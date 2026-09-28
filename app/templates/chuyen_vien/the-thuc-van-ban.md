# Thể thức văn bản hành chính - hướng dẫn soạn cho trợ lý

> Căn cứ: Nghị định số 30/2020/NĐ-CP ngày 05/3/2020 của Chính phủ về công tác văn thư - Phụ lục I (thể thức, kỹ thuật trình bày), Phụ lục II (viết hoa), Phụ lục III (chữ viết tắt tên loại, mẫu trình bày), Phụ lục IV (mẫu quản lý văn bản đến, đi).
> Công cụ `cong-cu\xuat-word.ps1` tự trình bày đúng khổ giấy, lề, phông, cỡ chữ, đường kẻ, số trang. Trợ lý chỉ cần viết **khối thông tin** và **phần nội dung** đúng quy tắc dưới đây.

## 1. Cấu trúc file .md

Mỗi văn bản gồm hai phần:

1. **Khối thông tin** giữa hai dòng `---` ở đầu file (xem các mẫu trong `mau/`):

| Khóa | Nội dung | Ghi chú |
|---|---|---|
| `loai` | `cong-van`, `quyet-dinh`, `ke-hoach`, `bao-cao`, `thong-bao`, `to-trinh`, `giay-moi`, `bien-ban`, `lich-tuan`, `giay-gioi-thieu`, `giay-nghi-phep`, `quy-che`, `quy-dinh`, `huong-dan`, `chuong-trinh`, `phuong-an`, `de-an`, `phat-bieu`, `khac` | quyết định tên loại in trên văn bản |
| `co_quan_chu_quan` | UBND TỈNH ... / UBND XÃ ... / SỞ GIÁO DỤC VÀ ĐÀO TẠO (văn bản nội bộ của phòng) | để `""` khi cơ quan ban hành là UBND (không có cơ quan chủ quản); thiếu khóa thì lấy từ bộ nhớ |
| `ten_co_quan` | SỞ GIÁO DỤC VÀ ĐÀO TẠO / PHÒNG VĂN HÓA - XÃ HỘI / ỦY BAN NHÂN DÂN \| XÃ ... | ` \| ` ngắt dòng (dùng cho "ỦY BAN NHÂN DÂN \| TỈNH ...", "ỦY BAN NHÂN DÂN \| XÃ ..."); tên khác để công cụ tự xếp một dòng |
| `so` | `"      /QĐ-SGDĐT"` | để trống phần số cho văn thư ghi; công văn: `"      /SGDĐT-GDTH"` |
| `dia_danh_ngay` | `"Nghệ An, ngày      tháng      năm 2026"` | biên bản, bài phát biểu để `""` |
| `ten_loai` | chỉ ghi khi muốn khác tên mặc định của `loai` (ví dụ `PHIẾU TRÌNH`, `LỊCH CÔNG TÁC TUẦN 3`) | |
| `trich_yeu` | công văn: `V/v ...`; loại khác: câu ngắn phản ánh nội dung | nhiều dòng: ngắt bằng ` \| ` |
| `du_thao` | `"DỰ THẢO"` | chỉ khi là dự thảo trình cấp trên ban hành (mục 1a.4); công cụ in đậm, đóng khung, sát lề phải phía trên phần đầu văn bản |
| `quoc_hieu` | `khong` | văn bản không theo thể thức hành chính (bài phát biểu): công cụ bỏ Quốc hiệu, tên cơ quan, số, ngày, khối chữ ký, nơi nhận - chỉ in tên loại, trích yếu và nội dung. `loai: phat-bieu` tự hiểu như vậy |
| `kem_theo` | `(Kèm theo Quyết định số .../QĐ-... ngày ... của ...)` | văn bản ban hành kèm quyết định (quy chế, quy định...) |
| `tham_quyen` | GIÁM ĐỐC SỞ GIÁO DỤC VÀ ĐÀO TẠO / ỦY BAN NHÂN DÂN XÃ ... / CHỦ TỊCH ỦY BAN NHÂN DÂN XÃ ... | chỉ quyết định, nghị quyết |
| `kinh_gui` | danh sách nơi nhận chính | công văn, tờ trình, báo cáo gửi cấp trên |
| `quyen_han` | `KT. GIÁM ĐỐC`, `KT. TRƯỞNG PHÒNG`, `TM. ỦY BAN NHÂN DÂN \| KT. CHỦ TỊCH`, `KT. CHỦ TỊCH`, `TL. CHỦ TỊCH`, `TL. GIÁM ĐỐC`, `Q. GIÁM ĐỐC`, `TUQ. ...` | ` \| ` = hai dòng quyền hạn; bỏ trống khi người đứng đầu ký |
| `chuc_vu` | GIÁM ĐỐC / PHÓ GIÁM ĐỐC / TRƯỞNG PHÒNG / PHÓ CHỦ TỊCH / CHÁNH VĂN PHÒNG / CHỦ TRÌ | |
| `nguoi_ky` | Họ và tên (không ghi học hàm, học vị) | |
| `chuc_vu_trai`, `nguoi_ky_trai` | THƯ KÝ / ĐẠI DIỆN ĐƠN VỊ ĐƯỢC KIỂM TRA và họ tên | chỉ biên bản (người ký bên trái) |
| `noi_nhan` | danh sách; dòng cuối `Lưu: VT, <đơn vị soạn thảo>.` | công văn, tờ trình, báo cáo có Kính gửi: dòng đầu `Như trên;` |
| `do_khan` | `KHẨN`, `THƯỢNG KHẨN`, `HỎA TỐC` | chỉ khi thật cần |
| `ky_hieu_soan_thao` | ví dụ `GDTH.(05)` | ký hiệu người soạn thảo, số bản phát hành (khi cơ quan có quy định) |
| `dia_chi` | các dòng địa chỉ, điện thoại, email | chân trang đầu công văn (tùy chọn) |
| `file_word` | (công cụ xuất Word tự ghi) | tên file Word đã xuất ra thư mục ngoài - không tự sửa, không xóa |

Giá trị có dấu hai chấm, dấu ` | ` hoặc bắt đầu bằng dấu ngoặc vuông thì đặt trong ngoặc kép `"..."`.

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

## 1a. Thể thức theo cơ quan ban hành

### 1a.1. Văn bản của Sở Giáo dục và Đào tạo
- `co_quan_chu_quan: UBND TỈNH <TÊN TỈNH>`, `ten_co_quan: SỞ GIÁO DỤC VÀ ĐÀO TẠO`; địa danh là **tên tỉnh** ("Nghệ An, ngày ...").
- Số, ký hiệu: công văn `      /<viết tắt Sở>-<viết tắt phòng>` (ví dụ `/SGDĐT-GDTH`, `/SGDĐT-GDMN`); văn bản có tên loại `      /<tên loại>-<viết tắt Sở>` (`/QĐ-SGDĐT`, `/KH-SGDĐT`, `/HD-SGDĐT`, `/BC-SGDĐT`, `/TB-SGDĐT`, `/TTr-SGDĐT`, `/GM-SGDĐT`). Viết tắt thật theo `thong-tin-co-quan.md` (một số Sở dùng "SGD&ĐT").
- Người ký: Giám đốc ký `chuc_vu: GIÁM ĐỐC`; Phó Giám đốc ký thay `quyen_han: KT. GIÁM ĐỐC` + `chuc_vu: PHÓ GIÁM ĐỐC` (mặc định - Phó Giám đốc phụ trách cấp học); Chánh Văn phòng, Trưởng phòng ký thừa lệnh khi được giao: `quyen_han: TL. GIÁM ĐỐC` + `chuc_vu: CHÁNH VĂN PHÒNG` / `TRƯỞNG PHÒNG ...`. Chuyên viên không ký.
- Nơi nhận: `Giám đốc (để b/c);` khi Phó Giám đốc ký; dòng cuối `Lưu: VT, <viết tắt phòng>.`
- Văn bản nội bộ của phòng (lịch công tác tuần, phiếu trình): `co_quan_chu_quan: SỞ GIÁO DỤC VÀ ĐÀO TẠO`, `ten_co_quan: PHÒNG <TÊN PHÒNG>`.

### 1a.2. Văn bản của Phòng Văn hóa - Xã hội (thuộc UBND xã, phường)
- `co_quan_chu_quan: UBND XÃ <TÊN XÃ>` (phường: `UBND PHƯỜNG ...`), `ten_co_quan: PHÒNG VĂN HÓA - XÃ HỘI`; địa danh là **tên xã, phường** ("Quảng Châu, ngày ...").
- Ký hiệu viết tắt của Phòng: `VHXH` (công văn `      /VHXH`, tờ trình `      /TTr-VHXH`, báo cáo `      /BC-VHXH`) - hoặc theo quy chế công tác văn thư của UBND xã (ghi trong `ghi-nho.md`).
- Người ký: `chuc_vu: TRƯỞNG PHÒNG`; Phó Trưởng phòng ký thay `quyen_han: KT. TRƯỞNG PHÒNG` + `chuc_vu: PHÓ TRƯỞNG PHÒNG`. Dòng cuối nơi nhận `Lưu: VT, VHXH.`
- Phòng tham mưu, không thay UBND xã: việc thuộc thẩm quyền UBND xã, Chủ tịch UBND xã (thành lập, sáp nhập trường; bổ nhiệm, miễn nhiệm cán bộ quản lý; giao dự toán; kế hoạch của xã) → **tờ trình của Phòng** (`vhxh-to-trinh.md`) kèm **dự thảo văn bản của UBND xã**.

### 1a.3. Văn bản của Ủy ban nhân dân xã, phường
- `co_quan_chu_quan: ""`, `ten_co_quan: "ỦY BAN NHÂN DÂN | XÃ <TÊN XÃ>"`; địa danh là tên xã, phường.
- Ký hiệu: `      /UBND-VHXH` (công văn, Phòng Văn hóa - Xã hội là đơn vị soạn thảo), `      /QĐ-UBND`, `      /KH-UBND`, `      /TB-UBND`, `      /BC-UBND`, `      /TTr-UBND`.
- Người ký:
  - Văn bản của tập thể UBND (kế hoạch, công văn, quyết định thuộc thẩm quyền UBND): `quyen_han: "TM. ỦY BAN NHÂN DÂN | KT. CHỦ TỊCH"` + `chuc_vu: PHÓ CHỦ TỊCH` (Chủ tịch ký: `quyen_han: TM. ỦY BAN NHÂN DÂN` + `chuc_vu: CHỦ TỊCH`).
  - Quyết định thuộc thẩm quyền riêng của Chủ tịch (thành lập, cho phép thành lập, sáp nhập, giải thể trường; bổ nhiệm, miễn nhiệm, điều động hiệu trưởng, phó hiệu trưởng; thành lập hội đồng trường...): `tham_quyen: CHỦ TỊCH ỦY BAN NHÂN DÂN XÃ <TÊN XÃ>`, `quyen_han: KT. CHỦ TỊCH` + `chuc_vu: PHÓ CHỦ TỊCH` (Chủ tịch ký: bỏ `quyen_han`, `chuc_vu: CHỦ TỊCH`); số vẫn `/QĐ-UBND`.
  - Thông báo kết luận của lãnh đạo UBND xã: `quyen_han: TL. CHỦ TỊCH` + `chuc_vu: CHÁNH VĂN PHÒNG` (hoặc `TM. ỦY BAN NHÂN DÂN | KT. CHỦ TỊCH`).
  - Cách ký cụ thể theo **quy chế làm việc của UBND xã** - có trong `ghi-nho.md` thì theo đó.
- Nơi nhận thường có: `Sở Giáo dục và Đào tạo (để b/c);`, `Chủ tịch, các Phó Chủ tịch UBND xã;`, `Phòng Văn hóa - Xã hội;`, dòng cuối `Lưu: VT, VHXH.`

### 1a.4. Dự thảo văn bản trình cấp trên ban hành
- Sở trình UBND tỉnh: dự thảo mang thể thức của UBND tỉnh - `co_quan_chu_quan: ""`, `ten_co_quan: "ỦY BAN NHÂN DÂN | TỈNH <TÊN TỈNH>"`, số `/QĐ-UBND`, `/KH-UBND`...; ký `quyen_han: "TM. ỦY BAN NHÂN DÂN | KT. CHỦ TỊCH"` + `chuc_vu: PHÓ CHỦ TỊCH`; tờ trình của Sở: `to-trinh-ubnd-tinh.md`.
- Phòng Văn hóa - Xã hội trình UBND xã: dự thảo theo mục 1a.3; tờ trình: `vhxh-to-trinh.md`.
- Thêm `du_thao: "DỰ THẢO"` vào khối thông tin; để trống họ tên người ký (`nguoi_ky: "[Họ và tên]"`) nếu chưa rõ lãnh đạo ký; phần "Theo đề nghị của ..." dẫn đúng tờ trình (số để trống).
- Mẫu chung: `du-thao-quyet-dinh-ubnd.md` (cấp xã đổi tên cơ quan, địa danh, `tham_quyen`, phần đề nghị theo mục 1a.3). Dự thảo kế hoạch của UBND xã: `ubnd-xa-ke-hoach.md` + `du_thao`.

### 1a.5. Phiếu trình, bài phát biểu
- **Phiếu trình** giải quyết công việc (chuyên viên trình lãnh đạo phòng, lãnh đạo cơ quan): `phieu-trinh.md` (`loai: khac`, `ten_loai: PHIẾU TRÌNH`, người ký là người trình). Cấp xã đổi `co_quan_chu_quan: UBND XÃ ...`, `ten_co_quan: PHÒNG VĂN HÓA - XÃ HỘI`, kính trình Phó Chủ tịch UBND xã phụ trách.
- **Bài phát biểu** (khai giảng, tổng kết, hội nghị): `bai-phat-bieu.md` (`loai: phat-bieu`, `quoc_hieu: khong`) - không phải văn bản hành chính: không Quốc hiệu, không số, không ký; `trich_yeu` ghi người phát biểu và sự kiện (` | ` để xuống dòng).

## 2. Quy tắc thể thức cần nhớ khi soạn (Phụ lục I)

- **Số văn bản**: số nhỏ hơn 10 ghi thêm số 0 phía trước (05/QĐ-...). Ký hiệu in hoa, giữa các nhóm chữ viết tắt dùng dấu gạch nối, không cách chữ.
- **Ngày tháng**: viết đầy đủ "ngày 05 tháng 01 năm 2026" - ngày nhỏ hơn 10 và tháng 1, 2 ghi thêm số 0.
- **Địa danh**: cơ quan cấp tỉnh ghi tên tỉnh; cơ quan cấp xã ghi tên xã, phường; viết hoa chữ cái đầu, sau địa danh có dấu phẩy.
- **Tên cơ quan chủ quản** được viết tắt cụm từ thông dụng: "UBND TỈNH ...", "UBND XÃ ...".
- **Quyền hạn người ký**: cấp phó ký thay người đứng đầu ghi `KT.`; ký thay mặt tập thể ghi `TM.`; ký thừa lệnh ghi `TL.`; cấp phó được giao phụ trách ký như ký thay.
- **Kính gửi**: một nơi nhận thì cùng dòng; nhiều nơi thì mỗi nơi một dòng, gạch đầu dòng, cuối dòng `;`, dòng cuối `.`
- **Nơi nhận**: mỗi nơi một dòng, cuối dòng `;`, dòng cuối "Lưu: VT, <chữ viết tắt đơn vị soạn thảo>, <số bản lưu>." Văn bản có "Kính gửi" thì nơi nhận bắt đầu bằng "Như trên;".
- **Viện dẫn văn bản**: lần đầu ghi đủ tên loại, số, ký hiệu, ngày ban hành, cơ quan ban hành, trích yếu (Luật chỉ ghi tên loại và tên luật); lần sau chỉ ghi tên loại và số, ký hiệu. Số, ngày chỉ lấy từ `mau/can-cu-phap-ly.md` và `09_BO_NHO_TRO_LY/can-cu-dia-phuong.md`.
- **Phụ lục**: văn bản có phụ lục phải có chỉ dẫn trong nội dung; từ 2 phụ lục trở lên đánh số La Mã (Phụ lục I, II). Trình bày: dòng "Phụ lục I" (đậm, canh giữa), tiêu đề IN HOA đậm, dòng "(Kèm theo Văn bản số ... ngày ... của ...)" nghiêng.
- **Kết thúc nội dung** văn bản bằng dấu `./.`

## 3. Chữ viết tắt tên loại văn bản (Phụ lục III)

Quyết định QĐ · Quy chế QC · Quy định QyĐ · Thông báo TB · Hướng dẫn HD · Chương trình CTr · Kế hoạch KH · Phương án PA · Đề án ĐA · Báo cáo BC · Biên bản BB · Tờ trình TTr · Hợp đồng HĐ · Giấy ủy quyền GUQ · Giấy mời GM · Giấy giới thiệu GGT · Giấy nghỉ phép GNP · Phiếu gửi PG · Phiếu chuyển PC · Phiếu báo PB. Công văn không có chữ viết tắt tên loại: `Số: .../<viết tắt cơ quan>-<viết tắt đơn vị soạn thảo hoặc lĩnh vực>`. Bản sao: SY (sao y), TrS (trích sao), SL (sao lục). Biên bản của đoàn kiểm tra có thể ghi `/BB-ĐKT` (ký hiệu theo quy chế của cơ quan).

## 4. Viết hoa (Phụ lục II)

- Tên người: viết hoa chữ cái đầu mọi âm tiết (Nguyễn Thị Hà).
- Đơn vị hành chính: danh từ chung viết thường, tên riêng viết hoa, không gạch nối: xã Quảng Châu, tỉnh Nghệ An. Tên có chữ số viết hoa cả danh từ chung: Phường 3.
- Cơ quan, tổ chức: viết hoa chữ cái đầu của từ chỉ loại hình và chức năng, lĩnh vực: Bộ Giáo dục và Đào tạo, Sở Giáo dục và Đào tạo, Ủy ban nhân dân tỉnh Nghệ An, Ủy ban nhân dân xã Quảng Châu, Phòng Văn hóa - Xã hội, Phòng Giáo dục Tiểu học, Trường Mầm non Hoa Sen, Trường Tiểu học Quảng Châu 1, Ban Chỉ đạo phổ cập giáo dục, xóa mù chữ xã.
- Chức vụ viết hoa khi đi liền tên người hoặc chỉ một người cụ thể: Giám đốc Sở Giáo dục và Đào tạo, Phó Chủ tịch UBND xã Trần Văn A; đứng một mình trong câu với nghĩa chung thì viết thường (các phó giám đốc, các hiệu trưởng).
- Tên loại văn bản khi nói đến một văn bản cụ thể: viết hoa chữ đầu tên loại (Kế hoạch số 12/KH-..., Luật Giáo dục). Viện dẫn: viết hoa Phần, Chương, Mục, Điều; viết thường khoản, điểm (điểm a khoản 2 Điều 5).
- Ngày trong tuần, tháng khi không dùng chữ số: thứ Hai, thứ Bảy, tháng Tám. Tết: tết Nguyên đán, tết Trung thu.
- Ngày lễ: ngày Nhà giáo Việt Nam 20-11, ngày Quốc khánh 2-9. Danh hiệu: Nhà giáo Ưu tú, Chiến sĩ thi đua cơ sở.
- Đặc biệt: Nhà nước, Nhân dân (viết hoa khi dùng như danh từ riêng).

## 5. Mẫu tương ứng

| Loại | Mẫu NĐ 30 | File mẫu (Sở) | Cấp xã |
|---|---|---|---|
| Quyết định cá biệt | Mẫu 1.2, 1.3 | `quyet-dinh.md`, `quyet-dinh-doan-kiem-tra.md` | `ubnd-xa-quyet-dinh.md` |
| Kế hoạch, báo cáo, thông báo, tờ trình, hướng dẫn, chương trình, quy chế... | Mẫu 1.4 | `ke-hoach.md`, `bao-cao.md`, `thong-bao.md`, `to-trinh.md`, `huong-dan.md`, `thong-bao-ket-luan-kiem-tra.md`, `to-trinh-ubnd-tinh.md` | `ubnd-xa-ke-hoach.md`, `vhxh-to-trinh.md`, `ubnd-xa-thong-bao-ket-luan.md` |
| Công văn | Mẫu 1.5 | `cong-van.md`, `de-cuong-bao-cao.md` (công văn kèm đề cương, biểu mẫu), `cong-van-gop-y.md` | `vhxh-cong-van.md`, `ubnd-xa-cong-van.md` |
| Giấy mời | Mẫu 1.7 | `giay-moi.md` | đổi khối thông tin theo mục 1a |
| Giấy giới thiệu | Mẫu 1.8 | `giay-gioi-thieu.md` | nt |
| Biên bản | Mẫu 1.9 | `bien-ban.md`, `bien-ban-kiem-tra.md` | nt |
| Giấy nghỉ phép | Mẫu 1.10 | `giay-nghi-phep.md` | nt |
| Dự thảo văn bản trình UBND ban hành | Mẫu 1.2-1.4 | `du-thao-quyet-dinh-ubnd.md` | dùng chung |
| Phiếu giải quyết văn bản đến | Phụ lục IV, mục VII | `phieu-giai-quyet-van-ban-den.md` | nt |
| Phiếu trình | (quy chế làm việc của cơ quan) | `phieu-trinh.md` | nt |
| Lịch công tác tuần | - | `lich-tuan.md` | nt |
| Bài phát biểu | - | `bai-phat-bieu.md` | dùng chung |
| Văn bản ban hành kèm quyết định (quy chế, quy định) | Mẫu "văn bản kèm theo quyết định" | dùng `loai: quy-che`, `kem_theo: (...)`, `so: ""`, `dia_danh_ngay: ""`, không có khối chữ ký | nt |

## 6. Văn phong

- Câu ngắn, chủ động, rõ chủ thể; không dùng từ cảm thán, khẩu ngữ. Xưng tên cơ quan ("Sở Giáo dục và Đào tạo", "Phòng Văn hóa - Xã hội", "Ủy ban nhân dân xã ...").
- Văn bản hướng dẫn, chỉ đạo: nêu rõ việc - đơn vị thực hiện - thời hạn - sản phẩm báo cáo; tránh yêu cầu hồ sơ, báo cáo trùng lặp, không yêu cầu cơ sở giáo dục khai lại dữ liệu đã có trên cơ sở dữ liệu ngành.
- Công văn, tờ trình mở đầu bằng căn cứ hoặc lý do; kết thúc: "... đề nghị ... triển khai thực hiện./.", tờ trình: "... kính trình ... xem xét, phê duyệt./."
- Số liệu thống nhất: 1.250 học sinh; tỷ lệ 98,5%; số La Mã cho phần, mục lớn.
- Không bịa số liệu, số hiệu, điều khoản: chỗ chưa có ghi `[CẦN BỔ SUNG]`, căn cứ chưa chắc ghi `[CẦN KIỂM TRA]`.
