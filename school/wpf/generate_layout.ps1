$ICON_BIEUDO = 'PATH:M0,20 L4,20 L4,9 L0,9 Z M7,20 L11,20 L11,3 L7,3 Z M14,20 L18,20 L18,12 L14,12 Z'
$TheChinh = @(
    @{ N = 'TcSoan';    Hanh = 'trang:SoanVanBan'; Nen = '#EEF4FF'; C1 = '#4C8DFF'; C2 = '#1E5FD8'; Icon = [char]0xE8A5; Tieu = 'Soạn văn bản';       MoTa = 'Công văn, tờ trình, thông báo, quyết định...' }
    @{ N = 'TcMau';     Hanh = 'trang:Mau';        Nen = '#EAF8F0'; C1 = '#2DBE78'; C2 = '#0E8A4F'; Icon = [char]0xE8C8; Tieu = 'Mẫu văn bản';        MoTa = 'Mẫu theo NĐ 30/2020 và các quy định mới.' }
    @{ N = 'TcChat';    Hanh = 'chat';             Nen = '#F4EFFF'; C1 = '#A775FF'; C2 = '#7B3FE4'; Icon = [char]0xE8BD; Tieu = 'Trò chuyện AI';      MoTa = 'Hỏi đáp, tư vấn, hỗ trợ công việc quản lý nhà trường.' }
    @{ N = 'TcKeHoach'; Hanh = 'lenh:/ke-hoach';   Nen = '#FFF4EA'; C1 = '#FFA24A'; C2 = '#EF6C00'; Icon = [char]0xE787; Tieu = 'Lập kế hoạch';       MoTa = 'Kế hoạch năm học, tháng, chuyên đề, phân công...' }
    @{ N = 'TcBienBan'; Hanh = 'lenh:/bien-ban';   Nen = '#FFEFF1'; C1 = '#FF6F7A'; C2 = '#E0313F'; Icon = [char]0xE716; Tieu = 'Biên bản họp';       MoTa = 'Họp tổ chuyên môn, Hội đồng sư phạm, họp cha mẹ học sinh.' }
    @{ N = 'TcLich';    Hanh = 'lenh:/lich-tuan';  Nen = '#E8F7F9'; C1 = '#2CC3D6'; C2 = '#00838F'; Icon = [char]0xE823; Tieu = 'Lịch công tác tuần'; MoTa = 'Lịch tuần của Ban giám hiệu, phân công, nhắc việc.' }
    @{ N = 'TcTongHop'; Hanh = 'trang:TongHop';    Nen = '#EDF7EC'; C1 = '#4CAF50'; C2 = '#2E7D32'; Icon = $ICON_BIEUDO;  Tieu = 'Tổng hợp số liệu';   MoTa = 'Thống kê học sinh, kết quả đánh giá, đội ngũ, cơ sở vật chất.' }
    @{ N = 'TcTraCuu';  Hanh = 'trang:TraCuu';     Nen = '#F1F4F8'; C1 = '#7C90A6'; C2 = '#40546B'; Icon = [char]0xE721; Tieu = 'Tra cứu quy định';   MoTa = 'Điều lệ trường, Thông tư, Nghị định, Công văn...' }
    @{ N = 'TcVBDen';   Hanh = 'trang:VanBanDen';  Nen = '#FFF8E7'; C1 = '#FFC943'; C2 = '#E09A00'; Icon = [char]0xED25; Tieu = 'Xử lý văn bản đến';  MoTa = 'Đọc, tóm tắt, trích việc phải làm từ văn bản của Sở, UBND xã...' }
)
$LoaiVB = @(
    @{ N = 'LvCongVan';  Tieu = 'Công văn';          MoTa = 'Mẫu 1.5 - NĐ 30';           Lenh = '/cong-van Soạn công văn' }
    @{ N = 'LvQuyetDinh'; Tieu = 'Quyết định';       MoTa = 'Mẫu 1.2, 1.3 - NĐ 30';      Lenh = '/cong-van Soạn quyết định' }
    @{ N = 'LvKeHoach';  Tieu = 'Kế hoạch';          MoTa = 'Mẫu 1.4 - NĐ 30';           Lenh = '/ke-hoach Lập kế hoạch' }
    @{ N = 'LvBaoCao';   Tieu = 'Báo cáo';           MoTa = 'Mẫu 1.4 - NĐ 30';           Lenh = '/bao-cao Soạn báo cáo' }
    @{ N = 'LvThongBao'; Tieu = 'Thông báo';         MoTa = 'Mẫu 1.4 - NĐ 30';           Lenh = '/cong-van Soạn thông báo' }
    @{ N = 'LvToTrinh';  Tieu = 'Tờ trình';          MoTa = 'Mẫu 1.4 - NĐ 30';           Lenh = '/cong-van Soạn tờ trình' }
    @{ N = 'LvGiayMoi';  Tieu = 'Giấy mời';          MoTa = 'Mẫu 1.7 - NĐ 30';           Lenh = '/cong-van Soạn giấy mời' }
    @{ N = 'LvBienBan';  Tieu = 'Biên bản';          MoTa = 'Mẫu 1.9 - NĐ 30';           Lenh = '/bien-ban Lập biên bản' }
    @{ N = 'LvGioiThieu'; Tieu = 'Giấy giới thiệu';  MoTa = 'Mẫu 1.8 - NĐ 30';           Lenh = '/cong-van Soạn giấy giới thiệu' }
    @{ N = 'LvNghiPhep'; Tieu = 'Giấy nghỉ phép';    MoTa = 'Mẫu 1.10 - NĐ 30';          Lenh = '/cong-van Soạn giấy nghỉ phép' }
    @{ N = 'LvLichTuan'; Tieu = 'Lịch công tác tuần'; MoTa = 'Bảng lịch có phân công';   Lenh = '/lich-tuan Lập lịch công tác tuần' }
    @{ N = 'LvPhieu';    Tieu = 'Phiếu giải quyết văn bản đến'; MoTa = 'Phụ lục IV - NĐ 30'; Lenh = '/van-ban-den Lập phiếu giải quyết văn bản đến' }
)
$TienIch = @(
    @{ N = 'TiVb';        Tieu = 'Lấy văn bản mới (iOffice)'; MoTa = 'Quét sổ văn bản đến trên iOffice đang mở trong Chrome, chia việc theo ngày.'; Icon = [char]0xE896; Mau = '#1E5FD8'; Hanh = 'vb' }
    @{ N = 'TiCsdl';      Tieu = 'Rà dữ liệu CSDL ngành'; MoTa = 'Mở trang web, đăng nhập và tải tệp dữ liệu để xử lý.';   Icon = [char]0xE9D2; Mau = '#9C1F4A'; Hanh = 'csdl-nganh' }
    @{ N = 'TiGhiChep';   Tieu = 'Ghi chép cuộc họp';   MoTa = 'Nói vào micro hoặc ghi âm cả buổi, trợ lý soạn biên bản đúng thể thức.'; Icon = [char]0xE720; Mau = '#C62828'; Hanh = 'ghichep' }
    @{ N = 'TiVnEdu';     Tieu = 'Rà dữ liệu vnEdu';    MoTa = 'Mở trang web, đăng nhập và tải tệp dữ liệu để xử lý.';        Icon = [char]0xE7BE; Mau = '#EF6C00'; Hanh = 'vnedu' }
    @{ N = 'TiVBDen';    Tieu = 'Xử lý văn bản đến';   MoTa = 'Thả file Word, PDF, ảnh vào để tóm tắt và trích việc.';          Icon = [char]0xED25; Mau = '#E09A00'; Hanh = 'trang:VanBanDen' }
    @{ N = 'TiTongHop';   Tieu = 'Tổng hợp số liệu';    MoTa = 'Thống kê từ file Excel: học sinh, kết quả đánh giá, đội ngũ, cơ sở vật chất.'; Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'trang:TongHop' }
    @{ N = 'TiTraCuu';    Tieu = 'Tra cứu quy định';    MoTa = 'Hỏi đáp quy định; danh mục căn cứ pháp lý đã đối chiếu.';            Icon = [char]0xE82D; Mau = '#40546B'; Hanh = 'trang:TraCuu' }
    @{ N = 'TiToCM';      Tieu = 'Hồ sơ tổ chuyên môn'; MoTa = 'Danh sách tổ, văn bản các tổ; góp ý, duyệt hồ sơ tổ.';                Icon = [char]0xE716; Mau = '#E0313F'; Hanh = 'trang:ToChuyenMon' }
    @{ N = 'TiRaSoat';    Tieu = 'Rà soát văn bản';     MoTa = 'Kiểm tra thể thức NĐ 30, căn cứ, số liệu, chính tả; tạo bản đã sửa.'; Icon = [char]0xE73E; Mau = '#0E8A4F'; Hanh = 'rasoat' }
    @{ N = 'TiKTNB';      Tieu = 'Kiểm tra nội bộ';     MoTa = 'Kế hoạch, phiếu dự giờ, biên bản, tổng hợp kết quả kiểm tra.';    Icon = [char]0xE9D5; Mau = '#7B3FE4'; Hanh = 'lenh:/kiem-tra-noi-bo' }
    @{ N = 'TiSHCM';      Tieu = 'Sinh hoạt chuyên môn'; MoTa = 'Kế hoạch, phiếu quan sát, biên bản SHCM theo nghiên cứu bài học.'; Icon = [char]0xE716; Mau = '#E0313F'; Hanh = 'lenh:/shcm' }
    @{ N = 'TiPhanCong';  Tieu = 'Phân công chuyên môn'; MoTa = 'Tính tiết theo định mức, thừa thiếu giờ, dạy thay.';             Icon = [char]0xE8EF; Mau = '#00838F'; Hanh = 'lenh:/phan-cong-chuyen-mon' }
    @{ N = 'TiNamHoc';    Tieu = 'Chuyển năm học mới';  MoTa = 'Lưu trữ năm cũ, cập nhật quy mô, nhân sự, lịch năm học.';           Icon = [char]0xE72C; Mau = '#EF6C00'; Hanh = 'lenh:/nam-hoc-moi' }
    @{ N = 'TiGhiNho';    Tieu = 'Ghi nhớ thông tin';   MoTa = 'Cập nhật thông tin trường, nhân sự, quy ước làm việc.';             Icon = [char]0xE734; Mau = '#40546B'; Hanh = 'lenh:/ghi-nho' }
    @{ N = 'TiXuatWord';  Tieu = 'Xuất Word từ file .md'; MoTa = 'Chọn file .md đã soạn để xuất lại file Word đúng thể thức.';      Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'xuatword' }
    @{ N = 'TiSaoLuu';    Tieu = 'Sao lưu dữ liệu';     MoTa = 'Nén bộ nhớ và toàn bộ văn bản đã soạn ra một file .zip.';          Icon = [char]0xE753; Mau = '#0E8A4F'; Hanh = 'saoluu' }
    @{ N = 'TiDonRac';    Tieu = 'Dọn rác máy tính';    MoTa = 'Xóa tệp tạm, bộ nhớ đệm trình duyệt, báo lỗi cũ cho máy nhẹ hơn.'; Icon = [char]0xE74D; Mau = '#00838F'; Hanh = 'donrac' }
    @{ N = 'TiSuaMay';    Tieu = 'Kiểm tra và sửa máy'; MoTa = 'Chẩn đoán ổ đĩa, bộ nhớ, mạng, virus, lỗi hệ thống; gợi ý và sửa nhanh.'; Icon = [char]0xE7F4; Mau = '#5E35B1'; Hanh = 'suamay' }
    @{ N = 'TiHuongDan';  Tieu = 'Hướng dẫn sử dụng';  MoTa = 'Cách dùng phần mềm, xử lý sự cố thường gặp.';                      Icon = [char]0xE897; Mau = '#7B3FE4'; Hanh = 'huongdan' }
)
# Trang Công tác Đảng (Bí thư, Phó Bí thư đảng ủy, chi bộ trong trường)
$CongTacDang = @(
    @{ N = 'DgSinhHoat';    Tieu = 'Sinh hoạt chi bộ';            MoTa = 'Chuẩn bị nội dung, dự thảo nghị quyết, biên bản sinh hoạt thường kỳ, chuyên đề.';     Icon = [char]0xE716; Mau = '#C62828'; Hanh = 'lenh:/sinh-hoat-chi-bo Chuẩn bị sinh hoạt chi bộ thường kỳ tháng này' }
    @{ N = 'DgNghiQuyet';   Tieu = 'Nghị quyết tháng';            MoTa = 'Nghị quyết lãnh đạo nhiệm vụ chính trị tháng của đảng ủy, chi bộ.';                 Icon = [char]0xE8A5; Mau = '#C62828'; Hanh = 'lenh:/sinh-hoat-chi-bo Soạn nghị quyết tháng' }
    @{ N = 'DgVanBan';      Tieu = 'Văn bản của Đảng';            MoTa = 'Kế hoạch, báo cáo, thông báo, quyết định, tờ trình, công văn theo thể thức của Đảng.'; Icon = [char]0xE7C3; Mau = '#B71C1C'; Hanh = 'lenh:/cong-tac-dang Soạn văn bản của đảng ủy, chi bộ' }
    @{ N = 'DgKiemDiem';    Tieu = 'Kiểm điểm, xếp loại cuối năm'; MoTa = 'Báo cáo kiểm điểm tập thể, bản kiểm điểm cá nhân, tổng hợp đánh giá xếp loại.';      Icon = [char]0xE9D5; Mau = '#E09A00'; Hanh = 'lenh:/dang-vien Kiểm điểm, đánh giá, xếp loại chất lượng tổ chức đảng và đảng viên năm nay' }
    @{ N = 'DgDangVien';    Tieu = 'Công tác đảng viên';          MoTa = 'Phát triển đảng viên, công nhận chính thức, chuyển sinh hoạt, đảng phí.';            Icon = [char]0xE77B; Mau = '#E09A00'; Hanh = 'lenh:/dang-vien Công tác đảng viên' }
    @{ N = 'DgKTGS';        Tieu = 'Kiểm tra, giám sát';          MoTa = 'Chương trình kiểm tra, giám sát năm; kế hoạch, báo cáo kết quả kiểm tra.';           Icon = [char]0xE721; Mau = '#B71C1C'; Hanh = 'lenh:/cong-tac-dang Lập chương trình kiểm tra, giám sát năm' }
    @{ N = 'DgHocTap';      Tieu = 'Học tập nghị quyết, chuyên đề'; MoTa = 'Kế hoạch học tập, quán triệt nghị quyết; chuyên đề học tập và làm theo Bác.';      Icon = [char]0xE7BE; Mau = '#C62828'; Hanh = 'lenh:/cong-tac-dang Kế hoạch học tập, quán triệt nghị quyết và thực hiện chuyên đề năm' }
    @{ N = 'DgChuongTrinh'; Tieu = 'Chương trình công tác năm';   MoTa = 'Chương trình công tác năm, sơ kết 6 tháng, tổng kết năm của đảng ủy, chi bộ.';       Icon = [char]0xE787; Mau = '#E09A00'; Hanh = 'lenh:/cong-tac-dang Xây dựng chương trình công tác năm' }
    @{ N = 'DgTraCuu';      Tieu = 'Tra cứu quy định của Đảng';   MoTa = 'Điều lệ, quy định, hướng dẫn thi hành; trả lời kèm số hiệu, điều khoản.';             Icon = [char]0xE82D; Mau = '#B71C1C'; Hanh = 'lenh:/tra-cuu Tra cứu quy định của Đảng' }
)
# Công tác Đảng (từ 2.8.0): thêm văn bản đầu nhiệm kỳ; trang xếp theo nhóm nhiệm vụ ($NhomDang)
$CongTacDang += @(
    @{ N = 'DgQuyChe';     Tieu = 'Quy chế làm việc của đảng ủy';   MoTa = 'Quy chế làm việc nhiệm kỳ; trách nhiệm đảng ủy, bí thư, phó bí thư, cấp ủy viên.';          Icon = [char]0xE8A5; Mau = '#B71C1C'; Hanh = 'lenh:/cong-tac-dang Quy chế làm việc của đảng ủy' }
    @{ N = 'DgCTToanKhoa'; Tieu = 'Chương trình làm việc toàn khóa'; MoTa = 'Cụ thể hóa nghị quyết đại hội nhiệm kỳ, phân kỳ theo từng năm.';                          Icon = [char]0xE787; Mau = '#C62828'; Hanh = 'lenh:/cong-tac-dang Chương trình làm việc toàn khóa' }
    @{ N = 'DgPhanCong';   Tieu = 'Phân công cấp ủy viên';           MoTa = 'Phân công nhiệm vụ bí thư, phó bí thư, cấp ủy viên theo lĩnh vực, chi bộ.';               Icon = [char]0xE716; Mau = '#E09A00'; Hanh = 'lenh:/cong-tac-dang Phân công nhiệm vụ cấp ủy viên' }
    @{ N = 'DgPhoiHop';    Tieu = 'Quy chế phối hợp';                MoTa = 'Phối hợp giữa đảng ủy với Hiệu trưởng, Đoàn, Đội (Quy định 125-QĐ/TW).';                  Icon = [char]0xE77B; Mau = '#B71C1C'; Hanh = 'lenh:/cong-tac-dang Quy chế phối hợp giữa đảng ủy với Hiệu trưởng, đoàn thể' }
    @{ N = 'DgHoiNghi';    Tieu = 'Hội nghị đảng ủy';                MoTa = 'Chương trình, biên bản, nghị quyết hội nghị đảng ủy thường kỳ.';                             Icon = [char]0xE8BD; Mau = '#C62828'; Hanh = 'lenh:/cong-tac-dang Hội nghị đảng ủy' }
)
$NhomDang = [ordered]@{
    'VĂN BẢN ĐẦU NHIỆM KỲ, ĐẦU NĂM'     = @('DgQuyChe', 'DgCTToanKhoa', 'DgChuongTrinh', 'DgKTGS', 'DgPhanCong', 'DgPhoiHop')
    'HẰNG THÁNG, THƯỜNG XUYÊN'          = @('DgNghiQuyet', 'DgSinhHoat', 'DgHoiNghi', 'DgHocTap')
    'ĐẢNG VIÊN, CUỐI NĂM, VĂN BẢN KHÁC' = @('DgKiemDiem', 'DgDangVien', 'DgVanBan', 'DgTraCuu')
}
# Trang Ban giám hiệu (từ 2.8.0): nhiệm vụ Hiệu trưởng, Phó Hiệu trưởng theo phân công; việc tháng này (viec-can-lam.md)
$BanGiamHieu = @(
    @{ N = 'BgKeHoach';   Tieu = 'Kế hoạch năm học, kế hoạch giáo dục'; MoTa = 'Kế hoạch năm học, kế hoạch giáo dục nhà trường, kế hoạch tháng.';                 Icon = [char]0xE787; Mau = '#1E5FD8'; Hanh = 'lenh:/ke-hoach Kế hoạch năm học, kế hoạch giáo dục nhà trường' }
    @{ N = 'BgBoMay';     Tieu = 'Tổ chức bộ máy, phân công';           MoTa = 'Quyết định thành lập tổ, hội đồng, ban; bổ nhiệm tổ trưởng; phân công nhiệm vụ.';   Icon = [char]0xE716; Mau = '#0E8A4F'; Hanh = 'lenh:/ban-giam-hieu Tổ chức bộ máy, phân công nhiệm vụ' }
    @{ N = 'BgNhanSu';    Tieu = 'Nhân sự, đánh giá viên chức';         MoTa = 'Đánh giá, xếp loại viên chức; đánh giá giáo viên theo chuẩn nghề nghiệp.';          Icon = [char]0xE77B; Mau = '#7B3FE4'; Hanh = 'lenh:/ban-giam-hieu Nhân sự, đánh giá viên chức' }
    @{ N = 'BgTaiChinh';  Tieu = 'Tài chính, tài sản, công khai';       MoTa = 'Dự toán, quy chế chi tiêu nội bộ, quản lý tài sản, công khai.';                     Icon = $ICON_BIEUDO;  Mau = '#E09A00'; Hanh = 'lenh:/ban-giam-hieu Tài chính, tài sản, công khai' }
    @{ N = 'BgDanChu';    Tieu = 'Dân chủ cơ sở, hội nghị viên chức';   MoTa = 'Quy chế thực hiện dân chủ, hội nghị viên chức đầu năm học.';                          Icon = [char]0xE8BD; Mau = '#00838F'; Hanh = 'lenh:/ban-giam-hieu Dân chủ cơ sở, hội nghị viên chức' }
    @{ N = 'BgThiDua';    Tieu = 'Thi đua, khen thưởng';                MoTa = 'Kế hoạch thi đua, hội đồng thi đua, hồ sơ khen thưởng.';                               Icon = [char]0xE734; Mau = '#C62828'; Hanh = 'lenh:/ban-giam-hieu Thi đua, khen thưởng' }
    @{ N = 'BgKiemDinh';  Tieu = 'Bảo đảm chất lượng, chuẩn QG';        MoTa = 'Tự đánh giá, cải tiến chất lượng, minh chứng (Thông tư 57/2026).';                      Icon = [char]0xE73E; Mau = '#2E7D32'; Hanh = 'lenh:/bao-dam-chat-luong' }
    @{ N = 'BgKTNB';      Tieu = 'Kiểm tra nội bộ';                     MoTa = 'Kế hoạch, quyết định, biên bản, báo cáo kiểm tra nội bộ.';                              Icon = [char]0xE9D5; Mau = '#40546B'; Hanh = 'lenh:/kiem-tra-noi-bo Kiểm tra nội bộ trường học' }
    @{ N = 'BgBaoCao';    Tieu = 'Báo cáo cấp trên';                    MoTa = 'Báo cáo đầu năm, sơ kết, tổng kết, báo cáo theo yêu cầu của Sở, UBND xã.';           Icon = [char]0xE8A5; Mau = '#1E5FD8'; Hanh = 'lenh:/bao-cao Báo cáo gửi cấp trên' }
    @{ N = 'BpKHGD';      Tieu = 'Chương trình, kế hoạch giáo dục';     MoTa = 'Kế hoạch giáo dục nhà trường; giao các tổ kế hoạch dạy học theo khối.';               Icon = [char]0xE82D; Mau = '#1E5FD8'; Hanh = 'lenh:/ke-hoach-giao-duc Chương trình, kế hoạch giáo dục' }
    @{ N = 'BpToCM';      Tieu = 'Chỉ đạo tổ chuyên môn';               MoTa = 'Mở trang Tổ chuyên môn: giao việc, theo dõi, góp ý, duyệt hồ sơ các tổ.';           Icon = [char]0xE716; Mau = '#E0313F'; Hanh = 'trang:ToChuyenMon' }
    @{ N = 'BpDanhGiaHS'; Tieu = 'Đánh giá học sinh';                   MoTa = 'Kiểm tra định kỳ, nhận xét, tổng hợp đánh giá theo quy định của cấp học.';            Icon = [char]0xE9D5; Mau = '#7B3FE4'; Hanh = 'lenh:/ban-giam-hieu Đánh giá học sinh' }
    @{ N = 'BpSHCM';      Tieu = 'Sinh hoạt chuyên môn, bồi dưỡng';     MoTa = 'Sinh hoạt chuyên môn cấp trường, bồi dưỡng giáo viên (Công văn 4069).';               Icon = [char]0xE7BE; Mau = '#C62828'; Hanh = 'lenh:/shcm Sinh hoạt chuyên môn, bồi dưỡng giáo viên' }
    @{ N = 'BpPhanCong';  Tieu = 'Phân công chuyên môn, thời khóa biểu'; MoTa = 'Tính tiết theo định mức, thừa thiếu giờ, dạy thay, thời khóa biểu.';              Icon = [char]0xE8EF; Mau = '#00838F'; Hanh = 'lenh:/phan-cong-chuyen-mon Phân công chuyên môn, thời khóa biểu' }
    @{ N = 'BpCSVC';      Tieu = 'Cơ sở vật chất, thiết bị, thư viện';  MoTa = 'Rà soát phòng học, thiết bị dạy học, sách giáo khoa, thư viện, văn hóa đọc.';      Icon = [char]0xE80F; Mau = '#EF6C00'; Hanh = 'lenh:/ban-giam-hieu Cơ sở vật chất, thiết bị, thư viện' }
    @{ N = 'BpBanTru';    Tieu = 'Bán trú, y tế, an toàn trường học';   MoTa = 'Bán trú, y tế học đường, phòng chống tai nạn, bạo lực học đường.';                  Icon = [char]0xE95E; Mau = '#2E7D32'; Hanh = 'lenh:/ban-giam-hieu Bán trú, y tế, an toàn trường học' }
    @{ N = 'BpPhoCap';    Tieu = 'Phổ cập, tuyển sinh, chuyển đổi số';  MoTa = 'Tuyển sinh lớp 1, phổ cập giáo dục tiểu học, hồ sơ số, chuyển đổi số.';            Icon = [char]0xE774; Mau = '#40546B'; Hanh = 'lenh:/ban-giam-hieu Phổ cập giáo dục, tuyển sinh, chuyển đổi số' }
    @{ N = 'BpVBDen';     Tieu = 'Xử lý văn bản đến';                   MoTa = 'Đọc, tóm tắt, trích việc phải làm từ văn bản của Sở, UBND xã.';                      Icon = [char]0xED25; Mau = '#E09A00'; Hanh = 'trang:VanBanDen' }
)
$NhomBGH = [ordered]@{
    'NHIỆM VỤ CỦA HIỆU TRƯỞNG'                     = @('BgKeHoach', 'BgBoMay', 'BgNhanSu', 'BgTaiChinh', 'BgDanChu', 'BgThiDua', 'BgKiemDinh', 'BgKTNB', 'BgBaoCao')
    'NHIỆM VỤ CỦA PHÓ HIỆU TRƯỞNG (THEO PHÂN CÔNG)' = @('BpKHGD', 'BpToCM', 'BpDanhGiaHS', 'BpSHCM', 'BpPhanCong', 'BpCSVC', 'BpBanTru', 'BpPhoCap', 'BpVBDen')
}
# Trang Tổ chuyên môn (từ 2.8.0): nhiệm vụ của tổ (tổ trưởng vào làm) và chỉ đạo của Ban giám hiệu. Hanh phải khác nhau từng ô (Mo-QuyTrinhO tìm ô theo Hanh)
$NhiemVuTo = @(
    @{ N = 'ToKeHoach';  Tieu = 'Kế hoạch hoạt động của tổ';     MoTa = 'Kế hoạch năm học, kế hoạch tháng của tổ chuyên môn.';                                      Icon = [char]0xE787; Mau = '#1E5FD8'; Hanh = 'lenh:/to-chuyen-mon Kế hoạch hoạt động của tổ' }
    @{ N = 'ToSHCM';     Tieu = 'Kế hoạch sinh hoạt chuyên môn'; MoTa = 'Sinh hoạt chuyên môn theo nghiên cứu bài học (Công văn 4069), phân công dạy minh họa.';   Icon = [char]0xE716; Mau = '#E0313F'; Hanh = 'lenh:/shcm Kế hoạch sinh hoạt chuyên môn của tổ' }
    @{ N = 'ToBienBan';  Tieu = 'Biên bản sinh hoạt tổ';         MoTa = 'Biên bản sinh hoạt tổ định kỳ (ít nhất 2 tuần một lần), sinh hoạt chuyên đề.';              Icon = [char]0xE8A5; Mau = '#0E8A4F'; Hanh = 'lenh:/to-chuyen-mon Biên bản sinh hoạt tổ' }
    @{ N = 'ToDeKT';     Tieu = 'Ma trận và đề kiểm tra';        MoTa = 'Ma trận, đề, đáp án, hướng dẫn chấm đúng khung của cấp học; tự kiểm đề.';                   Icon = [char]0xE9D5; Mau = '#7B3FE4'; Hanh = 'lenh:/de-kiem-tra Ma trận và đề kiểm tra định kỳ' }
    @{ N = 'ToDotKT';    Tieu = 'Đợt kiểm tra định kỳ';          MoTa = 'Kế hoạch đợt kiểm tra, phân công ra đề, phản biện, biên bản duyệt đề.';                     Icon = [char]0xE787; Mau = '#5C3D99'; Hanh = 'lenh:/dot-kiem-tra Tổ chức đợt kiểm tra định kỳ' }
    @{ N = 'ToPhanTich'; Tieu = 'Phân tích kết quả kiểm tra';    MoTa = 'Phổ điểm, so sánh các lớp, độ khó và độ phân biệt từng câu.';                                Icon = $ICON_BIEUDO;  Mau = '#0E8A4F'; Hanh = 'lenh:/phan-tich-ket-qua Phân tích kết quả bài kiểm tra' }
    @{ N = 'ToKHDH';     Tieu = 'Kế hoạch giáo dục môn học';     MoTa = 'Kế hoạch dạy học các môn theo Phụ lục 2 Công văn 2345, lấy từ bộ tham khảo dùng chung.';    Icon = [char]0xE82D; Mau = '#00838F'; Hanh = 'lenh:/khgd-mon-hoc Kế hoạch giáo dục môn học' }
    @{ N = 'ToDuGio';    Tieu = 'Dự giờ, góp ý bài dạy';         MoTa = 'Phiếu dự giờ quan sát học sinh, góp ý kế hoạch bài dạy (không xếp loại giờ dạy).';        Icon = [char]0xE890; Mau = '#EF6C00'; Hanh = 'lenh:/to-chuyen-mon Dự giờ, góp ý bài dạy' }
    @{ N = 'ToChuyenDe'; Tieu = 'Chuyên đề, bồi dưỡng';          MoTa = 'Chuyên đề của tổ, sinh hoạt cụm chuyên môn, bồi dưỡng học sinh.';                          Icon = [char]0xE7BE; Mau = '#C62828'; Hanh = 'lenh:/to-chuyen-mon Chuyên đề, bồi dưỡng' }
    @{ N = 'ToBaoCao';   Tieu = 'Báo cáo của tổ';                MoTa = 'Báo cáo hoạt động của tổ tháng, học kì, năm học.';                                          Icon = $ICON_BIEUDO;  Mau = '#2E7D32'; Hanh = 'lenh:/to-chuyen-mon Báo cáo của tổ' }
    @{ N = 'ToDanhGia';  Tieu = 'Đánh giá giáo viên của tổ';     MoTa = 'Tổ góp ý, tổng hợp đánh giá giáo viên theo chuẩn nghề nghiệp (Thông tư 30/2026).';          Icon = [char]0xE77B; Mau = '#40546B'; Hanh = 'lenh:/to-chuyen-mon Đánh giá giáo viên của tổ' }
)
$ChiDaoTo = @(
    @{ N = 'CdDanhSach'; Tieu = 'Danh sách tổ chuyên môn';       MoTa = 'Cập nhật tổ, tổ trưởng, tổ phó, thành viên, lịch sinh hoạt.';                                 Icon = [char]0xE716; Mau = '#1E5FD8'; Hanh = 'lenh:/chi-dao-to Danh sách tổ chuyên môn' }
    @{ N = 'CdGiaoViec'; Tieu = 'Giao nhiệm vụ cho tổ';          MoTa = 'Nhiệm vụ chuyên môn tháng, hồ sơ và hạn nộp; tin nhắc các tổ.';                               Icon = [char]0xE724; Mau = '#0E8A4F'; Hanh = 'lenh:/chi-dao-to Giao nhiệm vụ cho tổ' }
    @{ N = 'CdTheoDoi';  Tieu = 'Theo dõi hồ sơ các tổ';         MoTa = 'Đối chiếu hồ sơ phải nộp: tổ nào đã nộp, chưa nộp, quá hạn.';                                  Icon = [char]0xE9D5; Mau = '#E09A00'; Hanh = 'lenh:/chi-dao-to Theo dõi hồ sơ các tổ' }
    @{ N = 'CdDuyet';    Tieu = 'Góp ý, duyệt hồ sơ tổ';         MoTa = 'Rà soát kế hoạch, đề kiểm tra của tổ; lập phiếu góp ý, ý kiến duyệt.';                         Icon = [char]0xE73E; Mau = '#7B3FE4'; Hanh = 'lenh:/chi-dao-to Góp ý, duyệt hồ sơ tổ' }
    @{ N = 'CdTongHop';  Tieu = 'Tổng hợp báo cáo các tổ';       MoTa = 'Gộp báo cáo của các tổ thành báo cáo chuyên môn của trường.';                                  Icon = $ICON_BIEUDO;  Mau = '#00838F'; Hanh = 'lenh:/chi-dao-to Tổng hợp báo cáo các tổ' }
    @{ N = 'CdLich';     Tieu = 'Lịch sinh hoạt các tổ';         MoTa = 'Lịch sinh hoạt tổ, phân công Ban giám hiệu dự; đưa vào lịch công tác.';                       Icon = [char]0xE787; Mau = '#C62828'; Hanh = 'lenh:/chi-dao-to Lịch sinh hoạt các tổ' }
)
# Bấm một ô quy trình (lenh:) chỉ CHỌN quy trình: mở việc mới trong Trò chuyện, hiện các gợi ý dưới đây, trợ lý chờ thầy/cô ghi việc cụ thể
# rồi mới làm (từ 2.7.8 - trước đây bấm ô là chạy ngay cả bộ văn bản, rất tốn lượt dùng). {thang} tháng này, {quy} quý, {nam} năm, {namhoc} năm học
$GoiYO = @{
    TcKeHoach     = @('Kế hoạch tháng {thang}', 'Kế hoạch năm học {namhoc}', 'Kế hoạch chuyên đề: (ghi tên chuyên đề)')
    TcBienBan     = @('Biên bản họp Hội đồng sư phạm tháng {thang}', 'Biên bản họp tổ chuyên môn: (ghi tên tổ)', 'Biên bản họp cha mẹ học sinh lớp: (ghi lớp)')
    TcLich        = @('Lịch công tác tuần này', 'Lịch công tác tuần sau')
    TiKTNB        = @('Kế hoạch kiểm tra nội bộ năm học {namhoc}', 'Kế hoạch kiểm tra nội bộ tháng {thang}', 'Phiếu dự giờ', 'Báo cáo kết quả kiểm tra nội bộ tháng {thang}')
    TiSHCM        = @('Kế hoạch sinh hoạt chuyên môn theo nghiên cứu bài học tháng {thang}', 'Phiếu quan sát giờ dạy minh họa', 'Biên bản sinh hoạt chuyên môn tổ: (ghi tên tổ)')
    TiPhanCong    = @('Phân công chuyên môn năm học {namhoc} (đính kèm danh sách giáo viên)', 'Tính thừa, thiếu giờ của giáo viên', 'Phân công dạy thay cho giáo viên nghỉ: (ghi tên, số ngày)')
    TiNamHoc      = @('Chuyển bộ nhớ sang năm học {namhoc}')
    TiGhiNho      = @('Ghi nhớ: (ghi điều cần nhớ)')
    DgSinhHoat    = @('Đề cương điều hành sinh hoạt chi bộ thường kỳ tháng {thang}', 'Dự thảo nghị quyết tháng {thang}', 'Khung biên bản sinh hoạt chi bộ tháng {thang}', 'Phiếu tự chấm điểm chất lượng buổi sinh hoạt', 'Kế hoạch sinh hoạt chuyên đề quý {quy}')
    DgNghiQuyet   = @('Dự thảo nghị quyết tháng {thang} của chi bộ: (ghi tên chi bộ)', 'Hoàn thiện nghị quyết tháng {thang} từ ghi chép buổi sinh hoạt (dán ghi chép vào đây)')
    DgVanBan      = @('Kế hoạch của đảng ủy về: (ghi nội dung)', 'Báo cáo gửi Đảng ủy xã về: (ghi nội dung)', 'Thông báo phân công nhiệm vụ cấp ủy viên', 'Tờ trình đề nghị Đảng ủy xã: (ghi nội dung)')
    DgKiemDiem    = @('Báo cáo kiểm điểm tập thể chi bộ năm {nam}', 'Khung bản kiểm điểm cá nhân đảng viên năm {nam}', 'Tổng hợp đánh giá, xếp loại đảng viên năm {nam}')
    DgDangVien    = @('Danh mục hồ sơ đề nghị kết nạp đảng viên', 'Hồ sơ công nhận đảng viên chính thức cho đồng chí: (ghi họ tên)', 'Hướng dẫn chuyển sinh hoạt đảng', 'Bảng theo dõi đảng phí tháng {thang}')
    DgKTGS        = @('Chương trình kiểm tra, giám sát năm {nam}', 'Kế hoạch kiểm tra về: (ghi nội dung)', 'Báo cáo kết quả kiểm tra, giám sát')
    DgHocTap      = @('Kế hoạch học tập, quán triệt nghị quyết: (ghi tên nghị quyết)', 'Kế hoạch thực hiện chuyên đề học tập và làm theo Bác năm {nam}')
    DgChuongTrinh = @('Chương trình công tác năm {nam}', 'Báo cáo sơ kết 6 tháng đầu năm {nam}', 'Báo cáo tổng kết năm {nam}')
    DgTraCuu      = @('Điều lệ Đảng quy định thế nào về: (ghi câu hỏi)')
    ToKeHoach     = @('Kế hoạch hoạt động tháng {thang} của tổ', 'Kế hoạch hoạt động năm học {namhoc} của tổ')
    ToSHCM        = @('Kế hoạch sinh hoạt chuyên môn theo nghiên cứu bài học tháng {thang}', 'Phân công dạy minh họa, phiếu quan sát học sinh')
    ToBienBan     = @('Biên bản sinh hoạt tổ ngày: (ghi ngày; dán ghi chép buổi sinh hoạt vào đây)', 'Khung biên bản sinh hoạt tổ tháng {thang}')
    ToDeKT        = @('Đề kiểm tra cuối học kì I môn Toán lớp: (ghi lớp)', 'Đề kiểm tra cuối học kì I môn Tiếng Việt lớp: (ghi lớp)', 'Ma trận đề kiểm tra môn: (ghi môn, lớp, kỳ kiểm tra)', 'Kiểm lại bộ đề đã soạn: (ghi môn, lớp, kỳ)')
    ToDotKT       = @('Kế hoạch tổ chức kiểm tra cuối học kì I năm học {namhoc}', 'Bảng phân công ra đề, phản biện, duyệt đề', 'Biên bản họp tổ duyệt đề kiểm tra', 'Phiếu phản biện đề môn: (ghi môn, lớp)')
    ToPhanTich    = @('Phân tích kết quả kiểm tra môn: (ghi môn, lớp, kỳ; đính kèm bảng điểm)', 'So sánh kết quả các lớp trong khối: (ghi khối)', 'Nạp câu hỏi của đề đã kiểm tra vào ngân hàng câu hỏi')
    ToKHDH        = @('Kế hoạch dạy học cả khối lớp: (ghi lớp) năm học {namhoc}', 'Kế hoạch dạy học môn: (ghi môn) lớp: (ghi lớp)')
    ToDuGio       = @('Phiếu dự giờ quan sát học sinh (nghiên cứu bài học)', 'Góp ý kế hoạch bài dạy (đính kèm file kế hoạch bài dạy)')
    ToChuyenDe    = @('Kế hoạch chuyên đề của tổ: (ghi tên chuyên đề)', 'Kế hoạch sinh hoạt cụm chuyên môn', 'Kế hoạch bồi dưỡng học sinh năng khiếu, hỗ trợ học sinh gặp khó khăn')
    ToBaoCao      = @('Báo cáo hoạt động của tổ tháng {thang}', 'Báo cáo sơ kết học kì I của tổ')
    ToDanhGia     = @('Tổng hợp đánh giá giáo viên của tổ theo chuẩn nghề nghiệp năm học {namhoc}')
    CdDanhSach    = @('Cập nhật danh sách tổ: (dán quyết định thành lập tổ hoặc ghi tổ, tổ trưởng, tổ phó, thành viên)')
    CdGiaoViec    = @('Thông báo nhiệm vụ chuyên môn tháng {thang} gửi các tổ', 'Tin nhắc các tổ nộp hồ sơ tháng {thang}', 'Giao cho tổ: (ghi tổ, việc, hạn)')
    CdTheoDoi     = @('Tổ nào chưa nộp hồ sơ tháng {thang}?')
    CdDuyet       = @('Góp ý kế hoạch tháng {thang} của các tổ', 'Duyệt đề kiểm tra của tổ: (ghi tổ, môn, lớp)')
    CdTongHop     = @('Tổng hợp báo cáo chuyên môn tháng {thang} từ báo cáo các tổ')
    CdLich        = @('Lịch sinh hoạt các tổ tháng {thang}, phân công Ban giám hiệu dự')
    DgQuyChe      = @('Quy chế làm việc của đảng ủy nhiệm kỳ 2025 - 2030', 'Quyết định ban hành quy chế làm việc của đảng ủy')
    DgCTToanKhoa  = @('Chương trình làm việc toàn khóa nhiệm kỳ 2025 - 2030 (đính kèm nghị quyết đại hội)')
    DgPhanCong    = @('Quyết định phân công nhiệm vụ cấp ủy viên: (ghi người, lĩnh vực)')
    DgPhoiHop     = @('Quy chế phối hợp giữa đảng ủy với Hiệu trưởng', 'Quy chế phối hợp giữa đảng ủy với Đoàn, Đội')
    DgHoiNghi     = @('Chương trình hội nghị đảng ủy tháng {thang}', 'Biên bản hội nghị đảng ủy (dán ghi chép vào đây)')
    BgKeHoach     = @('Kế hoạch năm học {namhoc}', 'Kế hoạch giáo dục nhà trường năm học {namhoc} (Phụ lục 1 Công văn 2345)', 'Kế hoạch tháng {thang}')
    BgBoMay       = @('Quyết định thành lập tổ chuyên môn năm học {namhoc}', 'Quyết định thành lập hội đồng: (ghi tên hội đồng)', 'Quyết định phân công nhiệm vụ Ban giám hiệu')
    BgNhanSu      = @('Kế hoạch đánh giá, xếp loại viên chức năm học {namhoc}', 'Kế hoạch đánh giá giáo viên theo chuẩn nghề nghiệp', 'Bố trí, phân công nhân sự: (ghi nội dung)')
    BgTaiChinh    = @('Quy chế chi tiêu nội bộ (đính kèm quy chế cũ, dự toán)', 'Thông báo công khai: (ghi nội dung)', 'Kế hoạch kiểm kê tài sản')
    BgDanChu      = @('Kế hoạch tổ chức hội nghị viên chức năm học {namhoc}', 'Quy chế thực hiện dân chủ trong nhà trường')
    BgThiDua      = @('Kế hoạch phát động thi đua năm học {namhoc}', 'Quyết định thành lập Hội đồng thi đua, khen thưởng')
    BgKiemDinh    = @('Quyết định thành lập Hội đồng tự đánh giá năm học {namhoc}', 'Kế hoạch tự đánh giá năm học {namhoc}', 'Kế hoạch cải tiến chất lượng năm học {namhoc}', 'Báo cáo tự đánh giá năm học {namhoc}', 'Trường cần làm gì để đạt chuẩn quốc gia Mức độ 2?')
    BgKTNB        = @('Kế hoạch kiểm tra nội bộ năm học {namhoc}', 'Kế hoạch kiểm tra nội bộ tháng {thang}')
    BgBaoCao      = @('Báo cáo đầu năm học {namhoc}', 'Báo cáo tháng {thang}', 'Báo cáo theo văn bản yêu cầu (đính kèm văn bản)')
    BpKHGD        = @('Kế hoạch giáo dục nhà trường năm học {namhoc}', 'Giao các tổ xây dựng kế hoạch dạy học theo khối (Phụ lục 2)')
    BpDanhGiaHS   = @('Kế hoạch kiểm tra định kỳ cuối học kì I', 'Hướng dẫn giáo viên đánh giá, nhận xét học sinh theo Thông tư 27/2020', 'Tổng hợp kết quả đánh giá học sinh (đính kèm file)')
    BpSHCM        = @('Kế hoạch sinh hoạt chuyên môn cấp trường tháng {thang}', 'Kế hoạch bồi dưỡng giáo viên năm học {namhoc}')
    BpPhanCong    = @('Phân công chuyên môn năm học {namhoc} (đính kèm danh sách giáo viên)', 'Thời khóa biểu: (ghi yêu cầu)')
    BpCSVC        = @('Kế hoạch rà soát cơ sở vật chất, thiết bị năm học {namhoc}', 'Kế hoạch phát triển văn hóa đọc, thư viện')
    BpBanTru      = @('Kế hoạch tổ chức bán trú năm học {namhoc}', 'Kế hoạch y tế trường học', 'Kế hoạch bảo đảm an toàn trường học')
    BpPhoCap      = @('Kế hoạch tuyển sinh lớp 1', 'Báo cáo phổ cập giáo dục tiểu học', 'Kế hoạch chuyển đổi số năm học {namhoc}')
}
# ----------------------------------------------------------------------------
# Gợi ý ở trang Trò chuyện AI (bấm là điền vào ô hỏi, KHÔNG tự chạy - từ 2.20.0)
# Thứ tự: việc nhẹ, làm được ngay khi máy mới cài -> soạn một văn bản -> việc
# cần có sẵn văn bản, số liệu. Không để việc nặng (slide, bảng tính tổng hợp)
# lên đầu: chạy lâu, tốn lượt dùng, mà lúc đầu chưa có văn bản, số liệu nào.
# Gợi ý đổi theo chức danh (Ban giám hiệu / tổ trưởng) và theo cấp học.
# ----------------------------------------------------------------------------
function Lay-GoiYChat {
    $cap = ''; try { $cap = Doc-CapHoc } catch {}
    $traCuu = switch ($cap) {
        'mn'   { 'Quy định hiện hành về đánh giá sự phát triển của trẻ' }
        'thcs' { 'Quy định hiện hành về đánh giá học sinh trung học cơ sở' }
        'th'   { 'Quy định hiện hành về đánh giá học sinh tiểu học' }
        default { 'Quy định hiện hành về đánh giá học sinh' }
    }
    if (La-ToTruong) {
        $chuyenMon = $(if ($cap -eq 'mn') { 'Kế hoạch giáo dục của khối: (ghi khối)' } else { 'Ma trận và đề kiểm tra: (ghi môn, lớp, kỳ kiểm tra)' })
        return @(
            'Việc tháng {thang} của tổ chuyên môn',
            'Kế hoạch hoạt động tháng {thang} của tổ',
            'Kế hoạch sinh hoạt chuyên môn tháng {thang}',
            $traCuu,
            $chuyenMon,
            'Biên bản sinh hoạt tổ (dán ghi chép buổi sinh hoạt vào đây)',
            'Tóm tắt văn bản đến mới nhất',
            'Làm slide từ báo cáo của tổ đã soạn'
        )
    }
    $hopHoiDong = $(if ($cap -eq 'mn') { 'Soạn thông báo họp hội đồng nhà trường' } else { 'Soạn thông báo họp Hội đồng sư phạm' })
    return @(
        'Việc tháng {thang} của Ban giám hiệu',
        $traCuu,
        $hopHoiDong,
        'Kế hoạch tháng {thang} của trường',
        'Kế hoạch kiểm tra nội bộ tháng {thang}',
        'Chuẩn bị nội dung sinh hoạt chi bộ tháng {thang}',
        'Tóm tắt văn bản đến mới nhất',
        'Làm slide từ báo cáo đã soạn'
    )
}

# ============================================================================
# 2. Giao diện XAML
# ============================================================================
$xamlText = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Trợ lý Quản trị trường học" Width="1360" Height="860" MinWidth="1000" MinHeight="640"
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
              <Trigger Property="IsChecked" Value="True"><Setter TargetName="Bd" Property="Background" Value="White"/><Setter Property="Foreground" Value="#0B2B6B"/><Setter Property="FontWeight" Value="SemiBold"/></Trigger>
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
          <GradientStop Color="#123A86" Offset="0"/>
          <GradientStop Color="#0B2B6B" Offset="0.55"/>
          <GradientStop Color="#08204F" Offset="1"/>
        </LinearGradientBrush>
      </Border.Background>
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <!-- Họa tiết chấm trắng trên nền xanh navy -->
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
            <TextBlock Text="QUẢN TRỊ TRƯỜNG HỌC" FontSize="12" FontWeight="Bold" Foreground="White" Margin="0,-1,0,0"/>
            <TextBlock Text="Đồng hành cùng nhà trường" FontSize="10" Foreground="#B9C9EA" Margin="0,4,0,0"/>
          </StackPanel>
        </StackPanel>
        <ScrollViewer x:Name="CuonMenu" Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
          <StackPanel x:Name="DsMenu" Margin="14,0,14,8">
            <RadioButton x:Name="NavTrangChu"    Style="{StaticResource Nav}" Tag="&#xE80F;" Content="Trang chủ" IsChecked="True"/>
            <RadioButton x:Name="NavNhiemVu"     Style="{StaticResource Nav}" Tag="&#xE8F1;" Content="Việc của tôi"/>
            <RadioButton x:Name="NavTroChuyen"   Style="{StaticResource Nav}" Tag="&#xE8BD;" Content="Trò chuyện AI"/>
            <RadioButton x:Name="NavBanGiamHieu" Style="{StaticResource Nav}" Tag="&#xE77B;" Content="Ban giám hiệu"/>
            <RadioButton x:Name="NavSoanVanBan"  Style="{StaticResource Nav}" Tag="&#xE8A5;" Content="Soạn văn bản"/>
            <RadioButton x:Name="NavCongViec"    Style="{StaticResource Nav}" Tag="&#xE787;" Content="Công việc và lịch"/>
            <RadioButton x:Name="NavThuVien"     Style="{StaticResource Nav}" Tag="&#xED25;" Content="Thư viện văn bản"/>
            <RadioButton x:Name="NavCongTacDang" Style="{StaticResource Nav}" Tag="&#xE7C1;" Content="Công tác Đảng"/>
            <RadioButton x:Name="NavTienIch"     Style="{StaticResource Nav}" Tag="&#xE90F;" Content="Công cụ tiện ích"/>
            <RadioButton x:Name="NavCaiDat"      Style="{StaticResource Nav}" Tag="&#xE713;" Content="Cài đặt"/>
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
          <TextBlock Text="Vì học sinh" FontFamily="Segoe Script" FontSize="20" Foreground="White" Margin="36,26,0,0" RenderTransformOrigin="0,0">
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
          <TextBlock Text="Trợ lý Quản trị trường học" FontSize="26" FontWeight="Bold" Foreground="#0B2B6B" TextTrimming="CharacterEllipsis"/>
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
              <TextBlock x:Name="TxtTenNguoiDung" Text="Thầy/cô" FontSize="15" FontWeight="SemiBold" Foreground="#0B2B6B" TextTrimming="CharacterEllipsis"/>
              <TextBlock x:Name="TxtChucVu" Text="Ban giám hiệu" FontSize="12.5" Foreground="#5B6B7F" TextTrimming="CharacterEllipsis"/>
            </StackPanel>
            <TextBlock Text="&#xE70D;" FontFamily="Segoe MDL2 Assets" FontSize="12" Foreground="#40546B" VerticalAlignment="Center"/>
          </StackPanel>
          <Border.ContextMenu>
            <ContextMenu>
              <MenuItem x:Name="MnKhaiBao" Header="Khai báo thông tin trường"/>
              <MenuItem x:Name="MnThongTin" Header="Thông tin trường và bộ nhớ"/>
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
                        <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE77B;" FontFamily="Segoe MDL2 Assets" FontSize="14" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Khai báo thông tin trường" VerticalAlignment="Center"/></StackPanel>
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
                  <TextBlock Text="Đoàn kết một mái trường" FontFamily="Segoe Script" FontSize="13" FontWeight="Bold" Foreground="#14418C" HorizontalAlignment="Right"/>
                  <TextBlock Text="Tận tâm vì học sinh thân yêu!" FontFamily="Segoe Script" FontSize="13" FontWeight="Bold" Foreground="#14418C" HorizontalAlignment="Right" Margin="0,2,0,0"/>
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
              <TextBlock x:Name="GoiYYChinh" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ví dụ: tờ trình gửi UBND xã đề nghị hỗ trợ sửa mái nhà lớp học Phân hiệu, dự toán 45 triệu, cần trước 30/9 (Enter để gửi, Shift+Enter xuống dòng)"/>
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
                    <TextBlock Text="Chọn file Word/PDF (dự thảo của tổ, của giáo viên, văn bản cũ) để kiểm tra thể thức, căn cứ, số liệu, chính tả và tạo bản đã sửa." FontSize="13" Foreground="#5B6B7F" TextWrapping="Wrap" Margin="0,4,0,0"/>
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
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Các mẫu trình bày theo Phụ lục III Nghị định 30/2020/NĐ-CP. Muốn dùng mẫu riêng của trường: chép file vào thư mục mẫu riêng (07_MAU_RIENG), phần mềm sẽ ưu tiên mẫu đó và không bị ghi đè khi cập nhật. Trường có cách làm riêng một việc: nói với trợ lý &quot;ghi lại thành quy trình riêng&quot;, hoặc tự đặt tệp .md vào thư mục quy trình riêng."/>
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
            <Button x:Name="BtnQuyTrinhRieng" Style="{StaticResource Nut}" Content="Quy trình riêng của trường" ToolTip="Mở thư mục chứa các quy trình riêng - mỗi tệp .md là một lệnh của trợ lý"/>
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
              <TextBlock Style="{StaticResource MoTaTrang}" Margin="0,4,0,0" Text="Giao việc như nhắn tin - giao được 3 việc cùng lúc. Trợ lý tự đọc bộ nhớ trường, làm đến khi xong và gửi lại file Word. Chữ nhỏ thì bấm A+; cần đọc kỹ thì bấm Phóng to (F11) hoặc “Đọc cửa sổ lớn” dưới mỗi câu trả lời."/>
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
                  <TextBlock x:Name="TxtChaoChat" Text="Thầy/cô cần em giúp việc gì hôm nay?" FontSize="21" FontWeight="Bold" Foreground="#0B2B6B" HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap" Margin="0,14,0,6"/>
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
            <!-- Quy trình chọn từ ô chức năng: chưa gửi, chờ thầy/cô ghi việc cụ thể (tro-chuyen.ps1: Ve-QuyTrinh) -->
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
            <StackPanel Orientation="Horizontal" VerticalAlignment="Bottom">
              <Button x:Name="BtnDinhKem" Style="{StaticResource Nut}" Height="48" Padding="14,0" ToolTip="Đính kèm file (Word, PDF, Excel, ảnh) - chụp màn hình rồi Ctrl+V vào ô nhập cũng được">
                <TextBlock Text="&#xE723;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#2F6FE0"/>
              </Button>
              <Button x:Name="BtnNoiChat" Style="{StaticResource Nut}" Height="48" Padding="14,0" Margin="8,0,0,0" ToolTip="Nói thay cho gõ: bật Gõ bằng giọng nói của Windows (phím Windows + H) vào ô nhập">
                <TextBlock Text="&#xE720;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#C62828"/>
              </Button>
            </StackPanel>
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
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Việc cần làm của thầy/cô (trợ lý cũng đọc và ghi vào danh sách này) và các hạn xử lý phát sinh từ văn bản đến."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="150"/><ColumnDefinition Width="90"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <DatePicker x:Name="DpNgayViec" FontSize="14" VerticalContentAlignment="Center" Height="40" Margin="0,0,10,0"/>
            <Grid Grid.Column="1" Height="40" Margin="0,0,10,0">
              <TextBox x:Name="TxtGioViec" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYGio" Style="{StaticResource GoiY}" Text="08:00"/>
            </Grid>
            <Grid Grid.Column="2" Height="40" Margin="0,0,10,0">
              <TextBox x:Name="TxtNoiDungViec" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYViec" Style="{StaticResource GoiY}" Text="Nội dung công việc, ví dụ: Duyệt kế hoạch tổ chuyên môn tháng {thang}"/>
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
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Đưa file Excel/CSV (danh sách học sinh, kết quả đánh giá, đội ngũ, thời khóa biểu...) vào đây, chọn file (giữ Ctrl để chọn nhiều file), ghi yêu cầu cần tổng hợp gì rồi bấm Giao việc tổng hợp. Trợ lý chỉ đưa số liệu tổng hợp vào báo cáo, không lưu danh sách học sinh vào bộ nhớ."/>
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
                  <TextBlock x:Name="GoiYYeuCauTH" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,9,14,0" TextWrapping="Wrap" Text="Ghi rõ cần tổng hợp gì. Ví dụ: tỷ lệ học sinh hoàn thành tốt từng môn theo khối, so sánh với cuối năm học trước, lập bảng và nhận xét để đưa vào báo cáo sơ kết."/>
                </Grid>
                <WrapPanel x:Name="WpGoiYTH" Margin="0,8,0,0"/>
              </StackPanel>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="5" Margin="0,12,0,0">
            <Button x:Name="BtnTongHopFile" Style="{StaticResource NutChinh}" Content="Giao việc tổng hợp"/>
            <Button x:Name="BtnPhanCongFile" Style="{StaticResource Nut}" Content="Phân công chuyên môn từ file này"/>
            <Button x:Name="BtnMoDuLieu" Style="{StaticResource Nut}" Content="Mở thư mục dữ liệu"/>
          </WrapPanel>
        </Grid>

        <!-- ========== TRA CỨU ========== -->
        <Grid x:Name="PgTraCuu" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang6" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Công cụ tiện ích" Margin="0,0,14,0" ToolTip="Chuyển sang Công cụ tiện ích"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Tra cứu quy định" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Hỏi về Điều lệ trường, đánh giá học sinh, chế độ làm việc giáo viên, thi đua, văn thư... Trợ lý trả lời kèm căn cứ và chỉ dùng số hiệu văn bản có trong danh mục đã đối chiếu dưới đây."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <Grid Height="44" Margin="0,0,10,0">
              <TextBox x:Name="TxtCauHoi" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYCauHoi" Style="{StaticResource GoiY}" Text="Ví dụ: Giáo viên tiểu học dạy bao nhiêu tiết một tuần? Tổ trưởng được giảm mấy tiết?"/>
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
            <Button x:Name="BtnCanCuTruong" Style="{StaticResource Nut}" Content="Căn cứ của Sở, xã, trường"/>
          </WrapPanel>
        </Grid>

        <!-- ========== THƯ VIỆN VĂN BẢN ========== -->
        <Grid x:Name="PgThuVien" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <TextBlock Text="Thư viện văn bản" Style="{StaticResource TieuDeTrang}"/>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Toàn bộ văn bản trợ lý đã soạn và văn bản đến, dữ liệu thầy/cô đã đưa vào. Bấm đúp để mở file."/>
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

        <!-- ========== CÔNG TÁC ĐẢNG ========== -->
        <ScrollViewer x:Name="PgCongTacDang" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Công tác Đảng" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Dành cho Bí thư, Phó Bí thư đảng ủy, chi bộ trong trường. Văn bản soạn theo thể thức văn bản của Đảng, lưu ở thư mục 10_CONG_TAC_DANG. Không đưa tài liệu mật, tài liệu lưu hành nội bộ vào trợ lý."/>
            <Grid Margin="6,0,6,14">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel>
                    <TextBlock Text="Tổ chức Đảng của trường" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                    <TextBlock x:Name="TxtToChucDang" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                  </StackPanel>
                  <StackPanel Grid.Column="1" VerticalAlignment="Top" Margin="16,0,0,0">
                    <Button x:Name="BtnKhaiBaoDang" Style="{StaticResource NutChinh}" Content="Khai báo tổ chức Đảng" Margin="0,0,0,8"/>
                    <Button x:Name="BtnDsDangVien" Style="{StaticResource Nut}" Content="Danh sách đảng viên" Margin="0,0,0,8"/>
                    <Button x:Name="BtnToChucDang" Style="{StaticResource Nut}" Content="Cấp ủy, chi bộ, lịch sinh hoạt" Margin="0"/>
                  </StackPanel>
                </Grid>
              </Border>
            </Grid>
            <Grid Height="84" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhDang" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhDang" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi, Shift+Enter xuống dòng). Hoặc ghi vài ý chính rồi bấm một ô việc bên dưới. Ví dụ: tờ trình đề nghị Đảng ủy xã kết nạp đảng viên; sinh hoạt chi bộ Phân hiệu Diễn Liên tháng {thang}..."/>
              <Button x:Name="BtnGiaoViecDang" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <StackPanel>
@@DANG@@
            </StackPanel>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="12">
                <StackPanel>
                  <Grid Margin="4,0,4,8">
                    <TextBlock Text="Văn bản Đảng đã soạn" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                      <Button x:Name="BtnMoVBDang" Style="{StaticResource Nut}" Content="Mở văn bản"/>
                      <Button x:Name="BtnMoThuMucDang" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0"/>
                    </StackPanel>
                  </Grid>
                  <ListView x:Name="LvDang" Height="240">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Tên văn bản" Width="560" DisplayMemberBinding="{Binding Ten}"/>
                        <GridViewColumn Header="Định dạng" Width="90" DisplayMemberBinding="{Binding DinhDang}"/>
                        <GridViewColumn Header="Ngày sửa" Width="140" DisplayMemberBinding="{Binding NgayTxt}"/>
                      </GridView>
                    </ListView.View>
                  </ListView>
                </StackPanel>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== VIỆC CỦA TÔI (từ 2.10.0 - nhiệm vụ theo chức danh, app\nhiem-vu.ps1) ========== -->
        <ScrollViewer x:Name="PgNhiemVu" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <StackPanel x:Name="KhuDsNV">
              <TextBlock x:Name="TieuDeTrangNV" Text="Việc của tôi" Style="{StaticResource TieuDeTrang}"/>
              <TextBlock Style="{StaticResource MoTaTrang}" Text="Nhiệm vụ theo chức danh (Điều lệ trường tiểu học - Thông tư 15/2026/TT-BGDĐT, phân công của Hiệu trưởng). Mỗi nhiệm vụ có trợ lý chuyên trách: thẻ căn cứ, việc theo tháng và hồ sơ riêng trợ lý tự ghi nhớ sau mỗi lần làm."/>
              <Grid Margin="6,0,6,14">
                <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                <Grid Margin="0,0,8,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Người dùng" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                      <TextBlock x:Name="TxtNguoiDungNV" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                      <WrapPanel Margin="0,10,0,0">
                        <Button x:Name="BtnKhaiBaoNV" Style="{StaticResource Nut}" Content="Khai báo, đổi chức danh" Margin="0,0,8,6"/>
                        <Button x:Name="BtnSapXepNV" Style="{StaticResource Nut}" Content="Sắp xếp bộ nhớ theo nhiệm vụ" Margin="0,0,8,6"/>
                      </WrapPanel>
                      <CheckBox x:Name="ChkTatCaNV" Content="Hiện cả nhiệm vụ khác" FontSize="13" Foreground="#40546B" Margin="0,4,0,0"/>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Grid.Column="1" Margin="8,0,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock x:Name="TieuDeViecThangNV" Text="Việc tháng này" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                      <TextBlock x:Name="TxtViecThangNV" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                      <WrapPanel Margin="0,10,0,0">
                        <Button x:Name="BtnViecThangNV" Style="{StaticResource NutChinh}" Content="Lập việc tháng này" Margin="0,0,8,6"/>
                        <Button x:Name="BtnMoCongViecNV" Style="{StaticResource Nut}" Content="Quản lý công việc" Margin="0,0,8,6"/>
                      </WrapPanel>
                    </StackPanel>
                  </Border>
                </Grid>
              </Grid>
@@NHIEMVU@@
            </StackPanel>
            <StackPanel x:Name="KhuChiTietNV" Visibility="Collapsed">
              <Button x:Name="BtnQuayLaiNV" Style="{StaticResource Lien}" HorizontalAlignment="Left" Margin="4,0,0,8">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE72B;" FontFamily="Segoe MDL2 Assets" FontSize="13" VerticalAlignment="Center" Margin="0,0,6,0"/><TextBlock Text="Tất cả nhiệm vụ" FontSize="14" VerticalAlignment="Center"/></StackPanel>
              </Button>
              <Grid Margin="4,0,6,12">
                <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                <Border x:Name="OBieuTuongNV" Width="54" Height="54" CornerRadius="14" Background="#1E5FD8" VerticalAlignment="Center">
                  <TextBlock x:Name="IconNV" Text="&#xE8F1;" FontFamily="Segoe MDL2 Assets" FontSize="24" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
                <StackPanel Grid.Column="1" Margin="14,0,12,0" VerticalAlignment="Center">
                  <TextBlock x:Name="TxtTenNV" Style="{StaticResource TieuDeTrang}" Margin="0" TextWrapping="Wrap"/>
                  <TextBlock x:Name="TxtMoTaNV" Style="{StaticResource MoTaTrang}" Margin="0,2,0,0"/>
                </StackPanel>
                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                  <Button x:Name="BtnTheNV" Style="{StaticResource Nut}" Content="Xem thẻ nhiệm vụ" Margin="0,0,8,0" ToolTip="Căn cứ, sản phẩm, việc theo tháng, hồ sơ cần có, lưu ý (phần mềm cung cấp)"/>
                  <Button x:Name="BtnHoSoNV" Style="{StaticResource Nut}" Content="Mở hồ sơ nhiệm vụ" Margin="0" ToolTip="Bộ nhớ riêng của nhiệm vụ này: văn bản đã làm, việc đang theo dõi, cách thầy/cô muốn làm (trợ lý tự ghi, thầy/cô sửa được)"/>
                </StackPanel>
              </Grid>
              <Grid Height="84" Margin="0,0,0,12">
                <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                <TextBox x:Name="TxtYChinhNV" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
                <TextBlock x:Name="GoiYYChinhNV" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm hoặc điều cần hỏi về nhiệm vụ này rồi bấm Giao việc (Enter để gửi, Shift+Enter xuống dòng), hoặc bấm một gợi ý bên dưới. Trợ lý chuyên trách đọc đúng thẻ và hồ sơ của nhiệm vụ này."/>
                <Button x:Name="BtnGiaoViecNV" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi cho trợ lý chuyên trách nhiệm vụ này (Enter)">
                  <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
                </Button>
              </Grid>
              <WrapPanel x:Name="DsGoiYNV" Margin="2,0,0,8"/>
              <Grid Margin="6,0,6,14">
                <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                <Grid Margin="0,0,8,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock x:Name="TieuDeThangNV" Text="Tháng này cần làm" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                      <TextBlock x:Name="TxtThangNV" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                      <TextBlock Text="Căn cứ chính" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,14,0,6"/>
                      <TextBlock x:Name="TxtCanCuNV" TextWrapping="Wrap" FontSize="13" Foreground="#40546B" LineHeight="21"/>
                    </StackPanel>
                  </Border>
                </Grid>
                <Grid Grid.Column="1" Margin="8,0,0,0">
                  <Border Style="{StaticResource Bong}"/>
                  <Border Style="{StaticResource The}">
                    <StackPanel>
                      <TextBlock Text="Hồ sơ của trường về nhiệm vụ này" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                      <TextBlock x:Name="TxtHoSoNV" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                    </StackPanel>
                  </Border>
                </Grid>
              </Grid>
            </StackPanel>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== BAN GIÁM HIỆU ========== -->
        <ScrollViewer x:Name="PgBanGiamHieu" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Ban giám hiệu" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Nhiệm vụ của Hiệu trưởng, Phó Hiệu trưởng theo Điều lệ trường và phân công; việc cần làm tháng này. Bấm một ô để chọn việc - trợ lý chờ thầy/cô ghi việc cụ thể rồi mới làm."/>
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
              <TextBox x:Name="TxtYChinhBGH" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhBGH" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi, Shift+Enter xuống dòng), hoặc bấm một ô bên dưới. Ví dụ: quyết định thành lập tổ chuyên môn năm học 2026 - 2027; kế hoạch tổ chức hội nghị viên chức..."/>
              <Button x:Name="BtnGiaoViecBGH" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <StackPanel>
@@BGH@@
            </StackPanel>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== TỔ CHUYÊN MÔN ========== -->
        <ScrollViewer x:Name="PgToChuyenMon" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang8" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Công cụ tiện ích" Margin="0,0,14,0" ToolTip="Chuyển sang Công cụ tiện ích"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Tổ chuyên môn" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Tổ trưởng chuyên môn vào đây để làm nhiệm vụ của tổ; Ban giám hiệu giao việc, theo dõi, góp ý và duyệt hồ sơ các tổ. Văn bản của tổ lưu ở thư mục 11_TO_CHUYEN_MON, mỗi tổ một thư mục."/>
            <Grid Margin="6,0,6,14">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel>
                    <TextBlock Text="Các tổ chuyên môn" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,6"/>
                    <TextBlock x:Name="TxtDsTo" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                  </StackPanel>
                  <StackPanel Grid.Column="1" VerticalAlignment="Top" Margin="16,0,0,0">
                    <Button x:Name="BtnDsTo" Style="{StaticResource NutChinh}" Content="Danh sách tổ, hồ sơ phải nộp" Margin="0,0,0,8"/>
                    <Button x:Name="BtnMoThuMucTo" Style="{StaticResource Nut}" Content="Mở thư mục tổ chuyên môn" Margin="0"/>
                  </StackPanel>
                </Grid>
              </Border>
            </Grid>
            <Grid Height="84" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhTo" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhTo" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc của tổ rồi bấm Giao việc (Enter để gửi, Shift+Enter xuống dòng), hoặc bấm một ô việc bên dưới. Ví dụ: biên bản sinh hoạt Tổ 2-3 ngày {ngay}; đề kiểm tra cuối học kì I môn Toán lớp 4..."/>
              <Button x:Name="BtnGiaoViecTo" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <TextBlock Text="NHIỆM VỤ CỦA TỔ CHUYÊN MÔN" FontSize="13" FontWeight="Bold" Foreground="#2F6FE0" Margin="8,2,6,8"/>
            <UniformGrid Columns="3">
@@TOCM@@
            </UniformGrid>
            <StackPanel x:Name="KhuChiDaoTo">
              <TextBlock Text="CHỈ ĐẠO TỔ CHUYÊN MÔN (BAN GIÁM HIỆU)" FontSize="13" FontWeight="Bold" Foreground="#2F6FE0" Margin="8,14,6,8"/>
              <UniformGrid Columns="3">
@@CHIDAO@@
              </UniformGrid>
            </StackPanel>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="12">
                <StackPanel>
                  <Grid Margin="4,0,4,8">
                    <TextBlock Text="Hồ sơ các tổ" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                      <Button x:Name="BtnMoVBTo" Style="{StaticResource Nut}" Content="Mở văn bản"/>
                      <Button x:Name="BtnDuyetVBTo" Style="{StaticResource Nut}" Content="Góp ý, duyệt"/>
                      <Button x:Name="BtnMoThuMucTo2" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0"/>
                    </StackPanel>
                  </Grid>
                  <ListView x:Name="LvTo" Height="240">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Tổ" Width="110" DisplayMemberBinding="{Binding To}"/>
                        <GridViewColumn Header="Tên văn bản" Width="470" DisplayMemberBinding="{Binding Ten}"/>
                        <GridViewColumn Header="Ngày sửa" Width="130" DisplayMemberBinding="{Binding NgayTxt}"/>
                        <GridViewColumn Header="Trạng thái" Width="120" DisplayMemberBinding="{Binding TrangThai}"/>
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
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Các quy trình chuyên sâu cho Ban giám hiệu và các công cụ quản lý dữ liệu."/>
            <UniformGrid Columns="3">
@@TIENICH@@
            </UniformGrid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== VĂN BẢN ĐẾN ========== -->
        <Grid x:Name="PgVanBanDen" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang7" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Công cụ tiện ích" Margin="0,0,14,0" ToolTip="Chuyển sang Công cụ tiện ích"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Xử lý văn bản đến" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Thả file văn bản của Sở, UBND xã (Word, PDF, ảnh chụp) để trợ lý tóm tắt, trích việc phải làm, thời hạn và đề xuất phân công. Bạn có thể tải văn bản từ iOffice rồi chọn tệp để xử lý."/>
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
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Tình trạng công cụ, kết nối OpenRouter, mô hình AI, thông tin trường và bộ nhớ của trợ lý."/>
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
                      <TextBlock Text="Bản quyền" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
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
                      <TextBlock Text="Thông tin trường (bộ nhớ của trợ lý)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock x:Name="TxtThongTinTruong" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnKhaiBao" Style="{StaticResource NutChinh}" Content="Khai báo thông tin trường" Margin="0,0,10,8"/>
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
                      <TextBlock Text="Làm việc trên CSDL ngành, vnEdu" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock TextWrapping="Wrap" FontSize="13" Foreground="#40546B" LineHeight="20" Text="Mặc định trợ lý chỉ đọc, đối chiếu và báo lỗi. Bật nhập dữ liệu thì trợ lý lập bản xem trước và chỉ nhập sau khi thầy/cô bấm xác nhận từng đợt; không xóa bản ghi, không ký số, không gửi báo cáo."/>
                      <CheckBox x:Name="ChkNhapDuLieu" Content="Cho phép nhập dữ liệu (từ file Excel trong 06__DU_LIEU)" FontSize="13.5" Foreground="#1F3354" Margin="0,12,0,0"/>
                      <TextBlock x:Name="TxtNhapDuLieu" TextWrapping="Wrap" FontSize="13" Foreground="#1F3354" LineHeight="20" Margin="0,6,0,0"/>
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
      <TextBlock Text="$(XE $c.Tieu)" FontSize="14.5" FontWeight="Bold" Foreground="$($c.C2)" TextWrapping="Wrap"/>
      <TextBlock Text="$(XE $c.MoTa)" FontSize="11.5" Foreground="#5B6B7F" TextWrapping="Wrap" TextTrimming="CharacterEllipsis" MaxHeight="32" Margin="0,2,0,0" LineHeight="16"/>
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
$sb = New-Object System.Text.StringBuilder
foreach ($c in $CongTacDang) {
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
# (ô Công tác Đảng dựng theo nhóm nhiệm vụ - XAML-NhomO bên dưới)
# Ô của trang Tổ chuyên môn (cùng kiểu ô Công tác Đảng)
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
$xamlText = $xamlText.Replace('@@TOCM@@', (XAML-OVuong $NhiemVuTo)).Replace('@@CHIDAO@@', (XAML-OVuong $ChiDaoTo))
# Ô xếp theo nhóm có tiêu đề (trang Công tác Đảng, Ban giám hiệu); giữ thứ tự ô trong từng nhóm
function XAML-NhomO($nhom, $ds) {
    $b = New-Object System.Text.StringBuilder
    foreach ($ten in $nhom.Keys) {
        $o = @(foreach ($n in $nhom[$ten]) { $ds | Where-Object { $_.N -eq $n } })
        if (-not $o.Count) { continue }
        [void]$b.Append('<TextBlock Text="' + (XE $ten) + '" FontSize="13" FontWeight="Bold" Foreground="#2F6FE0" Margin="8,10,6,8"/><UniformGrid Columns="3">' + (XAML-OVuong $o) + '</UniformGrid>')
    }
    return $b.ToString()
}
$xamlText = $xamlText.Replace('@@DANG@@', (XAML-NhomO $NhomDang $CongTacDang)).Replace('@@BGH@@', (XAML-NhomO $NhomBGH $BanGiamHieu))
# Trang Việc của tôi: nhiệm vụ theo chức danh (danh mục mau\kien-thuc\nhiem-vu\_danh-muc.md)



# Ngày tháng trong các câu ví dụ, chữ gợi ý của giao diện: thay bằng thời gian thực khi mở
# phần mềm (từ 2.20.0) - để sang tháng 10, tháng 11 không còn thấy "tháng 9" nằm lại.
$nayGD = Get-Date
$xamlText = $xamlText.Replace('{thang}', [string]$nayGD.Month).Replace('{nam}', [string]$nayGD.Year).Replace('{namthang}', $nayGD.ToString('yyyy-MM')).Replace('{ngay}', ($nayGD.Day.ToString() + '/' + $nayGD.Month.ToString()))


[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'layout.xaml'), $xamlText, (New-Object Text.UTF8Encoding($false)))
