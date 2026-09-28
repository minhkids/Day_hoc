"""Package the teacher app separately; never include .env or user data."""
from pathlib import Path
import os
import subprocess
import sys
import shutil
from clean_layout import clean_layout
clean_layout()
root=Path(__file__).resolve().parents[1]
dist_path=Path(os.environ.get('TROLY_DIST_DIR', root/'exe')).resolve()
env=os.environ.copy()
env['PYINSTALLER_CONFIG_DIR']=str(root/'build'/'teacher-cache')
shared=root/'build'/'teacher-shared'
shared.mkdir(parents=True,exist_ok=True)
shutil.copy2(root/'specialist/desktop.py',shared/'shared_bridge.py')
shutil.copy2(root/'specialist/updater.py',shared/'updater.py')
for script in (root / 'teacher' / 'wpf').glob('*.ps1'):
    raw = script.read_bytes()
    while raw.startswith(b'\xef\xbb\xbf'): raw = raw[3:]
    text = raw.decode('utf-8', errors='replace').lstrip('\ufeff')
    script.write_bytes(b'\xef\xbb\xbf' + text.encode('utf-8'))
subprocess.run([sys.executable,'-m','PyInstaller','--noconfirm','--clean','--onedir','--windowed',
 '--name','TroLyGiaoVien-DocLap','--distpath',str(dist_path),'--workpath',str(root/'build'/'teacher'),
 '--specpath',str(root/'teacher'),'--paths',str(root/'specialist'),'--paths',str(shared),
 '--hidden-import','shared_bridge','--hidden-import','updater',

 '--add-data', str(Path(__file__).resolve().parent / 'wpf' / 'school-link.ps1') + ';wpf',
 '--add-data',str(root/'teacher/wpf/layout.xaml')+';wpf',
 '--add-data',str(root/'teacher/wpf/host.ps1')+';wpf',
 '--add-data',str(root/'scripts/verify-ai.ps1')+';wpf',
 '--add-data',str(root/'teacher/wpf/logo.png')+';wpf',
 '--add-data',str(root/'teacher/wpf/icon.ico')+';wpf',
 '--icon',str(root/'teacher/wpf/icon.ico'),
 '--add-data',str(root/'app'/'templates'/'giao_vien')+';templates/giao_vien',
 '--add-data',str(root/'app'/'mini_apps')+';mini_apps',
 '--exclude-module','numpy','--exclude-module','pandas','--exclude-module','matplotlib',
 str(root/'teacher'/'desktop.py')],env=env,check=True,cwd=root)
