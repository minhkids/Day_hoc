import tempfile
import time
from pathlib import Path
from unittest.mock import patch
import desktop

with tempfile.TemporaryDirectory() as data:
    bridge=desktop.Bridge(data)
    state=bridge.dispatch('state',{})
    assert len(state['template'])==32
    bridge.dispatch('settings',{'profile':{'provider':'OpenRouter','model':'test-only','subject':'Toán'}})
    with patch.object(desktop.Store,'key',return_value='test-only'),patch.object(desktop.shared,'ask_ai',return_value='Nội dung bài dạy'):
        job=bridge.dispatch('chat_start',{'prompt':'Soạn bài toán','files':[]})
        for _ in range(100):
            result=bridge.dispatch('chat_poll',{'job':job['job']})
            if result['state']!='running':break
            time.sleep(.02)
        assert result['state']=='done',result
    doc=bridge.dispatch('save',{'kind':'document','item':{'title':'Bài dạy','body':'Nội dung'}})
    state=bridge.dispatch('state',{})
    assert state['document'][0]['body']=='Nội dung'
    store=desktop.Store(data)
    raw=store.db.execute("SELECT payload FROM records WHERE kind='document'").fetchone()[0]
    assert 'body' not in raw
    assert not store.db.execute("SELECT 1 FROM records WHERE kind='chat'").fetchone()
    store.db.close()
    for fmt in ('docx','pptx','xlsx'):
        exported=bridge.dispatch('export',{'format':fmt,'title':'Bài dạy','body':'Nội dung'})
        assert Path(exported['path']).is_file()
    bridge.dispatch('project_create',{'kind':'flashcard'})
    assert len(bridge.dispatch('projects',{}))==1
    bridge.dispatch('backup',{'path':str(Path(data)/'backup.zip')})
    print('PASS: teacher WPF bridge, 32 templates, mocked AI jobs, file-backed documents, no chat in SQLite, Office, projects, backup.')
