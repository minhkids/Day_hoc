# Tai lieu tong hop Tro ly Chuyen vien Doc lap

## Bổ sung ứng dụng Trợ lý Giáo viên — 21/09/2026

### Cập nhật giao diện WPF theo bản đang cài

- Đã bỏ khỏi bản Giáo viên các mục đăng nhập/cập nhật/cài lại/chẩn đoán Claude Code, hướng dẫn model Claude và thông báo Anthropic. Phần kết nối và quyền riêng tư hiển thị OpenRouter. `teacher/clean_layout.py` áp dụng lại thay đổi này khi build; bộ EXE không kèm script sinh giao diện tham chiếu.

- Bản EXE hiện chạy `teacher/desktop.py` và `teacher/wpf/host.ps1`, thay giao diện Tkinter ban đầu. `teacher/main.py` được giữ làm mã hỗ trợ/xuất tài liệu; không còn là điểm khởi động EXE.
- Bố cục XAML, màu, thẻ chức năng, biểu tượng và logo lấy từ tài nguyên trình bày của `TroLyGV/app/TroLy.ps1`, qua `teacher/prepare_wpf.py`. Không chạy mã cập nhật, bản quyền hoặc Claude Code của ứng dụng gốc.
- Có 16 trang WPF theo bản tham chiếu. Cài đặt giữ bố cục thẻ, đổi trạng thái dịch vụ thành OpenRouter; khai báo hồ sơ và cấu hình mở trong hộp thoại WPF.
- Nối điều hướng, thẻ soạn bài, chủ nhiệm/kiểm tra/hồ sơ, chat bất đồng bộ tối đa 3 việc, đính kèm, bộ nhớ, mẫu riêng, biên tập/xuất Office, danh sách việc, lịch, kho bản nháp, tạo/chạy/ZIP trò chơi, ghép/xoay PDF và sao lưu. Hội thoại giữ trong RAM; nội dung tài liệu/mẫu/bộ nhớ là file ngoài SQLite.
- Các thao tác chỉ thuộc bản tham chiếu như cập nhật Claude, kích hoạt, xem trước WebView2 chưa có; giao diện thông báo rõ khi bấm. Bố cục giống bản cài không đồng nghĩa toàn bộ chức năng gốc đã được tích hợp.
- Kiểm tra: `python teacher/test_wpf_bridge.py`, `python teacher/smoke_wpf.py`, `python teacher/verify_exe.py`. Ảnh từng trang nằm tại `reports/teacher/wpf/`.
- Build vẫn dùng `python teacher/build.py`, xuất cùng đường dẫn EXE Giáo viên. Giữ cả thư mục `_internal` khi chuyển máy.

Thông tin dưới đây ghi lại bản Tkinter ban đầu để giữ lịch sử; cập nhật WPF phía trên là trạng thái mới nhất.

- Đã đọc hướng dẫn cài trên máy: `C:/Users/Admin/AppData/Local/Programs/TroLyGV/app/huong-dan.html`, phiên bản tham chiếu 1.1.1.
- Mã nguồn độc lập: `teacher/main.py`; dùng dịch vụ đọc tài liệu, OpenRouter và xuất Office từ `specialist/core.py`.
- Build: `python teacher/build.py`. Chạy: `dist/TroLyGiaoVien-DocLap/TroLyGiaoVien-DocLap.exe`. Cần giữ cả thư mục `_internal` bên cạnh EXE.
- Dữ liệu riêng: `%LOCALAPPDATA%/TroLyGiaoVienDocLap`; có thể đặt `TROLY_TEACHER_DATA_DIR` khi kiểm thử.
- Có 12 trang: trang chủ, soạn bài, kiểm tra đánh giá, chủ nhiệm, hồ sơ chuyên môn, trò chuyện, công việc, kho tài liệu, mẫu, xưởng phần mềm, tiện ích/sao lưu và cài đặt.
- Hồ sơ gồm trường, tên giáo viên, môn, lớp dạy, lớp chủ nhiệm, địa phương, năm học, cách xưng hô. AI dùng model/key OpenRouter đang cấu hình; không tự chọn model khác.
- Kèm 32 mẫu giáo viên cấp cao nhất và tài liệu tham chiếu trong thư mục templates/giao_vien; 6 mẫu trò chơi mở bằng trình duyệt, sao chép thành dự án riêng và xuất ZIP.
- Bản nháp là file Markdown, SQLite chỉ lưu metadata bản nháp/công việc/hồ sơ; hội thoại giữ trong RAM của phiên. Key nhập trong cài đặt được lưu DPAPI, không nằm trong SQLite.
- Word dùng bố cục bài dạy, không tự thêm quốc hiệu; PowerPoint chia nội dung thành slide chữ; Excel xuất các dòng văn bản. Đây chưa phải bộ biên tập Office đầy đủ hoặc bảng điểm có công thức tự động.
- Có ghép/tách/xoay PDF và sao lưu SQLite nhất quán cùng bản nháp/mẫu/dự án; không sao lưu API key.
- Kiểm thử: `python teacher/test_teacher.py` kiểm tra giao diện, công việc, AI giả lập, bản nháp, Office, PDF, ZIP và sao lưu. Không gọi nhà cung cấp AI trong lần kiểm thử này.
- Kiểm tra EXE: `python teacher/verify_exe.py`; ảnh tại `reports/teacher/exe-home.png`.
- Phạm vi chưa tương đương bản tham chiếu: chưa có Claude Code, WebView2 xem trước, AI tự viết/chạy mã dự án, ba việc đồng thời, OCR, tự cập nhật, bộ nhớ tự học hoặc tự sao lưu hàng ngày. Luồng AI chạy một việc, có hội thoại tiếp nối trong phiên; dự án trò chơi chỉnh sửa qua file hiện có.
- Bản Giáo viên này chưa nối đăng nhập backend/ngrok và heartbeat 30 giây của hệ thống quản trị; cấu hình AI hiện ở máy chạy app. Chưa phải bản phân phối qua backend giấu key/model.


Tai lieu nay gom lich su, luong van hanh, phat hanh, backend tai khoan, co so du lieu va iOffice.


---

# Lich su phat trien

# Lịch sử thiết kế và triển khai dự án Trợ lý Giáo dục

Tài liệu này ghi lại các quyết định và thay đổi chính để tiếp tục phát triển dự án mà không mất ngữ cảnh.

## 1. Sắp xếp lại dự án

Các nhóm file đã được sắp xếp lại:

```text
downloads/       Bộ cài Windows để tải từ website
scripts/         Script đóng gói, triển khai và kiểm tra
archive/         Các thư mục extracted_* từ bộ cài tham chiếu
reports/         Nhật ký sắp xếp và ảnh kiểm tra giao diện
app/             Mã nguồn website/ứng dụng hiện có
specialist/      Ứng dụng Trợ lý Chuyên viên độc lập
dist/            Bản đóng gói chạy thực tế
```

Danh sách file trước và sau khi sắp xếp nằm trong `reports/`.

## 2. Đánh giá bản EXE ban đầu

Bản `TroLyChuyenVien-DocLap.exe` ban đầu chứa đủ mã nguồn đóng gói, tài nguyên WPF và 41 mẫu văn bản. Tuy nhiên khi chạy trực tiếp xuất hiện:

```text
Failed to create parent directory structure.
```

Nguyên nhân là PyInstaller dạng `one-file` phải giải nén vào thư mục `_MEI`; quyền thư mục tạm của môi trường Windows hiện tại không cho phép bootloader tạo cấu trúc con.

## 3. Thiết kế cơ sở dữ liệu

Thiết kế đầy đủ nằm trong:

- [Thiết kế cơ sở dữ liệu](#thiet-ke-co-so-du-lieu) trong tài liệu này.
- `specialist/schema.sql`

Nguyên tắc lưu trữ đã chốt:

- SQLite chỉ lưu metadata, quan hệ, trạng thái và nhật ký.
- Không lưu nội dung DOCX/PDF/XLSX.
- Không lưu file nhị phân trong SQLite.
- Không lưu API key trong SQLite.
- Không lưu nội dung hội thoại AI mặc định.
- File thật nằm ngoài database; SQLite chỉ giữ đường dẫn, loại file, kích thước và SHA-256.

Các nhóm bảng chính gồm người dùng, cơ quan, đơn vị, công việc, văn bản đến, báo cáo, mẫu, phiên bản, tệp, hội thoại, bộ nhớ và nhật ký.

## 4. Thiết kế iOffice

Phần iOffice được thiết kế theo hướng người dùng ít thao tác:

```text
Đồng bộ iOffice
→ chọn văn bản
→ tạo việc
→ giao xử lý
→ soạn Word/PowerPoint/Excel
→ lưu bản sao
→ mở hồ sơ trên iOffice
→ người dùng xác nhận gửi/ký/phê duyệt
→ hoàn tất
```

Các bảng iOffice gồm:

- `ioffice_connections`: địa chỉ, cơ quan, adapter và trạng thái kết nối.
- `ioffice_documents`: metadata văn bản từ xa.
- `ioffice_assignments`: thông tin giao xử lý.
- `ioffice_sync_runs`: lịch sử đồng bộ, số bản ghi và lỗi.

Mật khẩu/token iOffice không lưu trong SQLite. Khi chưa có API chính thức, ứng dụng chỉ mở iOffice bằng trình duyệt và không tự động gửi, ký hoặc phê duyệt.

## 5. Giao diện giống Office

Thiết kế giao diện chi tiết nằm trong phần [Thiết kế giao diện iOffice](#thiet-ke-giao-dien-ioffice).

Các thành phần chính:

- Ribbon giống Word/PowerPoint/Excel.
- Điều hướng bên trái.
- Khu vực làm việc trung tâm.
- Ngăn thông tin hồ sơ bên phải.
- Thanh trạng thái đồng bộ.
- Tìm kiếm chung bằng `Ctrl+E`.
- Thu gọn Ribbon bằng `Ctrl+F1`.
- Bật/tắt ngăn thông tin bằng `F4`.

## 6. Tích hợp soạn thảo

Trình biên tập nội bộ hiện có các chức năng:

- Mở nội dung dự thảo từ AI hoặc thư viện văn bản.
- Chỉnh sửa tiêu đề và nội dung.
- Lưu bản nháp.
- Xuất Word, PowerPoint, Excel và Markdown.
- Mở iOffice ngay từ cửa sổ biên tập bằng nút `Mở iOffice`.
- Hiển thị rõ việc gửi/ký/phê duyệt vẫn do người dùng xác nhận trên iOffice.

Phần này được triển khai trong `specialist/wpf/host.ps1`.

## 7. Cách đóng gói hiện tại

Không dùng bản one-file vì lỗi giải nén `_MEI`. Bản hiện tại dùng PyInstaller `--onedir`:

```text
dist/
└─ TroLyChuyenVien-DocLap/
   ├─ TroLyChuyenVien-DocLap.exe
   ├─ _internal/
   ├─ wpf/
   └─ reference-templates/
```

Chạy đóng gói bằng:

```powershell
python specialist/build.py
```

Chạy kiểm thử EXE bằng:

```powershell
python specialist/verify_exe.py
```

Chạy kiểm thử giao diện WPF bằng:

```powershell
python specialist/smoke_wpf.py
```

## 8. Trạng thái kiểm thử gần nhất

Các kiểm thử gần nhất đạt:

```text
EXE dạng thư mục mở được cửa sổ chính.
41 mẫu văn bản được khởi tạo.
Ứng dụng thoát sạch.
15 trang WPF hoạt động.
Tạo và hoàn tất công việc hoạt động.
Cấu hình được lưu.
Gọi AI giả lập qua HTTP hoạt động.
Không có lỗi dispatcher.
```

## 9. Việc còn lại

- Viết adapter API thật cho iOffice của từng cơ quan.
- Thay lớp `Store` cũ dùng `records(kind, id, payload)` bằng schema chuẩn hóa.
- Chuyển nội dung bản nháp và mẫu ra file ngoài, chỉ lưu metadata trong SQLite.
- Bổ sung migration dữ liệu cũ.
- Bổ sung đồng bộ hai chiều với xử lý xung đột.
- Kiểm thử trên máy Windows sạch và quyền người dùng tiêu chuẩn.

## 10. Nguyên tắc khi tiếp tục phát triển

- Không tự động gửi, ký hoặc phê duyệt hồ sơ.
- Không đưa nội dung tài liệu hoặc API key vào SQLite.
- Luôn giữ đường dẫn file tương đối, MIME type, kích thước và checksum.
- Mọi thay đổi schema phải có migration và tăng `PRAGMA user_version`.
- Sau mỗi thay đổi lớn, chạy cả `test_core.py`, `test_desktop.py`, `smoke_wpf.py` và `verify_exe.py`.

## 11. Cau hinh OpenRouter tu .env

- Ung dung doc `OPENROUTER_KEY` (hoac `OPENROUTER_API_KEY`) va `MODEL` (hoac `OPENROUTER_MODEL`) tu `.env`.
- Key chi duoc doc tai thoi diem chay; khong ghi vao SQLite va khong hien gia tri trong giao dien/log.
- Cau hinh da luu trong ung dung duoc uu tien hon `.env`; file `.env` co the dat tai thu muc du an, canh EXE hoac thu muc hien hanh.
- Da kiem tra goi that den OpenRouter bang dung model trong `.env`: thanh cong.



---

# Luồng hiện tại

# Luong hien tai cua Tro ly Chuyen vien Doc lap

Tai lieu nay ghi lai luong dang co trong ban EXE hien tai va ranh gioi giua che do cuc bo voi kien truc backend multi-tenant.

## 1. Khoi dong EXE

1. Nguoi dung chay `dist/TroLyChuyenVien-DocLap/TroLyChuyenVien-DocLap.exe`.
2. PyInstaller mo ban `onedir`, khong can cai Python.
3. EXE khoi tao bridge HTTP chi lang nghe tren `127.0.0.1`.
4. Bridge tao token ngau nhien cho rieng phien chay.
5. WPF host nhan `TROLY_BRIDGE_URL` va `TROLY_BRIDGE_TOKEN` tu tien trinh cha.
6. Moi request giua WPF va bridge deu gui `X-TroLy-Token`.

## 2. Dang nhap backend

1. Neu co `AUTH_URL` trong `.env` hoac bien moi truong `TROLY_AUTH_URL`, EXE hien man hinh dang nhap WPF.
2. Nguoi dung nhap email va mat khau.
3. EXE goi `POST {AUTH_URL}/api/auth/login` qua HTTPS.
4. Backend tra ve `access_token` hoac `token`.
5. EXE gan token vao header `Authorization: Bearer ...` cho cac request tiep theo.
6. Neu dang nhap that bai, EXE khong mo giao dien chinh.
7. Neu khong cau hinh `AUTH_URL`, EXE bo qua dang nhap va chay che do cuc bo hien tai.

## 3. Khoi tao du lieu cuc bo

1. Bridge mo SQLite tai `%LOCALAPPDATA%\\TroLyChuyenVienDocLap\\du-lieu.sqlite3` (hoac `TROLY_DATA_DIR`).
2. Tao cac thu muc du lieu tai may nguoi dung.
3. Nap 41 mau van ban tham chieu neu chua co.
4. Du lieu cong viec, ho so, mau va lich su thao tac duoc luu tren may.
5. File tai lieu duoc giu ngoai SQLite; SQLite chi luu metadata/tham chieu theo thiet ke.

## 4. Cac thao tac WPF

WPF hien thi cac trang Trang chu, Tro chuyen, Cong viec, Lich, Thu vien, Mau, Van ban den, Don vi, Kiem tra, Tra cuu va Cai dat.

WPF goi bridge cho cac thao tac:

- `state`: doc trang thai va du lieu hien tai.
- `settings`: luu ho so cau hinh.
- `save` / `delete`: luu hoac xoa ban ghi.
- `read` / `import`: doc va nhap tai lieu tu may.
- `export`: xuat Word, PowerPoint, Excel.
- `chat_start` / `chat_poll` / `chat_cancel`: tao, theo doi va huy yeu cau AI.

## 5. Cau hinh AI hien tai

Trong che do cuc bo, `core.py` doc:

- `OPENROUTER_KEY` hoac `OPENROUTER_API_KEY`.
- `MODEL` hoac `OPENROUTER_MODEL`.
- `OPENROUTER_ENDPOINT` hoac `OPENROUTER_BASE_URL`.

Key tu `.env` chi duoc doc tai thoi diem chay va khong luu vao SQLite. Neu nguoi dung luu key qua giao dien Cai dat, key duoc bao ve bang Windows DPAPI trong `api-key.dpapi`.

## 6. Luong AI hien tai

1. Nguoi dung nhap yeu cau, co the dinh kem file.
2. WPF gui cong viec AI cho bridge localhost.
3. Bridge doc ho so, bo nho va van ban duoc phep doc.
4. `core.ask_ai` gui request den provider da cau hinh, hien tai co OpenRouter/Gemini/Claude/API tuong thich.
5. Ket qua duoc luu vao lich su chat cuc bo neu thao tac thanh cong.
6. Nguoi dung co the chinh sua, luu va xuat Word/PowerPoint/Excel.

## 7. Trang thai kien truc backend

Đã có [thiết kế backend tài khoản](#thiet-ke-backend-tai-khoan) và giao diện đăng nhập trong EXE. Backend cần cung cấp tối thiểu:

- `POST /api/auth/login`.
- Quan ly tai khoan, phien dang nhap va access key rieng.
- Hash access key, thu hoi key, gioi han luu luong va audit log.
- `POST /api/ai/chat` de giu OpenRouter key/model tren server.

Trong ban hien tai, token dang nhap da duoc gan vao client WPF, nhung luong AI van dang goi `core.ask_ai` tu bridge cuc bo. Muon an tuyet doi OpenRouter key/model, can noi tiep `chat_start` cua bridge sang endpoint `/api/ai/chat` cua backend va loai bo OpenRouter key khoi may khach hang.

## 8. Kiem thu da chay

- `python specialist/test_core.py`.
- `python specialist/test_desktop.py`.
- `python specialist/smoke_wpf.py`.
- `python specialist/verify_exe.py`.
- Goi OpenRouter thuc te bang model trong `.env` da thanh cong.

## 9. Cach phat hanh hien tai

Chỉ gửi thư mục `dist/TroLyChuyenVien-DocLap/`. Không gửi `.env`, mã nguồn, SQLite phát triển hoặc `api-key.dpapi`. Xem [hướng dẫn phát hành](#huong-dan-phat-hanh) trong tài liệu này.



---

# Huong dan phat hanh

# Phat hanh EXE an toan

## Ban gui cho khach hang

Chi gui toan bo thu muc `dist/TroLyChuyenVien-DocLap/`. Khong gui file `.env`, file `api-key.dpapi`, thu muc du an, thu muc `specialist`, hoac file SQLite trong `%LOCALAPPDATA%`.

Khach hang mo EXE, vao **Cai dat**, chon OpenRouter, nhap model va API key cua chinh ho, sau do bam **Luu cai dat**. Key duoc bao ve bang Windows DPAPI theo tai khoan Windows cua khach hang.

## Kiem tra truoc khi gui

```powershell
python specialist/build.py
python specialist/verify_exe.py
Test-Path dist/TroLyChuyenVien-DocLap/.env # phai la False
```

Khong dua key that vao `--add-data` cua PyInstaller. File `.env` chi dung cho moi truong phat trien noi bo va khong duoc copy vao thu muc phat hanh.

## Neu muon an ca model va dung chung mot key

Khong goi OpenRouter truc tiep tu EXE. Can mot backend trung gian do ban quan ly: EXE gui yeu cau den backend, backend giu key va model trong secret store roi goi OpenRouter. Khi do key va model khong nam trong EXE, nhung backend phai co xac thuc nguoi dung, gioi han luu luong va theo doi chi phi.



---

# Thiet ke backend tai khoan

# Kien truc tai khoan va khoa truy cap

## Mo hinh

EXE khong chua OpenRouter key va khong goi OpenRouter truc tiep:

```text
EXE -> API backend cua chu he thong -> OpenRouter
```

Moi tai khoan co mot hoac nhieu access key rieng. Backend chi luu `key_hash`, khong luu khoa day du sau khi cap. OpenRouter key va model nam trong secret manager cua backend.

## Bang du lieu backend

- `accounts`: `id`, `email`, `password_hash`, `display_name`, `status`, `created_at`, `last_login_at`.
- `organizations`: don vi/khach hang, lien ket qua `account_organizations`.
- `access_keys`: `id`, `account_id`, `prefix`, `key_hash`, `label`, `scopes_json`, `expires_at`, `last_used_at`, `revoked_at`, `created_at`.
- `usage_events`: `id`, `account_id`, `request_id`, `model_alias`, `input_tokens`, `output_tokens`, `status`, `created_at`. Chi luu thong ke, khong luu noi dung prompt/answer.
- `refresh_sessions`: `id`, `account_id`, `token_hash`, `expires_at`, `revoked_at`, `created_at`, `last_seen_at`.
- `audit_events`: thao tac dang nhap, cap khoa, thu hoi khoa, doi mat khau.

Mat khau dung Argon2id. Access key hien mot lan khi cap, dang `tv_live_<random>`. Moi request dung `Authorization: Bearer ...`; backend hash khoa de tra cuu, kiem tra status/expiry/scope va gioi han luu luong.

## API toi thieu

- `POST /api/auth/login` -> access token phien ngan han trong HttpOnly Secure SameSite cookie.
- `POST /api/auth/logout` -> thu hoi refresh session.
- `POST /api/keys` -> cap khoa moi, tra plaintext duy nhat mot lan.
- `GET /api/keys` -> chi tra prefix, nhan, ngay dung, trang thai.
- `POST /api/keys/:id/revoke` -> thu hoi ngay.
- `POST /api/ai/chat` -> backend gan model noi bo, goi OpenRouter, tra ket qua.
- `GET /api/me` -> thong tin tai khoan va quyen.

Khong cho phep client gui tuy y `endpoint`, `model`, hoac OpenRouter key. Backend dung model alias noi bo, vi du `fast` -> model that trong secret manager.

## Luong cap phat

1. Quan tri vien tao tai khoan va gui lien ket dat mat khau mot lan.
2. Khach dang nhap tren trang web.
3. Backend cap session cookie; EXE dung session/token cua tai khoan de goi backend.
4. Quan tri vien co the xem prefix, gioi han, lan dung cuoi va thu hoi khoa ma khong doc duoc plaintext.

Khong dung localStorage cho refresh token. Bat buoc HTTPS, CSRF protection cho cookie, rate limit dang nhap, khoa tam thoi sau nhieu lan sai va log audit khong chua secret.

## Trang quan tri tai khoan

Giao dien `portal/admin.html` dung cac endpoint quan tri:

- `GET /api/admin/accounts` -> `{ accounts: [...] }` voi `id`, `email`, `display_name`, `organization_name`, `status`, `last_login_at`.
- `PATCH /api/admin/accounts/:id/status` voi `{ "status": "active" | "inactive" }`.
- `GET /api/admin/keys?account=:id` -> danh sach key chi hien prefix/trang thai.
- `POST /api/admin/accounts` -> tao tai khoan.
- `POST /api/admin/accounts/:id/keys` -> cap key moi va chi hien plaintext mot lan.
- `POST /api/admin/keys/:id/revoke` -> thu hoi key.

Tat ca endpoint `/api/admin/*` phai yeu cau session cua quan tri vien va scope `accounts:manage`. Moi thay doi status phai ghi `audit_events`.

## Phan quyen dang nhap admin

- `portal/login.html` chi danh cho quan tri vien va goi `POST /api/auth/admin/login`.
- Backend bat buoc kiem tra `account.role = admin` va `account.status = active`; tai khoan khach hang phai bi tu choi voi HTTP 403.
- Session admin phai co scope `accounts:manage` moi duoc truy cap `/admin.html` va `/admin-account-new.html`.
- `POST /api/admin/accounts` tao tai khoan khach hang voi role `customer`, khong cho client tu gui role `admin`.
- Viec kich hoat, vo hieu hoa, cap va thu hoi key deu phai kiem tra quyen o server va ghi audit log.



---

# Thiet ke co so du lieu

# Thiết kế cơ sở dữ liệu cho Trợ lý Chuyên viên Giáo dục

## 1. Phạm vi và nguyên tắc

Thiết kế này bao phủ luồng:

`tiếp nhận văn bản → phân loại → giao việc → xử lý/soạn thảo → xin ý kiến → hoàn tất → lưu trữ/báo cáo`.

Ngoài ra, hệ thống quản lý đơn vị và đợt báo cáo, mẫu văn bản, hội thoại AI, bộ nhớ cơ quan, tệp đính kèm, kết nối iOffice và nhật ký thao tác.

- Dùng SQLite cho bản desktop hiện tại; có thể chuyển sang PostgreSQL mà không đổi mô hình nghiệp vụ.
- Mỗi bảng có khóa UUID dạng TEXT để đồng bộ và khôi phục từ bản sao lưu.
- Không lưu API key dạng rõ trong database. Khóa được mã hóa bằng Windows DPAPI trong tệp riêng hoặc kho bí mật của máy chủ.
- Database không lưu nội dung DOCX/PDF/XLSX, nội dung hội thoại, nội dung mẫu/bộ nhớ hay blob nhị phân. Tệp nằm trên filesystem/object storage; database chỉ lưu metadata, đường dẫn tương đối, kích thước và checksum.
- Không xóa vật lý hồ sơ nghiệp vụ quan trọng; dùng `deleted_at` hoặc trạng thái lưu trữ.
- Thời gian lưu UTC dạng ISO-8601; giao diện đổi sang giờ Việt Nam.

## 2. Các bảng chính

| Bảng | Vai trò | Quan hệ quan trọng |
|---|---|---|
| `users` | Người dùng hệ thống | thuộc một `organizations` hoặc nhiều `user_organizations` |
| `organizations` | Cơ quan/chủ quản | có nhiều `units`, `users`, `memories` |
| `units` | Đơn vị trực thuộc | nhận báo cáo, có đầu mối |
| `reporting_cycles` | Đợt báo cáo | thuộc cơ quan, có nhiều `submissions` |
| `submissions` | Hồ sơ nộp báo cáo | nối `reporting_cycles`, `units`, `files` |
| `incoming_documents` | Văn bản đến | sinh ra `tasks`, có `files` và liên kết nguồn |
| `tasks` | Công việc xử lý | có người giao/phụ trách, hạn, trạng thái, nguồn văn bản |
| `documents` | Dự thảo/văn bản đã lưu | có phiên bản, tệp xuất và nguồn |
| `document_versions` | Lịch sử chỉnh sửa metadata | thuộc một `document`, trỏ tới tệp đã lưu |
| `templates` | Mẫu/quy trình | có nhiều `template_versions` |
| `conversations` | Phiên trò chuyện AI | có nhiều `messages`, có thể gắn hồ sơ nghiệp vụ |
| `messages` | Metadata lượt gọi AI | lưu trạng thái, lỗi và token; nội dung để ở tệp ngoài nếu cần lưu |
| `memories` | Bộ nhớ cơ quan | được đưa vào ngữ cảnh AI |
| `files` | Metadata tệp | dùng chung cho văn bản, báo cáo, tin nhắn và phiên bản |
| `audit_logs` | Nhật ký thao tác | phục vụ truy vết và hỗ trợ người dùng |
| `ioffice_connections` | Cấu hình kết nối iOffice | chỉ lưu URL, tên kết nối và mã tham chiếu credential |
| `ioffice_documents` | Bản sao metadata từ iOffice | không lưu nội dung; có mã từ xa và liên kết mở trên trình duyệt |
| `ioffice_assignments` | Việc giao/xử lý trên iOffice | theo dõi người nhận, hạn và trạng thái từ xa |
| `ioffice_sync_runs` | Lịch sử đồng bộ | hỗ trợ đồng bộ lại, xem lỗi và chống trùng |

Các bảng tra cứu nên dùng mã ổn định: `document_statuses`, `task_statuses`, `document_types`, `memory_groups`. Với SQLite bản đầu, có thể dùng `CHECK` thay cho bảng tra cứu.

## 3. Luồng dữ liệu

1. Tạo `incoming_documents`, thêm tệp vào `files`, sau đó tạo một hoặc nhiều `tasks`.
2. Người phụ trách cập nhật `tasks`; khi cần soạn văn bản, tạo `documents` với `source_incoming_id` hoặc `source_task_id`.
3. Mỗi lần lưu nội dung tạo `document_versions`; bản hiện hành được trỏ bởi `documents.current_version_id`.
4. Gửi yêu cầu AI tạo `conversations` và `messages`; kết quả AI chỉ là nội dung đề xuất cho người dùng duyệt.
5. Khi nhận báo cáo, tạo `submissions` theo `reporting_cycles` và `units`; tệp thực tế nối qua `files`.
6. Mọi thao tác tạo/sửa/xóa/trạng thái ghi vào `audit_logs`.

## 3a. Luồng iOffice thuận tiện cho người dùng

1. **Cấu hình một lần:** người dùng nhập địa chỉ iOffice, chọn cơ quan và bấm `Kiểm tra kết nối`. Mật khẩu/token đi vào Windows Credential Manager hoặc kho bí mật của máy, chỉ lưu `credential_ref` trong database.
2. **Trang tổng quan:** hiển thị số văn bản mới, sắp đến hạn, đã giao và lỗi đồng bộ; có nút `Đồng bộ ngay` và thời điểm đồng bộ cuối.
3. **Danh sách hợp nhất:** văn bản iOffice và văn bản nhập thủ công dùng chung màn hình. Lọc theo số hiệu, ngày, đơn vị, trạng thái và hạn; dữ liệu chỉ là metadata.
4. **Mở đúng hồ sơ:** nút `Mở trên iOffice` dùng deep-link đã lưu; nút `Tải bản sao` chỉ tải file ra thư mục dữ liệu, không đưa nội dung vào SQLite.
5. **Giao việc nhanh:** từ một văn bản bấm `Tạo việc`, hệ thống điền sẵn tiêu đề, số hiệu, nguồn, hạn và người nhận; người dùng chỉ xác nhận trước khi gửi.
6. **Theo dõi hai chiều:** trạng thái giao việc và hạn được cập nhật khi đồng bộ; xung đột được đưa vào hàng chờ để người dùng chọn giữ bản iOffice hay bản cục bộ.
7. **Không làm mất dữ liệu:** đồng bộ tăng dần theo `remote_updated_at`, chống trùng bằng `(connection_id, remote_id)`, có nút `Thử lại` cho từng lỗi và nhật ký đầy đủ.
8. **Dự phòng an toàn:** nếu iOffice không có API, dùng adapter trình duyệt mở trang và hướng dẫn người dùng thao tác; không tự động bấm gửi, ký hoặc phê duyệt khi chưa có API chính thức.

## 4. Chuyển từ bảng `records` hiện tại

Bản hiện tại lưu `kind` và JSON trong `records`. Khi nâng cấp:

- `profile` → `organizations` + `users` + `user_organizations`.
- `task` → `tasks`.
- `unit` → `units`.
- `cycle` → `reporting_cycles`.
- `submission` → `submissions`.
- `incoming` → `incoming_documents`.
- `document` → `documents` và `document_versions`; nội dung cũ chuyển thành tệp ngoài, không đưa vào SQLite.
- `template` → `templates` và `template_versions`.
- `memory` → `memories`.
- `chat` → `conversations` và `messages`.

Migration phải chạy trong transaction, giữ lại `legacy_record_id` để đối chiếu và chỉ đánh dấu hoàn tất sau khi đếm số bản ghi/tệp khớp.

## 5. Quy tắc nghiệp vụ cần enforce

- `tasks.due_date` không được nhỏ hơn `created_at` nếu công việc chưa hoàn thành.
- Một `submission` duy nhất cho cặp `(cycle_id, unit_id)`; cho phép nộp lại bằng `version_no`.
- Không cho xóa `unit`, `cycle`, `incoming_document` nếu còn hồ sơ liên quan; chuyển sang `archived`.
- `document_versions.version_no` tăng tuần tự trong từng tài liệu.
- Chỉ tin nhắn `assistant` ở trạng thái `completed` mới được coi là câu trả lời thành công.
- Tệp phải có `sha256`, kích thước, MIME type và đường dẫn tương đối; không tin tên tệp do người dùng gửi.
- Không đưa nội dung tài liệu hoặc API key vào các cột JSON/`TEXT` của database.
- Các trường mô tả ngắn như tiêu đề, số hiệu, trạng thái và ngày tháng được phép lưu; phần nội dung đầy đủ phải là file ngoài.
- Nếu cần lưu hội thoại AI, lưu từng lượt vào file mã hóa ngoài database và chỉ giữ `content_file_id`; mặc định có thể không lưu.
- Tất cả truy vấn theo tổ chức phải lọc `organization_id`; đây là ranh giới dữ liệu khi thêm nhiều người dùng.

Schema SQL triển khai ban đầu nằm trong [`schema.sql`](schema.sql).



---

# Thiet ke giao dien iOffice

# Thiết kế giao diện iOffice theo cách dùng Word, PowerPoint và Excel

## Mục tiêu

Người dùng đã quen Microsoft Office có thể mở iOffice và làm việc ngay, không phải học lại quy trình. Giao diện dùng một cửa sổ chính, thanh Ribbon, khu vực làm việc trung tâm và ngăn thông tin bên phải.

## Bố cục cửa sổ chính

```text
┌ Menu nhanh ─ Tìm kiếm ─ Đồng bộ ─ Trợ giúp ─ Hồ sơ người dùng ┐
├ Ribbon: Trang chủ | Văn bản | Giao việc | Báo cáo | Xem | Kết nối ┤
├ Điều hướng        ┌ Khu vực làm việc chính ┐  Ngăn thông tin     ┤
│ - Tổng quan       │ Tab văn bản/bảng/slide │  - Hạn xử lý        │
│ - Văn bản đến     │                         │  - Người phụ trách  │
│ - Văn bản đi      │                         │  - Lịch sử          │
│ - Giao việc       └─────────────────────────┘  - Tệp liên quan    │
│ - Báo cáo                                                        │
└ Thanh trạng thái: kết nối | đồng bộ cuối | số mục chọn | zoom ┘
```

Điều hướng bên trái có thể thu gọn bằng `Ctrl+F1`. Ngăn bên phải có thể bật/tắt bằng `F4`. Mọi màn hình đều có ô tìm kiếm chung `Ctrl+E`.

## Ribbon

### Trang chủ

`Văn bản mới` · `Mở tệp` · `Lưu bản sao` · `Tạo việc` · `Giao xử lý` · `Đồng bộ iOffice` · `Hoàn tác` · `Làm lại`.

### Văn bản

`Văn bản đến` · `Văn bản đi` · `Dự thảo` · `Mẫu` · `Mở trên iOffice` · `Tải bản sao` · `In` · `Xuất PDF`.

### Giao việc

`Giao việc mới` · `Chuyển xử lý` · `Xin ý kiến` · `Đặt hạn` · `Nhắc hạn` · `Hoàn tất` · `Lịch sử xử lý`.

### Báo cáo

`Đợt báo cáo mới` · `Nhận báo cáo` · `Theo dõi đơn vị chưa nộp` · `Tổng hợp` · `Xuất Excel`.

### Xem

`Danh sách` · `Chi tiết` · `Lưới` · `Toàn màn hình` · `Thu gọn điều hướng` · `Thu gọn ngăn thông tin`.

### Kết nối

`Kết nối iOffice` · `Đồng bộ ngay` · `Lịch sử đồng bộ` · `Cài đặt tài khoản`.

## Trình xem văn bản

Màn hình văn bản dùng bố cục giống Word:

- Tab tài liệu ở phía trên để mở nhiều hồ sơ.
- Thanh công cụ định dạng tối thiểu: phông, cỡ chữ, đậm/nghiêng/gạch chân, căn lề, đánh số và tìm kiếm.
- Khu vực xem trước ở giữa; nội dung thật mở từ file ngoài hoặc từ iOffice, không lưu vào SQLite.
- Ngăn `Thông tin văn bản` bên phải: số hiệu, ngày, người gửi, hạn, trạng thái, người xử lý.
- Thanh hành động cố định: `Tạo việc`, `Giao xử lý`, `Mở iOffice`, `Tải bản sao`, `Đóng hồ sơ`.

Khi người dùng đóng văn bản, chỉ lưu trạng thái và đường dẫn file. Nếu file đã bị di chuyển, hiện nút `Định vị lại tệp` thay vì báo lỗi mơ hồ.

## Trình soạn thảo Word

Không xây một trình soạn thảo Word đầy đủ ngay từ đầu. Dùng ba chế độ để dễ triển khai:

1. `Xem nhanh`: mở DOCX/PDF bằng ứng dụng mặc định.
2. `Soạn dự thảo`: dùng trình soạn thảo nội bộ cho nội dung ngắn, lưu ra DOCX/Markdown ở thư mục ngoài.
3. `Chỉnh sửa nâng cao`: nút mở bằng Microsoft Word hoặc LibreOffice.

Ứng dụng luôn hiển thị nhãn `Dự thảo – cần kiểm tra trước khi ban hành` và yêu cầu xác nhận trước thao tác gửi/ký.

## Trình bày PowerPoint

Màn hình trình chiếu có ba vùng như PowerPoint:

```text
┌ Danh sách slide ┐ ┌ Slide hiện tại ┐ ┌ Thuộc tính ┐
│ 1. Tiêu đề      │ │                 │ │ Bố cục     │
│ 2. Nội dung     │ │     Canvas      │ │ Tiêu đề    │
│ 3. Kết luận     │ │                 │ │ Ghi chú    │
└─────────────────┘ └─────────────────┘ └────────────┘
```

Có `Thêm slide`, `Nhân bản`, `Xóa`, `Đổi bố cục`, `Di chuyển lên/xuống`, `Trình chiếu` và `Xuất PPTX`. Bản đầu chỉ cần tiêu đề, nội dung, ghi chú và bố cục; hiệu ứng nâng cao có thể mở bằng PowerPoint.

## Trình bảng Excel

Màn hình bảng dùng các thao tác quen thuộc:

- Lưới hàng/cột có tiêu đề cố định.
- Dán nhiều ô từ clipboard.
- Sắp xếp, lọc, tìm kiếm, đổi tên cột và cố định hàng đầu.
- Kiểm tra dữ liệu trước khi gửi báo cáo.
- Nút `Tải mẫu Excel`, `Nhập bảng`, `Xuất Excel`.
- Không thực thi công thức lạ; file xuất được tạo ở thư mục ngoài.

Tổng hợp báo cáo hiển thị dạng bảng trước, sau đó người dùng bấm `Xuất Excel`. Không tự gửi dữ liệu lên iOffice nếu chưa xác nhận.

## Luồng thao tác ngắn nhất

1. Bấm `Đồng bộ iOffice`.
2. Chọn một văn bản trong danh sách.
3. Bấm `Tạo việc`; hệ thống tự điền số hiệu, tiêu đề và hạn.
4. Chọn người phụ trách rồi bấm `Giao xử lý`.
5. Soạn Word, PowerPoint hoặc Excel ở tab tương ứng.
6. Bấm `Lưu bản sao` và `Mở iOffice` để người dùng tự kiểm tra, ký hoặc gửi.
7. Sau khi xử lý, bấm `Hoàn tất`; trạng thái được đồng bộ ở lần kế tiếp.

## Nguyên tắc an toàn và thuận tiện

- Không tự động ký, gửi hoặc phê duyệt khi người dùng chưa xác nhận.
- Luôn hiển thị nguồn, số hiệu và hạn ngay cạnh nút hành động.
- Thao tác nguy hiểm có hộp xác nhận; thao tác thường dùng có phím tắt.
- Nếu mất kết nối, người dùng vẫn xem được metadata đã đồng bộ và có thể soạn offline.
- SQLite chỉ lưu metadata; tài liệu, bản xuất và bản sao tải về nằm ngoài database.
- Mọi lỗi đồng bộ có mô tả tiếng Việt, mã lỗi, thời gian và nút `Thử lại`.

