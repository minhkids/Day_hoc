"""Preschool workflows and editable offline templates; no primary-school exams."""
PAGES = [
    ('home', 'Trang chủ', 'Một ngày ở lớp'),
    ('activities', 'Soạn hoạt động', 'Cùng trẻ khám phá mỗi ngày'),
    ('plans', 'Kế hoạch giáo dục', 'Từ kế hoạch năm đến từng hoạt động'),
    ('children', 'Hồ sơ trẻ em', 'Thông tin cơ bản, thể trạng, bố mẹ & nơi ở sáp nhập phường'),
    ('observations', 'Theo dõi trẻ', 'Ghi nhận sự tiến bộ của từng trẻ'),
    ('care', 'Chăm sóc và quản lý lớp', 'Quan tâm từ những việc nhỏ'),
    ('parents', 'Phối hợp phụ huynh', 'Kết nối gia đình và nhà trường'),
    ('professional', 'Hồ sơ chuyên môn', 'Chuẩn bị hồ sơ rõ ràng, có hệ thống'),
    ('legal', 'Thông tư & Văn bản mới', 'Cập nhật kịp thời Nghị định, Thông tư GD mầm non'),
    ('materials', 'Học liệu và trò chơi', 'Học qua chơi, khám phá bằng trải nghiệm'),
    ('library', 'Kho tài liệu', 'Những tài liệu cô đã chuẩn bị'),
    ('calendar', 'Lịch công việc', 'Chủ động việc hôm nay và những ngày tới'),
    ('chat', 'Trò chuyện AI', 'Trao đổi, đính kèm và soạn nội dung'),
    ('settings', 'Cài đặt', 'Thông tin lớp và kết nối AI'),
]

AGES = ['Nhà trẻ 3–12 tháng', 'Nhà trẻ 12–24 tháng', 'Nhà trẻ 24–36 tháng', 'Mẫu giáo 3–4 tuổi', 'Mẫu giáo 4–5 tuổi', 'Mẫu giáo 5–6 tuổi']
FIELDS = ['Phát triển thể chất', 'Phát triển nhận thức', 'Phát triển ngôn ngữ', 'Tình cảm và kỹ năng xã hội', 'Phát triển thẩm mỹ', 'Tích hợp theo độ tuổi']

try:
    from assistant import THEMES, ADV_METHODS, PARENT_SCENARIOS, CREATIVE_GENRES, SITUATIONS
except ImportError:
    try:
        from preschool.assistant import THEMES, ADV_METHODS, PARENT_SCENARIOS, CREATIVE_GENRES, SITUATIONS
    except ImportError:
        THEMES = ['Trường mầm non', 'Bản thân', 'Gia đình', 'Nghề nghiệp', 'Thế giới thực vật', 'Thế giới động vật', 'Giao thông', 'Nước và các hiện tượng tự nhiên', 'Quê hương - Bác Hồ']
        ADV_METHODS = ['STEAM (Mô hình 5E)', 'STEAM (Quy trình EDP)', 'Montessori', 'Reggio Emilia', 'Học qua chơi & Lấy trẻ làm trung tâm', 'Trò chơi vận động & Âm nhạc']
        PARENT_SCENARIOS = ['Bé va chạm / trầy xước nhẹ', 'Bé bị bạn cắn hoặc cắn bạn', 'Bé sốt nhẹ / mệt / biếng ăn', 'Khen ngợi bé tiến bộ', 'Nhắc đón muộn / đồ dùng', 'Kêu gọi nguyên vật liệu', 'Thông báo hoạt động dã ngoại']
        CREATIVE_GENRES = ['Truyện ngắn có tên bé trong lớp', 'Bài thơ 4 chữ / 5 chữ', 'Đồng dao / Vè', 'Bộ 3 câu đố vui']
        SITUATIONS = ['Trẻ khóc sáng sớm', 'Trẻ cắn/đánh bạn', 'Trẻ biếng ăn/ngậm cơm', 'Phụ huynh phàn nàn', 'Sơ cứu hóc dị vật', 'Sơ cứu sốt co giật']

# Each template is a real editable document, usable without an AI connection.
SPECS = [
 ('child_profile','children','Hồ sơ thông tin trẻ em','Lý lịch trích ngang, thể trạng, gia đình và địa chỉ trước/sau sáp nhập.', ['Thông tin cơ bản của trẻ (Họ tên, ngày sinh, giới tính, lớp)','Chỉ số thể trạng (Cân nặng, chiều cao, đánh giá dinh dưỡng)','Thông tin bố mẹ và điện thoại liên hệ khẩn cấp','Nơi ở trước sáp nhập và sau sáp nhập phường','Đặc điểm thói quen và lưu ý sức khỏe']),
 ('activity','activities','Kế hoạch tổ chức hoạt động','Mục tiêu, chuẩn bị, tổ chức và điều chỉnh.', ['Mục tiêu phù hợp độ tuổi','Không gian, đồ dùng và học liệu','Gây hứng thú','Tổ chức cho trẻ trải nghiệm','Quan sát và hỗ trợ cá nhân','Kết thúc, chuyển hoạt động','Điều chỉnh sau hoạt động']),
 ('corners','activities','Hoạt động góc','Góc chơi, vật liệu và cách quan sát trẻ.', ['Các góc chơi và mục tiêu','Đồ dùng, bố trí góc','Thỏa thuận chơi cùng trẻ','Vai trò hỗ trợ của giáo viên','Quan sát trẻ chơi','Thu dọn và chia sẻ sau chơi']),
 ('outdoor','activities','Hoạt động ngoài trời','Quan sát thiên nhiên và trò chơi vận động.', ['Mục tiêu','Địa điểm, thời tiết và chuẩn bị','Quan sát, khám phá','Trò chơi vận động','Chơi tự do có giám sát','Điểm danh và chuyển hoạt động']),
 ('experience','activities','Khám phá và trải nghiệm','Thử nghiệm đơn giản theo khả năng của trẻ.', ['Câu hỏi gợi mở','Vật liệu và điều kiện thực hiện','Trẻ dự đoán và thử nghiệm','Câu hỏi trong quá trình khám phá','Trẻ chia sẻ điều quan sát được','Điều chỉnh theo nhóm tuổi']),
 ('slides','activities','Dàn ý trình chiếu','Hình ảnh, câu hỏi và lời dẫn cho từng trang.', ['Trang mở đầu: chủ đề','Hình ảnh gợi mở','Trẻ quan sát và trò chuyện','Hoạt động tương tác','Củng cố bằng hình ảnh','Lời dẫn và nguồn học liệu cần bổ sung']),
 ('year','plans','Kế hoạch giáo dục năm','Mục tiêu và nội dung theo nhóm tuổi.', ['Đặc điểm nhóm lớp','Mục tiêu giáo dục theo độ tuổi','Nội dung dự kiến trong năm','Tổ chức môi trường giáo dục','Phối hợp gia đình','Theo dõi, đánh giá và điều chỉnh']),
 ('month','plans','Kế hoạch tháng / chủ đề','Chủ đề, mục tiêu và hoạt động dự kiến.', ['Chủ đề và thời gian','Mục tiêu','Mạng nội dung và hoạt động','Môi trường, học liệu','Phối hợp phụ huynh','Đánh giá và điều chỉnh']),
 ('week','plans','Kế hoạch tuần','Đón trẻ, chơi, hoạt động, ăn, ngủ và trả trẻ.', ['Mục tiêu tuần','Đón trẻ và thể dục sáng','Hoạt động giáo dục từng ngày','Hoạt động góc, ngoài trời','Ăn, ngủ, vệ sinh','Hoạt động chiều và trả trẻ','Điều chỉnh cuối tuần']),
 ('day','plans','Kế hoạch ngày','Sắp xếp hoạt động theo chế độ sinh hoạt.', ['Đón trẻ','Hoạt động buổi sáng','Chơi và trải nghiệm','Ăn, ngủ, vệ sinh','Hoạt động buổi chiều','Trả trẻ','Ghi nhận cuối ngày']),
 ('development','observations','Tổng hợp sự phát triển','Tổng hợp từ ghi nhận đã có của giáo viên.', ['Thời gian và nguồn quan sát','Điểm tiến bộ của trẻ','Điều trẻ đang thực hiện được','Nội dung cần hỗ trợ thêm','Hoạt động hỗ trợ tiếp theo','Trao đổi với gia đình']),
 ('support','observations','Kế hoạch hỗ trợ cá nhân','Hỗ trợ trẻ từ các tình huống quan sát thực tế.', ['Mã trẻ và nhóm tuổi','Quan sát cụ thể','Mục tiêu hỗ trợ','Hoạt động và cách hỗ trợ','Phối hợp gia đình','Thời điểm xem lại và kết quả']),
 ('routine','care','Rèn nền nếp và tự phục vụ','Thói quen phù hợp độ tuổi và khả năng.', ['Thói quen cần rèn','Biểu hiện hiện tại','Các bước hướng dẫn','Học liệu, môi trường hỗ trợ','Phối hợp gia đình','Ghi nhận tiến bộ']),
 ('handover','care','Đón và trả trẻ','Chuẩn bị, điểm danh và trao đổi cuối ngày.', ['Chuẩn bị đón trẻ','Ghi nhận tình trạng khi đến lớp','Điểm danh và thay đổi trong ngày','Thông tin cần trao đổi','Xác nhận người đón theo quy trình của trường']),
 ('safety','care','Rà soát môi trường lớp','Danh sách kiểm tra trước khi tổ chức hoạt động.', ['Không gian lớp và sân chơi','Đồ dùng, đồ chơi','Khu vực ăn, ngủ, vệ sinh','Việc cần xử lý và người phụ trách','Thời điểm kiểm tra lại']),
 ('meeting','parents','Họp phụ huynh','Nội dung họp và kế hoạch phối hợp.', ['Mục đích và thời gian','Tình hình chung của lớp','Kế hoạch chăm sóc, giáo dục','Nội dung phối hợp','Ý kiến phụ huynh','Thống nhất và việc tiếp theo']),
 ('message','parents','Thông báo và tin nhắn','Lời nhắn ngắn gọn, rõ ràng cho gia đình.', ['Người nhận','Nội dung cần thông báo','Thời gian, địa điểm nếu có','Việc cần phụ huynh phối hợp','Lời cảm ơn']),
 ('parent_minutes','parents','Biên bản họp phụ huynh','Ghi lại nội dung và ý kiến thực tế.', ['Thời gian, địa điểm','Thành phần tham dự','Nội dung trao đổi','Ý kiến thực tế','Nội dung thống nhất','Người ghi và xác nhận']),
 ('home_activity','parents','Hoạt động cùng gia đình','Gợi ý chơi và trò chuyện tại nhà.', ['Mục tiêu nhỏ trong tuần','Đồ dùng quen thuộc','Cách chơi cùng trẻ','Câu hỏi gợi mở','Phản hồi của gia đình']),
 ('professional_meeting','professional','Sinh hoạt chuyên môn','Dự giờ, trao đổi và điều chỉnh hoạt động.', ['Chủ đề sinh hoạt','Hoạt động minh họa','Quan sát thực tế','Ý kiến trao đổi','Điều chỉnh thống nhất','Phân công và thời hạn']),
 ('minutes','professional','Biên bản họp tổ','Từ ghi chép thành biên bản có cấu trúc.', ['Thời gian, địa điểm','Thành phần','Nội dung họp','Ý kiến trao đổi','Kết luận, phân công','Người ghi biên bản']),
 ('report','professional','Báo cáo cá nhân','Sơ kết, tổng kết theo dữ liệu giáo viên cung cấp.', ['Kỳ báo cáo','Công việc đã thực hiện','Kết quả và minh chứng thực tế','Khó khăn','Kế hoạch tiếp theo','Đề xuất']),
 ('training','professional','Kế hoạch bồi dưỡng','Nội dung học tập và minh chứng thực hiện.', ['Nhu cầu bồi dưỡng','Mục tiêu','Nội dung và hình thức','Thời gian','Sản phẩm, minh chứng','Tự nhìn nhận sau bồi dưỡng']),
 ('standards','professional','Tự đánh giá nghề nghiệp','Theo mẫu và căn cứ mầm non do trường cung cấp.', ['Mẫu, căn cứ đang sử dụng','Tiêu chí cần đánh giá','Minh chứng thực tế','Mức tự đánh giá và lý do','Kế hoạch cải thiện']),
 ('initiative','professional','Sáng kiến / giải pháp','Trình bày giải pháp với minh chứng có thật.', ['Vấn đề thực tế','Mục tiêu giải pháp','Cách thực hiện','Minh chứng trước và sau','Nhận xét kết quả','Điều kiện áp dụng']),
 ('incoming','professional','Tóm tắt văn bản nhà trường','Đính kèm văn bản trong Trò chuyện AI để trích việc.', ['Tên và nguồn văn bản','Nội dung chính','Việc giáo viên cần thực hiện','Thời hạn được nêu trong văn bản','Thông tin cần làm rõ']),
 ('legal_plan','legal','Kế hoạch triển khai quy định mới','Rà soát và áp dụng thông tư, nghị định mới vào nhóm lớp.', ['Tên thông tư / nghị định và căn cứ ban hành','Nội dung mới cần điều chỉnh tại nhóm lớp','Kế hoạch thực hiện cụ thể','Khó khăn và đề xuất nhà trường']),
 ('adv_method_activity','activities','Kế hoạch hoạt động GD tiên tiến (STEAM / Montessori / Reggio Emilia / Học qua chơi)','Soạn giáo án ứng dụng STEAM 5E, EDP, Montessori, Reggio Emilia hoặc lấy trẻ làm trung tâm.', ['Tên hoạt động, độ tuổi và phương pháp tiên tiến áp dụng','Mục tiêu giáo dục tích hợp (Kiến thức, kỹ năng, thái độ theo phương pháp)','Chuẩn bị không gian, học liệu tự nhiên và đồ dùng trực quan','Tiến trình tổ chức hoạt động chi tiết theo các bước của phương pháp','Quan sát, hỗ trợ trẻ và khơi gợi tư duy chủ động','Đánh giá kết quả hoạt động và điều chỉnh']),
 ('school_standards_eval','legal','Bảng tự đánh giá trường mầm non đạt chuẩn quốc gia (TT 19/2018/TT-BGDĐT)','Đánh giá 5 tiêu chuẩn theo từng mức độ (Mức 1, Mức 2, Mức 3) và mã hóa minh chứng.', ['Thông tin trường và mục tiêu kiểm định / công nhận đạt chuẩn (Mức 1, 2 hoặc 3)','Tiêu chuẩn 1: Tổ chức và quản lý nhà trường (10 tiêu chí)','Tiêu chuẩn 2: Cán bộ quản lý, giáo viên, nhân viên (4 tiêu chí)','Tiêu chuẩn 3: Cơ sở vật chất và thiết bị dạy học (6 tiêu chí - theo TT 13/2020)','Tiêu chuẩn 4: Quan hệ giữa nhà trường, gia đình và xã hội (2 tiêu chí)','Tiêu chuẩn 5: Hoạt động và kết quả nuôi dưỡng, chăm sóc, giáo dục trẻ (5 tiêu chí)','Bảng tổng hợp kết quả tự đánh giá các tiêu chí theo từng Mức độ','Kế hoạch cải tiến chất lượng và danh mục mã minh chứng [H1-1.01-01]']),
 ('party_review','professional','Bản kiểm điểm đảng viên cuối năm (Giáo viên mầm non - Mẫu 02-HD/BTCTW)','Kiểm điểm đánh giá xếp loại đảng viên theo Quy định 124-QĐ/TW gắn với nghề nuôi dạy trẻ.', ['Thông tin đảng viên, chi bộ và nhiệm vụ chuyên môn nuôi dạy trẻ','Ưu điểm, kết quả công tác (Chính trị tư tưởng, đạo đức lối sống, thực hiện nhiệm vụ, kỷ luật)','Hạn chế, khuyết điểm và nguyên nhân thực tế','Kết quả khắc phục các hạn chế, khuyết điểm kỳ trước','Phương hướng, biện pháp khắc phục trong năm tới','Tự nhận mức xếp loại chất lượng đảng viên']),
 ('party_commitment','professional','Bản cam kết tu dưỡng rèn luyện phấn đấu năm của Đảng viên','Cam kết chính trị, đạo đức nhà giáo mầm non, chống suy thoái và nêu gương.', ['Thông tin đảng viên và chi bộ trường mầm non','Cam kết về tư tưởng chính trị và phẩm chất đạo đức lối sống nhà giáo','Cam kết thực hiện chức trách nhiệm vụ nuôi dạy và an toàn cho trẻ','Cam kết ý thức tổ chức kỷ luật và trách nhiệm nêu gương','Kế hoạch hành động và biện pháp thực hiện']),
 ('party_branch_minutes','professional','Biên bản & Nghị quyết sinh hoạt Chi bộ trường mầm non','Biên bản sinh hoạt định kỳ / chuyên đề chi bộ trường mầm non theo hướng dẫn.', ['Thời gian, địa điểm, thành phần và chủ trì sinh hoạt chi bộ','Đánh giá công tác lãnh đạo nuôi dạy trẻ và tư tưởng chính trị tháng qua','Triển khai nhiệm vụ trọng tâm tháng tới (chuyên môn, an toàn, phát triển đảng)','Ý kiến thảo luận và đóng góp của đảng viên','Kết luận của Bí thư Chi bộ và biểu quyết thông qua Nghị quyết Chi bộ']),
 ('story','materials','Truyện và lời kể','Câu chuyện ngắn với câu hỏi gợi mở.', ['Chủ đề, nhóm tuổi','Nhân vật','Nội dung câu chuyện tự sáng tác','Câu hỏi trò chuyện','Gợi ý kể bằng tranh hoặc rối']),
 ('poem','materials','Thơ, vè và nhịp điệu','Nội dung tự sáng tác dễ nghe, dễ nhớ.', ['Chủ đề','Bài thơ hoặc vè tự sáng tác','Cử chỉ, nhịp điệu gợi ý','Cách tổ chức cùng trẻ']),
 ('movement','materials','Trò chơi vận động','Luật chơi đơn giản và cách tổ chức.', ['Tên trò chơi','Mục tiêu, nhóm tuổi','Không gian và đồ dùng','Cách chơi','Vai trò giáo viên','Biến thể theo khả năng']),
 ('picture','materials','Phiếu hoạt động bằng hình ảnh','Nối, tô, phân loại và nhận biết.', ['Mục tiêu, nhóm tuổi','Mô tả hình ảnh cần chuẩn bị','Hướng dẫn hoạt động bằng lời','Cách quan sát trẻ thực hiện','Điều chỉnh độ khó']),
]

CUSTOM_BODIES = {
 'adv_method_activity': '''# KẾ HOẠCH TỔ CHỨC HOẠT ĐỘNG GIÁO DỤC THEO PHƯƠNG PHÁP TIÊN TIẾN
(Căn cứ: Văn bản hợp nhất 01/VBHN-BGDĐT & Thông tư 51/2020/TT-BGDĐT)

Trường: [TÊN TRƯỜNG MẦM NON]
Lớp: [TÊN LỚP] - Nhóm tuổi: [MẪU GIÁO / NHÀ TRẺ]
Chủ đề / Dự án: [TÊN CHỦ ĐỀ HOẶC DỰ ÁN]
Tên hoạt động: [TÊN HOẠT ĐỘNG TRẢI NGHIỆM]
Phương pháp giáo dục tiên tiến áp dụng: [LỰA CHỌN: STEAM 5E / STEAM EDP / MONTESSORI / REGGIO EMILIA / HỌC QUA CHƠI]
Thời gian thực hiện: [THỜI GIAN]

---

## 1. Mục tiêu hoạt động (Tích hợp theo phương pháp tiên tiến)
- Kiến thức (Khoa học / Khám phá): Trẻ nhận biết, khám phá đặc điểm, quy luật, cấu tạo hoặc thuộc tính của đối tượng...
- Kỹ năng (Công nghệ / Kỹ thuật / Toán / Kỹ năng thực hành): Trẻ tự tin thao tác, phối hợp tay - mắt, đo lường, phân loại, giải quyết vấn đề đơn giản.
- Thái độ (Nghệ thuật / Cảm xúc): Trẻ hào hứng, tò mò, kiên trì, biết chia sẻ đồ chơi và tôn trọng sản phẩm của bạn.

## 2. Chuẩn bị môi trường & học liệu
- Môi trường: Không gian thoáng đãng, sắp xếp bàn ghế nhóm hoặc thảm hoạt động linh hoạt; chuẩn bị góc trải nghiệm mở.
- Đồ dùng của cô: Mẫu vật thật, hình ảnh minh họa, video ngắn hoặc tình huống thực tế.
- Học liệu của trẻ: Đồ dùng tự nhiên (lá cây, sỏi, hạt...), vật liệu tái chế an toàn (bìa carton, cốc giấy...), khay hoạt động riêng cho từng nhóm/trẻ.

## 3. Tiến trình tổ chức hoạt động chi tiết
*(Theo tiến trình 5E: Gắn kết - Khám phá - Giải thích - Áp dụng - Đánh giá; hoặc tiến trình chuyên sâu tương ứng)*
### Bước 1: Gắn kết (Engage) / Khơi gợi hứng thú
- Cô tạo tình huống bất ngờ (hộp quà bí mật, câu đố, mẩu chuyện ngắn) để kích thích trí tò mò của trẻ.
- Đặt câu hỏi mở: "Các con thấy điều gì đang diễn ra?", "Nếu chúng mình làm thế này thì điều gì sẽ xảy ra?".

### Bước 2: Khám phá (Explore) / Trải nghiệm trực tiếp
- Trẻ trực tiếp chạm, ngửi, quan sát, thử nghiệm và thao tác với học liệu.
- Giáo viên đóng vai trò là người đồng hành, gợi mở và hỗ trợ khi trẻ gặp khó khăn, tuyệt đối không làm thay trẻ.

### Bước 3: Giải thích & Chia sẻ (Explain)
- Trẻ trình bày, diễn đạt những gì mình vừa phát hiện được bằng ngôn ngữ của trẻ.
- Cô chuẩn hóa kiến thức ngắn gọn, trực quan, phù hợp với tâm lý lứa tuổi mầm non.

### Bước 4: Áp dụng & Sáng tạo (Elaborate)
- Trẻ vận dụng điều vừa học để tạo ra sản phẩm mới, thử nghiệm ở mức độ khó hơn hoặc giải quyết nhiệm vụ sáng tạo.
- Khuyến khích trẻ thể hiện ý tưởng qua hội họa, tạo hình, tạo mẫu.

### Bước 5: Đánh giá (Evaluate)
- Trẻ tự giới thiệu và nhận xét sản phẩm của mình, của bạn.
- Cô nhận xét, động viên sự nỗ lực và tiến bộ của từng cá nhân trẻ.

## 4. Quan sát và hỗ trợ cá nhân
- Lưu ý những trẻ còn nhút nhát hoặc kỹ năng vận động tinh chưa thành thạo để khích lệ kịp thời.

## 5. Kết thúc & Điều chỉnh sau hoạt động
- Hướng dẫn trẻ tự giác thu dọn đồ dùng, học liệu gọn gàng.
- Ghi nhận mức độ hứng thú và điều chỉnh cho hoạt động tiếp theo.
''',

 'school_standards_eval': '''# BẢNG TỰ ĐÁNH GIÁ TRƯỜNG MẦM NON ĐẠT CHUẨN QUỐC GIA
(Căn cứ: Thông tư số 19/2018/TT-BGDĐT & Thông tư số 13/2020/TT-BGDĐT của Bộ GD&ĐT)

Tên cơ sở giáo dục: Trường Mầm non [TÊN TRƯỜNG]
Địa chỉ: [ĐỊA CHỈ TRƯỜNG MẦM NON]
Năm học tự đánh giá: [NĂM HỌC 2026–2027]
Mục tiêu đánh giá: [CHỌN: ĐẠT KIỂM ĐỊNH CLGD CẤP ĐỘ 2 & CHUẨN QUỐC GIA MỨC ĐỘ 1 / CẤP ĐỘ 3 & CHUẨN QG MỨC ĐỘ 2]

---

## 1. Thông tin chung về nhà trường
- Tổng số nhóm trẻ, lớp mẫu giáo: [...] nhóm/lớp. Tổng số trẻ: [...] trẻ.
- Đội ngũ cán bộ quản lý, giáo viên, nhân viên: [...] người. Tỷ lệ giáo viên/lớp đạt quy định theo Thông tư 19/2023/TT-BGDĐT.
- Trình độ đào tạo giáo viên: 100% đạt chuẩn từ Cao đẳng sư phạm mầm non trở lên.

## 2. Bảng tổng hợp kết quả tự đánh giá 5 Tiêu chuẩn & 25 Tiêu chí

| Tiêu chuẩn / Tiêu chí | Mức 1 (Tối thiểu) | Mức 2 (Chuẩn QG Mức 1) | Mức 3 (Chuẩn QG Mức 2) | Mã minh chứng |
| :--- | :---: | :---: | :---: | :--- |
| **Tiêu chuẩn 1: Tổ chức và quản lý nhà trường** | | | | |
| 1.1 Phương hướng, chiến lược xây dựng và phát triển | Đạt | Đạt | Đạt | [H1-1.01-01] |
| 1.2 Hội đồng trường và các hội đồng khác | Đạt | Đạt | Đạt | [H1-1.02-01] |
| 1.3 Tổ chức Đảng Cộng sản Việt Nam, đoàn thể | Đạt | Đạt | Đạt | [H1-1.03-01] |
| 1.4 Hiệu trưởng, phó hiệu trưởng, tổ chuyên môn | Đạt | Đạt | Đạt | [H1-1.04-01] |
| 1.5 Khối nhóm trẻ, lớp mẫu giáo | Đạt | Đạt | Đạt | [H1-1.05-01] |
| 1.6 Quản lý hành chính, tài chính và tài sản | Đạt | Đạt | Đạt | [H1-1.06-01] |
| 1.7 Quản lý cán bộ, giáo viên và nhân viên | Đạt | Đạt | Đạt | [H1-1.07-01] |
| 1.8 Quản lý hoạt động nuôi dưỡng, chăm sóc, GD trẻ | Đạt | Đạt | Đạt | [H1-1.08-01] |
| 1.9 Thực hiện quy chế dân chủ cơ sở | Đạt | Đạt | Đạt | [H1-1.09-01] |
| 1.10 Đảm bảo an ninh trật tự, an toàn trường học | Đạt | Đạt | Đạt | [H1-1.10-01] |
| **Tiêu chuẩn 2: Cán bộ quản lý, giáo viên, nhân viên** | | | | |
| 2.1 Đối với Hiệu trưởng, Phó hiệu trưởng | Đạt | Đạt | Đạt | [H2-2.01-01] |
| 2.2 Đối với Giáo viên mầm non | Đạt | Đạt | Đạt | [H2-2.02-01] |
| 2.3 Đối với Nhân viên | Đạt | Đạt | Đạt | [H2-2.03-01] |
| 2.4 Số lượng và cơ cấu giáo viên, nhân viên | Đạt | Đạt | Đạt | [H2-2.04-01] |
| **Tiêu chuẩn 3: Cơ sở vật chất và thiết bị (TT 13/2020)** | | | | |
| 3.1 Diện tích khuôn viên, sân chơi, cây xanh | Đạt | Đạt | Đạt | [H3-3.01-01] |
| 3.2 Khối phòng nhóm trẻ, lớp mẫu giáo | Đạt | Đạt | Đạt | [H3-3.02-01] |
| 3.3 Khối phòng phục vụ học tập đa năng | Đạt | Đạt | Đạt | [H3-3.03-01] |
| 3.4 Khối phòng hành chính quản trị | Đạt | Đạt | Đạt | [H3-3.04-01] |
| 3.5 Bếp ăn bán trú một chiều an toàn thực phẩm | Đạt | Đạt | Đạt | [H3-3.05-01] |
| 3.6 Thiết bị, đồ dùng, đồ chơi giáo dục | Đạt | Đạt | Đạt | [H3-3.06-01] |
| **Tiêu chuẩn 4: Quan hệ nhà trường, gia đình và xã hội** | | | | |
| 4.1 Ban đại diện cha mẹ học sinh | Đạt | Đạt | Đạt | [H4-4.01-01] |
| 4.2 Công tác tham mưu và phối hợp xã hội | Đạt | Đạt | Đạt | [H4-4.02-01] |
| **Tiêu chuẩn 5: Hoạt động và kết quả nuôi dạy trẻ** | | | | |
| 5.1 Thực hiện Chương trình Giáo dục mầm non mới | Đạt | Đạt | Đạt | [H5-5.01-01] |
| 5.2 Tổ chức hoạt động nuôi dưỡng, chăm sóc sức khỏe | Đạt | Đạt | Đạt | [H5-5.02-01] |
| 5.3 Kết quả nuôi dưỡng, giảm tỷ lệ suy dinh dưỡng | Đạt | Đạt | Đạt | [H5-5.03-01] |
| 5.4 Kết quả giáo dục trẻ phát triển toàn diện | Đạt | Đạt | Đạt | [H5-5.04-01] |
| 5.5 Phổ cập giáo dục mầm non cho trẻ em | Đạt | Đạt | Đạt | [H5-5.05-01] |

## 3. Điểm mạnh nổi bật (Strengths)
- Đội ngũ giáo viên vững tay nghề, tích cực đổi mới phương pháp giáo dục lấy trẻ làm trung tâm.
- Môi trường học tập sáng - xanh - sạch - đẹp, đảm bảo an toàn tuyệt đối; bếp ăn đạt chuẩn an toàn thực phẩm.

## 4. Tồn tại và hạn chế (Deficiencies)
- Cần bổ sung thêm thiết bị đồ chơi thông minh và khu trải nghiệm thiên nhiên ngoài trời cho trẻ.

## 5. Kế hoạch cải tiến chất lượng
- Giải pháp: Tham mưu đầu tư cơ sở vật chất và tăng cường bồi dưỡng chuyên môn STEAM cho giáo viên.
- Thời gian thực hiện: Năm học 2026–2027. Phụ trách: Ban Giám hiệu và các Tổ chuyên môn.

## 6. Kết luận tự đánh giá
- Số tiêu chí đạt Mức 1: 25/25 (100%).
- Số tiêu chí đạt Mức 2: 25/25 (100%).
- Kết luận: Trường Mầm non [TÊN TRƯỜNG] đủ điều kiện đề nghị công nhận đạt chuẩn Quốc gia Mức độ [1/2].
''',

 'party_review': '''ĐẢNG BỘ QUẬN/HUYỆN: [TÊN QUẬN/HUYỆN]
CHI BỘ: TRƯỜNG MẦM NON [TÊN TRƯỜNG]
               ĐẢNG CỘNG SẢN VIỆT NAM
               -------------------

BẢN KIỂM ĐIỂM ĐẢNG VIÊN NĂM [NĂM]
(Dành cho Đảng viên là Giáo viên Mầm non - Mẫu 02-HD/BTCTW theo Quy định 124-QĐ/TW)

Họ và tên: [HỌ VÀ TÊN ĐẢNG VIÊN]
Ngày sinh: [NGÀY SINH]
Ngày vào Đảng: [NGÀY VÀO ĐẢNG] - Ngày chính thức: [NGÀY CHÍNH THỨC]
Chức vụ Đảng: Đảng viên
Chức vụ chuyên môn, đoàn thể: Giáo viên mầm non - Lớp [...]
Chi bộ: Trường Mầm non [TÊN TRƯỜNG]

---

## 1. Ưu điểm, kết quả công tác
### a. Về tư tưởng chính trị, phẩm chất đạo đức, lối sống, ý thức tổ chức kỷ luật
- Luôn kiên định chủ nghĩa Mác - Lênin, tư tưởng Hồ Chí Minh; chấp hành tuyệt đối đường lối của Đảng và chính sách của Nhà nước.
- Giữ gìn phẩm chất đạo đức nhà giáo mẫu mực, lối sống trong sạch, giản dị, chan hòa với đồng nghiệp và phụ huynh; không vi phạm những điều đảng viên không được làm.
- Thực hiện nghiêm túc việc học tập và làm theo tư tưởng, đạo đức, phong cách Hồ Chí Minh; gương mẫu thực hiện trách nhiệm nêu gương.
- Chấp hành nghiêm nguyên tắc tập trung dân chủ, quy chế của nhà trường và sự phân công của Chi bộ.

### b. Về thực hiện chức trách, nhiệm vụ được giao (Nuôi dạy và chăm sóc trẻ)
- Hết lòng yêu thương, chăm sóc trẻ; đảm bảo an toàn tuyệt đối về thể chất và tinh thần cho 100% trẻ của nhóm/lớp.
- Tích cực đổi mới phương pháp dạy học mầm non, ứng dụng hiệu quả STEAM, Montessori, học qua chơi lấy trẻ làm trung tâm.
- Thực hiện đúng quy định hồ sơ sổ sách mầm non theo Thông tư 52/2020/TT-BGDĐT; phối hợp chặt chẽ, tạo niềm tin vững chắc với cha mẹ học sinh.

## 2. Hạn chế, khuyết điểm và nguyên nhân
- Hạn chế: Việc ứng dụng công nghệ thông tin trong thiết kế bài giảng tương tác có lúc còn chưa phong phú do quỹ thời gian tự học còn hạn chế.
- Nguyên nhân: Thời gian làm việc trực tiếp tại lớp chăm sóc trẻ cả ngày dài, cường độ công việc cao.

## 3. Kết quả khắc phục khuyết điểm năm trước
- Đã chủ động sắp xếp thời gian hợp lý hơn, tích cực tham gia các buổi sinh hoạt chuyên môn và tự học nâng cao kỹ năng sư phạm.

## 4. Phương hướng, biện pháp khắc phục trong năm tới
- Tiếp tục rèn luyện bản lĩnh chính trị, giữ vững phẩm chất nhà giáo mẫu mực.
- Tích cực nghiên cứu ứng dụng công nghệ mới và học liệu tự nhiên phong phú trong giảng dạy.

## 5. Tự nhận mức xếp loại chất lượng
- Tự nhận mức xếp loại: Hoàn thành tốt nhiệm vụ (hoặc: Hoàn thành xuất sắc nhiệm vụ).

                                Ngày ..... tháng ..... năm .....
                                      NGƯỜI TỰ KIỂM ĐIỂM
                                    (Ký và ghi rõ họ tên)
''',

 'party_commitment': '''ĐẢNG BỘ: [TÊN ĐẢNG BỘ QUẬN/HUYỆN]
CHI BỘ: TRƯỜNG MẦM NON [TÊN TRƯỜNG]
               ĐẢNG CỘNG SẢN VIỆT NAM
               -------------------

BẢN CAM KẾT TU DƯỠNG, RÈN LUYỆN, PHẤN ĐẤU NĂM [NĂM]

Họ và tên: [HỌ VÀ TÊN ĐẢNG VIÊN]
Sinh ngày: [NGÀY SINH]
Đơn vị công tác: Trường Mầm non [TÊN TRƯỜNG]
Chức vụ Đảng: Đảng viên
Chức vụ chuyên môn: Giáo viên mầm non
Chi bộ: Trường Mầm non [TÊN TRƯỜNG]

---

Căn cứ Nghị quyết của Đảng và nhiệm vụ năm học mầm non, tôi xin cam kết thực hiện nghiêm túc các nội dung tu dưỡng, rèn luyện sau:

## 1. Về tư tưởng chính trị
- Tuyệt đối trung thành với Đảng, Nhà nước; chấp hành nghiêm chỉnh mọi chủ trương, đường lối, nghị quyết của Đảng.
- Kiên quyết đấu tranh ngăn chặn, đẩy lùi suy thoái về tư tưởng chính trị, đạo đức, lối sống, "tự diễn biến", "tự chuyển hóa".

## 2. Về phẩm chất đạo đức, lối sống
- Giữ gìn tư cách, đạo đức nhà giáo mầm non mẫu mực; tâm huyết, yêu nghề, mến trẻ.
- Thực hành tiết kiệm, chống lãng phí, tiêu cực; xây dựng môi trường lớp học yêu thương, hạnh phúc.

## 3. Về thực hiện nhiệm vụ chuyên môn
- Bảo đảm an toàn tuyệt đối cho trẻ em cả về thể chất lẫn tinh thần; không để xảy ra bất kỳ tai nạn thương tích nào tại nhóm lớp.
- Tích cực đổi mới phương pháp giáo dục, đẩy mạnh học qua chơi, giáo dục lấy trẻ làm trung tâm.

## 4. Về tổ chức kỷ luật và nêu gương
- Thực hiện nghiêm nguyên tắc tập trung dân chủ, giữ gìn đoàn kết nội bộ, chấp hành kỷ luật phát ngôn và quy tắc ứng xử học đường.
- Gương mẫu đi đầu trong các phong trào thi đua dạy tốt - học tốt của nhà trường.

                                Ngày ..... tháng ..... năm .....
                                      NGƯỜI CAM KẾT
                                    (Ký và ghi rõ họ tên)
''',

 'party_branch_minutes': '''ĐẢNG BỘ: [TÊN ĐẢNG BỘ CẤP TRÊN]
CHI BỘ: TRƯỜNG MẦM NON [TÊN TRƯỜNG]
               ĐẢNG CỘNG SẢN VIỆT NAM
               -------------------

BIÊN BẢN VÀ NGHỊ QUYẾT SINH HOẠT CHI BỘ ĐỊNH KỲ THÁNG [THÁNG/NĂM]

Thời gian: Vào hồi [...] giờ [...] ngày [...] tháng [...] năm [...]
Địa điểm: Văn phòng Trường Mầm non [TÊN TRƯỜNG]
Thành phần tham dự:
- Tổng số đảng viên: [...] đồng chí (Chính thức: [...], Dự bị: [...]).
- Có mặt: [...] đồng chí. Vắng mặt: [...] đồng chí.
- Chủ trì: Đồng chí [...] - Bí thư Chi bộ, Hiệu trưởng.
- Thư ký: Đồng chí [...] - Đảng viên, Giáo viên mầm non.

---

## 1. Quán triệt văn bản và thông tin thời sự
- Đồng chí Bí thư Chi bộ thông tin các chỉ đạo mới của Đảng ủy cấp trên và nhiệm vụ năm học của ngành GD mầm non.

## 2. Đánh giá công tác lãnh đạo của Chi bộ trong tháng qua
- Công tác chuyên môn nuôi dạy trẻ: 100% nhóm/lớp duy trì nề nếp, đảm bảo tuyệt đối an toàn cho trẻ em; thực hiện cân đối khẩu phần dinh dưỡng và vệ sinh an toàn thực phẩm bán trú.
- Công tác chính trị, tư tưởng: Toàn thể đảng viên, giáo viên an tâm công tác, nêu cao tinh thần trách nhiệm.
- Công tác xây dựng Đảng: Thực hiện tốt nề nếp sinh hoạt chi bộ; quản lý đảng viên chặt chẽ; bồi dưỡng quần chúng ưu tú.

## 3. Nhiệm vụ trọng tâm tháng tới
- Đẩy mạnh phong trào thi đua ứng dụng phương pháp giáo dục tiên tiến STEAM, Montessori tại các nhóm lớp.
- Rà soát hồ sơ kiểm định chất lượng và chuẩn quốc gia theo Thông tư 19/2018/TT-BGDĐT.
- Chuẩn bị công tác đánh giá xếp loại đảng viên cuối năm theo Quy định 124-QĐ/TW.

## 4. Ý kiến thảo luận của đảng viên
- Đảng viên đóng góp ý kiến sôi nổi về giải pháp nâng cao chất lượng hoạt động trải nghiệm và phối hợp phụ huynh.

## 5. Kết luận của Bí thư Chi bộ và biểu quyết Nghị quyết
- Toàn thể Chi bộ biểu quyết 100% nhất trí thông qua Nghị quyết công tác tháng tới.

           THƯ KÝ CUỘC HỌP                           BÍ THƯ CHI BỘ
        (Ký và ghi rõ họ tên)                    (Ký và ghi rõ họ tên)
'''
}

CATALOG = []
for ident, page, title, description, sections in SPECS:
    if ident in CUSTOM_BODIES:
        body = CUSTOM_BODIES[ident]
    else:
        body = '# ' + title.upper() + '\n\nNhóm tuổi: [CẦN BỔ SUNG]\nLớp: [CẦN BỔ SUNG]\nChủ đề: [CẦN BỔ SUNG]\nThời gian: [CẦN BỔ SUNG]\n'
        for i, section in enumerate(sections, 1):
            body += f'\n## {i}. {section}\n[CẦN BỔ SUNG]\n'
    CATALOG.append(dict(id=ident, page=page, title=title, description=description, body=body))

SYSTEM = '''Bạn là Trợ lý AI Giáo viên Mầm non Việt Nam – Chuyên gia thiết kế hoạt động sư phạm, xử lý tình huống và xây dựng hồ sơ kiểm định trường chuẩn quốc gia.

## NGUYÊN TẮC VĂN PHONG VÀ TRÌNH BÀY (BẮT BUỘC):
1. ĐI THẲNG VÀO NỘI DUNG CHÍNH (ZERO FLUFF):
   - Tuyệt đối KHÔNG mở bài dài dòng, không chào hỏi thừa thãi ("Chào bạn, tôi là...", "Dưới đây là câu trả lời...", "Sau đây là nội dung...").
   - Tuyệt đối KHÔNG lặp lại đề bài hay sao chép lại yêu cầu của người dùng.
   - Bắt đầu ngay bằng Tiêu đề Markdown (`# TÊN KẾ HOẠCH / VĂN BẢN / GIẢI PHÁP`) hoặc nội dung thực thi.
2. KHÔNG KẾT BÀI SÁO RỖNG:
   - Tuyệt đối KHÔNG thêm các câu kết thừa ("Hy vọng nội dung trên giúp ích cho bạn...", "Nếu cần chỉnh sửa hãy báo tôi..."). Kết thúc ngay khi hoàn thành nội dung.
3. TRÌNH BÀY PHÂN CẤP RÕ RÀNG, MẠCH LẠC:
   - Dùng tiêu đề Markdown chuẩn (`#`, `##`, `###`) để phân chia rõ các phần.
   - Dùng danh sách gạch đầu dòng (`- `) ngắn gọn, súc tích, ngắt dòng thoáng mắt.
   - Dùng danh sách đánh số (`1.`, `2.`, `3.`) cho các bước tiến trình hoặc thứ tự thời gian.
   - In đậm (`**từ khóa**`) cho các điểm then chốt, lời thoại mẫu của cô giáo hoặc lưu ý quan trọng.
4. TÍNH THỰC CHIẾN - DÙNG ĐƯỢC NGAY:
   - Kế hoạch giáo dục: Đầy đủ mục tiêu (Kiến thức, Kỹ năng, Thái độ), Chuẩn bị, Tiến trình chi tiết (lời dẫn của cô + thao tác của trẻ), Trò chơi củng cố, Đánh giá.
   - Xử lý tình huống: Có quy trình tại chỗ 3 bước, lời thoại mẫu dịu dàng dỗ trẻ, những điều cấm kỵ và kịch bản trao đổi/tin nhắn chân tình gửi phụ huynh.
   - Đánh giá chuẩn & Văn bản Đảng: Đúng thể thức, trích dẫn chuẩn xác, kèm bảng mã minh chứng [H1-1.01-01].
5. CÂU HỎI NGẮN / XÃ GIAO:
   - Khi người dùng hỏi ngắn hoặc chào ("xin chào", "hello", "bạn là ai", "bạn làm được gì"): Trả lời ấm áp, cô đọng trong 2-3 câu ngắn giới thiệu vai trò Trợ lý AI Mầm non và sẵn sàng hỗ trợ, TUYỆT ĐỐI không liệt kê danh sách kỹ năng hay văn bản pháp luật dài dòng.

## CĂN CỨ VÀ CHUYÊN MÔN NGHIỆP VỤ:
1. CHƯƠNG TRÌNH GDMN MỚI (VBHN 01/VBHN-BGDĐT, TT 51/2020/TT-BGDĐT):
   - Lấy trẻ làm trung tâm, học qua chơi, trải nghiệm trực quan.
   - Phương pháp tiên tiến: STEAM (mô hình 5E hoặc EDP), Montessori (bài học 3 bước, tự lập), Reggio Emilia (học qua dự án, xưởng Atelier).
   - Phân biệt rõ lứa tuổi: Nhà trẻ (0-3 tuổi) chú trọng giác quan, ngôn ngữ sớm, vận động; Mẫu giáo (3-6 tuổi) phát triển 5 lĩnh vực toàn diện. Không áp đặt cách dạy phổ thông, không ma trận đề hay chấm điểm trẻ.
2. ĐÁNH GIÁ CHUẨN TRƯỜNG THEO THÔNG TƯ 19/2018/TT-BGDĐT & THÔNG TƯ 13/2020/TT-BGDĐT:
   - 5 Tiêu chuẩn kiểm định chất lượng và đạt chuẩn quốc gia. Lọc đúng tiêu chí theo mức độ yêu cầu (Mức 1, 2, 3).
   - Đánh giá thực trạng (Đạt / Chưa đạt), Điểm mạnh, Tồn tại, Kế hoạch cải tiến và mã hóa minh chứng [H1-1.01-01].
3. HỒ SƠ ĐẢNG VIÊN VÀ CHI BỘ TRƯỜNG MẦM NON (QUY ĐỊNH 124-QĐ/TW & HƯỚNG DẪN 25-HD/BTCTW):
   - Chuẩn thể thức Đảng: Bản kiểm điểm đảng viên (Mẫu 02), Bản cam kết tu dưỡng, Biên bản/Nghị quyết Chi bộ.
   - Gắn sát phẩm chất đạo đức nhà giáo, tình thương và bảo đảm tuyệt đối an toàn cho trẻ.
4. NGUYÊN TẮC BẢO ĐẢM AN TOÀN VÀ TRÁCH NHIỆM:
   - Tuyệt đối bảo đảm an toàn cho trẻ: Không gợi ý vật liệu sắc nhọn, hạt nhỏ dễ hóc cho trẻ nhỏ; không gợi ý bài tập viết chữ hay tính toán trừu tượng.
   - Nhận xét khách quan dựa trên dữ liệu giáo viên cung cấp; ghi [CẦN BỔ SUNG] nếu thiếu dữ liệu, không bịa thông tin về trẻ.'''
