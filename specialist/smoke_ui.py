"""GUI smoke test using isolated data and a local mock AI server."""
import json
import tempfile
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from unittest.mock import patch

from main import App


class Handler(BaseHTTPRequestHandler):
    seen = []
    def log_message(self, *args):
        pass
    def do_POST(self):
        data = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
        self.seen.append(data)
        value = json.dumps({'choices': [{'message': {'content': 'BÁO CÁO THỬ\nĐã nhận nội dung và hồ sơ cơ quan.'}}]}, ensure_ascii=False).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(value)))
        self.end_headers()
        self.wfile.write(value)


with tempfile.TemporaryDirectory() as folder:
    server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    app = App(folder)
    errors = []
    app.report_callback_exception = lambda *args: errors.append(str(args[1]))
    app.withdraw()
    app.profile = app.store.save_profile({'agency': 'ĐƠN VỊ KIỂM THỬ', 'provider': 'API tương thích',
        'endpoint': f'http://127.0.0.1:{server.server_port}/v1', 'model': 'test-model'})
    for page in [app.home, app.chat, app.compose, app.missions, app.incoming, app.reports,
                 app.inspections, app.tasks, app.library, app.templates, app.memory,
                 app.utilities, app.settings, app.units, app.help]:
        page()
        app.update()
    app.start_work('Soạn báo cáo thử bằng tiếng Việt')
    app.send()
    deadline = time.monotonic() + 10
    while app.pending and time.monotonic() < deadline:
        app.update()
        time.sleep(.02)
    assert not app.pending, 'AI request did not finish'
    assert app.session['messages'][-1]['role'] == 'assistant'
    assert 'ĐƠN VỊ KIỂM THỬ' in Handler.seen[0]['messages'][0]['content']
    app.input.insert('1.0', 'Sửa phần kết luận')
    app.home()
    app.chat()
    assert app.input.get('1.0', 'end').strip() == 'Sửa phần kết luận', 'Draft lost on navigation'
    app.send()
    deadline = time.monotonic() + 10
    while app.pending and time.monotonic() < deadline:
        app.update()
        time.sleep(.02)
    assert len(Handler.seen[-1]['messages']) == 4, 'Conversation history missing'
    assert not errors, errors
    screenshot = Path(__file__).parent / 'giao-dien.png'
    app.home()
    app.deiconify()
    app.attributes('-topmost', True)
    app.lift()
    app.update()
    for _ in range(15):
        app.update()
        time.sleep(.05)
    from PIL import ImageGrab
    x, y = app.winfo_rootx(), app.winfo_rooty()
    ImageGrab.grab(bbox=(x, y, x + app.winfo_width(), y + app.winfo_height())).save(screenshot)
    app.settings()
    app.update()
    for _ in range(8):
        app.update()
        time.sleep(.05)
    ImageGrab.grab(bbox=(x, y, x + app.winfo_width(), y + app.winfo_height())).save(Path(__file__).parent / 'cai-dat.png')
    app.close()
    server.shutdown()
    server.server_close()
    print('PASS: 16 pages; real HTTP mock; Vietnamese; multi-turn history; navigation draft; GUI screenshot.')
