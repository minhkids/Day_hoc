$ICON_BIEUDO = 'PATH:M0,20 L4,20 L4,9 L0,9 Z M7,20 L11,20 L11,3 L7,3 Z M14,20 L18,20 L18,12 L14,12 Z'
$TheChinh = @(
    @{ N = 'TcChat';     Hanh = 'chat';             Nen = '#EEF3FC'; C1 = '#3A6FD8'; C2 = '#0E3A86'; Icon = [char]0xE8BD; Tieu = 'Trò chuyện AI';       MoTa = 'Giao việc như nhắn tin; khung trò chuyện lớn, đọc được câu trả lời dài.' }
    @{ N = 'TcSoanBai';  Hanh = 'trang:SoanVanBan'; Nen = '#EEF3FC'; C1 = '#4C8DFF'; C2 = '#0B2B6B'; Icon = [char]0xE8A5; Tieu = 'Soạn bài dạy';        MoTa = 'Kế hoạch bài dạy, trình chiếu, phiếu học tập, đề cương ôn tập.' }
    @{ N = 'TcKiemTra';  Hanh = 'trang:KiemTra';    Nen = '#FDF6E3'; C1 = '#E0B43A'; C2 = '#9A7414'; Icon = [char]0xE9D5; Tieu = 'Kiểm tra, đánh giá';  MoTa = 'Ma trận, bản đặc tả, đề, đáp án; nhận xét, tổng hợp điểm.' }
    @{ N = 'TcChuNhiem'; Hanh = 'trang:ChuNhiem';   Nen = '#FDEFEF'; C1 = '#E0685F'; C2 = '#B0392E'; Icon = [char]0xE716; Tieu = 'Chủ nhiệm lớp';       MoTa = 'Kế hoạch chủ nhiệm, họp cha mẹ học sinh, theo dõi học sinh.' }
    @{ N = 'TcXuong';    Hanh = 'trang:Xuong';      Nen = '#E9ECF4'; C1 = '#2B3F6B'; C2 = '#14213D'; Icon = [char]0xE943; Tieu = 'Xưởng phần mềm';      MoTa = 'Nói yêu cầu - trợ lý làm trò chơi, bài ôn tập, ứng dụng cho lớp.' }
    @{ N = 'TcHoSo';     Hanh = 'trang:NhiemVu';    Nen = '#F1EFFC'; C1 = '#7C6BE0'; C2 = '#5B4BB7'; Icon = [char]0xE7C1; Tieu = 'Hồ sơ chuyên môn';    MoTa = 'Kế hoạch giáo dục, sinh hoạt chuyên môn, sáng kiến, chuẩn nghề nghiệp.' }
    @{ N = 'TcThuVien';  Hanh = 'trang:ThuVien';    Nen = '#EDF7EE'; C1 = '#4CAF50'; C2 = '#1F7A46'; Icon = [char]0xED25; Tieu = 'Kho tài liệu';        MoTa = 'Bài dạy, đề, hồ sơ, phần mềm đã làm; tìm, mở, sửa tiếp.' }
    @{ N = 'TcVBDen';    Hanh = 'trang:VanBanDen';  Nen = '#FFF8E7'; C1 = '#F0B429'; C2 = '#C97A12'; Icon = [char]0xE896; Tieu = 'Văn bản nhà trường';  MoTa = 'Đọc, tóm tắt văn bản của trường, tổ, Sở; trích việc phải làm.' }
    @{ N = 'TcTraCuu';   Hanh = 'trang:TraCuu';     Nen = '#F1F4F2'; C1 = '#7C9486'; C2 = '#40546B'; Icon = [char]0xE721; Tieu = 'Tra cứu quy định';    MoTa = 'Đánh giá học sinh, kế hoạch bài dạy, chế độ làm việc giáo viên...' }
)
# Trang Soạn bài dạy: các loại tài liệu dạy học (Lenh phải khác nhau - tra lại khi bấm ô)
$LoaiVB = @(
    @{ N = 'LvKHBD';      Tieu = 'Kế hoạch bài dạy';     MoTa = 'Mục tiêu, thiết bị, tiến trình 4 hoạt động'; Lenh = '/ke-hoach-bai-day Soạn kế hoạch bài dạy' }
    @{ N = 'LvTrinhChieu'; Tieu = 'Bài trình chiếu';      MoTa = 'File PowerPoint theo bài dạy';               Lenh = '/trinh-chieu Soạn bài trình chiếu' }
    @{ N = 'LvPhieuHT';   Tieu = 'Phiếu học tập';        MoTa = 'Phiếu cá nhân, phiếu nhóm';                  Lenh = '/phieu-hoc-tap Soạn phiếu học tập' }
    @{ N = 'LvBaiTap';    Tieu = 'Bài tập phân hóa';     MoTa = 'Theo mức biết, hiểu, vận dụng';              Lenh = '/phieu-hoc-tap Soạn bài tập phân hóa' }
    @{ N = 'LvDeCuong';   Tieu = 'Đề cương ôn tập';      MoTa = 'Giữa kỳ, cuối kỳ, có đáp án';                Lenh = '/phieu-hoc-tap Soạn đề cương ôn tập' }
    @{ N = 'LvChuyenDe';  Tieu = 'Chủ đề, STEM';         MoTa = 'Dạy học theo chủ đề, bài học STEM';          Lenh = '/ke-hoach-bai-day Soạn chủ đề dạy học, bài học STEM' }
    @{ N = 'LvKHGD';      Tieu = 'Kế hoạch giáo dục';    MoTa = 'Kế hoạch dạy học cả năm của giáo viên';      Lenh = '/ke-hoach-giao-duc Lập kế hoạch giáo dục của giáo viên' }
    @{ N = 'LvTroChoi';   Tieu = 'Trò chơi khởi động';   MoTa = 'Chạy trên máy chiếu (Xưởng phần mềm)';       Lenh = '/xuong-phan-mem Làm trò chơi khởi động cho bài học' }
    @{ N = 'LvSuaBai';    Tieu = 'Sửa bài đã soạn';      MoTa = 'Đính kèm file, nói cần sửa gì';              Lenh = '/ke-hoach-bai-day Sửa kế hoạch bài dạy đã có' }
    @{ N = 'LvRaSoatBai'; Tieu = 'Rà soát bài dạy';      MoTa = 'Kiến thức, thời lượng, chính tả';            Lenh = '/ra-soat Rà soát bài dạy' }
)
# Trang Kỹ năng trợ lý (Công cụ tiện ích): các quy trình theo nhóm và công cụ quản lý dữ liệu
$TienIch = @(
    @{ N = 'TiKHBD';       Tieu = 'Kế hoạch bài dạy';          MoTa = 'Soạn kế hoạch bài dạy theo mẫu hiện hành, xuất Word.';                    Icon = [char]0xE8A5; Mau = '#0E3A86'; Hanh = 'lenh:/ke-hoach-bai-day Kế hoạch bài dạy' }
    @{ N = 'TiTrinhChieu'; Tieu = 'Bài trình chiếu';           MoTa = 'Dàn ý từng trang chiếu, xuất file PowerPoint.';                           Icon = [char]0xE7F4; Mau = '#2F6FE0'; Hanh = 'lenh:/trinh-chieu Bài trình chiếu' }
    @{ N = 'TiPhieuHT';    Tieu = 'Phiếu học tập, đề cương';   MoTa = 'Phiếu học tập, bài tập phân hóa, đề cương ôn tập.';                       Icon = [char]0xE70B; Mau = '#3A6FD8'; Hanh = 'lenh:/phieu-hoc-tap Phiếu học tập, đề cương' }
    @{ N = 'TiKHGD';       Tieu = 'Kế hoạch giáo dục';         MoTa = 'Kế hoạch dạy học cả năm, tiến độ theo tuần, việc tháng.';                 Icon = [char]0xE787; Mau = '#0B2B6B'; Hanh = 'lenh:/ke-hoach-giao-duc Kế hoạch giáo dục' }
    @{ N = 'TiDeKT';       Tieu = 'Đề kiểm tra';               MoTa = 'Ma trận, bản đặc tả, đề, đáp án và hướng dẫn chấm.';                      Icon = [char]0xE9D5; Mau = '#9A7414'; Hanh = 'lenh:/de-kiem-tra Đề kiểm tra' }
    @{ N = 'TiDanhGia';    Tieu = 'Đánh giá học sinh';         MoTa = 'Nhận xét, tổng hợp điểm, xếp loại theo quy định.';                        Icon = [char]0xE8FB; Mau = '#C97A12'; Hanh = 'lenh:/danh-gia-hoc-sinh Đánh giá học sinh' }
    @{ N = 'TiTongHop';    Tieu = 'Tổng hợp bảng điểm';        MoTa = 'Thống kê điểm, tỷ lệ theo lớp từ file Excel.';                            Icon = $ICON_BIEUDO; Mau = '#1F7A46'; Hanh = 'trang:TongHop' }
    @{ N = 'TiChuNhiem';   Tieu = 'Công tác chủ nhiệm';        MoTa = 'Kế hoạch chủ nhiệm, họp cha mẹ học sinh, theo dõi học sinh.';             Icon = [char]0xE716; Mau = '#B0392E'; Hanh = 'lenh:/chu-nhiem Công tác chủ nhiệm' }
    @{ N = 'TiSHCM';       Tieu = 'Sinh hoạt chuyên môn';      MoTa = 'Nghiên cứu bài học, chuyên đề tổ, biên bản sinh hoạt.';                   Icon = [char]0xE8BD; Mau = '#5B4BB7'; Hanh = 'lenh:/sinh-hoat-chuyen-mon Sinh hoạt chuyên môn' }
    @{ N = 'TiSangKien';   Tieu = 'Sáng kiến kinh nghiệm';     MoTa = 'Đề cương, báo cáo sáng kiến, minh chứng hiệu quả.';                       Icon = [char]0xEA80; Mau = '#7C6BE0'; Hanh = 'lenh:/sang-kien Sáng kiến kinh nghiệm' }
    @{ N = 'TiChuan';      Tieu = 'Chuẩn nghề nghiệp';         MoTa = 'Tự đánh giá theo chuẩn, kế hoạch bồi dưỡng thường xuyên.';                Icon = [char]0xE734; Mau = '#5B4BB7'; Hanh = 'lenh:/chuan-nghe-nghiep Chuẩn nghề nghiệp' }
    @{ N = 'TiBaoCao';     Tieu = 'Báo cáo';                   MoTa = 'Báo cáo cá nhân, báo cáo tổ, sơ kết, tổng kết.';                          Icon = $ICON_BIEUDO; Mau = '#1F7A46'; Hanh = 'lenh:/bao-cao Báo cáo' }
    @{ N = 'TiBienBan';    Tieu = 'Biên bản';                  MoTa = 'Biên bản họp tổ, họp lớp, họp cha mẹ học sinh.';                          Icon = [char]0xE70B; Mau = '#40546B'; Hanh = 'lenh:/bien-ban Biên bản' }
    @{ N = 'TiXuong';      Tieu = 'Xưởng phần mềm';            MoTa = 'Trò chơi, trắc nghiệm, mô phỏng, ứng dụng nhỏ cho lớp học.';              Icon = [char]0xE943; Mau = '#14213D'; Hanh = 'trang:Xuong' }
    @{ N = 'TiVBDen';      Tieu = 'Văn bản nhà trường';        MoTa = 'Thả file Word, PDF, ảnh vào để tóm tắt và trích việc.';                   Icon = [char]0xE896; Mau = '#C97A12'; Hanh = 'trang:VanBanDen' }
    @{ N = 'TiRaSoat';     Tieu = 'Rà soát tài liệu';          MoTa = 'Kiểm tra kiến thức, chính tả, thể thức; tạo bản đã sửa.';                 Icon = [char]0xE73E; Mau = '#1F7A46'; Hanh = 'rasoat' }
    @{ N = 'TiXuatWord';   Tieu = 'Xuất Word từ bản nháp';     MoTa = 'Chọn tài liệu đã soạn để xuất lại file Word.';                            Icon = [char]0xE8A5; Mau = '#0E3A86'; Hanh = 'xuatword' }
    @{ N = 'TiTraCuu';     Tieu = 'Tra cứu quy định';          MoTa = 'Hỏi quy định; trả lời kèm điều, khoản và nguồn.';                         Icon = [char]0xE721; Mau = '#40546B'; Hanh = 'trang:TraCuu' }
    @{ N = 'TiCapNhatCC';  Tieu = 'Cập nhật văn bản mới';      MoTa = 'Tra văn bản mới, văn bản hết hiệu lực trên trang chính thống.';           Icon = [char]0xE895; Mau = '#40546B'; Hanh = 'lenh:/cap-nhat-can-cu Cập nhật căn cứ pháp lý' }
    @{ N = 'TiGhiNho';     Tieu = 'Ghi nhớ thông tin';         MoTa = 'Lớp dạy, tiến độ, lịch năm học, thói quen làm việc của thầy/cô.';          Icon = [char]0xE734; Mau = '#9A7414'; Hanh = 'lenh:/ghi-nho Ghi nhớ thông tin' }
    @{ N = 'TiNamHoc';     Tieu = 'Sang năm học mới';          MoTa = 'Lưu trữ bộ nhớ năm cũ, cập nhật lớp dạy, lịch năm học.';                  Icon = [char]0xE72C; Mau = '#9A7414'; Hanh = 'lenh:/nam-hoc-moi Sang năm học mới' }
    @{ N = 'TiHuongDanQT'; Tieu = 'Hỏi trợ lý cách dùng';      MoTa = 'Trợ lý giải thích phần mềm làm được gì và cách giao việc.';               Icon = [char]0xE897; Mau = '#0E3A86'; Hanh = 'lenh:/huong-dan Hỏi trợ lý cách dùng' }
    @{ N = 'TiSaoLuu';     Tieu = 'Sao lưu dữ liệu';           MoTa = 'Nén bộ nhớ và toàn bộ tài liệu đã soạn ra một file .zip.';                Icon = [char]0xE753; Mau = '#1F7A46'; Hanh = 'saoluu' }
    @{ N = 'TiDonRac';    Tieu = 'Dọn rác máy tính';    MoTa = 'Xóa tệp tạm, bộ nhớ đệm trình duyệt, báo lỗi cũ cho máy nhẹ hơn.'; Icon = [char]0xE74D; Mau = '#00838F'; Hanh = 'donrac' }
    @{ N = 'TiSuaMay';    Tieu = 'Kiểm tra và sửa máy'; MoTa = 'Chẩn đoán ổ đĩa, bộ nhớ, mạng, virus, lỗi hệ thống; gợi ý và sửa nhanh.'; Icon = [char]0xE7F4; Mau = '#5E35B1'; Hanh = 'suamay' }
    @{ N = 'TiHuongDan';   Tieu = 'Hướng dẫn sử dụng';         MoTa = 'Mở sách hướng dẫn: các trang, cách giao việc, xử lý sự cố.';              Icon = [char]0xE897; Mau = '#9A7414'; Hanh = 'huongdan' }
)
$NhomTienIch = [ordered]@{
    'DẠY HỌC'                 = @('TiKHBD', 'TiTrinhChieu', 'TiPhieuHT', 'TiKHGD')
    'KIỂM TRA, ĐÁNH GIÁ'      = @('TiDeKT', 'TiDanhGia', 'TiTongHop')
    'CHỦ NHIỆM, CHUYÊN MÔN'   = @('TiChuNhiem', 'TiSHCM', 'TiSangKien', 'TiChuan', 'TiBaoCao', 'TiBienBan')
    'XƯỞNG PHẦN MỀM'          = @('TiXuong')
    'VĂN BẢN, TRA CỨU, BỘ NHỚ' = @('TiVBDen', 'TiRaSoat', 'TiXuatWord', 'TiTraCuu', 'TiCapNhatCC', 'TiGhiNho', 'TiNamHoc', 'TiHuongDanQT')
    'CÔNG CỤ'                 = @('TiSaoLuu', 'TiHuongDan', 'TiDoctor')
}
# Trang "Hồ sơ chuyên môn" (PgNhiemVu)
$NhiemVu = @(
    @{ N = 'HsKHGD';      Tieu = 'Kế hoạch giáo dục';         MoTa = 'Kế hoạch dạy học cả năm của giáo viên theo môn, khối.';               Icon = [char]0xE787; Mau = '#0B2B6B'; Hanh = 'lenh:/ke-hoach-giao-duc Kế hoạch giáo dục (Hồ sơ)' }
    @{ N = 'HsTienDo';    Tieu = 'Tiến độ dạy học';           MoTa = 'Bảng tuần - tiết - bài; đánh dấu đã soạn, đã dạy.';                   Icon = [char]0xE9D5; Mau = '#2F6FE0'; Hanh = 'lenh:/ke-hoach-giao-duc Tiến độ dạy học theo tuần' }
    @{ N = 'HsSHCM';      Tieu = 'Sinh hoạt chuyên môn';      MoTa = 'Kế hoạch bài học minh họa, phiếu quan sát, biên bản.';                Icon = [char]0xE8BD; Mau = '#5B4BB7'; Hanh = 'lenh:/sinh-hoat-chuyen-mon Sinh hoạt chuyên môn (Hồ sơ)' }
    @{ N = 'HsChuyenDe';  Tieu = 'Chuyên đề tổ';              MoTa = 'Báo cáo chuyên đề, kế hoạch thực hiện chuyên đề.';                    Icon = [char]0xE7C3; Mau = '#7C6BE0'; Hanh = 'lenh:/sinh-hoat-chuyen-mon Chuyên đề của tổ chuyên môn' }
    @{ N = 'HsBienBanTo'; Tieu = 'Biên bản họp tổ';           MoTa = 'Biên bản sinh hoạt tổ, nhóm chuyên môn từ ghi chép.';                 Icon = [char]0xE70B; Mau = '#40546B'; Hanh = 'lenh:/bien-ban Biên bản họp tổ chuyên môn' }
    @{ N = 'HsSangKien';  Tieu = 'Sáng kiến kinh nghiệm';     MoTa = 'Đề cương, báo cáo sáng kiến, số liệu trước và sau áp dụng.';          Icon = [char]0xEA80; Mau = '#7C6BE0'; Hanh = 'lenh:/sang-kien Sáng kiến kinh nghiệm (Hồ sơ)' }
    @{ N = 'HsChuan';     Tieu = 'Tự đánh giá chuẩn';         MoTa = 'Tự đánh giá theo chuẩn nghề nghiệp giáo viên, minh chứng.';               Icon = [char]0xE734; Mau = '#5B4BB7'; Hanh = 'lenh:/chuan-nghe-nghiep Tự đánh giá chuẩn nghề nghiệp' }
    @{ N = 'HsBoiDuong';  Tieu = 'Bồi dưỡng thường xuyên';    MoTa = 'Kế hoạch, bài thu hoạch bồi dưỡng thường xuyên.';                     Icon = [char]0xE7BE; Mau = '#2F6FE0'; Hanh = 'lenh:/chuan-nghe-nghiep Bồi dưỡng thường xuyên' }
    @{ N = 'HsBaoCao';    Tieu = 'Báo cáo cá nhân';           MoTa = 'Báo cáo sơ kết, tổng kết, báo cáo theo yêu cầu của trường.';          Icon = $ICON_BIEUDO; Mau = '#1F7A46'; Hanh = 'lenh:/bao-cao Báo cáo cá nhân (Hồ sơ)' }
    @{ N = 'HsVBDen';     Tieu = 'Văn bản nhà trường';        MoTa = 'Mở trang văn bản: tóm tắt, trích việc phải làm, hạn nộp.';            Icon = [char]0xE896; Mau = '#C97A12'; Hanh = 'trang:VanBanDen' }
)
$NhomNhiemVu = [ordered]@{
    'KẾ HOẠCH, TIẾN ĐỘ'          = @('HsKHGD', 'HsTienDo')
    'SINH HOẠT CHUYÊN MÔN'       = @('HsSHCM', 'HsChuyenDe', 'HsBienBanTo')
    'PHÁT TRIỂN NGHỀ NGHIỆP'     = @('HsSangKien', 'HsChuan', 'HsBoiDuong')
    'BÁO CÁO, VĂN BẢN'           = @('HsBaoCao', 'HsVBDen')
}
# Trang "Kiểm tra, đánh giá" (PgKiemTra)
$KiemTraO = @(
    @{ N = 'KtMaTran';    Tieu = 'Ma trận, bản đặc tả';     MoTa = 'Đúng khung của cấp học, đủ các mức độ, tổng 10 điểm.'; Icon = [char]0xE8A1; Mau = '#9A7414'; Hanh = 'lenh:/de-kiem-tra Ma trận, bản đặc tả' }
    @{ N = 'KtDe';        Tieu = 'Đề và hướng dẫn chấm';    MoTa = 'Đề giữa kỳ, cuối kỳ; đáp án, thang điểm.';             Icon = [char]0xE9D5; Mau = '#C97A12'; Hanh = 'lenh:/de-kiem-tra Đề kiểm tra và hướng dẫn chấm' }
    @{ N = 'KtOnTap';     Tieu = 'Đề cương ôn tập';         MoTa = 'Nội dung ôn, bài tập mẫu theo ma trận đề.';            Icon = [char]0xE70B; Mau = '#2F6FE0'; Hanh = 'lenh:/phieu-hoc-tap Đề cương ôn tập (Kiểm tra)' }
    @{ N = 'KtNhanXet';   Tieu = 'Nhận xét học sinh';       MoTa = 'Lời nhận xét từng em từ bảng điểm, giọng tích cực.';    Icon = [char]0xE8FB; Mau = '#B0392E'; Hanh = 'lenh:/danh-gia-hoc-sinh Nhận xét học sinh' }
    @{ N = 'KtTongHop';   Tieu = 'Tổng hợp điểm, xếp loại'; MoTa = 'Điểm trung bình môn, kết quả học tập theo quy định.';    Icon = $ICON_BIEUDO; Mau = '#1F7A46'; Hanh = 'lenh:/danh-gia-hoc-sinh Tổng hợp điểm, xếp loại' }
    @{ N = 'KtPhanTich'; Tieu = 'Phân tích kết quả';       MoTa = 'Phổ điểm, so sánh lớp, độ khó - độ phân biệt từng câu.'; Icon = $ICON_BIEUDO; Mau = '#0E8A4F'; Hanh = 'lenh:/phan-tich-ket-qua Phân tích kết quả bài kiểm tra' }
    @{ N = 'KtTracNghiem'; Tieu = 'Trắc nghiệm trên lớp';   MoTa = 'Biến câu hỏi thành trò chơi thi đua (Xưởng phần mềm).'; Icon = [char]0xE943; Mau = '#14213D'; Hanh = 'lenh:/xuong-phan-mem Trắc nghiệm thi đua trên máy chiếu' }
)
# Trang "Chủ nhiệm lớp" (PgChuNhiem)
$ChuNhiemO = @(
    @{ N = 'CnKeHoach';  Tieu = 'Kế hoạch chủ nhiệm';      MoTa = 'Kế hoạch năm, tháng của giáo viên chủ nhiệm.';          Icon = [char]0xE787; Mau = '#B0392E'; Hanh = 'lenh:/chu-nhiem Kế hoạch chủ nhiệm' }
    @{ N = 'CnHopPH';    Tieu = 'Họp cha mẹ học sinh';     MoTa = 'Nội dung họp, lời phát biểu, báo cáo tình hình lớp.';   Icon = [char]0xE716; Mau = '#C97A12'; Hanh = 'lenh:/chu-nhiem Họp cha mẹ học sinh' }
    @{ N = 'CnBienBan';  Tieu = 'Biên bản họp';            MoTa = 'Biên bản họp cha mẹ học sinh, họp lớp từ ghi chép.';    Icon = [char]0xE70B; Mau = '#40546B'; Hanh = 'lenh:/chu-nhiem Biên bản họp cha mẹ học sinh, họp lớp' }
    @{ N = 'CnThu';      Tieu = 'Thư, tin nhắn phụ huynh'; MoTa = 'Thông báo, thư mời, tin nhắn nhóm lớp lịch sự, rõ ý.';  Icon = [char]0xE715; Mau = '#2F6FE0'; Hanh = 'lenh:/chu-nhiem Thư, tin nhắn gửi cha mẹ học sinh' }
    @{ N = 'CnTheoDoi';  Tieu = 'Theo dõi, hỗ trợ học sinh'; MoTa = 'Kế hoạch hỗ trợ học sinh cần quan tâm (không lưu bộ nhớ).'; Icon = [char]0xE8FB; Mau = '#7C6BE0'; Hanh = 'lenh:/chu-nhiem Theo dõi, hỗ trợ học sinh' }
    @{ N = 'CnSinhHoat'; Tieu = 'Tiết sinh hoạt lớp';      MoTa = 'Kế hoạch tiết sinh hoạt lớp, chủ đề trải nghiệm.';      Icon = [char]0xE8BD; Mau = '#0E3A86'; Hanh = 'lenh:/chu-nhiem Tiết sinh hoạt lớp' }
)
# Bấm một ô quy trình (lenh:) chỉ CHỌN quy trình: mở việc mới trong Trò chuyện, hiện các gợi ý dưới đây, trợ lý chờ thầy/cô
# ghi việc cụ thể rồi mới làm. Chỗ trống: {thang} tháng này, {nam} năm, {nam_hoc} năm học, {mon} môn dạy, {lop} lớp dạy.
$GoiYO = @{
    TiKHBD       = @('Kế hoạch bài dạy {mon}, bài: (ghi tên bài), lớp {lop}, số tiết: ...', 'Kế hoạch bài dạy có hoạt động nhóm và trò chơi khởi động: (ghi bài)', 'Chuyển kế hoạch bài dạy cũ sang mẫu mới (đính kèm file)')
    TiTrinhChieu = @('Bài trình chiếu cho bài: (ghi tên bài), khoảng 12-15 trang', 'Làm bài trình chiếu từ kế hoạch bài dạy đã soạn (đính kèm file)')
    TiPhieuHT    = @('Phiếu học tập nhóm cho hoạt động: (ghi hoạt động, bài)', 'Bài tập phân hóa 3 mức cho bài: (ghi bài)', 'Đề cương ôn tập giữa kỳ I môn {mon} lớp {lop}')
    TiKHGD       = @('Kế hoạch giáo dục môn {mon} năm học {nam_hoc}', 'Lập tiến độ dạy học theo tuần của học kỳ I', 'Lập danh sách việc tháng {thang} của giáo viên và ghi vào Quản lý công việc')
    TiDeKT       = @('Ma trận, bản đặc tả và đề kiểm tra giữa kỳ I môn {mon} lớp {lop}', 'Đề kiểm tra cuối kỳ I có hướng dẫn chấm', 'Đổi đề kiểm tra này thành đề B tương đương (đính kèm file)')
    TiDanhGia    = @('Nhận xét giữa kỳ cho lớp: (ghi lớp) từ bảng điểm (đính kèm file)', 'Tổng hợp điểm trung bình môn, xếp mức học kỳ I (đính kèm file)')
    TiChuNhiem   = @('Kế hoạch chủ nhiệm lớp {lop} năm học {nam_hoc}', 'Nội dung họp cha mẹ học sinh đầu năm', 'Tin nhắn nhắc cha mẹ học sinh về: (ghi nội dung)')
    TiSHCM       = @('Kế hoạch bài học minh họa nghiên cứu bài học: (ghi bài)', 'Phiếu quan sát học sinh trong giờ dạy minh họa', 'Biên bản sinh hoạt chuyên môn (dán ghi chép)')
    TiSangKien   = @('Đề cương sáng kiến: (ghi tên, vấn đề muốn giải quyết)', 'Viết báo cáo sáng kiến từ đề cương đã có (đính kèm file)')
    TiChuan      = @('Tự đánh giá theo chuẩn nghề nghiệp giáo viên (theo hạng) năm học {nam_hoc}', 'Kế hoạch bồi dưỡng năm học {nam_hoc}')
    TiBaoCao     = @('Báo cáo sơ kết học kỳ I của cá nhân', 'Báo cáo theo yêu cầu của nhà trường (đính kèm văn bản)')
    TiBienBan    = @('Biên bản họp tổ chuyên môn (dán ghi chép)', 'Biên bản họp lớp: (dán ghi chép)')
    TiCapNhatCC  = @('Có văn bản mới nào về đánh giá học sinh, kiểm tra định kỳ không?', 'Văn bản (ghi số hiệu) còn hiệu lực không?')
    TiGhiNho     = @('Ghi nhớ: (ghi điều cần nhớ)', 'Cập nhật lớp dạy, sĩ số, thiết bị phòng học: (ghi thông tin)')
    TiNamHoc     = @('Chuyển bộ nhớ sang năm học mới')
    TiHuongDanQT = @('Phần mềm giúp được tôi những việc gì?', 'Cách làm một trò chơi trắc nghiệm cho lớp')
    TiXuatWord   = @()
    TiRaSoat     = @()
}
$GoiYO.HsKHGD = $GoiYO.TiKHGD; $GoiYO.HsTienDo = @('Lập tiến độ dạy học theo tuần môn {mon} lớp {lop}', 'Đánh dấu đã dạy đến bài: (ghi bài)')
$GoiYO.HsSHCM = $GoiYO.TiSHCM; $GoiYO.HsChuyenDe = @('Báo cáo chuyên đề: (ghi tên chuyên đề)', 'Kế hoạch thực hiện chuyên đề của tổ: (ghi chuyên đề)')
$GoiYO.HsBienBanTo = @('Biên bản họp tổ chuyên môn tháng {thang} (dán ghi chép)'); $GoiYO.HsSangKien = $GoiYO.TiSangKien
$GoiYO.HsChuan = @('Tự đánh giá theo chuẩn nghề nghiệp giáo viên (theo hạng) năm học {nam_hoc}', 'Danh mục minh chứng kèm bản tự đánh giá'); $GoiYO.HsBoiDuong = @('Kế hoạch bồi dưỡng thường xuyên năm học {nam_hoc}', 'Bài thu hoạch bồi dưỡng: (ghi mô đun, nội dung)')
$GoiYO.HsBaoCao = $GoiYO.TiBaoCao
$GoiYO.KtMaTran = @('Ma trận và bản đặc tả đề kiểm tra giữa kỳ I môn {mon} lớp {lop}', 'Ma trận đề cuối kỳ I (ghi phạm vi kiến thức)')
$GoiYO.KtPhanTich = @('Phân tích kết quả kiểm tra môn {mon} lớp {lop} (đính kèm bảng điểm)', 'So sánh phổ điểm các lớp em dạy', 'Nạp câu hỏi của đề đã kiểm tra vào ngân hàng câu hỏi')
$GoiYO.KtDe = @('Đề kiểm tra giữa kỳ I môn {mon} lớp {lop} theo ma trận đã soạn', 'Đề cuối kỳ I có hướng dẫn chấm, 2 mã đề')
$GoiYO.KtOnTap = @('Đề cương ôn tập giữa kỳ I môn {mon} lớp {lop}', 'Đề cương ôn tập cuối kỳ I có bài tập mẫu')
$GoiYO.KtNhanXet = @('Nhận xét giữa kỳ cho từng học sinh lớp: (ghi lớp) (đính kèm bảng điểm)', 'Viết lại lời nhận xét ngắn gọn, tích cực hơn')
$GoiYO.KtTongHop = @('Tổng hợp điểm, xếp mức học kỳ I lớp: (ghi lớp) (đính kèm file)', 'Thống kê tỷ lệ điểm theo lớp để báo cáo')
$GoiYO.KtTracNghiem = @('Trò chơi trắc nghiệm từ đề kiểm tra đã soạn (đính kèm file)', 'Trắc nghiệm 10 câu ôn tập bài: (ghi bài), 4 đội thi đua')
$GoiYO.CnKeHoach = @('Kế hoạch chủ nhiệm lớp {lop} năm học {nam_hoc}', 'Kế hoạch chủ nhiệm tháng {thang}')
$GoiYO.CnHopPH = @('Nội dung họp cha mẹ học sinh đầu năm học', 'Báo cáo tình hình lớp để họp cha mẹ học sinh cuối học kỳ I')
$GoiYO.CnBienBan = @('Biên bản họp cha mẹ học sinh (dán ghi chép)', 'Biên bản họp lớp (dán ghi chép)')
$GoiYO.CnThu = @('Tin nhắn nhóm lớp nhắc: (ghi nội dung)', 'Thư mời cha mẹ học sinh dự họp: (ghi thời gian, địa điểm)')
$GoiYO.CnTheoDoi = @('Kế hoạch hỗ trợ học sinh học yếu môn: (ghi môn)', 'Cách trao đổi với cha mẹ học sinh về: (ghi tình huống, không ghi tên)')
$GoiYO.CnSinhHoat = @('Tiết sinh hoạt lớp tuần này theo chủ đề: (ghi chủ đề)', 'Kế hoạch sinh hoạt lớp tháng {thang}')
# Trang "Xưởng phần mềm": mẫu khởi đầu (thư mục mau\phan-mem\<tên>) - xuong.ps1 chép mẫu sang 10_PHAN_MEM\<dự án>
$MAU_PHAN_MEM = @(
    @{ N = 'XmTracNghiem'; Hanh = 'duan:trac-nghiem-doi'; Tieu = 'Trắc nghiệm thi đua đội'; MoTa = 'Câu hỏi 4 phương án, đếm ngược, 2-6 đội cộng điểm.';  Icon = [char]0xE9D5; Mau = '#2F6FE0' }
    @{ N = 'XmFlashcard';  Hanh = 'duan:flashcard';       Tieu = 'Thẻ ghi nhớ';             MoTa = 'Lật thẻ, xáo trộn, đánh dấu đã thuộc.';                Icon = [char]0xE8F1; Mau = '#0E3A86' }
    @{ N = 'XmVongQuay';   Hanh = 'duan:vong-quay';       Tieu = 'Vòng quay gọi tên';       MoTa = 'Quay chọn học sinh, chủ đề; loại tên đã quay.';        Icon = [char]0xE895; Mau = '#C97A12' }
    @{ N = 'XmDongHo';     Hanh = 'duan:dong-ho';         Tieu = 'Đồng hồ hoạt động nhóm';  MoTa = 'Đếm ngược chữ lớn, chuông báo, nút 1-3-5-10 phút.';    Icon = [char]0xE916; Mau = '#5B4BB7' }
    @{ N = 'XmOChu';       Hanh = 'duan:o-chu';           Tieu = 'Ô chữ';                   MoTa = 'Hàng ngang, từ khóa hàng dọc - ôn tập cuối bài.';      Icon = [char]0xE8D2; Mau = '#B0392E' }
    @{ N = 'XmTrong';      Hanh = 'duan:trong';           Tieu = 'Tự do';                   MoTa = 'Mô phỏng, sổ theo dõi, trò chơi riêng - tả bằng lời.'; Icon = [char]0xE943; Mau = '#14213D' }
)
# Gợi ý ở trang Trò chuyện AI - xếp theo thứ tự: việc nhẹ, làm được ngay khi máy mới cài ->
# việc cần có sẵn file, số liệu. Không để việc nặng (slide, bảng tính) lên đầu: chạy lâu,
# tốn lượt dùng, mà lúc đầu chưa có tài liệu, bảng điểm nào để lấy.
$GoiYChat = @('Soạn kế hoạch bài dạy cho bài: (ghi tên bài, lớp)',
    'Ra đề kiểm tra giữa kỳ có ma trận và hướng dẫn chấm',
    'Làm trò chơi trắc nghiệm ôn tập 10 câu cho lớp',
    'Nội dung họp cha mẹ học sinh đầu năm',
    'Tóm tắt văn bản mới nhất nhà trường gửi',
    'Viết nhận xét học sinh từ bảng điểm (đính kèm file)',
    'Lập bảng Excel tổng hợp điểm của lớp',
    'Làm slide bài giảng cho tiết sắp dạy')

# ============================================================================
# 2. Giao diện XAML
# ============================================================================
$xamlText = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Trợ lý Giáo viên" Width="1360" Height="860" MinWidth="1000" MinHeight="620"
        WindowStartupLocation="CenterScreen" Background="#F4F7FC" FontFamily="Segoe UI"
        UseLayoutRounding="True" SnapsToDevicePixels="True" TextOptions.TextFormattingMode="Display">
  <Window.Resources>
    <!-- Tiêu đề nhóm trong thanh bên -->
    <Style x:Key="NhomNav" TargetType="TextBlock">
      <Setter Property="FontSize" Value="11"/>
      <Setter Property="FontWeight" Value="Bold"/>
      <Setter Property="Foreground" Value="#F2C94C"/>
      <Setter Property="Margin" Value="16,15,0,4"/>
    </Style>
    <Style x:Key="Nav" TargetType="RadioButton">
      <Setter Property="GroupName" Value="nav"/>
      <Setter Property="Foreground" Value="#E3EAFA"/>
      <Setter Property="FontSize" Value="14.5"/>
      <Setter Property="Margin" Value="0,1"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="RadioButton">
            <Border x:Name="Bd" Background="Transparent" CornerRadius="10" Padding="14,8">
              <Grid>
                <Rectangle x:Name="Vach" Width="4" RadiusX="2" RadiusY="2" Fill="#E0B43A" HorizontalAlignment="Left" Margin="-9,1,0,1" Visibility="Collapsed"/>
                <StackPanel Orientation="Horizontal">
                  <TextBlock Text="{TemplateBinding Tag}" FontFamily="Segoe MDL2 Assets" FontSize="17" Width="28" VerticalAlignment="Center" Foreground="{TemplateBinding Foreground}"/>
                  <ContentPresenter VerticalAlignment="Center" Margin="9,0,0,0"/>
                </StackPanel>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="Background" Value="#26FFFFFF"/></Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="White"/>
                <Setter TargetName="Vach" Property="Visibility" Value="Visible"/>
                <Setter Property="Foreground" Value="#0B2B6B"/>
                <Setter Property="FontWeight" Value="SemiBold"/>
              </Trigger>
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
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#0E3A86"/><Setter TargetName="Bd" Property="Background" Value="#F2F6FE"/></Trigger>
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
            <Border x:Name="Bd" Background="#0E3A86" CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="Background" Value="#0B2B6B"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter TargetName="Bd" Property="Opacity" Value="0.5"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="NutVang" TargetType="Button">
      <Setter Property="Foreground" Value="#2A2206"/>
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="#F2C94C" CornerRadius="12" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="Background" Value="#E0B43A"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Lien" TargetType="Button">
      <Setter Property="Foreground" Value="#0E3A86"/>
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
        <Trigger Property="IsMouseOver" Value="True"><Setter Property="BorderBrush" Value="#E0B43A"/></Trigger>
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
    <Style x:Key="TieuDeKhoi" TargetType="TextBlock">
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="FontWeight" Value="Bold"/>
      <Setter Property="Foreground" Value="#0B2B6B"/>
      <Setter Property="Margin" Value="8,10,6,8"/>
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
              <Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#0E3A86"/></Trigger>
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
      <Setter Property="Background" Value="#EEF2FA"/>
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
                      <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#0E3A86"/></Trigger>
                      <Trigger Property="IsChecked" Value="True"><Setter TargetName="Bd" Property="BorderBrush" Value="#0E3A86"/></Trigger>
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
              <Trigger Property="IsHighlighted" Value="True"><Setter TargetName="Bd" Property="Background" Value="#EEF3FC"/></Trigger>
              <Trigger Property="IsSelected" Value="True"><Setter TargetName="Bd" Property="Background" Value="#E0E8F8"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Grid Background="#F4F7FC">
    <Grid.ColumnDefinitions>
      <ColumnDefinition x:Name="CotBen" Width="252"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>

    <!-- ===================== THANH BÊN TRÁI (navy + vàng kim) ===================== -->
    <Border x:Name="ThanhBen" Grid.Column="0">
      <Border.Background>
        <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
          <GradientStop Color="#0E3A86" Offset="0"/>
          <GradientStop Color="#0B2B6B" Offset="0.55"/>
          <GradientStop Color="#061A40" Offset="1"/>
        </LinearGradientBrush>
      </Border.Background>
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <!-- Họa tiết chấm trắng trên nền navy -->
        <Rectangle Grid.RowSpan="3" IsHitTestVisible="False">
          <Rectangle.Fill>
            <DrawingBrush TileMode="Tile" Viewport="0,0,18,18" ViewportUnits="Absolute" Viewbox="0,0,18,18" ViewboxUnits="Absolute" Opacity="0.06">
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
        <!-- Khối đầu thanh bên: logo, tên phần mềm, dòng phụ, đường kẻ ngăn với danh sách chức năng -->
        <StackPanel Margin="16,18,16,10">
          <StackPanel Orientation="Horizontal">
            <Border Width="50" Height="50" CornerRadius="14" Background="White" VerticalAlignment="Center">
              <Border.Effect><DropShadowEffect BlurRadius="10" ShadowDepth="2" Opacity="0.28" Color="#000814"/></Border.Effect>
              <Image x:Name="ImgLogo" Width="40" Height="40" RenderOptions.BitmapScalingMode="HighQuality"/>
            </Border>
            <StackPanel Margin="12,0,0,0" VerticalAlignment="Center">
              <TextBlock x:Name="TxtTenTL" Text="TRỢ LÝ" FontSize="21" FontWeight="Bold" Foreground="White"/>
              <TextBlock x:Name="TxtTenVP" Text="GIÁO VIÊN" FontSize="13" FontWeight="Bold" Foreground="#F2D98A" Margin="0,1,0,0"/>
            </StackPanel>
          </StackPanel>
          <TextBlock Text="Soạn bài · Kiểm tra · Sáng tạo" FontSize="11.5" FontWeight="SemiBold" Foreground="White" Margin="2,10,0,0"/>
          <Border Height="1" Background="#33FFFFFF" Margin="0,10,0,0"/>
          <Button x:Name="BtnGiaoViecMoiBen" Style="{StaticResource NutVang}" Height="42" Margin="0,10,0,0" ToolTip="Mở cuộc trò chuyện mới để giao việc cho trợ lý">
            <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE710;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,10,0"/><TextBlock Text="Giao việc mới" VerticalAlignment="Center" FontSize="15"/></StackPanel>
          </Button>
        </StackPanel>
        <ScrollViewer x:Name="CuonMenu" Grid.Row="1" VerticalScrollBarVisibility="Hidden" HorizontalScrollBarVisibility="Disabled">
          <StackPanel x:Name="DsMenu" Margin="14,0,14,8">
            <!-- Mẫu 2 "Bảng lớp": 11 mục chia 3 nhóm -->
            <TextBlock Text="VIỆC THƯỜNG LÀM" Style="{StaticResource NhomNav}" Margin="16,2,0,3"/>
            <RadioButton x:Name="NavTrangChu"    Style="{StaticResource Nav}" Tag="&#xE80F;" Content="Trang chủ" IsChecked="True"/>
            <RadioButton x:Name="NavTroChuyen"   Style="{StaticResource Nav}" Tag="&#xE8BD;" Content="Trò chuyện AI"/>
            <RadioButton x:Name="NavSoanVanBan"  Style="{StaticResource Nav}" Tag="&#xE8A5;" Content="Soạn bài dạy"/>
            <RadioButton x:Name="NavKiemTra"     Style="{StaticResource Nav}" Tag="&#xE9D5;" Content="Kiểm tra, đánh giá"/>
            <RadioButton x:Name="NavChuNhiem"    Style="{StaticResource Nav}" Tag="&#xE716;" Content="Chủ nhiệm lớp"/>
            <RadioButton x:Name="NavNhiemVu"     Style="{StaticResource Nav}" Tag="&#xE7C1;" Content="Hồ sơ chuyên môn"/>
            <RadioButton x:Name="NavLich"        Style="{StaticResource Nav}" Tag="&#xE787;" Content="Lịch, tiến độ"/>
            <TextBlock Text="XƯỞNG PHẦN MỀM" Style="{StaticResource NhomNav}"/>
            <RadioButton x:Name="NavXuong"       Style="{StaticResource Nav}" Tag="&#xE943;" Content="Xưởng phần mềm"/>
            <TextBlock Text="HỆ THỐNG" Style="{StaticResource NhomNav}"/>
            <RadioButton x:Name="NavThuVien"     Style="{StaticResource Nav}" Tag="&#xED25;" Content="Kho tài liệu"/>
            <RadioButton x:Name="NavTienIch"     Style="{StaticResource Nav}" Tag="&#xE90F;" Content="Kỹ năng trợ lý"/>
            <RadioButton x:Name="NavCaiDat"      Style="{StaticResource Nav}" Tag="&#xE713;" Content="Cài đặt"/>
          </StackPanel>
        </ScrollViewer>
        <!-- Chân thanh bên: đường kẻ, dấu trám vàng, châm ngôn (thay hình vẽ trụ sở cũ) -->
        <StackPanel x:Name="ChanBen" Grid.Row="2" Margin="16,8,16,16">
          <Border Height="1" Background="#2EFFFFFF"/>
          <Path Data="M6,0 L12,6 L6,12 L0,6 Z" Fill="#E0B43A" Width="9" Height="9" Stretch="Uniform" HorizontalAlignment="Center" Margin="0,12,0,0" Opacity="0.9"/>
          <TextBlock Text="TẤT CẢ VÌ HỌC SINH THÂN YÊU" FontSize="10.5" FontWeight="SemiBold" Foreground="#F2D98A" HorizontalAlignment="Center" Margin="0,8,0,0"/>
        </StackPanel>
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
      <Grid x:Name="DauTrang" Margin="28,18,28,12">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel VerticalAlignment="Center">
          <TextBlock Text="Trợ lý Giáo viên" FontSize="25" FontWeight="Bold" Foreground="#0B2B6B" TextTrimming="CharacterEllipsis"/>
          <TextBlock x:Name="TxtPhuDe" Text="Giáo viên THCS · Soạn bài – Kiểm tra – Sáng tạo" FontSize="13.5" Foreground="#4A5A70" Margin="0,3,0,0" TextTrimming="CharacterEllipsis"/>
        </StackPanel>
        <Grid Grid.Column="1" MaxWidth="440" MinWidth="200" Height="42" Margin="24,0,24,0" VerticalAlignment="Center">
          <TextBox x:Name="TxtTimNhanh" Style="{StaticResource Nhap}" Padding="30,0,0,0"/>
          <TextBlock Text="&#xE721;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#5B6B7F" VerticalAlignment="Center" Margin="16,0,0,0" IsHitTestVisible="False"/>
          <TextBlock x:Name="GoiYTimNhanh" Style="{StaticResource GoiY}" Margin="44,0,0,0" FontSize="13" Text="Nhập việc cần làm (ví dụ: kế hoạch bài dạy bài Hằng đẳng thức, Toán 8)..."/>
        </Grid>
        <Border x:Name="KhungNguoiDung" Grid.Column="2" Background="Transparent" Cursor="Hand" VerticalAlignment="Center">
          <StackPanel Orientation="Horizontal">
            <Border Width="44" Height="44" CornerRadius="22" Background="#0E3A86">
              <TextBlock x:Name="TxtVietTat" Text="GV" FontSize="16" FontWeight="SemiBold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <StackPanel Margin="12,0,10,0" VerticalAlignment="Center" MaxWidth="190">
              <TextBlock x:Name="TxtTenNguoiDung" Text="Thầy/cô" FontSize="15" FontWeight="SemiBold" Foreground="#0B2B6B" TextTrimming="CharacterEllipsis"/>
              <TextBlock x:Name="TxtChucVu" Text="Giáo viên" FontSize="12.5" Foreground="#5B6B7F" TextTrimming="CharacterEllipsis"/>
            </StackPanel>
            <TextBlock Text="&#xE70D;" FontFamily="Segoe MDL2 Assets" FontSize="12" Foreground="#40546B" VerticalAlignment="Center"/>
          </StackPanel>
          <Border.ContextMenu>
            <ContextMenu>
              <MenuItem x:Name="MnKhaiBao" Header="Khai báo thông tin giáo viên"/>
              <MenuItem x:Name="MnThongTin" Header="Thông tin và bộ nhớ"/>
              <MenuItem x:Name="MnDangNhap" Header="Cấu hình OpenRouter"/>
              <MenuItem x:Name="MnCaiDat" Header="Cài đặt"/>
            </ContextMenu>
          </Border.ContextMenu>
        </Border>
      </Grid>

      <!-- Các trang -->
      <Grid x:Name="VungTrang" Grid.Row="1" Margin="28,0,28,12">

        <!-- ========== TRANG CHỦ ========== -->
        <Grid x:Name="PgTrangChu">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="7*"/>
            <ColumnDefinition Width="18"/>
            <ColumnDefinition Width="3*" MinWidth="320" MaxWidth="430"/>
          </Grid.ColumnDefinitions>
          <Grid Grid.Column="0">
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="16"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid>
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="22,14" MinHeight="98">
                <Grid>
                  <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                  </Grid.ColumnDefinitions>
                  <Border Width="52" Height="52" CornerRadius="14" VerticalAlignment="Center">
                    <Border.Background>
                      <LinearGradientBrush StartPoint="0,0" EndPoint="1,1"><GradientStop Color="#0E3A86" Offset="0"/><GradientStop Color="#061A40" Offset="1"/></LinearGradientBrush>
                    </Border.Background>
                    <TextBlock Text="&#xE80F;" FontFamily="Segoe MDL2 Assets" FontSize="24" Foreground="#F2D98A" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                  </Border>
                  <StackPanel Grid.Column="1" Margin="18,0,12,0" VerticalAlignment="Center">
                    <TextBlock x:Name="TxtChao" Text="Chào buổi sáng!" FontSize="19" FontWeight="Bold" Foreground="#0B2B6B" TextWrapping="Wrap"/>
                    <TextBlock x:Name="TxtCauNoi" Text="“Mỗi bài dạy hay là một món quà cho học trò”" FontSize="14" FontStyle="Italic" Foreground="#34465F" Margin="0,6,0,0" TextWrapping="Wrap"/>
                    <StackPanel x:Name="KhungNhacKhaiBao" Orientation="Horizontal" Margin="0,8,0,0" Visibility="Collapsed">
                      <Button x:Name="BtnKhaiBaoNhanh" Style="{StaticResource NutChinh}" Padding="16,7">
                        <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE77B;" FontFamily="Segoe MDL2 Assets" FontSize="14" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Khai báo thông tin giáo viên" VerticalAlignment="Center"/></StackPanel>
                      </Button>
                    </StackPanel>
                  </StackPanel>
                  <Rectangle Grid.Column="2" Width="1" Fill="#E3EAF5" Margin="6,6"/>
                  <StackPanel Grid.Column="3" Orientation="Horizontal" Margin="18,0,4,0" VerticalAlignment="Center">
                    <TextBlock Text="&#xE787;" FontFamily="Segoe MDL2 Assets" FontSize="24" Foreground="#0E3A86" VerticalAlignment="Center"/>
                    <StackPanel Margin="12,0,0,0">
                      <TextBlock x:Name="TxtNgay" Text="" FontSize="15" Foreground="#1F3354"/>
                      <TextBlock x:Name="TxtTuanNay" Text="" FontSize="13" Foreground="#5B6B7F" Margin="0,5,0,0"/>
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
              <RowDefinition Height="*" MinHeight="120"/>
              <RowDefinition Height="14"/>
              <RowDefinition Height="*" MinHeight="120"/>
              <RowDefinition Height="14"/>
              <RowDefinition Height="*" MinHeight="120"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="18,12">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                  <Grid Margin="0,0,0,4">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="&#xE787;" FontFamily="Segoe MDL2 Assets" FontSize="17" Foreground="#0E3A86" VerticalAlignment="Center"/>
                    <TextBlock Grid.Column="1" Text="Tiến độ dạy học" FontSize="14.5" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,0,6,0" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
                    <Button x:Name="BtnXemTienDo" Grid.Column="2" Style="{StaticResource Lien}" VerticalAlignment="Center" Content="Xem tất cả  →"/>
                  </Grid>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsTienDo"/></ScrollViewer>
                </Grid>
              </Border>
            </Grid>
            <Grid Grid.Row="2">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="18,12">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                  <Grid Margin="0,0,0,4">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="&#xE943;" FontFamily="Segoe MDL2 Assets" FontSize="17" Foreground="#14213D" VerticalAlignment="Center"/>
                    <TextBlock Grid.Column="1" Text="Dự án phần mềm" FontSize="14.5" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,0,6,0" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
                    <Button x:Name="BtnXemDuAn" Grid.Column="2" Style="{StaticResource Lien}" VerticalAlignment="Center" Content="Xem tất cả  →"/>
                  </Grid>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsDuAnGon"/></ScrollViewer>
                </Grid>
              </Border>
            </Grid>
            <Grid Grid.Row="4">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="18,12">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                  <Grid Margin="0,0,0,4">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBlock Text="&#xE9D5;" FontFamily="Segoe MDL2 Assets" FontSize="17" Foreground="#C0392B" VerticalAlignment="Center"/>
                    <TextBlock Grid.Column="1" Text="Việc sắp đến hạn" FontSize="14.5" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,0,6,0" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
                    <Button x:Name="BtnXemViecHan" Grid.Column="2" Style="{StaticResource Lien}" VerticalAlignment="Center" Content="Xem tất cả  →"/>
                  </Grid>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsViecHan"/></ScrollViewer>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== SOẠN VĂN BẢN ========== -->
        <ScrollViewer x:Name="PgSoanVanBan" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Soạn bài dạy" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border><Button x:Name="TabTrang1" Style="{StaticResource TabTrang}" Tag="trang:Mau" Content="Mẫu tài liệu" Margin="0,0,22,0" ToolTip="Chuyển sang Mẫu tài liệu"/></StackPanel>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Ghi bài cần soạn rồi bấm Giao việc (hoặc nhấn Enter), hoặc ghi vài ý chính rồi bấm một loại tài liệu bên dưới. Trợ lý tự lấy môn, lớp, thiết bị phòng học trong bộ nhớ, soạn theo mẫu hiện hành và mở file Word. Mọi sản phẩm là bản nháp để thầy/cô xem lại."/>
            <Grid Height="80" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinh" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinh" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ví dụ: kế hoạch bài dạy Toán 8, bài Hằng đẳng thức đáng nhớ, 2 tiết, có hoạt động nhóm (Enter để gửi, Shift+Enter xuống dòng)"/>
              <Button x:Name="BtnGiaoViecSoan" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <UniformGrid Columns="5">
@@LOAIVB@@
            </UniformGrid>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel>
                    <TextBlock Text="Rà soát tài liệu có sẵn" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B"/>
                    <TextBlock Text="Chọn kế hoạch bài dạy, đề kiểm tra, phiếu học tập (Word, PDF) để kiểm tra kiến thức, thời lượng, chính tả và tạo bản đã sửa." FontSize="13" Foreground="#5B6B7F" TextWrapping="Wrap" Margin="0,4,0,0"/>
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
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang2" Style="{StaticResource TabTrang}" Tag="trang:SoanVanBan" Content="Soạn bài dạy" Margin="0,0,22,0" ToolTip="Chuyển sang Soạn bài dạy"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Mẫu tài liệu" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Mẫu kế hoạch bài dạy, đề kiểm tra, phiếu học tập, hồ sơ chủ nhiệm và văn bản hành chính của giáo viên. Muốn dùng mẫu riêng của trường, tổ: chép file vào thư mục mẫu riêng (07_MAU_RIENG), phần mềm ưu tiên mẫu đó và không ghi đè khi cập nhật. Trường, tổ có cách làm riêng một việc: nói với trợ lý &quot;ghi lại thành quy trình riêng&quot;, hoặc tự đặt tệp .md vào thư mục quy trình riêng."/>
          <Grid Grid.Row="2">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvMau">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Mẫu" Width="300" DisplayMemberBinding="{Binding Ten}"/>
                    <GridViewColumn Header="Dùng cho" Width="260" DisplayMemberBinding="{Binding CanCu}"/>
                    <GridViewColumn Header="Nguồn" Width="140" DisplayMemberBinding="{Binding Nguon}"/>
                    <GridViewColumn Header="File" Width="240" DisplayMemberBinding="{Binding File}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="3" Margin="0,14,0,0">
            <Button x:Name="BtnXemMau" Style="{StaticResource NutChinh}" Content="Xem mẫu dạng Word"/>
            <Button x:Name="BtnSoanTheoMau" Style="{StaticResource Nut}" Content="Soạn theo mẫu này"/>
            <Button x:Name="BtnHuongDanTheThuc" Style="{StaticResource Nut}" Content="Hướng dẫn trình bày"/>
            <Button x:Name="BtnMauRieng" Style="{StaticResource Nut}" Content="Mở thư mục mẫu riêng"/>
            <Button x:Name="BtnQuyTrinhRieng" Style="{StaticResource Nut}" Content="Quy trình riêng của tổ" ToolTip="Mở thư mục chứa các quy trình riêng - mỗi tệp .md là một lệnh của trợ lý"/>
          </WrapPanel>
        </Grid>

        <!-- ========== TRÒ CHUYỆN (khung chat LỚN - THIET-KE mục 0; xem app\tro-chuyen.ps1) ========== -->
        <Grid x:Name="PgTroChuyen" Visibility="Collapsed" AllowDrop="True" Background="Transparent">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/><RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid x:Name="DauChat" Margin="0,0,0,8">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <StackPanel x:Name="TieuDeChat">
              <TextBlock Text="Trò chuyện với trợ lý" Style="{StaticResource TieuDeTrang}"/>
              <TextBlock Style="{StaticResource MoTaTrang}" Margin="0,4,0,0" Text="Giao việc như nhắn tin - giao được 3 việc cùng lúc. Trợ lý tự đọc bộ nhớ lớp học, làm đến khi xong và gửi lại file. Việc của Xưởng phần mềm có khung Xem trước bên phải. Chữ nhỏ thì bấm A+; cần đọc kỹ thì bấm Phóng to (F11)."/>
            </StackPanel>
            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Top" Margin="12,2,0,0">
              <Button x:Name="BtnXemTruoc" Style="{StaticResource Nut}" Padding="12,6" Margin="0,0,10,0" Visibility="Collapsed" ToolTip="Hiện hoặc ẩn khung Xem trước của dự án phần mềm">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE7B3;" FontFamily="Segoe MDL2 Assets" FontSize="12" VerticalAlignment="Center" Margin="0,0,7,0"/><TextBlock Text="Xem trước" VerticalAlignment="Center"/></StackPanel>
              </Button>
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
            <Grid.ColumnDefinitions>
              <ColumnDefinition x:Name="CotViecChat" Width="248"/>
              <ColumnDefinition x:Name="CotHoChat" Width="14"/>
              <ColumnDefinition Width="*" MinWidth="360"/>
              <ColumnDefinition x:Name="CotHoXem" Width="0"/>
              <ColumnDefinition x:Name="CotXem" Width="0"/>
            </Grid.ColumnDefinitions>
            <Grid x:Name="KhungViecChat">
              <Grid.RowDefinitions><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
              <Grid>
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
              <Button x:Name="BtnChatMoi" Grid.Row="1" Style="{StaticResource NutVang}" Height="46" Margin="0,10,0,0" Padding="10,0" ToolTip="Mở một cuộc trò chuyện mới để giao việc khác - việc đang chạy vẫn tiếp tục">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE710;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,10,0"/><TextBlock Text="Việc mới" VerticalAlignment="Center"/></StackPanel>
              </Button>
            </Grid>
            <Grid Grid.Column="2">
              <Grid.RowDefinitions>
                <RowDefinition Height="*"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
              </Grid.RowDefinitions>
              <Grid>
                <Border Style="{StaticResource Bong}"/>
                <Border Style="{StaticResource The}" Padding="0">
                  <Grid>
                    <ScrollViewer x:Name="CuonChat" VerticalScrollBarVisibility="Auto" Padding="22,14"/>
                    <ScrollViewer x:Name="ChaoChat" VerticalScrollBarVisibility="Auto">
                      <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center" MaxWidth="820" Margin="24,16">
                        <Border Width="52" Height="52" CornerRadius="26" HorizontalAlignment="Center">
                          <Border.Background><LinearGradientBrush StartPoint="0,0" EndPoint="1,1"><GradientStop Color="#0E3A86" Offset="0"/><GradientStop Color="#061A40" Offset="1"/></LinearGradientBrush></Border.Background>
                          <TextBlock Text="&#xE8BD;" FontFamily="Segoe MDL2 Assets" FontSize="26" Foreground="#F2D98A" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <TextBlock x:Name="TxtChaoChat" Text="Thầy/cô cần em giúp việc gì hôm nay?" FontSize="21" FontWeight="Bold" Foreground="#0B2B6B" HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap" Margin="0,14,0,6"/>
                        <TextBlock Text="Gõ việc cần làm vào ô bên dưới hoặc chọn một gợi ý. Kéo thả file Word, PDF, Excel vào đây để em đọc." FontSize="13.5" Foreground="#5B6B7F" HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap"/>
                        <WrapPanel x:Name="DsGoiY" HorizontalAlignment="Center" Margin="0,14,0,0"/>
                      </StackPanel>
                    </ScrollViewer>
                  </Grid>
                </Border>
              </Grid>
              <Border x:Name="KhungTienTrinh" Grid.Row="1" Visibility="Collapsed" Background="White" BorderBrush="#CFDDF6" BorderThickness="1" CornerRadius="12" Padding="16,10" Margin="0,10,0,0">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <TextBlock x:Name="IconTienTrinh" Text="&#xE895;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#0E3A86" VerticalAlignment="Center" RenderTransformOrigin="0.5,0.5"/>
                  <StackPanel Grid.Column="1" Margin="12,0,14,0" VerticalAlignment="Center">
                    <Grid>
                      <TextBlock x:Name="TxtBuoc" Text="Đang đọc yêu cầu..." FontSize="13.5" FontWeight="SemiBold" Foreground="#1F3354" TextTrimming="CharacterEllipsis" Margin="0,0,120,0"/>
                      <TextBlock x:Name="TxtThoiGian" HorizontalAlignment="Right" FontSize="12.5" Foreground="#5B6B7F"/>
                    </Grid>
                    <ProgressBar x:Name="ThanhTienTrinh" Height="8" Margin="0,7,0,0" Minimum="0" Maximum="100" Foreground="#0E3A86" Background="#E8EEF8" BorderThickness="0"/>
                  </StackPanel>
                  <TextBlock x:Name="TxtPhanTram" Grid.Column="2" Text="0%" FontSize="18" FontWeight="Bold" Foreground="#0E3A86" VerticalAlignment="Center" MinWidth="52" TextAlignment="Right" Margin="0,0,14,0"/>
                  <Button x:Name="BtnDungChat" Grid.Column="3" Style="{StaticResource Nut}" Margin="0" VerticalAlignment="Center">
                    <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE71A;" FontFamily="Segoe MDL2 Assets" FontSize="12" Foreground="#D32F2F" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Dừng" VerticalAlignment="Center"/></StackPanel>
                  </Button>
                </Grid>
              </Border>
              <StackPanel Grid.Row="2" Margin="0,8,0,0">
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
              <Grid Grid.Row="3" Margin="0,10,0,0">
                <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                <Button x:Name="BtnDinhKem" Style="{StaticResource Nut}" Height="48" Padding="14,0" VerticalAlignment="Bottom" ToolTip="Đính kèm file (Word, PDF, Excel, ảnh) - chụp màn hình rồi Ctrl+V vào ô nhập cũng được">
                  <TextBlock Text="&#xE723;" FontFamily="Segoe MDL2 Assets" FontSize="18" Foreground="#0E3A86"/>
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
            <!-- Xưởng phần mềm: xem trước dự án của việc đang chọn (xuong.ps1) -->
            <Grid x:Name="KhungXem" Grid.Column="4" Visibility="Collapsed">
              <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
              <Border Background="#E3EAF5" CornerRadius="14,14,0,0" Padding="12,7">
                <Grid>
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <Ellipse Width="10" Height="10" Fill="#E85D4A" Margin="0,0,5,0"/><Ellipse Width="10" Height="10" Fill="#F2C94C" Margin="0,0,5,0"/><Ellipse Width="10" Height="10" Fill="#2F6FE0" Margin="0,0,10,0"/>
                    <TextBlock x:Name="TxtXemTen" Text="Xem trước" FontSize="13" FontWeight="SemiBold" Foreground="#1F3354" VerticalAlignment="Center" TextTrimming="CharacterEllipsis" MaxWidth="220"/>
                  </StackPanel>
                  <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <Button x:Name="BtnXemTaiLai" Style="{StaticResource Nut}" Padding="9,5" Margin="0,0,6,0" ToolTip="Tải lại bản chạy thử"><TextBlock Text="&#xE72C;" FontFamily="Segoe MDL2 Assets" FontSize="13"/></Button>
                    <Button x:Name="BtnXemToanMan" Style="{StaticResource Nut}" Padding="10,5" Margin="0,0,6,0" ToolTip="Mở toàn màn hình bằng trình duyệt (dùng trên máy chiếu)">
                      <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE740;" FontFamily="Segoe MDL2 Assets" FontSize="12" VerticalAlignment="Center" Margin="0,0,6,0"/><TextBlock Text="Toàn màn hình" VerticalAlignment="Center" FontSize="12.5"/></StackPanel>
                    </Button>
                    <Button x:Name="BtnXemThuMuc" Style="{StaticResource Nut}" Padding="9,5" Margin="0,0,6,0" ToolTip="Mở thư mục dự án"><TextBlock Text="&#xED25;" FontFamily="Segoe MDL2 Assets" FontSize="13"/></Button>
                    <Button x:Name="BtnXemDongGoi" Style="{StaticResource NutVang}" Padding="12,5" Margin="0,0,6,0" ToolTip="Nén dự án thành file .zip để gửi học sinh, đồng nghiệp">
                      <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE7B8;" FontFamily="Segoe MDL2 Assets" FontSize="12" VerticalAlignment="Center" Margin="0,0,6,0"/><TextBlock Text="Đóng gói" VerticalAlignment="Center" FontSize="12.5"/></StackPanel>
                    </Button>
                    <Button x:Name="BtnXemAn" Style="{StaticResource Lien}" Padding="6,4" VerticalAlignment="Center" ToolTip="Ẩn khung xem trước"><TextBlock Text="&#xE711;" FontFamily="Segoe MDL2 Assets" FontSize="12" Foreground="#40546B"/></Button>
                  </StackPanel>
                </Grid>
              </Border>
              <Border Grid.Row="1" Background="#14213D" CornerRadius="0,0,14,14" ClipToBounds="True">
                <Grid x:Name="LuoiXem">
                  <TextBlock x:Name="TxtXemTrong" Text="Chưa có bản chạy thử." Foreground="#C9D3EA" FontSize="14" TextWrapping="Wrap" TextAlignment="Center" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="30" LineHeight="22"/>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== HỒ SƠ CHUYÊN MÔN ========== -->
        <ScrollViewer x:Name="PgNhiemVu" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Hồ sơ chuyên môn" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Kế hoạch giáo dục, tiến độ dạy học, sinh hoạt chuyên môn, sáng kiến, chuẩn nghề nghiệp, báo cáo của giáo viên. Bấm một ô để chọn việc - trợ lý chờ thầy/cô ghi việc cụ thể rồi mới làm."/>
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
            <Grid Height="80" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhNV" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhNV" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi, Shift+Enter xuống dòng), hoặc ghi vài ý chính rồi bấm một ô bên dưới."/>
              <Button x:Name="BtnGiaoViecNV" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <StackPanel>
@@NHIEMVU@@
            </StackPanel>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== KIỂM TRA, ĐÁNH GIÁ ========== -->
        <ScrollViewer x:Name="PgKiemTra" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Kiểm tra, đánh giá" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Ma trận, bản đặc tả, đề kiểm tra và hướng dẫn chấm theo định dạng hiện hành; nhận xét, tổng hợp điểm từ bảng điểm. Đề đã soạn lưu ở thư mục 03_KIEM_TRA; bảng điểm thả vào khung bên phải (lưu ở 06_DU_LIEU)."/>
            <Grid Height="80" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhKT" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhKT" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi), hoặc bấm một ô bên dưới. Ví dụ: đề kiểm tra giữa kỳ I Toán 8, 90 phút, có ma trận và hướng dẫn chấm..."/>
              <Button x:Name="BtnGiaoViecKT" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <UniformGrid Columns="3">
@@KIEMTRA@@
            </UniformGrid>
            <Grid Margin="6,14,6,0">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="18"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
              <Grid>
                <Border Style="{StaticResource Bong}"/>
                <Border Style="{StaticResource The}" Padding="12">
                  <StackPanel>
                    <Grid Margin="4,0,4,8">
                      <TextBlock Text="Đề, ma trận đã soạn (03_KIEM_TRA)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                    </Grid>
                    <ListView x:Name="LvKiemTra" Height="250">
                      <ListView.View>
                        <GridView>
                          <GridViewColumn Header="Tên tài liệu" Width="300" DisplayMemberBinding="{Binding Ten}"/>
                          <GridViewColumn Header="Ngày sửa" Width="120" DisplayMemberBinding="{Binding NgayTxt}"/>
                        </GridView>
                      </ListView.View>
                    </ListView>
                    <WrapPanel Margin="4,10,0,0">
                      <Button x:Name="BtnMoKT" Style="{StaticResource NutChinh}" Content="Mở" Margin="0,0,8,8"/>
                      <Button x:Name="BtnSuaKT" Style="{StaticResource Nut}" Content="Sửa tiếp" Margin="0,0,8,8"/>
                      <Button x:Name="BtnTroChoiKT" Style="{StaticResource Nut}" Content="Làm trò chơi từ đề này" Margin="0,0,8,8"/>
                      <Button x:Name="BtnThuMucKT" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0,0,8,8"/>
                    </WrapPanel>
                  </StackPanel>
                </Border>
              </Grid>
              <Grid Grid.Column="2">
                <Border Style="{StaticResource Bong}"/>
                <Border Style="{StaticResource The}" Padding="12">
                  <StackPanel>
                    <TextBlock Text="Bảng điểm, danh sách lớp (06_DU_LIEU)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="4,0,4,8"/>
                    <Grid x:Name="VungThaDiem" Height="58" Margin="4,0,4,10" AllowDrop="True" Background="Transparent" Cursor="Hand">
                      <Rectangle RadiusX="12" RadiusY="12" Stroke="#8FB3F2" StrokeThickness="1.4" StrokeDashArray="5,4" Fill="#F5F9FF"/>
                      <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center">
                        <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="20" Foreground="#0E3A86" VerticalAlignment="Center"/>
                        <TextBlock Text="Kéo thả file Excel bảng điểm vào đây (hoặc bấm để chọn)" FontSize="13.5" Foreground="#40546B" VerticalAlignment="Center" Margin="10,0,0,0" TextWrapping="Wrap"/>
                      </StackPanel>
                    </Grid>
                    <ListView x:Name="LvDiem" Height="182" SelectionMode="Extended">
                      <ListView.View>
                        <GridView>
                          <GridViewColumn Header="File" Width="300" DisplayMemberBinding="{Binding File}"/>
                          <GridViewColumn Header="Ngày sửa" Width="120" DisplayMemberBinding="{Binding NgayTxt}"/>
                        </GridView>
                      </ListView.View>
                    </ListView>
                    <WrapPanel Margin="4,10,0,0">
                      <Button x:Name="BtnNhanXetDiem" Style="{StaticResource NutChinh}" Content="Nhận xét từ bảng điểm" Margin="0,0,8,8"/>
                      <Button x:Name="BtnTongHopDiem" Style="{StaticResource Nut}" Content="Tổng hợp, xếp loại" Margin="0,0,8,8"/>
                      <Button x:Name="BtnMoDiem" Style="{StaticResource Nut}" Content="Mở file" Margin="0,0,8,8"/>
                    </WrapPanel>
                  </StackPanel>
                </Border>
              </Grid>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== CHỦ NHIỆM LỚP ========== -->
        <ScrollViewer x:Name="PgChuNhiem" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Chủ nhiệm lớp" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Kế hoạch chủ nhiệm, họp cha mẹ học sinh, biên bản, tin nhắn, tiết sinh hoạt lớp. Hồ sơ lưu ở thư mục 04_CHU_NHIEM. Thông tin riêng của từng học sinh chỉ nằm trong file của thầy/cô, trợ lý không ghi vào bộ nhớ."/>
            <Grid Height="80" Margin="0,0,0,12">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
              <TextBox x:Name="TxtYChinhCN" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
              <TextBlock x:Name="GoiYYChinhCN" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ghi việc cần làm rồi bấm Giao việc (Enter để gửi), hoặc bấm một ô bên dưới. Ví dụ: nội dung họp cha mẹ học sinh đầu năm lớp 8A; tin nhắn nhắc nộp hồ sơ..."/>
              <Button x:Name="BtnGiaoViecCN" Grid.Column="1" Style="{StaticResource NutChinh}" Height="Auto" VerticalAlignment="Stretch" Margin="12,0,0,0" Padding="24,0" ToolTip="Gửi việc ghi trong ô cho trợ lý (Enter)">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE724;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Giao việc" VerticalAlignment="Center" FontSize="14.5"/></StackPanel>
              </Button>
            </Grid>
            <UniformGrid Columns="3">
@@CHUNHIEM@@
            </UniformGrid>
            <Grid Margin="6,14,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="12">
                <StackPanel>
                  <Grid Margin="4,0,4,8">
                    <TextBlock Text="Hồ sơ chủ nhiệm (04_CHU_NHIEM)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" VerticalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                      <Button x:Name="BtnMoCN" Style="{StaticResource Nut}" Content="Mở"/>
                      <Button x:Name="BtnSuaCN" Style="{StaticResource Nut}" Content="Sửa tiếp với trợ lý"/>
                      <Button x:Name="BtnThuMucCN" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0"/>
                    </StackPanel>
                  </Grid>
                  <ListView x:Name="LvChuNhiem" Height="230">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Tên tài liệu" Width="560" DisplayMemberBinding="{Binding Ten}"/>
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

        <!-- ========== XƯỞNG PHẦN MỀM (xuong.ps1) ========== -->
        <ScrollViewer x:Name="PgXuong" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Xưởng phần mềm" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Tả bằng lời phần mềm muốn có cho lớp học - trò chơi, trắc nghiệm thi đua, mô phỏng, thẻ ghi nhớ... Trợ lý viết ứng dụng chạy trên trình duyệt, không cần mạng, không cần cài. Thầy/cô xem trước ngay bên cạnh khung trò chuyện, nói tiếp để sửa, rồi đóng gói gửi học sinh."/>
            <Grid Margin="6,0,6,6">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="18,14">
                <StackPanel>
                  <TextBlock Text="Dự án mới" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                  <Grid Height="84">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBox x:Name="TxtYeuCauXuong" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
                    <TextBlock x:Name="GoiYYeuCauXuong" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,10,14,0" TextWrapping="Wrap" Text="Ví dụ: trò chơi Ai nhanh hơn ôn hằng đẳng thức đáng nhớ, 10 câu, đếm ngược 20 giây, 4 đội cộng điểm, chữ to cho máy chiếu (Enter để bắt đầu)"/>
                    <Button x:Name="BtnTaoDuAn" Grid.Column="1" Style="{StaticResource NutVang}" Margin="12,0,0,0" Padding="22,0" ToolTip="Tạo dự án và giao cho trợ lý làm ngay">
                      <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE943;" FontFamily="Segoe MDL2 Assets" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Bắt đầu làm" VerticalAlignment="Center"/></StackPanel>
                    </Button>
                  </Grid>
                  <TextBlock Text="Hoặc bắt đầu từ một mẫu có sẵn (bấm mẫu: chép mẫu thành dự án, trợ lý chờ thầy/cô nói cần đổi gì; đã ghi yêu cầu ở ô trên thì trợ lý làm theo mẫu đó):" FontSize="13" Foreground="#5B6B7F" TextWrapping="Wrap" Margin="0,12,0,4"/>
                  <UniformGrid Columns="3">
@@XUONG@@
                  </UniformGrid>
                </StackPanel>
              </Border>
            </Grid>
            <Grid Margin="6,12,6,0">
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="12">
                <StackPanel>
                  <TextBlock Text="Dự án của tôi (10_PHAN_MEM)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="4,0,4,8"/>
                  <ListView x:Name="LvDuAn" Height="240">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Dự án" Width="330" DisplayMemberBinding="{Binding Ten}"/>
                        <GridViewColumn Header="Loại" Width="160" DisplayMemberBinding="{Binding Loai}"/>
                        <GridViewColumn Header="Dùng cho" Width="140" DisplayMemberBinding="{Binding DungCho}"/>
                        <GridViewColumn Header="Trạng thái" Width="130" DisplayMemberBinding="{Binding TrangThai}"/>
                        <GridViewColumn Header="Cập nhật" Width="130" DisplayMemberBinding="{Binding NgayTxt}"/>
                      </GridView>
                    </ListView.View>
                  </ListView>
                  <WrapPanel Margin="4,10,0,0">
                    <Button x:Name="BtnMoDuAn" Style="{StaticResource NutChinh}" Content="Mở và làm tiếp" Margin="0,0,8,8"/>
                    <Button x:Name="BtnChayDuAn" Style="{StaticResource Nut}" Content="Chạy toàn màn hình" Margin="0,0,8,8"/>
                    <Button x:Name="BtnDongGoiDuAn" Style="{StaticResource Nut}" Content="Đóng gói gửi học sinh" Margin="0,0,8,8"/>
                    <Button x:Name="BtnThuMucDuAn" Style="{StaticResource Nut}" Content="Mở thư mục" Margin="0,0,8,8"/>
                  </WrapPanel>
                </StackPanel>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== QUẢN LÝ CÔNG VIỆC ========== -->
        <Grid x:Name="PgCongViec" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang7" Style="{StaticResource TabTrang}" Tag="trang:Lich" Content="Lịch, tiến độ" Margin="0,0,22,0" ToolTip="Chuyển sang Lịch, tiến độ"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Công việc" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Việc cần làm của thầy/cô (trợ lý cũng đọc và ghi vào danh sách này) và các hạn trong lịch năm học."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="150"/><ColumnDefinition Width="90"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <DatePicker x:Name="DpNgayViec" FontSize="14" VerticalContentAlignment="Center" Height="40" Margin="0,0,10,0"/>
            <Grid Grid.Column="1" Height="40" Margin="0,0,10,0">
              <TextBox x:Name="TxtGioViec" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYGio" Style="{StaticResource GoiY}" Text="08:00"/>
            </Grid>
            <Grid Grid.Column="2" Height="40" Margin="0,0,10,0">
              <TextBox x:Name="TxtNoiDungViec" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYViec" Style="{StaticResource GoiY}" Text="Nội dung công việc, ví dụ: Nộp kế hoạch bài dạy tuần 3 cho tổ trưởng"/>
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
                  <TextBlock Text="Việc theo hạn (lịch năm học)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsHan"/></ScrollViewer>
                  <WrapPanel Grid.Row="2" Margin="0,10,0,0">
                    <Button x:Name="BtnVbTuCongViec" Style="{StaticResource NutChinh}" Content="Lập việc tháng này"/>
                    <Button x:Name="BtnSoTheoDoi" Style="{StaticResource Nut}" Content="Mở lịch năm học"/>
                  </WrapPanel>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== LỊCH CÔNG TÁC ========== -->
        <Grid x:Name="PgLich" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Lịch, tiến độ" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border><Button x:Name="TabTrang6" Style="{StaticResource TabTrang}" Tag="trang:CongViec" Content="Công việc" Margin="0,0,22,0" ToolTip="Chuyển sang Quản lý công việc"/></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Tiến độ dạy học theo tuần (bộ nhớ tien-do-day-hoc.md) và các mốc của năm học: khai giảng, kiểm tra giữa kỳ, cuối kỳ, sơ kết, tổng kết, hạn nộp hồ sơ (bộ nhớ lich-nam-hoc.md)."/>
          <WrapPanel Grid.Row="2" Margin="0,0,0,14">
            <Button x:Name="BtnLapLichTuan" Style="{StaticResource NutChinh}" Content="Lập tiến độ dạy học"/>
            <Button x:Name="BtnCapNhatMoc" Style="{StaticResource Nut}" Content="Cập nhật mốc năm học"/>
            <Button x:Name="BtnMoLichNamHoc" Style="{StaticResource Nut}" Content="Mở file lịch năm học"/>
            <Button x:Name="BtnSangCongViec" Style="{StaticResource Nut}" Content="Quản lý công việc"/>
          </WrapPanel>
          <Grid Grid.Row="3">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="18"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
            <Grid>
              <Border Style="{StaticResource Bong}"/>
              <Border Style="{StaticResource The}" Padding="10">
                <Grid>
                  <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                  <TextBlock Text="Tiến độ dạy học (bấm đúp để trao đổi với trợ lý)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="10,6,0,8"/>
                  <ListView x:Name="LvLich" Grid.Row="1">
                    <ListView.View>
                      <GridView>
                        <GridViewColumn Header="Tuần" Width="60" DisplayMemberBinding="{Binding Tuan}"/>
                        <GridViewColumn Header="Lớp, môn" Width="110" DisplayMemberBinding="{Binding Lop}"/>
                        <GridViewColumn Header="Tiết" Width="60" DisplayMemberBinding="{Binding Tiet}"/>
                        <GridViewColumn Header="Bài" Width="210" DisplayMemberBinding="{Binding Bai}"/>
                        <GridViewColumn Header="Trạng thái" Width="100" DisplayMemberBinding="{Binding TrangThai}"/>
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
                  <TextBlock Text="Mốc năm học" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                  <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="DsMoc"/></ScrollViewer>
                </Grid>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <!-- ========== TỔNG HỢP SỐ LIỆU ========== -->
        <Grid x:Name="PgTongHop" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*" MinHeight="90"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang3" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Kỹ năng trợ lý" Margin="0,0,14,0" ToolTip="Chuyển sang Kỹ năng trợ lý"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Tổng hợp bảng điểm" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Đưa file Excel/CSV (bảng điểm, danh sách lớp, kết quả khảo sát) vào đây, chọn file (giữ Ctrl để chọn nhiều file), ghi yêu cầu rồi bấm Giao việc tổng hợp. Thông tin cá nhân học sinh chỉ dùng trong file của thầy/cô, trợ lý không ghi vào bộ nhớ."/>
          <Grid x:Name="VungThaDuLieu" Grid.Row="2" Height="72" Margin="0,0,0,12" AllowDrop="True" Background="Transparent" Cursor="Hand">
            <Rectangle RadiusX="14" RadiusY="14" Stroke="#8FB3F2" StrokeThickness="1.6" StrokeDashArray="5,4" Fill="#F5F9FF"/>
            <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
              <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="26" Foreground="#0E3A86" VerticalAlignment="Center"/>
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
          <Grid Grid.Row="4" Margin="0,12,0,0">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="16,12,16,8">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <TextBlock Text="&#xE8BD;" FontFamily="Segoe MDL2 Assets" FontSize="15" Foreground="#0E3A86" VerticalAlignment="Center"/>
                  <TextBlock Text="Yêu cầu tổng hợp" FontSize="14.5" FontWeight="SemiBold" Foreground="#1F3354" Margin="8,0,0,0" VerticalAlignment="Center"/>
                  <TextBlock Text="  ·  Enter để gửi, Shift+Enter xuống dòng" FontSize="12" Foreground="#7A8AA0" VerticalAlignment="Center"/>
                </StackPanel>
                <Grid Height="58" Margin="0,8,0,0">
                  <TextBox x:Name="TxtYeuCauTH" Style="{StaticResource Nhap}" AcceptsReturn="True" TextWrapping="Wrap" VerticalContentAlignment="Top" VerticalScrollBarVisibility="Auto"/>
                  <TextBlock x:Name="GoiYYeuCauTH" Style="{StaticResource GoiY}" VerticalAlignment="Top" Margin="14,9,14,0" TextWrapping="Wrap" Text="Ghi rõ cần tổng hợp gì. Ví dụ: điểm trung bình môn Toán học kỳ I từng lớp, tỷ lệ theo mức, so sánh với giữa kỳ; lập bảng và viết nhận xét."/>
                </Grid>
                <WrapPanel x:Name="WpGoiYTH" Margin="0,8,0,0"/>
              </StackPanel>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="5" Margin="0,12,0,0">
            <Button x:Name="BtnTongHopFile" Style="{StaticResource NutChinh}" Content="Giao việc tổng hợp"/>
            <Button x:Name="BtnSangDonVi" Style="{StaticResource Nut}" Content="Kiểm tra, đánh giá"/>
            <Button x:Name="BtnMoDuLieu" Style="{StaticResource Nut}" Content="Mở thư mục dữ liệu"/>
          </WrapPanel>
        </Grid>

        <!-- ========== TRA CỨU ========== -->
        <Grid x:Name="PgTraCuu" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang4" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Kỹ năng trợ lý" Margin="0,0,14,0" ToolTip="Chuyển sang Kỹ năng trợ lý"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Tra cứu quy định" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Hỏi về kế hoạch bài dạy, kiểm tra đánh giá học sinh, chương trình, chế độ làm việc giáo viên, dạy thêm học thêm, chuẩn nghề nghiệp... Trợ lý trả lời kèm căn cứ và chỉ dùng số hiệu văn bản có trong danh mục đã đối chiếu dưới đây."/>
          <Grid Grid.Row="2" Margin="0,0,0,14">
            <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <Grid Height="44" Margin="0,0,10,0">
              <TextBox x:Name="TxtCauHoi" Style="{StaticResource Nhap}"/>
              <TextBlock x:Name="GoiYCauHoi" Style="{StaticResource GoiY}" Text="Ví dụ: Mỗi học kỳ học sinh THCS được đánh giá thường xuyên mấy lần?"/>
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
            <Button x:Name="BtnCanCuTruong" Style="{StaticResource Nut}" Content="Văn bản của Sở, của trường"/>
          </WrapPanel>
        </Grid>

        <!-- ========== THƯ VIỆN VĂN BẢN ========== -->
        <Grid x:Name="PgThuVien" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <TextBlock Text="Kho tài liệu" Style="{StaticResource TieuDeTrang}"/>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Toàn bộ bài dạy, đề kiểm tra, hồ sơ trợ lý đã soạn, bản đóng gói phần mềm, văn bản và dữ liệu thầy/cô đã đưa vào. Bấm đúp để mở file."/>
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
                <TextBlock Text="Mở thư mục làm việc" VerticalAlignment="Center"/>
              </StackPanel>
            </Button>
          </Grid>
          <Grid Grid.Row="3">
            <Border Style="{StaticResource Bong}"/>
            <Border Style="{StaticResource The}" Padding="8">
              <ListView x:Name="LvThuVien">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Tên tài liệu" Width="470" DisplayMemberBinding="{Binding Ten}"/>
                    <GridViewColumn Header="Loại" Width="150" DisplayMemberBinding="{Binding Loai}"/>
                    <GridViewColumn Header="Định dạng" Width="90" DisplayMemberBinding="{Binding DinhDang}"/>
                    <GridViewColumn Header="Ngày sửa" Width="140" DisplayMemberBinding="{Binding NgayTxt}"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Border>
          </Grid>
          <WrapPanel Grid.Row="4" Margin="0,14,0,0">
            <Button x:Name="BtnMoVB" Style="{StaticResource NutChinh}" Content="Mở"/>
            <Button x:Name="BtnMoThuMucChua" Style="{StaticResource Nut}" Content="Mở thư mục chứa file"/>
            <Button x:Name="BtnSuaTiep" Style="{StaticResource Nut}" Content="Sửa tiếp với trợ lý"/>
            <Button x:Name="BtnRaSoatVB" Style="{StaticResource Nut}" Content="Rà soát tài liệu này"/>
          </WrapPanel>
        </Grid>

        <!-- ========== CÔNG CỤ TIỆN ÍCH ========== -->
        <ScrollViewer x:Name="PgTienIch" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Kỹ năng trợ lý" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Các kỹ năng (quy trình) của trợ lý và công cụ quản lý dữ liệu. Bấm một ô để chọn kỹ năng - trợ lý chờ thầy/cô ghi việc cụ thể rồi mới làm."/>
            <StackPanel>
@@TIENICH@@
            </StackPanel>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== VĂN BẢN ĐẾN ========== -->
        <Grid x:Name="PgVanBanDen" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel Orientation="Horizontal" Margin="0,0,0,2"><Button x:Name="TabTrang5" Style="{StaticResource TabTrang}" Tag="trang:TienIch" Content="Kỹ năng trợ lý" Margin="0,0,14,0" ToolTip="Chuyển sang Kỹ năng trợ lý"/><TextBlock Text="›" FontSize="22" FontWeight="Bold" Foreground="#9AA8BA" Margin="0,0,14,3" VerticalAlignment="Bottom"/><Border BorderThickness="0,0,0,3" BorderBrush="#2F6FE0" Padding="0,0,0,3" Margin="0,0,22,0"><TextBlock Text="Văn bản nhà trường" Style="{StaticResource TieuDeTrang}" Margin="0"/></Border></StackPanel>
          <TextBlock Grid.Row="1" Style="{StaticResource MoTaTrang}" Text="Thả file văn bản của trường, tổ chuyên môn, Sở, Phòng (Word, PDF, ảnh chụp) để trợ lý tóm tắt, trích việc giáo viên phải làm và hạn nộp."/>
          <Grid x:Name="VungThaVBDen" Grid.Row="2" Height="88" Margin="0,0,0,14" AllowDrop="True" Background="Transparent" Cursor="Hand">
            <Rectangle RadiusX="14" RadiusY="14" Stroke="#F0B429" StrokeThickness="1.6" StrokeDashArray="5,4" Fill="#FFFBF0"/>
            <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
              <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="26" Foreground="#C97A12" VerticalAlignment="Center"/>
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
            <Button x:Name="BtnPhieuGQ" Style="{StaticResource Nut}" Content="Ghi việc phải làm, hạn nộp"/>
            <Button x:Name="BtnSoTheoDoi2" Style="{StaticResource Nut}" Content="Quản lý công việc"/>
            <Button x:Name="BtnMoVBDen" Style="{StaticResource Nut}" Content="Mở thư mục"/>
          </WrapPanel>
        </Grid>

        <!-- ========== CÀI ĐẶT ========== -->
        <ScrollViewer x:Name="PgCaiDat" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="Cài đặt" Style="{StaticResource TieuDeTrang}"/>
            <TextBlock Style="{StaticResource MoTaTrang}" Text="Tình trạng công cụ, kết nối OpenRouter, mô hình AI, thông tin giáo viên và bộ nhớ của trợ lý."/>
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
                      <ProgressBar x:Name="PbCapNhat" Height="8" Margin="0,10,0,0" Minimum="0" Maximum="100" Visibility="Collapsed" Foreground="#0B8A8F" Background="#E6ECF5" BorderThickness="0"/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnKiemTraCapNhat" Style="{StaticResource NutChinh}" Content="Kiểm tra bản mới" Margin="0,0,10,8"/>
                        <Button x:Name="BtnCapNhatFile" Style="{StaticResource NutChinh}" Content="Cập nhật từ file cài đặt" Margin="0,0,10,8"/>
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
                      <TextBlock Text="Thông tin giáo viên (bộ nhớ của trợ lý)" FontSize="16" FontWeight="Bold" Foreground="#0B2B6B" Margin="0,0,0,8"/>
                      <TextBlock x:Name="TxtThongTinTruong" TextWrapping="Wrap" FontSize="13.5" Foreground="#1F3354" LineHeight="22"/>
                      <WrapPanel Margin="0,12,0,0">
                        <Button x:Name="BtnKhaiBao" Style="{StaticResource NutChinh}" Content="Khai báo thông tin giáo viên" Margin="0,0,10,8"/>
                        <Button x:Name="BtnCapNhatTruong" Style="{StaticResource Nut}" Content="Cập nhật cùng trợ lý" Margin="0,0,10,8"/>
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
      <Border x:Name="ChanTrang" Grid.Row="2" Background="White" BorderBrush="#E3EAF5" BorderThickness="0,1,0,0" Padding="28,9">
        <Grid>
          <StackPanel x:Name="KhungTrangThai" Orientation="Horizontal" VerticalAlignment="Center" Background="Transparent" Cursor="Hand">
            <Ellipse x:Name="ChamTrangThai" Width="11" Height="11" Fill="#B0BAC6"/>
            <TextBlock x:Name="TxtTrangThai" Text="Đang kiểm tra..." Margin="8,0,0,0" FontSize="13.5" Foreground="#1F3354" MaxWidth="290" TextTrimming="CharacterEllipsis"/>
            <Rectangle Width="1" Height="16" Fill="#D6E0EE" Margin="16,0"/>
            <TextBlock x:Name="TxtPhienBan" Text="Phiên bản" FontSize="13.5" Foreground="#1F3354"/>
          </StackPanel>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
            <Button x:Name="BtnHuongDan" Style="{StaticResource Nut}">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE897;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#0E3A86" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Hướng dẫn" VerticalAlignment="Center"/></StackPanel>
            </Button>
            <Button x:Name="BtnMoThuMuc" Style="{StaticResource Nut}">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xED25;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#0E3A86" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Mở thư mục làm việc" VerticalAlignment="Center"/></StackPanel>
            </Button>
            <Button x:Name="BtnSaoLuuChan" Style="{StaticResource Nut}">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE753;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#0E3A86" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Sao lưu dữ liệu" VerticalAlignment="Center"/></StackPanel>
            </Button>
            <Button x:Name="BtnLienHe" Style="{StaticResource Nut}" Margin="0">
              <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE95B;" FontFamily="Segoe MDL2 Assets" FontSize="16" Foreground="#0E3A86" VerticalAlignment="Center" Margin="0,0,8,0"/><TextBlock Text="Liên hệ hỗ trợ" VerticalAlignment="Center"/></StackPanel>
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
    <TextBlock Text="$(XE $c.Tieu)" FontSize="14.5" FontWeight="SemiBold" Foreground="#0B2B6B" Margin="0,8,0,2" TextWrapping="Wrap"/>
    <TextBlock Text="$(XE $c.MoTa)" FontSize="12" Foreground="#5B6B7F" TextWrapping="Wrap"/>
  </StackPanel>
</Border>
"@)
}
$xamlText = $xamlText.Replace('@@LOAIVB@@', $sb.ToString())
# Ô của các trang Hồ sơ chuyên môn, Kiểm tra đánh giá, Chủ nhiệm, Xưởng phần mềm, Kỹ năng trợ lý (cùng một kiểu ô)
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
        [void]$b.Append('<TextBlock Text="' + (XE $ten) + '" Style="{StaticResource TieuDeKhoi}"/><UniformGrid Columns="3">' + (XAML-OVuong $o) + '</UniformGrid>')
    }
    return $b.ToString()
}
$xamlText = $xamlText.Replace('@@NHIEMVU@@', (XAML-NhomO $NhomNhiemVu $NhiemVu))
$xamlText = $xamlText.Replace('@@TIENICH@@', (XAML-NhomO $NhomTienIch $TienIch))
$xamlText = $xamlText.Replace('@@KIEMTRA@@', (XAML-OVuong $KiemTraO)).Replace('@@CHUNHIEM@@', (XAML-OVuong $ChuNhiemO)).Replace('@@XUONG@@', (XAML-OVuong $MAU_PHAN_MEM))

# Ngày tháng trong các câu ví dụ, chữ gợi ý của giao diện: thay bằng thời gian thực khi mở
# phần mềm (từ 1.8.0) - để sang tháng 10, tháng 11 không còn thấy "tháng 9" nằm lại.
$nayGD = Get-Date
$xamlText = $xamlText.Replace('{thang}', [string]$nayGD.Month).Replace('{nam}', [string]$nayGD.Year).Replace('{namthang}', $nayGD.ToString('yyyy-MM')).Replace('{ngay}', ($nayGD.Day.ToString() + '/' + $nayGD.Month.ToString()))


[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'layout.xaml'), $xamlText, (New-Object Text.UTF8Encoding($false)))
