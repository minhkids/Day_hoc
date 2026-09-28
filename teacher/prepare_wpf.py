"""Extract declarative teacher presentation only, not installed application logic."""
from pathlib import Path
import shutil
root=Path(__file__).resolve().parent
installed=Path.home()/'AppData/Local/Programs/TroLyGV/app'
source=(installed/'TroLy.ps1').read_text(encoding='utf-8-sig')
start=source.index('$ICON_BIEUDO =')
end=source.index('try {\n    [xml]$xaml = $xamlText')
folder=root/'wpf'; folder.mkdir(exist_ok=True)
script=source[start:end]+'''\n[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'layout.xaml'), $xamlText, (New-Object Text.UTF8Encoding($false)))
'''
(folder/'generate_layout.ps1').write_text(script,encoding='utf-8-sig')
for name in ('logo.png','icon.ico'):shutil.copy2(installed/name,folder/name)
print('Teacher declarative layout prepared.')
