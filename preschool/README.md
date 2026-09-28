# Trợ lý Giáo viên Mầm non 1.0.1

## Giao diện tinh gọn · 1.0.1

- Trang chủ có bốn lối vào chính: soạn hoạt động, hồ sơ trẻ, theo dõi trẻ và tin nhắn phụ huynh.
- Menu chia ba nhóm: Hằng ngày, Lớp của cô, Tài liệu & hỗ trợ.
- Hồ sơ trẻ thu gọn sức khỏe, gia đình và nơi ở; bấm tên nhóm để mở và chỉnh sửa.
- Mẫu có sẵn và công cụ chuyên môn được mở khi cần. Tra cứu văn bản dùng ô tìm kiếm và danh sách chọn nhóm.
- Rút ngắn tiêu đề, tên nút; giảm nền màu và mô tả lặp lại.

Kiểm tra bản này được ghi riêng tại `reports/preschool/ui-1.0.1.md`; kết quả phiên bản cũ bên dưới chỉ là lịch sử.

Ứng dụng Windows tiếng Việt, riêng cho giáo viên nhà trẻ và mẫu giáo. Dùng chung các hàm đọc tài liệu, xuất Office và kết nối OpenRouter trong `specialist/core.py`; có giao diện, danh mục mẫu, lời nhắc AI, bộ cài và dữ liệu riêng.

## Chạy ứng dụng

- Bộ cài: `exe/TroLyGiaoVienMamNon-Setup.exe`.
- Bản chạy ngay: `exe/TroLyGiaoVienMamNon/TroLyGiaoVienMamNon.exe`. Giữ EXE cùng thư mục `_internal`.
- Chạy từ mã nguồn: `python preschool/desktop.py`.
- Dữ liệu: `%LOCALAPPDATA%\TroLyGiaoVienMamNon`; có thể đặt `TROLY_PRESCHOOL_DATA_DIR` khi kiểm thử.

## Chức năng

14 trang: Trang chủ, Soạn hoạt động, Kế hoạch giáo dục, Hồ sơ trẻ em, Theo dõi trẻ, Chăm sóc và quản lý lớp, Phối hợp phụ huynh, Hồ sơ chuyên môn, Thông tư & Văn bản mới, Học liệu và trò chơi, Kho tài liệu, Lịch công việc, Trò chuyện AI, Cài đặt.

- Tự động cập nhật Công văn, Nghị định & Thông tư mới GD Mầm non: Tự động quét và cập nhật các văn bản QPPL, công văn hướng dẫn nhiệm vụ năm học và chính sách mới nhất từ Cổng TTĐT Bộ GD&ĐT (moet.gov.vn) và Cổng Chính phủ (chinhphu.vn, baochinhphu.vn) ngay khi ứng dụng khởi động và có mạng; hỗ trợ bộ lọc nhanh theo Nghị định, Thông tư, Công văn & Hướng dẫn, Chế độ & Phụ cấp, PP Giáo dục tiên tiến, Chuẩn trường (Mức 1, 2, 3), và Hồ sơ Đảng & Chi bộ; có "Tóm tắt 3 phút cho Giáo viên Mầm non" (nêu rõ điểm mới, quyền lợi, tác động đến lớp dạy); đối chiếu tính chuẩn xác đường dẫn và nút đưa vào biên bản/kế hoạch.
- **Trung tâm Nghiệp vụ & Trợ lý AI Thông tư - Nghị định (Mới)**:
  + **Phương pháp Giáo dục tiên tiến**: Hướng dẫn và kết nối AI soạn bài theo VBHN 01/VBHN-BGDĐT: STEAM (quy trình 5E: Gắn kết - Khám phá - Giải thích - Áp dụng - Đánh giá, quy trình thiết kế kỹ thuật EDP), Montessori (5 góc hoạt động, bài học 3 bước), Reggio Emilia (học theo dự án, xưởng sáng tạo Atelier), Học qua chơi lấy trẻ làm trung tâm. Nút bấm 1-click kích hoạt Trợ lý AI soạn giáo án chi tiết và chuyển sang trình soạn thảo để xuất Word/PowerPoint.
  + **Đánh giá Chuẩn trường học theo Mức độ (1, 2, 3)**: Dựa trên Thông tư 19/2018/TT-BGDĐT (Kiểm định chất lượng & Chuẩn quốc gia trường MN) và Thông tư 13/2020/TT-BGDĐT (Tiêu chuẩn CSVC Mức 1 & Mức 2). AI tự động lọc đúng tiêu chí/chỉ báo tương ứng theo Mức 1 (tối thiểu), Mức 2 (Chuẩn QG Mức 1), Mức 3 (Chuẩn QG Mức 2); phân tích Đạt/Chưa đạt, Điểm mạnh, Tồn tại, Kế hoạch cải tiến và mã hóa minh chứng chuẩn [H1-1.01-01].
  + **Bảng đánh giá trường học đạt chuẩn quốc gia theo các mức độ**: Khung biểu mẫu bảng tự đánh giá 5 Tiêu chuẩn, 25 Tiêu chí (Phụ lục Thông tư 19/2018/TT-BGDĐT). Tích hợp nút [📊 Mở Bảng tự đánh giá] chỉnh sửa ngay hoặc [🤖 AI Điền mẫu Bảng tự đánh giá] để AI tự động điền dự thảo toàn diện.
  + **Cập nhật Hồ sơ Đảng & Chi bộ**: Dành riêng cho giáo viên mầm non theo Quy định 124-QĐ/TW & Hướng dẫn 25-HD/BTCTW. Bao gồm: Bản kiểm điểm đảng viên cuối năm (Mẫu 02-HD/BTCTW), Bản cam kết tu dưỡng rèn luyện năm, Biên bản & Nghị quyết sinh hoạt Chi bộ trường học. Tích hợp AI gợi ý tự phê bình, ưu điểm, hạn chế và giải pháp khắc phục gắn liền với thực tế nuôi dạy trẻ.
- Quản lý Hồ sơ trẻ em & Chuyển đổi nơi ở sáp nhập phường qua GeoVina API (https://geovina.io.vn/docs):
  + Quản lý danh sách học sinh: Mã trẻ, họ tên, giới tính, ngày sinh, lớp.
  + Thể trạng & số đo: Cân nặng (kg), chiều cao (cm), tự động tính chỉ số BMI và đánh giá thể trạng dinh dưỡng (Bình thường - Kênh A, Suy dinh dưỡng nhẹ cân/thấp còi, Thừa cân/béo phì), lưu ý sức khỏe/dị ứng.
  + Thông tin gia đình: Họ tên bố, số điện thoại bố, họ tên mẹ, số điện thoại mẹ, người giám hộ và số điện thoại liên hệ khẩn cấp.
  + Nơi ở & Chuyển đổi sáp nhập phường qua GeoVina API: Lưu trữ đồng thời nơi ở TRƯỚC SÁP NHẬP và nơi ở SAU SÁP NHẬP. Có hướng dẫn nhập tiện lợi (chỉ cần nhập tên Phường/Xã cũ - Quận/Huyện - Tỉnh/TP, không bắt buộc nhập số nhà, ngõ ngách chi tiết). Nút bấm chuyển đổi thủ công rõ ràng [📍 Chuyển đổi sang Phường mới], không tự động đổi ngầm khi lưu hồ sơ để cô giáo dễ kiểm soát. Tích hợp trực tiếp **GeoVina API** (https://geovina.io.vn) tự động nhận diện và chuyển đổi hai chiều chuẩn xác theo dữ liệu hành chính mới nhất của Tổng cục Thống kê (GSO); hỗ trợ tự động lấy token miễn phí, lưu cache cục bộ `geovina_cache.json` cho tốc độ phản hồi tức thì; có cơ chế chuyển đổi hàng loạt (`/batch`) cho toàn bộ danh sách lớp; tự động chuyển sang bộ quy tắc nội bộ khi không có kết nối mạng; nút [📄 Tải file Excel mẫu] chuẩn 17 cột và nút [📥 Nạp danh sách từ Excel] giúp nạp danh sách cả lớp trong tích tắc; xuất danh sách 16 cột ra Excel (.xlsx).
- 36 mẫu có cấu trúc: chỉnh sửa, lưu và xuất Word/PowerPoint/Excel khi không có mạng.
- Sổ theo dõi trẻ & Nhật ký chăm sóc: liên kết trực tiếp với danh mục trẻ em để chọn nhanh trẻ khi ghi nhận; thêm, sửa, tìm, xóa và xuất Excel.
- Công việc: tên, hạn, trạng thái; chỉnh sửa và hiển thị trên Trang chủ.
- AI: nhập model và API key OpenRouter tại Cài đặt; đính kèm tài liệu, hội thoại trong phiên, hủy yêu cầu và chuyển trả lời sang trình soạn thảo. Không tự gửi tin nhắn cho phụ huynh.
- Hai học liệu HTML chạy tại máy: nhận biết màu sắc và đồng hồ hoạt động.
- Sao lưu ZIP tại Cài đặt; nút trường học mở cổng dùng chung đã cấu hình, không tự đồng bộ sổ cá nhân.

Không có đề thi, ma trận, chấm điểm, xếp hạng hoặc lịch thi mặc định. Các mẫu là khung gợi ý, không tự nhận là biểu mẫu bắt buộc hoặc chứng minh tuân thủ mọi quy định. Nội dung thơ/truyện và phiếu hình ảnh là bản thảo văn bản; app chưa sinh ảnh hoặc âm thanh.

## Lưu trữ

SQLite chỉ chứa ID, loại hồ sơ, ngày cập nhật và đường dẫn. Nội dung hồ sơ lưu dưới `ho-so/<loại>/<id>.json`. Thông tin lớp trong `profile.json`. API key ở `api-key.dpapi`, bảo vệ bằng Windows DPAPI; không đọc khóa từ `.env` của app khác. Hội thoại chỉ trong RAM. Xóa chuyển tệp hồ sơ vào `thung-rac` và gỡ khỏi chỉ mục. Sao lưu gồm chỉ mục, hồ sơ, cấu hình lớp và thùng rác; không gồm khóa API hoặc hội thoại.

Khôi phục thủ công: đóng ứng dụng, giải nén bản sao lưu vào một thư mục mới, trỏ `TROLY_PRESCHOOL_DATA_DIR` tới đó để kiểm tra; nhập lại API key. Bản này chưa có nút khôi phục trong giao diện.

## Phát triển và kiểm tra

```powershell
python -m unittest discover -s preschool -p test_preschool.py -v
python preschool/smoke.py
python preschool/verify_ai_ui.py
python preschool/build.py
python preschool/smoke.py --exe
python preschool/build_installer.py
```

Kết quả kiểm tra bản 1.0.0 ngày 24/09/2026: 10 kiểm thử tự động đạt (100%); smoke test đạt 14/14 trang bao gồm Hồ sơ trẻ em, GeoVina API và 4 tính năng AI Thông tư & Chuẩn trường & Hồ sơ Đảng; EXE đóng gói mở 14 trang và thực hiện các thao tác lưu/sửa, xuất Office, tra cứu pháp luật đạt; luồng AI trên WPF đạt với nhà cung cấp mô phỏng; hai trò chơi đạt kiểm tra trên Chrome headless; bộ cài đạt hoàn thiện. Báo cáo: `reports/preschool/release-check.json`.
