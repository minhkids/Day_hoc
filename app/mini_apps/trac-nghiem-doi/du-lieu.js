/* =====================================================================
   NGÂN HÀNG CÂU HỎI TRẮC NGHIỆM PHÂN THEO LỚP & ĐỐ VUI
   - Hỗ trợ chọn lớp: Lớp 6, 7, 8, 9, 10, 11, 12 và Đố vui IQ / Khởi động.
   - Thầy/cô và học sinh có thể chọn lớp hoặc tự nhập câu hỏi trực tiếp trên web.
   - dapAn: đếm từ 0 (A=0, B=1, C=2, D=3).
   ===================================================================== */

window.NGAN_HANG_TRAC_NGHIEM = {
  "do-vui": {
    tieuDe: "Đố Vui Trí Tuệ & Khởi Động Tiết Học",
    monLop: "Đố vui - Mọi lứa tuổi",
    thoiGianMoiCau: 15,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Cái gì đen khi bạn mua nó, đỏ khi bạn dùng nó và xám xịt khi bạn vứt nó đi?",
        phuongAn: ["Hòn than củi", "Chiếc lốp xe", "Cục tẩy bút chì", "Đèn pin"],
        dapAn: 0,
        giaiThich: "Hòn than lúc chưa đốt màu đen, khi cháy đỏ rực, cháy tàn thành tro màu xám."
      },
      {
        hoi: "Tháng nào trong năm có 28 ngày?",
        phuongAn: ["Chỉ tháng 2", "Tháng 2 năm nhuận", "Tất cả các tháng", "Không có tháng nào"],
        dapAn: 2,
        giaiThich: "Tất cả 12 tháng trong năm đều có ít nhất 28 ngày!"
      },
      {
        hoi: "Con đường nào dài nhất thế giới?",
        phuongAn: ["Đường cao tốc xuyên Mỹ", "Đường xích đạo Trái Đất", "Đường đời", "Vạn Lý Trường Thành"],
        dapAn: 2,
        giaiThich: "Câu đố vui: 'Đường đời' là con đường dài nhất mà mỗi người đều đi suốt cuộc đời."
      },
      {
        hoi: "Quốc gia nào có diện tích lãnh thổ lớn nhất thế giới?",
        phuongAn: ["Canada", "Hoa Kỳ", "Trung Quốc", "Nga"],
        dapAn: 3,
        giaiThich: "Nga là quốc gia lớn nhất thế giới với diện tích hơn 17 triệu km²."
      },
      {
        hoi: "Ai là tác giả của tác phẩm 'Truyện Kiều' bất hủ?",
        phuongAn: ["Nguyễn Trãi", "Nguyễn Du", "Hồ Xuân Hương", "Đoàn Thị Điểm"],
        dapAn: 1,
        giaiThich: "Đại thi hào dân tộc Nguyễn Du (1765 - 1820) là tác giả Đoạn trường tân thanh (Truyện Kiều)."
      },
      {
        hoi: "Hành tinh nào gần Mặt Trời nhất trong Hệ Mặt Trời?",
        phuongAn: ["Sao Kim", "Sao Thủy", "Sao Hỏa", "Trái Đất"],
        dapAn: 1,
        giaiThich: "Sao Thủy (Mercury) là hành tinh nằm gần Mặt Trời nhất."
      },
      {
        hoi: "Trong bảng tuần hoàn hóa học, nguyên tố Fe là kim loại nào?",
        phuongAn: ["Đồng", "Nhôm", "Sắt", "Bạc"],
        dapAn: 2,
        giaiThich: "Fe là ký hiệu hóa học của Sắt (Ferrum), số hiệu nguyên tử 26."
      },
      {
        hoi: "Đỉnh núi nào được mệnh danh là 'Nóc nhà Đông Dương'?",
        phuongAn: ["Fansipan", "Bạch Mộc Lương Tử", "Langbiang", "Pù Luông"],
        dapAn: 0,
        giaiThich: "Fansipan (Sa Pa, Lào Cai) cao 3.143m, là đỉnh núi cao nhất 3 nước Đông Dương."
      }
    ]
  },

  "lop-6": {
    tieuDe: "Thử Thách Tri Thức Lớp 6",
    monLop: "Lớp 6 (Toán & KHTN)",
    thoiGianMoiCau: 20,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Tập hợp các ước tự nhiên của số 12 gồm bao nhiêu phần tử?",
        phuongAn: ["4 phần tử", "5 phần tử", "6 phần tử", "8 phần tử"],
        dapAn: 2,
        giaiThich: "Các ước tự nhiên của 12 là {1; 2; 3; 4; 6; 12} => Có 6 phần tử."
      },
      {
        hoi: "Số nguyên tố nhỏ nhất là số nào?",
        phuongAn: ["0", "1", "2", "3"],
        dapAn: 2,
        giaiThich: "Số 2 là số nguyên tố nhỏ nhất và cũng là số nguyên tố chẵn duy nhất."
      },
      {
        hoi: "Kết quả của phép tính: (−15) + 25 bằng bao nhiêu?",
        phuongAn: ["−40", "10", "−10", "40"],
        dapAn: 1,
        giaiThich: "(−15) + 25 = 25 − 15 = 10."
      },
      {
        hoi: "Hình nào sau đây có 4 cạnh bằng nhau và 4 góc vuông?",
        phuongAn: ["Hình bình hành", "Hình thoi", "Hình vuông", "Hình chữ nhật"],
        dapAn: 2,
        giaiThich: "Hình vuông có 4 cạnh bằng nhau và 4 góc vuông bằng nhau (90°)."
      },
      {
        hoi: "Cơ thể sinh vật đơn bào được cấu tạo từ bao nhiêu tế bào?",
        phuongAn: ["1 tế bào", "2 tế bào", "Hàng triệu tế bào", "Không có tế bào"],
        dapAn: 0,
        giaiThich: "Sinh vật đơn bào (như trùng roi, vi khuẩn) chỉ gồm đúng 1 tế bào đảm nhận mọi chức năng sống."
      },
      {
        hoi: "Khí nào chiếm thể tích lớn nhất trong không khí quyển Trái Đất?",
        phuongAn: ["Khí Oxygen (O₂)", "Khí Nitrogen (N₂)", "Khí Carbon dioxide (CO₂)", "Khí Hydrogen (H₂)"],
        dapAn: 1,
        giaiThich: "Khí Nitrogen (nitơ) chiếm khoảng 78% thể tích không khí quyển."
      },
      {
        hoi: "Nhiệt độ sôi của nước tinh khiết ở điều kiện áp suất chuẩn (1 atm) là:",
        phuongAn: ["50°C", "80°C", "100°C", "120°C"],
        dapAn: 2,
        giaiThich: "Nước nguyên chất sôi ở 100°C tại áp suất 1 atm."
      },
      {
        hoi: "Phân số nào sau đây bằng phân số 2/3?",
        phuongAn: ["4/9", "6/9", "4/5", "6/8"],
        dapAn: 1,
        giaiThich: "Nhân cả tử và mẫu với 3: 2/3 = (2·3)/(3·3) = 6/9."
      }
    ]
  },

  "lop-7": {
    tieuDe: "Đấu Trường Học Tập Lớp 7",
    monLop: "Lớp 7 (Toán & KHTN)",
    thoiGianMoiCau: 20,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Tổng ba góc trong một tam giác bằng bao nhiêu độ?",
        phuongAn: ["90°", "180°", "270°", "360°"],
        dapAn: 1,
        giaiThich: "Định lí: Tổng ba góc trong một tam giác bất kì luôn bằng 180°."
      },
      {
        hoi: "Số nào sau đây là số vô tỉ?",
        phuongAn: ["3/4", "0,25", "√2", "−5"],
        dapAn: 2,
        giaiThich: "√2 ≈ 1,4142135... là số thập phân vô hạn không tuần hoàn nên là số vô tỉ."
      },
      {
        hoi: "Kết quả của phép tính 2³ · 2⁴ là:",
        phuongAn: ["2¹²", "2⁷", "4⁷", "4¹²"],
        dapAn: 1,
        giaiThich: "Nhân hai lũy thừa cùng cơ số: aᵐ · aⁿ = aᵐ⁺ⁿ => 2³ · 2⁴ = 2³⁺⁴ = 2⁷."
      },
      {
        hoi: "Tam giác ABC cân tại A có góc A = 80°. Số đo góc B là:",
        phuongAn: ["50°", "80°", "100°", "40°"],
        dapAn: 0,
        giaiThich: "Tam giác cân có hai góc ở đáy bằng nhau: góc B = góc C = (180° − 80°) / 2 = 50°."
      },
      {
        hoi: "Âm thanh truyền nhanh nhất trong môi trường nào sau đây?",
        phuongAn: ["Chất khí", "Chất lỏng", "Chất rắn", "Chân không"],
        dapAn: 2,
        giaiThich: "Vận tốc truyền âm: Chất rắn > Chất lỏng > Chất khí (không truyền được trong chân không)."
      },
      {
        hoi: "Bào quan nào trong tế bào thực vật thực hiện quá trình quang hợp?",
        phuongAn: ["Nhân tế bào", "Lục lạp", "Ti thể", "Không bào"],
        dapAn: 1,
        giaiThich: "Lục lạp chứa chất diệp lục giúp cây hấp thụ ánh sáng để quang hợp tạo chất hữu cơ."
      },
      {
        hoi: "Đơn vị đo tốc độ chuyển động trong hệ SI là:",
        phuongAn: ["m/s", "km/h", "m/min", "cm/s"],
        dapAn: 0,
        giaiThich: "Trong hệ SI, đơn vị hợp pháp của tốc độ là mét trên giây (m/s)."
      }
    ]
  },

  "lop-8": {
    tieuDe: "Đấu Trường Hằng Đẳng Thức & Kiến Thức Lớp 8",
    monLop: "Lớp 8 (Toán & KHTN)",
    thoiGianMoiCau: 20,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "(a + b)² bằng biểu thức nào sau đây?",
        phuongAn: ["a² + b²", "a² + 2ab + b²", "a² − 2ab + b²", "a² + ab + b²"],
        dapAn: 1,
        giaiThich: "Bình phương của một tổng: (a + b)² = a² + 2ab + b²."
      },
      {
        hoi: "Khai triển (x − 3)² ta được kết quả:",
        phuongAn: ["x² − 9", "x² − 3x + 9", "x² − 6x + 9", "x² + 6x + 9"],
        dapAn: 2,
        giaiThich: "(x − 3)² = x² − 2·x·3 + 3² = x² − 6x + 9."
      },
      {
        hoi: "Viết x² − 16 thành nhân tử:",
        phuongAn: ["(x − 4)²", "(x − 4)(x + 4)", "(x − 8)(x + 8)", "(x + 4)²"],
        dapAn: 1,
        giaiThich: "Hiệu hai bình phương: x² − 16 = x² − 4² = (x − 4)(x + 4)."
      },
      {
        hoi: "Tam giác vuông có hai cạnh góc vuông là 3cm và 4cm thì cạnh huyền bằng:",
        phuongAn: ["5 cm", "6 cm", "7 cm", "25 cm"],
        dapAn: 0,
        giaiThich: "Theo định lí Pythagore: c² = 3² + 4² = 25 => c = 5 cm."
      },
      {
        hoi: "Tứ giác có hai cạnh đối song song được gọi là hình gì?",
        phuongAn: ["Hình thang", "Hình bình hành", "Hình chữ nhật", "Hình thoi"],
        dapAn: 0,
        giaiThich: "Định nghĩa: Hình thang là tứ giác có hai cạnh đối song song."
      },
      {
        hoi: "Khối lượng mol của phân tử Nước (H₂O) là bao nhiêu g/mol?",
        phuongAn: ["16 g/mol", "17 g/mol", "18 g/mol", "20 g/mol"],
        dapAn: 2,
        giaiThich: "M(H₂O) = 1·2 + 16 = 18 (g/mol)."
      },
      {
        hoi: "Dung dịch có độ pH = 3 mang môi trường gì?",
        phuongAn: ["Axit (Acid)", "Bazơ (Base)", "Trung tính", "Muối"],
        dapAn: 0,
        giaiThich: "Dung dịch có pH < 7 là môi trường axit, pH = 7 là trung tính, pH > 7 là môi trường bazơ."
      },
      {
        hoi: "Tính nhanh giá trị của 99 · 101:",
        phuongAn: ["10 000", "9 999", "9 900", "10 099"],
        dapAn: 1,
        giaiThich: "99 · 101 = (100 − 1)(100 + 1) = 100² − 1 = 10 000 − 1 = 9 999."
      }
    ]
  },

  "lop-9": {
    tieuDe: "Ôn Luyện Bứt Phá Lớp 9",
    monLop: "Lớp 9 (Toán, Lý, Hóa, Sinh)",
    thoiGianMoiCau: 20,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Điều kiện xác định của biểu thức √(2x − 6) là:",
        phuongAn: ["x > 3", "x ≥ 3", "x ≤ 3", "x < 3"],
        dapAn: 1,
        giaiThich: "Biểu thức dưới dấu căn không âm: 2x − 6 ≥ 0 <=> 2x ≥ 6 <=> x ≥ 3."
      },
      {
        hoi: "Góc nội tiếp chắn nửa đường tròn có số đo bằng bao nhiêu?",
        phuongAn: ["45°", "60°", "90°", "180°"],
        dapAn: 2,
        giaiThich: "Định lí góc nội tiếp: Góc nội tiếp chắn nửa đường tròn là góc vuông (90°)."
      },
      {
        hoi: "Hàm số y = (m − 2)x + 3 đồng biến trên R khi:",
        phuongAn: ["m > 2", "m < 2", "m = 2", "m ≠ 2"],
        dapAn: 0,
        giaiThich: "Hàm số bậc nhất y = ax + b đồng biến khi hệ số a > 0 <=> m − 2 > 0 <=> m > 2."
      },
      {
        hoi: "Hệ thức của Định luật Ôm (Ohm) cho đoạn mạch là:",
        phuongAn: ["I = U · R", "I = U / R", "U = I / R", "R = U · I"],
        dapAn: 1,
        giaiThich: "Cường độ dòng điện chạy qua dây dẫn tỉ lệ thuận với hiệu điện thế và tỉ lệ nghịch với điện trở: I = U/R."
      },
      {
        hoi: "Kim loại nào dẫn điện và dẫn nhiệt tốt nhất hiện nay?",
        phuongAn: ["Vàng (Au)", "Đồng (Cu)", "Bạc (Ag)", "Nhôm (Al)"],
        dapAn: 2,
        giaiThich: "Thứ tự dẫn điện tốt nhất: Bạc (Ag) > Đồng (Cu) > Vàng (Au) > Nhôm (Al) > Sắt (Fe)."
      },
      {
        hoi: "Công thức hóa học của khí Methane (mêtan) là:",
        phuongAn: ["CH₄", "C₂H₄", "C₂H₂", "C₆H₆"],
        dapAn: 0,
        giaiThich: "Mêtan là hiđrocacbon đơn giản nhất, công thức là CH₄."
      },
      {
        hoi: "Quy luật di truyền phân ly độc lập do nhà khoa học nào phát hiện?",
        phuongAn: ["S. Darwin", "G. Mendel", "L. Pasteur", "T. Morgan"],
        dapAn: 1,
        giaiThich: "Gregor Mendel được coi là người đặt nền móng cho Di truyền học cổ điển với các định luật Men-đen."
      }
    ]
  },

  "lop-10": {
    tieuDe: "Đấu Trường Kiến Thức Lớp 10",
    monLop: "Lớp 10 (THPT)",
    thoiGianMoiCau: 25,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Mệnh đề phủ định của '∀x ∈ R, x² ≥ 0' là:",
        phuongAn: ["∃x ∈ R, x² < 0", "∀x ∈ R, x² ≤ 0", "∃x ∈ R, x² ≤ 0", "∀x ∈ R, x² < 0"],
        dapAn: 0,
        giaiThich: "Phủ định của '∀' là '∃', phủ định của '≥' là '<'. Do đó: ∃x ∈ R, x² < 0."
      },
      {
        hoi: "Vectơ đối của vectơ AB là:",
        phuongAn: ["Vectơ BA", "Vectơ AB", "−Vectơ BA", "Vectơ 0"],
        dapAn: 0,
        giaiThich: "Vectơ đối của AB là −AB = BA (cùng độ dài, ngược hướng)."
      },
      {
        hoi: "Tập nghiệm của bất phương trình x² − 4x + 3 < 0 là khoảng nào?",
        phuongAn: ["(1; 3)", "(−∞; 1)", "(3; +∞)", "[1; 3]"],
        dapAn: 0,
        giaiThich: "Tam thức có 2 nghiệm x=1, x=3, hệ số a=1 > 0. 'Trong trái ngoài cùng' nên mang dấu âm trong (1; 3)."
      },
      {
        hoi: "Đơn vị đo lực trong hệ SI là:",
        phuongAn: ["Joule (J)", "Newton (N)", "Watt (W)", "Pascal (Pa)"],
        dapAn: 1,
        giaiThich: "Newton (N) là đơn vị đo lực trong hệ đo lường quốc tế SI (F = m · a)."
      },
      {
        hoi: "Hạt mang điện tích âm cấu tạo nên lớp vỏ nguyên tử là:",
        phuongAn: ["Proton", "Neutron", "Electron", "Positron"],
        dapAn: 2,
        giaiThich: "Vỏ nguyên tử tạo bởi các electron mang điện tích âm (−1), hạt nhân gồm proton (+) và neutron (không mang điện)."
      },
      {
        hoi: "Phân tử đường đơn nào là nguồn năng lượng chủ yếu cho tế bào?",
        phuongAn: ["Glucose", "Fructose", "Sucrose", "Tinh bột"],
        dapAn: 0,
        giaiThich: "Glucose (C₆H₁₂O₆) là loại đường đơn phổ biến nhất cung cấp năng lượng cho tế bào hô hấp."
      }
    ]
  },

  "lop-11": {
    tieuDe: "Chinh Phục Kiến Thức Lớp 11",
    monLop: "Lớp 11 (THPT)",
    thoiGianMoiCau: 25,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Giá trị của cos(0°) bằng bao nhiêu?",
        phuongAn: ["0", "1", "−1", "1/2"],
        dapAn: 1,
        giaiThich: "Tại điểm góc 0 rad (0°), hoành độ cos(0) = 1, tung độ sin(0) = 0."
      },
      {
        hoi: "Cho cấp số cộng (uₙ) có u₁ = 2 và công sai d = 3. Số hạng u₄ bằng:",
        phuongAn: ["9", "11", "14", "17"],
        dapAn: 1,
        giaiThich: "Công thức số hạng tổng quát: u₄ = u₁ + 3d = 2 + 3·3 = 11."
      },
      {
        hoi: "Đạo hàm của hàm số y = x³ là:",
        phuongAn: ["3x", "3x²", "x²/3", "2x³"],
        dapAn: 1,
        giaiThich: "Công thức cơ bản: (xⁿ)' = n · xⁿ⁻¹ => (x³)' = 3x²."
      },
      {
        hoi: "Hai điện tích điểm cùng dấu đặt gần nhau trong chân không sẽ:",
        phuongAn: ["Hút nhau", "Đẩy nhau", "Không tương tác", "Vừa hút vừa đẩy"],
        dapAn: 1,
        giaiThich: "Định luật Coulomb: Các điện tích cùng dấu đẩy nhau, trái dấu hút nhau."
      },
      {
        hoi: "Hợp chất hữu cơ có nhóm chức −OH liên kết trực tiếp với vòng benzen thuộc loại:",
        phuongAn: ["Ancol", "Phenol", "Este", "Axit cacboxylic"],
        dapAn: 1,
        giaiThich: "Phenol là hợp chất có nhóm hidroxyl (−OH) gắn trực tiếp vào nguyên tử C của vòng benzen."
      },
      {
        hoi: "Ở người, tim có mấy ngăn?",
        phuongAn: ["2 ngăn", "3 ngăn", "4 ngăn", "5 ngăn"],
        dapAn: 2,
        giaiThich: "Tim người và các loài chim, thú có 4 ngăn: 2 tâm nhĩ và 2 tâm thất."
      }
    ]
  },

  "lop-12": {
    tieuDe: "Về Đích - Ôn Thi Tốt Nghiệp Lớp 12",
    monLop: "Lớp 12 (Toán & KHTN)",
    thoiGianMoiCau: 25,
    diemMoiCau: 10,
    cauHoi: [
      {
        hoi: "Hàm số y = x³ − 3x có bao nhiêu điểm cực trị?",
        phuongAn: ["0", "1", "2", "3"],
        dapAn: 2,
        giaiThich: "y' = 3x² − 3 = 0 <=> x = ±1. Hàm số có 2 điểm cực trị tại x = 1 và x = −1."
      },
      {
        hoi: "Nguyên hàm của hàm số f(x) = cos(x) là:",
        phuongAn: ["sin(x) + C", "−sin(x) + C", "tan(x) + C", "−cos(x) + C"],
        dapAn: 0,
        giaiThich: "Đạo hàm của sin(x) là cos(x), do đó nguyên hàm của cos(x) là sin(x) + C."
      },
      {
        hoi: "Trong không gian Oxyz, mặt phẳng (Oxy) có phương trình là:",
        phuongAn: ["x = 0", "y = 0", "z = 0", "x + y = 0"],
        dapAn: 2,
        giaiThich: "Mọi điểm nằm trên mặt phẳng tọa độ Oxy đều có cao độ z = 0."
      },
      {
        hoi: "Sóng điện từ có bước sóng dài nhất trong thang sóng là:",
        phuongAn: ["Tia X (Röntgen)", "Tia tử ngoại (UV)", "Sóng vô tuyến", "Tia Gamma (γ)"],
        dapAn: 2,
        giaiThich: "Sóng vô tuyến có bước sóng dài nhất (từ vài mm đến hàng ngàn km), tần số và năng lượng nhỏ nhất."
      },
      {
        hoi: "Chất béo (Triglyceride) là trieste của axit béo với hợp chất nào sau đây?",
        phuongAn: ["Etylen glicol", "Glixerol (Glycerin)", "Ancol etylic", "Metanol"],
        dapAn: 1,
        giaiThich: "Chất béo là trieste của axit béo với glixerol C₃H₅(OH)₃."
      },
      {
        hoi: "Đơn vị cơ sở của quá trình tiến hóa nhỏ trong sinh học là:",
        phuongAn: ["Cá thể", "Quần xã", "Quần thể", "Hệ sinh thái"],
        dapAn: 2,
        giaiThich: "Quần thể là đơn vị tiến hóa nhỏ nhất, có cấu trúc di truyền và vốn gen biến đổi qua các thế hệ."
      }
    ]
  }
};

/* Mặc định cho phiên chơi đầu tiên: Lớp 8 */
window.DU_LIEU = Object.assign({
  doi: ["Đội 1", "Đội 2", "Đội 3", "Đội 4"]
}, window.NGAN_HANG_TRAC_NGHIEM["lop-8"]);
