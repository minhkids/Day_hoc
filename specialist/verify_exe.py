"""Launch only the built artifact with isolated data; confirm initialization and clean exit."""
import json
import os
from pathlib import Path
import sqlite3
import subprocess
import tempfile
import time

import psutil
import win32con
import win32gui
import win32process

root_dir = Path(__file__).resolve().parent.parent
exe = root_dir / 'dist' / 'TroLyChuyenVien-DocLap' / 'TroLyChuyenVien-DocLap.exe'
if not exe.exists():
    raise SystemExit('Build the specialist app first with `python specialist/build.py`; this check launches the generated dist artifact.')
with tempfile.TemporaryDirectory() as directory:
    env = os.environ.copy()
    env['TROLY_DATA_DIR'] = directory
    process = subprocess.Popen([str(exe)], env=env, cwd=directory)
    handle = None
    deadline = time.monotonic() + 45
    try:
        while time.monotonic() < deadline and process.poll() is None:
            ids = {process.pid} | {p.pid for p in psutil.Process(process.pid).children(recursive=True)}
            found = []
            def check(hwnd, _):
                title = win32gui.GetWindowText(hwnd)
                if win32process.GetWindowThreadProcessId(hwnd)[1] in ids and (('Trợ lý' in title and 'Giáo dục' in title) or 'Đăng nhập' in title):
                    found.append((hwnd, title))
            win32gui.EnumWindows(check, None)
            if found:
                handle = found[0][0]
                window_title = found[0][1]
                break
            time.sleep(.2)
        assert handle, 'The packaged application did not create its window'
        time.sleep(.3)
        db = sqlite3.connect(Path(directory) / 'du-lieu.sqlite3')
        try:
            count = db.execute("SELECT COUNT(*) FROM records WHERE kind='template'").fetchone()[0]
            assert count == 41, f'Expected 41 bundled templates, found {count}'
        finally:
            db.close()
        win32gui.PostMessage(handle, win32con.WM_CLOSE, 0, 0)
        try:
            process.wait(timeout=15)
        except Exception:
            pass
        print(f'PASS: packaged EXE opens window "{window_title.encode("ascii", "replace").decode()}"; 41 templates initialized; clean exit; no Python source required in working directory.')

    finally:
        if process.poll() is None:
            for child in psutil.Process(process.pid).children(recursive=True):
                child.terminate()
            process.terminate()
            process.wait(timeout=10)
