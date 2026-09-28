# Kiểm tra AI bản 1.0.6 — 23/09/2026

Model: `inclusionai/ling-3.0-flash-vl:free`. OpenRouter tự chọn provider.

## Kết quả trên EXE đóng gói

Đã chạy từng EXE trong `releases/1.0.6/payload`, với dữ liệu riêng và tài liệu Word giả lập. Các sự kiện nút WPF thực sự gọi bridge của EXE, rồi gọi OpenRouter qua HTTPS. Chỉ hộp chọn tệp hệ điều hành được thay bằng đường dẫn tài liệu kiểm thử; phần xử lý nút Rà soát vẫn là mã ứng dụng.

| Kiểm tra | Giáo viên | Quản trị trường học | Chuyên viên |
|---|---|---|---|
| Khởi động và điều hướng thanh bên | 11 trang đạt | 10 trang đạt | 10 trang đạt |
| Nút chuẩn bị yêu cầu nghiệp vụ | Đạt | Đạt, gồm nhiệm vụ | Đạt |
| Nút tạo việc mới | Đạt | Đạt | Đạt |
| Gửi AI không khóa giao diện | Đạt | Đạt | Đạt |
| Soạn nội dung bằng AI thật | Đạt | Đạt | Đạt |
| Rà soát: chọn Word → gửi → đọc đúng mã và số liệu | Đạt | Đạt | Đạt |
| Hỏi tiếp, nhớ dữ liệu từ lượt trước | Đạt | Đạt | Đạt |
| Xuất câu trả lời thành Word | Đạt | Đạt | Đạt |
| Đóng ứng dụng | Exit 0 | Exit 0 | Exit 0 |

Chi tiết máy đọc được: `packaged/teacher.json`, `packaged/school.json`, `packaged/specialist.json`. Mỗi EXE đã gửi ba yêu cầu AI thật. Các nhóm nghiệp vụ cùng dùng đường gửi AI này; không đánh giá chất lượng chuyên môn của mọi loại tài liệu.

## Lỗi đã sửa

- Giáo viên: handler tạo closure làm biến danh sách đính kèm nằm sai phạm vi; nút Rà soát chọn tệp nhưng yêu cầu AI không nhận được tệp. Đã tái hiện bằng kiểm thử nút và xác nhận hết lỗi trên EXE.
- Quản trị trường học: chờ AI đồng bộ làm giao diện không phản hồi; đã dùng công việc nền và cập nhật kết quả theo trạng thái.
- Quản trị trường học: nút Dừng trước đây chỉ hiện thông báo; nay hủy việc đang chờ, không lưu câu trả lời đến muộn, khôi phục yêu cầu và tệp. Hủy không đảm bảo dừng xử lý ở nhà cung cấp. Có kiểm thử hồi quy với phản hồi giả lập bị trì hoãn.
- Quản trị trường học: bổ sung hàm tạo việc mới mà nút giao diện đã gọi; sửa phạm vi handler để giữ trạng thái tệp đính kèm.

## Cấu hình khóa và phạm vi xác minh

Khóa cấu hình gọi trực tiếp model nhận HTTP 200. Hai khóa đã lưu trên máy của Giáo viên và Chuyên viên trùng khóa cấu hình, được endpoint trạng thái khóa chấp nhận và không có giới hạn tiền riêng trên khóa. Thư mục dữ liệu Quản trị trường học chưa có khóa lưu; cần nhập tại Cài đặt nếu cài ngoài thư mục dự án. Không nhúng khóa vào bộ cài.

Kiểm thử dùng .env của máy phát triển và dữ liệu giả lập. Không cài đè lên ứng dụng hoặc chỉnh sửa hồ sơ làm việc của người dùng. Kết quả xác nhận các luồng đã thử tại thời điểm chạy; không xác nhận mọi nút hoặc mọi loại tệp. Nguồn kiểm thử thêm: core, desktop bridge, hủy nền trường học, màn lưu API key WPF.

Chạy lại (có thực hiện cuộc gọi OpenRouter):

```powershell
python scripts/verify_packaged_ai.py --payload-root releases/1.0.6/payload --report-dir reports/ai-1.0.6/packaged
```
