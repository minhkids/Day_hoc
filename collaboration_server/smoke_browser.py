"""Exercise source server and browser with isolated test data; no user data touched."""
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import tempfile
import time
from urllib.request import urlopen
import websocket
from server import Workspace

ROOT=Path(__file__).resolve().parents[1]
def port():
    with socket.socket() as s:
        s.bind(('127.0.0.1',0)); return s.getsockname()[1]

with tempfile.TemporaryDirectory() as temp:
    folder=Path(temp); db=folder/'test.db'; ws=Workspace(db)
    ws.setup('Admin','admin@test','password1234')
    auth=ws.login({'email':'admin@test','password':'password1234'})
    school=ws.dispatch(auth,'school_create',{'name':'Trường kiểm thử','year':'2026-2027'})
    uid=ws.dispatch(auth,'member_add',{'school':school,'name':'Giáo viên A','email':'teacher@test','password':'password1234','role':'teacher'})
    ws.dispatch(auth,'task_create',{'school':school,'title':'Kế hoạch tuần','body':'Nộp kế hoạch','assignee':uid,'due':'2026-10-01'})
    http_port,debug_port=port(),port()
    server=subprocess.Popen([sys.executable,str(ROOT/'collaboration_server/server.py'),'--data',str(db),'--port',str(http_port)],creationflags=subprocess.CREATE_NO_WINDOW,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
    browser=None; conn=None
    try:
        for _ in range(100):
            try:
                urlopen(f'http://127.0.0.1:{http_port}',timeout=1).close(); break
            except OSError: time.sleep(.1)
        browser_path=os.environ.get('TROLY_TEST_BROWSER', r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe')
        browser=subprocess.Popen([browser_path,'--headless=new','--disable-dev-shm-usage','--disable-gpu','--no-first-run','--remote-allow-origins=*',f'--remote-debugging-port={debug_port}',f'--user-data-dir={folder / "browser"}','about:blank'],creationflags=subprocess.CREATE_NO_WINDOW,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
        pages=None
        for _ in range(20):
            try:
                pages=json.load(urlopen(f'http://127.0.0.1:{debug_port}/json',timeout=1)); break
            except OSError:time.sleep(.1)
        if pages is None:raise RuntimeError('Browser debugging unavailable; set TROLY_TEST_BROWSER to a compatible Chromium executable.')
        conn=websocket.create_connection(next(p['webSocketDebuggerUrl'] for p in pages if p['type']=='page'),timeout=10)
        counter=0
        def command(method,params):
            global counter
            counter+=1; ident=counter
            conn.send(json.dumps({'id':ident,'method':method,'params':params}))
            while True:
                reply=json.loads(conn.recv())
                if reply.get('id')==ident:
                    if 'error' in reply:raise RuntimeError(reply)
                    return reply.get('result',{})
        def js(expression):
            result=command('Runtime.evaluate',{'expression':expression,'returnByValue':True,'awaitPromise':True})
            if 'exceptionDetails' in result:raise RuntimeError(result)
            return result.get('result',{}).get('value')
        def wait(expression):
            for _ in range(100):
                if js(expression):return
                time.sleep(.1)
            raise AssertionError('Timed out: '+expression+'; '+str(js('document.body.innerText')))
        command('Page.navigate',{'url':f'http://127.0.0.1:{http_port}'})
        wait("!!document.getElementById('login')")
        js("document.querySelector('[name=email]').value='teacher@test';document.querySelector('[name=password]').value='password1234';document.getElementById('login').requestSubmit()")
        wait("document.body.innerText.includes('Kế hoạch tuần')")
        js("document.querySelector('form[id^=submit-] textarea').value='Đã hoàn thành';document.querySelector('form[id^=submit-]').requestSubmit()")
        wait("document.body.innerText.includes('Chờ duyệt') && !document.querySelector('form[id^=submit-]')")
        js("document.getElementById('logout').click()")
        wait("!!document.getElementById('login')")
        js("document.querySelector('[name=email]').value='admin@test';document.querySelector('[name=password]').value='password1234';document.getElementById('login').requestSubmit()")
        wait("!!document.querySelector('form[id^=review-]')")
        js("document.querySelector('form[id^=review-] textarea').value='Đạt';document.querySelector('form[id^=review-]').requestSubmit()")
        wait("!document.querySelector('form[id^=review-]') && document.body.innerText.includes('Đạt')")
        for tab in ['records','members','notifications','audit']:
            js(f"document.querySelector('[data-tab={tab}]').click()")
            wait(f"document.querySelector('[data-tab={tab}]').classList.contains('active')")
        assert not js("document.getElementById('message').textContent")
        print('PASS: source server, browser login, teacher submission, admin approval, all shared tabs.')
        command('Browser.close',{})
    finally:
        if conn:conn.close()
        if browser:
            try:browser.wait(timeout=10)
            except subprocess.TimeoutExpired:browser.terminate();browser.wait(timeout=10)
        server.terminate();server.wait(timeout=10)
