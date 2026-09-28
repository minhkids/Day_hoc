"""
HỆ THỐNG TRỢ LÝ AI GIÁO DỤC - PHIÊN BẢN DESKTOP WINDOWS ĐA VAI TRÒ
Tích hợp toàn diện 3 vai trò:
1. Trợ lý Giáo viên (Dạy học, Đề thi, Chủ nhiệm, Sáng kiến, Xưởng phần mềm)
2. Trợ lý Hiệu trưởng (Quản trị nhà trường, Kiểm tra nội bộ, Văn bản Đảng, CSDL ngành)
3. Trợ lý Chuyên viên (Tham mưu, Thẩm định, Chuẩn quốc gia TT 57/2026, Phổ cập GD)
"""

import os
import sys
import json
import webbrowser
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext

# Thêm đường dẫn hiện tại vào sys.path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT_DIR = os.path.join(BASE_DIR, "output")
MINI_APPS_DIR = os.path.join(BASE_DIR, "mini_apps")
TEMPLATES_DIR = os.path.join(BASE_DIR, "templates")

os.makedirs(OUTPUT_DIR, exist_ok=True)

if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from config import load_profile, save_profile
from prompts import (
    get_lesson_plan_prompt,
    get_exam_matrix_prompt,
    get_homeroom_plan_prompt,
    get_initiative_prompt,
    get_school_year_plan_prompt,
    get_internal_inspection_prompt,
    get_party_doc_prompt,
    get_consultation_prompt,
    get_accreditation_prompt,
    get_admin_doc_prompt
)
from ai_engine import AIEngine
from exporters.docx_builder import export_lesson_plan_docx, export_admin_doc_docx
from exporters.pptx_builder import export_lesson_slides_pptx
from exporters.xlsx_builder import export_gradebook_xlsx

class EducationAIAssistantApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Trợ lý AI - Giáo dục Số Thế Hệ Mới (Giáo viên - Hiệu trưởng - Chuyên viên)")
        self.geometry("1100x740")
        self.minsize(960, 640)

        # Nạp hồ sơ người dùng
        self.profile = load_profile()
        self.ai = AIEngine(self.profile)

        # Thiết lập giao diện màu sắc
        self.configure(bg="#F4F8FE")
        self.setup_styles()
        self.create_layout()

    def setup_styles(self):
        self.style = ttk.Style()
        self.style.theme_use("clam")

        self.PRIMARY_BLUE = "#1462E6"
        self.DARK_NAVY = "#0B2B6B"
        self.PALE_BLUE = "#E8F0FE"
        self.LINE_COLOR = "#D5E1F2"

        self.style.configure(".", font=("Segoe UI", 10), background="#F4F8FE")
        self.style.configure("Sidebar.TFrame", background="#0B2B6B")
        
        self.style.configure("Nav.TButton", 
                             font=("Segoe UI", 10, "bold"), 
                             background="#0B2B6B", 
                             foreground="#FFFFFF",
                             padding=(12, 9),
                             borderwidth=0)
        self.style.map("Nav.TButton", 
                       background=[("active", "#1462E6"), ("selected", "#1462E6")])

        self.style.configure("Action.TButton", 
                             font=("Segoe UI", 10, "bold"), 
                             background="#1462E6", 
                             foreground="#FFFFFF", 
                             padding=(14, 8))
        self.style.map("Action.TButton", 
                       background=[("active", "#0B4FC4")])

        self.style.configure("Secondary.TButton", 
                             font=("Segoe UI", 10, "bold"), 
                             background="#1FA971", 
                             foreground="#FFFFFF", 
                             padding=(12, 8))
        self.style.map("Secondary.TButton", 
                       background=[("active", "#178055")])

        self.style.configure("Header.TLabel", 
                             font=("Segoe UI", 15, "bold"), 
                             foreground="#0B2B6B", 
                             background="#FFFFFF")

    def create_layout(self):
        self.main_container = tk.Frame(self, bg="#F4F8FE")
        self.main_container.pack(fill=tk.BOTH, expand=True)

        # Sidebar trái
        self.sidebar = tk.Frame(self.main_container, bg="#0B2B6B", width=230)
        self.sidebar.pack(side=tk.LEFT, fill=tk.Y)
        self.sidebar.pack_propagate(False)

        # Header Logo
        lbl_logo = tk.Label(self.sidebar, 
                            text="🎓 TRỢ LÝ AI\nGIÁO DỤC TOÀN DIỆN", 
                            font=("Segoe UI", 12, "bold"), 
                            fg="#FFFFFF", 
                            bg="#0B2B6B", 
                            pady=16)
        lbl_logo.pack(fill=tk.X)

        # Phân loại vai trò
        role_label = tk.Label(self.sidebar, 
                              text=f"Vai trò: {self.profile.get('role', 'Giáo viên')}", 
                              font=("Segoe UI", 9, "italic"), 
                              fg="#93C5FD", 
                              bg="#0B2B6B",
                              pady=2)
        role_label.pack(fill=tk.X)

        sep = tk.Frame(self.sidebar, height=1, bg="#1E3A8A")
        sep.pack(fill=tk.X, padx=12, pady=10)

        # Danh mục chức năng Sidebar
        nav_items = [
            ("📋 Hồ sơ & Đổi vai trò", self.show_profile_view),
            ("📚 Nghiệp vụ Giáo viên", self.show_teacher_view),
            ("🏫 Nghiệp vụ Hiệu trưởng", self.show_principal_view),
            ("🏛️ Nghiệp vụ Chuyên viên", self.show_specialist_view),
            ("🎮 Xưởng phần mềm dạy học", self.show_mini_apps_view),
            ("📑 Thư viện mẫu văn bản", self.show_template_browser_view),
            ("📈 Bảng điểm Excel", self.show_gradebook_view),
            ("📁 Thư mục file xuất", self.open_output_folder)
        ]

        for text, cmd in nav_items:
            btn = ttk.Button(self.sidebar, text=text, style="Nav.TButton", command=cmd)
            btn.pack(fill=tk.X, padx=8, pady=3)

        # Footer Sidebar
        lbl_ver = tk.Label(self.sidebar, 
                           text="Phiên bản 2.0 Pro\nĐầy đủ 3 vai trò giáo dục", 
                           font=("Segoe UI", 8), 
                           fg="#93C5FD", 
                           bg="#0B2B6B", 
                           pady=12)
        lbl_ver.pack(side=tk.BOTTOM, fill=tk.X)

        # Vùng nội dung phải
        self.content_frame = tk.Frame(self.main_container, bg="#FFFFFF", padx=24, pady=18)
        self.content_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        self.show_profile_view()

    def clear_content(self):
        for widget in self.content_frame.winfo_children():
            widget.destroy()

    # =========================================================================
    # VIEW 1: HỒ SƠ CÔNG TÁC & CHỌN VAI TRÒ
    # =========================================================================
    def show_profile_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="📋 Khai báo Hồ sơ Công tác & Phân quyền Vai trò", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))
        
        lbl_sub = tk.Label(self.content_frame, text="Lựa chọn vai trò (Giáo viên, Hiệu trưởng, Chuyên viên) và cập nhật thông tin đơn vị để AI tự động điền thể thức văn bản chuẩn.", font=("Segoe UI", 10), fg="#64748B", bg="#FFFFFF")
        lbl_sub.pack(anchor="w", pady=(0, 16))

        form_frame = tk.Frame(self.content_frame, bg="#FFFFFF")
        form_frame.pack(fill=tk.BOTH, expand=True)

        fields = [
            ("Vai trò công tác:", "role_selector", ["Giáo viên", "Hiệu trưởng / Ban giám hiệu", "Chuyên viên QLNN về Giáo dục"]),
            ("Tên trường / Cơ quan:", "school_name", self.profile.get("school_name", "Trường THCS Lê Quý Đôn")),
            ("Xã / Phường / Quận / Huyện:", "district", self.profile.get("district", "Phường Hải Châu I")),
            ("Tỉnh / Thành phố:", "province", self.profile.get("province", "TP Đà Nẵng")),
            ("Họ và tên cán bộ / GV:", "full_name", self.profile.get("full_name", "Thầy/Cô giáo")),
            ("Chức danh cụ thể:", "role", self.profile.get("role", "Giáo viên")),
            ("Cấp học giảng dạy / quản lý:", "level", self.profile.get("level", "THCS")),
            ("Môn học phụ trách:", "subject", self.profile.get("subject", "Toán học")),
            ("Lớp phụ trách:", "classes", self.profile.get("classes", "Lớp 7A1, 7A2")),
            ("Google Gemini API Key (tùy chọn):", "api_key", self.profile.get("api_key", ""))
        ]

        self.profile_entries = {}
        for idx, item in enumerate(fields):
            label_text, key = item[0], item[1]
            lbl = tk.Label(form_frame, text=label_text, font=("Segoe UI", 10, "bold"), fg="#0B2B6B", bg="#FFFFFF")
            lbl.grid(row=idx, column=0, sticky="w", pady=5, padx=(0, 16))

            if key == "role_selector":
                curr_role = self.profile.get("role", "Giáo viên")
                idx_sel = 0
                if "Hiệu trưởng" in curr_role: idx_sel = 1
                elif "Chuyên viên" in curr_role: idx_sel = 2
                cmb = ttk.Combobox(form_frame, values=item[2], state="readonly", width=42, font=("Segoe UI", 10))
                cmb.current(idx_sel)
                cmb.grid(row=idx, column=1, sticky="w", pady=5)
                self.profile_entries[key] = cmb
            else:
                val = item[2]
                entry = ttk.Entry(form_frame, width=44, font=("Segoe UI", 10))
                entry.insert(0, val)
                entry.grid(row=idx, column=1, sticky="w", pady=5)
                self.profile_entries[key] = entry

        btn_save = ttk.Button(form_frame, text="💾 Lưu Hồ Sơ & Cập Nhật Hệ Thống", style="Action.TButton", command=self.save_profile_action)
        btn_save.grid(row=len(fields), column=1, sticky="w", pady=18)

    def save_profile_action(self):
        for key, widget in self.profile_entries.items():
            if key == "role_selector":
                sel = widget.get()
                if "Giáo viên" in sel: self.profile["role"] = "Giáo viên"
                elif "Hiệu trưởng" in sel: self.profile["role"] = "Hiệu trưởng"
                elif "Chuyên viên" in sel: self.profile["role"] = "Chuyên viên Phòng VH-XH"
            else:
                self.profile[key] = widget.get().strip()
        save_profile(self.profile)
        self.ai = AIEngine(self.profile)
        messagebox.showinfo("Thông báo", "Đã lưu hồ sơ thành công! AI đã được nạp cấu hình mới.")

    # =========================================================================
    # VIEW 2: NGHIỆP VỤ GIÁO VIÊN
    # =========================================================================
    def show_teacher_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="📚 Nghiệp Vụ Giáo Viên (Soạn Bài, Đề Thi, Chủ Nhiệm)", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))

        ctrl_frame = tk.Frame(self.content_frame, bg="#FFFFFF")
        ctrl_frame.pack(fill=tk.X, pady=(0, 10))

        tk.Label(ctrl_frame, text="Loại nghiệp vụ:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=0, sticky="w", padx=4)
        self.cmb_teacher_task = ttk.Combobox(ctrl_frame, values=[
            "Kế hoạch bài dạy (Công văn 5512)",
            "Ma trận & Bản đặc tả đề kiểm tra",
            "Kế hoạch công tác chủ nhiệm lớp",
            "Đề cương Sáng kiến kinh nghiệm"
        ], state="readonly", width=34)
        self.cmb_teacher_task.current(0)
        self.cmb_teacher_task.grid(row=0, column=1, padx=4)

        tk.Label(ctrl_frame, text="Tên bài / Chủ đề:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=2, sticky="w", padx=8)
        self.ent_teacher_topic = ttk.Entry(ctrl_frame, width=28)
        self.ent_teacher_topic.insert(0, "Hình hộp chữ nhật và hình lập phương")
        self.ent_teacher_topic.grid(row=0, column=3, padx=4)

        btn_bar = tk.Frame(self.content_frame, bg="#FFFFFF")
        btn_bar.pack(fill=tk.X, pady=(0, 8))

        btn_gen = ttk.Button(btn_bar, text="⚡ Soạn Thảo Tự Động", style="Action.TButton", command=self.generate_teacher_action)
        btn_gen.pack(side=tk.LEFT, padx=(0, 6))

        btn_word = ttk.Button(btn_bar, text="📄 Xuất Word (.docx)", style="Secondary.TButton", command=self.export_teacher_docx_action)
        btn_word.pack(side=tk.LEFT, padx=6)

        btn_ppt = ttk.Button(btn_bar, text="📊 Xuất Slide PowerPoint", style="Secondary.TButton", command=self.export_teacher_pptx_action)
        btn_ppt.pack(side=tk.LEFT, padx=6)

        self.txt_teacher_preview = scrolledtext.ScrolledText(self.content_frame, wrap=tk.WORD, font=("Times New Roman", 12), height=20)
        self.txt_teacher_preview.pack(fill=tk.BOTH, expand=True)
        self.txt_teacher_preview.insert(tk.END, "Chọn nghiệp vụ giáo viên và bấm 'Soạn Thảo Tự Động' để bắt đầu...")

    def generate_teacher_action(self):
        task = self.cmb_teacher_task.get()
        topic = self.ent_teacher_topic.get().strip()

        if "5512" in task:
            prompt = get_lesson_plan_prompt(self.profile.get("subject", "Toán"), self.profile.get("level", "Lớp 7"), topic, "1 tiết", self.profile)
        elif "Ma trận" in task:
            prompt = get_exam_matrix_prompt(self.profile.get("subject", "Toán"), self.profile.get("level", "Lớp 7"), "Giữa kỳ I", self.profile)
        elif "chủ nhiệm" in task:
            prompt = get_homeroom_plan_prompt(self.profile.get("classes", "Lớp 7A1"), "Học kỳ I", self.profile)
        else:
            prompt = get_initiative_prompt(topic, self.profile.get("subject", "Toán"), self.profile)

        self.txt_teacher_preview.delete("1.0", tk.END)
        self.txt_teacher_preview.insert(tk.END, "Đang xử lý nghiệp vụ sư phạm... Vui lòng đợi...\n")
        self.update()

        res = self.ai.generate_content("Bạn là Trợ lý Giáo viên Việt Nam.", prompt)
        self.txt_teacher_preview.delete("1.0", tk.END)
        self.txt_teacher_preview.insert(tk.END, res)

    def export_teacher_docx_action(self):
        topic = self.ent_teacher_topic.get().strip() or "Tai_Lieu"
        task = self.cmb_teacher_task.get()
        filename = f"GV_{topic[:25]}.docx".replace(" ", "_")
        out_path = os.path.join(OUTPUT_DIR, filename)

        if "5512" in task:
            export_lesson_plan_docx({"topic": topic, "grade": self.profile.get("level", "Lớp 7"), "duration": "1 tiết"}, self.profile, out_path)
        else:
            export_admin_doc_docx({"doc_type": task, "title": topic}, self.profile, out_path)
        messagebox.showinfo("Xuất Word thành công", f"Đã lưu văn bản chuẩn vào:\n{out_path}")

    def export_teacher_pptx_action(self):
        topic = self.ent_teacher_topic.get().strip() or "Bài_Giảng"
        filename = f"Slide_{topic[:25]}.pptx".replace(" ", "_")
        out_path = os.path.join(OUTPUT_DIR, filename)
        export_lesson_slides_pptx({"topic": topic, "grade": self.profile.get("level", "Lớp 7")}, self.profile, out_path)
        messagebox.showinfo("Xuất Slide thành công", f"Đã lưu bài giảng PowerPoint vào:\n{out_path}")

    # =========================================================================
    # VIEW 3: NGHIỆP VỤ HIỆU TRƯỞNG / BAN GIÁM HIỆU
    # =========================================================================
    def show_principal_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="🏫 Nghiệp Vụ Quản Trị Nhà Trường (Hiệu Trưởng / BGH)", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))

        ctrl_frame = tk.Frame(self.content_frame, bg="#FFFFFF")
        ctrl_frame.pack(fill=tk.X, pady=(0, 10))

        tk.Label(ctrl_frame, text="Loại quản trị:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=0, sticky="w", padx=4)
        self.cmb_ht_task = ttk.Combobox(ctrl_frame, values=[
            "Kế hoạch giáo dục nhà trường cả năm (TT 15/2026)",
            "Hồ sơ kiểm tra nội bộ (Quyết định, Kế hoạch, Biên bản)",
            "Văn bản Đảng / Chi bộ trường học (Hướng dẫn 05)",
            "Quyết định thành lập các Hội đồng trường học",
            "Báo cáo sơ kết / tổng kết năm học"
        ], state="readonly", width=42)
        self.cmb_ht_task.current(0)
        self.cmb_ht_task.grid(row=0, column=1, padx=4)

        tk.Label(ctrl_frame, text="Trích yếu / Nội dung:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=2, sticky="w", padx=8)
        self.ent_ht_topic = ttk.Entry(ctrl_frame, width=28)
        self.ent_ht_topic.insert(0, "Kế hoạch năm học 2026-2027")
        self.ent_ht_topic.grid(row=0, column=3, padx=4)

        btn_bar = tk.Frame(self.content_frame, bg="#FFFFFF")
        btn_bar.pack(fill=tk.X, pady=(0, 8))

        btn_gen = ttk.Button(btn_bar, text="⚡ Soạn Kế Hoạch / Quyết Định", style="Action.TButton", command=self.generate_principal_action)
        btn_gen.pack(side=tk.LEFT, padx=(0, 6))

        btn_word = ttk.Button(btn_bar, text="📄 Xuất Word NĐ 30 (.docx)", style="Secondary.TButton", command=self.export_principal_docx_action)
        btn_word.pack(side=tk.LEFT, padx=6)

        self.txt_ht_preview = scrolledtext.ScrolledText(self.content_frame, wrap=tk.WORD, font=("Times New Roman", 12), height=20)
        self.txt_ht_preview.pack(fill=tk.BOTH, expand=True)
        self.txt_ht_preview.insert(tk.END, "Soạn thảo văn bản quản lý trường học đúng thẩm quyền Hiệu trưởng, căn cứ Luật Nhà giáo 73/2025...")

    def generate_principal_action(self):
        task = self.cmb_ht_task.get()
        topic = self.ent_ht_topic.get().strip()

        if "Kế hoạch giáo dục" in task:
            prompt = get_school_year_plan_prompt("2026-2027", self.profile)
        elif "kiểm tra nội bộ" in task:
            prompt = get_internal_inspection_prompt(topic, self.profile)
        elif "Đảng" in task:
            prompt = get_party_doc_prompt("NGHỊ QUYẾT", topic, self.profile)
        else:
            prompt = get_admin_doc_prompt("QUYẾT ĐỊNH", topic, self.profile)

        self.txt_ht_preview.delete("1.0", tk.END)
        self.txt_ht_preview.insert(tk.END, "Đang tra cứu cơ sở dữ liệu quản trị nhà trường và soạn thảo...")
        self.update()

        res = self.ai.generate_content("Bạn là Trợ lý Hiệu trưởng Trường học Việt Nam.", prompt)
        self.txt_ht_preview.delete("1.0", tk.END)
        self.txt_ht_preview.insert(tk.END, res)

    def export_principal_docx_action(self):
        task = self.cmb_ht_task.get()
        topic = self.ent_ht_topic.get().strip() or "Van_Ban_BGH"
        filename = f"BGH_{topic[:25]}.docx".replace(" ", "_")
        out_path = os.path.join(OUTPUT_DIR, filename)

        export_admin_doc_docx({"doc_type": task, "title": topic}, self.profile, out_path)
        messagebox.showinfo("Thành công", f"Đã xuất văn bản quản trị chuẩn thể thức Nghị định 30:\n{out_path}")

    # =========================================================================
    # VIEW 4: NGHIỆP VỤ CHUYÊN VIÊN (QUẢN LÝ NHÀ NƯỚC)
    # =========================================================================
    def show_specialist_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="🏛️ Nghiệp Vụ Chuyên Viên Quản Lý Nhà Nước Về Giáo Dục", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))

        ctrl_frame = tk.Frame(self.content_frame, bg="#FFFFFF")
        ctrl_frame.pack(fill=tk.X, pady=(0, 10))

        tk.Label(ctrl_frame, text="Nhiệm vụ QLNN:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=0, sticky="w", padx=4)
        self.cmb_cv_task = ttk.Combobox(ctrl_frame, values=[
            "Tờ trình / Báo cáo tham mưu Lãnh đạo",
            "Thẩm định trường chuẩn Quốc gia (Thông tư 57/2026)",
            "Bài phát biểu / Thông báo kết luận hội nghị",
            "Công văn hướng dẫn nhiệm vụ năm học",
            "Kế hoạch kiểm tra chuyên môn các đơn vị"
        ], state="readonly", width=42)
        self.cmb_cv_task.current(0)
        self.cmb_cv_task.grid(row=0, column=1, padx=4)

        tk.Label(ctrl_frame, text="Nội dung / Đơn vị:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=2, sticky="w", padx=8)
        self.ent_cv_topic = ttk.Entry(ctrl_frame, width=28)
        self.ent_cv_topic.insert(0, "Trường THCS Lê Quý Đôn")
        self.ent_cv_topic.grid(row=0, column=3, padx=4)

        btn_bar = tk.Frame(self.content_frame, bg="#FFFFFF")
        btn_bar.pack(fill=tk.X, pady=(0, 8))

        btn_gen = ttk.Button(btn_bar, text="⚡ Soạn Báo Cáo / Tờ Trình", style="Action.TButton", command=self.generate_specialist_action)
        btn_gen.pack(side=tk.LEFT, padx=(0, 6))

        btn_word = ttk.Button(btn_bar, text="📄 Xuất Word Tham Mưu (.docx)", style="Secondary.TButton", command=self.export_specialist_docx_action)
        btn_word.pack(side=tk.LEFT, padx=6)

        self.txt_cv_preview = scrolledtext.ScrolledText(self.content_frame, wrap=tk.WORD, font=("Times New Roman", 12), height=20)
        self.txt_cv_preview.pack(fill=tk.BOTH, expand=True)
        self.txt_cv_preview.insert(tk.END, "Hỗ trợ cán bộ Phòng Văn hóa - Xã hội / Sở GD&ĐT / UBND xã soạn thảo văn bản quản lý nhà nước...")

    def generate_specialist_action(self):
        task = self.cmb_cv_task.get()
        topic = self.ent_cv_topic.get().strip()

        if "chuẩn Quốc gia" in task:
            prompt = get_accreditation_prompt(topic, self.profile)
        else:
            prompt = get_consultation_prompt(f"{task} cho {topic}", self.profile)

        self.txt_cv_preview.delete("1.0", tk.END)
        self.txt_cv_preview.insert(tk.END, "Đang xử lý tham mưu quản lý nhà nước...")
        self.update()

        res = self.ai.generate_content("Bạn là Chuyên viên Quản lý Nhà nước về Giáo dục.", prompt)
        self.txt_cv_preview.delete("1.0", tk.END)
        self.txt_cv_preview.insert(tk.END, res)

    def export_specialist_docx_action(self):
        task = self.cmb_cv_task.get()
        topic = self.ent_cv_topic.get().strip() or "Tham_Muu"
        filename = f"QLNN_{topic[:25]}.docx".replace(" ", "_")
        out_path = os.path.join(OUTPUT_DIR, filename)

        export_admin_doc_docx({"doc_type": task, "title": topic}, self.profile, out_path)
        messagebox.showinfo("Thành công", f"Đã xuất văn bản tham mưu vào:\n{out_path}")

    # =========================================================================
    # VIEW 5: XƯỞNG PHẦN MỀM DẠY HỌC (MINI APPS)
    # =========================================================================
    def show_mini_apps_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="🎮 Xưởng Phần Mềm Dạy Học (Trình Chiếu Trên Máy Tính & Lớp Học)", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))

        lbl_sub = tk.Label(self.content_frame, text="Bộ 6 công cụ phần mềm mini được tích hợp sẵn. Nhấn nút để khởi chạy ngay trong trình duyệt mà không cần cài đặt thêm.", font=("Segoe UI", 10), fg="#64748B", bg="#FFFFFF")
        lbl_sub.pack(anchor="w", pady=(0, 16))

        apps_container = tk.Frame(self.content_frame, bg="#FFFFFF")
        apps_container.pack(fill=tk.BOTH, expand=True)

        app_list = [
            ("🎯 Vòng Quay May Mắn", "vong-quay", "Quay gọi tên học sinh ngẫu nhiên, tạo câu hỏi khởi động vui nhộn.", "#EFF6FF", "#1D4ED8"),
            ("🧩 Ô Chữ Bí Mật", "o-chu", "Trò chơi giải ô chữ hàng ngang và từ khóa hàng dọc cho tiết ôn tập.", "#F0FDF4", "#15803D"),
            ("⚔️ Đấu Trường Trắc Nghiệm", "trac-nghiem-doi", "Thi đấu trắc nghiệm 2 đội đối kháng tính điểm trực tiếp trên máy chiếu.", "#FEF2F2", "#B91C1C"),
            ("⏱️ Đồng Hồ Đếm Ngược", "dong-ho", "Đồng hồ bấm giờ làm bài, thảo luận nhóm có âm thanh báo giờ.", "#FFFBEB", "#B45309"),
            ("🥁 Trống Lớp Học", "trong", "Mô phỏng tiếng trống vào lớp, ra chơi, khẩu lệnh nề nếp tiết học.", "#FAF5FF", "#6D28D9"),
            ("🎴 Flashcard Lật Thẻ", "flashcard", "Thẻ ghi nhớ từ vựng, công thức Toán, mốc Lịch sử lật 2 mặt.", "#F0FDFA", "#0F766E")
        ]

        for i, (title, folder, desc, bg_card, border_c) in enumerate(app_list):
            row = i // 2
            col = i % 2

            card = tk.Frame(apps_container, bg=bg_card, relief="ridge", bd=1, padx=14, pady=12)
            card.grid(row=row, column=col, padx=8, pady=8, sticky="nsew")
            apps_container.grid_columnconfigure(col, weight=1)

            lbl_t = tk.Label(card, text=title, font=("Segoe UI", 11, "bold"), fg=border_c, bg=bg_card)
            lbl_t.pack(anchor="w")

            lbl_d = tk.Label(card, text=desc, font=("Segoe UI", 9), fg="#475569", bg=bg_card, wraplength=320, justify="left")
            lbl_d.pack(anchor="w", pady=(4, 8))

            btn_open = ttk.Button(card, text="🚀 Mở Ứng Dụng Ngay", style="Action.TButton", command=lambda f=folder: self.launch_mini_app(f))
            btn_open.pack(anchor="w")

    def launch_mini_app(self, folder_name):
        path = os.path.join(MINI_APPS_DIR, folder_name, "index.html")
        if os.path.exists(path):
            webbrowser.open(f"file://{os.path.abspath(path)}")
        else:
            messagebox.showerror("Lỗi", f"Không tìm thấy tệp ứng dụng tại: {path}")

    # =========================================================================
    # VIEW 6: THƯ VIỆN MẪU VĂN BẢN (TEMPLATE BROWSER)
    # =========================================================================
    def show_template_browser_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="📑 Thư Viện Mẫu Văn Bản Nghiệp Vụ Chuẩn 2026-2027", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))

        ctrl_frame = tk.Frame(self.content_frame, bg="#FFFFFF")
        ctrl_frame.pack(fill=tk.X, pady=(0, 10))

        tk.Label(ctrl_frame, text="Nhóm mẫu:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").pack(side=tk.LEFT, padx=4)
        self.cmb_tmpl_group = ttk.Combobox(ctrl_frame, values=["Giáo viên (34 mẫu)", "Hiệu trưởng (49 mẫu)", "Chuyên viên (43 mẫu)"], state="readonly", width=25)
        self.cmb_tmpl_group.current(0)
        self.cmb_tmpl_group.pack(side=tk.LEFT, padx=4)
        self.cmb_tmpl_group.bind("<<ComboboxSelected>>", self.on_template_group_change)

        tk.Label(ctrl_frame, text="Chọn mẫu văn bản:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").pack(side=tk.LEFT, padx=(12, 4))
        self.cmb_tmpl_file = ttk.Combobox(ctrl_frame, state="readonly", width=36)
        self.cmb_tmpl_file.pack(side=tk.LEFT, padx=4)
        self.cmb_tmpl_file.bind("<<ComboboxSelected>>", self.on_template_file_change)

        btn_copy = ttk.Button(ctrl_frame, text="📋 Sao Chép Nội Dung", style="Action.TButton", command=self.copy_template_action)
        btn_copy.pack(side=tk.LEFT, padx=10)

        self.txt_tmpl_preview = scrolledtext.ScrolledText(self.content_frame, wrap=tk.WORD, font=("Consolas", 10), height=22)
        self.txt_tmpl_preview.pack(fill=tk.BOTH, expand=True)

        self.on_template_group_change(None)

    def on_template_group_change(self, event):
        sel = self.cmb_tmpl_group.get()
        sub = "giao_vien"
        if "Hiệu trưởng" in sel: sub = "hieu_truong"
        elif "Chuyên viên" in sel: sub = "chuyen_vien"

        dir_path = os.path.join(TEMPLATES_DIR, sub)
        if os.path.exists(dir_path):
            files = [f for f in os.listdir(dir_path) if f.endswith('.md')]
            self.cmb_tmpl_file['values'] = sorted(files)
            if files:
                self.cmb_tmpl_file.current(0)
                self.on_template_file_change(None)

    def on_template_file_change(self, event):
        sel_group = self.cmb_tmpl_group.get()
        sub = "giao_vien"
        if "Hiệu trưởng" in sel_group: sub = "hieu_truong"
        elif "Chuyên viên" in sel_group: sub = "chuyen_vien"

        fname = self.cmb_tmpl_file.get()
        if fname:
            path = os.path.join(TEMPLATES_DIR, sub, fname)
            if os.path.exists(path):
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
                self.txt_tmpl_preview.delete("1.0", tk.END)
                self.txt_tmpl_preview.insert(tk.END, content)

    def copy_template_action(self):
        content = self.txt_tmpl_preview.get("1.0", tk.END)
        self.clipboard_clear()
        self.clipboard_append(content)
        messagebox.showinfo("Đã sao chép", "Đã sao chép nội dung mẫu văn bản vào bộ nhớ đệm (Clipboard)!")

    # =========================================================================
    # VIEW 7: BẢNG TÍNH EXCEL
    # =========================================================================
    def show_gradebook_view(self):
        self.clear_content()

        lbl_title = ttk.Label(self.content_frame, text="📈 Trợ lý Quản lý Bảng điểm & Thống kê Excel", style="Header.TLabel")
        lbl_title.pack(anchor="w", pady=(0, 4))

        ctrl_frame = tk.Frame(self.content_frame, bg="#FFFFFF")
        ctrl_frame.pack(fill=tk.X, pady=(10, 16))

        tk.Label(ctrl_frame, text="Lớp theo dõi:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF").grid(row=0, column=0, sticky="w", padx=4)
        self.ent_gb_class = ttk.Entry(ctrl_frame, width=16)
        self.ent_gb_class.insert(0, "7A1")
        self.ent_gb_class.grid(row=0, column=1, padx=4)

        btn_export_xls = ttk.Button(ctrl_frame, text="📊 Xuất Bảng Điểm (.xlsx)", style="Action.TButton", command=self.export_gradebook_action)
        btn_export_xls.grid(row=0, column=2, padx=16)

        info_box = tk.Text(self.content_frame, wrap=tk.WORD, font=("Segoe UI", 10), height=14, bg="#F4F8FE", relief="flat", padx=16, pady=16)
        info_box.pack(fill=tk.BOTH, expand=True)
        info_box.insert(tk.END, """Tính năng Bảng tính Excel tự động:
- Tự động tạo tiêu đề trường, môn học, họ tên giáo viên theo Hồ sơ công tác.
- Bảng danh sách học sinh có sẵn điểm thành phần (TX1, TX2, TX3, Giữa kỳ, Cuối kỳ).
- Tích hợp sẵn công thức Excel tính Điểm trung bình môn chuẩn xác: =ROUND((TX1 + TX2 + TX3 + GK*2 + CK*3)/8, 1).
- Hàng tổng kết tính điểm trung bình cả lớp tự động bằng hàm =AVERAGE().
- Định dạng kẻ viền đơn, tô màu tiêu đề cột xanh hoàng gia bắt mắt, sẵn sàng in ấn hoặc lưu trữ.""")
        info_box.config(state="disabled")

    def export_gradebook_action(self):
        cls_name = self.ent_gb_class.get().strip() or "Lop"
        filename = f"BangDiem_{self.profile.get('subject', '')}_{cls_name}.xlsx".replace(" ", "_")
        out_path = os.path.join(OUTPUT_DIR, filename)

        data = {"class_name": cls_name}
        export_gradebook_xlsx(data, self.profile, out_path)
        messagebox.showinfo("Thành công", f"Đã tạo bảng tính Excel có công thức:\n{out_path}")

    # =========================================================================
    # VIEW 8: MỞ THƯ MỤC FILE XUẤT
    # =========================================================================
    def open_output_folder(self):
        if os.name == 'nt':
            os.startfile(OUTPUT_DIR)
        else:
            subprocess.Popen(['xdg-open', OUTPUT_DIR])

if __name__ == "__main__":
    app = EducationAIAssistantApp()
    app.mainloop()
