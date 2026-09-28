# Kiến thức, quy định theo cấp học (từ 2.15.0)

Phần mềm "Trợ lý Quản trị trường học" dùng cho trường **tiểu học**, **trung học cơ sở**, **mầm non** và trường có **hai cấp học TH&THCS**. Cấp học khai ở cửa sổ **Khai báo thông tin trường** (ghi dòng `- Cấp học: ...` vào `09_BO_NHO_TRO_LY\thong-tin-truong.md`).

## Cách tổ chức

| Thư mục | Nội dung |
|---|---|
| `th\` | Tiểu học |
| `thcs\` | Trung học cơ sở |
| `mn\` | Mầm non |
| `th-thcs\` | Trường có hai cấp học TH&THCS (tệp chỉ đường, trỏ sang `th\` và `thcs\`) |
| `dang-dung\` | **Bản đang dùng** - phần mềm tự chép từ thư mục cấp học đã khai, mỗi lần mở (hàm `Dam-Bao-CapHoc` trong `cong-cu\_chung.ps1`). Quy trình và quy tắc chỉ trỏ tới đường dẫn này |

Mỗi thư mục cấp học có các tệp cùng tên: `_muc-luc.md`, `can-cu-cap-hoc.md`, `danh-gia-hoc-sinh.md`, `ke-hoach-giao-duc.md`, `de-kiem-tra.md`, `to-chuyen-mon.md`, `hoc-sinh.md`, `dac-thu.md` và thư mục `nhiem-vu\`.

## Thẻ nhiệm vụ theo chức danh

- Bộ **dùng chung** ở `mau\kien-thuc\nhiem-vu\` (hiện viết theo cấp tiểu học - cấp học ra trước nhất của phần mềm).
- Khi chép sang `dang-dung\`, phần mềm chép bộ dùng chung **trước**, rồi chép `<cấp học>\nhiem-vu\` **đè lên**. Vì vậy:
  - `th\nhiem-vu\` không cần tệp nào (bộ dùng chung đã là bản tiểu học);
  - `thcs\nhiem-vu\` chỉ chứa `_danh-muc.md` và các thẻ **khác** bản tiểu học;
  - `mn\nhiem-vu\` chứa `_danh-muc.md` và đủ các thẻ của cấp mầm non (thuật ngữ, nhiệm vụ khác hẳn).
- Trang **Việc của tôi** dựng các ô theo `dang-dung\nhiem-vu\_danh-muc.md`; thẻ mà danh mục không nhắc tới thì không dùng.

## Khi sửa nội dung

1. Sửa trong thư mục cấp học (`th\`, `thcs\`, `mn\`), **không sửa `dang-dung\`** - thư mục này bị xóa và chép lại.
2. Ép chép lại: xóa `dang-dung\_cap-hoc.txt` rồi mở lại phần mềm.
3. Chỉ ghi văn bản pháp lý đã đối chiếu bản gốc; chưa chắc thì ghi `[CẦN KIỂM TRA]` kèm điều cần kiểm tra. Cấp học này thiếu quy định nào thì nói rõ là thiếu - **không lấy quy định của cấp học khác** thay vào.
