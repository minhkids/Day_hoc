# Mẫu: Trắc nghiệm thi đua đội (`trac-nghiem-doi`)

**Dùng khi**: trò chơi "Ai nhanh hơn", "Rung chuông vàng" rút gọn, ôn tập cuối tiết/cuối chương có 2-6 đội thi đua trên máy chiếu.

**Có sẵn**: màn chuẩn bị (số đội 2-6, sửa tên đội, giây mỗi câu, điểm mỗi câu, xáo trộn câu hỏi - nhớ cấu hình trên máy này) · câu hỏi 4 phương án chữ to, thanh đếm ngược, tiếng tích tắc 5 giây cuối, hết giờ báo chuông · mở đáp án (đúng xanh, chọn sai đỏ, hiện giải thích) · bảng điểm từng đội có nút +/− · bảng xếp hạng cuối (xếp đồng hạng khi bằng điểm) · âm thanh Web Audio, bật/tắt được · toàn màn hình.

**Phím**: `Enter` bắt đầu · `1`-`4`/`A`-`D` chọn đáp án · `Space` hiện đáp án · `P` tạm dừng · sau khi mở đáp án `1`-`6` cộng điểm đội, `Enter` câu tiếp · `F` toàn màn hình · `M` âm thanh.

**Sửa nội dung**: chỉ sửa `du-lieu.js` - `tieuDe`, `monLop`, `thoiGianMoiCau`, `diemMoiCau`, `doi`, `cauHoi[]` (`hoi`, `phuongAn` 2-4 phương án, `dapAn` đếm từ 0, `thoiGian` riêng và `giaiThich` không bắt buộc).

**Dữ liệu mẫu**: 10 câu hằng đẳng thức đáng nhớ, Toán 8 (đáp án đã kiểm tra).
