# Kiến thức, quy định theo cấp học

Phần mềm "Trợ lý Giáo viên" dùng cho giáo viên **tiểu học**, **trung học cơ sở**, **trung học phổ thông** và trường có hai cấp học. Cấp học khai ở cửa sổ **Khai báo thông tin** (ghi dòng `- Cấp học: ...` vào `09_BO_NHO_TRO_LY\thong-tin-giao-vien.md`).

## Cách tổ chức

| Thư mục | Nội dung |
|---|---|
| `th\` | Tiểu học |
| `thcs\` | Trung học cơ sở |
| `thpt\` | Trung học phổ thông |
| `th-thcs\` | Trường có hai cấp học TH&THCS (tệp chỉ đường) |
| `thcs-thpt\` | Trường có hai cấp học THCS&THPT (tệp chỉ đường) |
| `dang-dung\` | **Bản đang dùng** - phần mềm tự chép từ thư mục cấp học đã khai, mỗi lần mở (hàm `Dam-Bao-CapHoc` trong `cong-cu\_chung.ps1`). Quy trình và quy tắc chỉ trỏ tới đường dẫn này |

Mỗi thư mục cấp học có: `_muc-luc.md` (đặc điểm cấp học, điều dễ nhầm), `day-hoc.md` (chương trình, kế hoạch bài dạy, phương pháp), `kiem-tra-danh-gia.md` (đánh giá học sinh, ra đề, ma trận), `can-cu-cap-hoc.md` (căn cứ pháp lý riêng).

## Khi sửa nội dung

1. Sửa trong thư mục cấp học (`th\`, `thcs\`, `thpt\`), **không sửa `dang-dung\`** - thư mục này bị xóa và chép lại mỗi khi đổi cấp học.
2. Ép chép lại: xóa `dang-dung\_cap-hoc.txt` rồi mở lại phần mềm.
3. Chỉ ghi văn bản pháp lý đã đối chiếu bản gốc; chưa chắc thì ghi `[CẦN KIỂM TRA]`. Cấp học nào thiếu quy định nào thì nói rõ là thiếu - **không lấy quy định của cấp học khác** thay vào.
