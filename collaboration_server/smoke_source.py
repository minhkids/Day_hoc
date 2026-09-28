"""Verify the source server with an isolated database."""
import json
from pathlib import Path
import socket
import subprocess
import sys
import tempfile
import time
from urllib.request import Request, urlopen
from server import Workspace

root=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory() as temp:
    db=Path(temp)/'test.db'; workspace=Workspace(db)
    workspace.setup('Test admin','admin@test','test-password-123')
    with socket.socket() as sock:
        sock.bind(('127.0.0.1',0)); port=sock.getsockname()[1]
    proc=subprocess.Popen([sys.executable,str(root/'collaboration_server/server.py'),'--data',str(db),'--port',str(port)],creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0),stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
    try:
        base=f'http://127.0.0.1:{port}'
        for attempt in range(30):
            try:
                with urlopen(base,timeout=1) as response:
                    assert 'Trường học chung' in response.read().decode()
                break
            except OSError:
                if proc.poll() is not None:raise RuntimeError('Server exited')
                time.sleep(.1)
        else:raise RuntimeError('Server did not start')
        def call(action,data,token=''):
            with urlopen(Request(base+'/api/'+action,data=json.dumps(data).encode(),headers={'Content-Type':'application/json','Authorization':'Bearer '+token}),timeout=5) as response:
                return json.load(response)['data']
        token=call('login',{'email':'admin@test','password':'test-password-123'})['token']
        school=call('school_create',{'name':'Test school','year':'2026-2027'},token)
        assert call('state',{'school':school},token)['role']=='admin'
        print('PASS: source server serves UI, authenticates, creates school and reads shared database.')
    finally:
        proc.terminate();proc.wait(timeout=10)
