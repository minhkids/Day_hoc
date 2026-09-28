"""WPF desktop host and private, loopback-only bridge to the existing data services."""
from __future__ import annotations
import hmac
import json
import os
from pathlib import Path
import secrets
import shutil
import subprocess
import sys
import threading
import uuid
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

if not getattr(sys, 'frozen', False):
    sys.path.insert(0, str(Path(__file__).resolve().parent))

from core import Store, ask_ai, read_document, export_word, export_slides, export_table, unique_path, _dotenv_values


try:
    import updater
except ImportError:
    try:
        from specialist import updater
    except ImportError:
        updater = None

APP_ID = "specialist"
APP_NAME = "Trợ lý Chuyên viên QLNN Giáo dục"
APP_VERSION = "1.0.7"

ROOT = Path(getattr(sys, '_MEIPASS', Path(__file__).resolve().parent))

KINDS = {'task', 'unit', 'cycle', 'submission', 'document', 'template', 'memory', 'incoming', 'chat'}


class Bridge:
    def __init__(self, data_root=None):
        store = Store(data_root)
        self.root = store.root
        folder = ROOT / 'reference-templates'
        if not folder.exists():
            folder = Path(__file__).parent.parent / 'app/templates/chuyen_vien'
        if not store.all('seed') and folder.exists():
            for path in sorted(folder.glob('*.md')):
                store.put('template', {'title': path.stem.replace('-', ' ').capitalize(), 'body': path.read_text(encoding='utf-8-sig'), 'type': 'Mẫu tham chiếu'})
            store.put('seed', {'id': 'seed-templates-v1'})
        store.db.close()
        self.jobs = {}
        self.lock = threading.RLock()

    def authenticate(self, email, password):
        store = Store(self.root)
        try:
            return store.authenticate_user(email, password)
        finally:
            store.db.close()

    def dispatch(self, action, data):
        store = Store(self.root)

        try:
            if action == 'state':
                profile = store.profile()
                return {'profile': profile, 'has_key': bool(store.key()), 'root': str(self.root),
                        **{kind: store.all(kind) for kind in KINDS}}
            if action == 'settings':
                if data.get('key') is not None:
                    store.save_key(data['key'])
                return store.save_profile(data['profile'])
            if action == 'save':
                kind = data['kind']
                if kind not in KINDS:
                    raise ValueError('Loại dữ liệu không hợp lệ.')
                value = data['item']
                if kind == 'task' and value.get('due'):
                    datetime.strptime(value['due'], '%Y-%m-%d')
                if kind == 'document':
                    value['updated'] = datetime.now().isoformat(timespec='seconds')
                return store.put(kind, value)
            if action == 'delete':
                store.delete(data['id'])
                return True
            if action == 'read':
                return {'text': read_document(data['path'])}
            if action == 'import':
                source = Path(data['path'])
                folder = {'incoming': 'van-ban-den', 'submission': 'bao-cao'}[data['kind']]
                target = unique_path(self.root / folder, source.name)
                shutil.copy2(source, target)
                return store.put(data['kind'], data['item'] | {'path': str(target.relative_to(self.root))})
            if action == 'export':
                kind = data['format']
                path = Path(data['path']) if data.get('path') else unique_path(self.root / 'van-ban-da-soan', data.get('title', 'Tai lieu') + '.' + kind)
                if kind == 'docx':
                    export_word(path, data['title'], data['body'], store.profile())
                elif kind == 'pptx':
                    export_slides(path, data['title'], data['body'])
                elif kind == 'xlsx':
                    rows = data.get('rows') or [[line] for line in data.get('body', '').splitlines()]
                    export_table(path, rows, data.get('headers') or ['Nội dung'])
                elif kind == 'md':
                    path.write_text(data['body'], encoding='utf-8')
                else:
                    raise ValueError('Định dạng không được hỗ trợ.')
                return {'path': str(path)}
            if action == 'backup':
                store.backup(data['path'])
                return {'path': data['path']}
            if action == 'pdf':
                from PyPDF2 import PdfReader, PdfWriter
                writer = PdfWriter()
                target = Path(data['target']).resolve()
                sources = [Path(s).resolve() for s in data['sources']]
                if target in sources:
                    raise ValueError('Chọn tệp đích khác tệp gốc.')
                if data['mode'] != 'Ghép PDF' and len(sources) != 1:
                    raise ValueError('Chọn một tệp để tách hoặc xoay.')
                for source in sources:
                    reader = PdfReader(source)
                    begin, end = 1, len(reader.pages)
                    if data['mode'] == 'Tách trang' and data.get('pages'):
                        parts = data['pages'].split('-')
                        if len(parts) not in (1, 2):
                            raise ValueError('Khoảng trang phải có dạng 2-5 hoặc 3.')
                        begin, end = int(parts[0]), int(parts[-1])
                    if begin < 1 or end > len(reader.pages) or begin > end:
                        raise ValueError('Khoảng trang không hợp lệ.')
                    for index in range(begin - 1, end):
                        page = reader.pages[index]
                        if data['mode'] == 'Xoay trang':
                            page.rotate(int(data.get('angle', 90)))
                        writer.add_page(page)
                with target.open('wb') as output:
                    writer.write(output)
                return {'path': str(target)}
            if action == 'chat_start':
                profile, key = store.profile(), store.key()
                if not profile.get('model'):
                    raise ValueError('Vào Cài đặt để nhập API key và mã mô hình OpenRouter trước.')
                if profile.get('provider') != 'API tương thích' and not key:
                    raise ValueError('Chưa nhập API key. Bạn có thể nhập khóa trong Cài đặt.')
                sid = data.get('id')
                conversation = next((c for c in store.all('chat') if c['id'] == sid), None)
                if not conversation:
                    conversation = store.put('chat', {'title': data['prompt'][:65], 'created': datetime.now().isoformat(timespec='seconds'), 'messages': []})
                with self.lock:
                    if any(j['session'] == conversation['id'] and j['state'] == 'running' for j in self.jobs.values()):
                        raise ValueError('Việc này đang chạy. Hãy chờ câu trả lời hoặc tạo việc mới.')
                    if sum(j['state'] == 'running' for j in self.jobs.values()) >= 3:
                        raise ValueError('Đang chạy 3 việc. Hãy chờ một việc hoàn tất.')
                    job_id = uuid.uuid4().hex
                    self.jobs[job_id] = {'state': 'running', 'session': conversation['id']}
                memory = '\n\n'.join(m['title'] + ':\n' + m['body'] for m in store.all('memory'))
                threading.Thread(target=self.generate, args=(job_id, conversation, profile, key, memory, data), daemon=True).start()
                return {'job': job_id, 'session': conversation['id']}
            if action == 'chat_poll':
                with self.lock:
                    return dict(self.jobs.get(data['job'], {'state': 'missing'}))
            if action == 'chat_cancel':
                with self.lock:
                    job = self.jobs.get(data['job'])
                    if job and job['state'] == 'running':
                        job['state'] = 'cancelled'
                return True
            if action == 'check_update':
                if updater:
                    return updater.check_for_updates(
                        APP_ID, APP_VERSION,
                        interactive=data.get('interactive', True),
                        app_title=APP_NAME
                    )
                return {'status': 'error', 'error': 'Chưa kích hoạt module cập nhật.'}
            raise ValueError('Thao tác không tồn tại.')
        finally:
            store.db.close()

    def generate(self, job, conversation, profile, key, memory, data):
        try:
            content = data['prompt']
            files = data.get('files') or []
            for file in files:
                content += '\n\n<TAI_LIEU ten=' + json.dumps(Path(file).name, ensure_ascii=False) + '>\n' + read_document(file) + '\n</TAI_LIEU>'
            messages = [{'role': m['role'], 'content': m['content']} for m in conversation['messages']]
            answer = ask_ai(profile, key, messages + [{'role': 'user', 'content': content}], memory)
            with self.lock:
                if self.jobs[job]['state'] != 'running':
                    return
                store = Store(self.root)
                try:
                    display = data['prompt'] + ('\nĐính kèm: ' + ', '.join(Path(f).name for f in files) if files else '')
                    conversation['messages'] += [{'role': 'user', 'content': content, 'display': display}, {'role': 'assistant', 'content': answer}]
                    store.put('chat', conversation)
                finally:
                    store.db.close()
                self.jobs[job].update(state='done', answer=answer)
        except Exception as exc:
            with self.lock:
                if self.jobs[job]['state'] == 'running':
                    self.jobs[job].update(state='error', error=str(exc))


def create_server(bridge, token):
    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *args):
            pass
        def do_POST(self):
            path = self.path.rstrip('/')
            length = int(self.headers.get('Content-Length', '0'))
            if length > 8 * 1024 * 1024:
                self.send_error(413)
                return
            body = self.rfile.read(length) if length > 0 else b'{}'

            # Allow authentication endpoint without requiring bridge token
            if path in ('/api/auth/login', '/auth/login'):
                try:
                    data = json.loads(body.decode('utf-8'))
                    email = data.get('email') or data.get('username') or ''
                    password = data.get('password') or ''
                    auth_res = bridge.authenticate(email, password)
                    if auth_res.get('ok'):
                        result = {
                            'ok': True,
                            'access_token': token,
                            'token': token,
                            'user': {
                                'email': auth_res.get('email'),
                                'name': auth_res.get('name'),
                                'role': auth_res.get('role', 'Chuyên viên')
                            }
                        }
                        status_code = 200
                    else:
                        result = {'ok': False, 'error': auth_res.get('error', 'Đăng nhập không thành công.')}
                        status_code = 401
                except Exception as exc:
                    result = {'ok': False, 'error': str(exc)}
                    status_code = 400
                encoded = json.dumps(result, ensure_ascii=False).encode('utf-8')
                self.send_response(status_code)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            if not hmac.compare_digest(self.headers.get('X-TroLy-Token', ''), token):
                self.send_error(403)
                return
            try:
                data = json.loads(body.decode('utf-8'))
                result = {'ok': True, 'data': bridge.dispatch(self.path.strip('/'), data)}
            except Exception as exc:
                result = {'ok': False, 'error': str(exc)}
            encoded = json.dumps(result, ensure_ascii=False).encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Content-Length', str(len(encoded)))
            self.end_headers()
            self.wfile.write(encoded)
    return ThreadingHTTPServer(('127.0.0.1', 0), Handler)


def launch():
    if '--verify-ai' in sys.argv and '--smoke' not in sys.argv:
        sys.argv.append('--smoke')
    bridge = Bridge()
    token = secrets.token_urlsafe(32)
    server = create_server(bridge, token)
    threading.Thread(target=server.serve_forever, daemon=True).start()

    # Tự động kiểm tra cập nhật từ xa trong luồng phụ khi khởi động
    if updater and '--smoke' not in sys.argv and '--screenshot-dir' not in sys.argv:
        updater.start_background_check(APP_ID, APP_VERSION, APP_NAME, delay_seconds=3.0)

    env = os.environ.copy()
    # The backend URL may be supplied by the local .env, but secrets are never
    # copied into the EXE or sent to the WPF process.
    dotenv = _dotenv_values()
    if not env.get('TROLY_AUTH_URL'):
        env['TROLY_AUTH_URL'] = dotenv.get('AUTH_URL', dotenv.get('BACKEND_URL', ''))
        if not env['TROLY_AUTH_URL']:
            env['TROLY_AUTH_URL'] = f'http://127.0.0.1:{server.server_port}'

    env['TROLY_BRIDGE_URL'] = f'http://127.0.0.1:{server.server_port}'
    env['TROLY_BRIDGE_TOKEN'] = token
    shell = Path(os.environ.get('WINDIR', 'C:/Windows')) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
    arguments = [str(shell), '-NoProfile', '-STA', '-ExecutionPolicy', 'RemoteSigned', '-WindowStyle', 'Hidden', '-File', str(ROOT / 'wpf/host.ps1')]
    if '--screenshot-dir' in sys.argv:
        directory = sys.argv[sys.argv.index('--screenshot-dir') + 1]
        arguments += ['-ScreenshotDir', str(Path(directory).resolve())]
    if '--smoke' in sys.argv:
        arguments += ['-Smoke']
    if '--verify-ai' in sys.argv:
        arguments += ['-VerifyAI']
    try:
        return subprocess.call(arguments, env=env, creationflags=subprocess.CREATE_NO_WINDOW)
    finally:
        server.shutdown()
        server.server_close()


if __name__ == '__main__':
    sys.exit(launch())
