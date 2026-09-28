"""Package a separate preschool executable with only its own UI and resources."""
from pathlib import Path
import os
import subprocess
import sys

root=Path(__file__).resolve().parents[1]
app=root/'preschool'
for path in (app/'wpf').glob('*.ps1'):
    path.write_text(path.read_text(encoding='utf-8-sig').lstrip('\ufeff'),encoding='utf-8-sig')
env=os.environ.copy();env['PYINSTALLER_CONFIG_DIR']=str(root/'build/preschool-cache')
subprocess.run([sys.executable,'-m','PyInstaller','--noconfirm','--clean','--onedir','--windowed',
 '--name','TroLyGiaoVienMamNon','--distpath',os.environ.get('TROLY_DIST_DIR',str(root/'exe')),
 '--workpath',str(root/'build/preschool'),'--specpath',str(app),'--paths',str(root/'specialist'),'--paths',str(app),
 '--add-data',str(app/'wpf')+';wpf','--add-data',str(app/'games')+';games',
 '--hidden-import','updater',
 '--icon',str(app/'wpf/icon.ico'),'--exclude-module','numpy','--exclude-module','pandas','--exclude-module','matplotlib',
 str(app/'desktop.py')],env=env,cwd=root,check=True)

import shutil
dist_app = Path(os.environ.get('TROLY_DIST_DIR', str(root / 'exe'))) / 'TroLyGiaoVienMamNon'
if dist_app.is_dir():
    shutil.copy2(app / 'wpf/icon.ico', dist_app / 'icon.ico')
    (dist_app / 'wpf').mkdir(parents=True, exist_ok=True)
    shutil.copy2(app / 'wpf/icon.ico', dist_app / 'wpf/icon.ico')

