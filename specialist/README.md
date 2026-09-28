# Trợ lý Chuyên viên Giáo dục – bản độc lập

Ứng dụng Windows bằng tiếng Việt, xây dựng theo các nhóm nghiệp vụ quan sát được trong bộ cài `TroLyChuyenVien-Setup.exe` do người dùng cung cấp. Mã ứng dụng mới nằm trong thư mục này; không sửa bộ cài tham chiếu.

## Chạy ứng dụng

Chạy `exe/TroLyChuyenVien-Setup.exe` để cài ứng dụng. Sau khi cài, mở ứng dụng từ Menu Start. Bản phát hành cho người dùng là bộ cài; bản portable không được phân phối trong thư mục `exe/`.

Vào **Cài đặt → Kết nối AI**:

- Loại kết nối: **OpenRouter** (mặc định).
- Địa chỉ: `https://openrouter.ai/api/v1` (đã điền sẵn).
- API key: nhập khóa của bạn trực tiếp trong ứng dụng.
- Tên mô hình: nhập mã mô hình từ [danh mục OpenRouter](https://openrouter.ai/models).
- Bấm **Lưu cài đặt**, mở **Trò chuyện AI**, gửi một câu hỏi để kiểm tra.

Kết nối sử dụng HTTP POST `/chat/completions` và Bearer token theo [tài liệu OpenRouter](https://openrouter.ai/docs/quickstart). Chưa thử yêu cầu thật với OpenRouter vì chưa có API key. Kiểm thử kết nối dùng máy chủ HTTP giả lập nội bộ.

Các phần quản lý công việc, đơn vị, văn bản, mẫu, PDF và xuất Office có thể sử dụng khi chưa có API key. AI cần kết nối và tài khoản hợp lệ trên máy chủ bạn chọn. App gửi nội dung yêu cầu, lịch sử cuộc trò chuyện, tài liệu đính kèm và bộ nhớ cơ quan đến máy chủ đó.

## Chức năng hiện có

- Trang chủ tổng hợp số việc đang làm, quá hạn và số văn bản đã lưu.
- Trò chuyện AI có lịch sử nhiều lượt, đính kèm DOCX/PDF có chữ/XLSX/CSV/TXT/MD, cỡ chữ, giữ bản nháp khi chuyển trang và dừng chờ.
- 12 loại văn bản; 16 nhóm nhiệm vụ chuyên viên; 10 nhóm kiểm tra, đánh giá. Các nhóm chuẩn bị yêu cầu cho AI, không tự động hoàn thành thủ tục bên ngoài.
- Biên tập và lưu dự thảo; xuất Word, PowerPoint dạng trang chữ, Excel dạng bảng chữ và Markdown. Tên tệp xuất có phiên bản để tránh ghi đè.
- Văn bản đến: lưu bản sao tệp, nơi gửi, hạn, trạng thái, tóm tắt/trích việc/lập phiếu qua AI và thêm công việc theo dõi.
- Đơn vị và đợt báo cáo: quản lý đầu mối, nhận tệp theo đơn vị, theo dõi đã nộp/chưa nộp, tổng hợp/đôn đốc qua AI và xuất bảng Excel.
- Công việc: thêm, sửa, trạng thái, phụ trách, hạn, đánh dấu quá hạn và xuất Excel.
- 41 tệp mẫu có sẵn từ thư mục `app/templates/chuyen_vien` do người dùng cung cấp, nhập vào lần đầu. Có thể thêm, sửa, xóa và nhập mẫu/quy trình riêng.
- Bộ nhớ cơ quan theo 8 nhóm, tự lưu khi chuyển trang và gửi cùng yêu cầu AI.
- Ghép, tách và xoay PDF; liên kết nguồn văn bản chính thức; mở iOffice bằng trình duyệt; sao lưu ZIP.
- API key được mã hóa bằng Windows DPAPI. Sao lưu không chứa khóa.

## Khác biệt so với app tham chiếu

Đây là **bản đầu tiên, chưa tương đương 100%** và không phải phiên bản chính thức của tác giả phần mềm tham chiếu.

| Hạng mục | Trạng thái |
| --- | --- |
| Giao diện tiếng Việt và các trang nghiệp vụ chính | Đã xây dựng; bố cục mới, không sao chép từng điểm ảnh |
| AI | OpenRouter/API tương thích và Gemini |
| Mẫu văn bản | 41 tệp tham chiếu có sẵn và mẫu tự nhập |
| Tự thao tác iOffice | Chưa có; hiện mở trình duyệt và nhập tài liệu tải về |
| Tự kiểm tra văn bản mới trên website | Chưa có; hiện có liên kết nguồn để tra cứu |
| AI tự tạo/sửa tệp, tự ghi công việc, bộ nhớ | Chưa tự động; người dùng lưu/chỉnh sửa bằng các trang tương ứng |
| OCR ảnh, kéo thả tệp, nhận giọng nói | Chưa có; đính kèm bằng hộp chọn tệp, PDF cần có lớp chữ |
| Office | Word định dạng cơ bản, PowerPoint chia trang chữ, Excel lưu bảng chữ; chưa có biểu đồ/công thức tự động hoặc đầy đủ thể thức từng loại |
| Tự cập nhật, dọn rác, sửa máy tính | Chưa có |

## Dữ liệu và sao lưu

Dữ liệu lưu ở `%LOCALAPPDATA%\TroLyChuyenVienDocLap`, tách biệt với EXE. Có thể đặt biến môi trường `TROLY_DATA_DIR` để dùng thư mục khác.

Trong **Tra cứu & tiện ích → Sao lưu dữ liệu**, chọn nơi lưu ZIP. Khôi phục thủ công: đóng ứng dụng, sao lưu thư mục dữ liệu hiện tại, giải nén ZIP vào thư mục dữ liệu. Khi chuyển máy cần nhập lại API key.

## Phát triển và kiểm thử

Phụ thuộc: Python 3.11+, requests, python-docx, python-pptx, openpyxl, PyPDF2, PyInstaller. Pillow chỉ dùng cho ảnh kiểm thử.

```powershell
python specialist/test_core.py
python specialist/smoke_ui.py
python specialist/build.py
```

Kiểm thử dịch vụ: lưu/khôi phục dữ liệu tiếng Việt, DPAPI và loại khóa khỏi ZIP, xuất/đọc lại Office, chống ghi đè, ô Excel không thực thi công thức đầu vào, định dạng yêu cầu API, lỗi xác thực, chặn HTTP bên ngoài máy.

Kiểm thử giao diện: mở 16 trang, gọi máy chủ HTTP giả lập, kiểm tra hồ sơ được gửi, lịch sử nhiều lượt và giữ nháp khi chuyển trang. Ảnh được chụp từ dữ liệu kiểm thử riêng.
