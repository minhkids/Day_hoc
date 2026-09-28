"""Build standalone Windows distribution for School Administration Assistant (TroLyQuanTriTruongHoc-DocLap).
Runs independently through OpenRouter without external CLI tools.
Uses PyInstaller one-dir windowed distribution with WPF front-end and Python bridge.
"""
from pathlib import Path
import subprocess
import sys
import os

root = Path(__file__).resolve().parent
dist_path = Path(os.environ.get('TROLY_DIST_DIR', root.parent / 'exe')).resolve()

# Ensure all ps1 files have UTF-8-SIG encoding
for script in (root / 'wpf').glob('*.ps1'):
    raw = script.read_bytes()
    while raw.startswith(b'\xef\xbb\xbf'): raw = raw[3:]
    text = raw.decode('utf-8', errors='replace').lstrip('\ufeff')
    script.write_bytes(b'\xef\xbb\xbf' + text.encode('utf-8'))

environment = os.environ.copy()
environment['PYINSTALLER_CONFIG_DIR'] = str(root.parent / 'build' / 'pyinstaller-cache')

cmd = [
    sys.executable, '-m', 'PyInstaller', '--noconfirm', '--clean', '--onedir', '--windowed',
    '--name', 'TroLyQuanTriTruongHoc-DocLap',
    '--distpath', str(dist_path),
    '--workpath', str(root.parent / 'build' / 'school'),
    '--specpath', str(root),
    '--paths', str(root.parent / 'specialist'),
    '--paths', str(root.parent),
    '--hidden-import', 'updater',
    '--exclude-module', 'pandas',

    '--exclude-module', 'numpy',
    '--exclude-module', 'scipy',
    '--exclude-module', 'matplotlib',
    '--exclude-module', 'IPython',
    '--exclude-module', 'pytest',
    '--add-data', str(Path(__file__).resolve().parent / 'wpf' / 'school-link.ps1') + ';wpf',
 '--add-data', str(root.parent / 'app' / 'templates' / 'hieu_truong') + ';templates/hieu_truong',
    '--add-data', str(root / 'wpf' / 'host.ps1') + ';wpf',
    '--add-data', str(root.parent / 'scripts' / 'verify-ai.ps1') + ';wpf',
    '--add-data', str(root / 'wpf' / 'layout.xaml') + ';wpf',
    '--add-data', str(root / 'wpf' / 'logo.png') + ';wpf',
    '--add-data', str(root / 'wpf' / 'icon.ico') + ';wpf',
    '--add-data', str(root / 'wpf' / 'missions.json') + ';wpf',
    '--icon', str(root / 'wpf' / 'icon.ico'),
    str(root / 'desktop.py')
]

print("Executing PyInstaller build...")
subprocess.run(cmd, cwd=root, env=environment, check=True)
print("Build completed successfully!")
