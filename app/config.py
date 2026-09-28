import os
import json

CONFIG_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "profile.json")

DEFAULT_PROFILE = {
    "school_name": "TRƯỜNG THCS LÊ QUÝ ĐÔN",
    "district": "Quận Hải Châu",
    "province": "TP Đà Nẵng",
    "full_name": "Nguyễn Văn An",
    "role": "Giáo viên",
    "level": "THCS",
    "subject": "Toán học",
    "classes": "Lớp 7A1, 7A2",
    "api_key": "",
    "ai_provider": "Gemini"
}

def load_profile():
    """Tải hồ sơ người dùng từ file JSON"""
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
                profile = DEFAULT_PROFILE.copy()
                profile.update(data)
                return profile
        except Exception as e:
            print(f"Lỗi khi đọc profile: {e}")
    return DEFAULT_PROFILE.copy()

def save_profile(profile_data):
    """Lưu hồ sơ người dùng vào file JSON"""
    try:
        with open(CONFIG_FILE, "w", encoding="utf-8") as f:
            json.dump(profile_data, f, ensure_ascii=False, indent=2)
        return True
    except Exception as e:
        print(f"Lỗi khi lưu profile: {e}")
        return False
