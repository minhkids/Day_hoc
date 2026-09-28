/* =====================================================================
   NGÂN HÀNG THẺ GHI NHỚ PHÂN THEO LỚP & ĐỐ VUI
   - Hỗ trợ chọn lớp: Lớp 6, 7, 8, 9, 10, 11, 12 và Đố vui Khởi động.
   - Thầy/cô và học sinh có thể chọn lớp hoặc tự dán danh sách thẻ riêng.
   ===================================================================== */

window.NGAN_HANG_FLASHCARD = {
  "do-vui": {
    tieuDe: "Thẻ Đố Vui Trí Tuệ & Phản Xạ Nhanh",
    monLop: "Đố vui khởi động",
    the: [
      { nhan: "Câu đố 1", truoc: "Tháng nào trong năm có 28 ngày?", sau: "Tất cả 12 tháng đều có ít nhất 28 ngày!" },
      { nhan: "Câu đố 2", truoc: "Cái gì đen khi mua, đỏ khi dùng, xám xịt khi vứt đi?", sau: "Hòn than củi" },
      { nhan: "Địa danh", truoc: "Đỉnh núi nào được mệnh danh là 'Nóc nhà Đông Dương'?", sau: "Fansipan (3.143m, Sa Pa - Lào Cai)" },
      { nhan: "Địa lý", truoc: "Quốc gia nào có diện tích lãnh thổ lớn nhất hành tinh?", sau: "Nước Nga (hơn 17 triệu km²)" },
      { nhan: "Văn học", truoc: "Ai là tác giả của kiệt tác 'Truyện Kiều'?", sau: "Đại thi hào Nguyễn Du" },
      { nhan: "Hóa học", truoc: "Ký hiệu hóa học của kim loại Sắt là gì?", sau: "Fe (Ferrum, nguyên tử khối 56)" },
      { nhan: "Vũ trụ", truoc: "Hành tinh nào trong Hệ Mặt Trời có biệt danh 'Hành tinh Đỏ'?", sau: "Sao Hỏa (Mars)" }
    ]
  },

  "lop-6": {
    tieuDe: "Ghi Nhớ Trọng Tâm Lớp 6",
    monLop: "Lớp 6 (Toán & KHTN)",
    the: [
      { nhan: "Số học", truoc: "Số nguyên tố nhỏ nhất và chẵn duy nhất là số nào?", sau: "Số 2" },
      { nhan: "Hình học", truoc: "Hình có 4 cạnh bằng nhau và 4 góc vuông là hình gì?", sau: "Hình vuông" },
      { nhan: "Toán 6", truoc: "Kết quả của phép tính:\n(−15) + 25 = ?", sau: "10" },
      { nhan: "Sinh học", truoc: "Sinh vật mà cơ thể chỉ gồm đúng một tế bào gọi là gì?", sau: "Sinh vật đơn bào (ví dụ: vi khuẩn, trùng roi)" },
      { nhan: "Khí quyển", truoc: "Khí nào chiếm thể tích lớn nhất trong không khí quyển (~78%)?", sau: "Khí Nitrogen (N₂)" },
      { nhan: "Vật lý", truoc: "Nhiệt độ sôi của nước nguyên chất ở áp suất chuẩn là bao nhiêu?", sau: "100°C" },
      { nhan: "Toán 6", truoc: "Phân số tối giản của 12/18 là phân số nào?", sau: "2/3 (chia cả tử và mẫu cho 6)" }
    ]
  },

  "lop-7": {
    tieuDe: "Công Thức & Định Lí Lớp 7",
    monLop: "Lớp 7",
    the: [
      { nhan: "Hình học", truoc: "Tổng ba góc trong một tam giác bằng bao nhiêu độ?", sau: "180°" },
      { nhan: "Hình học", truoc: "Tam giác cân tại A có góc A = 80°. Góc B bằng bao nhiêu độ?", sau: "50° (vì (180° − 80°) : 2 = 50°)" },
      { nhan: "Số học", truoc: "Số viết được dưới dạng phân số a/b (a, b ∈ Z, b ≠ 0) gọi là số gì?", sau: "Số hữu tỉ (tập hợp Q)" },
      { nhan: "Lũy thừa", truoc: "Công thức nhân hai lũy thừa cùng cơ số:\naᵐ · aⁿ = ?", sau: "aᵐ⁺ⁿ" },
      { nhan: "Vật lý", truoc: "Âm thanh truyền nhanh nhất trong môi trường nào?", sau: "Chất rắn (Rắn > Lỏng > Khí)" },
      { nhan: "Sinh học", truoc: "Bào quan nào thực hiện chức năng quang hợp ở thực vật?", sau: "Lục lạp (chứa chất diệp lục)" },
      { nhan: "Tốc độ", truoc: "Công thức tính tốc độ chuyển động đều:\nv = ?", sau: "v = s / t (quãng đường chia thời gian)" }
    ]
  },

  "lop-8": {
    tieuDe: "Hằng Đẳng Thức & Khái Niệm Lớp 8",
    monLop: "Toán & KHTN 8",
    the: [
      { nhan: "Hằng đẳng thức 1", truoc: "Bình phương của một tổng\n(A + B)² = ?", sau: "(A + B)² = A² + 2AB + B²" },
      { nhan: "Hằng đẳng thức 2", truoc: "Bình phương của một hiệu\n(A − B)² = ?", sau: "(A − B)² = A² − 2AB + B²" },
      { nhan: "Hằng đẳng thức 3", truoc: "Hiệu hai bình phương\nA² − B² = ?", sau: "A² − B² = (A − B)(A + B)" },
      { nhan: "Hằng đẳng thức 4", truoc: "Lập phương của một tổng\n(A + B)³ = ?", sau: "(A + B)³ = A³ + 3A²B + 3AB² + B³" },
      { nhan: "Hằng đẳng thức 5", truoc: "Lập phương của một hiệu\n(A − B)³ = ?", sau: "(A − B)³ = A³ − 3A²B + 3AB² − B³" },
      { nhan: "Hằng đẳng thức 6", truoc: "Tổng hai lập phương\nA³ + B³ = ?", sau: "A³ + B³ = (A + B)(A² − AB + B²)" },
      { nhan: "Hằng đẳng thức 7", truoc: "Hiệu hai lập phương\nA³ − B³ = ?", sau: "A³ − B³ = (A − B)(A² + AB + B²)" },
      { nhan: "Hình học", truoc: "Định lí Pythagore trong tam giác vuông:\nCạnh huyền c, hai cạnh góc vuông a, b?", sau: "c² = a² + b²" },
      { nhan: "Hóa học", truoc: "Dung dịch có pH < 7 là môi trường gì?", sau: "Môi trường Axit (Acid)" }
    ]
  },

  "lop-9": {
    tieuDe: "Ôn Tập Trọng Tâm Lớp 9",
    monLop: "Lớp 9",
    the: [
      { nhan: "Đại số", truoc: "Biểu thức √A có nghĩa (xác định) khi nào?", sau: "Khi A ≥ 0" },
      { nhan: "Hình học", truoc: "Góc nội tiếp chắn nửa đường tròn có số đo bằng bao nhiêu?", sau: "90° (góc vuông)" },
      { nhan: "Hàm số", truoc: "Hàm số bậc nhất y = ax + b đồng biến khi nào?", sau: "Khi hệ số a > 0" },
      { nhan: "Vật lý", truoc: "Hệ thức Định luật Ôm (Ohm) cho đoạn mạch:\nI = ?", sau: "I = U / R" },
      { nhan: "Hóa học", truoc: "Kim loại nào dẫn điện và dẫn nhiệt tốt nhất?", sau: "Bạc (Ag)" },
      { nhan: "Hóa hữu cơ", truoc: "Công thức phân tử của khí Mêtan (Methane)?", sau: "CH₄" },
      { nhan: "Sinh học", truoc: "Ai là người phát hiện các quy luật di truyền cơ bản?", sau: "Gregor Mendel" }
    ]
  },

  "lop-10": {
    tieuDe: "Công Thức Trọng Tâm Lớp 10",
    monLop: "Lớp 10 (THPT)",
    the: [
      { nhan: "Logic học", truoc: "Mệnh đề phủ định của '∀x ∈ R, P(x)' là gì?", sau: "∃x ∈ R, ¬P(x)" },
      { nhan: "Hình học", truoc: "Vectơ đối của vectơ AB là vectơ nào?", sau: "Vectơ BA (hoặc −AB)" },
      { nhan: "Vật lý", truoc: "Đơn vị đo lực trong hệ chuẩn SI là gì?", sau: "Newton (N)" },
      { nhan: "Vật lý", truoc: "Công thức Định luật II Newton:\nF = ?", sau: "F = m · a" },
      { nhan: "Hóa học", truoc: "Hạt mang điện tích âm ở vỏ nguyên tử là hạt nào?", sau: "Electron (e⁻)" },
      { nhan: "Sinh học", truoc: "Phân tử đường đơn phổ biến nhất cung cấp năng lượng cho tế bào?", sau: "Glucose (C₆H₁₂O₆)" }
    ]
  },

  "lop-11": {
    tieuDe: "Giải Tích & Lượng Giác Lớp 11",
    monLop: "Lớp 11 (THPT)",
    the: [
      { nhan: "Lượng giác", truoc: "Giá trị của cos(0) và sin(0) bằng bao nhiêu?", sau: "cos(0) = 1, sin(0) = 0" },
      { nhan: "Cấp số cộng", truoc: "Công thức số hạng tổng quát của cấp số cộng (uₙ):\nuₙ = ?", sau: "uₙ = u₁ + (n − 1)d" },
      { nhan: "Đạo hàm", truoc: "Đạo hàm của hàm số lũy thừa:\n(xⁿ)' = ?", sau: "n · xⁿ⁻¹" },
      { nhan: "Vật lý", truoc: "Hai điện tích cùng dấu đặt gần nhau sẽ có tương tác gì?", sau: "Đẩy nhau (trái dấu hút nhau)" },
      { nhan: "Hóa học", truoc: "Hợp chất có nhóm −OH gắn trực tiếp vào vòng benzen thuộc loại gì?", sau: "Phenol" },
      { nhan: "Sinh học", truoc: "Tim người bình thường có cấu tạo mấy ngăn?", sau: "4 ngăn (2 tâm nhĩ, 2 tâm thất)" }
    ]
  },

  "lop-12": {
    tieuDe: "Ôn Thi Tốt Nghiệp Lớp 12",
    monLop: "Lớp 12 (THPT)",
    the: [
      { nhan: "Khảo sát hàm số", truoc: "Số điểm cực trị của hàm bậc ba y = ax³ + bx² + cx + d tối đa là bao nhiêu?", sau: "2 điểm cực trị (hoặc không có cực trị)" },
      { nhan: "Giải tích", truoc: "Nguyên hàm của hàm số cos(x):\n∫ cos(x) dx = ?", sau: "sin(x) + C" },
      { nhan: "Hình học Oxyz", truoc: "Phương trình mặt phẳng tọa độ (Oxy) trong không gian Oxyz?", sau: "z = 0" },
      { nhan: "Vật lý hạt nhân", truoc: "Sóng điện từ có bước sóng dài nhất trong thang sóng là sóng gì?", sau: "Sóng vô tuyến (Radio wave)" },
      { nhan: "Hóa học", truoc: "Chất béo là trieste của axit béo với hợp chất nào?", sau: "Glixerol (Glycerin) C₃H₅(OH)₃" },
      { nhan: "Sinh thái", truoc: "Đơn vị cơ sở của quá trình tiến hóa nhỏ trong sinh học là gì?", sau: "Quần thể" }
    ]
  }
};

/* Mặc định chạy Lớp 8 */
window.DU_LIEU = window.NGAN_HANG_FLASHCARD["lop-8"];
