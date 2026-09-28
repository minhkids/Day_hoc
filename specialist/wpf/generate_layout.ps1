$ICON_BIEUDO = 'PATH:M0,20 L4,20 L4,9 L0,9 Z M7,20 L11,20 L11,3 L7,3 Z M14,20 L18,20 L18,12 L14,12 Z'
# Vai trò (cơ quan công tác, chọn ở cửa sổ Khai báo): 'so' Sở GD&ĐT; 'vhxh' Phòng Văn hóa - Xã hội thuộc UBND xã, phường; 'ubnd' lãnh đạo UBND xã, phường.
# Ô có khóa VT: chữ, mô tả (và hành động) đổi theo vai trò - Ap-VaiTro. Khóa 'xa' dùng chung cho vhxh và ubnd.
$TheChinh = @(
    @{ N = 'TcSoan';     Hanh = 'trang:SoanVanBan'; Nen = '#EEF4FF'; C1 = '#4C8DFF'; C2 = '#1E5FD8'; Icon = [char]0xE8A5; Tieu = 'Soạn văn bản';       MoTa = 'Công văn, quyết định, hướng dẫn, tờ trình, phiếu trình...' }
    @{ N = 'TcMau';      Hanh = 'trang:Mau';        Nen = '#EAF8F0'; C1 = '#2DBE78'; C2 = '#0E8A4F'; Icon = [char]0xE8C8; Tieu = 'Mẫu văn bản';        MoTa = 'Mẫu theo Nghị định 30/2020 cho văn bản của cơ quan.' }
    @{ N = 'TcChat';     Hanh = 'chat';             Nen = '#F4EFFF'; C1 = '#A775FF'; C2 = '#7B3FE4'; Icon = [char]0xE8BD; Tieu = 'Trò chuyện AI';      MoTa = 'Hỏi đáp, tư vấn, hỗ trợ công việc quản lý giáo dục.' }
    @{ N = 'TcHuongDan'; Hanh = 'lenh:/huong-dan-nhiem-vu Hướng dẫn nhiệm vụ'; Nen = '#FFF4EA'; C1 = '#FFA24A'; C2 = '#EF6C00'; Icon = [char]0xE787; Tieu = 'Hướng dẫn nhiệm vụ'; MoTa = 'Hướng dẫn nhiệm vụ năm học, chuyên đề cho cấp học phụ trách.'
        VT = @{ so = @('Hướng dẫn nhiệm vụ', 'Hướng dẫn nhiệm vụ năm học, chuyên đề cho cấp học phụ trách.', 'lenh:/huong-dan-nhiem-vu Hướng dẫn nhiệm vụ')
                vhxh = @('Làm slide báo cáo kết quả kiểm tra các trường', 'Lập biểu mẫu Excel số liệu gửi các trường', 'Triển khai nhiệm vụ năm học', 'Kế hoạch, hướng dẫn các trường thực hiện nhiệm vụ năm học.', 'lenh:/huong-dan-nhiem-vu Triển khai nhiệm vụ năm học')
                ubnd = @('Làm slide báo cáo về giáo dục trước HĐND xã', 'Lập bảng Excel theo dõi các trường trên địa bàn', 'Phát biểu, kết luận', 'Bài phát biểu khai giảng, tổng kết; thông báo kết luận.', 'lenh:/phat-bieu Phát biểu, kết luận') } }
    @{ N = 'TcDonVi';    Hanh = 'trang:DonVi';      Nen = '#EDF7EC'; C1 = '#4CAF50'; C2 = '#2E7D32'; Icon = $ICON_BIEUDO;  Tieu = 'Đơn vị, báo cáo';    MoTa = 'Yêu cầu, theo dõi, tổng hợp báo cáo các xã, phường.'
        VT = @{ so = @('Đơn vị, báo cáo', 'Yêu cầu, theo dõi, tổng hợp báo cáo các xã, phường.'); xa = @('Đơn vị, báo cáo', 'Yêu cầu, theo dõi, tổng hợp báo cáo các trường trên địa bàn.') } }
    @{ N = 'TcKiemTra';  Hanh = 'trang:KiemTra';    Nen = '#FFEFF1'; C1 = '#FF6F7A'; C2 = '#E0313F'; Icon = [char]0xE9D5; Tieu = 'Kiểm tra, đánh giá'; MoTa = 'Kiểm tra chuyên môn, chuẩn quốc gia, phổ cập giáo dục.'
        VT = @{ so = @('Kiểm tra, đánh giá', 'Kiểm tra chuyên môn, chuẩn quốc gia, phổ cập giáo dục.'); xa = @('Kiểm tra, đánh giá', 'Kiểm tra các trường, chuẩn quốc gia, phổ cập giáo dục.') } }
    @{ N = 'TcThamMuu';  Hanh = 'lenh:/tham-muu Tham mưu UBND tỉnh'; Nen = '#E8F7F9'; C1 = '#2CC3D6'; C2 = '#00838F'; Icon = [char]0xE7C3; Tieu = 'Tham mưu UBND tỉnh'; MoTa = 'Tờ trình, dự thảo quyết định, kế hoạch trình UBND tỉnh.'
        VT = @{ so = @('Tham mưu UBND tỉnh', 'Tờ trình, dự thảo quyết định, kế hoạch trình UBND tỉnh.', 'lenh:/tham-muu Tham mưu UBND tỉnh')
                vhxh = @('Tham mưu UBND xã', 'Tờ trình, dự thảo quyết định, kế hoạch trình UBND xã, phường.', 'lenh:/tham-muu Tham mưu UBND xã')
                ubnd = @('Văn bản chỉ đạo', 'Quyết định, kế hoạch, công văn chỉ đạo các trường trên địa bàn.', 'lenh:/cong-van Văn bản chỉ đạo của UBND xã') } }
    @{ N = 'TcTraCuu';   Hanh = 'trang:TraCuu';     Nen = '#F1F4F8'; C1 = '#7C90A6'; C2 = '#40546B'; Icon = [char]0xE721; Tieu = 'Tra cứu quy định';   MoTa = 'Luật, Nghị định, Thông tư, Điều lệ trường, chương trình...' }
    @{ N = 'TcVBDen';    Hanh = 'trang:VanBanDen';  Nen = '#FFF8E7'; C1 = '#FFC943'; C2 = '#E09A00'; Icon = [char]0xED25; Tieu = 'Xử lý văn bản đến';  MoTa = 'Đọc, tóm tắt, trích việc từ văn bản của Bộ, UBND tỉnh, các sở...'
        VT = @{ so = @('Xử lý văn bản đến', 'Đọc, tóm tắt, trích việc từ văn bản của Bộ, UBND tỉnh, các sở...'); xa = @('Xử lý văn bản đến', 'Đọc, tóm tắt, trích việc từ văn bản của Sở, UBND tỉnh, UBND xã...') } }
)
$LoaiVB = @(
    @{ N = 'LvCongVan';   Tieu = 'Công văn';           MoTa = 'Mẫu 1.5 - NĐ 30';            Lenh = '/cong-van Soạn công văn' }
    @{ N = 'LvQuyetDinh'; Tieu = 'Quyết định';         MoTa = 'Mẫu 1.2, 1.3 - NĐ 30';       Lenh = '/cong-van Soạn quyết định' }
    @{ N = 'LvKeHoach';   Tieu = 'Kế hoạch';           MoTa = 'Mẫu 1.4 - NĐ 30';            Lenh = '/ke-hoach Lập kế hoạch' }
    @{ N = 'LvBaoCao';    Tieu = 'Báo cáo';            MoTa = 'Mẫu 1.4 - NĐ 30';            Lenh = '/bao-cao Soạn báo cáo' }
    @{ N = 'LvHuongDan';  Tieu = 'Hướng dẫn';          MoTa = 'Mẫu 1.4 - NĐ 30';            Lenh = '/huong-dan-nhiem-vu Soạn hướng dẫn' }
    @{ N = 'LvThongBao';  Tieu = 'Thông báo';          MoTa = 'Mẫu 1.4 - NĐ 30';            Lenh = '/cong-van Soạn thông báo' }
    @{ N = 'LvToTrinh';   Tieu = 'Tờ trình';           MoTa = 'Mẫu 1.4 - kèm dự thảo';      Lenh = '/tham-muu Soạn tờ trình' }
    @{ N = 'LvPhieuTrinh'; Tieu = 'Phiếu trình';       MoTa = 'Trình lãnh đạo xem xét, ký'; Lenh = '/cong-van Soạn phiếu trình' }
    @{ N = 'LvGiayMoi';   Tieu = 'Giấy mời';           MoTa = 'Mẫu 1.7 - NĐ 30';            Lenh = '/cong-van Soạn giấy mời' }
    @{ N = 'LvTrieuTap';  Tieu = 'Giấy triệu tập';     MoTa = 'Tập huấn, hội nghị';          Lenh = '/cong-van Soạn giấy triệu tập' }
    @{ N = 'LvBienBan';   Tieu = 'Biên bản';           MoTa = 'Mẫu 1.9 - NĐ 30';            Lenh = '/bien-ban Lập biên bản' }
    @{ N = 'LvLichTuan';  Tieu = 'Lịch công tác tuần'; MoTa = 'Bảng lịch có phân công';     Lenh = '/lich-tuan Lập lịch công tác tuần' }
)
$TienIch = @(
    @{ N = 'TiVb';        Tieu = 'Lấy văn bản mới (iOffice)'; MoTa = 'Quét sổ văn bản đến trên iOffice đang mở trong Chrome, chia việc theo ngày.'; Icon = [char]0xE896; Mau = '#1E5FD8'; Hanh = 'vb' }
    @{ N = 'TiVBDen';     Tieu = 'Xử lý văn bản đến';   MoTa = 'Thả file Word, PDF, ảnh vào để tóm tắt và trích việc.';          Icon = [char]0xED25; Mau = '#E09A00'; Hanh = 'trang:VanBanDen' }
    @{ N = 'TiTongHop';   Tieu = 'Tổng hợp số liệu';    MoTa = 'Tổng hợp số liệu báo cáo của các đơn vị từ Excel, CSV.'; Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'trang:TongHop' }
    @{ N = 'TiTraCuu';    Tieu = 'Tra cứu quy định';    MoTa = 'Hỏi đáp quy định; danh mục căn cứ pháp lý đã đối chiếu.';            Icon = [char]0xE82D; Mau = '#40546B'; Hanh = 'trang:TraCuu' }
    @{ N = 'TiRaSoat';    Tieu = 'Rà soát văn bản';     MoTa = 'Kiểm tra thể thức NĐ 30, căn cứ, số liệu, chính tả; tạo bản đã sửa.'; Icon = [char]0xE73E; Mau = '#0E8A4F'; Hanh = 'rasoat' }
    @{ N = 'TiThamDinh';  Tieu = 'Thẩm định, phê duyệt'; MoTa = 'Xét thẩm quyền, căn cứ, hồ sơ, nội dung trước khi ký; giáo dục, văn hóa, y tế.'; Icon = [char]0xE8FB; Mau = '#2E7D32'; Hanh = 'lenh:/tham-dinh Thẩm định, phê duyệt' }
    @{ N = 'TiCapNhatCC'; Tieu = 'Cập nhật căn cứ pháp lý'; MoTa = 'Tra văn bản mới, văn bản hết hiệu lực trên trang chính thống, ghi vào bộ nhớ.'; Icon = [char]0xE895; Mau = '#40546B'; Hanh = 'lenh:/cap-nhat-can-cu Cập nhật căn cứ pháp lý' }
    @{ N = 'TiGopY';      Tieu = 'Góp ý dự thảo';       MoTa = 'Góp ý dự thảo văn bản của Bộ, UBND tỉnh, các sở, UBND xã.';    Icon = [char]0xE8F2; Mau = '#7B3FE4'; Hanh = 'lenh:/gop-y-du-thao Góp ý dự thảo' }
    @{ N = 'TiThamMuu';   Tieu = 'Tham mưu, trình ký';  MoTa = 'Tờ trình kèm dự thảo văn bản; phiếu trình lãnh đạo.';            Icon = [char]0xE7C3; Mau = '#00838F'; Hanh = 'lenh:/tham-muu Tham mưu, trình ký' }
    @{ N = 'TiHDNV';      Tieu = 'Hướng dẫn, triển khai nhiệm vụ'; MoTa = 'Hướng dẫn nhiệm vụ năm học, chuyên đề; kế hoạch triển khai.'; Icon = [char]0xE787; Mau = '#EF6C00'; Hanh = 'lenh:/huong-dan-nhiem-vu Hướng dẫn, triển khai nhiệm vụ' }
    @{ N = 'TiTuyenSinh'; Tieu = 'Tuyển sinh';          MoTa = 'Kế hoạch, phê duyệt, báo cáo tuyển sinh mầm non, lớp 1, lớp 6.';  Icon = [char]0xE8FA; Mau = '#1E5FD8'; Hanh = 'lenh:/tuyen-sinh Tuyển sinh' }
    @{ N = 'TiToChuc';    Tieu = 'Tổ chức, sắp xếp trường'; MoTa = 'Thành lập, sáp nhập, phân hiệu; bổ nhiệm, điều động cán bộ quản lý.'; Icon = [char]0xE80F; Mau = '#2E7D32'; Hanh = 'lenh:/to-chuc-truong Tổ chức, sắp xếp trường' }
    @{ N = 'TiPhatBieu';  Tieu = 'Phát biểu, kết luận'; MoTa = 'Bài phát biểu khai giảng, tổng kết, hội nghị; thông báo kết luận.'; Icon = [char]0xE720; Mau = '#C62828'; Hanh = 'lenh:/phat-bieu Phát biểu, kết luận' }
    @{ N = 'TiHoiThi';    Tieu = 'Hội thi, giao lưu';   MoTa = 'Hội thi giáo viên dạy giỏi, giao lưu học sinh, hội thi mầm non.';  Icon = [char]0xE734; Mau = '#E0313F'; Hanh = 'lenh:/hoi-thi Hội thi, giao lưu' }
    @{ N = 'TiBoiDuong';  Tieu = 'Tập huấn, bồi dưỡng'; MoTa = 'Kế hoạch tập huấn, giấy triệu tập, bồi dưỡng thường xuyên.';      Icon = [char]0xE7BE; Mau = '#00838F'; Hanh = 'lenh:/boi-duong Tập huấn, bồi dưỡng' }
    @{ N = 'TiNamHoc';    Tieu = 'Chuyển năm học mới';  MoTa = 'Lưu trữ năm cũ, cập nhật quy mô, nhân sự, lịch năm học.';           Icon = [char]0xE72C; Mau = '#EF6C00'; Hanh = 'lenh:/nam-hoc-moi' }
    @{ N = 'TiGhiNho';    Tieu = 'Ghi nhớ thông tin';   MoTa = 'Cập nhật thông tin cơ quan, nhân sự, đơn vị, quy ước làm việc.';     Icon = [char]0xE734; Mau = '#40546B'; Hanh = 'lenh:/ghi-nho' }
    @{ N = 'TiXuatWord';  Tieu = 'Xuất Word từ file .md'; MoTa = 'Chọn văn bản đã soạn để xuất lại file Word đúng thể thức.';        Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'xuatword' }
    @{ N = 'TiSaoLuu';    Tieu = 'Sao lưu dữ liệu';     MoTa = 'Nén bộ nhớ và toàn bộ văn bản đã soạn ra một file .zip.';          Icon = [char]0xE753; Mau = '#0E8A4F'; Hanh = 'saoluu' }
    @{ N = 'TiDonRac';    Tieu = 'Dọn rác máy tính';    MoTa = 'Xóa tệp tạm, bộ nhớ đệm trình duyệt, báo lỗi cũ cho máy nhẹ hơn.'; Icon = [char]0xE74D; Mau = '#00838F'; Hanh = 'donrac' }
    @{ N = 'TiSuaMay';    Tieu = 'Kiểm tra và sửa máy'; MoTa = 'Chẩn đoán ổ đĩa, bộ nhớ, mạng, virus, lỗi hệ thống; gợi ý và sửa nhanh.'; Icon = [char]0xE7F4; Mau = '#5E35B1'; Hanh = 'suamay' }
    @{ N = 'TiHuongDan';  Tieu = 'Hướng dẫn sử dụng';  MoTa = 'Cách dùng phần mềm, xử lý sự cố thường gặp.';                      Icon = [char]0xE897; Mau = '#7B3FE4'; Hanh = 'huongdan' }
)
# Trang Nhiệm vụ: mỗi vai trò một bộ ô xếp theo nhóm (KhuNVso, KhuNVvhxh, KhuNVubnd - Ap-VaiTro hiện đúng bộ). Hanh phải khác nhau (Tim-O tìm ô theo Hanh).
$NvSo = @(
    @{ N = 'NsHuongDan';    Tieu = 'Hướng dẫn nhiệm vụ năm học';  MoTa = 'Hướng dẫn nhiệm vụ năm học, hướng dẫn chuyên đề cho các đơn vị.';        Icon = [char]0xE787; Mau = '#EF6C00'; Hanh = 'lenh:/huong-dan-nhiem-vu Hướng dẫn nhiệm vụ năm học' }
    @{ N = 'NsChuongTrinh'; Tieu = 'Chương trình, kế hoạch giáo dục'; MoTa = 'Thực hiện chương trình, kế hoạch giáo dục; đánh giá trẻ, học sinh.';  Icon = [char]0xE82D; Mau = '#1E5FD8'; Hanh = 'lenh:/nhiem-vu Chương trình, kế hoạch giáo dục' }
    @{ N = 'NsBoiDuong';    Tieu = 'Tập huấn, bồi dưỡng';         MoTa = 'Tập huấn chuyên đề, bồi dưỡng thường xuyên cán bộ quản lý, giáo viên.';  Icon = [char]0xE7BE; Mau = '#00838F'; Hanh = 'lenh:/boi-duong Tập huấn, bồi dưỡng cấp tỉnh' }
    @{ N = 'NsHoiThi';      Tieu = 'Hội thi, giao lưu';           MoTa = 'Hội thi giáo viên dạy giỏi, giao lưu học sinh, hội thi mầm non.';        Icon = [char]0xE734; Mau = '#E0313F'; Hanh = 'lenh:/hoi-thi Hội thi, giao lưu cấp tỉnh' }
    @{ N = 'NsDoiNgu';      Tieu = 'Đội ngũ, chuẩn nghề nghiệp';  MoTa = 'Đánh giá chuẩn nghề nghiệp, nhu cầu giáo viên, cán bộ quản lý.';         Icon = [char]0xE77B; Mau = '#7B3FE4'; Hanh = 'lenh:/nhiem-vu Đội ngũ, chuẩn nghề nghiệp' }
    @{ N = 'NsCDS';         Tieu = 'Chuyển đổi số, dữ liệu ngành'; MoTa = 'Học bạ số, cơ sở dữ liệu ngành, ứng dụng công nghệ, trí tuệ nhân tạo.'; Icon = [char]0xE774; Mau = '#40546B'; Hanh = 'lenh:/nhiem-vu Chuyển đổi số, dữ liệu ngành' }
    @{ N = 'NsThamMuu';     Tieu = 'Tham mưu UBND tỉnh';          MoTa = 'Tờ trình kèm dự thảo quyết định, kế hoạch, chỉ thị của UBND tỉnh.';      Icon = [char]0xE7C3; Mau = '#00838F'; Hanh = 'lenh:/tham-muu Tham mưu UBND tỉnh (trang Nhiệm vụ)' }
    @{ N = 'NsPhieuTrinh';  Tieu = 'Phiếu trình, trình ký';       MoTa = 'Phiếu trình giải quyết công việc lên lãnh đạo phòng, lãnh đạo Sở.';      Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/tham-muu Phiếu trình giải quyết công việc' }
    @{ N = 'NsGopY';        Tieu = 'Góp ý dự thảo';               MoTa = 'Góp ý dự thảo văn bản của Bộ, UBND tỉnh, các sở, ngành.';                Icon = [char]0xE8F2; Mau = '#7B3FE4'; Hanh = 'lenh:/gop-y-du-thao Góp ý dự thảo của Bộ, tỉnh' }
    @{ N = 'NsTuyenSinh';   Tieu = 'Tuyển sinh';                  MoTa = 'Hướng dẫn, theo dõi, báo cáo tuyển sinh mầm non, lớp 1.';                Icon = [char]0xE8FA; Mau = '#1E5FD8'; Hanh = 'lenh:/tuyen-sinh Hướng dẫn tuyển sinh' }
    @{ N = 'NsToChuc';      Tieu = 'Mạng lưới trường, lớp';       MoTa = 'Sắp xếp trường, phân hiệu, điểm trường; cho phép hoạt động giáo dục.';   Icon = [char]0xE80F; Mau = '#2E7D32'; Hanh = 'lenh:/to-chuc-truong Mạng lưới trường, lớp' }
    @{ N = 'NsKiemTra';     Tieu = 'Kiểm tra, đánh giá';          MoTa = 'Mở trang Kiểm tra: kiểm tra chuyên môn, chuẩn quốc gia, phổ cập.';      Icon = [char]0xE9D5; Mau = '#E0313F'; Hanh = 'trang:KiemTra' }
    @{ N = 'NsDonVi';       Tieu = 'Báo cáo của đơn vị';          MoTa = 'Mở trang Đơn vị, báo cáo: yêu cầu, theo dõi, tổng hợp.';                 Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'trang:DonVi' }
    @{ N = 'NsBaoCao';      Tieu = 'Báo cáo Bộ, UBND tỉnh';       MoTa = 'Báo cáo định kỳ, chuyên đề, theo yêu cầu của Bộ, UBND tỉnh.';            Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/bao-cao Báo cáo Bộ, UBND tỉnh' }
    @{ N = 'NsSoKet';       Tieu = 'Sơ kết, tổng kết';            MoTa = 'Sơ kết học kì I, tổng kết năm học cấp học phụ trách.';                   Icon = [char]0xE9D5; Mau = '#EF6C00'; Hanh = 'lenh:/bao-cao Sơ kết, tổng kết năm học cấp tỉnh' }
    @{ N = 'NsViecThang';   Tieu = 'Việc tháng này';              MoTa = 'Danh sách việc của chuyên viên theo tháng, ghi vào Quản lý công việc.';  Icon = [char]0xE787; Mau = '#C62828'; Hanh = 'lenh:/nhiem-vu Việc tháng của chuyên viên' }
    @{ N = 'NsThongKe';     Tieu = 'Thống kê, số liệu';           MoTa = 'Tổng hợp số liệu cấp học toàn tỉnh từ file Excel, CSV.';                 Icon = $ICON_BIEUDO;  Mau = '#00838F'; Hanh = 'lenh:/tong-hop Thống kê số liệu toàn tỉnh' }
    @{ N = 'NsPhatBieu';    Tieu = 'Phát biểu, kết luận';         MoTa = 'Bài phát biểu, thông báo kết luận của lãnh đạo Sở tại hội nghị.';       Icon = [char]0xE720; Mau = '#C62828'; Hanh = 'lenh:/phat-bieu Phát biểu của lãnh đạo Sở' }
    @{ N = 'NsThamDinh';    Tieu = 'Thẩm định trước khi trình';   MoTa = 'Thẩm quyền, căn cứ còn hiệu lực, hồ sơ, nội dung, thể thức của văn bản.'; Icon = [char]0xE8FB; Mau = '#2E7D32'; Hanh = 'lenh:/tham-dinh Thẩm định trước khi trình ký (Sở)' }
    @{ N = 'NsTraCuu';      Tieu = 'Tư vấn quy định';             MoTa = 'Hỏi quy định giáo dục mầm non, tiểu học; trả lời kèm điều, khoản.';     Icon = [char]0xE82D; Mau = '#1E5FD8'; Hanh = 'lenh:/tra-cuu Tư vấn quy định giáo dục' }
    @{ N = 'NsCapNhat';     Tieu = 'Cập nhật căn cứ';             MoTa = 'Văn bản mới, văn bản hết hiệu lực; ghi vào bộ nhớ để dùng ngay.';        Icon = [char]0xE895; Mau = '#40546B'; Hanh = 'lenh:/cap-nhat-can-cu Cập nhật căn cứ giáo dục' }
)
$NhomNvSo = [ordered]@{
    'CHỈ ĐẠO CHUYÊN MÔN' = @('NsHuongDan', 'NsChuongTrinh', 'NsBoiDuong', 'NsHoiThi', 'NsDoiNgu', 'NsCDS')
    'QUẢN LÝ NHÀ NƯỚC'   = @('NsThamMuu', 'NsPhieuTrinh', 'NsGopY', 'NsTuyenSinh', 'NsToChuc', 'NsKiemTra')
    'CĂN CỨ, THẨM ĐỊNH'  = @('NsThamDinh', 'NsTraCuu', 'NsCapNhat')
    'THEO DÕI, BÁO CÁO'  = @('NsDonVi', 'NsBaoCao', 'NsSoKet', 'NsViecThang', 'NsThongKe', 'NsPhatBieu')
}
$NvXa = @(
    @{ N = 'NxHuongDan';   Tieu = 'Triển khai nhiệm vụ năm học';  MoTa = 'Kế hoạch, hướng dẫn các trường thực hiện nhiệm vụ năm học.';              Icon = [char]0xE787; Mau = '#EF6C00'; Hanh = 'lenh:/huong-dan-nhiem-vu Triển khai nhiệm vụ năm học trên địa bàn' }
    @{ N = 'NxTuyenSinh';  Tieu = 'Tuyển sinh';                   MoTa = 'Kế hoạch tuyển sinh mầm non, lớp 1, lớp 6; phê duyệt, báo cáo.';         Icon = [char]0xE8FA; Mau = '#1E5FD8'; Hanh = 'lenh:/tuyen-sinh Tuyển sinh trên địa bàn' }
    @{ N = 'NxToChuc';     Tieu = 'Tổ chức trường, cán bộ quản lý'; MoTa = 'Thành lập, sáp nhập, phân hiệu; bổ nhiệm, điều động cán bộ quản lý.';  Icon = [char]0xE80F; Mau = '#2E7D32'; Hanh = 'lenh:/to-chuc-truong Tổ chức trường, cán bộ quản lý' }
    @{ N = 'NxBoiDuong';   Tieu = 'Bồi dưỡng, sinh hoạt cụm';     MoTa = 'Bồi dưỡng thường xuyên, sinh hoạt chuyên môn cụm trường.';               Icon = [char]0xE7BE; Mau = '#00838F'; Hanh = 'lenh:/boi-duong Bồi dưỡng giáo viên trên địa bàn' }
    @{ N = 'NxHoiThi';     Tieu = 'Hội thi, giao lưu';            MoTa = 'Hội thi giáo viên dạy giỏi cấp xã, giao lưu học sinh.';                  Icon = [char]0xE734; Mau = '#E0313F'; Hanh = 'lenh:/hoi-thi Hội thi cấp xã' }
    @{ N = 'NxPhoCap';     Tieu = 'Phổ cập giáo dục';             MoTa = 'Điều tra, hồ sơ phổ cập, xóa mù chữ; đề nghị kiểm tra công nhận.';       Icon = [char]0xE774; Mau = '#40546B'; Hanh = 'lenh:/pho-cap Phổ cập giáo dục cấp xã' }
    @{ N = 'NxThamMuu';    Tieu = 'Tham mưu UBND xã';             MoTa = 'Tờ trình kèm dự thảo quyết định, kế hoạch của UBND xã, phường.';        Icon = [char]0xE7C3; Mau = '#00838F'; Hanh = 'lenh:/tham-muu Tham mưu UBND xã (trang Nhiệm vụ)' }
    @{ N = 'NxPhieuTrinh'; Tieu = 'Phiếu trình lãnh đạo UBND';    MoTa = 'Trình Chủ tịch, Phó Chủ tịch xem xét, ký văn bản.';                     Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/tham-muu Phiếu trình lãnh đạo UBND xã' }
    @{ N = 'NxGopY';       Tieu = 'Góp ý dự thảo';                MoTa = 'Góp ý dự thảo văn bản của Sở, UBND tỉnh, UBND xã.';                     Icon = [char]0xE8F2; Mau = '#7B3FE4'; Hanh = 'lenh:/gop-y-du-thao Góp ý dự thảo (cấp xã)' }
    @{ N = 'NxPhatBieu';   Tieu = 'Bài phát biểu cho lãnh đạo';   MoTa = 'Phát biểu khai giảng, tổng kết, hội nghị của lãnh đạo UBND xã.';        Icon = [char]0xE720; Mau = '#C62828'; Hanh = 'lenh:/phat-bieu Bài phát biểu cho lãnh đạo UBND xã' }
    @{ N = 'NxKiemTra';    Tieu = 'Kiểm tra các trường';          MoTa = 'Mở trang Kiểm tra: kiểm tra các trường, chuẩn quốc gia, phổ cập.';     Icon = [char]0xE9D5; Mau = '#E0313F'; Hanh = 'trang:KiemTra' }
    @{ N = 'NxCSVC';       Tieu = 'Cơ sở vật chất, chế độ';       MoTa = 'Cơ sở vật chất, kinh phí, chế độ chính sách cho trẻ, học sinh, giáo viên.'; Icon = [char]0xE8C7; Mau = '#EF6C00'; Hanh = 'lenh:/nhiem-vu Cơ sở vật chất, kinh phí, chế độ chính sách' }
    @{ N = 'NxDonVi';      Tieu = 'Báo cáo của các trường';       MoTa = 'Mở trang Đơn vị, báo cáo: yêu cầu, theo dõi, tổng hợp.';                 Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'trang:DonVi' }
    @{ N = 'NxBaoCao';     Tieu = 'Báo cáo Sở, UBND xã';          MoTa = 'Báo cáo định kỳ, chuyên đề theo yêu cầu của Sở, UBND xã.';               Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/bao-cao Báo cáo Sở, UBND xã' }
    @{ N = 'NxSoKet';      Tieu = 'Sơ kết, tổng kết';             MoTa = 'Sơ kết học kì I, tổng kết năm học giáo dục trên địa bàn.';               Icon = [char]0xE9D5; Mau = '#EF6C00'; Hanh = 'lenh:/bao-cao Sơ kết, tổng kết năm học cấp xã' }
    @{ N = 'NxViecThang';  Tieu = 'Việc tháng này';               MoTa = 'Việc của Phòng theo tháng, ghi vào Quản lý công việc.';                  Icon = [char]0xE787; Mau = '#C62828'; Hanh = 'lenh:/nhiem-vu Việc tháng của Phòng' }
    @{ N = 'NxThongKe';    Tieu = 'Thống kê, số liệu';            MoTa = 'Tổng hợp số liệu các trường từ file Excel, CSV.';                        Icon = $ICON_BIEUDO;  Mau = '#00838F'; Hanh = 'lenh:/tong-hop Thống kê số liệu các trường' }
    @{ N = 'NxVBDen';      Tieu = 'Xử lý văn bản đến';            MoTa = 'Đọc, tóm tắt văn bản của Sở, UBND tỉnh, UBND xã.';                       Icon = [char]0xED25; Mau = '#E09A00'; Hanh = 'trang:VanBanDen' }
    @{ N = 'NxThamDinh';   Tieu = 'Thẩm định hồ sơ trình ký';     MoTa = 'Thẩm quyền, căn cứ, hồ sơ, nội dung trước khi trình UBND xã ký, phê duyệt.'; Icon = [char]0xE8FB; Mau = '#2E7D32'; Hanh = 'lenh:/tham-dinh Thẩm định hồ sơ trình UBND xã' }
    @{ N = 'NxVanHoa';     Tieu = 'Văn hóa, thể thao, gia đình';  MoTa = 'Tư vấn quy định: lễ hội, danh hiệu văn hóa, thông tin cơ sở, thể thao.'; Icon = [char]0xE8B9; Mau = '#C62828'; Hanh = 'lenh:/tra-cuu Tư vấn văn hóa, thể thao, gia đình (Phòng)' }
    @{ N = 'NxYTe';        Tieu = 'Y tế, an toàn thực phẩm';      MoTa = 'Tư vấn quy định: trạm y tế, an toàn thực phẩm, y tế trường học, dân số.'; Icon = [char]0xE95E; Mau = '#00838F'; Hanh = 'lenh:/tra-cuu Tư vấn y tế, an toàn thực phẩm (Phòng)' }
)
$NhomNvXa = [ordered]@{
    'TRIỂN KHAI NHIỆM VỤ NĂM HỌC' = @('NxHuongDan', 'NxTuyenSinh', 'NxToChuc', 'NxBoiDuong', 'NxHoiThi', 'NxPhoCap')
    'THAM MƯU UBND XÃ, PHƯỜNG'    = @('NxThamMuu', 'NxPhieuTrinh', 'NxGopY', 'NxPhatBieu', 'NxKiemTra', 'NxCSVC')
    'VĂN HÓA, Y TẾ, THẨM ĐỊNH'    = @('NxThamDinh', 'NxVanHoa', 'NxYTe')
    'THEO DÕI, BÁO CÁO'           = @('NxDonVi', 'NxBaoCao', 'NxSoKet', 'NxViecThang', 'NxThongKe', 'NxVBDen')
}
$NvUb = @(
    @{ N = 'NuChiDao';    Tieu = 'Chỉ đạo nhiệm vụ năm học';   MoTa = 'Kế hoạch, công văn chỉ đạo các trường trên địa bàn.';                       Icon = [char]0xE787; Mau = '#EF6C00'; Hanh = 'lenh:/nhiem-vu Chỉ đạo nhiệm vụ năm học' }
    @{ N = 'NuXemXet';    Tieu = 'Xem xét văn bản trình';      MoTa = 'Rà soát tờ trình, dự thảo do Phòng Văn hóa - Xã hội trình ký.';            Icon = [char]0xE73E; Mau = '#0E8A4F'; Hanh = 'lenh:/ra-soat Xem xét văn bản Phòng Văn hóa - Xã hội trình' }
    @{ N = 'NuPhatBieu';  Tieu = 'Phát biểu';                  MoTa = 'Bài phát biểu khai giảng, tổng kết, hội nghị giáo dục.';                    Icon = [char]0xE720; Mau = '#C62828'; Hanh = 'lenh:/phat-bieu Bài phát biểu của lãnh đạo UBND xã' }
    @{ N = 'NuKetLuan';   Tieu = 'Thông báo kết luận';         MoTa = 'Kết luận của lãnh đạo UBND xã tại cuộc họp, buổi làm việc.';                Icon = [char]0xE8BD; Mau = '#7B3FE4'; Hanh = 'lenh:/phat-bieu Thông báo kết luận' }
    @{ N = 'NuToChuc';    Tieu = 'Tổ chức trường, cán bộ quản lý'; MoTa = 'Quyết định thành lập, sáp nhập trường; bổ nhiệm, điều động cán bộ quản lý.'; Icon = [char]0xE80F; Mau = '#2E7D32'; Hanh = 'lenh:/to-chuc-truong Quyết định về tổ chức trường, cán bộ quản lý' }
    @{ N = 'NuTuyenSinh'; Tieu = 'Tuyển sinh';                 MoTa = 'Phê duyệt kế hoạch tuyển sinh mầm non, lớp 1, lớp 6.';                      Icon = [char]0xE8FA; Mau = '#1E5FD8'; Hanh = 'lenh:/tuyen-sinh Phê duyệt tuyển sinh' }
    @{ N = 'NuKiemTra';   Tieu = 'Kiểm tra các trường';        MoTa = 'Mở trang Kiểm tra: kiểm tra, chuẩn quốc gia, phổ cập.';                     Icon = [char]0xE9D5; Mau = '#E0313F'; Hanh = 'trang:KiemTra' }
    @{ N = 'NuPhoCap';    Tieu = 'Phổ cập giáo dục';           MoTa = 'Chỉ đạo phổ cập giáo dục, xóa mù chữ; đề nghị công nhận.';                  Icon = [char]0xE774; Mau = '#40546B'; Hanh = 'lenh:/pho-cap Chỉ đạo phổ cập giáo dục' }
    @{ N = 'NuBaoCao';    Tieu = 'Báo cáo UBND tỉnh, Sở';      MoTa = 'Báo cáo tình hình giáo dục trên địa bàn theo yêu cầu cấp trên.';            Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/bao-cao Báo cáo của UBND xã về giáo dục' }
    @{ N = 'NuViecThang'; Tieu = 'Việc tháng này';             MoTa = 'Việc chỉ đạo giáo dục trong tháng, ghi vào Quản lý công việc.';             Icon = [char]0xE787; Mau = '#C62828'; Hanh = 'lenh:/nhiem-vu Việc tháng của lãnh đạo UBND xã' }
    @{ N = 'NuDonVi';     Tieu = 'Báo cáo của các trường';     MoTa = 'Mở trang Đơn vị, báo cáo: yêu cầu, theo dõi, tổng hợp.';                    Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'trang:DonVi' }
    @{ N = 'NuVBDen';     Tieu = 'Xử lý văn bản đến';          MoTa = 'Đọc, tóm tắt văn bản của UBND tỉnh, Sở, các trường.';                       Icon = [char]0xED25; Mau = '#E09A00'; Hanh = 'trang:VanBanDen' }
    @{ N = 'NuThamDinh';  Tieu = 'Thẩm định trước khi ký';     MoTa = 'Đúng thẩm quyền, căn cứ còn hiệu lực, đủ hồ sơ chưa; kết luận ký được hay cần sửa.'; Icon = [char]0xE8FB; Mau = '#2E7D32'; Hanh = 'lenh:/tham-dinh Thẩm định trước khi ký, phê duyệt' }
    @{ N = 'NuVanHoa';    Tieu = 'Văn hóa, thể thao, gia đình'; MoTa = 'Tư vấn quy định, phê duyệt: lễ hội, danh hiệu văn hóa, thể thao, thông tin.'; Icon = [char]0xE8B9; Mau = '#C62828'; Hanh = 'lenh:/tra-cuu Tư vấn văn hóa, thể thao, gia đình (lãnh đạo)' }
    @{ N = 'NuYTe';       Tieu = 'Y tế, an toàn thực phẩm';    MoTa = 'Tư vấn quy định, chỉ đạo: trạm y tế, an toàn thực phẩm, dịch bệnh, dân số.'; Icon = [char]0xE95E; Mau = '#00838F'; Hanh = 'lenh:/tra-cuu Tư vấn y tế, an toàn thực phẩm (lãnh đạo)' }
)
$NhomNvUb = [ordered]@{
    'CHỈ ĐẠO, ĐIỀU HÀNH' = @('NuChiDao', 'NuXemXet', 'NuPhatBieu', 'NuKetLuan', 'NuToChuc', 'NuTuyenSinh')
    'VĂN HÓA, Y TẾ, THẨM ĐỊNH' = @('NuThamDinh', 'NuVanHoa', 'NuYTe')
    'THEO DÕI, KIỂM TRA' = @('NuKiemTra', 'NuPhoCap', 'NuBaoCao', 'NuViecThang', 'NuDonVi', 'NuVBDen')
}
$NhiemVu = @($NvSo + $NvXa + $NvUb)
# Trang Đơn vị, báo cáo
$DonViO = @(
    @{ N = 'DvYeuCau';   Tieu = 'Yêu cầu báo cáo';   MoTa = 'Công văn, đề cương, biểu mẫu báo cáo gửi các đơn vị.';        Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/tong-hop-don-vi Yêu cầu báo cáo' }
    @{ N = 'DvTheoDoi';  Tieu = 'Theo dõi nộp';      MoTa = 'Đối chiếu đơn vị đã nộp, chưa nộp theo từng đợt.';            Icon = [char]0xE9D5; Mau = '#E09A00'; Hanh = 'lenh:/tong-hop-don-vi Theo dõi nộp báo cáo' }
    @{ N = 'DvDonDoc';   Tieu = 'Đôn đốc';           MoTa = 'Công văn, tin nhắn đôn đốc đơn vị chưa nộp.';                 Icon = [char]0xE8BD; Mau = '#E0313F'; Hanh = 'lenh:/tong-hop-don-vi Đôn đốc báo cáo' }
    @{ N = 'DvTongHop';  Tieu = 'Tổng hợp báo cáo';  MoTa = 'Gộp báo cáo, số liệu các đơn vị thành báo cáo chung.';        Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'lenh:/tong-hop-don-vi Tổng hợp báo cáo đơn vị' }
    @{ N = 'DvDanhSach'; Tieu = 'Danh sách đơn vị';  MoTa = 'Cập nhật đơn vị, đầu mối, số trường, chuẩn quốc gia.';        Icon = [char]0xE716; Mau = '#7B3FE4'; Hanh = 'lenh:/ghi-nho Danh sách đơn vị' }
    @{ N = 'DvSoLieu';   Tieu = 'Số liệu tổng hợp';  MoTa = 'Thống kê số liệu các đơn vị từ file Excel, CSV.';             Icon = $ICON_BIEUDO;  Mau = '#00838F'; Hanh = 'lenh:/tong-hop Số liệu các đơn vị' }
)
# Trang Kiểm tra, đánh giá
$KiemTraO = @(
    @{ N = 'KtKeHoach';   Tieu = 'Kế hoạch kiểm tra';        MoTa = 'Kế hoạch kiểm tra năm học, đợt kiểm tra chuyên đề.';                  Icon = [char]0xE787; Mau = '#1E5FD8'; Hanh = 'lenh:/kiem-tra Kế hoạch kiểm tra' }
    @{ N = 'KtQuyetDinh'; Tieu = 'Quyết định, đề cương';     MoTa = 'Quyết định thành lập đoàn, đề cương làm việc, lịch kiểm tra.';        Icon = [char]0xE8A5; Mau = '#0E8A4F'; Hanh = 'lenh:/kiem-tra Quyết định thành lập đoàn, đề cương' }
    @{ N = 'KtDuGio';     Tieu = 'Phiếu dự giờ, quan sát';   MoTa = 'Phiếu dự giờ, quan sát hoạt động, kiểm tra hồ sơ.';                   Icon = [char]0xE890; Mau = '#EF6C00'; Hanh = 'lenh:/kiem-tra Phiếu dự giờ, quan sát' }
    @{ N = 'KtBienBan';   Tieu = 'Biên bản kiểm tra';        MoTa = 'Biên bản làm việc, kiểm tra tại đơn vị từ ghi chép.';                 Icon = [char]0xE716; Mau = '#7B3FE4'; Hanh = 'lenh:/kiem-tra Biên bản kiểm tra' }
    @{ N = 'KtKetLuan';   Tieu = 'Thông báo kết quả';        MoTa = 'Thông báo kết quả, kết luận kiểm tra gửi đơn vị.';                    Icon = [char]0xE8BD; Mau = '#E0313F'; Hanh = 'lenh:/kiem-tra Thông báo kết quả kiểm tra' }
    @{ N = 'KtBaoCao';    Tieu = 'Báo cáo tổng hợp';         MoTa = 'Báo cáo tổng hợp kết quả đợt kiểm tra.';                              Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'lenh:/kiem-tra Báo cáo tổng hợp kiểm tra' }
    @{ N = 'KdKeHoach';   Tieu = 'Kế hoạch, hướng dẫn';      MoTa = 'Kế hoạch, hướng dẫn bảo đảm chất lượng, chuẩn quốc gia (TT 57/2026).'; Icon = [char]0xE73E; Mau = '#2E7D32'; Hanh = 'lenh:/chuan-chat-luong Kế hoạch, hướng dẫn bảo đảm chất lượng, chuẩn quốc gia' }
    @{ N = 'KdThamDinh';  Tieu = 'Hội đồng thẩm định';        MoTa = 'Quyết định hội đồng, phiếu ý kiến, biên bản, thông báo kết quả.';     Icon = [char]0xE9D5; Mau = '#00838F'; Hanh = 'lenh:/chuan-chat-luong Hội đồng thẩm định chuẩn quốc gia' }
    @{ N = 'KdCongNhan';  Tieu = 'Công nhận, báo cáo năm'; MoTa = 'Quyết định công nhận, thu hồi; báo cáo năm (Mẫu số 7).';             Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/chuan-chat-luong Tờ trình, quyết định công nhận' }
    @{ N = 'PcKeHoach';   Tieu = 'Kế hoạch phổ cập';         MoTa = 'Kế hoạch phổ cập giáo dục mầm non, tiểu học, xóa mù chữ.';            Icon = [char]0xE787; Mau = '#40546B'; Hanh = 'lenh:/pho-cap Kế hoạch phổ cập' }
    @{ N = 'PcKiemTra';   Tieu = 'Kiểm tra công nhận';       MoTa = 'Kiểm tra, công nhận xã, phường đạt chuẩn phổ cập.';                   Icon = [char]0xE9D5; Mau = '#E09A00'; Hanh = 'lenh:/pho-cap Kiểm tra công nhận phổ cập' }
    @{ N = 'PcBaoCao';    Tieu = 'Báo cáo phổ cập';          MoTa = 'Báo cáo kết quả phổ cập, xóa mù chữ; tổng hợp số liệu.';              Icon = $ICON_BIEUDO;  Mau = '#00838F'; Hanh = 'lenh:/pho-cap Báo cáo phổ cập' }
)
$NhomKT = [ordered]@{
    'KIỂM TRA'                  = @('KtKeHoach', 'KtQuyetDinh', 'KtDuGio', 'KtBienBan', 'KtKetLuan', 'KtBaoCao')
    'KIỂM ĐỊNH, CHUẨN QUỐC GIA' = @('KdKeHoach', 'KdThamDinh', 'KdCongNhan')
    'PHỔ CẬP GIÁO DỤC'          = @('PcKeHoach', 'PcKiemTra', 'PcBaoCao')
}
# Bấm một ô quy trình (lenh:) chỉ CHỌN quy trình: mở việc mới trong Trò chuyện, hiện các gợi ý dưới đây, trợ lý chờ người dùng ghi việc cụ thể
# rồi mới làm. Chỗ trống: {thang} tháng này, {quy} quý, {nam} năm, {namhoc} năm học, {caphoc} cấp học phụ trách, {donvi} "các xã, phường"
# (Sở) hoặc "các trường" (cấp xã), {ubnd} "UBND tỉnh" hoặc "UBND xã". Gợi ý dạng @{ so = ...; xa = ...; vhxh = ...; ubnd = ... } chọn theo vai trò.
$GoiYO = @{
    TcHuongDan  = @{ so = @('Hướng dẫn thực hiện nhiệm vụ giáo dục {caphoc} năm học {namhoc}', 'Hướng dẫn kiểm tra, đánh giá định kỳ cuối học kì I', 'Hướng dẫn chuyên đề: (ghi tên chuyên đề)')
                     vhxh = @('Kế hoạch thực hiện nhiệm vụ giáo dục năm học {namhoc} trên địa bàn', 'Công văn hướng dẫn các trường triển khai văn bản của Sở (đính kèm văn bản)')
                     ubnd = @('Bài phát biểu khai giảng năm học {namhoc}', 'Thông báo kết luận của lãnh đạo UBND tại hội nghị: (dán ghi chép)') }
    TcThamMuu   = @{ so = @('Tờ trình UBND tỉnh ban hành kế hoạch: (ghi nội dung), kèm dự thảo quyết định', 'Dự thảo quyết định của UBND tỉnh về: (ghi nội dung)', 'Phiếu trình lãnh đạo Sở: (ghi việc cần trình)')
                     vhxh = @('Tờ trình UBND xã phê duyệt: (ghi nội dung), kèm dự thảo quyết định', 'Dự thảo kế hoạch của UBND xã về: (ghi nội dung)', 'Phiếu trình lãnh đạo UBND xã: (ghi việc cần trình)')
                     ubnd = @('Công văn chỉ đạo các trường về: (ghi nội dung)', 'Quyết định của UBND xã về: (ghi nội dung)', 'Kế hoạch của UBND xã về: (ghi nội dung)') }
    TiGopY      = @('Góp ý dự thảo văn bản (đính kèm dự thảo)', 'Công văn góp ý dự thảo: (ghi tên dự thảo, cơ quan xin ý kiến)')
    TiTuyenSinh = @{ so = @('Hướng dẫn tuyển sinh mầm non, lớp 1 năm học {namhoc}', 'Báo cáo kết quả tuyển sinh {caphoc} toàn tỉnh')
                     xa = @('Kế hoạch tuyển sinh mầm non, lớp 1, lớp 6 năm học {namhoc} trên địa bàn', 'Quyết định phê duyệt kế hoạch tuyển sinh của các trường', 'Báo cáo kết quả tuyển sinh gửi Sở') }
    TiToChuc    = @{ so = @('Tờ trình phương án sắp xếp mạng lưới trường, lớp: (ghi nội dung)', 'Hướng dẫn tổ chức hoạt động trường chính, phân hiệu, điểm trường')
                     xa = @('Tờ trình thành lập (sáp nhập) trường: (ghi nội dung)', 'Quyết định bổ nhiệm (điều động) cán bộ quản lý: (ghi họ tên, trường)', 'Quyết định giao chỉ tiêu số lớp, số trẻ, học sinh năm học {namhoc}') }
    TiPhatBieu  = @('Bài phát biểu khai giảng năm học {namhoc}', 'Bài phát biểu chỉ đạo hội nghị tổng kết năm học', 'Thông báo kết luận cuộc họp: (dán ghi chép)')
    TiHoiThi    = @{ so = @('Kế hoạch hội thi giáo viên dạy giỏi {caphoc} cấp tỉnh', 'Quyết định thành lập Ban tổ chức, Ban giám khảo hội thi', 'Thông báo kết quả hội thi')
                     xa = @('Kế hoạch hội thi giáo viên dạy giỏi cấp xã năm học {namhoc}', 'Quyết định công nhận giáo viên dạy giỏi cấp xã') }
    TiBoiDuong  = @('Kế hoạch tập huấn chuyên đề: (ghi tên chuyên đề) cho cán bộ quản lý, giáo viên {caphoc}', 'Giấy triệu tập tập huấn: (ghi thời gian, địa điểm)', 'Kế hoạch bồi dưỡng thường xuyên năm học {namhoc}', 'Báo cáo kết quả tập huấn')
    TiNamHoc    = @('Chuyển bộ nhớ sang năm học {namhoc}')
    TiGhiNho    = @('Ghi nhớ: (ghi điều cần nhớ)')
    NsChuongTrinh = @('Hướng dẫn xây dựng kế hoạch giáo dục nhà trường {caphoc} năm học {namhoc}', 'Hướng dẫn đánh giá trẻ, học sinh cuối học kì I', 'Kế hoạch triển khai chương trình (thí điểm chương trình giáo dục mầm non mới)')
    NsDoiNgu    = @('Hướng dẫn đánh giá giáo viên theo chuẩn nghề nghiệp năm học {namhoc}', 'Tổng hợp nhu cầu giáo viên {caphoc} (đính kèm số liệu)')
    NsCDS       = @('Hướng dẫn cập nhật cơ sở dữ liệu ngành đầu năm học {namhoc}', 'Kế hoạch chuyển đổi số giáo dục {caphoc} năm học {namhoc}')
    NsPhieuTrinh = @('Phiếu trình lãnh đạo Sở: (ghi việc cần trình, đính kèm văn bản)', 'Phiếu trình lãnh đạo phòng: (ghi việc cần trình)')
    NsBaoCao    = @('Báo cáo đầu năm học {namhoc} giáo dục {caphoc}', 'Báo cáo theo văn bản yêu cầu của Bộ (đính kèm văn bản)', 'Báo cáo chuyên đề: (ghi nội dung)')
    NsSoKet     = @('Báo cáo sơ kết học kì I năm học {namhoc} giáo dục {caphoc}', 'Báo cáo tổng kết năm học {namhoc}')
    NsViecThang = @('Lập danh sách việc tháng {thang} của chuyên viên và ghi vào Quản lý công việc', 'Việc cần chuẩn bị trước cho tháng sau')
    NsThongKe   = @('Tổng hợp số trường, lớp, trẻ, học sinh {caphoc} theo xã, phường (đính kèm file)', 'So sánh số liệu với cùng kỳ năm học trước')
    NxBoiDuong  = @('Kế hoạch bồi dưỡng thường xuyên năm học {namhoc} của giáo viên trên địa bàn', 'Kế hoạch sinh hoạt chuyên môn cụm trường')
    NxPhoCap    = @('Kế hoạch phổ cập giáo dục, xóa mù chữ năm {nam} của xã', 'Báo cáo tự kiểm tra phổ cập giáo dục {caphoc}', 'Tờ trình đề nghị Sở kiểm tra công nhận phổ cập')
    NxPhieuTrinh = @('Phiếu trình Phó Chủ tịch UBND xã: (ghi việc cần trình)')
    NxCSVC      = @('Báo cáo thực trạng cơ sở vật chất các trường (đính kèm số liệu)', 'Tờ trình hỗ trợ kinh phí sửa chữa: (ghi trường, nội dung)', 'Tổng hợp chế độ hỗ trợ ăn trưa, chi phí học tập cho trẻ mầm non')
    NxBaoCao    = @('Báo cáo đầu năm học {namhoc} giáo dục trên địa bàn', 'Báo cáo theo văn bản yêu cầu của Sở (đính kèm văn bản)')
    NxSoKet     = @('Báo cáo sơ kết học kì I năm học {namhoc} giáo dục trên địa bàn', 'Báo cáo tổng kết năm học {namhoc}')
    NxViecThang = @('Lập danh sách việc tháng {thang} về giáo dục của Phòng và ghi vào Quản lý công việc')
    NxThongKe   = @('Tổng hợp số lớp, trẻ, học sinh, giáo viên các trường (đính kèm file)')
    NuChiDao    = @('Kế hoạch của UBND xã thực hiện nhiệm vụ giáo dục năm học {namhoc}', 'Công văn chỉ đạo các trường về: (ghi nội dung)')
    NuXemXet    = @('Rà soát dự thảo trước khi ký (đính kèm file)', 'Nêu ý kiến chỉ đạo đối với tờ trình (đính kèm file)')
    NuPhatBieu  = @('Bài phát biểu khai giảng năm học {namhoc} tại trường: (ghi tên trường)', 'Bài phát biểu hội nghị tổng kết năm học giáo dục của xã')
    NuKetLuan   = @('Thông báo kết luận buổi làm việc với trường: (dán ghi chép)')
    NuBaoCao    = @('Báo cáo tình hình giáo dục đầu năm học {namhoc} trên địa bàn', 'Báo cáo theo văn bản yêu cầu (đính kèm văn bản)')
    NuViecThang = @('Lập danh sách việc chỉ đạo giáo dục tháng {thang} và ghi vào Quản lý công việc')
    DvYeuCau    = @('Công văn yêu cầu {donvi} báo cáo: (ghi nội dung, hạn nộp)', 'Đề cương báo cáo sơ kết học kì I gửi {donvi}', 'Biểu mẫu thống kê số liệu đầu năm học {namhoc}')
    DvTheoDoi   = @('Đơn vị nào chưa nộp báo cáo đợt: (ghi tên đợt)', 'Cập nhật sổ theo dõi báo cáo từ các file đã nhận')
    DvDonDoc    = @('Tin nhắn đôn đốc {donvi} chưa nộp báo cáo đợt: (ghi tên đợt)', 'Công văn đôn đốc nộp báo cáo')
    DvTongHop   = @('Tổng hợp báo cáo đợt: (ghi tên đợt) thành báo cáo chung', 'Bảng tổng hợp số liệu các đơn vị đợt: (ghi tên đợt)')
    DvDanhSach  = @('Cập nhật danh sách đơn vị: (dán danh sách hoặc đính kèm file)')
    DvSoLieu    = @('Tổng hợp số liệu {donvi} từ các file trong đợt: (ghi tên đợt)')
    KtKeHoach   = @{ so = @('Kế hoạch kiểm tra chuyên môn giáo dục {caphoc} năm học {namhoc}', 'Kế hoạch kiểm tra đầu năm học tại {donvi}')
                     xa = @('Kế hoạch kiểm tra các trường trên địa bàn năm học {namhoc}', 'Kế hoạch kiểm tra đầu năm học các trường') }
    KtQuyetDinh = @('Quyết định thành lập đoàn kiểm tra: (ghi nội dung, đơn vị)', 'Đề cương báo cáo phục vụ kiểm tra gửi đơn vị', 'Lịch kiểm tra từng đơn vị')
    KtDuGio     = @('Phiếu dự giờ, quan sát hoạt động giáo dục {caphoc}', 'Phiếu kiểm tra hồ sơ chuyên môn của trường')
    KtBienBan   = @('Biên bản kiểm tra tại: (ghi tên đơn vị; dán ghi chép)')
    KtKetLuan   = @('Thông báo kết quả kiểm tra tại: (ghi tên đơn vị; đính kèm biên bản)')
    KtBaoCao    = @('Báo cáo tổng hợp kết quả đợt kiểm tra: (ghi tên đợt)')
    KdKeHoach   = @{ so = @('Kế hoạch bảo đảm chất lượng giáo dục, xây dựng trường chuẩn quốc gia năm học {namhoc}', 'Hướng dẫn tự đánh giá, cải tiến chất lượng năm học {namhoc} theo TT 57/2026')
                     xa = @('Kế hoạch xây dựng trường đạt chuẩn quốc gia giai đoạn: (ghi giai đoạn)', 'Công văn chỉ đạo các trường tự đánh giá, cải tiến chất lượng năm học {namhoc}') }
    KdThamDinh  = @{ so = @('Quyết định thành lập Hội đồng thẩm định chuẩn quốc gia: (ghi trường)', 'Biên bản họp Hội đồng thẩm định (Mẫu số 5): (ghi trường)', 'Thông báo kết quả thẩm định (Mẫu số 4): (ghi trường)')
                     xa = @('Báo cáo cung cấp thông tin, điều kiện thực tế phục vụ thẩm định chuẩn quốc gia: (ghi trường)') }
    KdCongNhan  = @{ so = @('Quyết định công nhận trường đạt chuẩn quốc gia: (ghi trường, mức độ)', 'Báo cáo kết quả công tác bảo đảm chất lượng, chuẩn quốc gia năm học {namhoc} (Mẫu số 7)')
                     xa = @('Báo cáo tình hình các trường đạt chuẩn quốc gia, hạn Bằng công nhận năm học {namhoc}') }
    PcKeHoach   = @{ so = @('Kế hoạch phổ cập giáo dục {caphoc} năm {nam}', 'Hướng dẫn điều tra, cập nhật số liệu phổ cập năm {nam}')
                     xa = @('Kế hoạch phổ cập giáo dục, xóa mù chữ năm {nam} của xã') }
    PcKiemTra   = @{ so = @('Kế hoạch kiểm tra công nhận đạt chuẩn phổ cập năm {nam}', 'Quyết định công nhận đạt chuẩn phổ cập: (ghi xã, phường)')
                     xa = @('Báo cáo tự kiểm tra phổ cập giáo dục năm {nam}', 'Tờ trình đề nghị kiểm tra công nhận đạt chuẩn phổ cập') }
    PcBaoCao    = @('Báo cáo kết quả phổ cập giáo dục, xóa mù chữ năm {nam}', 'Tổng hợp số liệu phổ cập (đính kèm file)')
}
# Ô dùng chung gợi ý với ô khác
# Ô Tham mưu, trình ký (/tham-muu) và Hướng dẫn, triển khai nhiệm vụ (/huong-dan-nhiem-vu) ở Công cụ tiện ích: gợi ý riêng cho lãnh đạo UBND xã
# (ô Trang chủ cùng vị trí của vai trò ubnd là quy trình khác: /cong-van, /phat-bieu - không dùng chung gợi ý)
$GoiYO.TiThamMuu = @{ so = $GoiYO.TcThamMuu.so; vhxh = $GoiYO.TcThamMuu.vhxh
    ubnd = @('Cho ý kiến tờ trình, dự thảo do Phòng Văn hóa - Xã hội trình: ký được hay cần sửa (đính kèm file)', 'Tờ trình của UBND xã trình UBND tỉnh về: (ghi nội dung), kèm dự thảo', 'Báo cáo giải trình, trả lời kiến nghị về giáo dục: (ghi nội dung)') }
$GoiYO.TiHDNV = @{ so = $GoiYO.TcHuongDan.so; vhxh = $GoiYO.TcHuongDan.vhxh
    ubnd = @('Kế hoạch của UBND xã thực hiện nhiệm vụ năm học {namhoc} theo hướng dẫn của Sở (đính kèm văn bản của Sở)', 'Công văn của UBND xã chỉ đạo các trường triển khai nhiệm vụ năm học {namhoc}', 'Công văn chỉ đạo các trường thực hiện chuyên đề: (ghi tên chuyên đề)') }
$GoiYO.NsHuongDan = $GoiYO.TcHuongDan.so; $GoiYO.NsThamMuu = $GoiYO.TcThamMuu.so; $GoiYO.NsBoiDuong = $GoiYO.TiBoiDuong; $GoiYO.NsHoiThi = $GoiYO.TiHoiThi.so
$GoiYO.NsGopY = $GoiYO.TiGopY; $GoiYO.NsTuyenSinh = $GoiYO.TiTuyenSinh.so; $GoiYO.NsToChuc = $GoiYO.TiToChuc.so; $GoiYO.NsPhatBieu = $GoiYO.TiPhatBieu
$GoiYO.NxHuongDan = $GoiYO.TcHuongDan.vhxh; $GoiYO.NxTuyenSinh = $GoiYO.TiTuyenSinh.xa; $GoiYO.NxToChuc = $GoiYO.TiToChuc.xa; $GoiYO.NxHoiThi = $GoiYO.TiHoiThi.xa
$GoiYO.NxThamMuu = $GoiYO.TcThamMuu.vhxh; $GoiYO.NxGopY = $GoiYO.TiGopY; $GoiYO.NxPhatBieu = $GoiYO.TiPhatBieu
$GoiYO.NuToChuc = $GoiYO.TiToChuc.xa; $GoiYO.NuTuyenSinh = $GoiYO.TiTuyenSinh.xa; $GoiYO.NuPhoCap = $GoiYO.NxPhoCap
# Thẩm định, căn cứ pháp lý, văn hóa - y tế (bản 1.1.0)
$GoiYO.TiThamDinh = @('Thẩm định hồ sơ trước khi ký (đính kèm tờ trình, dự thảo)', 'Kiểm tra thẩm quyền: việc (ghi việc) do ai quyết định?', 'Các căn cứ trong văn bản này còn hiệu lực không? (đính kèm file)')
$GoiYO.TiCapNhatCC = @('Cập nhật văn bản mới về giáo dục {caphoc} từ lần rà soát trước', 'Cập nhật văn bản mới về văn hóa, y tế cấp xã', 'Văn bản (ghi số hiệu) còn hiệu lực không?')
$GoiYO.NsThamDinh = @('Thẩm định dự thảo trước khi trình lãnh đạo Sở (đính kèm file)', 'Rà thẩm quyền, căn cứ của dự thảo quyết định UBND tỉnh (đính kèm file)')
$GoiYO.NsTraCuu = @('Quy định về (ghi nội dung) đối với giáo dục {caphoc}?', 'Thẩm quyền của Sở và UBND xã về (ghi việc) sau khi bỏ cấp huyện?')
$GoiYO.NsCapNhat = @('Cập nhật văn bản mới về giáo dục {caphoc}', 'Văn bản (ghi số hiệu) còn hiệu lực không?')
$GoiYO.NxThamDinh = @('Thẩm định tờ trình, dự thảo trước khi trình UBND xã (đính kèm file)', 'Thẩm định hồ sơ đề nghị của trường: (ghi việc; đính kèm hồ sơ)', 'Thẩm định hồ sơ lễ hội, sự kiện văn hóa: (đính kèm hồ sơ)')
$GoiYO.NxVanHoa = @('Tổ chức lễ hội (ghi tên) cần thủ tục gì, ai cho phép?', 'Công nhận danh hiệu gia đình văn hóa, thôn văn hóa theo quy định nào?', 'Kế hoạch tổ chức đại hội thể dục thể thao cấp xã', 'Quy định về thông tin cơ sở, đài truyền thanh xã')
$GoiYO.NxYTe = @('Kiểm tra an toàn thực phẩm bếp ăn bán trú các trường theo quy định nào?', 'Kế hoạch tiêm chủng, phòng chống dịch trên địa bàn', 'Quy định về y tế trường học, khám sức khỏe học sinh', 'Thẩm quyền cấp xã về an toàn thực phẩm sau khi bỏ cấp huyện?')
$GoiYO.NuThamDinh = @('Thẩm định tờ trình, dự thảo trước khi ký (đính kèm file)', 'Văn bản này tôi có thẩm quyền ký không? (đính kèm file)', 'Hồ sơ đề nghị (ghi việc) đã đủ điều kiện phê duyệt chưa? (đính kèm hồ sơ)')
$GoiYO.NuVanHoa = @('Quy định, thẩm quyền về tổ chức lễ hội trên địa bàn xã', 'Công văn chỉ đạo thực hiện nếp sống văn minh trong việc cưới, việc tang', 'Kế hoạch phong trào Toàn dân đoàn kết xây dựng đời sống văn hóa năm {nam}')
$GoiYO.NuYTe = @('Công văn chỉ đạo bảo đảm an toàn thực phẩm bếp ăn trường học', 'Kế hoạch phòng chống dịch bệnh mùa (ghi mùa) năm {nam}', 'Quy định, thẩm quyền cấp xã về an toàn thực phẩm, y tế cơ sở')
# Gợi ý ở trang Trò chuyện AI - xếp theo thứ tự: việc nhẹ, làm được ngay khi máy mới cài ->
# việc cần có sẵn văn bản, số liệu. Không để việc nặng (slide, bảng tính) lên đầu: chạy lâu,
# tốn lượt dùng, mà lúc đầu chưa có văn bản, số liệu nào để lấy.
$GoiYChat = @{
    so   = @('Thẩm quyền công nhận trường đạt chuẩn quốc gia hiện nay thế nào?', 'Lập kế hoạch kiểm tra chuyên môn đầu năm học',
             'Soạn công văn hướng dẫn kiểm tra định kỳ cuối học kì I gửi UBND các xã, phường',
             'Tờ trình UBND tỉnh ban hành kế hoạch phổ cập giáo dục mầm non',
             'Tóm tắt văn bản mới nhất của Bộ trong thư mục văn bản đến', 'Xã, phường nào chưa nộp báo cáo đầu năm học?',
             'Lập biểu mẫu Excel số liệu gửi các xã, phường', 'Làm slide báo cáo triển khai nhiệm vụ năm học')
    vhxh = @('Phòng Văn hóa - Xã hội có nhiệm vụ gì về giáo dục?', 'Soạn kế hoạch tuyển sinh năm học tới trên địa bàn',
             'Công văn đề nghị các trường báo cáo số liệu đầu năm học',
             'Tờ trình UBND xã phê duyệt kế hoạch hội thi giáo viên dạy giỏi cấp xã',
             'Tóm tắt văn bản mới nhất của Sở trong thư mục văn bản đến', 'Trường nào chưa nộp báo cáo đầu năm học?')
    ubnd = @('UBND xã có thẩm quyền gì với trường mầm non, tiểu học?', 'Lập việc chỉ đạo giáo dục tháng này',
             'Soạn bài phát biểu khai giảng năm học mới', 'Thông báo kết luận buổi làm việc với các trường',
             'Rà soát tờ trình Phòng Văn hóa - Xã hội vừa gửi', 'Tóm tắt văn bản mới nhất của UBND tỉnh về giáo dục')
}

# ============================================================================
# 2. Giao diện XAML
# ============================================================================
$xamlText = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Trợ lý QLNN về Giáo dục" Width="1360" Height="860" MinWidth="1000" MinHeight="640"
        WindowStartupLocation="CenterScreen" Background="#F4F7FC" FontFamily="Segoe UI"
        UseLayoutRounding="True" SnapsToDevicePixels="True" TextOptions.TextFormattingMode="Display">
  <Window.Resources>
    <Style x:Key="Nav" TargetType="RadioButton">
      <Setter Property="GroupName" Value="nav"/>
      <Setter Property="Foreground" Value="#E8EEFB"/>
      <Setter Property="FontSize" Value="15"/>
      <Setter Property="Margin" Value="0,2"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="RadioButton">
            <Border x:Name="Bd" Background="Transparent" CornerRadius="10" Padding="16,10">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="{TemplateBinding Tag}" FontFamily="Segoe MDL2 Assets" FontSize="18" Width="30" VerticalAlignment="Center" Foreground="{TemplateBinding Foreground}"/>
                <ContentPresenter VerticalAlignment="Center" Margin="10,0,0,0"/>
              </StackPanel>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="Background" Value="#26FFFFFF"/></Trigger>
              <Trigger Property="IsChecked" Value="True"><Setter TargetName="Bd" Property="Background" Value="White"/><Setter Property="Foreground" Value="#0B5F6B"/><Setter Property="FontWeight" Value="SemiBold"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Nut" TargetType="Button">
      <Setter Property="Foreground" Value="#1F3354"/>
      <Setter Property="Background" Value="White"/>
      <Setter Property="BorderBrush" Value="#D6E0EE"/>
      <Setter Property="FontSize" Value="13.5"/>
      <Setter Property="Padding" Value="16,9"/>
      <Setter Property="Margin" Value="0,0,10,0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#2F6FE0"/><Setter TargetName="Bd" Property="Background" Value="#F2F7FF"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter TargetName="Bd" Property="Opacity" Value="0.5"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="NutChinh" TargetType="Button">
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="FontSize" Value="13.5"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Padding" Value="18,9"/>
      <Setter Property="Margin" Value="0,0,10,0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="#2F6FE0" CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="Background" Value="#245BC2"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="NutXanhLa" TargetType="Button">
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="FontSize" Value="14.5"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="#6BB33A" CornerRadius="12" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="Background" Value="#599A2E"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Lien" TargetType="Button">
      <Setter Property="Foreground" Value="#2F6FE0"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Background="Transparent" Padding="4,2"><ContentPresenter/></Border>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Bong" TargetType="Border">
      <Setter Property="Background" Value="White"/>
      <Setter Property="CornerRadius" Value="16"/>
      <Setter Property="Effect"><Setter.Value><DropShadowEffect BlurRadius="18" ShadowDepth="2" Direction="270" Opacity="0.08" Color="#1B3A6B"/></Setter.Value></Setter>
    </Style>
    <Style x:Key="The" TargetType="Border">
      <Setter Property="Background" Value="White"/>
      <Setter Property="CornerRadius" Value="16"/>
      <Setter Property="BorderBrush" Value="#E6ECF5"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="20,16"/>
    </Style>
    <Style x:Key="OChucNang" TargetType="Border">
      <Setter Property="CornerRadius" Value="14"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="BorderBrush" Value="#E9EEF6"/>
      <Setter Property="Padding" Value="12,10"/>
      <Setter Property="Margin" Value="5"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Style.Triggers>
        <Trigger Property="IsMouseOver" Value="True"><Setter Property="BorderBrush" Value="#8FB3F2"/></Trigger>
      </Style.Triggers>
    </Style>
    <Style x:Key="TabTrang" TargetType="Button">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent" BorderThickness="0,0,0,3" BorderBrush="Transparent" Padding="0,0,0,3">
              <ContentPresenter TextElement.FontSize="22" TextElement.FontWeight="Bold" TextElement.Foreground="#9AA8BA"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#CFDDF6"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="TieuDeTrang" TargetType="TextBlock">
      <Setter Property="FontSize" Value="22"/>
      <Setter Property="FontWeight" Value="Bold"/>
      <Setter Property="Foreground" Value="#0B2B6B"/>
    </Style>
    <Style x:Key="MoTaTrang" TargetType="TextBlock">
      <Setter Property="FontSize" Value="13.5"/>
      <Setter Property="Foreground" Value="#5B6B7F"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
      <Setter Property="Margin" Value="0,4,0,14"/>
    </Style>
    <Style x:Key="Nhap" TargetType="TextBox">
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Foreground" Value="#1F3354"/>
      <Setter Property="VerticalContentAlignment" Value="Center"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="TextBox">
            <Border x:Name="Bd" Background="White" BorderBrush="#D6E0EE" BorderThickness="1" CornerRadius="10" Padding="12,6">
              <ScrollViewer x:Name="PART_ContentHost" VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#2F6FE0"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="GoiY" TargetType="TextBlock">
      <Setter Property="IsHitTestVisible" Value="False"/>
      <Setter Property="Foreground" Value="#8A98AB"/>
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Margin" Value="14,0,0,0"/>
      <Setter Property="VerticalAlignment" Value="Center"/>
    </Style>
    <Style TargetType="ListView">
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="FontSize" Value="13.5"/>
      <Setter Property="Foreground" Value="#1F3354"/>
    </Style>
    <Style TargetType="ListViewItem">
      <Setter Property="Padding" Value="4,7"/>
      <Setter Property="Cursor" Value="Hand"/>
    </Style>
    <Style TargetType="GridViewColumnHeader">
      <Setter Property="HorizontalContentAlignment" Value="Left"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Foreground" Value="#40546B"/>
      <Setter Property="Padding" Value="8,8"/>
      <Setter Property="Background" Value="#F3F6FB"/>
      <Setter Property="BorderThickness" Value="0"/>
    </Style>
    <Style x:Key="Chon" TargetType="ComboBox">
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Foreground" Value="#1F3354"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ComboBox">
            <Grid>
              <ToggleButton Focusable="False" ClickMode="Press" IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}">
                <ToggleButton.Template>
                  <ControlTemplate TargetType="ToggleButton">
                    <Border x:Name="Bd" Background="White" BorderBrush="#D6E0EE" BorderThickness="1" CornerRadius="10">
                      <TextBlock Text="&#xE70D;" FontFamily="Segoe MDL2 Assets" FontSize="11" Foreground="#5B6B7F" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,12,0"/>
                    </Border>
                    <ControlTemplate.Triggers>
                      <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#2F6FE0"/></Trigger>
                      <Trigger Property="IsChecked" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#2F6FE0"/></Trigger>
                    </ControlTemplate.Triggers>
                  </ControlTemplate>
                </ToggleButton.Template>
              </ToggleButton>
              <ContentPresenter IsHitTestVisible="False" Margin="12,0,30,0" HorizontalAlignment="Left" VerticalAlignment="Center"
                                Content="{TemplateBinding SelectionBoxItem}" ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"/>
              <Popup x:Name="PART_Popup" IsOpen="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}" Placement="Bottom" AllowsTransparency="True" Focusable="False" PopupAnimation="Slide">
                <Border Background="White" BorderBrush="#D6E0EE" BorderThickness="1" CornerRadius="10" Margin="0,4,0,0" Padding="4"
                        MinWidth="{Binding ActualWidth, RelativeSource={RelativeSource TemplatedParent}}">
                  <ScrollViewer MaxHeight="280" VerticalScrollBarVisibility="Auto"><ItemsPresenter KeyboardNavigation.DirectionalNavigation="Contained"/></ScrollViewer>
                </Border>
              </Popup>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="ComboBoxItem">
      <Setter Property="Padding" Value="10,7"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ComboBoxItem">
            <Border x:Name="Bd" Background="Transparent" CornerRadius="7" Padding="{TemplateBinding Padding}">
              <ContentPresenter/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsHighlighted" Value="True"><Setter TargetName="Bd" Property="Background" Value="#EEF4FF"/></Trigger>
              <Trigger Property="IsSelected" Value="True"><Setter TargetName="Bd" Property="Background" Value="#E3ECFB"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Grid Background="#F4F7FC">
    <Grid.ColumnDefinitions>
      <ColumnDefinition x:Name="CotBen" Width="240"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>

    <!-- ===================== THANH BÊN TRÁI ===================== -->
    <Border x:Name="ThanhBen" Grid.Column="0">
      <Border.Background>
        <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
          <GradientStop Color="#0B5F6B" Offset="0"/>
          <GradientStop Color="#08505B" Offset="0.55"/>
          <GradientStop Color="#053840" Offset="1"/>
        </LinearGradientBrush>
      </Border.Background>
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <!-- Họa tiết chấm trắng trên nền xanh lục lam -->
        <Rectangle Grid.RowSpan="3" IsHitTestVisible="False">
          <Rectangle.Fill>
            <DrawingBrush TileMode="Tile" Viewport="0,0,18,18" ViewportUnits="Absolute" Viewbox="0,0,18,18" ViewboxUnits="Absolute" Opacity="0.13">
              <DrawingBrush.Drawing>
                <GeometryDrawing Brush="White">
                  <GeometryDrawing.Geometry>
                    <GeometryGroup>
                      <EllipseGeometry Center="4.5,4.5" RadiusX="1.25" RadiusY="1.25"/>
                      <EllipseGeometry Center="13.5,13.5" RadiusX="1.25" RadiusY="1.25"/>
                    </GeometryGroup>
                  </GeometryDrawing.Geometry>
                </GeometryDrawing>
              </DrawingBrush.Drawing>
            </DrawingBrush>
          </Rectangle.Fill>
        </Rectangle>
        <StackPanel Orientation="Horizontal" Margin="16,22,6,18">
          <!-- Logo: quyển sách mở màu xanh (app\logo.png, nạp trong mã) trên ô trắng bo góc -->
          <Border Width="54" Height="54" CornerRadius="14" Background="White" VerticalAlignment="Center">
            <Border.Effect><DropShadowEffect BlurRadius="10" ShadowDepth="2" Opacity="0.28" Color="#000814"/></Border.Effect>
            <Image x:Name="ImgLogo" Width="44" Height="44" RenderOptions.BitmapScalingMode="HighQuality"/>
          </Border>
          <StackPanel Margin="12,0,0,0" VerticalAlignment="Center">
            <TextBlock Text="TRỢ LÝ" FontSize="23" FontWeight="Bold" Foreground="White"/>
            <TextBlock Text="QLNN VỀ GIÁO DỤC" FontSize="12" FontWeight="Bold" Foreground="White" Margin="0,-1,0,0"/>
            <TextBlock Text="Đồng hành cùng cán bộ quản lý" FontSize="10" Foreground="#B9C9EA" Margin="0,4,0,0"/>
          </StackPanel>
        </StackPanel>
        <ScrollViewer x:Name="CuonMenu" Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
          <StackPanel x:Name="DsMenu" Margin="14,0,14,8">
            <RadioButton x:Name="NavTrangChu"   Style="{StaticResource Nav}" Tag="&#xE80F;" Content="Trang chủ" IsChecked="True"/>
            <RadioButton x:Name="NavNhiemVu"    Style="{StaticResource Nav}" Tag="&#xE7C1;" Content="Nhiệm vụ"/>
            <RadioButton x:Name="NavTroChuyen"  Style="{StaticResource Nav}" Tag="&#xE8BD;" Content="Trò chuyện AI"/>
            <RadioButton x:Name="NavSoanVanBan" Style="{StaticResource Nav}" Tag="&#xE8A5;" Content="Soạn văn bản"/>
            <RadioButton x:Name="NavDonVi"      Style="{StaticResource Nav}" Tag="&#xE716;" Content="Đơn vị, báo cáo"/>
            <RadioButton x:Name="NavKiemTra"    Style="{StaticResource Nav}" Tag="&#xE73E;" Content="Kiểm tra"/>
            <RadioButton x:Name="NavCongViec"   Style="{StaticResource Nav}" Tag="&#xE787;" Content="Công việc và lịch"/>
            <RadioButton x:Name="NavThuVien"    Style="{StaticResource Nav}" Tag="&#xED25;" Content="Thư viện văn bản"/>
            <RadioButton x:Name="NavTienIch"    Style="{StaticResource Nav}" Tag="&#xE90F;" Content="Công cụ tiện ích"/>
            <RadioButton x:Name="NavCaiDat"     Style="{StaticResource Nav}" Tag="&#xE713;" Content="Cài đặt"/>
          </StackPanel>
        </ScrollViewer>
        <Grid x:Name="TranhBen" Grid.Row="2" Height="170" ClipToBounds="True">
          <Canvas>
            <Path Data="M18,150 C40,138 70,136 104,146 L104,166 C70,156 40,158 18,168 Z" Fill="White" Stroke="#B9C7DA" StrokeThickness="1.2"/>
            <Path Data="M104,146 C138,136 168,138 190,150 L190,168 C168,158 138,156 104,166 Z" Fill="#FBFCFE" Stroke="#B9C7DA" StrokeThickness="1.2"/>
            <Path Data="M30,152 C50,146 76,145 98,150 M110,150 C132,145 158,146 178,152" Stroke="#D5DEEA" StrokeThickness="1"/>
            <Path Data="M200,160 C196,120 206,92 226,62" Stroke="#6BAA5C" StrokeThickness="2.2"/>
            <Path Data="M214,78 C200,72 196,60 200,50 C212,56 218,66 214,78 Z" Fill="#7CC36A"/>
            <Path Data="M222,70 C236,62 246,64 250,72 C240,80 230,80 222,70 Z" Fill="#5FAE52"/>
            <Path Data="M206,106 C190,102 184,90 186,80 C200,86 208,96 206,106 Z" Fill="#8ACF74"/>
            <Path Data="M210,98 C224,88 236,88 242,96 C232,106 220,106 210,98 Z" Fill="#6DB85D"/>
            <Path Data="M201,134 C186,132 178,122 178,112 C192,116 200,124 201,134 Z" Fill="#7CC36A"/>
            <Path Data="M204,126 C218,118 230,118 236,126 C226,134 214,134 204,126 Z" Fill="#5FAE52"/>
          </Canvas>
          <TextBlock Text="Vì trẻ em" FontFamily="Segoe Script" FontSize="20" Foreground="White" Margin="36,26,0,0" RenderTransformOrigin="0,0">
            <TextBlock.RenderTransform><RotateTransform Angle="-8"/></TextBlock.RenderTransform>
          </TextBlock>
          <TextBlock Text="thân yêu!" FontFamily="Segoe Script" FontSize="20" Foreground="White" Margin="64,58,0,0" RenderTransformOrigin="0,0">
            <TextBlock.RenderTransform><RotateTransform Angle="-8"/></TextBlock.RenderTransform>
          </TextBlock>
        </Grid>
      </Grid>
    </Border>

    <!-- ===================== PHẦN CHÍNH ===================== -->
    <Grid Grid.Column="1">
      <Grid.RowDefinitions>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>

      <!-- Đầu trang -->
      <Grid x:Name="DauTrang" Margin="30,22,30,14">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel VerticalAlignment="Center">
          <TextBlock Text="Trợ lý QLNN về Giáo dục" FontSize="26" FontWeight="Bold" Foreground="#0B2B6B" TextTrimming="CharacterEllipsis"/>
          <TextBlock x:Name="TxtPhuDe" Text="Soạn thảo nhanh – Đúng quy định – Hiệu quả mỗi ngày" FontSize="14" Foreground="#4A5A70" Margin="0,4,0,0" TextTrimming="CharacterEllipsis"/>
        </StackPanel>
        <Grid Grid.Column="1" MaxWidth="440" MinWidth="220" Height="44" Margin="24,0,24,0" VerticalAlignment="Center">
          <TextBox x:Name="TxtTimNhanh" Style="{StaticResource Nhap}" Padding="30,0,0,0"/>
          <TextBlock Text="&#xE721;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#5B6B7F" VerticalAlignment="Center" Margin="16,0,0,0" IsHitTestVisible="False"/>
          <TextBlock x:Name="GoiYTimNhanh" Style="{StaticResource GoiY}" Margin="44,0,0,0" FontSize="13" Text="Nhập nội dung cần hỗ trợ (ví dụ: soạn kế hoạch tháng {thang}...)"/>
        </Grid>
        <Border x:Name="KhungNguoiDung" Grid.Column="2" Background="Transparent" Cursor="Hand" VerticalAlignment="Center">
          <StackPanel Orientation="Horizontal">
            <Border Width="46" Height="46" CornerRadius="23" Background="#1E5FD8">
              <TextBlock x:Name="TxtVietTat" Text="TL" FontSize="17" FontWeight="SemiBold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <StackPanel Margin="12,0,10,0" VerticalAlignment="Center" MaxWidth="190">
              <TextBlock x:Name="TxtTenNguoiDung" Text="Anh/chị" FontSize="15" FontWeight="SemiBold" Foreground="#0B2B6B" TextTrimming="CharacterEllipsis"/>
              <TextBlock x:Name="TxtChucVu" Text="Chuyên viên" FontSize="12.5" Foreground="#5B6B7F" TextTrimming="CharacterEllipsis"/>
            </StackPanel>
            <TextBlock Text="&#xE70D;" FontFamily="Segoe MDL2 Assets" FontSize="12" Foreground="#40546B" VerticalAlignment="Center"/>
          </StackPanel>
          <Border.ContextMenu>
            <ContextMenu>
              <MenuItem x:Name="MnKhaiBao" Header="Khai báo thông tin cơ quan"/>
              <MenuItem x:Name="MnThongTin" Header="Thông tin cơ quan và bộ nhớ"/>
              <MenuItem x:Name="MnDangNhap" Header="Cấu hình OpenRouter"/>
              <MenuItem x:Name="MnCaiDat" Header="Cài đặt"/>
            </ContextMenu>
          </Border.ContextMenu>
        </Border>
      </Grid>

      <!-- Các trang -->
      <Grid x:Name="VungTrang" Grid.Row="1" Margin="30,0,30,14">

        <!-- ========== TRANG CHỦ ========== -->
        <Grid x:Name="PgTrangChu">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="7*"/>
            <ColumnDefinition Width="18"/>
            <ColumnDefinition Width="3*" MinWidth="300" MaxWidth="400"/>
          </Grid.ColumnDefinitions>
          <Grid Grid.Column="0">
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="16"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid>
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="24,16" MinHeight="102">
                <Grid>
                  <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                  </Grid.ColumnDefinitions>
                  <Canvas Width="50" Height="50" VerticalAlignment="Center">
                    <Path Data="M25,2 L25,9 M25,41 L25,48 M2,25 L9,25 M41,25 L48,25 M8.7,8.7 L13.6,13.6 M36.4,36.4 L41.3,41.3 M8.7,41.3 L13.6,36.4 M36.4,13.6 L41.3,8.7" Stroke="#FFA000" StrokeThickness="3" StrokeStartLineCap="Round" StrokeEndLineCap="Round"/>
                    <Ellipse Canvas.Left="13" Canvas.Top="13" Width="24" Height="24">
                      <Ellipse.Fill><RadialGradientBrush><GradientStop Color="#FFD54F" Offset="0"/><GradientStop Color="#FFA000" Offset="1"/></RadialGradientBrush></Ellipse.Fill>
                    </Ellipse>
                  </Canvas>
                  <StackPanel Grid.Column="1" Margin="18,0,12,0" VerticalAlignment="Center">
                    <TextBlock x:Name="TxtChao" Text="Chào buổi sáng!" FontSize="19" FontWeight="Bold" Foreground="#0B2B6B" TextWrapping="Wrap"/>
                    <TextBlock x:Name="TxtCauNoi" Text="“Kế hoạch rõ ràng – Hành động kịp thời – Kết quả bền vững”" FontSize="14" FontStyle="Italic" Foreground="#34465F" Margin="0,6,0,0" TextWrapping="Wrap"/>
                    <StackPanel x:Name="KhungNhacKhaiBao" Orientation="Horizontal" Margin="0,8,0,0" Visibility="Collapsed">
                      <Button x:Name="BtnKhaiBaoNhanh" Style="{StaticResource NutChinh}" Padding="16,7">
                        <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE77B;" FontFamily="Segoe MDL2 Assets" FontSize="14" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Khai báo thông tin cơ quan" VerticalAlignment="Center"/></StackPanel>
                      </Button>
                    </StackPanel>
                  </StackPanel>
                  <Rectangle Grid.Column="2" Width="1" Fill="#E3EAF5" Margin="6,6"/>
                  <StackPanel Grid.Column="3" Orientation="Horizontal" Margin="18,0,4,0" VerticalAlignment="Center">
                    <TextBlock Text="&#xE787;" FontFamily="Segoe MDL2 Assets" FontSize="26" Foreground="#2F6FE0" VerticalAlignment="Center"/>
                    <StackPanel Margin="12,0,0,0">
                      <TextBlock x:Name="TxtNgay" Text="" FontSize="15" Foreground="#1F3354"/>
                      <TextBlock x:Name="TxtNamHoc" Text="" FontSize="13" Foreground="#5B6B7F" Margin="0,5,0,0"/>
                      <Button x:Name="BtnVanBanMoi" Style="{StaticResource Lien}" Margin="-4,3,0,0" HorizontalAlignment="Left" Visibility="Collapsed"><TextBlock x:Name="TxtVanBanMoi" Text="Kiểm tra văn bản mới" FontSize="13"/></Button>
                    </StackPanel>
                  </StackPanel>
                </Grid>
              </Border>
            </Grid>
            <Grid Grid.Row="2">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="16,14">
                <Grid>
                  <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                  </Grid.RowDefinitions>
                  <TextBlock Text="Chức năng chính" FontSize="19" FontWeight="Bold" Foreground="#0B2B6B" Margin="8,2,0,8"/>
                  <UniformGrid Grid.Row="1" Columns="3" Rows="3">
@@THECHINH@@
                  </UniformGrid>
                </Grid>
              </Border>
            </Grid>
          </Grid>
          <Grid Grid.Column="2">
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="16"/>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="16"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Border x:Name="Banner" Height="102" CornerRadius="14">
              <Grid x:Name="BannerNoiDung" ClipToBounds="True">
                <Grid.Background>
                  <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                    <GradientStop Color="#BFE3FF" Offset="0"/>
                    <GradientStop Color="#EAF6FF" Offset="0.75"/>
                    <GradientStop Color="#D7EFC8" Offset="1"/>
                  </LinearGradientBrush>
                </Grid.Background>
                <Canvas x:Name="TranhTruong">
                  <Ellipse Canvas.Left="104" Canvas.Top="4" Width="20" Height="20" Fill="#FFE082" Opacity="0.9"/>
                  <Path Data="M8,72 C40,60 90,62 140,70 C200,58 280,60 400,70 L400,110 L0,110 Z" Fill="#9CCB78"/>
                  <Ellipse Canvas.Left="-6" Canvas.Top="48" Width="26" Height="36" Fill="#5FA84B"/>
                  <Ellipse Canvas.Left="8" Canvas.Top="54" Width="22" Height="32" Fill="#72B85C"/>
                  <Path Data="M22,48 L64,32 L106,48 Z" Fill="#C0392B"/>
                  <Path Data="M27,48 L101,48 L101,80 L27,80 Z" Fill="#FFF3DA" Stroke="#E4C9A0" StrokeThickness="1"/>
                  <Path Data="M32,54 L39,54 L39,60 L32,60 Z M44,54 L51,54 L51,60 L44,60 Z M77,54 L84,54 L84,60 L77,60 Z M89,54 L96,54 L96,60 L89,60 Z M32,66 L39,66 L39,72 L32,72 Z M44,66 L51,66 L51,72 L44,72 Z M77,66 L84,66 L84,72 L77,72 Z M89,66 L96,66 L96,72 L89,72 Z" Fill="#6FA8DC"/>
                  <Path Data="M57,80 L57,62 L71,62 L71,80 Z" Fill="#B5651D"/>
                  <Path Data="M64,32 L64,14" Stroke="#6D4C41" StrokeThickness="1.4"/>
                  <Path Data="M64,14 L75,17 L64,20 Z" Fill="#E53935"/>
                  <Ellipse Canvas.Left="104" Canvas.Top="50" Width="22" Height="32" Fill="#5FA84B"/>
                </Canvas>
                <StackPanel HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,10,10,0" RenderTransformOrigin="0.5,0.5">
                  <StackPanel.RenderTransform><RotateTransform Angle="-5"/></StackPanel.RenderTransform>
                  <TextBlock Text="Chung sức vì giáo dục" FontFamily="Segoe Script" FontSize="13" FontWeight="Bold" Foreground="#14418C" HorizontalAlignment="Right"/>
                  <TextBlock Text="Vì trẻ em thân yêu!" FontFamily="Segoe Script" FontSize="13" FontWeight="Bold" Foreground="#14418C" HorizontalAlignment="Right" Margin="0,2,0,0"/>
                </StackPanel>
              </Grid>
            </Border>
            <Grid Grid.Row="2">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="18,14">
                <StackPanel>
                  <Grid Margin="0,0,0,6">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="&#xE787;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#2F6FE0" VerticalAlignment="Center"/>
                    <TextBlock Grid.Column="1" Text="Công việc hôm nay" FontSize="14.5" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,0,6,0" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
                    <Button x:Name="BtnXemViec" Grid.Column="2" Style="{StaticResource Lien}" VerticalAlignment="Center" Content="Xem tất cả  →"/>
                  </Grid>
                  <StackPanel x:Name="DsViecHomNay"/>
                </StackPanel>
              </Border>
            </Grid>
            <Grid Grid.Row="4">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="18,14">
                <Grid>
                  <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                  </Grid.RowDefinitions>
                  <Grid Margin="0,0,0,4">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="&#xE8A5;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#2F6FE0" VerticalAlignment="Center"/>
                    <TextBlock Grid.Column="1" Text="Văn bản gần đây" FontSize="14.5" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,0,6,0" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
                    <Button x:Name="BtnXemVanBan" Grid.Column="2" Style="{StaticResource Lien}" VerticalAlignment="Center" Content="Xem tất cả  →"/>
                  </Grid>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                    <StackPanel x:Name="DsGanDay"/>
                  </ScrollViewer>
                  <Border Grid.Row="2" Background="#EAF6EE" CornerRadius="12" Padding="14,10" Margin="0,10,0,0">
                    <Grid>
                      <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                      <Path Data="M4,26 C4,12 14,3 30,2 C30,18 20,28 6,28 Z M6,28 C12,20 18,14 24,9" Fill="#43A047" Stroke="#2E7D32" StrokeThickness="1" Width="30" Height="30" Stretch="Uniform" VerticalAlignment="Center"/>
                      <StackPanel Grid.Column="1" Margin="10,0,0,0" HorizontalAlignment="Stretch">
                        <TextBlock Text="Kỷ cương – Trách nhiệm – Sáng tạo" FontSize="13" FontStyle="Italic" Foreground="#2E7D32" TextAlignment="Center" TextWrapping="Wrap"/>
                        <TextBlock Text="Vì một môi trường giáo dục hạnh phúc!" FontSize="13" FontStyle="Italic" Foreground="#2E7D32" TextAlignment="Center" TextWrapping="Wrap" Margin="0,2,0,0"/>
                      </StackPanel>
                    </Grid>
                  </Border>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== SOẠN VĂN BẢN ========== -->
        <ScrollViewer x:Name="PgSoanVanBan" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Soạn văn bản" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border><Button x:Name="TabTrang1" Style="{StaticResource TabTrang}" Tag="trang:Mau" Content="Mẫu văn bản" Margin="0,0,22,0" ToolTip="Chuyển sang Mẫu văn bản"/></StackPanel>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Ghi việc cần soạn rồi bấm Giao việc (hoặc nhấn Enter), hoặc ghi vài ý chính rồi bấm loại văn bản bên dưới. Trợ lý tự lấy thông tin trong bộ nhớ, soạn đúng thể thức Nghị định 30/2020 và mở file Word."/>
            <Grid Height="84" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinh" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinh" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ví dụ: công văn hướng dẫn các đơn vị tổ chức kiểm tra định kỳ cuối học kì I, báo cáo kết quả trước 20/01 (Enter để gửi, Shift+Enter xuống dòng)"/>
              <Button x:Name="BtnGiaoViecSoan" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <UniformGrid Columns="4">
@@LOAIVB@@
            </UniformGrid>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel>
                    <TextBlock Text="Rà soát văn bản có sẵn" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B"/>
                    <TextBlock Text="Chọn file Word/PDF (dự thảo của phòng, văn bản các đơn vị gửi lên, văn bản cũ) để kiểm tra thể thức, căn cứ, số liệu, chính tả và tạo bản đã sửa." FontSize="13" Foreground="#5B6B7F" TextWrapping="Wrap" Margin="0,4,0,0"/>
                  </StackPanel>
                  <Button x:Name="BtnRaSoatFile" Grid.Column="1" Style="{StaticResource NutChinh}" Content="Chọn file để rà soát" VerticalAlignment="Center" Margin="16,0,0,0"/>
                </Grid>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== MẪU VĂN BẢN ========== -->
        <Grid x:Name="PgMau" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang2" Style="{StaticResource TabTrang}" Tag="trang:SoanVanBan" Content="Soạn văn bản" Margin="0,0,22,0" ToolTip="Chuyển sang Soạn văn bản"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Mẫu văn bản" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Các mẫu trình bày theo Phụ lục III Nghị định 30/2020/NĐ-CP. Muốn dùng mẫu riêng của cơ quan: chép file vào thư mục mẫu riêng (07_MAU_RIENG), phần mềm sẽ ưu tiên mẫu đó và không bị ghi đè khi cập nhật. Cơ quan có cách làm riêng một việc: nói với trợ lý &quot;ghi lại thành quy trình riêng&quot;, hoặc tự đặt tệp .md vào thư mục quy trình riêng."/>
          <Grid Grid.Row="2">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvMau">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Mẫu" Width="300" DisplayMemberBinding="{Binding Ten}"/>
                    <GridViewColumn Header="Căn cứ trình bày" Width="260" DisplayMemberBinding="{Binding CanCu}"/>
                    <GridViewColumn Header="Nguồn" Width="120" DisplayMemberBinding="{Binding Nguon}"/>
                    <GridViewColumn Header="File" Width="240" DisplayMemberBinding="{Binding File}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="3" Margin="0,14,0,0">
            <Button x:Name="BtnXemMau" Style="{StaticResource NutChinh}" Content="Xem mẫu dạng Word"/>
            <Button x:Name="BtnSoanTheoMau" Style="{StaticResource Nut}" Content="Soạn theo mẫu này"/>
            <Button x:Name="BtnHuongDanTheThuc" Style="{StaticResource Nut}" Content="Hướng dẫn thể thức NĐ 30"/>
            <Button x:Name="BtnMauRieng" Style="{StaticResource Nut}" Content="Mở thư mục mẫu riêng"/>
            <Button x:Name="BtnQuyTrinhRieng" Style="{StaticResource Nut}" Content="Quy trình riêng của cơ quan" ToolTip="Mở thư mục chứa các quy trình riêng - mỗi tệp .md là một lệnh của trợ lý"/>
          </WrapPanel>
        </Grid>

        <!-- ========== TRÒ CHUYỆN (khung chat - trợ lý chạy ẩn, xem app\tro-chuyen.ps1) ========== -->
        <Grid x:Name="PgTroChuyen" Visibility="Collapsed" AllowDrop="True" Background="Transparent">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
          </Grid.RowDefinitions>
          <Grid x:Name="DauChat" Margin="0,0,0,10">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <StackPanel x:Name="TieuDeChat">
              <TextBlock Text="Trò chuyện với trợ lý" Style="{StaticResource TieuDeTrang}"/>
              <TextBlock Style="{StaticResource MoTaTrang}" Margin="0,4,0,0" Text="Giao việc như nhắn tin - giao được 3 việc cùng lúc. Trợ lý tự đọc bộ nhớ cơ quan, làm đến khi xong và gửi lại file Word. Chữ nhỏ thì bấm A+; cần đọc kỹ thì bấm Phóng to (F11) hoặc “Đọc cửa sổ lớn” dưới mỗi câu trả lời."/>
            </StackPanel>
            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Top" Margin="12,2,0,0">
              <Button x:Name="BtnViecMoiNho" Style="{StaticResource Nut}" Padding="12,6" Margin="0,0,10,0" ToolTip="Mở một cuộc trò chuyện mới để giao việc khác">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE710;" FontFamily="Segoe MDL2 Assets" FontSize="12" VerticalAlignment="Center" Margin="0,0,7,0"/><TextBlock Text="Việc mới" VerticalAlignment="Center"/></StackPanel>
              </Button>
              <Border Background="White" BorderBrush="#D6E0EE" BorderThickness="1" CornerRadius="10" Padding="4,2" Margin="0,0,10,0">
                <StackPanel Orientation="Horizontal">
                  <Button x:Name="BtnChuNho" Style="{StaticResource Lien}" Content="A−" FontSize="15" FontWeight="Bold" Padding="9,3" ToolTip="Giảm cỡ chữ câu trả lời và ô nhập"/>
                  <TextBlock x:Name="TxtCoChu" Text="15" FontSize="12.5" Foreground="#5B6B7F" VerticalAlignment="Center" MinWidth="22" TextAlignment="Center"/>
                  <Button x:Name="BtnChuTo" Style="{StaticResource Lien}" Content="A+" FontSize="15" FontWeight="Bold" Padding="9,3" ToolTip="Tăng cỡ chữ câu trả lời và ô nhập"/>
                </StackPanel>
              </Border>
              <Button x:Name="BtnCotViec" Style="{StaticResource Nut}" Padding="12,6" Margin="0,0,10,0" ToolTip="Thu gọn hoặc mở lại cột Các việc đã giao">
                <StackPanel Orientation="Horizontal"><TextBlock x:Name="IcCotViec" Text="&#xE700;" FontFamily="Segoe MDL2 Assets" FontSize="12" VerticalAlignment="Center" Margin="0,0,7,0"/><TextBlock x:Name="TxtCotViec" Text="Thu gọn cột việc" VerticalAlignment="Center"/></StackPanel>
              </Button>
              <Button x:Name="BtnPhongTo" Style="{StaticResource NutChinh}" Padding="14,7" Margin="0" ToolTip="Ẩn thanh menu và đầu trang để khung trò chuyện chiếm gần cả cửa sổ (F11; Esc để trở lại)">
                <StackPanel Orientation="Horizontal"><TextBlock x:Name="IcPhongTo" Text="&#xE740;" FontFamily="Segoe MDL2 Assets" FontSize="13" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock x:Name="TxtPhongTo" Text="Phóng to" VerticalAlignment="Center"/></StackPanel>
              </Button>
            </StackPanel>
          </Grid>
          <Grid Grid.Row="1">
            <Grid.ColumnDefinitions><ColumnDefinition x:Name="CotViecChat" Width="250"/><ColumnDefinition x:Name="CotHoChat" Width="14"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
            <!-- Cột "Các việc đã giao" đặt ở lưới trang (Grid.Row 1-3) để kéo dài xuống sát nút Việc mới -->
            <Grid Grid.Column="2">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="0">
              <Grid>
                <ScrollViewer x:Name="CuonChat" VerticalScrollBarVisibility="Auto" Padding="22,14"/>
                <ScrollViewer x:Name="ChaoChat" VerticalScrollBarVisibility="Auto">
                <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center" MaxWidth="780" Margin="24,16">
                  <Border Width="52" Height="52" CornerRadius="26" HorizontalAlignment="Center">
                    <Border.Background><LinearGradientBrush StartPoint="0,0" EndPoint="1,1"><GradientStop Color="#A775FF" Offset="0"/><GradientStop Color="#2F6FE0" Offset="1"/></LinearGradientBrush></Border.Background>
                    <TextBlock Text="&#xE8BD;" FontFamily="Segoe MDL2 Assets" FontSize="28" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                  </Border>
                  <TextBlock x:Name="TxtChaoChat" Text="Anh/chị cần em giúp việc gì hôm nay?" FontSize="21" FontWeight="Bold" Foreground="#0B2B6B" HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap" Margin="0,14,0,6"/>
                  <TextBlock Text="Gõ việc cần làm vào ô bên dưới hoặc chọn một gợi ý. Kéo thả file Word, PDF, Excel vào đây để em đọc." FontSize="13.5" Foreground="#5B6B7F" HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap"/>
                  <WrapPanel x:Name="DsGoiY" HorizontalAlignment="Center" Margin="0,14,0,0"/>
                </StackPanel>
                </ScrollViewer>
              </Grid>
            </Border>
            </Grid>
          </Grid>
          <!-- Cột Các việc đã giao: cao từ khung chat xuống sát nút Việc mới (thầy góp ý 15/9/2026: cột ngắn, khó nhìn) -->
          <Grid x:Name="KhungViecChat" Grid.Row="1" Grid.RowSpan="3" Width="250" HorizontalAlignment="Left">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="10,12">
              <Grid>
                <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
                <TextBlock Text="Các việc đã giao" FontSize="14.5" FontWeight="Bold" Foreground="#0B2B6B" Margin="6,0,0,8"/>
                <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsViecChat"/></ScrollViewer>
                <TextBlock x:Name="TxtSoViecChay" Grid.Row="2" FontSize="12" Foreground="#5B6B7F" Margin="6,8,0,0" TextWrapping="Wrap"/>
              </Grid>
            </Border>
          </Grid>
          <Border x:Name="KhungTienTrinh" Grid.Row="2" Visibility="Collapsed" Background="White" BorderBrush="#CFDDF6" BorderThickness="1" CornerRadius="12" Padding="16,10" Margin="264,12,0,0">
            <Grid>
              <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBlock x:Name="IconTienTrinh" Text="&#xE895;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#2F6FE0" VerticalAlignment="Center" RenderTransformOrigin="0.5,0.5"/>
              <StackPanel Grid.Column="1" Margin="12,0,14,0" VerticalAlignment="Center">
                <Grid>
                  <TextBlock x:Name="TxtBuoc" Text="Đang đọc yêu cầu..." FontSize="13.5" FontWeight="SemiBold" Foreground="#1F3354" TextTrimming="CharacterEllipsis" Margin="0,0,120,0"/>
                  <TextBlock x:Name="TxtThoiGian" HorizontalAlignment="Right" FontSize="12.5" Foreground="#5B6B7F"/>
                </Grid>
                <ProgressBar x:Name="ThanhTienTrinh" Height="8" Margin="0,7,0,0" Minimum="0" Maximum="100" Foreground="#2F6FE0" Background="#E8EEF8" BorderThickness="0"/>
              </StackPanel>
              <TextBlock x:Name="TxtPhanTram" Grid.Column="2" Text="0%" FontSize="18" FontWeight="Bold" Foreground="#2F6FE0" VerticalAlignment="Center" MinWidth="52" TextAlignment="Right" Margin="0,0,14,0"/>
              <Button x:Name="BtnDungChat" Grid.Column="3" Style="{StaticResource Nut}" Margin="0" VerticalAlignment="Center">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE71A;" FontFamily="Segoe MDL2 Assets" FontSize="12" Foreground="#D32F2F" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Dừng" VerticalAlignment="Center"/></StackPanel>
              </Button>
            </Grid>
          </Border>
          <StackPanel x:Name="KhungDinhKemChat" Grid.Row="3" Margin="264,10,0,0">
            <!-- Quy trình chọn từ ô chức năng: chưa gửi, chờ anh/chị ghi việc cụ thể (tro-chuyen.ps1: Ve-QuyTrinh) -->
            <Border x:Name="KhungQuyTrinh" Visibility="Collapsed" Background="White" BorderBrush="#CFDDF6" BorderThickness="1" CornerRadius="12" Padding="14,10" Margin="0,0,0,6">
              <StackPanel>
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <TextBlock x:Name="TxtQuyTrinh" FontSize="13.5" Foreground="#40546B" TextWrapping="Wrap" LineHeight="20"/>
                  <Button x:Name="BtnBoQuyTrinh" Grid.Column="1" Style="{StaticResource Lien}" Margin="10,0,0,0" VerticalAlignment="Top" ToolTip="Bỏ chọn quy trình này">
                    <TextBlock Text="&#xE711;" FontFamily="Segoe MDL2 Assets" FontSize="11" Foreground="#5B6B7F"/>
                  </Button>
                </Grid>
                <WrapPanel x:Name="DsGoiYQuyTrinh" Margin="0,8,0,0"/>
              </StackPanel>
            </Border>
            <WrapPanel x:Name="DsDinhKem"/>
          </StackPanel>
          <!-- Nút giao việc mới: dưới cột "Các việc đã giao", ngang hàng ô chat -->
          <Button x:Name="BtnChatMoi" Grid.Row="4" Style="{StaticResource NutXanhLa}" Width="250" Height="48" Margin="0,10,0,0" HorizontalAlignment="Left" VerticalAlignment="Bottom" ToolTip="Mở một cuộc trò chuyện mới để giao việc khác - việc đang chạy vẫn tiếp tục">
            <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE710;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,10,0"/><TextBlock Text="Việc mới" VerticalAlignment="Center"/></StackPanel>
          </Button>
          <Grid x:Name="KhungNhapChat" Grid.Row="4" Margin="264,10,0,0">
            <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <Button x:Name="BtnDinhKem" Style="{StaticResource Nut}" Height="48" Padding="14,0" VerticalAlignment="Bottom" ToolTip="Đính kèm file (Word, PDF, Excel, ảnh) - chụp màn hình rồi Ctrl+V vào ô nhập cũng được">
              <TextBlock Text="&#xE723;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#2F6FE0"/>
            </Button>
            <Grid Grid.Column="1" Margin="0,0,10,0">
              <TextBox x:Name="TxtHoi" Style="{StaticResource Nhap}" MinHeight="48" MaxHeight="180" AcceptsReturn="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYHoi" Style="{StaticResource GoiY}" Text="Nhập việc cần làm... (Enter để gửi, Shift+Enter để xuống dòng)"/>
            </Grid>
            <Button x:Name="BtnGuiHoi" Grid.Column="2" Style="{StaticResource NutChinh}" Height="48" Margin="0" Padding="22,0" VerticalAlignment="Bottom">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Gửi" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
            </Button>
          </Grid>
        </Grid>

        <!-- ========== QUẢN LÝ CÔNG VIỆC ========== -->
        <Grid x:Name="PgCongViec" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Việc cần làm" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border><Button x:Name="TabTrang3" Style="{StaticResource TabTrang}" Tag="trang:Lich" Content="Lịch công tác" Margin="0,0,22,0" ToolTip="Chuyển sang Lịch công tác"/></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Việc cần làm của anh/chị (trợ lý cũng đọc và ghi vào danh sách này) và các hạn xử lý phát sinh từ văn bản đến."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="150"/><ColumnDefinition Width="90"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <DatePicker x:Name="DpNgayViec" FontSize="14" VerticalContentAlignment="Center" Height="40" Margin="0,0,10,0"/>
            <Grid Grid.Column="1" Height="40" Margin="0,0,10,0">
              <TextBox x:Name="TxtGioViec" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYGio" Style="{StaticResource GoiY}" Text="08:00"/>
            </Grid>
            <Grid Grid.Column="2" Height="40" Margin="0,0,10,0">
              <TextBox x:Name="TxtNoiDungViec" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYViec" Style="{StaticResource GoiY}" Text="Nội dung công việc, ví dụ: Tổng hợp báo cáo đầu năm học của các đơn vị"/>
            </Grid>
            <Button x:Name="BtnThemViec" Grid.Column="3" Style="{StaticResource NutChinh}" Content="Thêm việc" Margin="0"/>
          </Grid>
          <Grid Grid.Row="3">
            <Grid.ColumnDefinitions><ColumnDefinition Width="3*"/><ColumnDefinition Width="18"/><ColumnDefinition Width="2*"/></Grid.ColumnDefinitions>
            <Grid>
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
                  <TextBlock Text="Danh sách việc" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsViec"/></ScrollViewer>
                  <WrapPanel Grid.Row="2" Margin="0,10,0,0">
                    <Button x:Name="BtnXoaViecXong" Style="{StaticResource Nut}" Content="Xóa các việc đã xong"/>
                    <Button x:Name="BtnMoFileViec" Style="{StaticResource Nut}" Content="Mở file việc cần làm"/>
                  </WrapPanel>
                </Grid>
              </Border>
            </Grid>
            <Grid Grid.Column="2">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
                  <TextBlock Text="Hạn xử lý từ văn bản đến" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsHan"/></ScrollViewer>
                  <WrapPanel Grid.Row="2" Margin="0,10,0,0">
                    <Button x:Name="BtnVbTuCongViec" Style="{StaticResource NutChinh}" Content="Lấy văn bản mới (iOffice)"/>
                    <Button x:Name="BtnSoTheoDoi" Style="{StaticResource Nut}" Content="Sổ theo dõi việc"/>
                  </WrapPanel>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== LỊCH CÔNG TÁC ========== -->
        <Grid x:Name="PgLich" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang4" Style="{StaticResource TabTrang}" Tag="trang:CongViec" Content="Việc cần làm" Margin="0,0,22,0" ToolTip="Chuyển sang Việc cần làm"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Lịch công tác" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Lịch công tác tuần đã lập và các mốc thời gian của năm học (lấy từ bộ nhớ của trợ lý)."/>
          <WrapPanel Grid.Row="2" Margin="0,0,0,14">
            <Button x:Name="BtnLapLichTuan" Style="{StaticResource NutChinh}" Content="Lập lịch công tác tuần tới"/>
            <Button x:Name="BtnCapNhatMoc" Style="{StaticResource Nut}" Content="Cập nhật mốc năm học"/>
            <Button x:Name="BtnMoLichNamHoc" Style="{StaticResource Nut}" Content="Mở file lịch năm học"/>
          </WrapPanel>
          <Grid Grid.Row="3">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="18"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
            <Grid>
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="10">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                  <TextBlock Text="Lịch tuần đã lập (bấm đúp để mở)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,6,0,8"/>
                  <ListView x:Name="LvLich" Grid.Row="1">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Lịch" Width="330" DisplayMemberBinding="{Binding Ten}"/>
                        <GridViewColumn Header="Ngày sửa" Width="120" DisplayMemberBinding="{Binding NgayTxt}"/>
                      </GridView>
                    </ListView.View>
                  </ListView>
                </Grid>
              </Border>
            </Grid>
            <Grid Grid.Column="2">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                  <TextBlock Text="Mốc thời gian năm học" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsMoc"/></ScrollViewer>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== TỔNG HỢP SỐ LIỆU ========== -->
        <Grid x:Name="PgTongHop" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*" MinHeight="90"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang5" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Công cụ tiện ích" Margin="0,0,14,0" ToolTip="Chuyển sang Công cụ tiện ích"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Tổng hợp số liệu" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Đưa file Excel/CSV (số liệu thống kê của các đơn vị, phổ cập, chất lượng giáo dục, đội ngũ...) vào đây, chọn file (giữ Ctrl để chọn nhiều file), ghi yêu cầu cần tổng hợp gì rồi bấm Giao việc tổng hợp. Trợ lý chỉ đưa số liệu tổng hợp vào báo cáo, không lưu danh sách cá nhân vào bộ nhớ."/>
          <Grid x:Name="VungThaDuLieu" Grid.Row="2" Height="76" Margin="0,0,0,12" AllowDrop="True" Background="Transparent" Cursor="Hand">
            <Rectangle RadiusX="14" RadiusY="14" Stroke="#8FB3F2" StrokeThickness="1.6" StrokeDashArray="5,4" Fill="#F5F9FF"/>
            <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
              <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="26" Foreground="#2F6FE0" VerticalAlignment="Center"/>
              <StackPanel Margin="14,0,0,0">
                <TextBlock Text="Kéo thả file Excel, CSV vào đây" FontSize="15" FontWeight="SemiBold" Foreground="#1F3354"/>
                <TextBlock Text="hoặc bấm để chọn file từ máy tính" FontSize="13" Foreground="#5B6B7F"/>
              </StackPanel>
            </StackPanel>
          </Grid>
          <Grid Grid.Row="3">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvDuLieu" SelectionMode="Extended">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="File dữ liệu" Width="420" DisplayMemberBinding="{Binding File}"/>
                    <GridViewColumn Header="Ngày sửa" Width="140" DisplayMemberBinding="{Binding NgayTxt}"/>
                    <GridViewColumn Header="Dung lượng" Width="110" DisplayMemberBinding="{Binding CoTxt}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <!-- Ô yêu cầu: thầy cô ghi cần tổng hợp gì (Enter gửi, Shift+Enter xuống dòng); nút gợi ý điền nhanh -->
          <Grid Grid.Row="4" Margin="0,12,0,0">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="16,12,16,8">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <TextBlock Text="&#xE8BD;" FontFamily="Segoe MDL2 Assets" FontSize="15" Foreground="#2F6FE0" VerticalAlignment="Center"/>
                  <TextBlock Text="Yêu cầu tổng hợp" FontSize="14.5" FontWeight="SemiBold" Foreground="#1F3354" Margin="8,0,0,0" VerticalAlignment="Center"/>
                  <TextBlock Text="  ·  Enter để gửi, Shift+Enter xuống dòng" FontSize="12" Foreground="#7A8AA0" VerticalAlignment="Center"/>
                </StackPanel>
                <Grid Height="60" Margin="0,8,0,0">
                  <TextBox x:Name="TxtYeuCauTH" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
                  <TextBlock x:Name="GoiYYeuCauTH" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,9,14,0" TextWrapping="Wrap" Text="Ghi rõ cần tổng hợp gì. Ví dụ: số trường, lớp, trẻ, học sinh theo từng đơn vị, tỷ lệ huy động trẻ, so sánh với năm học trước; lập bảng và nhận xét để đưa vào báo cáo."/>
                </Grid>
                <WrapPanel x:Name="WpGoiYTH" Margin="0,8,0,0"/>
              </StackPanel>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="5" Margin="0,12,0,0">
            <Button x:Name="BtnTongHopFile" Style="{StaticResource NutChinh}" Content="Giao việc tổng hợp"/>
            <Button x:Name="BtnSangDonVi" Style="{StaticResource Nut}" Content="Báo cáo của các đơn vị"/>
            <Button x:Name="BtnMoDuLieu" Style="{StaticResource Nut}" Content="Mở thư mục dữ liệu"/>
          </WrapPanel>
        </Grid>

        <!-- ========== TRA CỨU ========== -->
        <Grid x:Name="PgTraCuu" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang6" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Công cụ tiện ích" Margin="0,0,14,0" ToolTip="Chuyển sang Công cụ tiện ích"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Tra cứu quy định" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Hỏi về chương trình giáo dục mầm non, tiểu học, Điều lệ trường, đánh giá học sinh, phổ cập, kiểm định, chuẩn quốc gia, phân cấp quản lý, văn thư... Trợ lý trả lời kèm căn cứ và chỉ dùng số hiệu văn bản có trong danh mục đã đối chiếu dưới đây."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <Grid Height="44" Margin="0,0,10,0">
              <TextBox x:Name="TxtCauHoi" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYCauHoi" Style="{StaticResource GoiY}" Text="Ví dụ: Điều kiện công nhận xã đạt chuẩn phổ cập giáo dục mầm non cho trẻ em 3-5 tuổi?"/>
            </Grid>
            <Button x:Name="BtnTraCuu" Grid.Column="1" Style="{StaticResource NutChinh}" Content="Tra cứu" Margin="0"/>
          </Grid>
          <Grid Grid.Row="3">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvCanCu">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Văn bản" Width="260" DisplayMemberBinding="{Binding VanBan}"/>
                    <GridViewColumn Header="Ngày" Width="100" DisplayMemberBinding="{Binding Ngay}"/>
                    <GridViewColumn Header="Nội dung" Width="330" DisplayMemberBinding="{Binding NoiDung}"/>
                    <GridViewColumn Header="Tình trạng" Width="300" DisplayMemberBinding="{Binding TinhTrang}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="4" Margin="0,14,0,0">
            <Button x:Name="BtnMoCanCu" Style="{StaticResource Nut}" Content="Mở danh mục căn cứ"/>
            <Button x:Name="BtnCanCuTruong" Style="{StaticResource Nut}" Content="Căn cứ của tỉnh, Sở, xã"/>
          </WrapPanel>
        </Grid>

        <!-- ========== THƯ VIỆN VĂN BẢN ========== -->
        <Grid x:Name="PgThuVien" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <TextBlock Text="Thư viện văn bản" Style="{StaticResource TieuDeTrang}"/>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Toàn bộ văn bản trợ lý đã soạn và văn bản đến, dữ liệu anh/chị đã đưa vào. Bấm đúp để mở file."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="220"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <Grid Height="42" Margin="0,0,10,0">
              <TextBox x:Name="TxtTimVB" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYTimVB" Style="{StaticResource GoiY}" Text="Tìm theo tên văn bản (gõ không dấu cũng được)..."/>
            </Grid>
            <ComboBox x:Name="CbLoaiVB" Grid.Column="1" Height="42" Style="{StaticResource Chon}" Margin="0,0,10,0"/>
            <Button x:Name="BtnMoThuMucSanPham" Grid.Column="2" Style="{StaticResource NutChinh}" Margin="0">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="&#xED25;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/>
                <TextBlock Text="Mở thư mục văn bản" VerticalAlignment="Center"/>
              </StackPanel>
            </Button>
          </Grid>
          <Grid Grid.Row="3">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvThuVien">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Tên văn bản" Width="470" DisplayMemberBinding="{Binding Ten}"/>
                    <GridViewColumn Header="Loại" Width="120" DisplayMemberBinding="{Binding Loai}"/>
                    <GridViewColumn Header="Định dạng" Width="90" DisplayMemberBinding="{Binding DinhDang}"/>
                    <GridViewColumn Header="Ngày sửa" Width="140" DisplayMemberBinding="{Binding NgayTxt}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="4" Margin="0,14,0,0">
            <Button x:Name="BtnMoVB" Style="{StaticResource NutChinh}" Content="Mở văn bản"/>
            <Button x:Name="BtnMoThuMucChua" Style="{StaticResource Nut}" Content="Mở thư mục chứa file"/>
            <Button x:Name="BtnSuaTiep" Style="{StaticResource Nut}" Content="Sửa tiếp với trợ lý"/>
            <Button x:Name="BtnRaSoatVB" Style="{StaticResource Nut}" Content="Rà soát văn bản này"/>
          </WrapPanel>
        </Grid>

        <!-- ========== NHIỆM VỤ (bộ ô theo cơ quan công tác: Sở / Phòng Văn hóa - Xã hội / UBND xã) ========== -->
        <ScrollViewer x:Name="PgNhiemVu" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock x:Name="TieuDeNV" Text="Nhiệm vụ chuyên viên" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock x:Name="MoTaNV" Style="{StaticResource MoTaTrang}" Text="Nhiệm vụ theo cấp học phụ trách. Bấm một ô để chọn việc - trợ lý chờ anh/chị ghi việc cụ thể rồi mới làm."/>
            <Grid Margin="6,0,6,14">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel>
                    <TextBlock x:Name="TieuDeViecThang" Text="Việc tháng này" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                    <TextBlock x:Name="TxtViecThang" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                  </StackPanel>
                  <StackPanel Grid.Column="1" VerticalAlignment="Top" Margin="16,0,0,0">
                    <Button x:Name="BtnViecThang" Style="{StaticResource NutChinh}" Content="Lập việc tháng này" Margin="0,0,0,8"/>
                    <Button x:Name="BtnMoCongViec" Style="{StaticResource Nut}" Content="Quản lý công việc" Margin="0"/>
                  </StackPanel>
                </Grid>
              </Border>
            </Grid>
            <Grid Height="84" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhNV" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhNV" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi, Shift+Enter xuống dòng), hoặc ghi vài ý chính rồi bấm một ô bên dưới."/>
              <Button x:Name="BtnGiaoViecNV" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <StackPanel x:Name="KhuNVso">
@@NVSO@@
            </StackPanel>
            <StackPanel x:Name="KhuNVvhxh" Visibility="Collapsed">
@@NVXA@@
            </StackPanel>
            <StackPanel x:Name="KhuNVubnd" Visibility="Collapsed">
@@NVUB@@
            </StackPanel>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== ĐƠN VỊ, BÁO CÁO (Sở: các xã, phường; cấp xã: các trường trên địa bàn) ========== -->
        <ScrollViewer x:Name="PgDonVi" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Đơn vị, báo cáo" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock x:Name="MoTaDV" Style="{StaticResource MoTaTrang}" Text="Yêu cầu, theo dõi và tổng hợp báo cáo của các đơn vị. Báo cáo nhận được lưu ở thư mục 11_BAO_CAO_DON_VI, mỗi đợt một thư mục con; trợ lý đối chiếu với sổ theo dõi báo cáo."/>
            <Grid Margin="6,0,6,14">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="18"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
              <Grid>
                <Border Style="{StaticResource Bong}"/>
                <Border Style="{StaticResource The}">
                  <StackPanel>
                    <Grid Margin="0,0,0,6">
                      <TextBlock x:Name="TieuDeDsDV" Text="Các xã, phường" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                      <Button x:Name="BtnDsDonVi" Style="{StaticResource Lien}" HorizontalAlignment="Right" VerticalAlignment="Center" Content="Sửa danh sách  →"/>
                    </Grid>
                    <TextBlock x:Name="TxtDsDonVi" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                  </StackPanel>
                </Border>
              </Grid>
              <Grid Grid.Column="2">
                <Border Style="{StaticResource Bong}"/>
                <Border Style="{StaticResource The}">
                  <StackPanel>
                    <Grid Margin="0,0,0,6">
                      <TextBlock Text="Các đợt báo cáo" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                      <Button x:Name="BtnSoTheoDoiBC" Style="{StaticResource Lien}" HorizontalAlignment="Right" VerticalAlignment="Center" Content="Sổ theo dõi  →"/>
                    </Grid>
                    <TextBlock x:Name="TxtDotBC" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                  </StackPanel>
                </Border>
              </Grid>
            </Grid>
            <Grid Height="84" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhDV" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhDV" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi), hoặc bấm một ô bên dưới. Ví dụ: công văn yêu cầu báo cáo số liệu đầu năm học, hạn 25/{thang}; đơn vị nào chưa nộp báo cáo đợt {namthang}..."/>
              <Button x:Name="BtnGiaoViecDV" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <UniformGrid Columns="3">
@@DV@@
            </UniformGrid>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="12">
                <StackPanel>
                  <Grid Margin="4,0,4,8">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="Báo cáo đã nhận" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                    <StackPanel Grid.Column="2" Orientation="Horizontal">
                      <Button x:Name="BtnMoVBDV" Style="{StaticResource Nut}" Content="Mở file"/>
                      <Button x:Name="BtnTongHopDot" Style="{StaticResource Nut}" Content="Tổng hợp đợt đang chọn"/>
                      <Button x:Name="BtnMoThuMucDV" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0"/>
                    </StackPanel>
                  </Grid>
                  <Grid Margin="4,0,4,10">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="280"/><ColumnDefinition Width="12"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="Đợt:" FontSize="13.5" Foreground="#40546B" VerticalAlignment="Center" Margin="0,0,8,0"/>
                    <ComboBox x:Name="CbDotBC" Grid.Column="1" Height="38" Style="{StaticResource Chon}"/>
                    <Grid Grid.Column="3" Height="38">
                      <TextBox x:Name="TxtDotMoi" Style="{StaticResource Nhap}"/>
                      <TextBlock x:Name="GoiYDotMoi" Style="{StaticResource GoiY}" FontSize="13" Text="Tên đợt mới, ví dụ: {namthang} Báo cáo đầu năm học"/>
                    </Grid>
                    <Button x:Name="BtnTaoDot" Grid.Column="4" Style="{StaticResource Nut}" Content="Tạo đợt" Margin="10,0,0,0"/>
                  </Grid>
                  <Grid x:Name="VungThaDV" Height="60" Margin="4,0,4,10" AllowDrop="True" Background="Transparent" Cursor="Hand">
                    <Rectangle RadiusX="12" RadiusY="12" Stroke="#8FB3F2" StrokeThickness="1.4" StrokeDashArray="5,4" Fill="#F5F9FF"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center">
                      <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="20" Foreground="#2F6FE0" VerticalAlignment="Center"/>
                      <TextBlock Text="Kéo thả file báo cáo của đơn vị vào đây (hoặc bấm để chọn) - file được lưu vào đợt đang chọn" FontSize="13.5" Foreground="#40546B" VerticalAlignment="Center" Margin="10,0,0,0" TextWrapping="Wrap"/>
                    </StackPanel>
                  </Grid>
                  <ListView x:Name="LvDonVi" Height="240">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Đợt" Width="220" DisplayMemberBinding="{Binding Dot}"/>
                        <GridViewColumn Header="Tên file" Width="420" DisplayMemberBinding="{Binding File}"/>
                        <GridViewColumn Header="Ngày" Width="130" DisplayMemberBinding="{Binding NgayTxt}"/>
                      </GridView>
                    </ListView.View>
                  </ListView>
                </StackPanel>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== KIỂM TRA, ĐÁNH GIÁ ========== -->
        <ScrollViewer x:Name="PgKiemTra" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Kiểm tra, đánh giá" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock x:Name="MoTaKT" Style="{StaticResource MoTaTrang}" Text="Kiểm tra chuyên môn, bảo đảm chất lượng, công nhận chuẩn quốc gia, phổ cập giáo dục. Hồ sơ lưu ở thư mục 10_KIEM_TRA, mỗi đợt một thư mục con. Bấm một ô để chọn việc - trợ lý chờ anh/chị ghi việc cụ thể rồi mới làm."/>
            <Grid Height="84" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhKT" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhKT" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi), hoặc bấm một ô bên dưới. Ví dụ: biên bản kiểm tra Trường Mầm non Hoa Sen ngày 15/10 (dán ghi chép); tờ trình công nhận trường đạt chuẩn quốc gia..."/>
              <Button x:Name="BtnGiaoViecKT" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <StackPanel>
@@KT@@
            </StackPanel>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="12">
                <StackPanel>
                  <Grid Margin="4,0,4,8">
                    <TextBlock Text="Hồ sơ kiểm tra, đánh giá" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                      <Button x:Name="BtnMoVBKT" Style="{StaticResource Nut}" Content="Mở văn bản"/>
                      <Button x:Name="BtnMoThuMucKT" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0"/>
                    </StackPanel>
                  </Grid>
                  <ListView x:Name="LvKiemTra" Height="240">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Đợt" Width="220" DisplayMemberBinding="{Binding Dot}"/>
                        <GridViewColumn Header="Tên văn bản" Width="440" DisplayMemberBinding="{Binding Ten}"/>
                        <GridViewColumn Header="Ngày sửa" Width="130" DisplayMemberBinding="{Binding NgayTxt}"/>
                      </GridView>
                    </ListView.View>
                  </ListView>
                </StackPanel>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== CÔNG CỤ TIỆN ÍCH ========== -->
        <ScrollViewer x:Name="PgTienIch" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Công cụ tiện ích" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Các quy trình chuyên sâu và các công cụ quản lý dữ liệu."/>
            <UniformGrid Columns="3">
@@TIENICH@@
            </UniformGrid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== VĂN BẢN ĐẾN ========== -->
        <Grid x:Name="PgVanBanDen" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang7" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Công cụ tiện ích" Margin="0,0,14,0" ToolTip="Chuyển sang Công cụ tiện ích"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Xử lý văn bản đến" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Thả file văn bản của Bộ, UBND tỉnh, Sở, UBND xã, các trường (Word, PDF, ảnh chụp) để trợ lý tóm tắt, trích việc phải làm, thời hạn và đề xuất phân công. Bạn có thể tải văn bản từ iOffice rồi chọn tệp để xử lý."/>
          <Grid x:Name="VungThaVBDen" Grid.Row="2" Height="96" Margin="0,0,0,14" AllowDrop="True" Background="Transparent" Cursor="Hand">
            <Rectangle RadiusX="14" RadiusY="14" Stroke="#F0B429" StrokeThickness="1.6" StrokeDashArray="5,4" Fill="#FFFBF0"/>
            <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
              <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="26" Foreground="#E09A00" VerticalAlignment="Center"/>
              <StackPanel Margin="14,0,0,0">
                <TextBlock Text="Kéo thả file văn bản đến vào đây" FontSize="15" FontWeight="SemiBold" Foreground="#1F3354"/>
                <TextBlock Text="hoặc bấm để chọn file (Word, PDF, ảnh chụp văn bản)" FontSize="13" Foreground="#5B6B7F"/>
              </StackPanel>
            </StackPanel>
          </Grid>
          <Grid Grid.Row="3">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvVBDen">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Văn bản đến" Width="520" DisplayMemberBinding="{Binding File}"/>
                    <GridViewColumn Header="Định dạng" Width="90" DisplayMemberBinding="{Binding DinhDang}"/>
                    <GridViewColumn Header="Ngày nhận" Width="140" DisplayMemberBinding="{Binding NgayTxt}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="4" Margin="0,14,0,0">
            <Button x:Name="BtnTomTat" Style="{StaticResource NutChinh}" Content="Tóm tắt và trích việc"/>
            <Button x:Name="BtnVbIOffice" Style="{StaticResource Nut}" Content="Lấy văn bản mới từ iOffice"/>
            <Button x:Name="BtnPhieuGQ" Style="{StaticResource Nut}" Content="Lập phiếu giải quyết"/>
            <Button x:Name="BtnSoTheoDoi2" Style="{StaticResource Nut}" Content="Sổ theo dõi việc"/>
            <Button x:Name="BtnMoVBDen" Style="{StaticResource Nut}" Content="Mở thư mục"/>
          </WrapPanel>
        </Grid>

        <!-- ========== CÀI ĐẶT ========== -->
        <ScrollViewer x:Name="PgCaiDat" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Cài đặt" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Tình trạng công cụ, kết nối OpenRouter, mô hình AI, thông tin cơ quan và bộ nhớ của trợ lý."/>
            <Grid>
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="18"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
              <StackPanel>
                <Grid>
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Tình trạng" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,10"/>
                      <StackPanel Orientation="Horizontal" Margin="0,4"><Ellipse x:Name="ChamOpenRouter" Width="10" Height="10" Fill="#B0BAC6"/><TextBlock x:Name="TxtOpenRouter" Text="OpenRouter: đang kiểm tra cấu hình..." Margin="10,0,0,0" FontSize="14"/></StackPanel>
                      <StackPanel Orientation="Horizontal" Margin="0,4"><Ellipse x:Name="ChamPandoc" Width="10" Height="10" Fill="#B0BAC6"/><TextBlock x:Name="TxtPandoc" Text="Xuất Word: đang kiểm tra..." Margin="10,0,0,0" FontSize="14"/></StackPanel>
                      <StackPanel Orientation="Horizontal" Margin="0,4"><Ellipse x:Name="ChamDangNhap" Width="10" Height="10" Fill="#B0BAC6"/><TextBlock x:Name="TxtDangNhap" Text="Đăng nhập: đang kiểm tra..." Margin="10,0,0,0" FontSize="14"/></StackPanel>
                      <WrapPanel Margin="0,14,0,0">
                        <Button x:Name="BtnDangNhap" Style="{StaticResource NutChinh}" Content="Cấu hình OpenRouter" Margin="0,0,10,8"/>
                        
                        
                        
                      </WrapPanel>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Margin="0,18,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Mô hình AI (model)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock TextWrapping="Wrap" FontSize="13" Foreground="#40546B" LineHeight="20" Text="Model AI đã được cấu hình sẵn. Nhập API key OpenRouter để sử dụng."/>
                      <ComboBox x:Name="CbModel" Style="{StaticResource Chon}" Height="42" Margin="0,10,0,0"/>
                      <TextBlock x:Name="TxtModel" TextWrapping="Wrap" FontSize="13" Foreground="#1F3354" LineHeight="20" Margin="0,8,0,0"/>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Margin="0,18,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Dữ liệu và an toàn" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock TextWrapping="Wrap" FontSize="13" Foreground="#40546B" LineHeight="20" Text="Yêu cầu và tài liệu đính kèm được gửi qua OpenRouter đến nhà cung cấp model đã cấu hình. API key được bảo vệ bằng tài khoản Windows."/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnSaoLuu" Style="{StaticResource NutChinh}" Content="Sao lưu dữ liệu" Margin="0,0,10,8"/>
                        <Button x:Name="BtnMoGoc" Style="{StaticResource Nut}" Content="Mở thư mục làm việc" Margin="0,0,10,8"/>
                        <Button x:Name="BtnXoaLichSu" Style="{StaticResource Nut}" Content="Xóa lịch sử trò chuyện" Margin="0,0,10,8" ToolTip="Xóa các cuộc trò chuyện đã lưu trên máy này (văn bản, bộ nhớ giữ nguyên)"/>
                      </WrapPanel>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Margin="0,18,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Kích hoạt phần mềm" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock x:Name="TxtBanQuyen" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="21"/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnKichHoat" Style="{StaticResource NutChinh}" Content="Kích hoạt / nhập mã mới" Margin="0,0,10,8"/>
                      </WrapPanel>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Margin="0,18,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Cập nhật phần mềm" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock x:Name="TxtCapNhat" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="21"/>
                      <ProgressBar x:Name="PbCapNhat" Height="8" Margin="0,10,0,0" Minimum="0" Maximum="100" Visibility="Collapsed" Foreground="#2F6FE0" Background="#E6EDF7" BorderThickness="0"/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnKiemTraCapNhat" Style="{StaticResource NutChinh}" Content="Kiểm tra bản mới" Margin="0,0,10,8"/>
                        <Button x:Name="BtnCapNhatFile" Style="{StaticResource Nut}" Content="Cập nhật từ file cài đặt" Margin="0,0,10,8"/>
                      </WrapPanel>
                    </StackPanel>
                  </Border>
                </Grid>
              </StackPanel>
              <StackPanel Grid.Column="2">
                <Grid>
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Thông tin cơ quan (bộ nhớ của trợ lý)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock x:Name="TxtThongTinTruong" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnKhaiBao" Style="{StaticResource NutChinh}" Content="Khai báo thông tin cơ quan" Margin="0,0,10,8"/>
                        <Button x:Name="BtnCapNhatTruong" Style="{StaticResource Nut}" Content="Cập nhật quy mô cùng trợ lý" Margin="0,0,10,8"/>
                      </WrapPanel>
                      <TextBlock Text="Mở từng file bộ nhớ để xem, sửa bằng Notepad:" FontSize="13" Foreground="#5B6B7F" Margin="0,6,0,6"/>
                      <WrapPanel x:Name="DsFileBoNho"/>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Margin="0,18,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Giới thiệu" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock x:Name="TxtGioiThieu" TextWrapping="Wrap" FontSize="13" Foreground="#40546B" LineHeight="20"/>
                    </StackPanel>
                  </Border>
                </Grid>
              </StackPanel>
            </Grid>
          </StackPanel>
        </ScrollViewer>
      </Grid>

      <!-- Chân trang -->
      <Border x:Name="ChanTrang" Grid.Row="2" Background="White" BorderBrush="#E3EAF5" BorderThickness="0,1,0,0" Padding="30,10">
        <Grid>
          <StackPanel x:Name="KhungTrangThai" Orientation="Horizontal" VerticalAlignment="Center" Background="Transparent" Cursor="Hand">
            <Ellipse x:Name="ChamTrangThai" Width="11" Height="11" Fill="#B0BAC6"/>
            <TextBlock x:Name="TxtTrangThai" Text="Đang kiểm tra..." Margin="8,0,0,0" FontSize="13.5" Foreground="#22324A" MaxWidth="290" TextTrimming="CharacterEllipsis"/>
            <Rectangle Width="1" Height="16" Fill="#D6E0EE" Margin="16,0"/>
            <TextBlock x:Name="TxtPhienBan" Text="Phiên bản" FontSize="13.5" Foreground="#22324A"/>
          </StackPanel>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
            <Button x:Name="BtnHuongDan" Style="{StaticResource Nut}">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE897;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#2F6FE0" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Hướng dẫn" VerticalAlignment="Center"/></StackPanel>
            </Button>
            <Button x:Name="BtnMoThuMuc" Style="{StaticResource Nut}">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xED25;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#2F6FE0" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Mở thư mục làm việc" VerticalAlignment="Center"/></StackPanel>
            </Button>
            <Button x:Name="BtnSaoLuuChan" Style="{StaticResource Nut}">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE753;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#2F6FE0" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Sao lưu dữ liệu" VerticalAlignment="Center"/></StackPanel>
            </Button>
            <Button x:Name="BtnLienHe" Style="{StaticResource Nut}" Margin="0">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE95B;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#2F6FE0" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Liên hệ hỗ trợ" VerticalAlignment="Center"/></StackPanel>
            </Button>
          </StackPanel>
        </Grid>
      </Border>
    </Grid>
  </Grid>
</Window>
'@

# ---- Sinh XAML cho các ô chức năng ----
function Bieu-Tuong($icon, [int]$co, [string]$mau) {
    if ("$icon".StartsWith('PATH:')) {
        $d = "$icon".Substring(5)
        return '<Path Data="' + $d + '" Fill="' + $mau + '" Width="' + $co + '" Height="' + $co + '" Stretch="Uniform" HorizontalAlignment="Center" VerticalAlignment="Center"/>'
    }
    return '<TextBlock Text="&#x' + ([int][char]$icon).ToString('X4') + ';" FontFamily="Segoe MDL2 Assets" FontSize="' + $co + '" Foreground="' + $mau + '" HorizontalAlignment="Center" VerticalAlignment="Center"/>'
}
function XE([string]$s) { return [System.Security.SecurityElement]::Escape($s) }
$sb = New-Object System.Text.StringBuilder
foreach ($c in $TheChinh) {
    [void]$sb.Append(@"
<Border x:Name="$($c.N)" Tag="$($c.Hanh)" Style="{StaticResource OChucNang}" Background="$($c.Nen)">
  <Grid>
    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
    <Border Width="44" Height="44" CornerRadius="12" VerticalAlignment="Center">
      <Border.Background><LinearGradientBrush StartPoint="0,0" EndPoint="1,1"><GradientStop Color="$($c.C1)" Offset="0"/><GradientStop Color="$($c.C2)" Offset="1"/></LinearGradientBrush></Border.Background>
      $(Bieu-Tuong $c.Icon 21 'White')
    </Border>
    <StackPanel Grid.Column="1" Margin="10,0,2,0" VerticalAlignment="Center">
      <TextBlock x:Name="$($c.N)T" Text="$(XE $c.Tieu)" FontSize="14.5" FontWeight="Bold" Foreground="$($c.C2)" TextWrapping="Wrap"/>
      <TextBlock x:Name="$($c.N)M" Text="$(XE $c.MoTa)" FontSize="11.5" Foreground="#5B6B7F" TextWrapping="Wrap" TextTrimming="CharacterEllipsis" MaxHeight="32" Margin="0,2,0,0" LineHeight="16"/>
    </StackPanel>
    <TextBlock Grid.Column="2" Text="&#xE76C;" FontFamily="Segoe MDL2 Assets" FontSize="11" Foreground="$($c.C2)" VerticalAlignment="Center"/>
  </Grid>
</Border>
"@)
}
$xamlText = $xamlText.Replace('@@THECHINH@@', $sb.ToString())
$sb = New-Object System.Text.StringBuilder
foreach ($c in $LoaiVB) {
    [void]$sb.Append(@"
<Border x:Name="$($c.N)" Tag="$(XE $c.Lenh)" Style="{StaticResource OChucNang}" Background="White" Padding="16,14">
  <StackPanel>
    <TextBlock Text="&#xE8A5;" FontFamily="Segoe MDL2 Assets" FontSize="22" Foreground="#2F6FE0"/>
    <TextBlock Text="$(XE $c.Tieu)" FontSize="15" FontWeight="SemiBold" Foreground="#0B2B6B" Margin="0,8,0,2" TextWrapping="Wrap"/>
    <TextBlock Text="$(XE $c.MoTa)" FontSize="12" Foreground="#5B6B7F" TextWrapping="Wrap"/>
  </StackPanel>
</Border>
"@)
}
$xamlText = $xamlText.Replace('@@LOAIVB@@', $sb.ToString())
$sb = New-Object System.Text.StringBuilder
foreach ($c in $TienIch) {
    [void]$sb.Append(@"
<Border x:Name="$($c.N)" Tag="$(XE $c.Hanh)" Style="{StaticResource OChucNang}" Background="White" Padding="18,16">
  <Grid>
    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
    <Border Width="48" Height="48" CornerRadius="12" Background="$($c.Mau)" VerticalAlignment="Top">
      $(Bieu-Tuong $c.Icon 22 'White')
    </Border>
    <StackPanel Grid.Column="1" Margin="14,0,0,0">
      <TextBlock Text="$(XE $c.Tieu)" FontSize="15.5" FontWeight="Bold" Foreground="#0B2B6B" TextWrapping="Wrap"/>
      <TextBlock Text="$(XE $c.MoTa)" FontSize="11.5" Foreground="#5B6B7F" TextWrapping="Wrap" TextTrimming="CharacterEllipsis" MaxHeight="32" Margin="0,2,0,0" LineHeight="16"/>
    </StackPanel>
  </Grid>
</Border>
"@)
}
$xamlText = $xamlText.Replace('@@TIENICH@@', $sb.ToString())
# Ô của các trang Nhiệm vụ, Đơn vị - báo cáo, Kiểm tra (cùng kiểu ô Công cụ tiện ích)
function XAML-OVuong($ds) {
    $b = New-Object System.Text.StringBuilder
    foreach ($c in $ds) {
        [void]$b.Append(@"
<Border x:Name="$($c.N)" Tag="$(XE $c.Hanh)" Style="{StaticResource OChucNang}" Background="White" Padding="18,16">
  <Grid>
    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
    <Border Width="48" Height="48" CornerRadius="12" Background="$($c.Mau)" VerticalAlignment="Top">
      $(Bieu-Tuong $c.Icon 22 'White')
    </Border>
    <StackPanel Grid.Column="1" Margin="14,0,0,0">
      <TextBlock Text="$(XE $c.Tieu)" FontSize="15.5" FontWeight="Bold" Foreground="#0B2B6B" TextWrapping="Wrap"/>
      <TextBlock Text="$(XE $c.MoTa)" FontSize="11.5" Foreground="#5B6B7F" TextWrapping="Wrap" TextTrimming="CharacterEllipsis" MaxHeight="32" Margin="0,2,0,0" LineHeight="16"/>
    </StackPanel>
  </Grid>
</Border>
"@)
    }
    return $b.ToString()
}
# Ô xếp theo nhóm có tiêu đề; giữ thứ tự ô trong từng nhóm
function XAML-NhomO($nhom, $ds) {
    $b = New-Object System.Text.StringBuilder
    foreach ($ten in $nhom.Keys) {
        $o = @(foreach ($n in $nhom[$ten]) { $ds | Where-Object { $_.N -eq $n } })
        if (-not $o.Count) { continue }
        [void]$b.Append('<TextBlock Text="' + (XE $ten) + '" FontSize="13" FontWeight="Bold" Foreground="#0B5F6B" Margin="8,10,6,8"/><UniformGrid Columns="3">' + (XAML-OVuong $o) + '</UniformGrid>')
    }
    return $b.ToString()
}
$xamlText = $xamlText.Replace('@@NVSO@@', (XAML-NhomO $NhomNvSo $NvSo)).Replace('@@NVXA@@', (XAML-NhomO $NhomNvXa $NvXa)).Replace('@@NVUB@@', (XAML-NhomO $NhomNvUb $NvUb))
$xamlText = $xamlText.Replace('@@DV@@', (XAML-OVuong $DonViO)).Replace('@@KT@@', (XAML-NhomO $NhomKT $KiemTraO))

# Ngày tháng trong các câu ví dụ, chữ gợi ý của giao diện: thay bằng thời gian thực khi mở
# phần mềm (từ 1.10.0) - để sang tháng 10, tháng 11 không còn thấy "tháng 9" nằm lại.
$nayGD = Get-Date
$xamlText = $xamlText.Replace('{thang}', [string]$nayGD.Month).Replace('{nam}', [string]$nayGD.Year).Replace('{namthang}', $nayGD.ToString('yyyy-MM')).Replace('{ngay}', ($nayGD.Day.ToString() + '/' + $nayGD.Month.ToString()))


[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'layout.xaml'), $xamlText, (New-Object Text.UTF8Encoding($false)))
$catalog = @{ home=$TheChinh; documents=$LoaiVB; tools=$TienIch; missions=$NvSo; inspections=$KiemTraO; units=$DonViO }
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'catalog.json'), ($catalog | ConvertTo-Json -Depth 12), (New-Object Text.UTF8Encoding($false)))
