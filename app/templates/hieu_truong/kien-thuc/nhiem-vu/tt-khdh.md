# Thẻ nhiệm vụ: Kế hoạch dạy học các môn (Tổ trưởng chuyên môn)

> Trợ lý chuyên trách nhiệm vụ này đọc thẻ trước khi làm, rồi đọc hồ sơ nhiệm vụ `09_BO_NHO_TRO_LY/nhiem-vu/tt-khdh.md` của trường. Chỉ trích căn cứ có trong `{{HE_THONG}}\mau\can-cu-phap-ly.md`, `can-cu-bo-sung.md`, `can-cu-dia-phuong.md`; văn bản khác → `[CẦN KIỂM TRA]`. Thẻ do phần mềm cung cấp (chỉ đọc); điều riêng của trường ghi vào hồ sơ nhiệm vụ.

## Phạm vi
- Tổ chuyên môn xây dựng kế hoạch dạy học các môn học, hoạt động giáo dục theo khối lớp trong tổ (Phụ lục 2 Công văn 2345): lấy bản tham khảo, điều chỉnh theo lịch năm học, điều kiện của trường, nội dung tích hợp; tổ thảo luận, tổ trưởng ký, trình Hiệu trưởng phê duyệt; điều chỉnh khi lịch học thay đổi.
- Không thuộc nhiệm vụ này: kế hoạch giáo dục nhà trường - Phụ lục 1 (`ht-ke-hoach`); theo dõi thực hiện chương trình các khối, thời khóa biểu, dạy thay (`pht-chuong-trinh`); kế hoạch bài dạy của giáo viên - Phụ lục 3 (giáo viên soạn; góp ý thuộc `tt-ho-tro-gv`); phạm vi đề kiểm tra (`tt-de-kiem-tra`).

## Căn cứ
- **Điều lệ trường (Thông tư 15/2026/TT-BGDĐT)**: Điều 13 khoản 2 điểm b (thực hiện chủ động, linh hoạt kế hoạch giáo dục của tổ theo kế hoạch giáo dục của nhà trường đã được phê duyệt); Điều 17 khoản 1, 2 (thực hiện chương trình, khung kế hoạch thời gian năm học), khoản 4 (học sinh khuyết tật học hòa nhập được thực hiện kế hoạch giáo dục linh hoạt).
- **Công văn 2345/BGDĐT-GDTH** ngày 07/6/2021, **Phụ lục 2**: bảng Tuần, tháng | Chương trình và sách giáo khoa (Chủ đề/Mạch nội dung; Tên bài học; Tiết học/thời lượng) | Nội dung điều chỉnh, bổ sung (nếu có) | Ghi chú; ký Tổ trưởng, Hiệu trưởng. Công văn còn dẫn Thông tư 28/2020 và Phòng GD&ĐT - khi soạn thay bằng Thông tư 15/2026 và cơ quan hiện hành.
- **Thông tư 32/2018/TT-BGDĐT** (Chương trình giáo dục phổ thông; sửa đổi, bổ sung bởi Thông tư 20/2021, 13/2022, 17/2025).
- **Quyết định 2308/QĐ-BGDĐT**: 35 tuần (học kỳ I 18 tuần, học kỳ II 17 tuần); kết thúc học kỳ I trước 18/01, năm học trước 31/5. Lịch cụ thể theo UBND tỉnh (`lich-nam-hoc.md`).
- **Công văn 5208/BGDĐT-GDPT** ngày 07/8/2026 (nhiệm vụ năm học 2026-2027); Công văn 5555/BGDĐT-GDPT (kế hoạch giáo dục thống nhất toàn trường).
- Nội dung tích hợp theo bộ tham khảo (Thông tư 02/2025 khung năng lực số người học, Thông tư 08/2024 giáo dục quốc phòng và an ninh, Công văn 3456/BGDĐT-GDPT): chưa đối chiếu bản gốc - chỉ dẫn ở mức văn bản, không ghi điều khoản.

## Sản phẩm thường làm
| Sản phẩm | Quy trình | Ghi chú |
|---|---|---|
| Kế hoạch dạy học cả khối (mọi môn) | `/khgd-mon-hoc` | `{{HE_THONG}}\cong-cu\khdh.ps1 -Lop <n> -To "<Tổ>"`; khổ ngang |
| Kế hoạch dạy học một môn của khối | `/khgd-mon-hoc` | thêm `-Mon <môn>`; xem các môn: `-DanhSach` |
| Điều chỉnh kế hoạch (dời tiết, tuần nghỉ, tích hợp) | `/khgd-mon-hoc` | sửa đúng dòng trong `.csv`, dựng lại bằng `-Dung` |
| Biên bản tổ thống nhất kế hoạch dạy học | `/to-chuyen-mon` | mẫu `to-bien-ban.md` |

## Việc theo tháng
| Tháng | Việc |
|---|---|
| 8 | Lấy bản tham khảo kế hoạch dạy học các khối; phân công giáo viên dự thảo điều chỉnh từng môn; ghi điều kiện thực hiện của từng khối |
| 9 | Tổ thảo luận, thống nhất; tổ trưởng ký, trình Hiệu trưởng phê duyệt theo khối (theo hạn của trường); giáo viên triển khai theo kế hoạch đã duyệt |
| 10 | Rà tiến độ thực hiện kế hoạch dạy học tại buổi sinh hoạt tổ; ghi nhận nội dung cần điều chỉnh |
| 11 | Điều chỉnh tiết bị ảnh hưởng do nghỉ đột xuất, thời tiết (nếu có); ghi cột Ghi chú |
| 12 | Rà kế hoạch đến hết học kỳ I, bảo đảm dạy đủ trước kiểm tra cuối học kỳ I |
| 1 | Đánh giá thực hiện học kỳ I; điều chỉnh kế hoạch học kỳ II theo lịch năm học của tỉnh |
| 2 | Dời tiết theo lịch nghỉ Tết của tỉnh (nếu khác dự kiến); cập nhật cột Ghi chú |
| 3 | Rà tiến độ học kỳ II; điều chỉnh nội dung tích hợp, giáo dục địa phương khi cần |
| 4 | Rà kế hoạch đến cuối năm, bảo đảm dạy đủ trước kiểm tra cuối năm học |
| 5 | Đánh giá thực hiện kế hoạch dạy học cả năm; đề xuất điều chỉnh cho năm học sau |

## Hồ sơ cần có
- Kế hoạch dạy học từng khối có chữ ký Tổ trưởng và phê duyệt của Hiệu trưởng (hồ sơ điện tử là chủ yếu - Điều 21 khoản 4 Điều lệ).
- Nội dung tổ thảo luận, điều chỉnh ghi trong sổ ghi chép nội dung các hoạt động của tổ (Điều 21 khoản 3 Điều lệ).
- Bản `.csv`, `.md` trong `11_TO_CHUYEN_MON/<Tổ>/.tro-ly/` để lần sau điều chỉnh, lấy phạm vi đề kiểm tra.

## Bộ nhớ cần đọc
- Hồ sơ nhiệm vụ này; `to-chuyen-mon.md` (tổ, tổ trưởng, khối lớp); `lich-nam-hoc.md` (tuần học, nghỉ lễ, nghỉ Tết); `so-lieu.md` khi viết mục II (số lớp, học sinh, thiết bị).
- `03_KE_HOACH/.tro-ly/_MUC_LUC.md` (kế hoạch giáo dục nhà trường: dạy 2 buổi/ngày, Tiếng Anh, Tin học, giáo dục địa phương); `can-cu-dia-phuong.md` (hướng dẫn của Sở).
- Nghiệp vụ: `{{HE_THONG}}\mau\kien-thuc\nghiep-vu-to-chuyen-mon.md` mục 2.

## Lưu ý, sai sót hay gặp
- **Không tự nghĩ tên bài, số tiết**: luôn lấy từ `khdh.ps1`; không tải được thì báo thầy/cô, không tự dựng danh sách bài.
- Không đọc toàn bộ bảng (tốn lượt dùng): tìm đúng dòng trong `.csv` bằng Grep theo tuần, tên bài rồi sửa từng dòng.
- Nội dung tích hợp (năng lực số, AI, quốc phòng và an ninh, kĩ năng sống, giáo dục địa phương...) ghi ở cột "Nội dung điều chỉnh, bổ sung" - không thêm cột riêng.
- Không ghi tên bộ sách giáo khoa; ghi "sách giáo khoa Toán 4"...; không tự đổi tên bài, chủ đề của bộ tham khảo khi thầy/cô chưa chỉ rõ.
- Kế hoạch dạy học ký khác văn bản tổ thông thường: **Tổ trưởng bên trái, Hiệu trưởng bên phải**.
- Không dẫn Thông tư 28/2020, không ghi "Phòng GD&ĐT" dù Công văn 2345 còn dẫn.
- Không bắt giáo viên chép tay kế hoạch dạy học; dùng một bản điện tử chung của khối.

## Gợi ý giao việc
- Kế hoạch dạy học cả khối lớp năm học {namhoc}: (ghi lớp)
- Kế hoạch dạy học môn (ghi môn) lớp (ghi lớp) theo Phụ lục 2
- Điều chỉnh kế hoạch dạy học lớp (ghi lớp) do nghỉ học tuần (ghi tuần, lý do)
- Bổ sung nội dung giáo dục địa phương, năng lực số vào kế hoạch dạy học lớp (ghi lớp, môn)
- Rà soát tiến độ kế hoạch dạy học các khối trong tổ tháng {thang} (ghi tuần đang dạy)
