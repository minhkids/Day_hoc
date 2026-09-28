# Thể thức văn bản của Đảng - hướng dẫn soạn cho trợ lý

> Căn cứ: Quy định số 399-QĐ/TW, ngày 09/01/2026 của Ban Bí thư về thể loại, thẩm quyền ban hành và thể thức văn bản của Đảng (thay Quy định 66-QĐ/TW năm 2017); Hướng dẫn số 05-HD/VPTW, ngày 27/5/2026 của Văn phòng Trung ương Đảng về thể thức và kỹ thuật trình bày văn bản của Đảng (thay Hướng dẫn 36-HD/VPTW năm 2018).
> Dùng cho văn bản của **đảng ủy trường** (đảng bộ cơ sở), **ban thường vụ đảng ủy trường** (nếu có), **chi bộ trực thuộc**, **chi bộ cơ sở**. KHÔNG trình bày các văn bản này theo Nghị định 30.
> Công cụ `cong-cu\xuat-word.ps1` tự trình bày: lề trên 20, dưới 20, trái 30, phải 15 mm; tiêu đề "ĐẢNG CỘNG SẢN VIỆT NAM"; tên tổ chức và dấu sao; "Số 05-NQ/ĐU"; tên loại, trích yếu, "-----"; lời văn cỡ 14 giãn dòng 19 pt, lùi đầu dòng 10 mm; khối ký (chức vụ không đậm); "Nơi nhận" gạch chân; số trang. Trợ lý chỉ viết **khối thông tin** và **nội dung** đúng quy tắc dưới đây.

## 1. Khối thông tin (giữa hai dòng `---`)

| Khóa | Nội dung |
|---|---|
| `the_thuc` | luôn ghi `dang` (file nằm trong `10_CONG_TAC_DANG/` công cụ cũng tự hiểu) |
| `loai` | `nghi-quyet`, `quyet-dinh`, `ket-luan`, `quy-che`, `thong-bao`, `bao-cao`, `ke-hoach`, `chuong-trinh`, `de-an`, `phuong-an`, `to-trinh`, `cong-van`, `bien-ban`, `giay-moi`, `giay-gioi-thieu` |
| `co_quan_chu_quan` | tổ chức đảng cấp trên trực tiếp: `ĐẢNG BỘ XÃ ...` (đảng ủy trường, chi bộ cơ sở), `ĐẢNG BỘ TRƯỜNG ...` (chi bộ trực thuộc). Bỏ khóa thì công cụ lấy từ `09_BO_NHO_TRO_LY/to-chuc-dang.md` |
| `ten_co_quan` | tổ chức ban hành: `ĐẢNG ỦY TRƯỜNG ...`, `CHI BỘ ...`. Văn bản của ban thường vụ cũng ghi tên đảng ủy. Bỏ khóa thì lấy từ bộ nhớ |
| `so` | để trống phần số: `"      -NQ/ĐU"` (chi bộ: `"      -NQ/CB"`; công văn: `"      -CV/ĐU"`); có số thì `"12-NQ/ĐU"` (công cụ tự thêm chữ "Số", không có dấu hai chấm) |
| `dia_danh_ngay` | `"[Địa danh], ngày      tháng      năm 2026"`; biên bản để `""` |
| `trich_yeu` | chữ thường, ví dụ `về lãnh đạo thực hiện nhiệm vụ năm học 2026 - 2027`; công văn: `về việc ...` (không viết "V/v") |
| `kinh_gui` | **chỉ công văn** |
| `kinh_trinh` | **chỉ tờ trình** |
| `tham_quyen` | dòng chủ thể khi cần (quyết định), ví dụ `BAN THƯỜNG VỤ ĐẢNG ỦY TRƯỜNG ... QUYẾT ĐỊNH:` - thực tiễn, HD 05 không quy định |
| `quyen_han` | `T/M ĐẢNG ỦY`, `T/M BAN THƯỜNG VỤ`, `T/M CHI BỘ`, `T/M ỦY BAN KIỂM TRA`; bỏ trống thì công cụ tự ghi theo tên tổ chức |
| `chuc_vu` | `BÍ THƯ` hoặc `PHÓ BÍ THƯ` (không kèm tên cấp ủy); bỏ trống = `BÍ THƯ` |
| `nguoi_ky` | họ tên đầy đủ, không ghi học hàm, học vị |
| `chuc_vu_trai`, `nguoi_ky_trai`, `chuc_vu`, `nguoi_ky` | biên bản: `NGƯỜI GHI BIÊN BẢN` (bên trái), `CHỦ TRÌ HỘI NGHỊ` (bên phải) |
| `noi_nhan` | mỗi nơi một dòng; dòng cuối `Lưu Đảng ủy.` hoặc `Lưu Chi bộ.` (không có dấu hai chấm, không có "VT"). Công văn, tờ trình: dòng đầu `Như trên;` |
| `du_thao` | `Dự thảo lần 1` - khi trình hội nghị cho ý kiến |
| `do_khan` | `KHẨN`, `THƯỢNG KHẨN`, `HỎA TỐC` - chỉ khi thật cần |
| `pham_vi_luu_hanh` | `TÀI LIỆU HỘI NGHỊ`... - chỉ khi cần |

Giá trị có dấu hai chấm hoặc bắt đầu bằng dấu ngoặc vuông thì đặt trong ngoặc kép.

## 2. Quy tắc cần nhớ

- **Số văn bản** đánh liên tục từ 01 **cho từng tên loại, trong một nhiệm kỳ cấp ủy** (từ bế mạc đại hội này đến bế mạc đại hội sau) - không đánh lại theo năm. Số nhỏ hơn 10 thêm số 0. Mặc định để trống phần số; thầy/cô cho số thì lấy số, rồi ghi vào mục "Số văn bản Đảng đã dùng gần nhất" của `to-chuc-dang.md`.
- **Ký hiệu tổ chức**: `ĐU` (đảng ủy, kể cả văn bản của ban thường vụ), `CB` (chi bộ). Ví dụ `Số 05-NQ/ĐU`, `Số 03-BC/CB`.
- **Ngày tháng**: ngày nhỏ hơn 10 và tháng 1, 2 thêm số 0: `ngày 05 tháng 02 năm 2026`, `ngày 27 tháng 5 năm 2026`.
- **Địa danh**: địa danh nơi trường đóng (như văn bản hành chính của trường).
- **Viết "ĐẢNG ỦY"**, "Đảng ủy" (không viết "UỶ", "uỷ").
- **Căn cứ** (nếu có): in đứng, mỗi căn cứ một dòng bắt đầu bằng `- `, cuối dòng `;`, căn cứ cuối cùng `.` (hoặc `,` khi ngay sau là câu chủ thể).
- **Nội dung kết thúc bằng dấu chấm `.`** - không dùng `./.`.
- **Đề mục** (theo thói quen văn bản Đảng): `## I- TÊN MỤC IN HOA`, `### 1. Tên khoản`, điểm `a)`, gạch đầu dòng `- `. Nghị quyết, kế hoạch, báo cáo dùng I-, II-, III-...
- **Viện dẫn**: lần đầu ghi đủ "Nghị quyết số 12-NQ/ĐU, ngày 05/9/2026 của Đảng ủy Trường ... về ..." (có dấu phẩy trước "ngày"); lần sau chỉ "Nghị quyết 12-NQ/ĐU". Chữ viết tắt: lần đầu viết đủ, chữ viết tắt trong ngoặc đơn ngay sau.
- **Ký thay mặt**: cấp ủy là tập thể nên **không dùng K/T**; phó bí thư ký `T/M ĐẢNG ỦY` / `PHÓ BÍ THƯ`. Không có "T/U"; ủy quyền ký dùng `T/L`.
- **Chi bộ không có con dấu**: bí thư (hoặc phó bí thư được phân công) ký `T/M CHI BỘ`, không đóng dấu. Cần văn bản có dấu thì ký thừa lệnh để dùng dấu của đảng ủy cấp trên - cách ghi khối ký cụ thể HD 05 không có mẫu: ghi `[CẦN KIỂM TRA: cách ký thừa lệnh theo quy chế của Đảng ủy]`.
- **Biên bản**: bên trái `NGƯỜI GHI BIÊN BẢN`, bên phải `CHỦ TRÌ HỘI NGHỊ`; dấu (nếu có) đóng lên chữ ký của chủ trì.

## 3. Ký hiệu tên loại văn bản

| Tên loại | Ký hiệu | | Tên loại | Ký hiệu |
|---|---|---|---|---|
| Nghị quyết | NQ | | Kế hoạch | KH |
| Quyết định, Quy định | QĐ | | Chương trình | CTr |
| Kết luận | KL | | Tờ trình | TTr |
| Quy chế | QC | | Công văn (không in tên loại) | CV |
| Thông báo | TB | | Biên bản | BB |
| Báo cáo | BC | | Đề án, Phương án | ĐA, PA |

Giấy mời, giấy giới thiệu: HD 05 không quy định ký hiệu; dùng `GM`, `GGT` theo quy tắc chữ cái đầu và ghi rõ là giả định, hoặc theo cách Đảng ủy cấp trên đang dùng.

## 4. Thẩm quyền ban hành (Quy định 399-QĐ/TW, Điều 11, 13)

| Loại | Đảng ủy cơ sở (BCH) | Ban Thường vụ đảng ủy cơ sở | Chi bộ (cơ sở, trực thuộc) |
|---|---|---|---|
| Nghị quyết, Quyết định, Kết luận, Thông báo, Báo cáo, Kế hoạch, Chương trình, Đề án, Phương án, Tờ trình, Công văn, Biên bản | Có | Có | Có |
| Quy chế | Có | **Không** | Có |
| Quy định | Có | Có | **Không** |
| Hướng dẫn | **Không** | Có | **Không** |
| Chỉ thị, Thông tri | Không | Không | Không |

Mọi tổ chức đảng đều được ban hành giấy tờ hành chính: giấy giới thiệu, giấy chứng nhận, giấy đi đường, giấy nghỉ phép, giấy mời, phiếu chuyển, phiếu gửi, thư công. Đại hội chi bộ: nghị quyết, quy chế, chương trình, công văn, biên bản (số riêng, ký hiệu `ĐH`).

## 5. Mẫu

| Loại | File mẫu |
|---|---|
| Nghị quyết (tháng, chuyên đề, năm) | `mau/dang-nghi-quyet.md` |
| Biên bản sinh hoạt chi bộ, hội nghị đảng ủy | `mau/dang-bien-ban.md` |
| Kế hoạch | `mau/dang-ke-hoach.md` |
| Chương trình (công tác năm, kiểm tra - giám sát) | `mau/dang-chuong-trinh.md` |
| Báo cáo (tháng, sơ kết, tổng kết, kiểm điểm) | `mau/dang-bao-cao.md` |
| Thông báo (kết luận hội nghị...) | `mau/dang-thong-bao.md` |
| Quyết định | `mau/dang-quyet-dinh.md` |
| Tờ trình | `mau/dang-to-trinh.md` |
| Công văn | `mau/dang-cong-van.md` |
| Giấy mời | `mau/dang-giay-moi.md` |

Mẫu biểu nghiệp vụ công tác đảng viên (hồ sơ kết nạp, giấy giới thiệu sinh hoạt đảng, phiếu đánh giá...) là văn bản chuyên ngành theo hướng dẫn của Ban Tổ chức Trung ương - dùng biểu mẫu chính thức, trợ lý chỉ lập danh mục, hướng dẫn điền, không tự chế mẫu.

## 6. Văn phong

- Chủ thể: "Đảng ủy", "Ban Thường vụ Đảng ủy", "Chi bộ"; gọi đảng viên là "đồng chí".
- Nghị quyết: kết quả - hạn chế, nguyên nhân - nhiệm vụ, giải pháp - tổ chức thực hiện; giao việc cụ thể cho chi bộ, đảng ủy viên, người đứng đầu nhà trường, đoàn thể, có thời hạn. Nghị quyết do hội nghị thông qua: trình dự thảo thì ghi `du_thao`.
- Không bịa số liệu, số hiệu, tên người: chỗ chưa có ghi `[CẦN BỔ SUNG]`, căn cứ chưa chắc ghi `[CẦN KIỂM TRA]`.
