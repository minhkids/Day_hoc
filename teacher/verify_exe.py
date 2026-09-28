"""Smoke-test the built teacher EXE with a temporary data directory."""
import os
from pathlib import Path
import subprocess
import tempfile
import time
import psutil
import win32gui
import win32process
import win32con
import ctypes
import win32ui
from PIL import Image

root=Path(__file__).resolve().parents[1]
exe=root/'exe'/'TroLyGiaoVien-DocLap'/'TroLyGiaoVien-DocLap.exe'
if not exe.exists():
    exe=root/'dist'/'TroLyGiaoVien-DocLap'/'TroLyGiaoVien-DocLap.exe'
with tempfile.TemporaryDirectory() as data:
    env=os.environ.copy(); env['TROLY_TEACHER_DATA_DIR']=data
    process=subprocess.Popen([str(exe)],cwd=data,env=env)
    try:
        found=[]; deadline=time.monotonic()+30
        def visit(hwnd,_):
            ids={process.pid}|{p.pid for p in psutil.Process(process.pid).children(recursive=True)}
            if win32process.GetWindowThreadProcessId(hwnd)[1] in ids and win32gui.GetWindowText(hwnd).startswith('Trợ lý Giáo viên'):
                found.append(hwnd)
        while not found and time.monotonic()<deadline:
            win32gui.EnumWindows(visit,None); time.sleep(.2)
        assert found,'Teacher EXE did not open its window'
        time.sleep(1)
        folder=root/'reports'/'teacher'; folder.mkdir(exist_ok=True,parents=True)
        hwnd=found[0]
        left,top,right,bottom=win32gui.GetWindowRect(hwnd)
        width,height=right-left,bottom-top
        dc=win32gui.GetWindowDC(hwnd); source=win32ui.CreateDCFromHandle(dc); memory=source.CreateCompatibleDC()
        bitmap=win32ui.CreateBitmap(); bitmap.CreateCompatibleBitmap(source,width,height); memory.SelectObject(bitmap)
        try:
            assert ctypes.windll.user32.PrintWindow(hwnd,memory.GetSafeHdc(),2),'Window capture failed'
            Image.frombuffer('RGB',(width,height),bitmap.GetBitmapBits(True),'raw','BGRX',0,1).save(folder/'exe-home.png')
        finally:
            win32gui.DeleteObject(bitmap.GetHandle()); memory.DeleteDC(); source.DeleteDC(); win32gui.ReleaseDC(hwnd,dc)
        assert (Path(data)/'du-lieu.sqlite3').exists()
        win32gui.PostMessage(found[0],win32con.WM_CLOSE,0,0)
        assert process.wait(timeout=10)==0
        print('PASS: packaged teacher EXE opens a native window, initializes isolated data, closes cleanly; screenshot reports/teacher/exe-home.png')
    finally:
        if process.poll() is None:
            for child in psutil.Process(process.pid).children(recursive=True):child.terminate()
            process.terminate();process.wait(timeout=10)
