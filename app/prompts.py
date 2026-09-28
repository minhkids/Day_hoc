"""
HỆ THỐNG PROMPT VÀ CẤU TRÚC NGHIỆP VỤ CHUẨN GIÁO DỤC VIỆT NAM (2026-2027)
Tổng hợp đầy đủ nghiệp vụ cho cả 3 vai trò:
1. Giáo viên (Tiểu học, THCS, THPT)
2. Hiệu trưởng / Quản trị trường học
3. Chuyên viên / Quản lý nhà nước về Giáo dục
"""

# ============================================================================
# 1. NGHIỆP VỤ GIÁO VIÊN
# ============================================================================

def get_lesson_plan_prompt(subject, grade, topic, duration, profile):
    """Tạo prompt chuẩn hóa cho Kế hoạch bài dạy theo Công văn 5512/BGDĐT"""
    return f"""Bạn là Trợ lý AI Chuyên gia Giáo dục Việt Nam. Hãy biên soạn KẾ HOẠCH BÀI DẠY chuẩn theo Công văn 5512/BGDĐT với thông tin sau:
- Đơn vị: {profile.get('school_name', '')}
- Giáo viên: {profile.get('full_name', '')}
- Môn học: {subject}
- Cấp lớp: {grade}
- Tên bài dạy: {topic}
- Thời lượng: {duration}

YÊU CẦU BẮT BUỘC THEO CÔNG VĂN 5512:
I. MỤC TIÊU:
1. Năng lực đặc thù của môn học
2. Năng lực chung (Tự chủ - tự học, Giao tiếp - hợp tác, Giải quyết vấn đề - sáng tạo)
3. Phẩm chất (Yêu nước, Nhân ái, Chăm chỉ, Trung thực, Trách nhiệm)

II. THIẾT BỊ DẠY HỌC VÀ HỌC LIỆU:
1. Giáo viên (SGK, bài giảng điện tử, phiếu học tập, học liệu số)
2. Học sinh (SGK, vở ghi, dụng cụ học tập)

III. TIẾN TRÌNH DẠY HỌC (GỒM ĐỦ 4 HOẠT ĐỘNG CHUẨN):
1. Hoạt động 1: Xác định vấn đề / Mở đầu / Khởi động
2. Hoạt động 2: Hình thành kiến thức mới
3. Hoạt động 3: Luyện tập
4. Hoạt động 4: Vận dụng
Mỗi hoạt động phải trình bày rõ: a) Mục tiêu, b) Nội dung, c) Sản phẩm, d) Tổ chức thực hiện (Giao nhiệm vụ -> Thực hiện -> Báo cáo thảo luận -> Kết luận đánh giá).
"""

def get_exam_matrix_prompt(subject, grade, exam_type, profile):
    """Tạo prompt thiết lập ma trận và đề kiểm tra định kỳ 4 mức độ"""
    return f"""Bạn là Chuyên gia Khảo thí và Kiểm định Giáo dục. Hãy thiết lập MA TRẬN, BẢN ĐẶC TẢ VÀ ĐỀ KIỂM TRA ĐỊNH KỲ cho:
- Môn: {subject}
- Khối lớp: {grade}
- Đợt kiểm tra: {exam_type} (Giữa kỳ hoặc Cuối kỳ)
- Đơn vị: {profile.get('school_name', '')}

YÊU CẦU THIẾT KẾ ĐỀ:
1. Bảng ma trận theo 4 mức độ nhận thức:
   - Nhận biết: ~40%
   - Thông hiểu: ~30%
   - Vận dụng: ~20%
   - Vận dụng cao: ~10%
2. Đề thi gồm:
   - Phần 1: Trắc nghiệm khách quan (kèm 4 phương án A, B, C, D)
   - Phần 2: Tự luận giải quyết vấn đề
3. Bản đặc tả câu hỏi và Hướng dẫn chấm (biểu điểm chi tiết từng câu).
"""

def get_homeroom_plan_prompt(grade_class, semester, profile):
    """Tạo prompt Kế hoạch công tác chủ nhiệm lớp"""
    return f"""Bạn là Trợ lý Giáo viên Chủ nhiệm chuyên nghiệp. Hãy soạn thảo KẾ HOẠCH CÔNG TÁC CHỦ NHIỆM:
- Trường: {profile.get('school_name', '')}
- Giáo viên chủ nhiệm: {profile.get('full_name', '')}
- Lớp: {grade_class}
- Học kỳ / Năm học: {semester} (Năm học 2026-2027)

YÊU CẦU NỘI DUNG:
1. Đặc điểm tình hình lớp (Thuận lợi, Khó khăn, Cơ cấu tổ chức cán bộ lớp, Ban đại diện cha mẹ).
2. Mục tiêu, chỉ tiêu phấn đấu (Học tập, Rèn luyện, Nề nếp kỷ cương, Hoạt động phong trào).
3. Các biện pháp thực hiện (Xây dựng nề nếp, Phối hợp cha mẹ học sinh, Hỗ trợ học sinh cần quan tâm).
4. Lịch trình công tác theo từng tuần / tháng trong học kỳ.
"""

def get_initiative_prompt(title, subject, profile):
    """Tạo prompt Đề cương Sáng kiến kinh nghiệm sư phạm"""
    return f"""Bạn là Chuyên gia Nghiên cứu Khoa học Sư phạm ứng dụng. Hãy xây dựng BẢN ĐỀ CƯƠNG SÁNG KIẾN KINH NGHIỆM:
- Tên sáng kiến: {title}
- Môn / Lĩnh vực: {subject}
- Tác giả: {profile.get('full_name', '')}
- Đơn vị: {profile.get('school_name', '')}

CẤU TRÚC CHUẨN:
1. Đặt vấn đề (Tính cấp thiết, Thực trạng, Đối tượng nghiên cứu).
2. Nội dung các biện pháp đổi mới sáng tạo (Mô tả chi tiết 3-4 giải pháp cụ thể).
3. Hiệu quả áp dụng (Đối chứng trước và sau khi áp dụng, số liệu định lượng).
4. Kết luận và kiến nghị bài học kinh nghiệm.
"""

# ============================================================================
# 2. NGHIỆP VỤ QUẢN TRỊ TRƯỜNG HỌC (HIỆU TRƯỞNG / BAN GIÁM HIỆU)
# ============================================================================

def get_school_year_plan_prompt(academic_year, profile):
    """Tạo prompt Kế hoạch giáo dục nhà trường cả năm học"""
    return f"""Bạn là Chuyên gia Quản trị Giáo dục. Hãy soạn thảo KẾ HOẠCH GIÁO DỤC NHÀ TRƯỜNG:
- Trường: {profile.get('school_name', '')}
- Cấp học: {profile.get('level', 'THCS')}
- Năm học: {academic_year} (Theo Luật Nhà giáo 73/2025/QH15 và Thông tư 15/2026/TT-BGDĐT)
- Hiệu trưởng: {profile.get('full_name', '')}

NỘI DUNG YÊU CẦU:
I. Căn cứ xây dựng kế hoạch (Nghị quyết, Thông tư, Hướng dẫn nhiệm vụ năm học của Sở GD&ĐT).
II. Đặc điểm tình hình (Quy mô trường lớp, Đội ngũ giáo viên, Cơ sở vật chất).
III. Mục tiêu giáo dục và các chỉ tiêu năm học.
IV. Kế hoạch thời gian thực hiện chương trình và phân phối chương trình các môn.
V. Tổ chức thực hiện và phân công nhiệm vụ Ban giám hiệu, Tổ chuyên môn.
"""

def get_internal_inspection_prompt(inspection_topic, profile):
    """Tạo prompt Kế hoạch và Quyết định kiểm tra nội bộ trường học"""
    return f"""Bạn là Chuyên gia Thanh tra - Kiểm tra Giáo dục. Hãy soạn thảo BỘ HỒ SƠ KIỂM TRA NỘI BỘ TRƯỜNG HỌC:
- Đơn vị: {profile.get('school_name', '')}
- Nội dung kiểm tra: {inspection_topic}
- Hiệu trưởng: {profile.get('full_name', '')}
- Cơ quan quản lý: UBND {profile.get('district', 'Xã/Phường')}

YÊU CẦU GỒM 3 VĂN BẢN CHUẨN:
1. Quyết định thành lập Đoàn kiểm tra nội bộ (Căn cứ pháp lý, Thành phần đoàn, Quyền hạn).
2. Kế hoạch kiểm tra chi tiết (Mục đích, Nội dung kiểm tra hồ sơ và dự giờ, Thời gian, Phương pháp).
3. Mẫu Biên bản kiểm tra và Kết luận kiểm tra nội bộ.
"""

def get_party_doc_prompt(doc_type, title, profile):
    """Tạo prompt Văn bản Đảng / Chi bộ trường học (Hướng dẫn 05-HD/VPTW)"""
    return f"""Bạn là Thư ký Cấp ủy Chi bộ trường học. Hãy soạn thảo văn bản Chi bộ {doc_type}:
- Đảng bộ cấp trên: ĐẢNG BỘ XÃ / PHƯỜNG {profile.get('district', '').upper()}
- Đơn vị: CHI BỘ {profile.get('school_name', '').upper()}
- Tiêu đề / Trích yếu: {title}
- Bí thư Chi bộ: {profile.get('full_name', '')}

YÊU CẦU THỂ THỨC VĂN BẢN ĐẢNG:
1. Đặt đúng tiêu đề ĐẢNG CỘNG SẢN VIỆT NAM, số và ký hiệu theo quy định Đảng (/NQ-CB, /BC-CB, /KH-CB).
2. Đánh giá kết quả lãnh đạo chính trị, công tác tư tưởng và chuyên môn dạy học.
3. Phần kết luận, biểu quyết thông qua và khối ký Bí thư chi bộ.
"""

# ============================================================================
# 3. NGHIỆP VỤ CHUYÊN VIÊN (QUẢN LÝ NHÀ NƯỚC VỀ GIÁO DỤC)
# ============================================================================

def get_consultation_prompt(topic, profile):
    """Tạo prompt Báo cáo Tham mưu & Tờ trình quản lý nhà nước"""
    return f"""Bạn là Chuyên viên Quản lý Nhà nước về Giáo dục (Sở GD&ĐT / Phòng Văn hóa - Xã hội / UBND xã).
Hãy soạn thảo TỜ TRÌNH / BÁO CÁO THAM MƯU:
- Đơn vị tham mưu: {profile.get('role', 'Phòng Văn hóa - Xã hội')}
- Cơ quan quyết định: UBND {profile.get('district', 'Xã/Phường/Tỉnh')}
- Nội dung tham mưu: {topic}
- Cán bộ thực hiện: {profile.get('full_name', '')}

NỘI DUNG:
1. Sự cần thiết và căn cứ pháp lý thẩm định.
2. Thực trạng tình hình và phương án đề xuất giải quyết.
3. Đề xuất cụ thể điều khoản thực hiện, nguồn kinh phí (nếu có).
4. Dự thảo Quyết định kèm theo để Lãnh đạo ký ban hành.
"""

def get_accreditation_prompt(school_target, profile):
    """Tạo prompt Thẩm định công nhận trường đạt chuẩn quốc gia (Thông tư 57/2026)"""
    return f"""Bạn là Trưởng đoàn Thẩm định Kiểm định chất lượng giáo dục và Trường chuẩn quốc gia.
Hãy soạn BIÊN BẢN VÀ THÔNG BÁO KẾT QUẢ THẨM ĐỊNH theo Thông tư 57/2026/TT-BGDĐT:
- Cơ quan thẩm định: {profile.get('role', 'Sở GD&ĐT / Hội đồng Thẩm định cấp Tỉnh')}
- Trường được thẩm định: {school_target}
- Cán bộ thẩm định: {profile.get('full_name', '')}

ĐÁNH GIÁ 5 TIÊU CHUẨN CHUẨN QUỐC GIA:
1. Tiêu chuẩn 1: Tổ chức và quản lý nhà trường.
2. Tiêu chuẩn 2: Cán bộ quản lý, giáo viên, nhân viên và học sinh.
3. Tiêu chuẩn 3: Cơ sở vật chất và thiết bị dạy học.
4. Tiêu chuẩn 4: Quan hệ giữa nhà trường, gia đình và xã hội.
5. Tiêu chuẩn 5: Hoạt động giáo dục và kết quả giáo dục.
Kết luận kiến nghị mức độ đạt chuẩn (Mức 1, Mức 2).
"""

# ============================================================================
# 4. VĂN BẢN HÀNH CHÍNH NGHỊ ĐỊNH 30/2020/NĐ-CP (DÙNG CHUNG)
# ============================================================================

def get_admin_doc_prompt(doc_type, title, profile):
    """Tạo prompt soạn thảo văn bản chuẩn Nghị định 30/2020/NĐ-CP"""
    return f"""Bạn là Chuyên gia Văn thư - Quản lý Nhà nước về Giáo dục. Hãy soạn thảo văn bản {doc_type} theo đúng 100% thể thức Nghị định số 30/2020/NĐ-CP:
- Cơ quan chủ quản: UBND {profile.get('district', 'XÃ/PHƯỜNG').upper()}
- Đơn vị ban hành: {profile.get('school_name', '').upper()}
- Thẩm quyền ký: {profile.get('role', 'HIỆU TRƯỞNG').upper()}
- Người ký: {profile.get('full_name', '')}
- Địa danh: {profile.get('province', 'TP')}
- Trích yếu văn bản: {title}

YÊU CẦU:
1. Đầy đủ Quốc hiệu, Tiêu ngữ, Số và ký hiệu văn bản.
2. Căn cứ pháp lý đầy đủ (Luật Giáo dục, Điều lệ trường học, Nghị định 30/2020/NĐ-CP...).
3. Các Điều khoản rõ ràng, mạch lạc, đúng thẩm quyền và trách nhiệm.
4. Phần nơi nhận đầy đủ theo quy định.
"""
