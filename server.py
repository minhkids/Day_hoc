#!/usr/bin/env python3
"""
HỆ THỐNG BACKEND WEB & AI PROXY SERVER - TRỢ LÝ GIÁO DỤC
- Phục vụ Landing Page và Cổng Quản trị (Portal)
- Quản lý tài khoản, phân quyền và cấp Access Key bản quyền (SQLite)
- Proxy an toàn cho các cuộc gọi AI đến OpenRouter (Bảo mật OpenRouter Key tuyệt đối)
"""

import os
import sys
import json
import sqlite3
import secrets
import hashlib
from datetime import datetime
from pathlib import Path
from typing import Optional, List, Dict, Any

from fastapi import FastAPI, HTTPException, Request, Response, Header, Depends, status
from fastapi.responses import JSONResponse, FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests

# Thư mục gốc dự án
BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(exist_ok=True)
DB_PATH = DATA_DIR / "portal.db"

# Đọc cấu hình từ file .env
def load_env_config():
    env_file = BASE_DIR / ".env"
    config = {
        "OPENROUTER_KEY": "",
        "MODEL": "nvidia/nemotron-3-super-120b-a12b:free",
        "PROVIDER": "nvidia",
        "PORT": 8000,
        "HOST": "0.0.0.0",
        "SECRET_KEY": "troly_giaoduc_secret_key_2026"
    }
    if env_file.exists():
        for line in env_file.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, val = line.split("=", 1)
                config[key.strip()] = val.strip().strip("\"'")
    # Ưu tiên biến môi trường hệ thống
    for k in config:
        if k in os.environ:
            config[k] = os.environ[k]
    return config

CONFIG = load_env_config()

# ===================== DATABASE & SEED =====================
def get_db():
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with get_db() as conn:
        cursor = conn.cursor()
        # Bảng tài khoản cán bộ
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS accounts (
                id TEXT PRIMARY KEY,
                email TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                display_name TEXT,
                organization_name TEXT,
                role TEXT DEFAULT 'Giáo viên',
                status TEXT DEFAULT 'active',
                created_at TEXT,
                last_login_at TEXT
            )
        """)
        # Bảng Access Key bản quyền
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS access_keys (
                id TEXT PRIMARY KEY,
                account_id TEXT NOT NULL,
                key_value TEXT UNIQUE NOT NULL,
                status TEXT DEFAULT 'active',
                created_at TEXT,
                revoked_at TEXT,
                FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE CASCADE
            )
        """)
        # Bảng lịch sử gọi AI và số lượng tokens
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS usage_events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                account_id TEXT,
                model TEXT,
                prompt_tokens INTEGER DEFAULT 0,
                completion_tokens INTEGER DEFAULT 0,
                total_tokens INTEGER DEFAULT 0,
                created_at TEXT
            )
        """)
        # Bảng nhật ký kiểm toán quản trị
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS audit_events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                action TEXT,
                target TEXT,
                details TEXT,
                created_at TEXT
            )
        """)
        conn.commit()

        # Seed dữ liệu mặc định ban đầu nếu bảng accounts rỗng
        cursor.execute("SELECT COUNT(*) as count FROM accounts")
        if cursor.fetchone()["count"] == 0:
            now = datetime.now().strftime("%d/%m/%Y %H:%M")
            # 1. Admin hệ thống
            admin_id = "admin_01"
            cursor.execute("""
                INSERT INTO accounts (id, email, password, display_name, organization_name, role, status, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (admin_id, "admin@giaoduc.edu.vn", "admin123", "Ban Quản Trị Hệ Thống", "Sở / Bộ GD&ĐT", "admin", "active", now))

            # 2. Các tài khoản mẫu chuẩn ngành giáo dục
            sample_users = [
                ("acc_01", "gv.nguyenvanan@thptchuyen.edu.vn", "Giaoduc@2026", "Thầy Nguyễn Văn An", "THPT Chuyên Lê Quý Đôn", "Giáo viên", "active", "tv_live_9f82d1a4e5b7c8a1"),
                ("acc_02", "hieutruong.tranthimai@thcslythuongkiet.edu.vn", "Giaoduc@2026", "Cô Trần Thị Mai", "THCS Lý Thường Kiệt", "Hiệu trưởng", "active", "tv_live_4b7c89a0e1f2d3e4"),
                ("acc_03", "cv.lehoangnam@pgdquan1.edu.vn", "Giaoduc@2026", "Đ/c Lê Hoàng Nam", "Phòng GD&ĐT Quận 1", "Chuyên viên", "active", "tv_live_8a3d5e7f1c2b4a69"),
                ("acc_04", "gv.phamthilan@tieuhocnguyendu.edu.vn", "Giaoduc@2026", "Cô Phạm Thị Lan", "Tiểu học Nguyễn Du", "Giáo viên", "inactive", "tv_live_revoked_7f1c"),
                ("acc_05", "hieutruong.dangquocbao@thptnguyentatthanh.edu.vn", "Giaoduc@2026", "Thầy Đặng Quốc Bảo", "THPT Nguyễn Tất Thành", "Hiệu trưởng", "active", "tv_live_3c6e9a1b4d7f8021"),
            ]
            for u in sample_users:
                cursor.execute("""
                    INSERT INTO accounts (id, email, password, display_name, organization_name, role, status, created_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (u[0], u[1], u[2], u[3], u[4], u[5], u[6], now))
                cursor.execute("""
                    INSERT INTO access_keys (id, account_id, key_value, status, created_at)
                    VALUES (?, ?, ?, ?, ?)
                """, ("key_" + u[0], u[0], u[7], u[6], now))
            conn.commit()

init_db()

# ===================== KHỞI TẠO FASTAPI APP =====================
app = FastAPI(
    title="Trợ Lý Giáo Dục AI - API & Admin Portal",
    description="Hệ thống Backend phục vụ Portal Quản trị, Quản lý tài khoản, Access Key và AI Chat Proxy",
    version="2.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Lưu token phiên trong bộ nhớ
ACTIVE_SESSIONS = {}

# ===================== PYDANTIC MODELS =====================
class LoginRequest(BaseModel):
    email: str
    password: str

class AccountCreateRequest(BaseModel):
    email: str
    password: Optional[str] = "Giaoduc@2026"
    display_name: str
    organization_name: Optional[str] = ""
    role: Optional[str] = "Giáo viên"

class StatusUpdateRequest(BaseModel):
    status: str

def parse_provider(value):
    if not value:
        return None
    if isinstance(value, dict):
        return value
    if isinstance(value, str):
        val = value.strip()
        if not val:
            return None
        parts = val.split("/", 1)
        res = {"order": [parts[0]]}
        if len(parts) > 1 and parts[1]:
            res["quantizations"] = [parts[1]]
        return res
    return None

class AIChatRequest(BaseModel):
    messages: List[Dict[str, Any]]
    model: Optional[str] = None
    provider: Optional[Any] = None
    temperature: Optional[float] = 0.7
    max_tokens: Optional[int] = None
    stream: Optional[bool] = False

class ReleaseUpdateRequest(BaseModel):
    app: str
    latest_version: str
    download_url: str
    changelog: Optional[str] = ""
    mandatory: Optional[bool] = False


# ===================== AUTH HELPERS =====================
def get_current_admin(authorization: Optional[str] = Header(None)):
    if not authorization:
        # Kiểm tra fallback session token đơn giản
        raise HTTPException(status_code=401, detail="Yêu cầu đăng nhập quản trị.")
    token = authorization.replace("Bearer ", "").strip()
    session = ACTIVE_SESSIONS.get(token)
    if not session or session.get("role") != "admin":
        raise HTTPException(status_code=403, detail="Không có quyền truy cập khu vực quản trị.")
    return session

def verify_access_key(authorization: Optional[str] = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Thiếu mã xác thực bản quyền (Access Key).")
    key_val = authorization.replace("Bearer ", "").strip()
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT k.id, k.status as key_status, a.id as account_id, a.status as account_status, a.display_name, a.role
            FROM access_keys k
            JOIN accounts a ON k.account_id = a.id
            WHERE k.key_value = ?
        """, (key_val,))
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=401, detail="Mã Access Key không hợp lệ.")
        if row["key_status"] != "active":
            raise HTTPException(status_code=403, detail="Access Key này đã bị thu hồi hoặc hết hạn.")
        if row["account_status"] != "active":
            raise HTTPException(status_code=403, detail="Tài khoản cán bộ liên kết đang bị tạm khóa.")
        return dict(row)

# ===================== AUTH ENDPOINTS =====================
@app.post("/api/auth/admin/login", tags=["Xác thực"])
def admin_login(req: LoginRequest):
    email = req.email.strip().lower()
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM accounts WHERE LOWER(email) = ? AND role = 'admin'", (email,))
        user = cursor.fetchone()
        if not user or user["password"] != req.password:
            # Fallback admin mặc định nếu chưa đổi
            if email == "admin@giaoduc.edu.vn" and req.password == "admin123":
                token = secrets.token_hex(24)
                ACTIVE_SESSIONS[token] = {"email": email, "role": "admin", "name": "Ban Quản Trị Hệ Thống"}
                return {"ok": True, "token": token, "redirect": "/portal/admin.html", "user": ACTIVE_SESSIONS[token]}
            raise HTTPException(status_code=401, detail="Email hoặc mật khẩu quản trị không đúng.")
        
        if user["status"] != "active":
            raise HTTPException(status_code=403, detail="Tài khoản quản trị viên này đang bị khóa.")
        
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        cursor.execute("UPDATE accounts SET last_login_at = ? WHERE id = ?", (now, user["id"]))
        conn.commit()

        token = secrets.token_hex(24)
        ACTIVE_SESSIONS[token] = {
            "id": user["id"],
            "email": user["email"],
            "role": user["role"],
            "name": user["display_name"]
        }
        return {
            "ok": True,
            "token": token,
            "redirect": "/portal/admin.html",
            "user": ACTIVE_SESSIONS[token]
        }

@app.post("/api/auth/logout", tags=["Xác thực"])
def logout(authorization: Optional[str] = Header(None)):
    if authorization:
        token = authorization.replace("Bearer ", "").strip()
        ACTIVE_SESSIONS.pop(token, None)
    return {"ok": True, "message": "Đã đăng xuất thành công."}

@app.get("/api/me", tags=["Xác thực"])
def get_me(authorization: Optional[str] = Header(None)):
    if authorization:
        token = authorization.replace("Bearer ", "").strip()
        if token in ACTIVE_SESSIONS:
            return {"ok": True, "user": ACTIVE_SESSIONS[token]}
    return {"ok": True, "user": {"role": "guest"}}

# ===================== ADMIN ACCOUNTS ENDPOINTS =====================
@app.get("/api/admin/accounts", tags=["Quản trị Tài khoản"])
def list_accounts(q: Optional[str] = None, status: Optional[str] = None, role: Optional[str] = None):
    with get_db() as conn:
        cursor = conn.cursor()
        query = """
            SELECT a.id, a.email, a.display_name, a.organization_name, a.role, a.status, a.created_at, a.last_login_at,
                   k.id as key_id, k.key_value as key, k.created_at as key_created_at
            FROM accounts a
            LEFT JOIN access_keys k ON a.id = k.account_id AND k.status = 'active'
            WHERE a.role != 'admin'
        """
        params = []
        if status:
            query += " AND a.status = ?"
            params.append(status)
        if role:
            query += " AND a.role = ?"
            params.append(role)
        if q:
            query += " AND (a.email LIKE ? OR a.display_name LIKE ? OR a.organization_name LIKE ?)"
            term = f"%{q}%"
            params.extend([term, term, term])
        
        query += " ORDER BY a.created_at DESC"
        cursor.execute(query, params)
        accounts = [dict(row) for row in cursor.fetchall()]
        return {"ok": True, "accounts": accounts, "total": len(accounts)}

@app.post("/api/admin/accounts", tags=["Quản trị Tài khoản"])
def create_account(req: AccountCreateRequest):
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM accounts WHERE LOWER(email) = ?", (req.email.lower(),))
        if cursor.fetchone():
            raise HTTPException(status_code=400, detail="Địa chỉ email này đã tồn tại trong hệ thống.")
        
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        acc_id = "acc_" + secrets.token_hex(6)
        cursor.execute("""
            INSERT INTO accounts (id, email, password, display_name, organization_name, role, status, created_at)
            VALUES (?, ?, ?, ?, ?, ?, 'active', ?)
        """, (acc_id, req.email.lower(), req.password, req.display_name, req.organization_name, req.role, now))

        # Tự động tạo mã Access Key bản quyền ban đầu
        key_id = "key_" + secrets.token_hex(6)
        key_value = "tv_live_" + secrets.token_hex(8)
        cursor.execute("""
            INSERT INTO access_keys (id, account_id, key_value, status, created_at)
            VALUES (?, ?, ?, 'active', ?)
        """, (key_id, acc_id, key_value, now))

        # Ghi nhật ký audit
        cursor.execute("""
            INSERT INTO audit_events (action, target, details, created_at)
            VALUES ('CREATE_ACCOUNT', ?, ?, ?)
        """, (req.email, f"Tạo tài khoản cán bộ {req.display_name} - {req.organization_name}", now))
        conn.commit()

        return {
            "ok": True,
            "message": "Tạo tài khoản thành công.",
            "account": {
                "id": acc_id,
                "email": req.email,
                "display_name": req.display_name,
                "key": key_value
            }
        }

@app.patch("/api/admin/accounts/{account_id}/status", tags=["Quản trị Tài khoản"])
def update_account_status(account_id: str, req: StatusUpdateRequest):
    if req.status not in ("active", "inactive"):
        raise HTTPException(status_code=400, detail="Trạng thái chỉ có thể là 'active' hoặc 'inactive'.")
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT email, display_name FROM accounts WHERE id = ?", (account_id,))
        acc = cursor.fetchone()
        if not acc:
            raise HTTPException(status_code=404, detail="Không tìm thấy tài khoản.")
        
        cursor.execute("UPDATE accounts SET status = ? WHERE id = ?", (req.status, account_id))
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        cursor.execute("""
            INSERT INTO audit_events (action, target, details, created_at)
            VALUES ('UPDATE_STATUS', ?, ?, ?)
        """, (acc["email"], f"Cập nhật trạng thái thành {req.status}", now))
        conn.commit()
        return {"ok": True, "message": f"Đã chuyển trạng thái tài khoản thành {req.status}."}

@app.delete("/api/admin/accounts/{account_id}", tags=["Quản trị Tài khoản"])
def delete_account(account_id: str):
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT email FROM accounts WHERE id = ?", (account_id,))
        acc = cursor.fetchone()
        if not acc:
            raise HTTPException(status_code=404, detail="Không tìm thấy tài khoản.")
        
        cursor.execute("DELETE FROM access_keys WHERE account_id = ?", (account_id,))
        cursor.execute("DELETE FROM accounts WHERE id = ?", (account_id,))
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        cursor.execute("""
            INSERT INTO audit_events (action, target, details, created_at)
            VALUES ('DELETE_ACCOUNT', ?, 'Xóa tài khoản khỏi hệ thống', ?)
        """, (acc["email"], now))
        conn.commit()
        return {"ok": True, "message": "Đã xóa tài khoản thành công."}

# ===================== ACCESS KEY ENDPOINTS =====================
@app.get("/api/admin/keys", tags=["Quản lý Access Key"])
def list_keys(account_id: Optional[str] = None):
    with get_db() as conn:
        cursor = conn.cursor()
        if account_id:
            cursor.execute("""
                SELECT k.id, k.account_id, k.key_value, k.status, k.created_at, k.revoked_at, a.display_name, a.email
                FROM access_keys k
                JOIN accounts a ON k.account_id = a.id
                WHERE k.account_id = ?
                ORDER BY k.created_at DESC
            """, (account_id,))
        else:
            cursor.execute("""
                SELECT k.id, k.account_id, k.key_value, k.status, k.created_at, k.revoked_at, a.display_name, a.email
                FROM access_keys k
                JOIN accounts a ON k.account_id = a.id
                ORDER BY k.created_at DESC
            """)
        keys = [dict(row) for row in cursor.fetchall()]
        return {"ok": True, "keys": keys}

@app.post("/api/admin/accounts/{account_id}/keys", tags=["Quản lý Access Key"])
def generate_key_for_account(account_id: str):
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT email, display_name FROM accounts WHERE id = ?", (account_id,))
        acc = cursor.fetchone()
        if not acc:
            raise HTTPException(status_code=404, detail="Không tìm thấy tài khoản.")
        
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        # Thu hồi các key active cũ trước khi tạo key mới
        cursor.execute("UPDATE access_keys SET status = 'revoked', revoked_at = ? WHERE account_id = ? AND status = 'active'", (now, account_id))

        key_id = "key_" + secrets.token_hex(6)
        key_val = "tv_live_" + secrets.token_hex(8)
        cursor.execute("""
            INSERT INTO access_keys (id, account_id, key_value, status, created_at)
            VALUES (?, ?, ?, 'active', ?)
        """, (key_id, account_id, key_val, now))

        cursor.execute("""
            INSERT INTO audit_events (action, target, details, created_at)
            VALUES ('GENERATE_KEY', ?, ?, ?)
        """, (acc["email"], f"Cấp key mới {key_val}", now))
        conn.commit()

        return {
            "ok": True,
            "message": "Đã tạo Access Key mới thành công.",
            "key": key_val,
            "created_at": now
        }

@app.post("/api/admin/keys/{key_id}/revoke", tags=["Quản lý Access Key"])
def revoke_key(key_id: str):
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT id, account_id FROM access_keys WHERE id = ? OR key_value = ?", (key_id, key_id))
        key_row = cursor.fetchone()
        if not key_row:
            raise HTTPException(status_code=404, detail="Không tìm thấy Access Key.")
        
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        cursor.execute("UPDATE access_keys SET status = 'revoked', revoked_at = ? WHERE id = ?", (now, key_row["id"]))
        cursor.execute("""
            INSERT INTO audit_events (action, target, details, created_at)
            VALUES ('REVOKE_KEY', ?, 'Thu hồi quyền truy cập của Access Key', ?)
        """, (key_row["account_id"], now))
        conn.commit()
        return {"ok": True, "message": "Đã thu hồi Access Key thành công."}

# ===================== AI CHAT PROXY (OPENROUTER) =====================
@app.post("/api/ai/chat", tags=["AI Proxy"])
def ai_chat_proxy(req: AIChatRequest, auth_data: dict = Depends(verify_access_key)):
    """
    Điểm tiếp nhận AI Proxy:
    - Yêu cầu Header: Authorization: Bearer tv_live_xxx (Access Key của khách hàng)
    - Tự động lấy OPENROUTER_KEY và MODEL từ file .env
    - Khách hàng không bao giờ biết được API Key gốc của OpenRouter
    """
    openrouter_key = CONFIG.get("OPENROUTER_KEY", "").strip()
    if not openrouter_key:
        raise HTTPException(
            status_code=500,
            detail="Hệ thống chưa cấu hình OPENROUTER_KEY trong file .env trên máy chủ."
        )
    
    target_model = req.model or CONFIG.get("MODEL") or "nvidia/nemotron-3-super-120b-a12b:free"

    headers = {
        "Authorization": f"Bearer {openrouter_key}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://trolygiaoduc.edu.vn",
        "X-Title": "Tro Ly Giao Duc AI"
    }

    payload = {
        "model": target_model,
        "messages": req.messages,
        "temperature": req.temperature
    }
    provider_config = req.provider or CONFIG.get("PROVIDER")
    if provider_config:
        parsed_provider = parse_provider(provider_config)
        if parsed_provider:
            payload["provider"] = parsed_provider
    if req.max_tokens:
        payload["max_tokens"] = req.max_tokens

    try:
        resp = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=payload,
            timeout=60
        )
        if not resp.ok:
            error_data = resp.json() if resp.headers.get("content-type", "").startswith("application/json") else {}
            err_msg = error_data.get("error", {}).get("message") or f"OpenRouter lỗi ({resp.status_code}): {resp.text[:150]}"
            raise HTTPException(status_code=resp.status_code, detail=err_msg)
        
        data = resp.json()

        # Lưu thống kê tokens sử dụng
        usage = data.get("usage", {})
        now = datetime.now().strftime("%d/%m/%Y %H:%M")
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO usage_events (account_id, model, prompt_tokens, completion_tokens, total_tokens, created_at)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                auth_data.get("account_id"),
                target_model,
                usage.get("prompt_tokens", 0),
                usage.get("completion_tokens", 0),
                usage.get("total_tokens", 0),
                now
            ))
            conn.commit()

        return data
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=502, detail=f"Không thể kết nối đến OpenRouter API: {str(e)}")

# ===================== APP UPDATE API (AUTO-UPDATER) =====================
VERSIONS_FILE = DATA_DIR / "app_versions.json"

def get_versions_data() -> dict:
    if VERSIONS_FILE.exists():
        try:
            return json.loads(VERSIONS_FILE.read_text(encoding="utf-8"))
        except Exception:
            pass
    return {
        "teacher": {
            "name": "Trợ lý Giáo viên",
            "latest_version": "1.0.7",
            "download_url": "/downloads/TroLyGiaoVien-Setup.exe",
            "changelog": "- Soạn giáo án chuẩn Công văn 5512/BGDĐT.\n- Cập nhật 6 Mini Apps dạy học.",
            "mandatory": False
        },
        "school": {
            "name": "Trợ lý Quản trị trường học (Hiệu trưởng)",
            "latest_version": "1.0.7",
            "download_url": "/downloads/TroLyHieuTruong-Setup.exe",
            "changelog": "- Quản trị hồ sơ nhà trường, kế hoạch năm học.\n- Thể thức chuẩn Nghị định 30/2020.",
            "mandatory": False
        },
        "specialist": {
            "name": "Trợ lý Chuyên viên QLNN Giáo dục",
            "latest_version": "1.0.7",
            "download_url": "/downloads/TroLyChuyenVien-Setup.exe",
            "changelog": "- Soạn thảo công văn, tờ trình chuẩn Nghị định 30/2020.\n- Bộ công cụ PDF thông minh.",
            "mandatory": False
        },
        "preschool": {
            "name": "Trợ lý Giáo viên Mầm non",
            "latest_version": "1.0.4",
            "download_url": "https://github.com/minhkids/Day_hoc/releases/download/v1.0.4/TroLyGiaoVienMamNon-Setup.exe",
            "changelog": "- [MỚI] Tinh gọn giao diện v1.0.4: Loại bỏ phần Chăm sóc trẻ và Tin nhắn phụ huynh, tập trung vào Kế hoạch giáo dục và Hồ sơ trẻ em.\n- Toàn bộ dữ liệu của lớp học được giữ nguyên 100%.\n- Cập nhật trải nghiệm sử dụng nhanh và thuận tiện hơn.",
            "mandatory": False
        }
    }

def save_versions_data(data: dict):
    VERSIONS_FILE.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")

def _parse_version_tuple(v_str: str):
    parts = []
    for p in v_str.strip().lstrip('vV').split('.'):
        num = ''
        for c in p:
            if c.isdigit():
                num += c
            else:
                break
        parts.append(int(num) if num else 0)
    return tuple(parts)

@app.get("/api/updates/check", tags=["Cập nhật ứng dụng"])
def check_app_update(request: Request, app: str, version: str = "1.0.0"):
    """
    Kiểm tra phiên bản ứng dụng Desktop và trả về thông tin cập nhật từ xa.
    - app: 'teacher' | 'school' | 'specialist'
    - version: phiên bản hiện tại của app client (vd: '1.0.0')
    """
    app_key = app.strip().lower()
    versions = get_versions_data()
    if app_key not in versions:
        for k, v in versions.items():
            if k in app_key or app_key in k:
                app_key = k
                break

    info = versions.get(app_key)
    if not info:
        return {
            "app": app,
            "has_update": False,
            "current_version": version,
            "latest_version": version,
            "message": "Không tìm thấy cấu hình cho ứng dụng này."
        }

    latest_ver = info.get("latest_version", version)
    has_update = _parse_version_tuple(latest_ver) > _parse_version_tuple(version)
    download_url = info.get("download_url", "")
    
    # Chuẩn hóa link tải tuyệt đối nếu dùng đường dẫn tương đối
    if download_url.startswith("/"):
        base_url = str(request.base_url).rstrip("/")
        download_url = f"{base_url}{download_url}"

    return {
        "app": app_key,
        "name": info.get("name", app_key),
        "current_version": version,
        "latest_version": latest_ver,
        "has_update": has_update,
        "download_url": download_url,
        "changelog": info.get("changelog", ""),
        "mandatory": info.get("mandatory", False),
        "release_date": info.get("release_date", "")
    }

@app.get("/api/updates/versions", tags=["Cập nhật ứng dụng"])
def list_app_versions():
    """Lấy danh sách tất cả các phiên bản ứng dụng đã cấu hình."""
    return {"ok": True, "versions": get_versions_data()}

@app.post("/api/admin/updates/release", tags=["Cập nhật ứng dụng"])
def release_app_update(req: ReleaseUpdateRequest, admin = Depends(get_current_admin)):
    """Quản trị viên phát hành hoặc cập nhật thông tin phiên bản mới cho ứng dụng."""
    app_key = req.app.strip().lower()
    versions = get_versions_data()
    
    if app_key not in versions:
        versions[app_key] = {
            "name": app_key,
            "latest_version": req.latest_version,
            "download_url": req.download_url,
            "changelog": req.changelog or "",
            "mandatory": req.mandatory or False,
            "release_date": datetime.now().strftime("%Y-%m-%d")
        }
    else:
        versions[app_key]["latest_version"] = req.latest_version
        versions[app_key]["download_url"] = req.download_url
        if req.changelog:
            versions[app_key]["changelog"] = req.changelog
        versions[app_key]["mandatory"] = bool(req.mandatory)
        versions[app_key]["release_date"] = datetime.now().strftime("%Y-%m-%d")

    save_versions_data(versions)
    return {
        "ok": True,
        "message": f"Đã cập nhật phiên bản {req.latest_version} cho {app_key} thành công.",
        "data": versions[app_key]
    }

# ===================== STATIC WEB ROUTING =====================
WEB_DIR = BASE_DIR / "web"
EXE_DIR = BASE_DIR / "exe"

# Phục vụ thư mục web và các phân hệ tĩnh
portal_dir = (WEB_DIR / "portal") if (WEB_DIR / "portal").exists() else (BASE_DIR / "portal")
if portal_dir.exists():
    app.mount("/portal", StaticFiles(directory=str(portal_dir), html=True), name="portal")

mini_apps_dir = (WEB_DIR / "mini_apps") if (WEB_DIR / "mini_apps").exists() else (BASE_DIR / "mini_apps")
if mini_apps_dir.exists():
    app.mount("/mini_apps", StaticFiles(directory=str(mini_apps_dir), html=True), name="mini_apps")

# Phục vụ file .exe (hỗ trợ cả đường dẫn /exe và /downloads)
exe_dir = EXE_DIR if EXE_DIR.exists() else (BASE_DIR / "downloads")
if exe_dir.exists():
    app.mount("/exe", StaticFiles(directory=str(exe_dir)), name="exe")
    app.mount("/downloads", StaticFiles(directory=str(exe_dir)), name="downloads")

for sub_dir in ["css", "js", "images"]:
    dir_path = (WEB_DIR / sub_dir) if (WEB_DIR / sub_dir).exists() else (BASE_DIR / sub_dir)
    if dir_path.exists():
        app.mount(f"/{sub_dir}", StaticFiles(directory=str(dir_path)), name=sub_dir)

@app.get("/", response_class=HTMLResponse, tags=["Trang chủ"])
def serve_home():
    index_file = WEB_DIR / "index.html"
    if not index_file.exists():
        index_file = BASE_DIR / "index.html"
    if index_file.exists():
        return HTMLResponse(content=index_file.read_text(encoding="utf-8"))
    return HTMLResponse("<h1>Trợ lý Giáo dục AI Server</h1><p>Vui lòng kiểm tra file index.html trong thư mục web/.</p>")

@app.get("/index.html", response_class=HTMLResponse, include_in_schema=False)
def serve_index():
    return serve_home()


# ===================== KHỞI CHẠY MAIN =====================
if __name__ == "__main__":
    import uvicorn
    port = int(CONFIG.get("PORT", 8000))
    host = CONFIG.get("HOST", "0.0.0.0")
    print("=" * 65)
    print("🚀 HỆ THỐNG BACKEND WEB & AI PROXY TRỢ LÝ GIÁO DỤC ĐANG KHỞI ĐỘNG...")
    print(f"📡 Địa chỉ Web Landing:      http://localhost:{port}/")
    print(f"🔒 Cổng Quản trị (Portal):    http://localhost:{port}/portal/login.html")
    print(f"📚 Tài liệu API (Swagger UI): http://localhost:{port}/docs")
    print(f"🤖 Model AI mặc định:        {CONFIG.get('MODEL')}")
    print(f"⚙️  AI Provider Routing:      {CONFIG.get('PROVIDER')}")
    print(f"🔑 OpenRouter Key:           {CONFIG.get('OPENROUTER_KEY')[:15]}... (Đã sẵn sàng)")
    print("=" * 65)
    uvicorn.run("server:app", host=host, port=port, reload=True)
