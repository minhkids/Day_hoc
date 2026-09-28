# Mẫu: Khung trống (`trong`)

**Dùng khi**: phần mềm không giống các mẫu khác (mô phỏng, vẽ đồ thị bằng canvas, ghép cặp kéo thả, bảng điểm thi đua, sổ theo dõi...). Chép khung này rồi viết phần riêng.

**Có sẵn**: thanh tiêu đề + nút toàn màn hình · vùng nội dung `<main id="noiDung">` · thẻ nội dung mẫu, nút "Bấm thử" · phong cách chung (màu, nút `.nut` `.nut-chinh` `.nut-xanh` `.nut-do` `.nut-lon`, ô nhập, `kbd`, lớp `.dung`/`.sai`) · trong `app.js` có sẵn: `batTatToanManHinh()`, `beep()` và `AM.dung()`/`AM.sai()`, `xaoTron()`, `docTam()`/`luuTam()` an toàn, khung phím tắt bỏ qua khi đang gõ chữ.

**Phím**: `Space` bấm thử · `F` toàn màn hình.

**Sửa nội dung**: `du-lieu.js` - `tieuDe`, `monLop`, `loiGioiThieu`, `cacMuc[]` (`tieuDe`, `noiDung`). Khi viết phần mềm mới, xóa phần thẻ/nút mẫu trong `index.html` và hàm `veNoiDung`, `bamThu` trong `app.js`, giữ các công cụ dùng chung.
