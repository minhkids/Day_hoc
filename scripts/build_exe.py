"""
SCRIPT ĐÓNG GÓI ỨNG DỤNG THÀNH TỆP TIN THỰC THI (.EXE) WINDOWS
Sử dụng PyInstaller để đóng gói toàn bộ mã nguồn thành 1 file độc lập.
Bao gồm đầy đủ:
- Bộ mã nguồn 3 vai trò (Giáo viên, Hiệu trưởng, Chuyên viên)
- Xưởng phần mềm (6 Mini Web Apps)
- Thư viện 126 mẫu văn bản giáo dục chuẩn 2026-2027
- Bộ công cụ xuất Word, PowerPoint, Excel
"""

from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[1]
os.chdir(PROJECT_ROOT)

import os
import sys
import subprocess

def build():
    print("==================================================")
    print("🚀 BẮT ĐẦU ĐÓNG GÓI ỨNG DỤNG TRỢ LÝ AI GIÁO DỤC (.EXE)")
    print("==================================================")

    # 1. Kiểm tra PyInstaller
    try:
        import PyInstaller
        print("✓ Đã tìm thấy PyInstaller.")
    except ImportError:
        print("! Đang tự động cài đặt PyInstaller qua pip...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pyinstaller"])

    # 2. Cấu hình tham số PyInstaller
    app_main = os.path.join(os.getcwd(), "app", "main.py")
    dist_dir = os.path.join(os.getcwd(), "dist")
    build_dir = os.path.join(os.getcwd(), "build")
    
    cmd = [
        "pyinstaller",
        "--name=TroLyAI-GiaoDuc-Setup",
        "--noconsole",         # Ẩn cửa sổ dòng lệnh đen, chỉ hiện GUI
        "--onefile",           # Đóng gói thành 1 file .exe duy nhất
        f"--distpath={dist_dir}",
        f"--workpath={build_dir}",
        f"--add-data=app/config.py;.",
        f"--add-data=app/prompts.py;.",
        f"--add-data=app/ai_engine.py;.",
        f"--add-data=app/exporters;exporters",
        f"--add-data=app/mini_apps;mini_apps",
        f"--add-data=app/templates;templates",
        app_main
    ]

    print(f"Đang thực thi: {' '.join(cmd)}")
    result = subprocess.run(cmd)

    if result.returncode == 0:
        exe_path = os.path.join(dist_dir, "TroLyAI-GiaoDuc-Setup.exe")
        print("\n==================================================")
        print("🎉 ĐÓNG GÓI THÀNH CÔNG!")
        print(f"📁 Tệp thực thi .EXE được tạo tại: {exe_path}")
        print("Thầy cô và cán bộ có thể sao chép file này sang bất kỳ máy tính Windows nào để sử dụng.")
        print("==================================================")
    else:
        print("\n❌ Quá trình đóng gói gặp lỗi. Vui lòng kiểm tra lại log chi tiết phía trên.")

if __name__ == "__main__":
    build()
