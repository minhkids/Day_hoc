# Hệ Thống Trợ Lý AI Giáo Dục & Cổng Quản Trị (Portal)

Hệ thống phần mềm Trí tuệ Nhân tạo thế hệ mới phục vụ chuyển đổi số ngành Giáo dục, bao gồm:
1. **Website Landing Page & Cổng Quản trị Portal** ([portal/](file:///e:/git_hub/Day_hoc/portal)): Giới thiệu giải pháp, quản lý tài khoản cán bộ, đơn vị trường học và cấp mã bản quyền Access Key.
2. **Máy chủ Backend Web & AI Proxy ([server.py](file:///e:/git_hub/Day_hoc/server.py))**: Xây dựng bằng **FastAPI**, cơ sở dữ liệu **SQLite**, đóng vai trò cầu nối bảo mật tuyệt đối cho OpenRouter AI.
3. **Bộ 3 ứng dụng Windows Desktop độc lập (.exe)**: Dành riêng cho Giáo viên, Hiệu trưởng và Chuyên viên QLNN về Giáo dục, hỗ trợ soạn thảo chuẩn Nghị định 30/2020/NĐ-CP và Công văn 5512/BGDĐT.

---

## 🌟 Tính Năng Nổi Bật

- **AI Proxy Server An Toàn**: Người dùng và trường học chỉ sử dụng mã bản quyền **Access Key** (`tv_live_...`). Khóa API gốc (`OPENROUTER_KEY`) được bảo mật tuyệt đối trên server trong file `.env`.
- **Cổng Quản Trị Hệ Thống (Portal Admin)**:
  - Quản lý danh sách tài khoản theo đơn vị trường học, phòng ban.
  - Kích hoạt, tạm khóa tài khoản tức thì.
  - Cấp mã Access Key mới, thu hồi mã bản quyền khi hết hạn.
  - Thống kê lượt gọi và số lượng token AI tiêu thụ.
- **Tương thích đa môi trường**:
  - Chạy máy chủ backend đầy đủ: `python server.py`.
  - Hỗ trợ triển khai tĩnh (GitHub Pages, Netlify, Vercel) với cơ chế Client-Side Admin Auth thông minh.
- **Tài liệu API Swagger tự động**: Truy cập tương tác và kiểm thử API trực quan tại `/docs`.

---

## 🚀 Hướng Dẫn Khởi Chạy Nhanh Backend Web

### 1. Yêu cầu môi trường
- Python 3.10 trở lên.
- Các thư viện Python đã cài đặt:
  ```bash
  pip install fastapi uvicorn requests python-dotenv pydantic
  ```

### 2. Cấu hình biến môi trường (`.env`)
Tạo hoặc chỉnh sửa file `.env` tại thư mục gốc dự án:
```env
OPENROUTER_KEY = <your-openrouter-api-key>
MODEL = nvidia/nemotron-3-super-120b-a12b:free
PROVIDER = nvidia
PORT = 8000
HOST = 0.0.0.0
```

### 3. Lệnh khởi động Server
Từ thư mục gốc dự án, thực hiện lệnh:
```bash
python server.py
```
Hoặc:
```bash
py server.py
```

Khi server khởi động thành công, hệ thống sẽ mở các cổng truy cập:
- **Trang chủ Website**: [http://localhost:8000/](http://localhost:8000/)
- **Cổng Đăng nhập Quản trị**: [http://localhost:8000/portal/login.html](http://localhost:8000/portal/login.html)
- **Bảng Quản trị Hệ thống**: [http://localhost:8000/portal/admin.html](http://localhost:8000/portal/admin.html)
- **Tài liệu API tương tác (Swagger UI)**: [http://localhost:8000/docs](http://localhost:8000/docs)
- **Tài liệu ReDoc**: [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## 🔒 Tài Khoản Đăng Nhập Mặc Định

Khi khởi chạy lần đầu, cơ sở dữ liệu SQLite (`data/portal.db`) sẽ được tự động tạo lập kèm tài khoản quản trị viên hệ thống:

| Vai trò | Email đăng nhập | Mật khẩu mặc định |
| :--- | :--- | :--- |
| **Quản trị viên (Admin)** | `admin@giaoduc.edu.vn` | `admin123` |

*(Trên trang đăng nhập có sẵn nút **"Điền & Đăng nhập ngay"** giúp thử nghiệm nhanh chỉ với 1 click)*.

---

## 📚 Danh Mục RESTful API Chi Tiết

### 1. Xác thực & Quản trị Phiên
- `POST /api/auth/admin/login`: Đăng nhập quản trị viên, cấp token phiên.
  - Body: `{ "email": "admin@giaoduc.edu.vn", "password": "..." }`
- `POST /api/auth/logout`: Đăng xuất và hủy phiên làm việc.
- `GET /api/me`: Lấy thông tin tài khoản đang đăng nhập.

### 2. Quản lý Tài khoản Cán bộ
- `GET /api/admin/accounts`: Lấy danh sách tài khoản (hỗ trợ lọc `q`, `status`, `role`).
- `POST /api/admin/accounts`: Tạo tài khoản mới, tự động cấp 1 Access Key `tv_live_...`.
  - Body: `{ "email": "...", "display_name": "...", "organization_name": "...", "role": "Giáo viên" }`
- `PATCH /api/admin/accounts/{id}/status`: Cập nhật trạng thái `active` (hoạt động) hoặc `inactive` (tạm khóa).
  - Body: `{ "status": "active" | "inactive" }`
- `DELETE /api/admin/accounts/{id}`: Xóa tài khoản khỏi hệ thống.

### 3. Quản lý Access Key Bản Quyền
- `GET /api/admin/keys`: Lấy danh sách toàn bộ Access Key hoặc lọc theo `account_id`.
- `POST /api/admin/accounts/{id}/keys`: Cấp Access Key mới cho đơn vị/tài khoản.
- `POST /api/admin/keys/{id}/revoke`: Thu hồi quyền sử dụng của Access Key.

### 4. AI Chat Proxy Server (OpenRouter)
- `POST /api/ai/chat`: Điểm kết nối AI an toàn dành cho ứng dụng Web và phần mềm Desktop.
  - **Header bắt buộc**: `Authorization: Bearer tv_live_xxxxxxxx` (Mã Access Key của đơn vị).
  - **Body**:
    ```json
    {
      "messages": [
        {"role": "user", "content": "Soạn kế hoạch bài dạy môn Toán lớp 10 theo Công văn 5512."}
      ],
      "temperature": 0.7
    }
    ```
  - **Cơ chế**: Server kiểm tra Access Key và trạng thái tài khoản. Nếu hợp lệ, server tự động đọc `OPENROUTER_KEY` từ file `.env` để gọi mô hình AI và ghi lại số lượng token đã dùng vào cơ sở dữ liệu.

---

## 📁 Cấu Trúc Thư Mục Dự Án (Đã Tối Ưu Gọn Gàng)

```text
Day_hoc/
|-- web/                    # [MỚI] Toàn bộ phân hệ Web gom vào 1 thư mục riêng
|   |-- index.html          # Giao diện Landing Page giới thiệu giải pháp
|   |-- css/                # Stylesheet giao diện hiện đại
|   |-- js/                 # Javascript tương tác
|   |-- portal/             # Cổng Quản trị Hệ thống (Admin & Login)
|   `-- mini_apps/          # Xưởng ứng dụng nhỏ tương tác dạy học
|-- exe/                    # [MỚI] Toàn bộ các file .EXE và bộ cài gom vào 1 thư mục riêng
|   |-- TroLyGiaoVien-Setup.exe          # Bộ cài đặt Trợ lý Giáo viên
|   |-- TroLyHieuTruong-Setup.exe        # Bộ cài đặt Trợ lý Hiệu trưởng
|   |-- TroLyChuyenVien-Setup.exe        # Bộ cài đặt Trợ lý Chuyên viên
|   `-- README.md                        # Hướng dẫn chi tiết từng file .exe
|-- server.py               # Máy chủ Backend Web & AI Proxy (FastAPI)
|-- .env                    # Cấu hình OpenRouter Key, Model AI, Cổng Port
|-- data/
|   `-- portal.db           # Cơ sở dữ liệu SQLite quản trị và lịch sử gọi AI
|-- specialist/             # Mã nguồn Ứng dụng Chuyên viên
|-- teacher/                # Mã nguồn Ứng dụng Giáo viên
|-- school/                 # Mã nguồn Ứng dụng Hiệu trưởng / Quản trị trường
|-- scripts/                # Công cụ đóng gói và tiện ích
`-- README.md               # Tài liệu hướng dẫn sử dụng
```

---

## 🛠️ Đóng Gói Các Ứng Dụng Windows (.EXE) Độc Lập

### 1. Trợ lý Quản trị trường học (Hiệu trưởng / Ban giám hiệu / Tổ chuyên môn)
Ứng dụng desktop độc lập hoàn toàn, không phụ thuộc Claude Code, kết nối OpenRouter AI tốc độ cao, giao diện chuẩn WPF với đầy đủ 16 phân hệ quản trị trường học:
```bash
python school/build.py
```
File thực thi độc lập:
```text
exe/TroLyQuanTriTruongHoc-DocLap/TroLyQuanTriTruongHoc-DocLap.exe
```

### 2. Trợ lý Chuyên viên Quản lý Nhà nước về Giáo dục
Ứng dụng desktop độc lập dành cho cán bộ Sở/Phòng GD&ĐT với phân tách rõ ràng tác vụ dữ liệu và soạn thảo:
```bash
python specialist/build.py
```
File thực thi độc lập:
```text
exe/TroLyChuyenVien-DocLap/TroLyChuyenVien-DocLap.exe
```

---

## 📞 Hỗ Trợ & Liên Hệ
- **Tác giả phát triển**: Thầy Trần Thanh Chung
- **Zalo**: 0913031073
- **Bản quyền**: Hệ thống Trợ lý AI Giáo dục Việt Nam – Mở khóa vĩnh viễn, bảo mật dữ liệu tuyệt đối.
