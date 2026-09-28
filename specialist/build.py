"""Build a portable Windows application directory, without replacing the reference installer.

The one-file bootloader cannot extract under some managed Windows profiles, so the
release uses PyInstaller's one-directory layout. It runs without a Python install
and avoids the ``Failed to create parent directory structure`` startup error.
"""
from pathlib import Path
import subprocess
import sys
import os

root = Path(__file__).resolve().parent
dist_path = Path(os.environ.get('TROLY_DIST_DIR', root.parent / 'exe')).resolve()
for script in (root / 'wpf').glob('*.ps1'):
    raw = script.read_bytes()
    while raw.startswith(b'\xef\xbb\xbf'): raw = raw[3:]
    text = raw.decode('utf-8', errors='replace').lstrip('\ufeff')
    script.write_bytes(b'\xef\xbb\xbf' + text.encode('utf-8'))
environment = os.environ.copy()
environment['PYINSTALLER_CONFIG_DIR'] = str(root.parent / 'build' / 'pyinstaller-cache')
subprocess.run([
    sys.executable, '-m', 'PyInstaller', '--noconfirm', '--clean', '--onedir', '--windowed',
    '--name', 'TroLyChuyenVien-DocLap', '--distpath', str(dist_path),
    '--workpath', str(root.parent / 'build' / 'specialist'), '--specpath', str(root),
    '--paths', str(root), '--paths', str(root.parent),
    '--hidden-import', 'updater',
    '--exclude-module', 'pandas', '--exclude-module', 'numpy', '--exclude-module', 'scipy',

    '--exclude-module', 'matplotlib', '--exclude-module', 'IPython', '--exclude-module', 'pytest',
    '--add-data', str(Path(__file__).resolve().parent / 'wpf' / 'school-link.ps1') + ';wpf',
 '--add-data', str(root.parent / 'app' / 'templates' / 'chuyen_vien') + ';reference-templates',
    '--add-data', str(root / 'wpf' / 'host.ps1') + ';wpf',
    '--add-data', str(root.parent / 'scripts' / 'verify-ai.ps1') + ';wpf',
    '--add-data', str(root / 'wpf' / 'layout.xaml') + ';wpf',
    '--add-data', str(root / 'wpf' / 'logo.png') + ';wpf',
    '--add-data', str(root / 'wpf' / 'icon.ico') + ';wpf',
    '--icon', str(root / 'wpf' / 'icon.ico'),
    str(root / 'desktop.py')
], cwd=root, env=environment, check=True)
