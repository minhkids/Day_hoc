import json
import tempfile
import threading
import time
import unittest
from pathlib import Path
from unittest.mock import patch
import requests

from core import Store
from desktop import Bridge, create_server


class DesktopTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        old = Store(self.root)
        old.put('document', {'id': 'old-doc', 'title': 'Tài liệu từ bản cũ', 'body': 'Nội dung cần giữ', 'updated': '2026-09-20'})
        old.save_profile({'provider': 'API tương thích', 'endpoint': 'http://localhost:1234/v1', 'model': 'test-model'})
        old.db.close()
        self.bridge = Bridge(self.root)

    def tearDown(self):
        self.tmp.cleanup()

    def test_migrated_data_and_office_exports(self):
        state = self.bridge.dispatch('state', {})
        self.assertEqual(state['document'][0]['body'], 'Nội dung cần giữ')
        self.assertEqual(len(state['template']), 41)
        for kind in ('docx', 'pptx', 'xlsx', 'md'):
            result = self.bridge.dispatch('export', {'title': 'Kiểm thử', 'body': 'Nội dung tiếng Việt', 'format': kind})
            self.assertTrue(Path(result['path']).is_file())
        Bridge(self.root)
        self.assertEqual(len(self.bridge.dispatch('state', {})['template']), 41)

    def test_loopback_token_required(self):
        server = create_server(self.bridge, 'test-only-token')
        threading.Thread(target=server.serve_forever, daemon=True).start()
        try:
            url = f'http://127.0.0.1:{server.server_port}/state'
            self.assertEqual(requests.post(url, json={}, timeout=5).status_code, 403)
            result = requests.post(url, json={}, headers={'X-TroLy-Token': 'test-only-token'}, timeout=5).json()
            self.assertTrue(result['ok'])
            self.assertNotIn('key', result['data']['profile'])
        finally:
            server.shutdown()
            server.server_close()

    def test_async_multiturn_and_cancel(self):
        started, release = threading.Event(), threading.Event()
        def generate(*args):
            started.set()
            release.wait(timeout=5)
            return 'Báo cáo hoàn tất'
        with patch('desktop.ask_ai', side_effect=generate):
            first = self.bridge.dispatch('chat_start', {'prompt': 'Soạn báo cáo', 'files': []})
            self.assertTrue(started.wait(timeout=5))
            self.bridge.dispatch('chat_cancel', {'job': first['job']})
            release.set()
            time.sleep(.05)
            self.assertEqual(self.bridge.dispatch('chat_poll', {'job': first['job']})['state'], 'cancelled')
            self.assertEqual(self.bridge.dispatch('state', {})['chat'][0]['messages'], [])
        with patch('desktop.ask_ai', return_value='Báo cáo tiếng Việt'):
            job = self.bridge.dispatch('chat_start', {'id': first['session'], 'prompt': 'Thử lại', 'files': []})
            deadline = time.monotonic() + 5
            while self.bridge.dispatch('chat_poll', {'job': job['job']})['state'] == 'running' and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertEqual(self.bridge.dispatch('state', {})['chat'][0]['messages'][-1]['content'], 'Báo cáo tiếng Việt')

    def test_auth_login_flow(self):
        server = create_server(self.bridge, 'test-secret-token')
        threading.Thread(target=server.serve_forever, daemon=True).start()
        try:
            url = f'http://127.0.0.1:{server.server_port}/api/auth/login'
            # Wrong password should fail with 401
            resp = requests.post(url, json={'email': 'admin@giaoduc.gov.vn', 'password': 'wrong'}, timeout=5)
            self.assertEqual(resp.status_code, 401)
            self.assertFalse(resp.json()['ok'])

            # Correct credentials should succeed without X-TroLy-Token header
            resp = requests.post(url, json={'email': 'admin@giaoduc.gov.vn', 'password': 'admin123'}, timeout=5)
            self.assertEqual(resp.status_code, 200)
            data = resp.json()
            self.assertTrue(data['ok'])
            self.assertEqual(data['access_token'], 'test-secret-token')
            self.assertEqual(data['user']['email'], 'admin@giaoduc.gov.vn')
        finally:
            server.shutdown()
            server.server_close()


if __name__ == '__main__':
    unittest.main(verbosity=2)

