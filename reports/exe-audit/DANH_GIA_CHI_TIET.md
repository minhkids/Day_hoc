# Đánh giá chi tiết chức năng — 22/09/2026

Đánh giá dựa trên kết quả chạy ba EXE, điều khiển cửa sổ bằng Windows UI Automation, thử sự kiện WPF trên bản sao gói ứng dụng và đối chiếu mã PowerShell nằm trong gói EXE. Chưa sửa ứng dụng.

## 1. Quản trị trường học: lỗi đã xác nhận

### B01 — Nghiêm trọng: bộ xử lý chung làm nhiều nút báo lỗi

Trên EXE gốc: Trang chủ → Khai báo thông tin trường → hiện lỗi `The expression after '&' ... must result in a command name, a script block, or a CommandInfo object`.

Trên bản sao có thêm ghi nhận kết quả, 34 nút sau gặp cùng lỗi. Đây là 34 nút bị ảnh hưởng bởi một lỗi chung, không phải 34 nguyên nhân độc lập.

| Nhóm | Các nút đã thử và gặp lỗi |
|---|---|
| Trang chủ/hồ sơ | Khai báo thông tin trường ở trang chủ; Kiểm tra văn bản mới; Xem tất cả công việc; Xem tất cả văn bản |
| Soạn thảo/mẫu | Giao việc soạn thảo; Chọn file để rà soát; Xem mẫu dạng Word; Soạn theo mẫu này; Hướng dẫn thể thức NĐ 30 |
| Trò chuyện | Gửi; Việc mới; tăng chữ A+; giảm chữ A−; Thu gọn cột việc |
| Công việc/lịch | Thêm việc; Lập lịch công tác tuần tới; Cập nhật mốc năm học; Lập việc tháng này; Quản lý công việc |
| Ban giám hiệu/tổ chuyên môn | Giao việc BGH; Danh sách tổ, hồ sơ phải nộp; Giao việc tổ chuyên môn; Góp ý, duyệt |
| Công tác Đảng | Khai báo tổ chức Đảng; Danh sách đảng viên; Cấp ủy, chi bộ, lịch sinh hoạt; Giao việc công tác Đảng |
| Tra cứu/tổng hợp | Tra cứu; Giao việc tổng hợp |
| Cài đặt/hỗ trợ | Khai báo thông tin trường ở cài đặt; Cập nhật quy mô cùng trợ lý; Hướng dẫn |
| Sao lưu | Sao lưu dữ liệu ở trang tiện ích và ở chân cửa sổ |

Nguyên nhân: hàm Wire tham chiếu biến cục bộ `$handler` trong callback sau khi hàm kết thúc. Callback không giữ được giá trị cần thực thi.

Bằng chứng: school/uia-after-settings-click.json và school/data/extended-audit.json. Việc mở được các trang không chứng minh những nút trong trang hoạt động.

### B02 — Cao: dữ liệu đã lưu không hiển thị đúng

Backend trả danh sách `task` và `document`, nhưng giao diện đọc `tasks` và `documents`.

Thử nghiệm xác nhận backend có công việc và văn bản, trong khi các thuộc tính giao diện đọc không tồn tại. Tác động tới Công việc hôm nay, danh sách công việc, Văn bản gần đây và Thư viện văn bản. Mã các trang Lịch, Tổng hợp, Công tác Đảng và Văn bản đến cũng dùng trường dữ liệu sai này.

Đây là lỗi đọc/hiển thị dữ liệu; chưa có bằng chứng dữ liệu bị xóa. Sửa B01 chưa giải quyết B02.

### B03 — Cao: sao lưu gửi sai tên tham số

Nút sao lưu gửi `target`, backend cần `path`. Gửi đúng nội dung callback hiện tại tới backend đóng gói trả lỗi `'path'`. Đổi sang `path` tạo được ZIP hợp lệ. B01 đang chặn thao tác nút trước đó; sau khi sửa B01 vẫn phải sửa B03.

## 2. Quản trị trường học: chức năng mới triển khai một phần

Các mục sau được xác định bằng cách đọc mã trong `_internal/wpf/host.ps1`; chưa phải kết quả kiểm thử thành công sau khi sửa B01.

| Chức năng | Hiện trạng trong mã | Phần còn thiếu |
|---|---|---|
| Góp ý, duyệt văn bản tổ chuyên môn | Chỉ gọi thông báo đã ghi nhận duyệt thành công | Chọn văn bản, nhập góp ý, lưu trạng thái duyệt và lịch sử |
| Danh sách đảng viên | Chuyển về trang Công tác Đảng và hiện thông báo đã đồng bộ | Thao tác tải/đồng bộ và hiển thị danh sách trong callback này |
| Khai báo thông tin trường/cập nhật quy mô | Chuyển tới Cài đặt; trang này hiển thị thông tin hồ sơ | Luồng nhập, sửa và lưu thông tin trường trong giao diện này |
| Xem mẫu dạng Word | Chỉ chuyển tới trang Mẫu | Mở/xuất mẫu Word đúng như tên nút |
| Chọn file để rà soát | Chỉ chuyển tới Thư viện | Chọn tệp và đưa tệp vào quy trình rà soát qua nút này |
| Soạn theo mẫu này | Đưa tên mẫu vào ô yêu cầu AI | Chưa thấy callback đưa toàn bộ nội dung mẫu vào yêu cầu |
| Giao việc tổng hợp | Điền một câu yêu cầu chung vào trò chuyện | Chọn/đọc dữ liệu và truyền dữ liệu cần tổng hợp qua nút này |
| Mốc năm học | Danh sách mốc viết cố định trong mã; nút cập nhật chỉ chuẩn bị câu hỏi AI | Lưu và cập nhật lịch riêng của trường |
| Tra cứu quy định | Danh sách văn bản và nhãn hiệu lực viết cố định; câu hỏi chuyển sang AI | Cơ chế tra cứu nguồn và cập nhật hiệu lực tự động trong chức năng này |

Không dùng các nhãn hiệu lực viết trong mã làm bằng chứng về tình trạng pháp lý hiện tại. Đánh giá này chỉ nhận xét cách ứng dụng triển khai dữ liệu.

## 3. Giáo viên: 16 nút chưa có xử lý chức năng

Bộ nối sự kiện trong EXE gán các nút sau vào thông báo dự phòng “chưa có trong bản độc lập”. Bốn nút đã được kích hoạt để xác nhận trực tiếp: Mở file điểm, Cập nhật mốc năm học, Mở file lịch năm học và Hướng dẫn trình bày. Các nút còn lại được xác định từ danh sách nối sự kiện. Không phải tất cả luôn hiển thị cùng lúc.

| STT | Nút | Phần chưa hoạt động qua nút này |
|---|---|---|
| 1 | Kiểm tra văn bản mới | Kiểm tra/lấy văn bản mới |
| 2 | Hướng dẫn trình bày | Mở hướng dẫn |
| 3 | Xem trước | Mở bản chạy thử/xem trước dự án |
| 4 | Tải lại bản chạy thử | Làm mới khung xem trước |
| 5 | Toàn màn hình | Mở bản chạy thử toàn màn hình |
| 6 | Mở thư mục dự án trong khung xem trước | Mở thư mục từ nút này |
| 7 | Đóng gói trong khung xem trước | Tạo ZIP từ nút này |
| 8 | Ẩn khung xem trước | Đóng/ẩn khung |
| 9 | Mở file ở phần điểm | Mở tệp điểm |
| 10 | Lập việc tháng này — BtnVbTuCongViec | Luồng lập việc qua nút này |
| 11 | Cập nhật mốc năm học | Cập nhật các mốc |
| 12 | Mở file lịch năm học | Mở tệp lịch |
| 13 | Kiểm tra, đánh giá tại trang tổng hợp | Chuyển sang chức năng đánh giá qua nút này |
| 14 | Kích hoạt / nhập mã mới | Luồng nhập và xác thực mã |
| 15 | Cập nhật từ file cài đặt | Chọn và áp dụng bản cài đặt |
| 16 | Liên hệ hỗ trợ | Mở kênh hỗ trợ |

Lưu ý: một số thao tác có nút khác đã được nối, ví dụ mở thư mục/đóng gói dự án trong danh sách dự án hoặc nút Lập việc tháng này khác. Kết luận trên áp dụng cho các nút cụ thể; không có nghĩa toàn bộ khả năng tương ứng đều không tồn tại.

Đã thử đạt: mở 16 trang, thêm công việc, xuất danh sách việc, tạo dự án trống, sao lưu và tạo DOCX/XLSX/PPTX/MD. Tệp Office được kiểm tra cấu trúc; chưa kiểm tra trình bày từng trang bằng Microsoft Office. Chưa có bằng chứng toàn bộ nghiệp vụ soạn bài/đề thi chạy hoàn chỉnh với AI thật.

## 4. Chuyên viên

Chưa phát hiện lỗi trong các ca đã chạy: 15 trang, 41 mẫu, thêm/hoàn thành/xóa việc, lưu cài đặt, gửi AI qua máy chủ HTTP giả lập và lưu phản hồi. Chín unit test mã nguồn cũng đạt.

Chưa có cơ sở khẳng định toàn bộ tính năng không lỗi hoặc không còn chức năng thiếu. Việc mở 15 trang không tương đương kiểm thử mọi thao tác nghiệp vụ trên 15 trang.

## 5. Các phần chưa xác minh

OpenRouter thật; chất lượng nội dung sinh ra; đăng nhập/đăng ký và đồng bộ với máy chủ thật; cài đặt/cập nhật thực tế; mọi công cụ PDF và tình huống tệp lỗi; dữ liệu lớn; DPI; mọi hộp thoại và thao tác kéo thả.

Đây là danh sách chưa kiểm chứng, không tự động được coi là lỗi hoặc chưa triển khai.

## 6. Ưu tiên xử lý

1. Sửa bộ xử lý nút Quản trị và kiểm thử lại các luồng bị chặn.
2. Sửa tên trường dữ liệu và tham số sao lưu.
3. Hoàn thiện các chức năng mới chỉ thông báo/chuyển trang, đặc biệt duyệt văn bản và hồ sơ trường.
4. Nối đủ các nút Giáo viên còn thiếu; kiểm tra những nút trùng tên ở các vị trí khác nhau.
5. Chạy các quy trình thực tế với AI và máy chủ trường, kiểm tra nội dung tệp xuất.

Bằng chứng gốc: tested-executables.json; launch-results.json; teacher/data/extended-audit.json; school/data/extended-audit.json; specialist/screenshots/smoke-result.json; artifact-validation.json; các ảnh trong teacher/screenshots và specialist/screenshots.
