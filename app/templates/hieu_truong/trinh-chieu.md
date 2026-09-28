---
loai: trinh-chieu
tieu_de: "[Tên bài trình chiếu, ví dụ: Báo cáo sơ kết học kỳ I năm học 2026 - 2027]"
phu_de: "[Trường ...]"
co_quan: "[UBND XÃ ... - TRƯỜNG ... - bỏ dòng này nếu không cần]"
nguoi_trinh_bay: "[Họ và tên - chức vụ]"
ngay: "[dd/mm/yyyy]"
kieu: the
mau: navy
phong: Calibri
phong_tieu_de: Calibri
chan_trang: "[Trường ...]"
---

<!--
HƯỚNG DẪN VIẾT FILE TRÌNH CHIẾU (công cụ: cong-cu\xuat-ppt.ps1)

1. KHỐI THÔNG TIN (giữa hai dòng ---)
   - tieu_de        : có dòng này thì công cụ tự dựng TRANG BÌA. Bỏ đi nếu không cần bìa.
   - phu_de         : dòng mô tả trên bìa (kiểu the: nằm trong khung màu dưới tiêu đề).
   - co_quan        : dòng chữ hoa nhỏ ở đầu trang bìa (cơ quan chủ quản - đơn vị, tên hội nghị).
   - nguoi_trinh_bay: người trình bày. Viết "Họ tên - chức vụ, đơn vị" thì kiểu the tách thành 2 dòng.
   - ngay           : ngày trình bày (kiểu the: ghi cạnh dòng cơ quan ở đầu bìa).
   - kieu           : KIỂU TRÌNH BÀY - quyết định trang bìa, trang phân đoạn, tiêu đề trang trông thế nào.
                        the (mặc định) : THẺ MÀU - kiểu bài tập huấn, chuyên đề hiện đại.
                                         Bìa và trang phân đoạn nền màu sâu có hình tròn trang trí, tiêu đề
                                         CHỮ HOA lớn; trang nội dung nền trắng, nhãn nhỏ chữ hoa phía trên
                                         tiêu đề, nội dung chia THẺ nền nhạt có vạch màu, hình tròn đánh
                                         số, dải nhấn. Phông Calibri. Dùng tốt với các khối ở mục 3e - 3j.
                        dam            : trang bìa và trang phân đoạn TÔ KÍN màu sâu, chữ trắng; mỗi trang
                                         nội dung có dải màu ngang đầu trang, tiêu đề chữ trắng; ô số liệu
                                         tô màu nhấn. Tương phản cao nhất, nhìn rõ từ cuối hội trường.
                        hien-dai       : trang bìa có khối màu sâu chiếm 38% bên trái (tên cơ quan, người
                                         trình bày đặt trong khối), tiêu đề lớn bên phải; ô số liệu tô màu
                                         sâu chữ trắng; trang phân đoạn chia đôi khối màu.
                        trang-trong    : căn giữa hết, chỉ hai vạch mảnh màu nhấn, không khối màu lớn; ô số
                                         liệu không tô nền. Hợp báo cáo trước hội nghị, trước cấp trên.
                      Bốn kiểu ghép tự do với mọi bộ màu ở dòng "mau:".
   - mau            : mỗi bộ gồm một màu sâu (chữ tiêu đề) và một màu nhấn (vạch, biểu đồ). Nền trang và
                      các khối nhạt được pha ra từ chính màu sâu nên luôn cùng một hệ màu.
                        navy            : xanh navy - xanh sáng (mặc định của kiểu the, đúng màu bài gốc)
                      Kiểu the tự pha màu sáng cùng sắc với màu sâu của bộ đã chọn (ngoc -> xanh ngọc sáng...).
                      Năm bộ nhã, trang trọng:
                        sang            : xanh navy - vàng đồng (mặc định của kiểu dam, hien-dai, trang-trong)
                        ngoc            : xanh ngọc - vàng kem
                        rung            : xanh rừng - hổ phách
                        than            : than chì - xanh khoáng
                        ruou            : đỏ rượu - hồng đất
                      Các bộ cũ vẫn dùng được: dat, xanh, xanh-la, do, cam, tim, xam.
   - phong          : chữ NỘI DUNG - Calibri (mặc định kiểu the) | Tahoma (mặc định các kiểu khác) | Arial
                      | Segoe UI | Verdana | Times New Roman.
   - phong_tieu_de  : chữ TIÊU ĐỀ - Calibri (mặc định kiểu the) | Cambria (mặc định các kiểu khác, chữ có chân)
                      | Georgia | Palatino Linotype | Constantia | Tahoma.
                      (Văn bản Word vẫn Times New Roman theo Nghị định 30 - không liên quan hai dòng này.)
   - logo           : đường dẫn ảnh logo trường trong thư mục làm việc (ví dụ 06_DU_LIEU/logo-truong.png).
                      Logo hiện ở góc phải trên trang bìa và các trang nội dung. Bỏ dòng này nếu không có.
   - chan_trang     : chữ nhỏ ở chân mọi trang; số trang công cụ tự đánh.
   - ty_le          : 16-9 (mặc định) hoặc 4-3 cho máy chiếu cũ.
   - file_ppt       : công cụ tự ghi tên file PowerPoint đã xuất - KHÔNG tự sửa, không xóa.

2. NỘI DUNG
   - Mỗi dòng "# Tiêu đề" mở MỘT TRANG CHIẾU mới.
   - "# Nhãn | Tiêu đề" : kiểu the hiện NHÃN chữ hoa nhỏ màu sáng phía trên tiêu đề (ví dụ
     "# Đặt vấn đề | Thực trạng hồ sơ"). Không ghi nhãn thì công cụ lấy tên phần đang trình bày.
   - "# = Tiêu đề" (hoặc "# # Tiêu đề") mở TRANG PHÂN ĐOẠN, dùng để ngăn giữa các phần lớn.
     Ví dụ:  # = Phần II. Kết quả thực hiện   (kiểu the: nhãn "PHẦN II", tên phần chữ hoa lớn).
     Dòng chữ đầu tiên ngay dưới là phụ đề của trang phân đoạn.
   - Trong trang chiếu:
       ## Tiểu mục            -> dòng đậm, màu chủ đạo
       - Gạch đầu dòng        -> lùi 2 dấu cách là cấp 2, 4 dấu cách là cấp 3
       1. Danh sách đánh số
       > Câu trích dẫn        -> chữ nghiêng (kiểu the: khung nhạt có dấu ngoặc kép lớn - trích điều, khoản)
       >> Câu chốt            -> DẢI NHẤN: hộp màu sâu, chữ trắng đậm, hết bề ngang trang
       ~ Chú thích            -> chữ nhỏ nghiêng màu nhạt (nguồn số liệu, căn cứ, thời gian)
       | Bảng | Markdown |    -> hàng đầu là tiêu đề bảng (nền màu sâu, chữ trắng, có vạch màu nhấn ở dưới);
                                 bảng chỉ kẻ ngang cho nhẹ nhàng; cột toàn số tự căn phải;
                                 hàng bắt đầu bằng Tổng / Cộng / Toàn trường tự in đậm
       ![](đường dẫn ảnh)     -> ảnh, tự căn giữa và co cho vừa trang
       Đoạn văn thường
   - Chữ **đậm**, *nghiêng* dùng được trong mọi dòng.

3. CÁC KHỐI ĐẶC BIỆT (mở bằng "::: <tên>", đóng bằng dòng ":::" trống)

   a) Ghi chú cho người trình bày (không chiếu lên màn hình)
       ::: ghi chu
       Nội dung nhắc người nói.
       :::

   b) Ô SỐ LIỆU NỔI BẬT - 2 đến 4 ô, số to, chú thích nhỏ. Mỗi dòng: giá trị | chú thích
       (thẻ nền nhạt, có vạch màu nhấn ở mép trên)
       ::: so-lieu
       60 | lớp học
       1.842 | học sinh
       94 | cán bộ, giáo viên, nhân viên
       :::

   c) BIỂU ĐỒ - biểu đồ gốc của PowerPoint (sửa được định dạng, đổi được kiểu biểu đồ).
      Mở khối: ::: bieu-do <kiểu> <tiêu đề biểu đồ>       kiểu = cot | cot-ngang | tron
      Bên trong là bảng Markdown: cột đầu là nhãn, các cột sau là từng chuỗi số liệu.
       ::: bieu-do cot Tỷ lệ Hoàn thành tốt theo khối (%)
       | Khối | Năm trước | Năm nay |
       |---|---|---|
       | Khối 1 | 32 | 36 |
       | Khối 2 | 34 | 38 |
       :::
      Biểu đồ tròn chỉ dùng cột số liệu đầu tiên và tự hiện tỷ lệ phần trăm.
      Lưu ý: dữ liệu biểu đồ nằm trong file .md này. Muốn sửa số thì sửa ở đây rồi xuất lại,
      không sửa trong PowerPoint (PowerPoint sửa được màu, kiểu biểu đồ, nhưng không có bảng dữ liệu nhúng).

   d) BỐ CỤC HAI CỘT - bên trái chữ, bên phải bảng hoặc ảnh (ngăn bằng dòng "|||")
       ::: hai-cot
       ## Kết quả nổi bật
       - Ý thứ nhất
       - Ý thứ hai
       |||
       | Chỉ tiêu | Kế hoạch | Đạt |
       |---|---|---|
       | Hoàn thành tốt | 36% | 38% |
       :::

   e) THẺ - 2 đến 4 thẻ cạnh nhau (5 - 8 thẻ thì xếp hai hàng). Mỗi thẻ mở bằng dòng "### Tên thẻ",
      bên dưới là gạch đầu dòng hoặc đoạn văn; dòng in nghiêng cả câu thành lời giải thích màu nhạt;
      "## Nhãn" trong thẻ thành nhãn chữ hoa nhỏ. Dùng thay cho trang toàn gạch đầu dòng khi đặt hai,
      ba nội dung cạnh nhau (thuận lợi / khó khăn, đơn vị này / đơn vị kia, học kỳ I / học kỳ II).
       ::: the
       ### Thuận lợi
       - Đội ngũ đủ về số lượng
       - Cơ sở vật chất được đầu tư
       ### Khó khăn
       - Địa bàn rộng, nhiều điểm
       :::

   f) SO SÁNH NÊN / KHÔNG NÊN - hai thẻ: thẻ đầu tông đỏ (chưa tốt), thẻ sau tông xanh lá (tốt).
       ::: so-sanh
       ### Chưa tốt
       Nội dung cách làm chưa tốt
       ### Tốt
       Nội dung cách làm tốt
       :::

   g) CÁC BƯỚC - quy trình 3 - 6 bước xếp ngang, hình tròn đánh số, mũi tên giữa các bước.
      Mỗi dòng: tên bước | mô tả ngắn (không bắt buộc)
       ::: buoc
       Rà soát | xác định việc phải làm
       Chuẩn hóa | thống nhất cách làm
       Lưu trữ | sao lưu định kỳ
       :::

   h) DANH SÁCH ĐÁNH SỐ - mỗi mục một hộp có hình tròn số (đến 3 mục: một cột chữ to; từ 4 mục:
      hai cột). Mỗi dòng: tên | mô tả ngắn (không bắt buộc). Muốn số riêng thì ghi "[1.1] Tên".
       ::: danh-sach
       Nhiệm vụ thứ nhất | mô tả ngắn
       Nhiệm vụ thứ hai | mô tả ngắn
       :::

   i) DẢI NHẤN - một dòng ">> Câu chốt của trang" (đặt cuối trang, sau thẻ hoặc các bước).

   j) CHÚ THÍCH NHỎ - một dòng "~ Nguồn: Báo cáo số ... ngày ..." (đặt cuối trang).

4. NGUYÊN TẮC TRÌNH BÀY
   - Mỗi trang 1 ý, tối đa 6 gạch đầu dòng; mỗi gạch đầu dòng dưới 15 chữ.
   - Kiểu the: ưu tiên THẺ, CÁC BƯỚC, DANH SÁCH ĐÁNH SỐ thay cho trang toàn gạch đầu dòng; mỗi trang
     nên có nhãn ("# Nhãn | Tiêu đề"), kết bằng một dải nhấn (">>") hoặc chú thích ("~") khi cần.
   - Chữ nội dung 22 - 24pt, KHÔNG nhỏ hơn 18pt (chuẩn trình chiếu): trang nào dài quá thì công cụ
     **tự tách thành trang mới** và ghi "(tiếp theo)" ở tiêu đề trang sau. Bảng dài cũng tự tách,
     hàng tiêu đề lặp lại. Vì chữ to nên mỗi trang chỉ đặt được 4 - 6 gạch đầu dòng - viết thật gọn.
   - Báo cáo có số liệu thì nên có ít nhất một biểu đồ so sánh (giữa các khối lớp, giữa các điểm
     trường, giữa hai học kỳ) và một khối ô số liệu nổi bật ở đầu báo cáo.
   - Bảng tối đa 6 cột; số liệu nhiều hơn thì đưa vào file Excel kèm theo.
   - Không chép nguyên văn báo cáo vào trang chiếu: rút ý, giữ số liệu.

5. MẪU SẴN THEO LOẠI BÁO CÁO (chép rồi điền, đã có sẵn bố cục và bộ màu)
   - trinh-chieu-so-ket.md        : sơ kết học kỳ                   (màu sang)
   - trinh-chieu-tong-ket.md      : tổng kết năm học                (màu ngoc)
   - trinh-chieu-hoi-nghi.md      : hội nghị viên chức              (màu rung)
   - trinh-chieu-cha-me.md        : họp cha mẹ học sinh             (màu than)
   - trinh-chieu-chuyen-de.md     : chuyên đề sinh hoạt chuyên môn  (màu ruou)

6. XUẤT FILE
   powershell -NoProfile -ExecutionPolicy Bypass -File "{{HE_THONG}}\cong-cu\xuat-ppt.ps1" -Md "<đường dẫn file .md>" -Open
-->

# Tình hình chung | [Tiêu đề trang 1 - ví dụ: Đặc điểm tình hình]

::: so-lieu
[số] | [đơn vị, ví dụ: lớp học]
[số] | [đơn vị, ví dụ: học sinh]
[số] | [đơn vị, ví dụ: cán bộ, giáo viên, nhân viên]
:::

::: the
### [Thuận lợi]
- [Ý thứ nhất]
- [Ý thứ hai]
### [Khó khăn]
- [Ý thứ nhất]
- [Ý thứ hai]
:::

::: ghi chu
[Điều cần nhấn mạnh khi trình bày trang này - không hiện lên màn chiếu]
:::

# = [Phần II. Kết quả thực hiện]

[Phụ đề của phần - một câu ngắn]

# Kết quả | [Tiêu đề trang - ví dụ: Kết quả thực hiện các chỉ tiêu]

| [Nội dung] | [Chỉ tiêu] | [Đạt] | [Tỉ lệ] |
|---|---|---|---|
| | | | |
| Tổng | | | |

::: bieu-do cot [Tiêu đề biểu đồ]
| [Nhãn] | [Chuỗi số liệu] |
|---|---|
| | |
:::

~ [Nguồn: báo cáo số ... ngày ...]

# Cách làm | [Tiêu đề trang - ví dụ: Các bước triển khai]

::: buoc
[Bước 1] | [mô tả ngắn]
[Bước 2] | [mô tả ngắn]
[Bước 3] | [mô tả ngắn]
:::

>> [Câu chốt của trang]

# Định hướng | [Tiêu đề trang cuối - ví dụ: Phương hướng thời gian tới]

::: danh-sach
[Nhiệm vụ 1] | [mô tả ngắn]
[Nhiệm vụ 2] | [mô tả ngắn]
[Nhiệm vụ 3] | [mô tả ngắn]
:::
