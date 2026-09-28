"""Preschool AI Assistant Engine: Activity Wizard, Parent Messaging, Observation Refiner, Creative Play Studio, Situation Co-pilot."""
from __future__ import annotations
import re
from typing import Any

THEMES = [
    'Trường mầm non',
    'Bản thân',
    'Gia đình',
    'Nghề nghiệp',
    'Thế giới thực vật',
    'Thế giới động vật',
    'Giao thông',
    'Nước và các hiện tượng tự nhiên',
    'Quê hương - Bác Hồ'
]

ADV_METHODS = [
    'STEAM (Mô hình 5E: Gắn kết - Khám phá - Giải thích - Củng cố - Đánh giá)',
    'STEAM (Quy trình thiết kế kỹ thuật EDP: Hỏi - Tưởng tượng - Kế hoạch - Chế tạo - Cải tiến)',
    'Montessori (5 góc: Thực hành cuộc sống, Giác quan, Ngôn ngữ, Toán, Văn hóa)',
    'Reggio Emilia (Dự án, Xưởng Atelier, Môi trường là người thầy thứ 3)',
    'Học qua chơi & Lấy trẻ làm trung tâm (Thông tư 51/2020/TT-BGDĐT)',
    'Trò chơi vận động & Âm nhạc trải nghiệm'
]

PARENT_SCENARIOS = [
    'Bé va chạm / trầy xước nhẹ (Thông báo chân thành & Đã sơ cứu kịp thời)',
    'Bé bị bạn cắn hoặc cắn bạn (Xử lý thấu cảm, gắn kết gia đình)',
    'Bé sốt nhẹ / mệt / biếng ăn / nôn trớ trong ngày',
    'Khen ngợi bé có tiến bộ vượt bậc (Động viên, tạo niềm vui)',
    'Nhắc đón bé muộn / Dặn dò chuẩn bị đồ dùng cá nhân',
    'Kêu gọi phối hợp nguyên vật liệu tự nhiên / tái chế an toàn',
    'Thông báo hoạt động trải nghiệm / dã ngoại / ngày hội'
]

CREATIVE_GENRES = [
    'Truyện ngắn có tên các bé trong lớp (kể trước giờ ngủ trưa)',
    'Bài thơ 4 chữ / 5 chữ ngắn dễ thuộc theo chủ đề',
    'Đồng dao / Vè vần điệu chuyển tiếp hoạt động',
    'Bộ 3 câu đố vui kích thích tư duy cho trẻ'
]

SITUATIONS = [
    'Trẻ mới đi học khóc nhiều, bám mẹ không chịu vào lớp',
    'Trẻ tranh giành đồ chơi, đánh hoặc cắn bạn',
    'Trẻ biếng ăn, ngậm cơm lâu, dễ nôn trớ',
    'Phụ huynh bức xúc phàn nàn vì con bị muỗi cắn hoặc xước da',
    'Xử lý sơ cấp cứu: Hóc dị vật đường thở (Thủ thuật vỗ lưng ấn ngực)',
    'Xử lý sơ cấp cứu: Sốt cao co giật ở trẻ mầm non'
]

PRESCHOOL_AI_SYSTEM = '''Bạn là Trợ lý Sư phạm Mầm non chuyên nghiệp tại Việt Nam.
NGUYÊN TẮC BẮT BUỘC:
1. Luôn xuất phát từ góc nhìn yêu thương trẻ, tôn trọng sự phát triển tự nhiên của trẻ mầm non (0-6 tuổi).
2. Tôn trọng triết lý "Học bằng chơi, chơi mà học", lấy trẻ làm trung tâm theo Thông tư 51/2020/TT-BGDĐT.
3. TUYỆT ĐỐI BẢO ĐẢM AN TOÀN TRẺ EM: Không gợi ý các vật liệu nhỏ dễ hóc (hạt cườm nhỏ, hột tròn) cho trẻ dưới 4 tuổi; không dùng kéo sắc nhọn, hóa chất độc hại; không giao bài tập viết chữ hay làm toán trừu tượng.
4. Lời thoại cô giáo phải dịu dàng, khích lệ ("Cô khen con...", "Các con ơi...", "Chúng mình cùng xem...").
5. Giao tiếp phụ huynh phải chân thành, tinh tế, nhận trách nhiệm bao quát, xoa dịu lo lắng và xây dựng niềm tin yêu.'''


def generate_activity_plan(topic: str, age: str, theme: str, method: str, duration: str, materials: str,
                           school: str = '', class_name: str = '', profile: dict = None, key: str = '',
                           ask_ai_fn: Any = None) -> str:
    topic = (topic or 'Khám phá thiên nhiên quanh bé').strip()
    age = age or 'Mẫu giáo 4–5 tuổi'
    theme = theme or 'Bản thân'
    method = method or 'STEAM (Mô hình 5E)'
    duration = duration or '25–30 phút'
    materials = materials or 'Vật liệu tự nhiên và đồ chơi lớp có sẵn'
    school = school or 'Trường Mầm non'
    class_name = class_name or 'Lớp Mẫu giáo'

    # Try calling AI if key and model are present
    if key and profile and profile.get('model') and ask_ai_fn:
        prompt = (
            f"Hãy thiết kế 01 KẾ HOẠCH TỔ CHỨC HOẠT ĐỘNG GIÁO DỤC MẦM NON hoàn chỉnh:\n"
            f"- Đề tài hoạt động: {topic}\n"
            f"- Độ tuổi: {age}\n"
            f"- Chủ đề: {theme}\n"
            f"- Phương pháp áp dụng: {method}\n"
            f"- Thời lượng: {duration}\n"
            f"- Học liệu chuẩn bị sẵn: {materials}\n"
            f"- Đơn vị: {school} - Lớp: {class_name}\n\n"
            f"YÊU CẦU CẤU TRÚC CHI TIẾT:\n"
            f"1. Mục tiêu (Kiến thức khoa học/khám phá, Kỹ năng thực hành/vận động tinh, Thái độ/cảm xúc tích cực)\n"
            f"2. Chuẩn bị môi trường & học liệu an toàn\n"
            f"3. Tiến trình tổ chức hoạt động chi tiết (gồm lời dẫn thoại của cô + hoạt động cụ thể của trẻ theo từng bước)\n"
            f"4. Hệ thống 3-5 câu hỏi mở kích thích tư duy\n"
            f"5. Trò chơi củng cố hoặc bài hát/bài thơ kết nối\n"
            f"6. Lưu ý an toàn và quan sát hỗ trợ cá nhân trẻ nhút nhát\n\n"
            f"Soạn chi tiết, có lời thoại cụ thể cho cô giáo dễ thực hành ngay trên lớp."
        )
        try:
            return ask_ai_fn(profile, key, [{'role': 'user', 'content': prompt}])
        except Exception:
            pass

    # High-quality smart pedagogical fallback
    return (
        f"# KẾ HOẠCH TỔ CHỨC HOẠT ĐỘNG GIÁO DỤC TRẢI NGHIỆM\n"
        f"*(Căn cứ Chương trình GD Mầm non mới - Thông tư 51/2020/TT-BGDĐT)*\n\n"
        f"**Trường:** {school}  ·  **Lớp:** {class_name}\n"
        f"**Chủ đề:** {theme}  ·  **Độ tuổi:** {age}\n"
        f"**Tên hoạt động:** {topic.upper()}\n"
        f"**Phương pháp:** {method}  ·  **Thời lượng:** {duration}\n\n"
        f"---\n\n"
        f"## 1. Mục tiêu hoạt động\n"
        f"- **Kiến thức:** Trẻ nhận biết, gọi tên đúng và chỉ ra được các đặc điểm, quy luật hoặc thuộc tính nổi bật của đối tượng trong hoạt động ({topic}).\n"
        f"- **Kỹ năng:** Trẻ rèn luyện kỹ năng quan sát, sử dụng các giác quan (chạm, nhìn, lắng nghe); rèn luyện vận động tinh khéo léo qua thao tác với học liệu; biết chia sẻ ý kiến với cô và bạn.\n"
        f"- **Thái độ:** Trẻ hào hứng, tò mò khám phá; biết giữ gìn đồ chơi, hợp tác vui vẻ cùng bạn và tự giác thu dọn đồ dùng sau khi chơi.\n\n"
        f"## 2. Chuẩn bị môi trường & học liệu an toàn\n"
        f"- **Không gian:** Lớp học sạch sẽ, thoáng mát, sàn khô ráo; chia thành các nhóm trải nghiệm mở tiện cho trẻ di chuyển.\n"
        f"- **Đồ dùng của cô:** Mô hình/vật mẫu trực quan, video ngắn hoặc hộp quà bí mật khơi gợi bất ngờ; bảng ghi nhận hình vẽ ngộ nghĩnh.\n"
        f"- **Học liệu của trẻ:** {materials}; phân chia đều vào các khay hoạt động cho từng nhóm/trẻ đảm bảo tiêu chuẩn an toàn mầm non.\n\n"
        f"## 3. Tiến trình tổ chức hoạt động chi tiết\n\n"
        f"### Bước 1: Gắn kết & Khơi gợi hứng thú (3–5 phút)\n"
        f"- Cô tập trung trẻ bằng một trò chơi ngón tay hoặc bài hát vui nhộn liên quan đến chủ đề {theme}.\n"
        f"- **Lời thoại gợi mở:** *\"Loa loa loa loa! Hôm nay lớp chúng mình có một vị khách bí mật mang đến một món quà vô cùng kỳ diệu. Các con có muốn cùng cô khám phá xem đó là gì không nào?\"*\n"
        f"- Cho trẻ quan sát hộp quà, đặt câu hỏi phỏng đoán: *\"Con đoán bên trong có gì? Vì sao con lại nghĩ như vậy?\"*\n\n"
        f"### Bước 2: Khám phá & Trải nghiệm thực tế (12–15 phút)\n"
        f"- Trẻ về các nhóm hoạt động, tự tay nhận khay học liệu và đồ dùng chuẩn bị sẵn.\n"
        f"- Trẻ trực tiếp dùng các giác quan: nhìn kỹ, sờ chạm, ngửi, thử nghiệm thao tác với vật liệu ({topic}).\n"
        f"- **Hành động của cô:** Cô đi quanh các nhóm, ngồi ngang tầm mắt trẻ, quan sát, lắng nghe trẻ trò chuyện và đặt các câu hỏi gợi mở:\n"
        f"  + *\"Khi con chạm vào vật này, con cảm thấy như thế nào?\"*\n"
        f"  + *\"Nếu chúng mình thử đặt vật này vào đây thì điều gì sẽ xảy ra tiếp theo nhỉ?\"*\n"
        f"  + *\"Con có phát hiện thấy điều gì thú vị vừa xuất hiện không?\"*\n"
        f"- Tuyệt đối cô không làm thay trẻ, để trẻ tự do khám phá và tự rút ra nhận xét theo cách của mình.\n\n"
        f"### Bước 3: Giải thích & Chia sẻ phát hiện (5–7 phút)\n"
        f"- Cô mời đại diện từng nhóm hoặc cá nhân trẻ lên chia sẻ điều mình vừa phát hiện được.\n"
        f"- Cô lắng nghe, tôn trọng mọi ý tưởng của trẻ, dùng lời nói dịu dàng chuẩn hóa kiến thức ngắn gọn, trực quan, dễ nhớ.\n"
        f"- Khen ngợi sự tò mò và sáng tạo của từng bạn nhỏ.\n\n"
        f"### Bước 4: Áp dụng & Củng cố sáng tạo (5 phút)\n"
        f"- Cho trẻ vận dụng điều vừa khám phá để thực hiện một thử thách nhỏ (vẽ lại điều con thích, tạo hình nhanh từ đất nặn/bìa giấy, hoặc tham gia trò chơi vận động mô phỏng).\n"
        f"- Cả lớp cùng tham gia trò chơi vận động vui nhộn để xua tan mệt mỏi.\n\n"
        f"## 4. Quan sát và hỗ trợ cá nhân\n"
        f"- Lưu ý những trẻ còn nhút nhát để đến gần khích lệ, đặt câu hỏi đơn giản giúp trẻ tự tin phát biểu.\n"
        f"- Nhắc nhở trẻ thao tác cẩn thận, không đưa đồ vật vào mắt, mũi, miệng.\n\n"
        f"## 5. Kết thúc & Điều chỉnh sau hoạt động\n"
        f"- Cô cùng trẻ hát vang bài hát kết thúc hoạt động, hướng dẫn các con tự giác cất đồ dùng, đồ chơi gọn gàng đúng nơi quy định.\n"
        f"- Ghi nhận mức độ hứng thú của lớp để điều chỉnh độ khó cho các hoạt động tiếp theo."
    )


def generate_parent_message(scenario: str, child_name: str, details: str, class_name: str = '',
                           teacher_name: str = '', school: str = '', profile: dict = None, key: str = '',
                           ask_ai_fn: Any = None) -> str:
    child_name = (child_name or 'bé').strip()
    class_name = class_name or 'Lớp Mầm non'
    teacher_name = teacher_name or 'cô giáo'
    school = school or 'Trường Mầm non'
    details = (details or '').strip()

    if key and profile and profile.get('model') and ask_ai_fn:
        prompt = (
            f"Hãy soạn 01 TIN NHẮN GỬI PHỤ HUYNH QUA ZALO cực kỳ khéo léo, tinh tế, ấm áp và chuẩn mực sư phạm:\n"
            f"- Tình huống: {scenario}\n"
            f"- Tên bé: {child_name}\n"
            f"- Chi tiết thực tế ở lớp: {details or 'Bé học tập và vui chơi ở lớp'}\n"
            f"- Lớp: {class_name} - Tên cô giáo: {teacher_name}\n\n"
            f"YÊU CẦU QUAN TRỌNG VỀ VĂN PHONG:\n"
            f"1. Lời chào ấm áp, xưng hô 'cô' và 'bố mẹ bé {child_name}'.\n"
            f"2. Nêu rõ ràng sự việc trung thực, nhận trách nhiệm bao quát của cô, nêu cụ thể các bước sơ cứu/chăm sóc đã thực hiện tại lớp và báo tình trạng bình thường hiện tại của con để bố mẹ yên tâm.\n"
            f"3. Dặn dò bố mẹ phối hợp theo dõi con buổi tối một cách ân cần.\n"
            f"4. Sử dụng các emoji phù hợp (❤️, 🌸, 🌿, 🌟) giúp tin nhắn nhẹ nhàng, thân tình, giảm căng thẳng tối đa."
        )
        try:
            return ask_ai_fn(profile, key, [{'role': 'user', 'content': prompt}])
        except Exception:
            pass

    # Smart templates for each scenario
    s_lower = scenario.lower()
    if any(k in s_lower for k in ('va chạm', 'trầy xước', 'xước', 'ngã')):
        detail_note = details or 'con có vô tình vấp nhẹ làm trầy xước nhẹ ở đầu gối'
        return (
            f"Dạ cô {teacher_name} ({class_name}) xin gửi lời chào ấm áp tới bố mẹ {child_name} ạ! ❤️\n\n"
            f"Thưa bố mẹ, chiều nay trong lúc cả lớp đang vui chơi hoạt động, {detail_note}. Ngay lúc đó, cô đã kịp thời bế dỗ dành con, dùng nước muối sinh lý rửa sạch vết thương và chườm mát cho con ngay ạ.\n\n"
            f"Sau đó con đã nín khóc, ăn ngoan và vui vẻ chơi đùa cùng các bạn bình thường rồi bố mẹ nhé. Cô rất xin lỗi bố mẹ vì lúc đó cô chưa kịp bao quát hết để con bị đau một chút. Chiều nay đón con về, bố mẹ quan sát và chăm sóc thêm vết xước giúp cô nha. Nếu có bất kỳ điều gì cần hỗ trợ, bố mẹ cứ nhắn cô ngay nhé ạ.\n\n"
            f"Cô cảm ơn sự thấu hiểu và tin yêu của bố mẹ rất nhiều ạ! 🌸"
        )
    elif any(k in s_lower for k in ('cắn', 'bạn cắn')):
        detail_note = details or 'trong lúc tranh đồ chơi, hai bạn nhỏ có va chạm và bé có vết cắn nhẹ'
        return (
            f"Dạ cô {teacher_name} ({class_name}) xin gửi lời chào thân thương tới bố mẹ {child_name} ạ! ❤️\n\n"
            f"Thưa bố mẹ, cô xin phép được trao đổi nhanh với bố mẹ một việc ở lớp hôm nay ạ. Giờ chơi góc chiều nay, {detail_note}. Ngay khi phát hiện, cô đã can thiệp lập tức, tách hai con ra, rửa sạch và chườm lạnh vết thương cho con chu đáo ạ.\n\n"
            f"Ở lứa tuổi mầm non, đôi khi các con chưa biết dùng lời nói để diễn đạt mong muốn nên dễ có phản xạ cắn bạn khi muốn giành đồ chơi. Cô đã nghiêm túc giải thích, chỉ bảo nhẹ nhàng cho bạn biết hành vi đó làm bạn đau và bạn đã xin lỗi con rồi ạ. Con cũng đã ngoan và chơi vui trở lại.\n\n"
            f"Cô xin nhận lỗi với bố mẹ vì sự cố ngoài ý muốn này. Chiều nay đón con về, bố mẹ xoa dịu và theo dõi thêm vết cắn giúp cô nhé. Cô chân thành cảm ơn sự đồng hành và chia sẻ của bố mẹ cùng cô giáo ạ! 🌿"
        )
    elif any(k in s_lower for k in ('sốt', 'mệt', 'biếng ăn', 'nôn')):
        detail_note = details or 'con có biểu hiện trán ấm, người hơi mệt và ăn ít hơn thường ngày'
        return (
            f"Dạ cô {teacher_name} ({class_name}) xin chào bố mẹ {child_name} ạ! 🌿\n\n"
            f"Bố mẹ ơi, hôm nay ở lớp {detail_note}. Cô đã chủ động cho con nghỉ ngơi ở khu vực thoáng mát, uống thêm nước ấm và kiểm tra nhiệt độ thường xuyên cho con. Hiện tại con vẫn chơi ngoan nhưng người có phần mệt mỏi hơn ngày thường một chút ạ.\n\n"
            f"Chiều nay khi đón con về, bố mẹ theo dõi thêm nhiệt độ và cho con ăn thức ăn mềm, dễ tiêu giúp cô nhé. Nếu tối nay con có biểu hiện sốt cao hoặc mệt thêm, bố mẹ nhớ nhắn cô để cô cùng nắm thông tin và phối hợp chăm sóc con chu đáo nhất nha bố mẹ.\n\n"
            f"Chúc {child_name} mau khỏe để ngày mai lại đến lớp líu lo cùng cô và các bạn ạ! ❤️"
        )
    elif any(k in s_lower for k in ('tiến bộ', 'khen', 'vượt bậc')):
        detail_note = details or 'hôm nay con rất tự giác tự xúc hết suất cơm và còn biết nhường đồ chơi cho bạn'
        return (
            f"Dạ cô {teacher_name} ({class_name}) xin chào bố mẹ {child_name} ạ! 🌟\n\n"
            f"Hôm nay cô có một niềm vui nho nhỏ rất muốn chia sẻ ngay cùng bố mẹ nè! Ở lớp hôm nay, {child_name} đã có một sự tiến bộ vượt bậc và biểu hiện vô cùng đáng yêu: {detail_note}. Cả cô và các bạn đều vỗ tay khen ngợi con thật to!\n\n"
            f"Nhìn con ngày càng tự lập, hiểu chuyện và biết yêu thương bạn bè, cô vui và hạnh phúc lắm ạ. Về nhà bố mẹ cũng dành cho con một cái ôm thật chặt và lời khen ngợi để con có thêm động lực tiếp tục phát huy sự tiến bộ này bố mẹ nhé!\n\n"
            f"Cảm ơn bố mẹ đã luôn đồng hành và cùng cô rèn luyện cho con những thói quen thật tuyệt vời! 💖"
        )
    elif any(k in s_lower for k in ('đón muộn', 'đồ dùng', 'nhắc')):
        detail_note = details or 'chiều nay bố mẹ nhớ mang thêm 1 bộ quần áo dự phòng cho con'
        return (
            f"Dạ cô {teacher_name} ({class_name}) kính gửi lời chào tới bố mẹ {child_name} ạ! ⏰\n\n"
            f"Cô xin phép nhắn tin nhắc nhỏ bố mẹ một chút ạ: {detail_note}. Để việc chăm sóc con tại lớp được chu đáo và tiện lợi nhất, bố mẹ lưu ý chuẩn bị hoặc sắp xếp thời gian đón con theo quy định giúp cô nhé.\n\n"
            f"Nếu hôm nay bố mẹ có việc bận đón muộn hoặc nhờ người thân đón hộ, bố mẹ vui lòng gọi điện hoặc nhắn tin báo trước cho cô để cô nắm được và yên tâm giữ con an toàn tại lớp nhé ạ.\n\n"
            f"Cô cảm ơn sự phối hợp nhiệt tình của bố mẹ rất nhiều ạ! 🌸"
        )
    elif any(k in s_lower for k in ('thu gom', 'vật liệu', 'tái chế')):
        detail_note = details or 'các loại vỏ hộp sữa, chai nhựa sạch, bìa carton hoặc lá cây khô'
        return (
            f"Dạ cô {teacher_name} xin gửi lời chào trân trọng tới toàn thể Quý phụ huynh Lớp {class_name}! 🍀\n\n"
            f"Để chuẩn bị cho dự án học tập trải nghiệm sáng tạo (STEAM) sắp tới của các con, lớp mình đang rất cần một số nguyên vật liệu tự nhiên và đồ tái chế an toàn như: {detail_note}.\n\n"
            f"Cô rất mong nhận được sự chung tay phối hợp của bố mẹ bằng cách gom các vật liệu sạch trên và gửi con mang tới lớp trong tuần này. Mỗi món đồ nhỏ từ gia đình sẽ giúp các con có thêm nhiều cơ hội sáng tạo những sản phẩm đồ chơi độc đáo bằng chính đôi tay của mình đấy ạ!\n\n"
            f"Cô giáo và các con xin gửi lời cảm ơn chân thành nhất tới sự ủng hộ nhiệt tình của bố mẹ ạ! ❤️"
        )
    else:
        detail_note = details or 'kế hoạch hoạt động trải nghiệm sắp tới của các con'
        return (
            f"Dạ cô {teacher_name} ({class_name}) kính gửi lời chào thân thương tới bố mẹ {child_name} ạ! 📢\n\n"
            f"Cô xin trân trọng thông báo tới bố mẹ thông tin: {detail_note}. Nhà trường và các cô đã chuẩn bị môi trường chu đáo và an toàn nhất để các con có một buổi trải nghiệm thật vui vẻ, bổ ích.\n\n"
            f"Rất mong bố mẹ theo dõi thông tin và cùng phối hợp với cô giáo để các con có một ngày hoạt động trọn vẹn niềm vui. Nếu bố mẹ có bất kỳ câu hỏi nào, xin hãy nhắn tin trực tiếp cho cô bất cứ lúc nào nhé ạ.\n\n"
            f"Chúc bố mẹ và gia đình một ngày làm việc thật nhiều niềm vui và bình an! 🌸"
        )


def refine_pedagogical_observation(child: str, raw_notes: str, area: str = '', kind: str = 'observation',
                                    age: str = '', profile: dict = None, key: str = '',
                                    ask_ai_fn: Any = None) -> dict[str, str]:
    child = (child or 'Trẻ').strip()
    raw_notes = (raw_notes or '').strip()
    area = area or 'Tình cảm và kỹ năng xã hội'
    age = age or 'Mẫu giáo 4–5 tuổi'

    if not raw_notes:
        return {
            'notes': 'Trẻ tích cực tham gia hoạt động, biết lắng nghe cô và hòa đồng cùng các bạn trong nhóm.',
            'next': 'Tiếp tục khích lệ trẻ phát huy tính chủ động và rèn luyện kỹ năng tự lập.'
        }

    if key and profile and profile.get('model') and ask_ai_fn:
        prompt = (
            f"Hãy chuẩn hóa ghi nhận quan sát sau đây của giáo viên mầm non thành CÂU NHẬN XÉT SƯ PHẠM CHUẨN MỰC, TÍCH CỰC:\n"
            f"- Tên trẻ: {child} (Độ tuổi: {age})\n"
            f"- Lĩnh vực quan sát: {area}\n"
            f"- Ghi chép thô của cô: \"{raw_notes}\"\n\n"
            f"YÊU CẦU ĐẦU RA (2 phần rõ ràng):\n"
            f"PHẦN 1 - NHẬN XÉT SƯ PHẠM: Viết bằng ngôn ngữ tôn trọng, hướng tới sự tiến bộ của trẻ (growth mindset), mô tả khách quan hành vi và tiến bộ của trẻ, tránh gán nhãn tiêu cực.\n"
            f"PHẦN 2 - BIỆN PHÁP HỖ TRỢ TIẾP THEO: Gợi ý 1-2 hành động sư phạm cụ thể cô cần làm để đồng hành cùng trẻ.\n\n"
            f"Định dạng trả về duy nhất:\n"
            f"NHẬN XÉT: [Nội dung nhận xét]\n"
            f"HỖ TRỢ: [Biện pháp hỗ trợ]"
        )
        try:
            ans = ask_ai_fn(profile, key, [{'role': 'user', 'content': prompt}])
            m1 = re.search(r'NHẬN XÉT:\s*(.*?)(?=\nHỖ TRỢ:|\Z)', ans, re.DOTALL | re.IGNORECASE)
            m2 = re.search(r'HỖ TRỢ:\s*(.*?)$', ans, re.DOTALL | re.IGNORECASE)
            if m1:
                return {
                    'notes': m1.group(1).strip(),
                    'next': m2.group(1).strip() if m2 else 'Tiếp tục quan sát và đồng hành cùng trẻ.'
                }
        except Exception:
            pass

    # High-quality rule-based pedagogical refiner
    rn_lower = raw_notes.lower()
    if any(w in rn_lower for w in ('tranh', 'giành', 'đẩy', 'đánh', 'cắn')):
        notes = (
            f"Trẻ bộc lộ cảm xúc rõ ràng khi tham gia hoạt động nhóm cùng bạn. "
            f"Đôi lúc còn lúng túng trong việc chia sẻ đồ chơi; sau khi được cô giải thích và làm mẫu, "
            f"trẻ đã hiểu, biết nhường nhịn bạn và bình tĩnh chơi hòa đồng trở lại."
        )
        nxt = "Cô tạo thêm các tình huống chơi nhóm đôi bạn, hướng dẫn trẻ dùng lời nói để mượn đồ chơi và kịp thời khen ngợi khi trẻ biết chia sẻ."
    elif any(w in rn_lower for w in ('khóc', 'mẹ', 'nhớ nhà', 'bám')):
        notes = (
            f"Trẻ còn chút bỡ ngỡ và xúc động khi chia tay gia đình vào đầu buổi học. "
            f"Được cô vỗ về và hướng dẫn tham gia trò chơi góc, trẻ đã nhanh chóng an tâm, "
            f"hào hứng hòa nhập và giao tiếp vui vẻ cùng các bạn."
        )
        nxt = "Tạo cảm giác an toàn, đón trẻ bằng nụ cười và cử chỉ âu yếm; chuẩn bị sẵn món đồ chơi bé yêu thích tại góc lớp."
    elif any(w in rn_lower for w in ('ngậm', 'biếng ăn', 'ăn chậm', 'nôn', 'chê')):
        notes = (
            f"Trong giờ ăn, tốc độ nhai nuốt của trẻ còn hơi chậm và cần sự khích lệ từ cô giáo. "
            f"Sau khi được cô động viên và kể chuyện ngộ nghĩnh, trẻ đã vui vẻ cố gắng ăn hết phần thức ăn của mình."
        )
        nxt = "Chia nhỏ lượng thức ăn, tạo không khí vui tươi giờ ăn qua trò chơi mô phỏng; phối hợp gia đình rèn nếp ăn tập trung tại nhà."
    elif any(w in rn_lower for w in ('nhút nhát', 'rụt rè', 'ít nói', 'không nói')):
        notes = (
            f"Trẻ có tính cách trầm tĩnh, khả năng tập trung quan sát tốt. "
            f"Khi tham gia phát biểu trước tập thể còn hơi e dè; khi được cô động viên riêng 1-1, "
            f"trẻ trả lời rõ ràng và thể hiện sự hiểu biết đúng chủ đề."
        )
        nxt = "Thường xuyên đặt câu hỏi gợi mở đơn giản, khen ngợi từng sự tiến bộ nhỏ để bồi dưỡng sự tự tin cho trẻ."
    elif any(w in rn_lower for w in ('khéo', 'vẽ', 'xếp', 'sáng tạo', 'giỏi', 'ngoan')):
        notes = (
            f"Trẻ rất khéo léo, phát huy tốt sự sáng tạo và khả năng vận động tinh trong hoạt động. "
            f"Trẻ chủ động lựa chọn học liệu, tập trung hoàn thiện sản phẩm và hào hứng giới thiệu cùng cô và các bạn."
        )
        nxt = "Khuyến khích trẻ thử thách ở các mức độ tạo hình khó hơn và hướng dẫn các bạn cùng bàn cùng làm."
    else:
        notes = (
            f"Trẻ tham gia hoạt động với tinh thần hào hứng: {raw_notes}. "
            f"Trẻ thể hiện sự tiến bộ rõ nét trong khả năng nhận thức và kỹ năng thực hành theo lứa tuổi."
        )
        nxt = "Tiếp tục tạo môi trường trải nghiệm phong phú để trẻ rèn luyện và phát triển toàn diện."

    return {'notes': notes, 'next': nxt}


def generate_creative_content(genre: str, children_names: str, topic: str, age: str = '',
                              profile: dict = None, key: str = '', ask_ai_fn: Any = None) -> str:
    children_names = (children_names or 'Minh Khôi, Bảo An').strip()
    topic = (topic or 'Giữ gìn vệ sinh đôi bàn tay xinh').strip()
    age = age or 'Mẫu giáo 4–5 tuổi'
    genre = genre or 'Truyện ngắn có tên các bé trong lớp'

    if key and profile and profile.get('model') and ask_ai_fn:
        prompt = (
            f"Hãy sáng tác 01 tác phẩm mầm non thể loại '{genre}':\n"
            f"- Chủ đề/Bài học: {topic}\n"
            f"- Tên các bé nhân vật chính xuất hiện trong câu chuyện/bài thơ: {children_names}\n"
            f"- Độ tuổi độc giả nhỏ tuổi: {age}\n\n"
            f"YÊU CẦU NGHỆ THUẬT SƯ PHẠM:\n"
            f"1. Nội dung trong sáng, ngôn từ giàu hình ảnh, nhịp điệu tươi vui, ngộ nghĩnh.\n"
            f"2. Đưa tên các bé ({children_names}) vào một cách tự nhiên, đáng yêu, giúp các bé cảm thấy tự hào và thích thú khi nghe cô đọc.\n"
            f"3. Lồng ghép bài học giáo dục nhẹ nhàng (vệ sinh, chia sẻ, vâng lời, dũng cảm).\n"
            f"4. Kèm theo 3 câu hỏi gợi mở đố vui sau khi kể xong."
        )
        try:
            return ask_ai_fn(profile, key, [{'role': 'user', 'content': prompt}])
        except Exception:
            pass

    # High quality creative fallback
    first_name = [n.strip() for n in children_names.replace(';', ',').split(',') if n.strip()][0] if children_names else 'Bé'
    second_name = [n.strip() for n in children_names.replace(';', ',').split(',') if n.strip()][1] if len([n.strip() for n in children_names.replace(';', ',').split(',') if n.strip()]) > 1 else 'Bảo An'

    if 'thơ' in genre.lower() or 'vè' in genre.lower() or 'đồng dao' in genre.lower():
        return (
            f"# BÀI THƠ MẦM NON: {topic.upper()}\n"
            f"*(Dành tặng các bé: {children_names} - Nhóm tuổi: {age})*\n\n"
            f"Bàn tay bé nhỏ\n"
            f"Trắng trẻo xinh xinh\n"
            f"Mỗi sớm bình minh\n"
            f"Rửa tay sạch mát.\n\n"
            f"Bạn {first_name} cười hát\n"
            f"Bạn {second_name} vỗ tay\n"
            f"Bong bóng tung bay\n"
            f"Xà phòng thơm ngát.\n\n"
            f"Vi khuẩn chạy tít\n"
            f"Bàn tay trắng tinh\n"
            f"Ăn cơm một mình\n"
            f"Thật là ngoan ngoãn!\n\n"
            f"---\n"
            f"## Câu hỏi gợi mở sau bài thơ:\n"
            f"1. Bạn {first_name} và bạn {second_name} trong bài thơ đã rửa tay bằng gì nhỉ?\n"
            f"2. Bàn tay sạch sẽ giúp chúng mình phòng tránh điều gì nào các con?\n"
            f"3. Chúng mình cùng cô giơ đôi bàn tay xinh lên nào!"
        )
    elif 'câu đố' in genre.lower():
        return (
            f"# BỘ CÂU ĐỐ VUI THEO CHỦ ĐỀ: {topic.upper()}\n"
            f"*(Cô đố các bé {children_names} và cả lớp cùng giải nhé!)*\n\n"
            f"### Câu đố số 1:\n"
            f"\"Cái gì mười ngón thật xinh\n"
            f"Giúp bé cầm bút, vẽ tranh tô màu\n"
            f"Rửa sạch trước mỗi bữa ăn\n"
            f"Đố bé đoán được là gì nào ai ơi?\"\n"
            f"👉 **Đáp án:** *Đôi bàn tay của bé.*\n\n"
            f"### Câu đố số 2:\n"
            f"\"Trắng tinh như bọt mây trời\n"
            f"Thơm tho dịu mát cho người sạch trơn\n"
            f"Gặp nước thì nổi phập phồng\n"
            f"Xua tan vi khuẩn, là gì bé ngoan?\"\n"
            f"👉 **Đáp án:** *Bánh xà phòng thơm.*\n\n"
            f"### Câu đố số 3:\n"
            f"\"Miệng tròn lòng trắng sâu sâu\n"
            f"Cơm canh đầy ắp bé mau xúc liền\n"
            f"Ăn xong cất gọn ngoan hiền\n"
            f"Đố bạn {first_name} biết là đồ vật chi?\"\n"
            f"👉 **Đáp án:** *Bát ăn cơm của bé.*"
        )
    else:
        return (
            f"# CÂU CHUYỆN KỂ TRƯỚC GIỜ NGỦ: CHUYẾN PHIÊU LƯU CỦA ĐÔI BÀN TAY XINH\n"
            f"*(Chủ đề: {topic} - Nhân vật chính: {children_names})*\n\n"
            f"Vào một buổi sáng ngập tràn ánh nắng ấm áp tại lớp mầm non thân yêu, bạn {first_name} và bạn {second_name} đang cùng nhau xây một tòa lâu đài cát vô cùng tráng lệ ở góc trải nghiệm.\n\n"
            f"Bỗng nhiên, bác Đồng Hồ reng lên một hồi chuông giòn giã: *Reng... reng... reng! Đã đến giờ ăn cơm trưa rồi các bé ơi!*. Lúc này, đôi bàn tay của hai bạn dính đầy những hạt cát và bụi bẩn li ti. Một chú vi khuẩn Tí Nị trốn trong kẽ tay thì thầm: *'Haha, hai bạn nhỏ quên rửa tay rồi, chúng mình sắp được vào bụng rồi!'*.\n\n"
            f"Nhưng bạn {first_name} liền tinh ý nhìn xuống đôi bàn tay mình và bảo với {second_name}: *'{second_name} ơi, tay chúng mình đang bẩn kìa, cô giáo dặn trước khi ăn cơm phải rửa tay bằng xà phòng để vi khuẩn không làm đau bụng đấy!'*. Thế là hai bạn nhỏ liền nắm tay nhau chạy ngay ra bồn rửa tay.\n\n"
            f"Xoẹt... xoẹt! Dòng nước mát lạnh xả xuống, bánh xà phòng bọt trắng xốp xoa đều lên mu bàn tay, từng kẽ ngón tay. Chú vi khuẩn Tí Nị sợ quá hét toáng lên rồi trôi vèo theo dòng nước xuống cống. Đôi bàn tay của bạn {first_name} và bạn {second_name} bây giờ đã sạch bong kin kít và thơm tho mùi dâu tây.\n\n"
            f"Cô giáo mỉm cười xoa đầu hai bạn: *'Cô khen {first_name} và {second_name} đã biết giữ gìn đôi bàn tay sạch sẽ nhé! Các con thật là những em bé ngoan!'*. Bữa trưa hôm ấy, hai bạn nhỏ ăn cơm thật ngon lành và ngủ một giấc trưa thật êm đềm với những giấc mơ đẹp.\n\n"
            f"---\n"
            f"## Câu hỏi trò chuyện cùng bé:\n"
            f"1. Trong câu chuyện, bạn {first_name} và bạn {second_name} đã làm gì trước khi ăn cơm?\n"
            f"2. Điều gì đã xảy ra với chú vi khuẩn khi hai bạn rửa tay bằng xà phòng?\n"
            f"3. Chúng mình cùng hứa với cô luôn giữ đôi bàn tay sạch sẽ như hai bạn nhé!"
        )


def generate_situation_coaching(situation: str, details: str = '', age: str = '',
                                profile: dict = None, key: str = '', ask_ai_fn: Any = None) -> str:
    situation = situation or 'Trẻ khóc nhiều lúc sáng sớm không chịu vào lớp'
    age = age or 'Mẫu giáo 3–4 tuổi'

    if key and profile and profile.get('model') and ask_ai_fn:
        prompt = (
            f"Hãy đưa ra cẩm nang hướng dẫn xử lý tình huống sư phạm mầm non thực chiến:\n"
            f"- Tình huống: {situation}\n"
            f"- Chi tiết bổ sung: {details or 'Tình huống thường nhật tại lớp học mầm non'}\n"
            f"- Nhóm tuổi: {age}\n\n"
            f"YÊU CẦU NỘI DUNG:\n"
            f"1. Hiểu đúng tâm lý của trẻ ở giai đoạn này (nguyên nhân sâu xa).\n"
            f"2. Các bước xử lý ngay tại chỗ (bước 1, bước 2, bước 3) với hành động và lời nói cụ thể của cô.\n"
            f"3. Điều TUYỆT ĐỐI KHÔNG LÀM (tránh đòn roi, dọa nạt, cô lập trẻ).\n"
            f"4. Cách trao đổi xoa dịu phụ huynh nếu có liên quan."
        )
        try:
            return ask_ai_fn(profile, key, [{'role': 'user', 'content': prompt}])
        except Exception:
            pass

    # High-quality situational coaching
    return (
        f"# HƯỚNG DẪN XỬ LÝ SƯ PHẠM: {situation.upper()}\n"
        f"*(Dành cho giáo viên nhóm lớp: {age})*\n\n"
        f"## 1. Thấu hiểu tâm lý trẻ\n"
        f"- Ở lứa tuổi này, trẻ đang trong giai đoạn phát triển nhận thức và cảm xúc mạnh mẽ nhưng ngôn ngữ biểu đạt chưa theo kịp cảm xúc.\n"
        f"- Mọi hành vi (khóc lóc, giành đồ, cắn bạn, nôn trớ) đều là tín hiệu trẻ đang cảm thấy bất an, muốn gây sự chú ý hoặc chưa biết cách giải quyết nhu cầu cá nhân.\n\n"
        f"## 2. Quy trình xử lý tại chỗ 3 bước chuẩn sư phạm\n"
        f"- **Bước 1: Tiếp cận ngang tầm mắt & Tạo sự an toàn (De-escalation):**\n"
        f"  + Ngồi xuống ngang tầm mắt trẻ, dùng ánh mắt ấm áp, đặt tay nhẹ lên vai hoặc ôm nhẹ trẻ vào lòng.\n"
        f"  + Giữ giọng nói bình tĩnh, trầm ấm: *\"Cô ở đây với con rồi, con cảm thấy thế nào, kể cho cô nghe nào.\"*\n"
        f"- **Bước 2: Gọi tên cảm xúc của trẻ (Emotion Labeling):**\n"
        f"  + Giúp trẻ gọi đúng cảm xúc: *\"Con đang thấy buồn vì nhớ mẹ đúng không?\"* hoặc *\"Con đang rất thích món đồ chơi đó phải không nào?\"*.\n"
        f"  + Khi được thấu hiểu, hệ thần kinh của trẻ sẽ nhanh chóng hạ nhiệt và lắng dịu cơn khóc.\n"
        f"- **Bước 3: Chuyển hướng chú ý & Cung cấp giải pháp thay thế:**\n"
        f"  + Mời trẻ tham gia một nhiệm vụ đặc biệt (làm \"trợ lý nhỏ\" giúp cô phát thìa, cho cá ăn, mở hộp quà bí mật).\n"
        f"  + Hướng dẫn trẻ dùng lời nói: *\"Lần sau muốn chơi, con hãy nói: Bạn cho mình mượn nhé!\"*.\n\n"
        f"## 3. Những điều TUYỆT ĐỐI TRÁNH\n"
        f"- ❌ Tuyệt đối không quát mắng, dọa dẫm (\"Cô nhốt vào phòng tối\", \"Bác bảo vệ bắt\").\n"
        f"- ❌ Không so sánh trẻ với các bạn khác (\"Nhìn bạn A ngoan thế kia kìa\").\n"
        f"- ❌ Không cô lập trẻ hoặc bỏ mặc trẻ khóc một mình trong góc khuất.\n\n"
        f"## 4. Kịch bản trao đổi chân tình cùng phụ huynh cuối ngày\n"
        f"- Chủ động gặp gỡ phụ huynh với nụ cười nhẹ nhàng, khen ngợi những điểm con làm tốt trong ngày trước.\n"
        f"- Giải thích nhẹ nhàng tình huống với tinh thần đồng hành: *\"Sáng nay con có chút lưu luyến mẹ, nhưng sau đó cô cháu mình cùng chơi trò chơi này con vui ngay ạ. Bố mẹ ở nhà tiếp tục động viên con giúp cô nhé!\"*."
    )
