# Kết quả kiểm tra

- 5 nhóm unittest đạt: quy trình giao–nộp–sửa–duyệt, xung đột phiên bản, phân quyền/cách ly trường, tệp đính kèm, dữ liệu dùng chung, đăng xuất và API HTTP.
- `test_toolbar.ps1` đạt trên ba thư mục dist: PowerShell hợp lệ, thanh kết nối được gắn, giữ nguyên nội dung và namescope WPF.
- `smoke_source.py` đạt với cơ sở dữ liệu tạm: máy chủ chạy từ Python phục vụ HTML, đăng nhập, tạo trường và đọc trạng thái.
- JavaScript của trang dùng chung qua kiểm tra cú pháp `node --check`.
- Chưa xác minh được toàn bộ thao tác trong trình duyệt: phiên Chromium tự động bị ngắt kết nối/hết thời gian chờ. Có thể chạy lại `smoke_browser.py` với biến `TROLY_TEST_BROWSER` trỏ tới Chromium phù hợp.
- Chưa triển khai máy chủ Internet, HTTPS, tên miền hay kiểm thử giữa hai máy thật. Cần cấu hình địa chỉ máy chủ thực tế khi đưa vào sử dụng.
