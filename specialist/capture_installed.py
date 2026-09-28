"""Capture the installed reference app, without modifying its files or configuration."""
from pathlib import Path
import ctypes
import os
import subprocess
import time
import win32gui
import win32con
from PIL import ImageGrab

ctypes.windll.user32.SetProcessDPIAware()
target = Path(os.environ['LOCALAPPDATA']) / 'Programs/TroLyQTTH/app/TroLy.exe'
out = Path(__file__).parent / 'reference'
out.mkdir(exist_ok=True)
subprocess.Popen([str(target)], cwd=target.parent)
deadline = time.monotonic() + 15
found = []
while time.monotonic() < deadline:
    found.clear()
    win32gui.EnumWindows(lambda h, _: found.append(h) if win32gui.IsWindowVisible(h) and 'Trợ lý' in win32gui.GetWindowText(h) else None, None)
    if found:
        break
    time.sleep(.25)
time.sleep(2)
for index, hwnd in enumerate(found):
    try:
        win32gui.SetWindowPos(hwnd, win32con.HWND_TOPMOST, 0, 0, 0, 0, win32con.SWP_NOMOVE | win32con.SWP_NOSIZE)
        time.sleep(.4)
        rect = win32gui.GetWindowRect(hwnd)
        ImageGrab.grab(bbox=rect).save(out / f'installed-{index}.png')
        print('Captured:', win32gui.GetWindowText(hwnd))
        win32gui.SetWindowPos(hwnd, win32con.HWND_NOTOPMOST, 0, 0, 0, 0, win32con.SWP_NOMOVE | win32con.SWP_NOSIZE)
    except Exception as exc:
        print(type(exc).__name__)
if not found:
    raise RuntimeError('No installed reference window appeared within 15 seconds')
