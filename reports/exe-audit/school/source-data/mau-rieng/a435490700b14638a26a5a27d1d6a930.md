---
loai: bang-tinh
tieu_de: "[Tên bảng tính, ví dụ: Tổng hợp chất lượng giáo dục học kỳ I năm học 2026 - 2027]"
don_vi: "[Trường Tiểu học ...]"
ngay: "[dd/mm/yyyy]"
mau: xanh
---

<!--
HƯỚNG DẪN VIẾT FILE BẢNG TÍNH (công cụ: cong-cu\xuat-excel.ps1)

1. KHỐI THÔNG TIN (giữa hai dòng ---)
   - tieu_de   : dòng tiêu đề in đậm ở đầu mỗi trang tính.
   - don_vi, ngay : dòng chữ nhỏ dưới tiêu đề.
   - mau       : xanh (mặc định) | xanh-la | do | cam | tim | xam - màu nền hàng tiêu đề bảng.
   - file_excel: công cụ tự ghi tên file Excel đã xuất - KHÔNG tự sửa, không xóa.

2. NỘI DUNG
   - Mỗi dòng "# Tên trang tính" mở MỘT TRANG TÍNH (sheet) mới. Tên quá 31 ký tự sẽ bị cắt.
   - Trong trang tính: bảng Markdown (hàng đầu là tiêu đề cột), các dòng chữ thường thành ghi chú
     đặt đúng chỗ (trên hoặc dưới bảng) - dùng để ghi nguồn số liệu, thời điểm chốt số.
   - Hàng có ô đầu bắt đầu bằng Tổng / Cộng / Toàn trường được in đậm, tô nền nhạt.

3. SỐ LIỆU
   - Viết số kiểu Việt Nam: 1.234 (nghìn), 98,5 (thập phân), 12,5% (phần trăm). Công cụ tự nhận thành
     SỐ THẬT trong Excel (canh phải, tách nghìn, đúng định dạng %) để thầy/cô cộng, lọc, vẽ biểu đồ được.
   - Ô không có số liệu thì để trống, không ghi "0" nếu thực tế chưa có.
   - Số liệu chưa có thì ghi [CẦN BỔ SUNG] - công cụ sẽ đếm và nhắc.

4. CÔNG CỤ TỰ LÀM (không cần viết trong file .md)
   - Hàng tiêu đề bảng: in đậm, chữ trắng nền màu, cố định khi cuộn, có bộ lọc.
   - Kẻ khung, bề rộng cột theo nội dung, khổ in A4 vừa chiều ngang, lặp hàng tiêu đề khi in nhiều trang.

5. XUẤT FILE
   powershell -NoProfile -ExecutionPolicy Bypass -File "{{HE_THONG}}\cong-cu\xuat-excel.ps1" -Md "<đường dẫn file .md>" -Open
-->

# [Tên trang tính 1]

[Nguồn số liệu, thời điểm chốt số]

| [Cột 1] | [Cột 2] | [Cột 3] | [Tỉ lệ] |
|---|---|---|---|
| | | | |
| **Tổng cộng** | | | |

# [Tên trang tính 2 - bỏ nếu chỉ cần một trang tính]

| [Cột 1] | [Cột 2] |
|---|---|
| | |
