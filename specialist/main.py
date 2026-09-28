"""Vietnamese desktop application. Run with Python or package with build.py."""
from __future__ import annotations

import json
import os
from pathlib import Path
import queue
import shutil
import sys
import threading
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, simpledialog
from tkinter.scrolledtext import ScrolledText
from datetime import datetime, date
import webbrowser

from core import (APP_NAME, Store, read_document, ask_ai, unique_path,
                  export_word, export_slides, export_table)

BG, NAVY, BLUE, MUTED = '#F3F6FB', '#142C50', '#2865CF', '#62748A'
DOC_TYPES = ['Công văn', 'Quyết định', 'Kế hoạch', 'Báo cáo', 'Hướng dẫn', 'Thông báo',
             'Tờ trình', 'Phiếu trình', 'Giấy mời', 'Giấy triệu tập', 'Biên bản', 'Lịch công tác tuần']
MISSIONS = ['Hướng dẫn nhiệm vụ năm học', 'Chương trình, kế hoạch giáo dục', 'Tập huấn, bồi dưỡng',
            'Hội thi, giao lưu', 'Đội ngũ, chuẩn nghề nghiệp', 'Chuyển đổi số, dữ liệu ngành',
            'Tham mưu UBND', 'Phiếu trình, trình ký', 'Góp ý dự thảo', 'Tuyển sinh',
            'Mạng lưới trường, lớp', 'Sơ kết, tổng kết', 'Thống kê, số liệu', 'Phát biểu, kết luận',
            'Thẩm định trước khi trình', 'Chuyển năm học mới']
INSPECTIONS = ['Kế hoạch kiểm tra', 'Quyết định thành lập đoàn', 'Đề cương kiểm tra',
               'Biên bản kiểm tra', 'Báo cáo kết quả kiểm tra', 'Thông báo kết luận',
               'Thẩm định hồ sơ trường chuẩn', 'Bảo đảm chất lượng giáo dục',
               'Phổ cập giáo dục, xóa mù chữ', 'Theo dõi khắc phục sau kiểm tra']
MEMORIES = ['Thông tin cơ quan', 'Nhân sự', 'Đơn vị phụ trách', 'Số liệu', 'Lịch năm học',
            'Căn cứ và nguồn tham khảo', 'Quy ước soạn thảo', 'Ghi nhớ khác']
ATTACH_TYPES = [('Tài liệu', '*.docx *.pdf *.xlsx *.csv *.txt *.md *.json')]


class App(tk.Tk):
    def __init__(self, root=None):
        super().__init__()
        self.store = Store(root)
        self.seed_templates()
        self.profile = self.store.profile()
        self.title(APP_NAME + ' • Bản độc lập 1.0')
        self.geometry('1280x830')
        self.minsize(1050, 720)
        self.configure(bg=BG)
        self.session = None
        self.attachments = []
        self.results = queue.Queue()
        self.pending = None
        self.fullscreen = False
        self.text_size = 11
        self.page = ''
        self.chat_draft = ''
        self.page_leave = None
        self.style = ttk.Style(self)
        self.style.theme_use('clam')
        self.style.configure('.', font=('Segoe UI', 10), background=BG, foreground=NAVY)
        self.style.configure('TButton', padding=(12, 7), background='#EAF0FA', borderwidth=0)
        self.style.map('TButton', background=[('active', '#DAE6FC')])
        self.style.configure('Primary.TButton', background=BLUE, foreground='white')
        self.style.map('Primary.TButton', background=[('active', '#17499D')])
        self.style.configure('Treeview', rowheight=32, background='white', fieldbackground='white', borderwidth=0)
        self.style.configure('Treeview.Heading', background='#E7EEF9', font=('Segoe UI', 10, 'bold'), padding=8)
        self.sidebar = tk.Frame(self, bg=NAVY, width=225)
        self.sidebar.pack(side='left', fill='y')
        self.sidebar.pack_propagate(False)
        tk.Label(self.sidebar, text='TRỢ LÝ CHUYÊN VIÊN', font=('Segoe UI', 13, 'bold'), bg=NAVY, fg='white').pack(pady=(28, 5))
        tk.Label(self.sidebar, text='QUẢN LÝ GIÁO DỤC', font=('Segoe UI', 9), bg=NAVY, fg='#A7BDE0').pack(pady=(0, 24))
        self.nav = {}
        items = [('Trang chủ', self.home), ('Trò chuyện AI', self.chat), ('Soạn văn bản', self.compose),
                 ('Nhiệm vụ chuyên viên', self.missions), ('Xử lý văn bản đến', self.incoming),
                 ('Đơn vị, báo cáo', self.reports), ('Kiểm tra, đánh giá', self.inspections),
                 ('Quản lý công việc', self.tasks), ('Văn bản đã soạn', self.library),
                 ('Mẫu & quy trình riêng', self.templates), ('Bộ nhớ cơ quan', self.memory),
                 ('Tra cứu & tiện ích', self.utilities), ('Cài đặt', self.settings)]
        for title, action in items:
            b = tk.Button(self.sidebar, text=title, anchor='w', relief='flat', bd=0, padx=18, pady=9,
                          bg=NAVY, fg='#DEE8FA', activebackground='#244676', activeforeground='white',
                          font=('Segoe UI', 10), cursor='hand2', command=action)
            b.pack(fill='x', padx=8, pady=1)
            self.nav[title] = b
        tk.Label(self.sidebar, text='Bản độc lập 1.0\nDữ liệu lưu trên máy của bạn', bg=NAVY, fg='#A7BDE0', font=('Segoe UI', 9)).pack(side='bottom', pady=18)
        self.body = tk.Frame(self, bg=BG)
        self.body.pack(side='left', fill='both', expand=True)
        self.status = tk.StringVar(value='Sẵn sàng • Chưa có tác vụ AI đang chạy')
        tk.Label(self.body, textvariable=self.status, bg='#E8EEF7', fg=MUTED, anchor='w', padx=24, pady=9).pack(side='bottom', fill='x')
        self.content = tk.Frame(self.body, bg=BG, padx=26, pady=22)
        self.content.pack(fill='both', expand=True)
        self.bind('<F11>', lambda e: self.toggle_fullscreen())
        self.bind('<Escape>', lambda e: self.attributes('-fullscreen', False))
        self.protocol('WM_DELETE_WINDOW', self.close)
        self.after(100, self.poll)
        self.home()

    def seed_templates(self):
        # Import the user-provided template assets once; edits survive new EXE versions.
        if self.store.all('seed'):
            return
        folder = Path(getattr(sys, '_MEIPASS', Path(__file__).resolve().parent)) / 'reference-templates'
        if not folder.exists():
            folder = Path(__file__).resolve().parent.parent / 'app' / 'templates' / 'chuyen_vien'
        for path in sorted(folder.glob('*.md')):
            self.store.put('template', {'title': path.stem.replace('-', ' ').capitalize(),
                           'body': path.read_text(encoding='utf-8-sig'), 'type': 'Mẫu từ thư mục tham chiếu'})
        if folder.exists():
            self.store.put('seed', {'id': 'seed-templates-v1'})

    def report_callback_exception(self, kind, value, traceback):
        messagebox.showerror('Không thể thực hiện', str(value), parent=self)

    def close(self):
        if self.pending and not messagebox.askyesno('Đang xử lý', 'AI đang trả lời. Đóng ứng dụng sẽ không lưu câu trả lời đang chờ. Vẫn đóng?', parent=self):
            return
        if self.page_leave:
            self.page_leave()
        self.store.db.close()
        self.destroy()

    def toggle_fullscreen(self):
        self.fullscreen = not bool(self.attributes('-fullscreen'))
        self.attributes('-fullscreen', self.fullscreen)

    def begin(self, title, subtitle=''):
        if self.page == 'Trò chuyện AI' and hasattr(self, 'input') and self.input.winfo_exists():
            self.chat_draft = self.input.get('1.0', 'end').strip()
        if self.page_leave:
            callback, self.page_leave = self.page_leave, None
            callback()
        self.page = title
        for w in self.content.winfo_children():
            w.destroy()
        for label, b in self.nav.items():
            b.configure(bg='#294C7D' if label == title else NAVY)
        tk.Label(self.content, text=title, bg=BG, fg=NAVY, font=('Segoe UI', 23, 'bold')).pack(anchor='w')
        if subtitle:
            tk.Label(self.content, text=subtitle, bg=BG, fg=MUTED, justify='left', wraplength=940,
                     font=('Segoe UI', 10)).pack(anchor='w', pady=(5, 18))

    def bar(self, parent=None):
        f = tk.Frame(parent or self.content, bg=BG)
        f.pack(fill='x', pady=7)
        return f

    def button(self, parent, title, action, primary=False):
        b = ttk.Button(parent, text=title, command=action, style='Primary.TButton' if primary else 'TButton')
        b.pack(side='left', padx=(0, 7), pady=2)
        return b

    def editor(self, parent=None, height=12):
        t = ScrolledText(parent or self.content, wrap='word', font=('Segoe UI', self.text_size), height=height,
                         relief='flat', padx=16, pady=14, bg='white', fg=NAVY, undo=True)
        t.pack(fill='both', expand=True, pady=6)
        return t

    def table(self, columns, parent=None):
        frame = tk.Frame(parent or self.content, bg=BG)
        frame.pack(fill='both', expand=True, pady=8)
        tree = ttk.Treeview(frame, columns=columns, show='headings', selectmode='browse')
        for c in columns:
            tree.heading(c, text=c)
            tree.column(c, width=145, minwidth=70)
        scroll = ttk.Scrollbar(frame, orient='vertical', command=tree.yview)
        tree.configure(yscrollcommand=scroll.set)
        tree.pack(side='left', fill='both', expand=True)
        scroll.pack(side='right', fill='y')
        return tree

    def selected(self, tree, records):
        selection = tree.selection()
        if not selection:
            messagebox.showinfo('Chọn dữ liệu', 'Hãy chọn một dòng trước.', parent=self)
            return None
        return next((r for r in records if r['id'] == selection[0]), None)

    def dialog(self, title, fields, initial=None):
        win = tk.Toplevel(self)
        win.title(title)
        win.geometry('610x' + str(min(700, 110 + len(fields) * 64)))
        win.transient(self)
        win.grab_set()
        win.configure(bg=BG)
        data, result = {}, []
        for key, label, options in fields:
            tk.Label(win, text=label, bg=BG, anchor='w').pack(fill='x', padx=20, pady=(8, 2))
            var = tk.StringVar(value=(initial or {}).get(key, options[0] if options else ''))
            widget = ttk.Combobox(win, textvariable=var, values=options, state='readonly') if options else ttk.Entry(win, textvariable=var)
            widget.pack(fill='x', padx=20)
            data[key] = var
        def save():
            result.append({k: v.get().strip() for k, v in data.items()})
            win.destroy()
        ttk.Button(win, text='Lưu', command=save, style='Primary.TButton').pack(pady=16)
        self.wait_window(win)
        return result[0] if result else None

    def cards(self, entries):
        frame = tk.Frame(self.content, bg=BG)
        frame.pack(fill='both', expand=True, pady=8)
        for i, (title, description, action) in enumerate(entries):
            r, c = divmod(i, 3)
            frame.columnconfigure(c, weight=1)
            card = tk.Frame(frame, bg='white', padx=16, pady=13, highlightthickness=1, highlightbackground='#DFE7F2')
            card.grid(row=r, column=c, sticky='nsew', padx=(0, 12), pady=(0, 12))
            tk.Label(card, text=title, bg='white', fg=NAVY, anchor='w', font=('Segoe UI', 11, 'bold'), wraplength=250).pack(fill='x')
            tk.Label(card, text=description, bg='white', fg=MUTED, justify='left', anchor='w', wraplength=235,
                     font=('Segoe UI', 9)).pack(fill='x', pady=8)
            ttk.Button(card, text='Mở  →', command=action).pack(anchor='w')

    def home(self):
        self.begin('Trang chủ', 'Không gian làm việc dành cho chuyên viên Sở GD&ĐT, Phòng Văn hóa – Xã hội và lãnh đạo UBND.')
        tk.Label(self.content, text='Xin chào' + (', ' + self.profile['name'] if self.profile['name'] else '') + '!',
                 bg=BG, fg=BLUE, font=('Segoe UI', 17, 'bold')).pack(anchor='w', pady=(0, 8))
        tasks = self.store.all('task')
        overdue = sum(1 for t in tasks if t.get('due') and t['due'] < date.today().isoformat() and t['state'] != 'Hoàn thành')
        line = f"{len([t for t in tasks if t['state'] != 'Hoàn thành'])} việc đang theo dõi     •     {overdue} việc quá hạn     •     {len(self.store.all('document'))} văn bản đã soạn"
        tk.Label(self.content, text=line, bg='#E5EEFD', fg=BLUE, padx=18, pady=14, anchor='w').pack(fill='x', pady=8)
        if not self.profile.get('endpoint') or not self.profile.get('model'):
            self.button(self.bar(), 'Thiết lập máy chủ AI trong Cài đặt', self.settings, True)
        self.cards([('Soạn văn bản', 'Công văn, kế hoạch, báo cáo, tờ trình và các văn bản khác.', self.compose),
                    ('Trò chuyện AI', 'Giao việc, đính kèm tài liệu, sửa tiếp trong cùng cuộc trò chuyện.', self.chat),
                    ('Xử lý văn bản đến', 'Lưu hồ sơ, đọc nội dung, tóm tắt và lập phiếu giải quyết.', self.incoming),
                    ('Đơn vị, báo cáo', 'Theo dõi đơn vị đã nộp, chưa nộp và tổng hợp tài liệu báo cáo.', self.reports),
                    ('Kiểm tra, đánh giá', 'Kế hoạch, biên bản, kết luận và hồ sơ thẩm định.', self.inspections),
                    ('Quản lý công việc', 'Ghi việc, phân công, hạn xử lý và trạng thái hoàn thành.', self.tasks),
                    ('Mẫu & quy trình riêng', 'Lưu nội dung mẫu và hướng dẫn riêng của cơ quan.', self.templates),
                    ('Bộ nhớ cơ quan', 'Thông tin, số liệu và quy ước được đưa vào ngữ cảnh AI.', self.memory),
                    ('Tra cứu & tiện ích', 'Nguồn văn bản, iOffice, PDF và sao lưu dữ liệu.', self.utilities)])

    def start_work(self, prompt='', attachment=None):
        if self.pending:
            messagebox.showinfo('Đang xử lý', 'Đợi tác vụ hiện tại hoàn tất hoặc bấm Dừng chờ trong Trò chuyện AI.', parent=self)
            return
        self.session = self.store.put('chat', {'title': (prompt or 'Cuộc trò chuyện mới')[:65], 'messages': [], 'created': datetime.now().isoformat(timespec='seconds')})
        self.attachments = [Path(attachment)] if attachment else []
        self.chat(prompt)

    def chat(self, prompt=None):
        self.begin('Trò chuyện AI', 'Nội dung bạn gửi, tài liệu đính kèm và bộ nhớ cơ quan sẽ được gửi đến máy chủ AI đã cấu hình.')
        if prompt is None:
            prompt = self.chat_draft
        chats = self.store.all('chat')
        top = self.bar()
        self.button(top, 'Cuộc trò chuyện mới', lambda: self.start_work())
        history = ttk.Combobox(top, values=[c['title'] + ' • ' + c['created'] for c in chats], state='readonly', width=48)
        history.pack(side='left', padx=6)
        def choose(event=None):
            if self.pending:
                messagebox.showinfo('Đang xử lý', 'Đợi tác vụ AI hoàn tất trước khi chuyển cuộc trò chuyện.', parent=self)
                return
            self.session = chats[history.current()]
            self.attachments = []
            self.chat('')
        history.bind('<<ComboboxSelected>>', choose)
        if self.session:
            for i, c in enumerate(chats):
                if c['id'] == self.session['id']:
                    history.current(i)
        tools = self.bar()
        self.button(tools, 'Lưu câu trả lời thành văn bản', self.save_answer)
        self.button(tools, 'A−', lambda: self.resize_chat(-1))
        self.button(tools, 'A+', lambda: self.resize_chat(1))
        self.transcript = self.editor(height=15)
        self.transcript.tag_configure('user', foreground=BLUE, font=('Segoe UI', self.text_size, 'bold'))
        self.render_messages()
        self.attachment_label = tk.StringVar()
        tk.Label(self.content, textvariable=self.attachment_label, bg=BG, fg=MUTED, anchor='w').pack(fill='x')
        self.refresh_attachments()
        self.input = ScrolledText(self.content, height=4, font=('Segoe UI', self.text_size), wrap='word', relief='flat', padx=12, pady=9)
        self.input.pack(fill='x', pady=5)
        self.input.insert('1.0', prompt)
        self.input.bind('<Control-Return>', lambda e: self.send())
        row = self.bar()
        self.button(row, 'Đính kèm tài liệu', self.attach)
        self.button(row, 'Bỏ đính kèm', self.clear_attachments)
        self.button(row, 'Gửi • Ctrl+Enter', self.send, True)
        self.button(row, 'Dừng chờ', self.cancel)

    def resize_chat(self, delta):
        self.text_size = max(10, min(20, self.text_size + delta))
        self.transcript.configure(font=('Segoe UI', self.text_size))
        self.transcript.tag_configure('user', font=('Segoe UI', self.text_size, 'bold'))
        self.input.configure(font=('Segoe UI', self.text_size))

    def render_messages(self):
        self.transcript.configure(state='normal')
        self.transcript.delete('1.0', 'end')
        messages = self.session.get('messages', []) if self.session else []
        if not messages:
            self.transcript.insert('end', 'Bạn cần hỗ trợ việc gì hôm nay?\n\nVí dụ: Soạn công văn đề nghị các trường báo cáo số liệu đầu năm học.\n\nBạn có thể đính kèm Word, PDF có chữ, Excel, CSV hoặc tài liệu văn bản.')
        for m in messages:
            self.transcript.insert('end', '\nBẠN\n' if m['role'] == 'user' else '\nTRỢ LÝ\n', 'user')
            self.transcript.insert('end', m.get('display', m['content']) + '\n')
        self.transcript.configure(state='disabled')
        self.transcript.see('end')

    def attach(self):
        paths = filedialog.askopenfilenames(parent=self, filetypes=ATTACH_TYPES)
        for p in paths:
            if Path(p) not in self.attachments:
                self.attachments.append(Path(p))
        self.refresh_attachments()

    def clear_attachments(self):
        self.attachments = []
        self.refresh_attachments()

    def refresh_attachments(self):
        self.attachment_label.set('Đính kèm: ' + (', '.join(p.name for p in self.attachments) or 'chưa có'))

    def send(self):
        if self.pending:
            return
        prompt = self.input.get('1.0', 'end').strip()
        if not prompt:
            return
        profile = dict(self.profile)
        if not profile.get('model'):
            messagebox.showinfo('Cấu hình AI', 'Nhập địa chỉ máy chủ và tên mô hình trong Cài đặt trước.', parent=self)
            return
        key = self.store.key()
        if not self.session:
            self.session = self.store.put('chat', {'title': prompt[:65], 'messages': [], 'created': datetime.now().isoformat(timespec='seconds')})
        paths = list(self.attachments)
        memory = '\n\n'.join(m['title'] + ':\n' + m['body'] for m in self.store.all('memory'))
        history = [{'role': m['role'], 'content': m['content']} for m in self.session['messages']]
        token = object()
        session_id = self.session['id']
        self.pending = token
        self.status.set('Đang đọc tài liệu và chờ AI trả lời… Bạn vẫn có thể mở các trang khác.')
        def worker():
            try:
                content = prompt
                for p in paths:
                    content += '\n\n<TAI_LIEU ten=' + json.dumps(p.name, ensure_ascii=False) + '>\n' + read_document(p) + '\n</TAI_LIEU>'
                display = prompt + ('\n[Đính kèm: ' + ', '.join(p.name for p in paths) + ']' if paths else '')
                messages = history + [{'role': 'user', 'content': content}]
                answer = ask_ai(profile, key, messages, memory)
                self.results.put((token, session_id, {'role': 'user', 'content': content, 'display': display}, answer, None))
            except Exception as exc:
                self.results.put((token, session_id, None, None, str(exc)))
        threading.Thread(target=worker, daemon=True).start()

    def cancel(self):
        if self.pending:
            self.pending = None
            self.status.set('Đã dừng chờ; máy chủ có thể vẫn đang xử lý yêu cầu đã gửi. Nội dung nhập được giữ lại.')

    def poll(self):
        try:
            while True:
                token, sid, user_message, answer, error = self.results.get_nowait()
                if token is not self.pending:
                    continue
                self.pending = None
                if error:
                    self.status.set('Yêu cầu chưa hoàn tất. Nội dung nhập được giữ lại để thử lại.')
                    messagebox.showerror('AI chưa trả lời', error, parent=self)
                    continue
                session = next(s for s in self.store.all('chat') if s['id'] == sid)
                session['messages'] += [user_message, {'role': 'assistant', 'content': answer}]
                self.session = self.store.put('chat', session)
                self.attachments = []
                self.chat_draft = ''
                self.status.set('AI đã trả lời • Cuộc trò chuyện đã được lưu trên máy')
                if self.page == 'Trò chuyện AI':
                    self.chat('')
        except queue.Empty:
            pass
        self.after(120, self.poll)

    def save_answer(self):
        answer = next((m['content'] for m in reversed(self.session['messages']) if m['role'] == 'assistant'), '') if self.session else ''
        if not answer:
            messagebox.showinfo('Chưa có nội dung', 'Cần có câu trả lời AI trước khi lưu.', parent=self)
            return
        self.document_editor(title=self.session['title'], body=answer)

    def compose(self):
        self.begin('Soạn văn bản', 'Chọn loại văn bản, bổ sung yêu cầu và sửa bản dự thảo trước khi xuất.')
        row = self.bar()
        self.doc_type = tk.StringVar(value=DOC_TYPES[0])
        ttk.Combobox(row, textvariable=self.doc_type, values=DOC_TYPES, state='readonly', width=28).pack(side='left', padx=(0, 12))
        self.button(row, 'Tự soạn / mở trình biên tập', lambda: self.document_editor(title=self.doc_type.get()))
        request = self.editor(height=12)
        request.insert('1.0', 'Nội dung cần soạn:\n\nĐối tượng nhận:\nThời hạn:\nSố liệu và căn cứ đã có:\nNgười ký:\n')
        self.button(self.bar(), 'Giao AI soạn dự thảo', lambda: self.start_work('Soạn ' + self.doc_type.get() + '.\n' + request.get('1.0', 'end').strip()), True)

    def missions(self):
        self.workflow('Nhiệm vụ chuyên viên', MISSIONS)

    def inspections(self):
        self.workflow('Kiểm tra, đánh giá', INSPECTIONS)

    def workflow(self, title, choices):
        self.begin(title, 'Chọn nghiệp vụ để chuẩn bị yêu cầu. Chỉ gửi đến AI khi bạn bấm Gửi trong cuộc trò chuyện.')
        tree = self.table(['Nghiệp vụ', 'Thực hiện'])
        for i, choice in enumerate(choices):
            tree.insert('', 'end', iid=str(i), values=(choice, 'Chuẩn bị yêu cầu →'))
        def use():
            if tree.selection():
                choice = choices[int(tree.selection()[0])]
                self.start_work(choice + '.\nPhạm vi, đơn vị liên quan: \nNội dung và số liệu: \nThời hạn: ')
        tree.bind('<Double-1>', lambda e: use())
        self.button(self.bar(), 'Chọn nghiệp vụ', use, True)

    def document_editor(self, record=None, title='', body=''):
        win = tk.Toplevel(self)
        win.title('Biên tập văn bản')
        win.geometry('950x760')
        win.configure(bg=BG)
        title_var = tk.StringVar(value=record['title'] if record else title)
        ttk.Entry(win, textvariable=title_var, font=('Segoe UI', 14)).pack(fill='x', padx=18, pady=12)
        edit = self.editor(win)
        edit.insert('1.0', record['body'] if record else body)
        status = tk.StringVar(value='Nội dung đang chỉnh sửa • Bản xuất sẽ tạo tên mới nếu tệp đã tồn tại')
        tk.Label(win, textvariable=status, bg=BG, fg=MUTED).pack(anchor='w', padx=18)
        current = dict(record) if record else {}
        def save():
            nonlocal current
            if not title_var.get().strip() or not edit.get('1.0', 'end').strip():
                raise ValueError('Cần nhập tiêu đề và nội dung.')
            current = self.store.put('document', current | {'title': title_var.get().strip(), 'body': edit.get('1.0', 'end').strip(), 'updated': datetime.now().isoformat(timespec='seconds')})
            status.set('Đã lưu lúc ' + datetime.now().strftime('%H:%M:%S'))
            return current
        def export(kind):
            rec = save()
            path = unique_path(self.store.root / 'van-ban-da-soan', rec['title'] + '.' + kind)
            if kind == 'docx':
                export_word(path, rec['title'], rec['body'], self.profile)
            elif kind == 'pptx':
                export_slides(path, rec['title'], rec['body'])
            elif kind == 'xlsx':
                rows = [line.split('\t') if '\t' in line else [line] for line in rec['body'].splitlines() if line.strip()]
                width = max(map(len, rows), default=1)
                export_table(path, rows, ['Nội dung' if width == 1 else f'Cột {i+1}' for i in range(width)])
            else:
                path.write_text(rec['body'], encoding='utf-8')
            status.set('Đã xuất: ' + str(path))
            messagebox.showinfo('Đã xuất tệp', str(path), parent=win)
        row = self.bar(win)
        self.button(row, 'Lưu văn bản', save, True)
        for kind, label in [('docx', 'Xuất Word'), ('pptx', 'Xuất PowerPoint'), ('xlsx', 'Xuất Excel'), ('md', 'Xuất Markdown')]:
            self.button(row, label, lambda k=kind: export(k))
        self.button(row, 'Thư mục xuất', lambda: os.startfile(self.store.root / 'van-ban-da-soan'))
        def close():
            changed = edit.get('1.0', 'end').strip() != current.get('body', '') or title_var.get().strip() != current.get('title', '')
            if changed:
                choice = messagebox.askyesnocancel('Lưu thay đổi', 'Lưu văn bản trước khi đóng?', parent=win)
                if choice is None:
                    return
                if choice:
                    save()
            win.destroy()
            if self.page == 'Văn bản đã soạn':
                self.library()
        win.protocol('WM_DELETE_WINDOW', close)

    def library(self):
        self.begin('Văn bản đã soạn', 'Tìm kiếm, chỉnh sửa và xuất Word, PowerPoint, Excel hoặc Markdown.')
        row = self.bar()
        query = tk.StringVar()
        ttk.Entry(row, textvariable=query, width=45).pack(side='left', padx=(0, 8))
        self.button(row, 'Nhập nội dung từ tệp', self.import_document)
        records = self.store.all('document')
        tree = self.table(['Tiêu đề', 'Cập nhật'])
        def refresh(*args):
            tree.delete(*tree.get_children())
            for r in records:
                if query.get().casefold() in (r['title'] + r['body']).casefold():
                    tree.insert('', 'end', iid=r['id'], values=(r['title'], r['updated']))
        query.trace_add('write', refresh)
        refresh()
        def edit():
            r = self.selected(tree, records)
            if r:
                self.document_editor(r)
        tree.bind('<Double-1>', lambda e: edit())
        row = self.bar()
        self.button(row, 'Mở / chỉnh sửa', edit, True)
        self.button(row, 'Thêm văn bản', self.document_editor)
        self.button(row, 'Xóa', lambda: self.delete_record(tree, records, self.library))
        self.button(row, 'Mở thư mục xuất', lambda: os.startfile(self.store.root / 'van-ban-da-soan'))

    def import_document(self):
        file = filedialog.askopenfilename(parent=self, filetypes=ATTACH_TYPES)
        if file:
            self.document_editor(title=Path(file).stem, body=read_document(file))

    def delete_record(self, tree, records, refresh):
        r = self.selected(tree, records)
        if r and messagebox.askyesno('Xóa bản ghi', 'Xóa bản ghi đang chọn? Tệp đã xuất/đính kèm vẫn được giữ.', parent=self):
            self.store.delete(r['id'])
            refresh()

    def incoming(self):
        self.begin('Xử lý văn bản đến', 'Nhập bản sao tài liệu, theo dõi hạn và giao AI đọc nội dung. Tệp gốc được giữ nguyên.')
        records = self.store.all('incoming')
        tree = self.table(['Tên văn bản', 'Nơi gửi', 'Hạn xử lý', 'Trạng thái'])
        for r in records:
            tree.insert('', 'end', iid=r['id'], values=(r['title'], r['sender'], r['due'], r['state']))
        def add():
            file = filedialog.askopenfilename(parent=self, filetypes=ATTACH_TYPES)
            if not file:
                return
            values = self.dialog('Văn bản đến', [('title', 'Tên văn bản', None), ('sender', 'Nơi gửi', None), ('due', 'Hạn xử lý (YYYY-MM-DD, có thể để trống)', None)], {'title': Path(file).stem})
            if values:
                self.validate_date(values['due'])
                path = unique_path(self.store.root / 'van-ban-den', Path(file).name)
                shutil.copy2(file, path)
                self.store.put('incoming', values | {'path': str(path.relative_to(self.store.root)), 'state': 'Chưa xử lý'})
                self.incoming()
        def action(mode):
            r = self.selected(tree, records)
            if not r:
                return
            path = self.store.root / r['path']
            if mode == 'open':
                os.startfile(path)
            elif mode == 'done':
                self.store.put('incoming', r | {'state': 'Đã xử lý'})
                self.incoming()
            elif mode == 'task':
                self.edit_task(initial={'title': 'Xử lý: ' + r['title'], 'due': r['due']})
            else:
                self.start_work(mode + '. Nêu rõ việc cần làm, đơn vị thực hiện, thời hạn. Chỉ dùng thông tin có trong tài liệu; phần thiếu ghi cần bổ sung.', path)
        row = self.bar()
        self.button(row, 'Nhập văn bản', add, True)
        self.button(row, 'Mở tệp', lambda: action('open'))
        self.button(row, 'Tóm tắt, trích việc', lambda: action('Tóm tắt văn bản và trích việc'))
        self.button(row, 'Lập phiếu giải quyết', lambda: action('Lập phiếu giải quyết văn bản đến'))
        row = self.bar()
        self.button(row, 'Thêm việc theo dõi', lambda: action('task'))
        self.button(row, 'Đánh dấu đã xử lý', lambda: action('done'))
        self.button(row, 'Xóa bản ghi', lambda: self.delete_record(tree, records, self.incoming))

    @staticmethod
    def validate_date(value):
        if value:
            parsed = date.fromisoformat(value)
            if parsed.isoformat() != value:
                raise ValueError('Ngày phải theo dạng YYYY-MM-DD, ví dụ 2026-09-30.')

    def edit_task(self, record=None, initial=None):
        values = self.dialog('Công việc', [('title', 'Nội dung công việc', None), ('owner', 'Người / đơn vị phụ trách', None),
                             ('due', 'Hạn (YYYY-MM-DD, có thể để trống)', None),
                             ('state', 'Trạng thái', ['Chưa làm', 'Đang làm', 'Hoàn thành']), ('note', 'Ghi chú', None)], record or initial)
        if values:
            if not values['title']:
                raise ValueError('Cần nhập nội dung công việc.')
            self.validate_date(values['due'])
            self.store.put('task', (record or {}) | values)
            self.tasks()

    def tasks(self):
        self.begin('Quản lý công việc', 'Theo dõi phân công, hạn xử lý và tiến độ. Ngày nhập theo dạng YYYY-MM-DD.')
        records = self.store.all('task')
        records.sort(key=lambda r: (r['state'] == 'Hoàn thành', r.get('due') or '9999'))
        tree = self.table(['Công việc', 'Phụ trách', 'Hạn', 'Trạng thái'])
        tree.tag_configure('late', foreground='#C13249')
        for r in records:
            late = r['due'] and r['due'] < date.today().isoformat() and r['state'] != 'Hoàn thành'
            tree.insert('', 'end', iid=r['id'], values=(r['title'], r['owner'], r['due'], r['state']), tags=('late',) if late else ())
        def edit():
            r = self.selected(tree, records)
            if r:
                self.edit_task(r)
        row = self.bar()
        self.button(row, 'Thêm công việc', self.edit_task, True)
        self.button(row, 'Sửa / cập nhật tiến độ', edit)
        self.button(row, 'Xóa', lambda: self.delete_record(tree, records, self.tasks))
        self.button(row, 'Xuất Excel', lambda: self.save_table(['Công việc', 'Phụ trách', 'Hạn', 'Trạng thái', 'Ghi chú'], [[r[k] for k in ('title', 'owner', 'due', 'state', 'note')] for r in records]))
        tree.bind('<Double-1>', lambda e: edit())

    def save_table(self, headers, rows):
        file = filedialog.asksaveasfilename(parent=self, defaultextension='.xlsx', filetypes=[('Excel', '*.xlsx')])
        if file:
            export_table(file, rows, headers)
            messagebox.showinfo('Đã xuất Excel', file, parent=self)

    def reports(self):
        self.begin('Đơn vị, báo cáo', 'Mỗi đợt lưu danh sách đơn vị cần nộp. Bản sao báo cáo được gắn đúng đơn vị và đợt.')
        cycles = self.store.all('cycle')
        row = self.bar()
        choice = ttk.Combobox(row, values=[c['title'] for c in cycles], state='readonly', width=48)
        choice.pack(side='left', padx=(0, 8))
        if cycles:
            choice.current(0)
        def new_cycle():
            data = self.dialog('Tạo đợt báo cáo', [('title', 'Tên đợt', None), ('due', 'Hạn nộp (YYYY-MM-DD)', None)])
            if data:
                if not data['title']:
                    raise ValueError('Cần nhập tên đợt.')
                self.validate_date(data['due'])
                self.store.put('cycle', data | {'units': [u['id'] for u in self.store.all('unit')]})
                self.reports()
        self.button(row, 'Tạo đợt', new_cycle, True)
        self.button(row, 'Danh sách đơn vị', self.units)
        tree = self.table(['Đơn vị', 'Hạn nộp', 'Tình trạng', 'Tệp báo cáo'])
        units = self.store.all('unit')
        def current():
            return cycles[choice.current()] if choice.current() >= 0 else None
        def refresh(event=None):
            tree.delete(*tree.get_children())
            cycle = current()
            if not cycle:
                return
            submissions = self.store.all('submission')
            for uid in cycle['units']:
                unit = next((u for u in units if u['id'] == uid), {'title': '(Đơn vị đã xóa)'})
                sub = next((s for s in submissions if s['cycle'] == cycle['id'] and s['unit'] == uid), None)
                tree.insert('', 'end', iid=uid, values=(unit['title'], cycle['due'], 'Đã nộp' if sub else 'Chưa nộp', Path(sub['path']).name if sub else ''))
        choice.bind('<<ComboboxSelected>>', refresh)
        refresh()
        def receive():
            cycle = current()
            if not cycle or not tree.selection():
                raise ValueError('Chọn đợt và đơn vị cần nhập báo cáo.')
            file = filedialog.askopenfilename(parent=self, filetypes=ATTACH_TYPES)
            if file:
                path = unique_path(self.store.root / 'bao-cao', Path(file).name)
                shutil.copy2(file, path)
                uid = tree.selection()[0]
                self.store.put('submission', {'id': cycle['id'] + '-' + uid, 'cycle': cycle['id'], 'unit': uid, 'path': str(path.relative_to(self.store.root))})
                refresh()
        def aggregate(remind=False):
            cycle = current()
            if not cycle:
                return
            subs = [s for s in self.store.all('submission') if s['cycle'] == cycle['id']]
            missing = [u['title'] for u in units if u['id'] in cycle['units'] and not any(s['unit'] == u['id'] for s in subs)]
            prompt = ('Soạn công văn đôn đốc' if remind else 'Tổng hợp các báo cáo đính kèm; nêu nguồn từng số liệu, không cộng số liệu khác đơn vị đo hoặc khác kỳ') + '.\nĐợt: ' + cycle['title'] + '\nHạn: ' + cycle['due'] + '\nĐơn vị chưa nộp: ' + ', '.join(missing)
            if self.pending:
                raise ValueError('Đợi tác vụ AI hiện tại hoàn tất.')
            self.start_work(prompt)
            if not remind:
                self.attachments = [self.store.root / s['path'] for s in subs]
                self.refresh_attachments()
        def include_units():
            cycle = current()
            if cycle:
                cycle['units'] = list(dict.fromkeys(cycle['units'] + [u['id'] for u in units]))
                self.store.put('cycle', cycle)
                refresh()
        def open_report():
            cycle = current()
            if cycle and tree.selection():
                sub = next((s for s in self.store.all('submission') if s['cycle'] == cycle['id'] and s['unit'] == tree.selection()[0]), None)
                if sub:
                    os.startfile(self.store.root / sub['path'])
        row = self.bar()
        self.button(row, 'Nhận báo cáo', receive, True)
        self.button(row, 'Mở báo cáo', open_report)
        self.button(row, 'Tổng hợp bằng AI', aggregate)
        self.button(row, 'Đôn đốc', lambda: aggregate(True))
        row = self.bar()
        self.button(row, 'Bổ sung đơn vị mới vào đợt', include_units)
        self.button(row, 'Xuất bảng theo dõi', lambda: self.save_table(['Đơn vị', 'Hạn', 'Tình trạng', 'Tệp'], [list(tree.item(i, 'values')) for i in tree.get_children()]))

    def units(self):
        self.begin('Danh sách đơn vị', 'Thêm đơn vị trước khi tạo đợt báo cáo, hoặc bổ sung vào đợt hiện có sau.')
        records = self.store.all('unit')
        tree = self.table(['Đơn vị', 'Đầu mối', 'Liên hệ'])
        for r in records:
            tree.insert('', 'end', iid=r['id'], values=(r['title'], r['contact'], r['phone']))
        def edit(existing=None):
            value = self.dialog('Đơn vị', [('title', 'Tên đơn vị', None), ('contact', 'Người liên hệ', None), ('phone', 'Email / điện thoại', None)], existing)
            if value:
                if not value['title']:
                    raise ValueError('Cần nhập tên đơn vị.')
                self.store.put('unit', (existing or {}) | value)
                self.units()
        def selected_edit():
            r = self.selected(tree, records)
            if r:
                edit(r)
        row = self.bar()
        self.button(row, 'Thêm đơn vị', edit, True)
        self.button(row, 'Sửa', selected_edit)
        self.button(row, 'Quay lại báo cáo', self.reports)

    def memory(self):
        self.begin('Bộ nhớ cơ quan', 'Thông tin đã lưu được đưa vào mỗi yêu cầu AI. Chỉ nhập dữ liệu cần cho công việc.')
        row = self.bar()
        selection = ttk.Combobox(row, values=MEMORIES, state='readonly', width=45)
        selection.current(0)
        selection.pack(side='left')
        edit = self.editor()
        selected_title = [MEMORIES[0]]
        def persist():
            self.store.put('memory', {'id': 'memory-' + selected_title[0], 'title': selected_title[0], 'body': edit.get('1.0', 'end').strip()})
        def load(event=None):
            if event:
                persist()
            selected_title[0] = selection.get()
            record = next((r for r in self.store.all('memory') if r['title'] == selection.get()), {})
            edit.delete('1.0', 'end')
            edit.insert('1.0', record.get('body', ''))
        load()
        self.page_leave = persist
        selection.bind('<<ComboboxSelected>>', load)
        def save():
            persist()
            self.status.set('Đã lưu bộ nhớ: ' + selection.get())
        self.button(self.bar(), 'Lưu bộ nhớ', save, True)

    def templates(self):
        self.begin('Mẫu & quy trình riêng', 'Mẫu do bạn nhập được lưu trong ứng dụng và có thể dùng làm chỉ dẫn khi giao việc cho AI.')
        records = self.store.all('template')
        tree = self.table(['Tên mẫu / quy trình', 'Loại'])
        for r in records:
            tree.insert('', 'end', iid=r['id'], values=(r['title'], r.get('type', 'Mẫu văn bản')))
        def edit(record=None):
            win = tk.Toplevel(self)
            win.title('Mẫu / quy trình')
            win.geometry('800x650')
            name = tk.StringVar(value=(record or {}).get('title', ''))
            ttk.Entry(win, textvariable=name).pack(fill='x', padx=12, pady=10)
            body = self.editor(win)
            body.insert('1.0', (record or {}).get('body', ''))
            def save():
                if not name.get().strip() or not body.get('1.0', 'end').strip():
                    raise ValueError('Cần nhập tên và nội dung mẫu.')
                self.store.put('template', (record or {}) | {'title': name.get().strip(), 'body': body.get('1.0', 'end').strip(), 'type': 'Mẫu / quy trình riêng'})
                win.destroy()
                self.templates()
            self.button(self.bar(win), 'Lưu mẫu', save, True)
        def use():
            r = self.selected(tree, records)
            if r:
                self.start_work('Thực hiện công việc theo mẫu / quy trình sau:\n' + r['body'] + '\n\nYêu cầu cụ thể: ')
        def selected_edit():
            r = self.selected(tree, records)
            if r:
                edit(r)
        def import_file():
            file = filedialog.askopenfilename(parent=self, filetypes=ATTACH_TYPES)
            if file:
                edit({'title': Path(file).stem, 'body': read_document(file)})
        row = self.bar()
        self.button(row, 'Tạo mẫu', edit, True)
        self.button(row, 'Nhập từ tệp', import_file)
        self.button(row, 'Chỉnh sửa', selected_edit)
        self.button(row, 'Dùng với AI', use)
        self.button(row, 'Xóa', lambda: self.delete_record(tree, records, self.templates))

    def utilities(self):
        self.begin('Tra cứu & tiện ích', 'Mở nguồn chính thức để đối chiếu quy định. iOffice mở trên trình duyệt; nhập tài liệu tải về ở trang Văn bản đến.')
        self.cards([('Cổng văn bản Chính phủ', 'Mở cổng tra cứu văn bản của Chính phủ.', lambda: webbrowser.open('https://vanban.chinhphu.vn')),
                    ('Bộ Giáo dục và Đào tạo', 'Mở trang thông tin của Bộ GD&ĐT.', lambda: webbrowser.open('https://moet.gov.vn')),
                    ('iOffice của cơ quan', 'Mở địa chỉ bạn đã khai báo trong Cài đặt.', self.open_ioffice),
                    ('Tra cứu với AI', 'Phân tích quy định từ tài liệu bạn cung cấp.', lambda: self.start_work('Phân tích quy định trong tài liệu đính kèm. Trích rõ điều khoản, nguồn; đánh dấu phần cần xác minh hiệu lực.\nCâu hỏi: ')),
                    ('Ghép / tách / xoay PDF', 'Tạo tệp PDF mới từ tài liệu đã chọn.', self.pdf_tools),
                    ('Sao lưu dữ liệu', 'Lưu cơ sở dữ liệu và các tệp thành ZIP, không chứa API key.', self.backup),
                    ('Thư mục dữ liệu', 'Mở nơi lưu công việc và văn bản của ứng dụng.', lambda: os.startfile(self.store.root)),
                    ('Hướng dẫn sử dụng', 'Cấu hình AI, quy trình làm việc và giới hạn hiện tại.', self.help)])

    def open_ioffice(self):
        from urllib.parse import urlparse
        url = self.profile.get('ioffice', '')
        if urlparse(url).scheme not in ('https', 'http') or not urlparse(url).hostname:
            raise ValueError('Nhập địa chỉ iOffice hợp lệ trong Cài đặt.')
        webbrowser.open(url)

    def pdf_tools(self):
        from PyPDF2 import PdfReader, PdfWriter
        options = self.dialog('Công cụ PDF', [('mode', 'Thao tác', ['Ghép PDF', 'Tách trang', 'Xoay trang']),
                            ('pages', 'Tách: khoảng trang, ví dụ 2-5 (để trống = tất cả)', None),
                            ('angle', 'Góc xoay', ['90', '180', '270'])])
        if not options:
            return
        files = filedialog.askopenfilenames(parent=self, filetypes=[('PDF', '*.pdf')])
        if not files:
            return
        if options['mode'] != 'Ghép PDF' and len(files) != 1:
            raise ValueError('Chọn đúng một tệp để tách hoặc xoay.')
        target = filedialog.asksaveasfilename(parent=self, defaultextension='.pdf', filetypes=[('PDF', '*.pdf')])
        if not target:
            return
        if Path(target).resolve() in [Path(f).resolve() for f in files]:
            raise ValueError('Chọn tên tệp mới để giữ nguyên PDF gốc.')
        writer = PdfWriter()
        for file in files:
            reader = PdfReader(file)
            first, last = 1, len(reader.pages)
            if options['mode'] == 'Tách trang' and options['pages']:
                parts = options['pages'].split('-')
                if len(parts) not in (1, 2):
                    raise ValueError('Khoảng trang phải có dạng 2-5 hoặc 3.')
                first, last = int(parts[0]), int(parts[-1])
            if first < 1 or last > len(reader.pages) or first > last:
                raise ValueError('Khoảng trang không hợp lệ.')
            for index in range(first - 1, last):
                page = reader.pages[index]
                if options['mode'] == 'Xoay trang':
                    page.rotate(int(options['angle']))
                writer.add_page(page)
        with open(target, 'wb') as handle:
            writer.write(handle)
        messagebox.showinfo('Đã tạo PDF', target, parent=self)

    def backup(self):
        target = filedialog.asksaveasfilename(parent=self, initialfile='TroLy-sao-luu-' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.zip', defaultextension='.zip', filetypes=[('ZIP', '*.zip')])
        if target:
            self.store.backup(target)
            messagebox.showinfo('Đã sao lưu', target + '\nKhông bao gồm API key.', parent=self)

    def settings(self):
        self.begin('Cài đặt', 'OpenRouter đã được điền sẵn địa chỉ. Nhập API key và mã mô hình để bắt đầu sử dụng AI.')
        notebook = ttk.Notebook(self.content)
        notebook.pack(fill='both', expand=True, pady=8)
        agency, ai = ttk.Frame(notebook, padding=20), ttk.Frame(notebook, padding=20)
        notebook.add(ai, text='Kết nối AI')
        notebook.add(agency, text='Hồ sơ cơ quan')
        fields = {}
        def field(parent, key, label, choices=None):
            tk.Label(parent, text=label, bg=BG, anchor='w').pack(fill='x', pady=(9, 3))
            var = tk.StringVar(value=self.profile.get(key, ''))
            w = ttk.Combobox(parent, values=choices, textvariable=var, state='readonly') if choices else ttk.Entry(parent, textvariable=var)
            w.pack(fill='x')
            fields[key] = var
        for key, label in [('agency', 'Tên cơ quan'), ('parent', 'Cơ quan chủ quản'), ('name', 'Họ tên'),
                           ('position', 'Chức vụ'), ('location', 'Địa danh'), ('year', 'Năm học')]:
            field(agency, key, label)
        field(agency, 'role', 'Vai trò', ['Chuyên viên Sở GD&ĐT', 'Phòng Văn hóa – Xã hội', 'Lãnh đạo UBND xã/phường'])
        field(ai, 'provider', 'Loại kết nối', ['OpenRouter', 'API tương thích', 'Gemini'])
        field(ai, 'endpoint', 'Địa chỉ API gốc, gồm /v1 nếu máy chủ yêu cầu (ví dụ http://localhost:1234/v1)')
        field(ai, 'model', 'Tên mô hình chính xác do máy chủ cung cấp')
        links = self.bar(ai)
        self.button(links, 'Lấy API key OpenRouter', lambda: webbrowser.open('https://openrouter.ai/settings/keys'))
        self.button(links, 'Xem mã mô hình', lambda: webbrowser.open('https://openrouter.ai/models'))
        def preset():
            fields['provider'].set('OpenRouter')
            fields['endpoint'].set('https://openrouter.ai/api/v1')
        self.button(links, 'Điền địa chỉ OpenRouter', preset)
        tk.Label(ai, text='API key (để trống nếu máy chủ nội bộ không yêu cầu)', bg=BG).pack(anchor='w', pady=(12, 3))
        key = tk.StringVar(value=self.store.key())
        ttk.Entry(ai, textvariable=key, show='•').pack(fill='x')
        field(ai, 'ioffice', 'Địa chỉ iOffice cơ quan (tùy chọn)')
        tk.Label(ai, text='Sau khi lưu, vào Trò chuyện AI để gửi câu hỏi thử.\nỨng dụng không tự gửi tài liệu khi bạn chỉ mở một trang nghiệp vụ.', bg=BG, fg=MUTED, justify='left').pack(anchor='w', pady=18)
        def save():
            values = {k: v.get().strip() for k, v in fields.items()}
            self.store.save_key(key.get().strip())
            self.profile = self.store.save_profile(values)
            self.status.set('Đã lưu hồ sơ và cấu hình AI')
            messagebox.showinfo('Đã lưu', 'Cấu hình đã lưu. Bạn có thể bắt đầu trò chuyện với AI.', parent=self)
        self.button(self.bar(), 'Lưu cài đặt', save, True)

    def help(self):
        self.begin('Hướng dẫn sử dụng', 'Trợ lý Chuyên viên Giáo dục • Bản độc lập 1.0')
        edit = self.editor()
        edit.insert('1.0', '''1. CÀI ĐẶT AI
Chọn Cài đặt → OpenRouter. Địa chỉ https://openrouter.ai/api/v1 đã được điền sẵn. Nhập API key và mã mô hình từ trang openrouter.ai/models, nhập hồ sơ cơ quan rồi lưu. Bạn cũng có thể chọn API tương thích để dùng máy chủ riêng. Không cần khóa để quản lý hồ sơ và biên tập tài liệu trên máy.

2. GIAO VIỆC
Chọn một nghiệp vụ, ghi yêu cầu và bấm Gửi. Ctrl+Enter cũng gửi yêu cầu. Có thể đính kèm DOCX, PDF có lớp chữ, XLSX, CSV, TXT, MD. Nhắn tiếp để sửa nội dung. Lịch sử chỉ lưu khi yêu cầu hoàn tất thành công. Dừng chờ không đảm bảo hủy xử lý trên máy chủ.

3. VĂN BẢN
Lưu câu trả lời thành văn bản, chỉnh sửa rồi xuất Word, PowerPoint, Excel hoặc Markdown. File xuất lại có hậu tố -v2, -v3 để tránh ghi đè. Word là bản dự thảo với định dạng cơ bản; cần rà nội dung và thể thức trước khi ban hành. PowerPoint chia nội dung thành các trang chữ; Excel giữ nội dung như dữ liệu chữ, chưa tự tạo biểu đồ hay công thức.

4. ĐƠN VỊ VÀ BÁO CÁO
Tạo danh sách đơn vị → tạo đợt → chọn đơn vị → nhận tệp báo cáo. Bấm Tổng hợp để chuẩn bị yêu cầu AI kèm các tệp đã nộp. Kiểm tra số liệu trước khi sử dụng.

5. BỘ NHỚ, MẪU VÀ CÔNG VIỆC
Bộ nhớ được gửi cùng yêu cầu AI, hãy bấm Lưu sau khi sửa. Mẫu và quy trình riêng có thể nhập từ tệp. Công việc quản lý trực tiếp trên máy; việc AI đề xuất chưa tự động ghi thành bản ghi.

6. DỮ LIỆU VÀ SAO LƯU
Dữ liệu nằm trong %LOCALAPPDATA%\\TroLyChuyenVienDocLap, tách khỏi EXE. Sao lưu tạo ZIP chứa dữ liệu và tệp, không chứa API key. Khôi phục thủ công: đóng app, sao lưu dữ liệu hiện tại, giải nén ZIP vào thư mục dữ liệu. Nhập lại API key khi chuyển máy.

7. PHẠM VI BẢN NÀY
Ứng dụng độc lập xây mới theo các nhóm nghiệp vụ của app tham chiếu. Không phải phiên bản chính thức của tác giả app mẫu và chưa tương đương 100%. Chưa có tự động hóa iOffice, theo dõi văn bản mới trên website, tự cập nhật phần mềm, OCR ảnh, nhận giọng nói hoặc công cụ sửa/dọn máy tính. iOffice mở bằng trình duyệt để bạn thao tác và tải tài liệu. AI dùng API OpenRouter do bạn cấu hình.
''')
        edit.configure(state='disabled')


if __name__ == '__main__':
    try:
        ctypes = __import__('ctypes')
        ctypes.windll.shcore.SetProcessDpiAwareness(1)
    except Exception:
        pass
    App().mainloop()
