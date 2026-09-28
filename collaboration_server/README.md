# Máy chủ trường học — mã nguồn Python

Máy chủ kết nối ba ứng dụng qua API và SQLite chung. Nút **Trường học chung** mở giao diện web. Dữ liệu cá nhân cũ chưa tự đồng bộ; người dùng xuất tài liệu rồi đính kèm để gửi.

## Triển khai

Yêu cầu **Python 3.10 trở lên**, chỉ dùng thư viện chuẩn, không cần cài gói pip. Upload thư mục `collaboration_server` lên server. Hai file chạy chính là `server.py` và `workspace.html`. Máy chủ này chạy riêng với `server.py` quản lý portal ở thư mục gốc dự án.

Chạy trong thư mục mã nguồn, thay đường dẫn dữ liệu bằng thư mục có quyền ghi:

```bash
python3 server.py --data /duong-dan-du-lieu/workspace.db --init-admin
python3 server.py --host 127.0.0.1 --port 8765 --data /duong-dan-du-lieu/workspace.db
```

Lệnh đầu tạo quản trị qua terminal rồi thoát. Mật khẩu ít nhất 10 ký tự, không hiển thị khi nhập. Lệnh thứ hai chạy dịch vụ. Luôn dùng cùng đường dẫn dữ liệu; không khởi tạo lại DB đã có tài khoản. Trên Windows dùng `python` và đường dẫn Windows.

Cấu hình qua biến môi trường `SCHOOL_HOST`, `SCHOOL_PORT`, `SCHOOL_DATA` hoặc tham số dòng lệnh (được ưu tiên). `server.py` không tự đọc `.env`; khi chạy thủ công hãy export biến hoặc dùng tham số. Mẫu `deploy/school.env.example` dành cho systemd nạp.

## Chạy thường trực trên Linux

Đặt mã nguồn tại `/opt/troly-school`. Ví dụ trên server có systemd:

```bash
sudo useradd --system --home-dir /var/lib/troly-school --shell /usr/sbin/nologin troly-school
sudo install -d -o troly-school -g troly-school -m 700 /var/lib/troly-school
sudo cp /opt/troly-school/deploy/school.env.example /etc/troly-school.env
sudo cp /opt/troly-school/deploy/troly-school.service /etc/systemd/system/
sudo -u troly-school python3 /opt/troly-school/server.py --data /var/lib/troly-school/workspace.db --init-admin
sudo systemctl daemon-reload
sudo systemctl enable --now troly-school
sudo systemctl status troly-school
sudo journalctl -u troly-school -f
```

Bỏ qua `useradd` nếu tài khoản dịch vụ đã có. Cho tài khoản dịch vụ quyền đọc mã nguồn, quyền ghi thư mục dữ liệu. Mẫu dùng `/usr/bin/python3`; sửa `ExecStart` nếu Python ở nơi khác. Mẫu systemd chưa được xác minh trên server thực tế của bạn.

## HTTPS và ba ứng dụng

Cấu hình reverse proxy HTTPS hiện có chuyển tiếp tới `http://127.0.0.1:8765`. Chuyển tiếp `/` và `/api/`, giữ header `Authorization`, giới hạn request ít nhất 8 MiB và không cache API. Tệp tối đa 5 MiB được gửi dưới dạng base64. Cổng 8765 để nội bộ; dùng một tiến trình máy chủ với file SQLite trên ổ đĩa cục bộ.

Đặt ở gốc tên miền/subdomain riêng vì giao diện gọi `/api/...`. Mở URL HTTPS, đăng nhập quản trị, tạo trường/năm học và thành viên. Trong ba ứng dụng chọn **Địa chỉ máy chủ**, nhập cùng URL HTTPS rồi mở **Trường học chung**.

Thử trên cùng máy: `http://localhost:8765`. Thử LAN: thêm `--host 0.0.0.0`, kết nối qua IP máy chủ và cho phép TCP 8765 trong mạng riêng. Không chạy máy chủ riêng trên từng máy khách.

Giới hạn đăng nhập tính theo IP kết nối trực tiếp: khi qua proxy, các tài khoản chia sẻ mức 15 lần/phút của IP proxy. Máy chủ chưa dùng `X-Forwarded-For`.

## Chức năng và phạm vi

- Giao việc → đính kèm/nộp → duyệt hoặc yêu cầu sửa; không tự duyệt.
- Quản trị cấp quyền hiệu trưởng/chuyên viên; hiệu trưởng thêm giáo viên. Thêm cùng email chuyên viên vào từng trường phụ trách để cấp quyền nhiều trường.
- Danh sách lớp, kế hoạch và lịch công tác lưu dạng tiêu đề/nội dung; chưa có quản lý điểm hoặc thời khóa biểu tự động.
- Thông báo, tài liệu chia sẻ, tiến độ và nhật ký. Số chưa đọc cập nhật mỗi 30 giây; bấm **Tải lại** để cập nhật danh sách.
- Hồ sơ giữ nội dung/nhận xét mới nhất, chưa lưu toàn bộ phiên bản cũ. Mỗi không gian gắn một năm học; tạo không gian mới cho năm tiếp theo.
- Mật khẩu PBKDF2, phiên 12 giờ, kiểm tra quyền ở máy chủ. Chưa có giao diện thu hồi thành viên/đặt lại mật khẩu.

## Dữ liệu và vận hành

Mẫu systemd lưu tại `/var/lib/troly-school/workspace.db`; tệp đính kèm nằm trong DB. Nếu không đặt đường dẫn, mặc định là `TroLyTruongHocChung/workspace.db` dưới LOCALAPPDATA trên Windows hoặc home trên Linux. Không đặt SQLite trên ổ mạng.

Sao lưu: dừng dịch vụ (`sudo systemctl stop troly-school` hoặc Ctrl+C), sao chép `workspace.db`, khởi động lại. Khôi phục cũng phải dừng dịch vụ trước khi thay DB.

Cập nhật: dừng dịch vụ, sao lưu, thay mã nguồn và giữ DB, rồi `sudo systemctl restart troly-school`. Không chạy lại `--init-admin`. Những thay đổi cấu trúc bảng sau này cần migration tương ứng.

## Kiểm tra từ thư mục gốc dự án

```bash
python -m unittest discover -s collaboration_server -p test_workspace.py -v
python collaboration_server/smoke_source.py
```

`integrate.py`, `school-link.ps1`, `test_toolbar.ps1` phục vụ tích hợp Windows, không cần chạy trên server. Khi chuyển ứng dụng Windows, sao chép cả thư mục trong `dist` gồm EXE và `_internal`.
