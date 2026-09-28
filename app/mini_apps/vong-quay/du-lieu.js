/* =====================================================================
   NGÂN HÀNG VÒNG QUAY PHÂN THEO LỚP & ĐỐ VUI
   - Hỗ trợ chọn lớp: Lớp 6, 7, 8, 9, 10, 11, 12, Đố vui Khởi động, Gọi nhóm.
   - Thầy/cô và học sinh có thể chọn lớp hoặc tự dán danh sách riêng.
   ===================================================================== */

window.NGAN_HANG_VONG_QUAY = {
  "do-vui": {
    tieuDe: "Vòng Quay Thử Thách & Đố Vui",
    monLop: "Đố vui - Khởi động",
    loaiSauKhiQuay: true,
    danhSach: [
      "🌟 Ngôi sao may mắn (+10đ)",
      "❓ Tháng nào có 28 ngày?",
      "🎤 Hát một câu hát vui",
      "❓ Cái gì đen khi mua, đỏ khi dùng?",
      "🎁 Phần quà bất ngờ!",
      "❓ Nóc nhà Đông Dương ở đâu?",
      "👏 Cả lớp dành 1 tràng pháo tay",
      "❓ Ký hiệu hóa học của Sắt?"
    ]
  },

  "lop-6": {
    tieuDe: "Vòng Quay Khởi Động Lớp 6",
    monLop: "Lớp 6 (Toán & KHTN)",
    loaiSauKhiQuay: true,
    danhSach: [
      "Số nguyên tố nhỏ nhất là gì?",
      "Tính: (−15) + 25 = ?",
      "Khí nào chiếm 78% không khí?",
      "Nêu định nghĩa hình vuông",
      "Nhiệt độ sôi của nước nguyên chất?",
      "Rút gọn phân số 12/18",
      "Sinh vật đơn bào là gì?",
      "🌟 Điểm thưởng may mắn"
    ]
  },

  "lop-7": {
    tieuDe: "Vòng Quay Kiến Thức Lớp 7",
    monLop: "Lớp 7",
    loaiSauKhiQuay: true,
    danhSach: [
      "Tổng 3 góc trong tam giác = ?",
      "Tính: 2³ · 2⁴ = ?",
      "Bào quan nào quang hợp ở cây?",
      "Âm thanh truyền nhanh nhất ở đâu?",
      "Định nghĩa số hữu tỉ",
      "Công thức tính vận tốc v = ?",
      "Tam giác cân có tính chất gì?",
      "🌟 Ngôi sao may mắn"
    ]
  },

  "lop-8": {
    tieuDe: "Vòng Quay Hằng Đẳng Thức Lớp 8",
    monLop: "Toán 8",
    loaiSauKhiQuay: true,
    danhSach: [
      "(A + B)² = ?",
      "(A − B)² = ?",
      "A² − B² = ?",
      "(A + B)³ = ?",
      "(A − B)³ = ?",
      "A³ + B³ = ?",
      "A³ − B³ = ?",
      "Định lí Pythagore",
      "🌟 Ngôi sao may mắn"
    ]
  },

  "lop-9": {
    tieuDe: "Vòng Quay Ôn Luyện Lớp 9",
    monLop: "Lớp 9",
    loaiSauKhiQuay: true,
    danhSach: [
      "Điều kiện xác định của √A?",
      "Góc nội tiếp chắn nửa đường tròn?",
      "Hệ thức Định luật Ohm I = ?",
      "Kim loại dẫn điện tốt nhất?",
      "Công thức phân tử khí Mêtan?",
      "Ai phát hiện quy luật di truyền?",
      "Hàm y = ax + b đồng biến khi nào?",
      "🌟 Nhân đôi số điểm"
    ]
  },

  "lop-10": {
    tieuDe: "Vòng Quay Trọng Tâm Lớp 10",
    monLop: "Lớp 10 (THPT)",
    loaiSauKhiQuay: true,
    danhSach: [
      "Phủ định của mệnh đề chứa ∀?",
      "Định nghĩa vectơ đối?",
      "Công thức Định luật II Newton?",
      "Hạt mang điện âm ở vỏ nguyên tử?",
      "Phân tử đường cung cấp năng lượng?",
      "Đơn vị đo lực trong hệ SI?",
      "🌟 Điểm thưởng nhóm"
    ]
  },

  "lop-11": {
    tieuDe: "Vòng Quay Chinh Phục Lớp 11",
    monLop: "Lớp 11 (THPT)",
    loaiSauKhiQuay: true,
    danhSach: [
      "Giá trị của cos(0) và sin(0)?",
      "Công thức số hạng uₙ cấp số cộng?",
      "Đạo hàm của x³ bằng gì?",
      "Hai điện tích cùng dấu tương tác thế nào?",
      "Phenol có nhóm chức nào?",
      "Cấu tạo tim người mấy ngăn?",
      "🌟 Ngôi sao may mắn"
    ]
  },

  "lop-12": {
    tieuDe: "Vòng Quay Về Đích Lớp 12",
    monLop: "Lớp 12 (THPT)",
    loaiSauKhiQuay: true,
    danhSach: [
      "Số cực trị tối đa hàm bậc 3?",
      "Nguyên hàm của cos(x)?",
      "Phương trình mặt phẳng (Oxy)?",
      "Sóng điện từ bước sóng dài nhất?",
      "Chất béo là trieste của chất nào?",
      "Đơn vị tiến hóa nhỏ trong sinh học?",
      "🌟 Chúc mừng +20 điểm"
    ]
  },

  "goi-nhom": {
    tieuDe: "Vòng Quay Gọi Nhóm & Tổ Học Tập",
    monLop: "Điều hành lớp học",
    loaiSauKhiQuay: false,
    danhSach: [
      "Nhóm 1", "Nhóm 2", "Nhóm 3", "Nhóm 4",
      "Nhóm 5", "Nhóm 6", "Tổ 1", "Tổ 2", "Tổ 3", "Tổ 4"
    ]
  }
};

/* Mặc định chạy Lớp 8 */
window.DU_LIEU = window.NGAN_HANG_VONG_QUAY["lop-8"];
