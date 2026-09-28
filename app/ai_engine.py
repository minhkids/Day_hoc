import os
import re

class AIEngine:
    def __init__(self, profile):
        self.profile = profile
        self.api_key = profile.get("api_key", "").strip()

    def generate_content(self, system_instruction, user_prompt):
        """
        Gọi API AI (Google Gemini hoặc các nhà cung cấp) nếu có API key,
        nếu không thì sử dụng bộ sinh mẫu offline thông minh.
        """
        if self.api_key:
            try:
                # Sử dụng Google Gemini qua google.genai
                from google import genai
                client = genai.Client(api_key=self.api_key)
                response = client.models.generate_content(
                    model="gemini-2.5-flash",
                    contents=f"{system_instruction}\n\n{user_prompt}"
                )
                if response and response.text:
                    return response.text
            except Exception as e:
                print(f"Lỗi khi gọi AI API, chuyển về bộ sinh mẫu offline: {e}")

        # Chế độ Offline / Fallback thông minh
        return self._generate_offline_template(user_prompt)

    def _generate_offline_template(self, prompt):
        """Sinh nội dung mẫu chất lượng cao khi chạy offline hoặc chưa có API key"""
        if "KẾ HOẠCH BÀI DẠY" in prompt or "CÔNG VĂN 5512" in prompt:
            return f"""[BẢN MẪU BIÊN SOẠN CHUẨN CÔNG VĂN 5512/BGDĐT]

I. YÊU CẦU CẦN ĐẠT:
1. Năng lực đặc thù:
- Nắm vững các khái niệm, định nghĩa và tính chất trọng tâm của bài học.
- Vận dụng linh hoạt các bước giải toán/bài tập vào các tình huống thực tiễn.
- Rèn luyện kỹ năng tư duy logic, phân tích và biểu diễn hình học/số liệu.

2. Năng lực chung:
- Tự chủ và tự học: Tự giác tìm hiểu nội dung trong sách giáo khoa và chuẩn bị bài.
- Giao tiếp và hợp tác: Tích cực thảo luận, chia sẻ ý kiến với các thành viên trong nhóm.
- Giải quyết vấn đề và sáng tạo: Chủ động đề xuất các cách giải hay, sáng tạo.

3. Phẩm chất:
- Chăm chỉ: Hoàn thành đầy đủ các nhiệm vụ học tập được giao trên lớp và ở nhà.
- Trung thực: Khách quan trong thảo luận và tự đánh giá bài làm của bạn.
- Trách nhiệm: Có tinh thần trách nhiệm trong công việc nhóm.

II. THIẾT BỊ DẠY HỌC VÀ HỌC LIỆU:
- Giáo viên: Kế hoạch bài dạy, bài trình chiếu PowerPoint, phiếu học tập, đồ dùng trực quan.
- Học sinh: SGK, vở ghi bài, thước kẻ, compa, bút màu.

III. TIẾN TRÌNH DẠY HỌC (4 HOẠT ĐỘNG CHUẨN):
● Hoạt động 1: Mở đầu / Khởi động (5 phút)
  a) Mục tiêu: Kích thích sự tò mò, kết nối kiến thức đã học với vấn đề bài mới.
  b) Nội dung: Trò chơi ghép thẻ kiến thức / Giải câu đố tình huống thực tế.
  c) Sản phẩm: Câu trả lời của học sinh; hình thành vấn đề cần giải quyết.
  d) Tổ chức thực hiện: GV nêu luật chơi -> HS tham gia sôi nổi -> GV tổng kết dẫn vào bài.

● Hoạt động 2: Hình thành kiến thức mới (18 phút)
  a) Mục tiêu: Xây dựng quy tắc, định nghĩa cốt lõi của bài học.
  b) Nội dung: Học sinh làm việc theo nhóm 4, đọc SGK và hoàn thành Phiếu học tập số 1.
  c) Sản phẩm: Bảng kết quả thảo luận của các nhóm được treo lên bảng lớp.
  d) Tổ chức thực hiện: GV chia nhóm giao việc -> Các nhóm thảo luận -> Đại diện báo cáo -> GV chốt kiến thức.

● Hoạt động 3: Luyện tập (15 phút)
  a) Mục tiêu: Khắc sâu và rèn luyện kỹ năng thực hành vận dụng công thức.
  b) Nội dung: Làm bài tập 1, bài tập 2 trong SGK theo từng mức độ.
  c) Sản phẩm: Lời giải chính xác trong vở ghi của học sinh.
  d) Tổ chức thực hiện: HS làm bài cá nhân -> GV quan sát hỗ trợ -> Gọi HS lên bảng chữa -> Nhận xét biểu dương.

● Hoạt động 4: Vận dụng (7 phút)
  a) Mục tiêu: Mở rộng kiến thức, liên hệ ứng dụng vào đời sống hàng ngày.
  b) Nội dung: Nêu bài toán thực tiễn gắn liền với môi trường xung quanh.
  c) Sản phẩm: Bản ghi nhận đề xuất phương án giải quyết của học sinh.
  d) Tổ chức thực hiện: GV giao nhiệm vụ về nhà -> Hướng dẫn nguồn tham khảo."""

        elif "MA TRẬN" in prompt or "KIỂM TRA" in prompt:
            return """[BẢN MA TRẬN VÀ ĐẶC TẢ ĐỀ KIỂM TRA ĐỊNH KỲ]

1. KHUNG MA TRẬN ĐỀ KIỂM TRA (TỶ LỆ 70% TRẮC NGHIỆM - 30% TỰ LUẬN):
- Mức độ Nhận biết (40%): 8 câu trắc nghiệm (mỗi câu 0.25đ = 2.0đ) + 1 ý tự luận (2.0đ).
- Mức độ Thông hiểu (30%): 6 câu trắc nghiệm (mỗi câu 0.25đ = 1.5đ) + 1 ý tự luận (1.5đ).
- Mức độ Vận dụng (20%): 2 câu trắc nghiệm (0.5đ) + 1 bài toán thực tế (1.5đ).
- Mức độ Vận dụng cao (10%): 1 câu tự luận phân loại học sinh giỏi (1.0đ).

2. ĐỀ THI MINH HỌA:
I. PHẦN TRẮC NGHIỆM (7.0 ĐIỂM)
Câu 1 (Nhận biết): Khẳng định nào sau đây là đúng về tính chất cơ bản?
A. a + b = b - a       B. a . (b + c) = a.b + a.c
C. a - b = b - a       D. a / b = b / a
Đáp án: B

Câu 2 (Thông hiểu): Cho biểu thức P = 2x + 5. Khi x = 3 thì giá trị của P là:
A. 10      B. 11      C. 15      D. 8
Đáp án: B (Vì 2.3 + 5 = 11)

II. PHẦN TỰ LUẬN (3.0 ĐIỂM)
Bài 1 (1.5 điểm): Thực hiện phép tính hợp lý...
Bài 2 (1.0 điểm): Một mảnh vườn hình chữ nhật có chu vi... Tính diện tích.
Bài 3 (0.5 điểm - Vận dụng cao): Tìm giá trị nhỏ nhất của biểu thức A..."""

        else:
            return f"""[VĂN BẢN QUẢN LÝ GIÁO DỤC CHUẨN NGHỊ ĐỊNH 30/2020/NĐ-CP]

Căn cứ Điều lệ trường học hiện hành;
Căn cứ Nghị định số 30/2020/NĐ-CP ngày 05/3/2020 của Chính phủ về công tác văn thư;
Xét đề nghị của Tổ trưởng chuyên môn và các bộ phận liên quan,

QUYẾT ĐỊNH:
Điều 1. Ban hành kế hoạch triển khai nhiệm vụ trọng tâm năm học 2026 - 2027.
Điều 2. Các tổ chuyên môn, ban ngành đoàn thể và giáo viên chịu trách nhiệm thi hành nghiêm túc.
Điều 3. Quyết định có hiệu lực thi hành kể từ ngày ký./."""
