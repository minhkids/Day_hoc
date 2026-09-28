# Thể thức văn bản hành chính - hướng dẫn soạn cho trợ lý

> Căn cứ: Nghị định số 30/2020/NĐ-CP ngày 05/3/2020 của Chính phủ về công tác văn thư - Phụ lục I (thể thức, kỹ thuật trình bày), Phụ lục II (viết hoa), Phụ lục III (chữ viết tắt tên loại, mẫu trình bày), Phụ lục IV (mẫu quản lý văn bản đến, đi).
> Công cụ `cong-cu\xuat-word.ps1` tự trình bày đúng khổ giấy, lề, phông, cỡ chữ, đường kẻ, số trang. Trợ lý chỉ cần viết **khối thông tin** và **phần nội dung** đúng quy tắc dưới đây.

## 1. Cấu trúc file .md

Mỗi văn bản gồm hai phần:

1. **Khối thông tin** giữa hai dòng `---` ở đầu file (xem các mẫu trong `mau/`):

| Khóa | Nội dung | Ghi chú |
|---|---|---|
| `loai` | `cong-van`, `quyet-dinh`, `ke-hoach`, `bao-cao`, `thong-bao`, `to-trinh`, `giay-moi`, `bien-ban`, `lich-tuan`, `giay-gioi-thieu`, `giay-nghi-phep`, `quy-che`, `quy-dinh`, `huong-dan`, `chuong-trinh`, `khac` | quyết định tên loại in trên văn bản |
| `co_quan_chu_quan` | UBND XÃ ... | để `""` nếu không có; thiếu khóa thì lấy từ bộ nhớ trường |
| `ten_co_quan` | TRƯỜNG TIỂU HỌC ... | công cụ tự nới cột để tên nằm trên **một dòng** (chỉ tách dòng khi tên quá dài); không tự ngắt bằng ` \| ` trừ khi thầy/cô yêu cầu |
| `so` | `"      /QĐ-THQC1"` | để trống phần số cho văn thư ghi; công văn: `"      /THQC1-CM"` |
| `dia_danh_ngay` | `"Quảng Châu, ngày      tháng      năm 2026"` | biên bản để `""` |
| `ten_loai` | chỉ ghi khi muốn khác tên mặc định của `loai` | |
| `trich_yeu` | công văn: `V/v ...`; loại khác: câu ngắn phản ánh nội dung | nhiều dòng: ngắt bằng ` \| ` |
| `kem_theo` | `(Kèm theo Quyết định số .../QĐ-... ngày ... của ...)` | văn bản ban hành kèm quyết định (quy chế, quy định...) |
| `tham_quyen` | HIỆU TRƯỞNG TRƯỜNG TIỂU HỌC ... | chỉ quyết định, nghị quyết |
| `kinh_gui` | danh sách nơi nhận chính | công văn, tờ trình, báo cáo gửi cấp trên |
| `quyen_han` | `KT. HIỆU TRƯỞNG`, `TM. ...`, `Q. HIỆU TRƯỞNG`, `TL. ...`, `TUQ. ...` | bỏ trống khi Hiệu trưởng ký |
| `chuc_vu` | HIỆU TRƯỞNG / PHÓ HIỆU TRƯỞNG / CHỦ TỌA | |
| `nguoi_ky` | Họ và tên (không ghi học hàm, học vị) | |
| `chuc_vu_trai`, `nguoi_ky_trai` | THƯ KÝ và họ tên | chỉ biên bản (người ký bên trái) |
| `noi_nhan` | danh sách; dòng cuối `Lưu: VT, <đơn vị soạn thảo>.` | công văn, tờ trình, báo cáo có Kính gửi: dòng đầu `Như trên;` |
| `do_khan` | `KHẨN`, `THƯỢNG KHẨN`, `HỎA TỐC` | chỉ khi thật cần |
| `ky_hieu_soan_thao` | ví dụ `CM.(05)` | ký hiệu người soạn, số bản phát hành (tùy chọn) |
| `dia_chi` | các dòng địa chỉ, điện thoại, email | chân trang đầu công văn (tùy chọn) |
| `file_word` | (công cụ xuất Word tự ghi) | tên file Word đã xuất ra thư mục ngoài - không tự sửa, không xóa |

Giá trị có dấu hai chấm hoặc bắt đầu bằng dấu ngoặc vuông thì đặt trong ngoặc kép `"..."`.

2. **Phần nội dung** viết Markdown:
- Mỗi đoạn cách nhau một dòng trống. Công cụ tự canh đều hai lề, lùi đầu dòng 1,27 cm, cỡ 14, cách đoạn 6pt.
- Căn cứ ban hành: in nghiêng `*Căn cứ ...;*`, mỗi căn cứ một đoạn, cuối dòng `;`, căn cứ cuối cùng kết thúc bằng `.`
- Mục lớn `## I. TIÊU ĐỀ IN HOA`; khoản có tiêu đề `### 1. Tiêu đề`; khoản không tiêu đề `1. Nội dung`; điểm `a) Nội dung` (theo thứ tự chữ cái tiếng Việt: a, b, c, d, đ, e, g...); gạch đầu dòng `- Nội dung`.
- Điều: `**Điều 1.** Nội dung` hoặc `**Điều 1. Tiêu đề điều**` rồi xuống đoạn.
- Phần, chương: dòng riêng canh giữa, đậm: dùng khối `::: {custom-style="Giua dam"}` cho "Phần I", "Chương I" và dòng tiêu đề IN HOA ngay dưới.
- Dòng canh giữa, đậm (ví dụ `QUYẾT ĐỊNH:`, `DANH SÁCH...`): `::: {custom-style="Giua dam"}` ... `:::`. Dòng canh giữa, nghiêng (ví dụ `(Kèm theo ...)`): `::: {custom-style="Giua nghieng"}` ... `:::`.
- Bảng số liệu: bảng Markdown bình thường (có viền, trải đủ khổ, hàng đầu đậm). Bảng từ 7 cột công cụ tự dùng cỡ chữ 12.
- `[[CHU-KY]]`: vị trí đặt khối chữ ký và nơi nhận (khi sau chữ ký còn danh sách, phụ lục). Không có dấu này thì khối chữ ký đặt cuối văn bản.
- `[[TRANG-MOI]]`: sang trang mới (trước phụ lục, danh sách kèm theo).
- Không dùng thẻ HTML, ký tự tab. Không tự vẽ bảng tiêu đề, bảng chữ ký.

## 2. Quy tắc thể thức cần nhớ khi soạn (Phụ lục I)

- **Số văn bản**: số nhỏ hơn 10 ghi thêm số 0 phía trước (05/QĐ-...). Ký hiệu in hoa, giữa các nhóm chữ viết tắt dùng dấu gạch nối, không cách chữ.
- **Ngày tháng**: viết đầy đủ "ngày 05 tháng 01 năm 2026" - ngày nhỏ hơn 10 và tháng 1, 2 ghi thêm số 0.
- **Địa danh**: tên đơn vị hành chính nơi trường đóng trụ sở (xã, phường), viết hoa chữ cái đầu, sau địa danh có dấu phẩy.
- **Tên cơ quan chủ quản** được viết tắt cụm từ thông dụng: "UBND XÃ ...".
- **Quyền hạn người ký**: Phó Hiệu trưởng ký thay ghi `quyen_han: KT. HIỆU TRƯỞNG`, `chuc_vu: PHÓ HIỆU TRƯỞNG`. Cấp phó được giao phụ trách cũng ký như ký thay.
- **Kính gửi**: một nơi nhận thì cùng dòng; nhiều nơi thì mỗi nơi một dòng, gạch đầu dòng, cuối dòng `;`, dòng cuối `.`
- **Nơi nhận**: mỗi nơi một dòng, cuối dòng `;`, dòng cuối "Lưu: VT, <chữ viết tắt đơn vị soạn thảo>, <số bản lưu>." Văn bản có "Kính gửi" thì nơi nhận bắt đầu bằng "Như trên;".
- **Viện dẫn văn bản**: lần đầu ghi đủ tên loại, số, ký hiệu, ngày ban hành, cơ quan ban hành, trích yếu (Luật chỉ ghi tên loại và tên luật); lần sau chỉ ghi tên loại và số, ký hiệu. Số, ngày chỉ lấy từ `mau/can-cu-phap-ly.md` và `09_BO_NHO_TRO_LY/can-cu-dia-phuong.md`.
- **Phụ lục**: văn bản có phụ lục phải có chỉ dẫn trong nội dung; từ 2 phụ lục trở lên đánh số La Mã (Phụ lục I, II). Trình bày: dòng "Phụ lục I" (đậm, canh giữa), tiêu đề IN HOA đậm, dòng "(Kèm theo Văn bản số ... ngày ... của ...)" nghiêng.
- **Kết thúc nội dung** văn bản bằng dấu `./.`

## 3. Chữ viết tắt tên loại văn bản (Phụ lục III)

Quyết định QĐ · Quy chế QC · Quy định QyĐ · Thông báo TB · Hướng dẫn HD · Chương trình CTr · Kế hoạch KH · Phương án PA · Đề án ĐA · Báo cáo BC · Biên bản BB · Tờ trình TTr · Hợp đồng HĐ · Giấy ủy quyền GUQ · Giấy mời GM · Giấy giới thiệu GGT · Giấy nghỉ phép GNP · Phiếu gửi PG · Phiếu chuyển PC · Phiếu báo PB. Công văn không có chữ viết tắt tên loại: `Số: .../<viết tắt trường>-<viết tắt đơn vị soạn thảo hoặc lĩnh vực>`. Bản sao: SY (sao y), TrS (trích sao), SL (sao lục).

## 4. Viết hoa (Phụ lục II)

- Tên người: viết hoa chữ cái đầu mọi âm tiết (Nguyễn Thị Hà).
- Đơn vị hành chính: danh từ chung viết thường, tên riêng viết hoa, không gạch nối: xã Quảng Châu, tỉnh Nghệ An. Tên có chữ số viết hoa cả danh từ chung: Quận 1, Phường 3.
- Cơ quan, tổ chức: viết hoa chữ cái đầu của từ chỉ loại hình và chức năng, lĩnh vực: Bộ Giáo dục và Đào tạo, Sở Giáo dục và Đào tạo, Ủy ban nhân dân xã Quảng Châu, Trường Tiểu học Quảng Châu 1, Hội đồng sư phạm.
- Chức vụ viết hoa khi đi liền tên người: Hiệu trưởng Trần Thị A; đứng một mình trong câu thì viết thường (các phó hiệu trưởng, giáo viên chủ nhiệm).
- Tên loại văn bản khi nói đến một văn bản cụ thể: viết hoa chữ đầu tên loại (Kế hoạch số 12/KH-..., Luật Giáo dục). Viện dẫn: viết hoa Phần, Chương, Mục, Điều; viết thường khoản, điểm (điểm a khoản 2 Điều 5).
- Ngày trong tuần, tháng khi không dùng chữ số: thứ Hai, thứ Bảy, tháng Tám. Tết: tết Nguyên đán, tết Trung thu; "Tết" khi thay cho tết Nguyên đán.
- Ngày lễ: ngày Nhà giáo Việt Nam 20-11, ngày Quốc khánh 2-9. Danh hiệu: Nhà giáo Ưu tú, Chiến sĩ thi đua cơ sở.
- Đặc biệt: Nhà nước, Nhân dân (viết hoa khi dùng như danh từ riêng).

## 5. Mẫu tương ứng (Phụ lục III)

| Loại | Mẫu NĐ 30 | File mẫu |
|---|---|---|
| Quyết định cá biệt | Mẫu 1.2 (quy định trực tiếp), 1.3 (ban hành/phê duyệt văn bản khác) | `mau/quyet-dinh.md` |
| Kế hoạch, báo cáo, thông báo, tờ trình, hướng dẫn, chương trình, quy chế... | Mẫu 1.4 (văn bản có tên loại) | `mau/ke-hoach.md`, `bao-cao.md`, `thong-bao.md`, `to-trinh.md` |
| Công văn | Mẫu 1.5 | `mau/cong-van.md` |
| Giấy mời | Mẫu 1.7 | `mau/giay-moi.md` |
| Giấy giới thiệu | Mẫu 1.8 | `mau/giay-gioi-thieu.md` |
| Biên bản | Mẫu 1.9 | `mau/bien-ban.md` |
| Giấy nghỉ phép | Mẫu 1.10 | `mau/giay-nghi-phep.md` |
| Phụ lục văn bản | Mẫu 2.1 | xem mục 2 ở trên |
| Phiếu giải quyết văn bản đến | Phụ lục IV, mục VII | `mau/phieu-giai-quyet-van-ban-den.md` |
| Văn bản ban hành kèm quyết định (quy chế, quy định) | Mẫu "văn bản kèm theo quyết định" | dùng `loai: quy-che`, `kem_theo: (...)`, `so: ""`, `dia_danh_ngay: ""`, không có khối chữ ký |

## 6. Văn phong

- Câu ngắn, chủ động, rõ chủ thể; không dùng từ cảm thán, khẩu ngữ. Xưng "Trường Tiểu học ..." hoặc "nhà trường".
- Công văn, tờ trình mở đầu bằng căn cứ hoặc lý do; kết thúc: "... trân trọng báo cáo/đề nghị ...", tờ trình: "Kính đề nghị ... xem xét, phê duyệt./."
- Số liệu thống nhất: 1.250 học sinh; tỷ lệ 98,5%; số La Mã cho phần, mục lớn.
- Không bịa số liệu, số hiệu, điều khoản: chỗ chưa có ghi `[CẦN BỔ SUNG]`, căn cứ chưa chắc ghi `[CẦN KIỂM TRA]`.
