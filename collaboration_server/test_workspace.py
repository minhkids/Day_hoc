import base64
import json
from pathlib import Path
import tempfile
import threading
import unittest
from urllib.request import Request, urlopen
from urllib.error import HTTPError
from server import Workspace, make_server

class WorkflowTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
        self.ws=Workspace(Path(self.tmp.name)/'workspace.db')
        self.ws.setup('Admin','admin@test','password1234')
        self.admin=self.ws.login({'email':'admin@test','password':'password1234'})
        self.school=self.call(self.admin,'school_create',name='Trường A',year='2026–2027')
        self.other=self.call(self.admin,'school_create',name='Trường B',year='2026–2027')
        self.principal=self.member('principal','ht@test')
        self.teacher=self.member('teacher','gv@test')
        self.specialist=self.member('specialist','cv@test')
        self.uid=self.call(self.teacher,'home')['user']['id']
    def call(self,token,action,**data):
        return self.ws.dispatch(token,action,{'school':getattr(self,'school',''),**data})
    def member(self,role,email):
        self.call(self.admin,'member_add',name=role,email=email,password='password1234',role=role)
        return self.ws.login({'email':email,'password':'password1234'})
    def task(self):
        return self.call(self.principal,'task_create',title='Kế hoạch',body='Tuần 1',assignee=self.uid,due='2026-10-01')
    def test_complete_workflow_and_concurrency(self):
        tid=self.task()
        fid=self.call(self.teacher,'upload',task=tid,name='ke-hoach.txt',content=base64.b64encode(b'report').decode())
        self.call(self.teacher,'submit',id=tid,version=0,body='Kế hoạch tuần')
        with self.assertRaises(ValueError): self.call(self.principal,'review',id=tid,version=0,status='approved')
        self.call(self.principal,'review',id=tid,version=1,status='revision',feedback='Bổ sung lịch')
        self.call(self.teacher,'submit',id=tid,version=2,body='Đã bổ sung')
        self.call(self.principal,'review',id=tid,version=3,status='approved',feedback='Đạt')
        state=self.call(self.teacher,'state')
        self.assertEqual(state['tasks'][0]['status'],'approved')
        self.assertEqual(base64.b64decode(self.call(self.principal,'download',id=fid)['content']),b'report')
        self.assertEqual(len(state['notifications']),3)
        with self.assertRaises(PermissionError): self.call(self.teacher,'upload',task=tid,name='x',content='YQ==')
        self.call(self.teacher,'seen'); self.assertTrue(all(n['seen'] for n in self.call(self.teacher,'state')['notifications']))
    def test_permissions_and_isolation(self):
        tid=self.task()
        with self.assertRaises(PermissionError): self.call(self.teacher,'state',school=self.other)
        with self.assertRaises(PermissionError): self.call(self.specialist,'state',school=self.other)
        with self.assertRaises(PermissionError): self.call(self.teacher,'task_create',title='x')
        with self.assertRaises(PermissionError): self.call(self.teacher,'member_add',role='principal')
        with self.assertRaises(PermissionError): self.call(self.principal,'member_add',role='specialist')
        other_teacher=self.member('teacher','other@test')
        self.assertEqual(self.call(other_teacher,'state')['tasks'],[])
        fid=self.call(self.teacher,'upload',task=tid,name='private',content='YQ==')
        with self.assertRaises(PermissionError): self.call(other_teacher,'download',id=fid)
        with self.assertRaises(PermissionError): self.call(other_teacher,'submit',id=tid,version=0,body='x')
        self.call(self.admin,'member_add',school=self.other,role='specialist',email='cv@test')
        self.assertEqual(len(self.call(self.specialist,'home')['schools']),2)
    def test_no_self_review_and_rollback(self):
        pid=self.call(self.principal,'home')['user']['id']
        tid=self.call(self.principal,'task_create',title='Own',assignee=pid,due='2026-10-01')
        self.call(self.principal,'submit',id=tid,version=0,body='x')
        with self.assertRaises(PermissionError): self.call(self.principal,'review',id=tid,version=1,status='approved')
        self.assertEqual(self.call(self.principal,'state')['tasks'][0]['status'],'submitted')
    def test_shared_records_sessions_and_persistence(self):
        self.call(self.principal,'record_add',kind='class',title='6A',body='GV phụ trách')
        self.call(self.teacher,'record_add',kind='document',title='Tài liệu',body='Nội dung')
        with self.assertRaises(PermissionError): self.call(self.teacher,'record_add',kind='plan',title='x',body='x')
        self.assertEqual(len(Workspace(self.ws.path).dispatch(self.teacher,'state',{'school':self.school})['records']),2)
        self.call(self.teacher,'logout')
        with self.assertRaises(PermissionError): self.call(self.teacher,'state')
        with self.assertRaises(ValueError): self.ws.setup('x','x','password1234')
    def test_http(self):
        server=make_server(self.ws,'127.0.0.1',0)
        threading.Thread(target=server.serve_forever,daemon=True).start()
        self.addCleanup(server.server_close); self.addCleanup(server.shutdown)
        base='http://127.0.0.1:'+str(server.server_port)
        with urlopen(base) as r:self.assertIn('Trường học chung',r.read().decode())
        req=Request(base+'/api/state',data=json.dumps({'school':self.school}).encode(),headers={'Authorization':'Bearer '+self.teacher,'Content-Type':'application/json'})
        with urlopen(req) as r:self.assertEqual(json.load(r)['data']['role'],'teacher')
        with self.assertRaises(HTTPError) as ctx:urlopen(Request(base+'/api/state',data=b'{}'))
        self.assertEqual(ctx.exception.code,403)

if __name__=='__main__':unittest.main()
