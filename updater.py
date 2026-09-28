"""
MODULE TỰ ĐỘNG CẬP NHẬT TỪ XA CHO ỨNG DỤNG WINDOWS DESKTOP (AUTO-UPDATER)
- Tương thích Python 3.10+, PyInstaller standalone và Windows 10/11.
- Không phụ thuộc thư viện ngoài (sử dụng urllib, ctypes, subprocess, json, tempfile).
- Hỗ trợ chạy ngầm khi khởi động hoặc kiểm tra thủ công từ menu/giao diện.
"""

import os
import sys
import json
import time
import ctypes
import tempfile
import threading
import subprocess
import urllib.request
from pathlib import Path
from typing import Optional, Tuple

# Hằng số Windows API MessageBox
MB_OK = 0x00000000
MB_YESNO = 0x00000004
MB_ICONINFORMATION = 0x00000040
MB_ICONWARNING = 0x00000030
MB_SYSTEMMODAL = 0x00001000
IDYES = 6


def show_native_message_box(title: str, text: str, style: int = MB_OK | MB_ICONINFORMATION) -> int:
    """Hiển thị hộp thoại thông báo Windows Native chuẩn."""
    try:
        return ctypes.windll.user32.MessageBoxW(0, text, title, style | MB_SYSTEMMODAL)
    except Exception:
        print(f"[{title}] {text}")
        return MB_OK


def parse_version(v_str: str) -> Tuple[int, ...]:
    """Chuyển chuỗi version 'v1.2.3' thành tuple (1, 2, 3) để so sánh chính xác."""
    clean = v_str.strip().lstrip('vV')
    parts = []
    for part in clean.split('.'):
        num = ''
        for ch in part:
            if ch.isdigit():
                num += ch
            else:
                break
        parts.append(int(num) if num else 0)
    return tuple(parts)


def get_default_server_url() -> str:
    """Xác định địa chỉ Server mặc định từ biến môi trường hoặc file .env."""
    url = os.environ.get('TROLY_SERVER_URL') or os.environ.get('TROLY_AUTH_URL') or os.environ.get('BACKEND_URL')
    if url and url.startswith('http'):
        return url.rstrip('/')
    
    # Kiểm tra file .env
    for candidate in (Path.cwd(), Path(__file__).resolve().parent, Path(__file__).resolve().parents[1]):
        env_file = candidate / '.env'
        if env_file.is_file():
            try:
                for line in env_file.read_text(encoding='utf-8').splitlines():
                    line = line.strip()
                    if line.startswith('BACKEND_URL=') or line.startswith('SERVER_URL='):
                        val = line.split('=', 1)[1].strip().strip('"\'')
                        if val.startswith('http'):
                            return val.rstrip('/')
            except Exception:
                pass

    return "http://localhost:8000"


def download_and_install_update(download_url: str, app_title: str, latest_version: str):
    """Tải bộ cài đặt mới về thư mục tạm và tiến hành khởi chạy cập nhật."""
    try:
        # Xác định phần mở rộng file (.exe hoặc .msi)
        filename = download_url.split('?')[0].split('/')[-1]
        if not filename.endswith(('.exe', '.msi')):
            filename = f"CapNhat_{latest_version}.exe"

        temp_path = os.path.join(tempfile.gettempdir(), filename)

        # Tạo request tải
        req = urllib.request.Request(
            download_url,
            headers={'User-Agent': 'TroLyGiaoDuc-AutoUpdater/1.0'}
        )
        with urllib.request.urlopen(req, timeout=60) as response, open(temp_path, 'wb') as out_file:
            block_size = 64 * 1024
            while True:
                buffer = response.read(block_size)
                if not buffer:
                    break
                out_file.write(buffer)

        # Thông báo trước khi đóng ứng dụng
        show_native_message_box(
            f"Cập nhật {app_title}",
            "Đã tải xong bản cập nhật mới thành công!\n\n"
            "Ứng dụng sẽ tự động đóng để khởi chạy bộ cài đặt phiên bản mới.",
            MB_OK | MB_ICONINFORMATION
        )

        # Khởi chạy bộ cài đặt mới
        try:
            # Thử chạy với cờ silent nếu là Inno Setup / NSIS, hoặc chạy trực tiếp
            os.startfile(temp_path)
        except Exception:
            subprocess.Popen([temp_path], shell=True)

        # Thoát ứng dụng hiện tại để tránh xung đột khóa tệp
        time.sleep(1)
        os._exit(0)

    except Exception as ex:
        show_native_message_box(
            f"Lỗi cập nhật {app_title}",
            f"Không thể tải bản cập nhật tự động:\n{str(ex)}\n\n"
            f"Vui lòng tải trực tiếp từ liên kết:\n{download_url}",
            MB_OK | MB_ICONWARNING
        )


def check_for_updates(
    app_id: str,
    current_version: str,
    server_url: Optional[str] = None,
    interactive: bool = False,
    app_title: str = "Trợ lý Giáo dục AI"
) -> dict:
    """
    Kiểm tra phiên bản mới từ server.
    - interactive=False: Chạy ngầm khi mở app, chỉ hiện thông báo nếu có bản mới.
    - interactive=True: Khi người dùng chủ động bấm 'Kiểm tra cập nhật'.
    """
    base_url = (server_url or get_default_server_url()).rstrip('/')
    check_api = f"{base_url}/api/updates/check?app={app_id}&version={current_version}"

    try:
        req = urllib.request.Request(
            check_api,
            headers={'User-Agent': f'TroLyGiaoDuc/{current_version}'}
        )
        with urllib.request.urlopen(req, timeout=6) as response:
            data = json.loads(response.read().decode('utf-8'))
            
            latest_version = data.get('latest_version', current_version)
            download_url = data.get('download_url')
            changelog = data.get('changelog', 'Nâng cấp tính năng và cải thiện hiệu năng.')
            has_update = data.get('has_update', False)

            # Nếu server chưa tính has_update thì tự so sánh version
            if not has_update and parse_version(latest_version) > parse_version(current_version):
                has_update = True

            if has_update and download_url:
                msg = (
                    f"ĐÃ CÓ PHIÊN BẢN MỚI: v{latest_version}\n"
                    f"(Phiên bản hiện tại của bạn: v{current_version})\n\n"
                    f"--- NỘI DUNG NÂNG CẤP ---\n{changelog}\n\n"
                    f"Thầy/Cô có muốn tự động tải về và nâng cấp ngay bây giờ không?"
                )
                choice = show_native_message_box(
                    f"Cập nhật {app_title}",
                    msg,
                    MB_YESNO | MB_ICONINFORMATION
                )
                if choice == IDYES:
                    # Chạy tải và cài đặt trong tiến trình mới
                    threading.Thread(
                        target=download_and_install_update,
                        args=(download_url, app_title, latest_version),
                        daemon=True
                    ).start()
                return {"status": "update_available", "latest_version": latest_version}

            else:
                if interactive:
                    show_native_message_box(
                        f"Cập nhật {app_title}",
                        f"Thầy/Cô đang sử dụng phiên bản mới nhất (v{current_version}).\nKhông có bản cập nhật nào mới hơn.",
                        MB_OK | MB_ICONINFORMATION
                    )
                return {"status": "up_to_date", "current_version": current_version}

    except Exception as e:
        if interactive:
            show_native_message_box(
                f"Cập nhật {app_title}",
                f"Không thể kết nối đến máy chủ kiểm tra cập nhật.\n"
                f"Địa chỉ kiểm tra: {base_url}\n"
                f"Lỗi: {str(e)}\n\nVui lòng kiểm tra lại kết nối mạng Internet.",
                MB_OK | MB_ICONWARNING
            )
        return {"status": "error", "error": str(e)}


def start_background_check(app_id: str, current_version: str, app_title: str, delay_seconds: float = 3.0):
    """Khởi chạy kiểm tra cập nhật trong luồng phụ (không làm chậm tốc độ mở ứng dụng)."""
    def _run():
        if delay_seconds > 0:
            time.sleep(delay_seconds)
        check_for_updates(app_id, current_version, interactive=False, app_title=app_title)

    t = threading.Thread(target=_run, daemon=True)
    t.start()
    return t
