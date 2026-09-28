"""Shared school workspace. Run on ONE server; clients use HTTP, never a DB share."""
import argparse
import base64
import hashlib
import hmac
import json
import logging
import os
from pathlib import Path
import secrets
import sqlite3
import sys
import time
from datetime import date
from contextlib import contextmanager
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ASSETS = Path(getattr(sys, '_MEIPASS', Path(__file__).parent))
ROLES = ('teacher', 'principal', 'specialist')

def password_hash(password, salt=None):
    if len(password) < 10:
        raise ValueError('Mật khẩu cần ít nhất 10 ký tự.')
    salt = salt or secrets.token_hex(16)
    return salt + ':' + hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(), 200000).hex()

def required(data, name):
    value = str(data.get(name, '')).strip()
    if not value:
        raise ValueError('Thiếu thông tin: ' + name)
    return value

class Workspace:
    def __init__(self, path):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with self.connect() as db:
            db.executescript('''
            PRAGMA journal_mode=WAL;
            CREATE TABLE IF NOT EXISTS users(id TEXT PRIMARY KEY, name TEXT, email TEXT UNIQUE, password TEXT, admin INTEGER DEFAULT 0);
            CREATE TABLE IF NOT EXISTS schools(id TEXT PRIMARY KEY, name TEXT, year TEXT);
            CREATE TABLE IF NOT EXISTS members(school TEXT REFERENCES schools(id), user TEXT REFERENCES users(id), role TEXT, PRIMARY KEY(school,user));
            CREATE TABLE IF NOT EXISTS sessions(token TEXT PRIMARY KEY,user TEXT REFERENCES users(id),expires REAL);
            CREATE TABLE IF NOT EXISTS records(id TEXT PRIMARY KEY,school TEXT REFERENCES schools(id),kind TEXT,title TEXT,body TEXT,owner TEXT REFERENCES users(id),created REAL);
            CREATE TABLE IF NOT EXISTS tasks(id TEXT PRIMARY KEY,school TEXT REFERENCES schools(id),title TEXT,body TEXT,assignee TEXT REFERENCES users(id),creator TEXT REFERENCES users(id),due TEXT,status TEXT,submission TEXT DEFAULT '',feedback TEXT DEFAULT '',version INTEGER DEFAULT 0);
            CREATE TABLE IF NOT EXISTS files(id TEXT PRIMARY KEY,school TEXT REFERENCES schools(id),task TEXT,name TEXT,content BLOB,owner TEXT REFERENCES users(id),created REAL);
            CREATE TABLE IF NOT EXISTS notifications(id TEXT PRIMARY KEY,school TEXT,user TEXT,text TEXT,seen INTEGER DEFAULT 0,created REAL);
            CREATE TABLE IF NOT EXISTS audit(id INTEGER PRIMARY KEY,school TEXT,user TEXT,action TEXT,object TEXT,created REAL);
            ''')

    @contextmanager
    def connect(self):
        db = sqlite3.connect(self.path, timeout=20)
        db.row_factory = sqlite3.Row
        db.execute('PRAGMA foreign_keys=ON')
        try:
            with db:
                yield db
        finally:
            db.close()

    def setup(self, name, email, password):
        with self.connect() as db:
            db.execute('BEGIN IMMEDIATE')
            if db.execute('SELECT 1 FROM users LIMIT 1').fetchone():
                raise ValueError('Máy chủ đã được khởi tạo.')
            db.execute('INSERT INTO users VALUES(?,?,?,?,1)', (secrets.token_hex(16), name, email.lower(), password_hash(password)))

    def login(self, data):
        with self.connect() as db:
            user = db.execute('SELECT * FROM users WHERE email=?', (required(data, 'email').lower(),)).fetchone()
            try:
                valid = user and hmac.compare_digest(user['password'], password_hash(str(data.get('password', '')), user['password'].split(':')[0]))
            except ValueError:
                valid = False
            if not valid:
                raise PermissionError('Email hoặc mật khẩu không đúng.')
            token = secrets.token_urlsafe(32)
            db.execute('DELETE FROM sessions WHERE expires<?', (time.time(),))
            db.execute('INSERT INTO sessions VALUES(?,?,?)', (hashlib.sha256(token.encode()).hexdigest(), user['id'], time.time()+43200))
            return token

    def user(self, db, token):
        row = db.execute('SELECT u.id,u.name,u.email,u.admin FROM users u JOIN sessions s ON s.user=u.id WHERE s.token=? AND s.expires>?', (hashlib.sha256(token.encode()).hexdigest(), time.time())).fetchone()
        if not row:
            raise PermissionError('Vui lòng đăng nhập lại.')
        return dict(row)

    def notify(self, db, school, users, text):
        for user in set(users):
            db.execute('INSERT INTO notifications VALUES(?,?,?,?,0,?)', (secrets.token_hex(16), school, user, text, time.time()))

    def dispatch(self, token, action, data):
        with self.connect() as db:
            db.execute('BEGIN IMMEDIATE')
            user = self.user(db, token)
            uid = user['id']
            if action == 'logout':
                db.execute('DELETE FROM sessions WHERE token=?', (hashlib.sha256(token.encode()).hexdigest(),))
                return True
            if action == 'home':
                schools = db.execute('SELECT * FROM schools' if user['admin'] else 'SELECT s.* FROM schools s JOIN members m ON m.school=s.id WHERE m.user=?', () if user['admin'] else (uid,))
                return {'user': user, 'schools': [dict(r) for r in schools]}
            if action == 'school_create':
                if not user['admin']:
                    raise PermissionError('Chỉ quản trị hệ thống được tạo trường.')
                sid = secrets.token_hex(16)
                db.execute('INSERT INTO schools VALUES(?,?,?)', (sid, required(data,'name'), required(data,'year')))
                return sid
            sid = required(data, 'school')
            school = db.execute('SELECT * FROM schools WHERE id=?', (sid,)).fetchone()
            membership = db.execute('SELECT role FROM members WHERE school=? AND user=?', (sid, uid)).fetchone()
            if not school or (not membership and not user['admin']):
                raise PermissionError('Bạn không có quyền truy cập trường này.')
            role = 'admin' if user['admin'] else membership['role']
            manager = role in ('admin', 'principal', 'specialist')
            if action == 'state':
                members = [dict(r) for r in db.execute('SELECT u.id,u.name,u.email,m.role FROM users u JOIN members m ON m.user=u.id WHERE m.school=?', (sid,))]
                tasks = [dict(r) for r in db.execute('SELECT * FROM tasks WHERE school=?'+('' if manager else ' AND assignee=?'), (sid,) if manager else (sid,uid))]
                files = [dict(r) for r in db.execute('SELECT id,task,name,owner,created FROM files WHERE school=? AND (task IS NULL OR task IN (SELECT id FROM tasks WHERE school=?'+('' if manager else ' AND assignee=?')+'))', (sid,sid) if manager else (sid,sid,uid))]
                return {'school':dict(school),'role':role,'members':members,'tasks':tasks,'files':files,
                        'records':[dict(r) for r in db.execute('SELECT * FROM records WHERE school=? ORDER BY created DESC',(sid,))],
                        'notifications':[dict(r) for r in db.execute('SELECT * FROM notifications WHERE school=? AND user=? ORDER BY created DESC LIMIT 100',(sid,uid))],
                        'audit':[dict(r) for r in db.execute('SELECT a.*,u.name FROM audit a JOIN users u ON u.id=a.user WHERE school=? ORDER BY a.id DESC LIMIT 100',(sid,))] if manager else []}
            obj = secrets.token_hex(16)
            if action == 'member_add':
                if role not in ('admin','principal'):
                    raise PermissionError('Chỉ hiệu trưởng hoặc quản trị được thêm thành viên.')
                new_role = required(data,'role')
                if new_role not in ROLES or (role == 'principal' and new_role != 'teacher'):
                    raise PermissionError('Vai trò này cần quản trị hệ thống cấp quyền.')
                email = required(data,'email').lower()
                existing = db.execute('SELECT id FROM users WHERE email=?',(email,)).fetchone()
                if existing:
                    obj = existing['id']
                else:
                    db.execute('INSERT INTO users VALUES(?,?,?,?,0)', (obj,required(data,'name'),email,password_hash(required(data,'password'))))
                db.execute('INSERT INTO members VALUES(?,?,?)',(sid,obj,new_role))
            elif action == 'record_add':
                kind = required(data,'kind')
                if kind not in ('class','plan','calendar','document'):
                    raise ValueError('Loại dữ liệu không hợp lệ.')
                if not manager and kind != 'document':
                    raise PermissionError('Bạn chỉ được chia sẻ tài liệu.')
                db.execute('INSERT INTO records VALUES(?,?,?,?,?,?,?)',(obj,sid,kind,required(data,'title'),required(data,'body'),uid,time.time()))
                self.notify(db,sid,[m[0] for m in db.execute('SELECT user FROM members WHERE school=? AND user<>?',(sid,uid))],'Nội dung mới: '+data['title'])
            elif action == 'task_create':
                if not manager:
                    raise PermissionError('Bạn không có quyền giao việc.')
                assignee = required(data,'assignee')
                if not db.execute('SELECT 1 FROM members WHERE school=? AND user=?',(sid,assignee)).fetchone():
                    raise ValueError('Người nhận không thuộc trường.')
                due = required(data,'due'); date.fromisoformat(due)
                db.execute('INSERT INTO tasks(id,school,title,body,assignee,creator,due,status) VALUES(?,?,?,?,?,?,?,?)',(obj,sid,required(data,'title'),str(data.get('body','')),assignee,uid,due,'assigned'))
                self.notify(db,sid,[assignee],'Việc mới: '+data['title'])
            elif action in ('submit','review'):
                obj = required(data,'id')
                task = db.execute('SELECT * FROM tasks WHERE id=? AND school=?',(obj,sid)).fetchone()
                if not task:
                    raise ValueError('Không tìm thấy công việc.')
                if data.get('version') != task['version']:
                    raise ValueError('Hồ sơ đã thay đổi. Hãy tải lại trước khi thao tác.')
                if action == 'submit':
                    if task['assignee'] != uid or task['status'] not in ('assigned','revision'):
                        raise PermissionError('Chỉ người được giao mới được nộp hồ sơ đang mở.')
                    db.execute("UPDATE tasks SET submission=?,status='submitted',version=version+1 WHERE id=?",(required(data,'body'),obj))
                    self.notify(db,sid,[task['creator']],'Đã nộp: '+task['title'])
                else:
                    if not manager or task['assignee'] == uid or task['status'] != 'submitted':
                        raise PermissionError('Không thể duyệt hồ sơ này (không được tự duyệt).')
                    status = required(data,'status')
                    if status not in ('approved','revision'):
                        raise ValueError('Trạng thái không hợp lệ.')
                    feedback = required(data,'feedback') if status == 'revision' else str(data.get('feedback',''))
                    db.execute('UPDATE tasks SET status=?,feedback=?,version=version+1 WHERE id=?',(status,feedback,obj))
                    self.notify(db,sid,[task['assignee']],('Đã duyệt: ' if status=='approved' else 'Yêu cầu sửa: ')+task['title'])
            elif action == 'upload':
                taskid = data.get('task') or None
                if taskid:
                    task = db.execute('SELECT * FROM tasks WHERE id=? AND school=?',(taskid,sid)).fetchone()
                    if not task or task['assignee'] != uid or task['status'] not in ('assigned','revision'):
                        raise PermissionError('Chỉ đính kèm vào hồ sơ được giao đang mở.')
                content = base64.b64decode(required(data,'content'), validate=True)
                if len(content)>5*1024*1024:
                    raise ValueError('Tệp tối đa 5 MB.')
                name = required(data,'name').replace('\\','/').split('/')[-1]
                db.execute('INSERT INTO files VALUES(?,?,?,?,?,?,?)',(obj,sid,taskid,name,content,uid,time.time()))
            elif action == 'download':
                row = db.execute('SELECT * FROM files WHERE id=? AND school=?',(required(data,'id'),sid)).fetchone()
                if not row:
                    raise ValueError('Không tìm thấy tệp.')
                if row['task'] and not manager and not db.execute('SELECT 1 FROM tasks WHERE id=? AND assignee=?',(row['task'],uid)).fetchone():
                    raise PermissionError('Không có quyền tải hồ sơ này.')
                return {'name':row['name'],'content':base64.b64encode(row['content']).decode()}
            elif action == 'seen':
                db.execute('UPDATE notifications SET seen=1 WHERE school=? AND user=?',(sid,uid))
            else:
                raise ValueError('Thao tác không hợp lệ.')
            db.execute('INSERT INTO audit(school,user,action,object,created) VALUES(?,?,?,?,?)',(sid,uid,action,obj,time.time()))
            return obj

def make_server(workspace, host, port):
    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *args):
            pass
        def respond(self, code, value, content_type='application/json; charset=utf-8'):
            body = json.dumps(value,ensure_ascii=False).encode() if isinstance(value,(dict,list)) else value
            self.send_response(code)
            self.send_header('Content-Type',content_type)
            self.send_header('Content-Length',str(len(body)))
            self.send_header('Cache-Control','no-store')
            self.send_header('X-Content-Type-Options','nosniff')
            self.send_header('X-Frame-Options','DENY')
            self.end_headers(); self.wfile.write(body)
        def do_GET(self):
            if self.path.split('?')[0] != '/':
                self.respond(404,{'error':'Không tìm thấy'}); return
            self.respond(200,(ASSETS/'workspace.html').read_bytes(),'text/html; charset=utf-8')
        def do_POST(self):
            try:
                length = int(self.headers.get('Content-Length','0'))
                if not 0 < length <= 8*1024*1024:
                    self.respond(413,{'error':'Yêu cầu quá lớn hoặc rỗng.'}); return
                data = json.loads(self.rfile.read(length))
                if not isinstance(data,dict):
                    raise ValueError('Dữ liệu không hợp lệ.')
                action = self.path.removeprefix('/api/')
                if action == 'login':
                    # Per-address throttling, including failed attempts.
                    with self.server.rate_lock:
                        now=time.time(); key=self.client_address[0]
                        self.server.attempts={k:v for k,v in self.server.attempts.items() if v[1]>now-60}
                        count,started=self.server.attempts.get(key,(0,now))
                        if count>=15:
                            self.respond(429,{'error':'Thử đăng nhập quá nhiều. Chờ một phút.'}); return
                        self.server.attempts[key]=(count+1,started)
                    result={'token':workspace.login(data)}
                else:
                    result=workspace.dispatch(self.headers.get('Authorization','').removeprefix('Bearer '),action,data)
                self.respond(200,{'data':result})
            except PermissionError as exc:
                self.respond(403,{'error':str(exc)})
            except (ValueError,KeyError,sqlite3.IntegrityError) as exc:
                self.respond(400,{'error':'Thành viên đã có trong trường hoặc dữ liệu không hợp lệ.' if isinstance(exc,sqlite3.IntegrityError) else str(exc)})
            except Exception:
                logging.exception('Workspace request failed')
                self.respond(500,{'error':'Máy chủ gặp lỗi. Vui lòng thử lại.'})
    import threading
    server=ThreadingHTTPServer((host,port),Handler)
    server.attempts={}; server.rate_lock=threading.Lock()
    return server

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--host',default=os.environ.get('SCHOOL_HOST','127.0.0.1'))
    parser.add_argument('--port',type=int,default=os.environ.get('SCHOOL_PORT','8765'))
    parser.add_argument('--data',default=os.environ.get('SCHOOL_DATA',str(Path(os.environ.get('LOCALAPPDATA',Path.home()))/'TroLyTruongHocChung'/'workspace.db')))
    parser.add_argument('--init-admin',action='store_true',help='Create the first administrator interactively, then exit.')
    args=parser.parse_args()
    logging.basicConfig(level=logging.INFO,format='%(asctime)s %(levelname)s %(message)s')
    workspace=Workspace(args.data)
    with workspace.connect() as db:
        empty=not db.execute('SELECT 1 FROM users LIMIT 1').fetchone()
    if args.init_admin and not empty:
        parser.error('Database already initialized; no accounts were changed.')
    if empty:
        if not sys.stdin.isatty():
            parser.error('Initialize first in a terminal: python server.py --data PATH --init-admin')
        import getpass
        print('Tao tai khoan quan tri he thong (lan dau).')
        name=input('Ho ten: ').strip(); email=input('Email: ').strip()
        password=getpass.getpass('Mat khau (it nhat 10 ky tu): ')
        if not name or not email or password!=getpass.getpass('Nhap lai mat khau: '):
            raise ValueError('Thong tin thieu hoac mat khau khong khop.')
        workspace.setup(name,email,password)
    if args.init_admin:
        print('Administrator created. Start the server without --init-admin.')
        return
    server=make_server(workspace,args.host,args.port)
    logging.info('Listening on %s:%s',args.host,args.port)
    logging.info('Database: %s',workspace.path.resolve())
    try: server.serve_forever()
    except KeyboardInterrupt: pass
    finally: server.server_close()

if __name__=='__main__': main()
