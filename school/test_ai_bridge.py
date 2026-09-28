"""Regression checks for school's asynchronous AI and cancel path."""
from pathlib import Path
import tempfile
import threading
import time
import unittest
from unittest.mock import patch

import desktop


class SchoolAI(unittest.TestCase):
    def test_background_cancel_and_attachments(self):
        with tempfile.TemporaryDirectory() as folder:
            bridge = desktop.Bridge(folder)
            started, release = threading.Event(), threading.Event()
            store = desktop.Store(bridge.root)
            store.save_key('fake-test-only')
            store.db.close()
            attachment = Path(folder) / 'sample.txt'
            attachment.write_text('AI-CHECK-7429: 128', encoding='utf-8')
            seen = []

            def answer(profile, key, messages, memory):
                seen.append(messages)
                started.set()
                release.wait(5)
                return 'Synthetic answer'

            with patch.object(desktop.shared, 'ask_ai', side_effect=answer):
                job = bridge.dispatch('chat_start', {'prompt': 'Read', 'files': [str(attachment)]})
                self.assertTrue(started.wait(5))
                self.assertEqual(bridge.dispatch('chat_poll', {'job': job['job']})['state'], 'running')
                bridge.dispatch('chat_cancel', {'job': job['job']})
                release.set()
                self.assertEqual(bridge.dispatch('chat_poll', {'job': job['job']})['state'], 'cancelled')
                self.assertIn('AI-CHECK-7429: 128', seen[0][-1]['content'])
                retry = bridge.dispatch('chat_start', {'id': job['session'], 'prompt': 'Retry', 'files': []})
                deadline = time.monotonic() + 5
                while bridge.dispatch('chat_poll', {'job': retry['job']})['state'] == 'running' and time.monotonic() < deadline:
                    time.sleep(.01)
                result = bridge.dispatch('chat_poll', {'job': retry['job']})
                self.assertEqual(result['state'], 'done', result)
                state = bridge.dispatch('state', {})
                conversation = next(c for c in state['chat'] if c['id'] == job['session'])
                self.assertEqual(len(conversation['messages']), 2)
                self.assertEqual(conversation['messages'][0]['content'], 'Retry')


if __name__ == '__main__':
    unittest.main(verbosity=2)
