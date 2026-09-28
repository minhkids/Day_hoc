/* =====================================================================
   NGÂN HÀNG Ô CHỮ PHÂN THEO LỚP & ĐỐ VUI
   - Hỗ trợ chọn lớp: Lớp 6, 7, 8, 9, 10, 11, 12 và Đố vui Khám phá.
   - Thầy/cô và học sinh có thể chọn lớp hoặc tự tạo ô chữ trực tiếp trên web.
   ===================================================================== */

window.NGAN_HANG_O_CHU = {
  "do-vui": {
    tieuDe: "Ô Chữ Tri Thức Cuộc Sống",
    monLop: "Đố vui trí tuệ",
    tuKhoa: "TRI THỨC",
    goiYTuKhoa: "Kho tàng hiểu biết của nhân loại giúp con người làm chủ thế giới gọi là gì?",
    hangNgang: [
      { dapAn: "VĂN MINH", oKhoa: 5, goiY: "Trạng thái phát triển cao của văn hóa và xã hội loài người?" },
      { dapAn: "MẶT TRỜI", oKhoa: 5, goiY: "Ngôi sao ở trung tâm Hệ Mặt Trời, nguồn sáng và nhiệt cho Trái Đất?" },
      { dapAn: "HỌC TẬP", oKhoa: 6, goiY: "Quá trình tiếp thu kiến thức, kỹ năng từ thầy cô và cuộc sống?" },
      { dapAn: "SÁCH VỞ", oKhoa: 1, goiY: "Phương tiện lưu trữ và truyền bá tri thức truyền thống của loài người?" },
      { dapAn: "THỰC HÀNH", oKhoa: 2, goiY: "'Học đi đôi với ...' là phương châm giáo dục hiệu quả?" },
      { dapAn: "TƯ DUY", oKhoa: 4, goiY: "Khả năng suy nghĩ, phán đoán và giải quyết vấn đề của bộ não?" },
      { dapAn: "THÀNH CÔNG", oKhoa: 6, goiY: "Kết quả đạt được mục tiêu sau quá trình nỗ lực, học tập chăm chỉ?" }
    ]
  },

  "lop-6": {
    tieuDe: "Ô Chữ KHTN & Toán 6",
    monLop: "Lớp 6",
    tuKhoa: "TRÁI ĐẤT",
    goiYTuKhoa: "Hành tinh thứ ba tính từ Mặt Trời, nơi tồn tại sự sống của chúng ta?",
    hangNgang: [
      { dapAn: "THỰC VẬT", oKhoa: 1, goiY: "Nhóm sinh vật có khả năng tự dưỡng nhờ quá trình quang hợp?" },
      { dapAn: "MẶT TRỜI", oKhoa: 5, goiY: "Thiên thể cung cấp ánh sáng và nhiệt chính cho sự sống trên Trái Đất?" },
      { dapAn: "KHÍ QUYỂN", oKhoa: 5, goiY: "Lớp vỏ khí bao quanh Trái Đất giúp bảo vệ sự sống khỏi bức xạ vũ trụ?" },
      { dapAn: "NĂNG LƯỢNG", oKhoa: 7, goiY: "Khả năng sinh công hoặc truyền nhiệt, ví dụ năng lượng mặt trời, gió?" },
      { dapAn: "ĐƠN BÀO", oKhoa: 1, goiY: "Sinh vật mà cơ thể chỉ gồm đúng một tế bào gọi là sinh vật gì?" },
      { dapAn: "ƯỚC CHUNG", oKhoa: 4, goiY: "Số vừa là ước của số a, vừa là ước của số b gọi là ... của a và b?" },
      { dapAn: "HÌNH VUÔNG", oKhoa: 8, goiY: "Hình tứ giác đều có 4 cạnh bằng nhau và 4 góc vuông?" }
    ]
  },

  "lop-7": {
    tieuDe: "Ô Chữ Khoa Học Lớp 7",
    monLop: "Lớp 7",
    tuKhoa: "TAM GIÁC",
    goiYTuKhoa: "Hình hình học phẳng có ba đỉnh không thẳng hàng và ba cạnh nối các đỉnh đó?",
    hangNgang: [
      { dapAn: "TỐC ĐỘ", oKhoa: 1, goiY: "Đại lượng đặc trưng cho sự nhanh hay chậm của chuyển động (đo bằng m/s, km/h)?" },
      { dapAn: "QUANG HỌC", oKhoa: 3, goiY: "Phần vật lý nghiên cứu về bản chất và các hiện tượng của ánh sáng?" },
      { dapAn: "HỮU TỈ", oKhoa: 5, goiY: "Số viết được dưới dạng phân số a/b (với a, b thuộc Z, b khác 0) gọi là số gì?" },
      { dapAn: "TRỌNG TÂM", oKhoa: 4, goiY: "Giao điểm của ba đường trung tuyến trong tam giác gọi là gì?" },
      { dapAn: "ÁNH SÁNG", oKhoa: 6, goiY: "Bức xạ điện từ có bước sóng mà mắt người có thể nhìn thấy được?" },
      { dapAn: "ĐỐI ĐỈNH", oKhoa: 5, goiY: "Hai góc mà mỗi cạnh của góc này là tia đối của một cạnh góc kia gọi là hai góc gì?" },
      { dapAn: "CÂN BẰNG", oKhoa: 5, goiY: "Trạng thái các lực tác dụng triệt tiêu lẫn nhau, vật giữ nguyên vận tốc?" }
    ]
  },

  "lop-8": {
    tieuDe: "Ô Chữ Toán & Khoa Học 8",
    monLop: "Toán 8",
    tuKhoa: "ĐỒ THỊ",
    goiYTuKhoa: "Hình gồm tất cả các điểm có tọa độ (x; y) thỏa mãn y = ax + b trên mặt phẳng tọa độ gọi là gì của hàm số?",
    hangNgang: [
      { dapAn: "ĐƠN THỨC", oKhoa: 1, goiY: "Biểu thức đại số chỉ gồm một số, một biến hoặc một tích giữa các số và biến?" },
      { dapAn: "ĐỒNG DẠNG", oKhoa: 2, goiY: "Hai đơn thức có hệ số khác 0 và có cùng phần biến gọi là hai đơn thức gì?" },
      { dapAn: "HẰNG ĐẲNG THỨC", oKhoa: 9, goiY: "Đẳng thức mà hai vế luôn nhận cùng giá trị với mọi biến số?" },
      { dapAn: "HÌNH THANG", oKhoa: 1, goiY: "Tứ giác có hai cạnh đối song song gọi là hình gì?" },
      { dapAn: "ĐỊNH LÍ", oKhoa: 2, goiY: "'Bình phương cạnh huyền bằng tổng bình phương hai cạnh góc vuông' là ... Pythagore?" }
    ]
  },

  "lop-9": {
    tieuDe: "Ô Chữ Trọng Tâm Lớp 9",
    monLop: "Lớp 9",
    tuKhoa: "CĂN THỨC",
    goiYTuKhoa: "Biểu thức có chứa dấu căn bậc hai hoặc căn bậc ba của một biểu thức đại số?",
    hangNgang: [
      { dapAn: "DÂY CUNG", oKhoa: 5, goiY: "Đoạn thẳng nối hai điểm bất kì trên đường tròn gọi là gì?" },
      { dapAn: "ĐỒNG BIẾN", oKhoa: 7, goiY: "Hàm số y = f(x) có giá trị tăng khi biến số x tăng gọi là hàm số gì?" },
      { dapAn: "NỘI TIẾP", oKhoa: 5, goiY: "Tứ giác có 4 đỉnh cùng nằm trên một đường tròn gọi là tứ giác gì?" },
      { dapAn: "ĐIỆN TRỞ", oKhoa: 5, goiY: "Đại lượng đặc trưng cho mức độ cản trở dòng điện của vật dẫn (kí hiệu R, đơn vị Ôm)?" },
      { dapAn: "HỆ PHƯƠNG TRÌNH", oKhoa: 6, goiY: "Tập hợp từ hai phương trình trở lên có chung các ẩn số cần tìm nghiệm?" },
      { dapAn: "KIM LOẠI", oKhoa: 1, goiY: "Nhóm nguyên tố có tính dẫn điện, dẫn nhiệt tốt, có ánh kim (như Fe, Cu, Al)?" },
      { dapAn: "MEN ĐEN", oKhoa: 6, goiY: "Nhà khoa học người Áo phát minh ra các định luật di truyền cơ bản?" }
    ]
  },

  "lop-10": {
    tieuDe: "Ô Chữ Khám Phá Lớp 10",
    monLop: "Lớp 10 (THPT)",
    tuKhoa: "VECTƠ",
    goiYTuKhoa: "Một đoạn thẳng có hướng, có điểm đầu và điểm cuối xác định gọi là gì?",
    hangNgang: [
      { dapAn: "MỆNH ĐỀ", oKhoa: 7, goiY: "Một câu khẳng định đúng hoặc sai trong logic học?" },
      { dapAn: "TẬP HỢP", oKhoa: 4, goiY: "Khái niệm cơ bản trong toán học dùng để gom nhóm các phần tử có chung tính chất?" },
      { dapAn: "GIA TỐC", oKhoa: 4, goiY: "Đại lượng vật lý đặc trưng cho sự biến thiên nhanh hay chậm của vận tốc theo thời gian?" },
      { dapAn: "NGUYÊN TỬ", oKhoa: 7, goiY: "Hạt vô cùng nhỏ cấu tạo nên các chất, gồm hạt nhân và lớp vỏ electron?" },
      { dapAn: "BẢNG TUẦN HOÀN", oKhoa: 8, goiY: "Bảng sắp xếp các nguyên tố hóa học theo chiều tăng dần điện tích hạt nhân do Mendeleev sáng lập?" }
    ]
  },

  "lop-11": {
    tieuDe: "Ô Chữ Chinh Phục Lớp 11",
    monLop: "Lớp 11 (THPT)",
    tuKhoa: "ĐẠO HÀM",
    goiYTuKhoa: "Tỉ số giữa số gia của hàm số và số gia của biến số khi số gia của biến số dần tới 0?",
    hangNgang: [
      { dapAn: "ĐIỆN TÍCH", oKhoa: 1, goiY: "Đặc tính của vật chất gây ra tương tác điện từ (đơn vị Coulomb)?" },
      { dapAn: "LƯỢNG GIÁC", oKhoa: 7, goiY: "Nhánh toán học nghiên cứu mối quan hệ giữa các cạnh và góc của tam giác (sin, cos)?" },
      { dapAn: "GIỚI HẠN", oKhoa: 7, goiY: "Khái niệm lim trong giải tích toán học khi biến số tiến tới một giá trị nào đó?" },
      { dapAn: "CẤP SỐ CỘNG", oKhoa: 5, goiY: "Dãy số mà mỗi số hạng kể từ số thứ 2 đều bằng số hạng trước cộng thêm công sai d?" },
      { dapAn: "PHENOL", oKhoa: 5, goiY: "Hợp chất hữu cơ có nhóm −OH liên kết trực tiếp với nguyên tử C của vòng benzen?" },
      { dapAn: "KHÚC XẠ", oKhoa: 6, goiY: "Hiện tượng chùm tia sáng bị đổi phương truyền khi đi qua mặt phân cách giữa hai môi trường?" }
    ]
  },

  "lop-12": {
    tieuDe: "Ô Chữ Về Đích Lớp 12",
    monLop: "Lớp 12 (THPT)",
    tuKhoa: "TÍCH PHÂN",
    goiYTuKhoa: "Phép toán ngược với đạo hàm, dùng để tính diện tích hình phẳng và thể tích khối tròn xoay?",
    hangNgang: [
      { dapAn: "CỰC TRỊ", oKhoa: 4, goiY: "Tên gọi chung cho điểm cực đại và điểm cực tiểu của hàm số?" },
      { dapAn: "NGUYÊN HÀM", oKhoa: 6, goiY: "Hàm số F(x) thỏa mãn F'(x) = f(x) gọi là ... của f(x)?" },
      { dapAn: "TỌA ĐỘ", oKhoa: 4, goiY: "Hệ trục không gian Oxyz gồm 3 trục vuông góc giúp xác định ... của một điểm?" },
      { dapAn: "HẠT NHÂN", oKhoa: 6, goiY: "Phần trung tâm của nguyên tử gồm các proton và neutron gắn kết bền vững?" },
      { dapAn: "SÓNG ÁNH SÁNG", oKhoa: 7, goiY: "Sóng điện từ thể hiện tính chất giao thoa, tán sắc và nhiễu xạ?" },
      { dapAn: "GLUCOSE", oKhoa: 7, goiY: "Loại monosaccharide có nhiều trong quả nho chín, còn gọi là đường nho?" },
      { dapAn: "TIẾN HÓA", oKhoa: 6, goiY: "Quá trình biến đổi của sinh giới qua hàng triệu năm dẫn đến sự đa dạng sinh học?" },
      { dapAn: "QUẦN THỂ", oKhoa: 6, goiY: "Tập hợp các cá thể cùng loài, cùng sinh sống trong một khoảng không gian xác định?" }
    ]
  }
};

/* Mặc định chạy Lớp 8 */
window.DU_LIEU = window.NGAN_HANG_O_CHU["lop-8"];
