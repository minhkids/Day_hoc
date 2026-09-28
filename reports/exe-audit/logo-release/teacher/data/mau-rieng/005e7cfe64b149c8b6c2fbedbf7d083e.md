# Thể thức tài liệu, văn bản - hướng dẫn soạn cho trợ lý (Giáo viên THCS)

> Căn cứ: Nghị định số 30/2020/NĐ-CP ngày 05/3/2020 của Chính phủ về công tác văn thư - Phụ lục I (thể thức, kỹ thuật trình bày), Phụ lục II (viết hoa), Phụ lục III (chữ viết tắt tên loại, mẫu trình bày); khung kế hoạch giáo dục, kế hoạch bài dạy theo Công văn số 5512/BGDĐT-GDTrH ngày 18/12/2020; ma trận, bản đặc tả đề kiểm tra theo Phụ lục Công văn số 7991/BGDĐT-GDTrH ngày 17/12/2024; Điều lệ trường kèm Thông tư số 15/2026/TT-BGDĐT (trường THCS do UBND cấp xã quản lý).
> Công cụ `cong-cu\xuat-word.ps1` tự trình bày khổ giấy, lề, phông Times New Roman, cỡ chữ, đường kẻ, số trang. Trợ lý chỉ cần viết **khối thông tin** và **phần nội dung** đúng quy tắc dưới đây.

## 1. Cấu trúc file .md

Mỗi file gồm hai phần:

1. **Khối thông tin** giữa hai dòng `---` ở đầu file (xem các mẫu trong `mau/`).
2. **Phần nội dung** viết Markdown.

Có **hai chế độ trình bày**:

| Chế độ | Khi nào | Công cụ dựng gì |
|---|---|---|
| **Tự do** (`the_thuc: tu-do`) | Tài liệu dạy học, kiểm tra: kế hoạch bài dạy, kế hoạch giáo dục của giáo viên, phiếu học tập, đề cương ôn tập, ma trận - bản đặc tả, đề kiểm tra, hướng dẫn chấm, thư gửi cha mẹ học sinh, bảng nhận xét, bản mô tả sáng kiến | **Không dựng gì** ở đầu, cuối: không Quốc hiệu, tên cơ quan, số, ngày, tên loại, trích yếu, khối chữ ký, nơi nhận. Mọi tiêu đề, dòng thông tin, bảng ký viết trong phần nội dung |
| **Hành chính NĐ 30** (không có khóa `the_thuc`) | Báo cáo, biên bản, kế hoạch của tổ/lớp/trường, đơn, giấy nghỉ phép, công văn dự thảo cho trường, bản tự đánh giá | Quốc hiệu - Tiêu ngữ, tên cơ quan, số, địa danh - ngày, tên loại, trích yếu, đường kẻ, Kính gửi, khối chữ ký, Nơi nhận, số trang |

### 1a. Khối thông tin - chế độ tự do

| Khóa | Nội dung | Ghi chú |
|---|---|---|
| `the_thuc` | `tu-do` | bắt buộc |
| `loai` | `khac` | |
| `ten_loai` | "Kế hoạch bài dạy", "Đề kiểm tra", "Ma trận, bản đặc tả", "Hướng dẫn chấm", "Phiếu học tập", "Đề cương ôn tập", "Kế hoạch giáo dục của giáo viên", "Thư gửi cha mẹ học sinh", "Sáng kiến" | chỉ dùng đặt tên file Word, không in ra |
| `trich_yeu` | "Toán 6 - Bài 3. Thứ tự trong tập hợp các số tự nhiên" | chỉ dùng đặt tên file Word |
| `huong_giay` | `ngang` | bảng nhiều cột: kế hoạch giáo dục, ma trận, bản đặc tả, bảng điểm |
| `file_word` | (công cụ tự ghi) | không tự sửa, không xóa |

### 1b. Khối thông tin - chế độ NĐ 30

| Khóa | Nội dung | Ghi chú |
|---|---|---|
| `loai` | `ke-hoach`, `bao-cao`, `bien-ban`, `thong-bao`, `to-trinh`, `giay-moi`, `giay-nghi-phep`, `cong-van`, `chuong-trinh`, `huong-dan`, `quyet-dinh`, `khac` | quyết định tên loại in trên văn bản (`khac` + `ten_loai` cho đơn) |
| `co_quan_chu_quan` | xem mục 2 | **luôn ghi rõ** (kể cả `""`) - không để công cụ tự điền |
| `ten_co_quan` | xem mục 2 | ` \| ` để ngắt dòng; **luôn ghi rõ** |
| `so` | `""` (văn bản tổ, lớp, cá nhân); `"      /KH-THCS"` (văn bản của trường - ký hiệu theo quy định của trường) | để trống phần số cho văn thư |
| `dia_danh_ngay` | `"Bạch Liêu, ngày      tháng      năm 2026"` | biên bản để `""` |
| `ten_loai` | khi muốn khác tên mặc định (`ĐƠN XIN NGHỈ PHÉP`, `BẢN TỰ ĐÁNH GIÁ`) | |
| `trich_yeu` | công văn: `V/v ...`; loại khác: câu ngắn | nhiều dòng: ngắt bằng ` \| ` |
| `du_thao` | `"DỰ THẢO"` | dự thảo trình Hiệu trưởng |
| `kinh_gui` | danh sách nơi nhận chính | báo cáo, đơn, tờ trình gửi Hiệu trưởng |
| `quyen_han` | `KT. HIỆU TRƯỞNG` | chỉ khi Phó Hiệu trưởng ký thay |
| `chuc_vu`, `nguoi_ky` | chức danh in hoa, họ tên | `TỔ TRƯỞNG`, `GIÁO VIÊN CHỦ NHIỆM`, `HIỆU TRƯỞNG`, `NGƯỜI BÁO CÁO`, `NGƯỜI VIẾT ĐƠN`, `CHỦ TRÌ` |
| `chuc_vu_trai`, `nguoi_ky_trai` | khối ký bên trái | biên bản (`THƯ KÝ`); duyệt, xác nhận (`DUYỆT CỦA HIỆU TRƯỞNG`, `XÁC NHẬN CỦA TỔ TRƯỞNG`) |
| `noi_nhan` | danh sách; văn bản có Kính gửi thì dòng đầu `Như trên;` | văn bản của trường: dòng cuối `Lưu: VT, ...`; văn bản tổ, lớp: `Lưu hồ sơ tổ.` |
| `file_word` | (công cụ tự ghi) | không tự sửa, không xóa |

Giá trị có dấu hai chấm, dấu ` | ` hoặc bắt đầu bằng dấu ngoặc vuông thì đặt trong ngoặc kép `"..."`.

### 1c. Phần nội dung (cả hai chế độ)

- Mỗi đoạn cách nhau một dòng trống. Công cụ tự canh đều hai lề, lùi đầu dòng, cỡ 14.
- Căn cứ: in nghiêng `*Căn cứ ...;*`, mỗi căn cứ một đoạn, căn cứ cuối kết thúc bằng `.`
- Mục lớn `## I. TIÊU ĐỀ IN HOA`; mục `### 1. Tiêu đề`; mục nhỏ `#### 2.1. Tiêu đề`; khoản không tiêu đề `1. Nội dung`; điểm `a) Nội dung` (a, b, c, d, đ, e, g...); gạch đầu dòng `- Nội dung`.
- **Dòng canh giữa, đậm** (tiêu đề tài liệu tự do: `KẾ HOẠCH BÀI DẠY`, tên bài, `ĐỀ KIỂM TRA ...`): `::: {custom-style="Giua dam"}` ... `:::` (nhiều dòng: mỗi dòng cách một dòng trống). **Dòng canh giữa, nghiêng** (môn, lớp, thời gian; `(Năm học 2026 - 2027)`): `::: {custom-style="Giua nghieng"}` ... `:::`.
- Bảng: bảng Markdown (có viền, trải đủ khổ, hàng đầu đậm, từ 7 cột tự dùng cỡ 12). Số ô mỗi hàng phải bằng nhau; dấu `|` trong ô viết `\|`.
- **Bảng ký trong tài liệu tự do**: bảng 2 cột, hàng đầu là chức danh in hoa (`**XÁC NHẬN CỦA TỔ TRƯỞNG**` | `**GIÁO VIÊN**`; `**TỔ TRƯỞNG**`, `**NGƯỜI RA ĐỀ**`, `**DUYỆT**`...), một hàng trống `| | |` để ký, hàng họ tên - công cụ nhận ra và **bỏ viền** bảng này. Bảng 2 cột có dòng `CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM` cũng được bỏ viền (đầu kế hoạch giáo dục).
- Phương án trắc nghiệm: `A\. ...    B\. ...` (dấu `\.` để không bị hiểu thành danh sách).
- Công thức: ký tự Unicode (x², H₂O, √, π, ≤, °C) hoặc `$...$` (pandoc chuyển thành công thức Word - nhắc thầy/cô kiểm tra).
- `[[CHU-KY]]`: vị trí khối chữ ký và nơi nhận (văn bản NĐ 30 còn phụ lục sau chữ ký). `[[TRANG-MOI]]`: sang trang mới (giữa đề và đáp án, trước phụ lục).
- Chú thích cho trợ lý trong mẫu: `<!-- ... -->` (không in ra). Không dùng thẻ HTML khác, ký tự tab.
- Kết thúc nội dung văn bản NĐ 30 bằng `./.`; tài liệu tự do không bắt buộc.

## 2. Chủ thể ban hành, tên cơ quan, người ký

| Văn bản của | `co_quan_chu_quan` | `ten_co_quan` | Số | Người ký |
|---|---|---|---|---|
| **Trường THCS công lập** (dự thảo giáo viên được giao) | `UBND XÃ <TÊN>` (phường: `UBND PHƯỜNG <TÊN>`) | `TRƯỜNG THCS <TÊN>` | `/KH-THCS`, `/BC-THCS`, `/TB-THCS`, công văn `/THCS-...` (theo quy định văn thư của trường) | `chuc_vu: HIỆU TRƯỞNG` hoặc `quyen_han: KT. HIỆU TRƯỞNG` + `chuc_vu: PHÓ HIỆU TRƯỞNG` |
| **Trường THPT** | `SỞ GD&ĐT <TỈNH>` (hoặc `SỞ GIÁO DỤC VÀ ĐÀO TẠO <TỈNH>`) | `TRƯỜNG THPT <TÊN>` | như trên | như trên |
| **Tổ chuyên môn** | `TRƯỜNG THCS <TÊN>` | `TỔ <TÊN TỔ>` | `""` (hoặc theo quy định của trường) | `chuc_vu: TỔ TRƯỞNG`; kế hoạch cần duyệt: `chuc_vu_trai: DUYỆT CỦA HIỆU TRƯỞNG` |
| **Lớp chủ nhiệm** | `TRƯỜNG THCS <TÊN>` | `LỚP <TÊN LỚP>` | `""` | `chuc_vu: GIÁO VIÊN CHỦ NHIỆM` |
| **Cá nhân giáo viên** - báo cáo, bản tự đánh giá | cơ quan chủ quản của trường | tên trường | `""` | `chuc_vu: NGƯỜI BÁO CÁO` / `NGƯỜI TỰ ĐÁNH GIÁ`; xác nhận: `chuc_vu_trai: XÁC NHẬN CỦA HIỆU TRƯỞNG` |
| **Cá nhân giáo viên** - đơn | `""` | `""` | `""` | `loai: khac`, `ten_loai: ĐƠN ...`, `chuc_vu: NGƯỜI VIẾT ĐƠN` |

- **Mô hình chính quyền địa phương 2 cấp** (từ 01/7/2025): trường tiểu học, THCS, trường phổ thông nhiều cấp học có cấp học cao nhất là THCS do **UBND cấp xã** quản lý, Phòng Văn hóa - Xã hội tham mưu (khoản 1 Điều 6 Điều lệ kèm Thông tư 15/2026/TT-BGDĐT); trường THPT do Sở GD&ĐT quản lý. Không còn Phòng GD&ĐT, UBND huyện - **không ghi** "PHÒNG GD&ĐT ..." làm cơ quan chủ quản, không gửi, không viện dẫn.
- Tên cơ quan chủ quản ghi tắt "UBND" theo NĐ 30 (ví dụ `UBND XÃ BẠCH LIÊU`). Tên trường, cơ quan chủ quản, địa danh, Hiệu trưởng lấy theo `09_BO_NHO_TRO_LY/thong-tin-giao-vien.md` (nhãn "Tên trường ghi trên văn bản", "Cơ quan chủ quản", "Địa danh", "Hiệu trưởng"); chưa có thì `[CẦN BỔ SUNG]`.
- Địa danh là tên xã, phường nơi trường đóng; sau địa danh có dấu phẩy.
- Trường công lập không còn tổ chức Công đoàn: không đưa Công đoàn vào nơi nhận, thành phần.

## 3. Quy tắc thể thức cần nhớ (Phụ lục I NĐ 30)

- **Số văn bản**: ghi theo năm, bắt đầu từ số 01 ngày 01 tháng 01; số nhỏ hơn 10 ghi thêm số 0. Ký hiệu in hoa, nối bằng gạch nối, không cách chữ.
- **Ngày tháng**: "ngày 05 tháng 01 năm 2027" - ngày nhỏ hơn 10 và tháng 1, 2 ghi thêm số 0.
- **Kính gửi**: một nơi nhận thì cùng dòng; nhiều nơi thì mỗi nơi một dòng.
- **Nơi nhận**: mỗi nơi một dòng, cuối dòng `;`, dòng cuối `.`; văn bản có "Kính gửi" thì bắt đầu bằng "Như trên;".
- **Viện dẫn văn bản**: lần đầu ghi đủ tên loại, số, ký hiệu, ngày ban hành, cơ quan ban hành, trích yếu (Luật chỉ ghi tên loại và tên luật); lần sau chỉ ghi tên loại và số, ký hiệu. Số, ngày chỉ lấy từ kho căn cứ và `can-cu-dia-phuong.md`.
- **Phụ lục**: có chỉ dẫn trong nội dung; từ 2 phụ lục trở lên đánh số La Mã.

## 4. Viết hoa (Phụ lục II NĐ 30) và thuật ngữ

- Tên người: viết hoa chữ cái đầu mọi âm tiết. Đơn vị hành chính: danh từ chung viết thường, tên riêng viết hoa: xã Bạch Liêu, tỉnh Nghệ An.
- Cơ quan, tổ chức: Trường Trung học cơ sở Bạch Liêu, Ủy ban nhân dân xã Bạch Liêu, Sở Giáo dục và Đào tạo Nghệ An, Bộ Giáo dục và Đào tạo, Ban đại diện cha mẹ học sinh, Đội Thiếu niên Tiền phong Hồ Chí Minh.
- Chức vụ viết hoa khi đi liền tên người hoặc chỉ một người cụ thể: Hiệu trưởng, Phó Hiệu trưởng Nguyễn Văn A, Tổ trưởng tổ Toán - Tin; đứng một mình với nghĩa chung viết thường (các giáo viên chủ nhiệm, các tổ trưởng).
- Tên loại văn bản cụ thể: Thông tư số 22/2021/TT-BGDĐT, Công văn số 5512/BGDĐT-GDTrH, Kế hoạch số 12/KH-THCS. Viện dẫn: viết hoa Điều; viết thường khoản, điểm (điểm a khoản 3 Điều 5).
- Môn học, hoạt động giáo dục theo tên trong Chương trình: Ngữ văn, Toán, Ngoại ngữ 1, Giáo dục công dân, Lịch sử và Địa lí, Khoa học tự nhiên, Công nghệ, Tin học, Giáo dục thể chất, Nghệ thuật (Âm nhạc, Mĩ thuật), Hoạt động trải nghiệm, hướng nghiệp, Nội dung giáo dục của địa phương.
- Thuật ngữ đánh giá theo Thông tư 22/2021: "đánh giá thường xuyên", "đánh giá định kì" (giữa kì, cuối kì), "kết quả học tập", "kết quả rèn luyện", mức Tốt/Khá/Đạt/Chưa đạt, "ĐTBmhk", "ĐTBmcn". Không dùng "hạnh kiểm", "học lực Giỏi/Khá/Trung bình/Yếu/Kém" (quy định cũ).
- Không ghi tên bộ sách giáo khoa ("sách giáo khoa Toán 6"). Ngày trong tuần, tháng: thứ Hai, tháng Mười. Ngày lễ: ngày Nhà giáo Việt Nam 20-11.

## 5. Mẫu tương ứng (`mau/`)

| Loại | Chế độ | File mẫu | Quy trình |
|---|---|---|---|
| Kế hoạch bài dạy (Phụ lục IV Công văn 5512) | tự do | `ke-hoach-bai-day.md` | `/ke-hoach-bai-day` |
| Kế hoạch giáo dục của giáo viên (Phụ lục III Công văn 5512) | tự do, ngang | `ke-hoach-giao-duc-giao-vien.md` | `/ke-hoach-giao-duc` |
| Dàn ý bài trình chiếu (xuất .pptx bằng pandoc) | khối pandoc `title` | `trinh-chieu.md` | `/trinh-chieu` |
| Phiếu học tập, bảng kiểm, rubric | tự do | `phieu-hoc-tap.md` | `/phieu-hoc-tap` |
| Đề cương ôn tập | tự do | `de-cuong-on-tap.md` | `/phieu-hoc-tap` |
| Ma trận, bản đặc tả (Phụ lục Công văn 7991) | tự do, ngang | `ma-tran-dac-ta.md` | `/de-kiem-tra` |
| Đề kiểm tra | tự do | `de-kiem-tra.md` | `/de-kiem-tra` |
| Hướng dẫn chấm | tự do | `huong-dan-cham.md` | `/de-kiem-tra` |
| Kế hoạch chủ nhiệm | NĐ 30 (lớp) | `ke-hoach-chu-nhiem.md` | `/chu-nhiem` |
| Biên bản họp cha mẹ học sinh | NĐ 30 (lớp) | `bien-ban-hop-cha-me-hoc-sinh.md` | `/chu-nhiem` |
| Thư gửi cha mẹ học sinh | tự do | `thu-gui-cha-me.md` | `/chu-nhiem` |
| Kế hoạch nghiên cứu bài học, phiếu quan sát | NĐ 30 (tổ) | `nghien-cuu-bai-hoc.md` | `/sinh-hoat-chuyen-mon` |
| Biên bản sinh hoạt chuyên môn | NĐ 30 (tổ) | `bien-ban-sinh-hoat-chuyen-mon.md` | `/sinh-hoat-chuyen-mon` |
| Bản mô tả sáng kiến | tự do | `sang-kien.md` | `/sang-kien` |
| Bản tự đánh giá (hoàn thành nhiệm vụ, đáp ứng chuẩn) | NĐ 30 (cá nhân) | `tu-danh-gia-chuan.md` | `/chuan-nghe-nghiep` |
| Báo cáo cá nhân, báo cáo thành tích, báo cáo chủ nhiệm | NĐ 30 (cá nhân) | `bao-cao-ca-nhan.md` | `/bao-cao` |
| Báo cáo của tổ (dự thảo báo cáo của trường) | NĐ 30 | `bao-cao.md` | `/bao-cao` |
| Kế hoạch của tổ, kế hoạch hoạt động (dự thảo kế hoạch của trường) | NĐ 30 | `ke-hoach.md` | `/sinh-hoat-chuyen-mon`, `/bao-cao` |
| Biên bản họp tổ, họp lớp, bàn giao (Mẫu 1.9) | NĐ 30 | `bien-ban.md` | `/bien-ban` |
| Đơn xin nghỉ phép, đơn đề nghị | NĐ 30 (cá nhân) | `don-de-nghi.md` | `/bao-cao` |
| Giấy nghỉ phép do Hiệu trưởng cấp (Mẫu 1.10) | NĐ 30 (trường) | `giay-nghi-phep.md` | - |
| Công văn của trường (dự thảo khi được giao, Mẫu 1.5) | NĐ 30 (trường) | `cong-van.md` | - |
| Dự án phần mềm (Xưởng phần mềm) | HTML/JS | `phan-mem/` | `/xuong-phan-mem` |

Mẫu riêng của trường, tổ đặt ở `07_MAU_RIENG/.tro-ly/` cùng tên file thì được ưu tiên.

## 6. Văn phong

- **Tài liệu dạy học**: câu ngắn, rõ việc học sinh làm; động từ quan sát được (nêu, trình bày, so sánh, giải thích, vận dụng, thiết kế); lời văn cho học sinh gần gũi, vừa sức lứa tuổi.
- **Nhận xét học sinh, thư gửi cha mẹ**: tôn trọng, tích cực, cụ thể; không xúc phạm, không so sánh, không nêu hoàn cảnh riêng.
- **Văn bản hành chính**: câu ngắn, chủ động, rõ chủ thể; mỗi việc nêu rõ **việc - người thực hiện - thời hạn - sản phẩm**; báo cáo có số liệu thống nhất, so sánh với kế hoạch và năm học trước.
- Số liệu: 1.250; tỷ lệ 98,5%; điểm 7,5; số La Mã cho phần, mục lớn.
- Không bịa số liệu, số hiệu, điều khoản, tên bài: chỗ chưa có ghi `[CẦN BỔ SUNG]`, căn cứ chưa chắc ghi `[CẦN KIỂM TRA]`.
