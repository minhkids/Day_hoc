"""Exercise the WPF screens with an isolated database and retain their renders."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
sys.path.insert(0,'E:\\git_hub\\Day_hoc\\specialist')
from core import Store

class Handler(BaseHTTPRequestHandler):
    calls = []
    def log_message(self, *args): pass
    def do_POST(self):
        data = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
        self.calls.append(data)
        result = json.dumps({'choices': [{'message': {'content': 'BÁO CÁO KIỂM THỬ\nGiao diện WPF gửi và nhận tiếng Việt thành công.'}}]}).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(result)))
        self.end_headers()
        self.wfile.write(result)

root = Path('E:\\git_hub\\Day_hoc\\reports\\exe-audit\\specialist')
with tempfile.TemporaryDirectory(prefix='troly-wpf-') as folder:
    server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    store = Store(folder)
    store.save_profile({'provider': 'API tương thích', 'model': 'wpf-test-model', 'endpoint': f'http://127.0.0.1:{server.server_port}/v1'})
    store.db.close()
    env = os.environ.copy()
    env['TROLY_DATA_DIR'] = folder
    command = ['E:\\git_hub\\Day_hoc\\exe\\TroLyChuyenVien-DocLap\\TroLyChuyenVien-DocLap.exe', '--smoke', '--screenshot-dir', str(root / 'screenshots')]
    result = subprocess.run(command, env=env, capture_output=True, timeout=60)
    if result.returncode:
        print(result.stdout.decode('utf-8', errors='replace'))
        print(result.stderr.decode('utf-8', errors='replace'))
    report_path = Path(folder) / 'wpf-smoke.json'
    if not report_path.exists():
        raise RuntimeError(f'WPF did not finish its smoke test (exit {result.returncode})')
    report = json.loads(report_path.read_text(encoding='utf-8-sig'))
    (root / 'screenshots' / 'smoke-result.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    if report['errors']:
        print('\n'.join(report['errors']))
        raise RuntimeError('WPF dispatcher errors detected')
    assert result.returncode == 0
    assert report['templates'] == 41
    assert Handler.calls and 'CƠ QUAN KIỂM THỬ WPF' in Handler.calls[0]['messages'][0]['content']
    server.shutdown()
    server.server_close()
    print(f"PASS: {len(report['pages'])} WPF pages; task create/complete; settings persist; real button -> HTTP AI -> saved answer; 41 templates; no dispatcher errors.")
