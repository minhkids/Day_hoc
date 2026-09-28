"""Extract only the supplied reference's declarative presentation assets.

No original authentication, updater, AI execution, or data-management code is used.
"""
from pathlib import Path
import shutil

root = Path(__file__).resolve().parent
source = root.parent / 'archive' / 'extracted_cv' / '$_13_' / 'app' / 'TroLy.ps1'
text = source.read_text(encoding='utf-8-sig')
start = text.index("$ICON_BIEUDO =")
end = text.index('try {\n    [xml]$xaml = $xamlText')
folder = root / 'wpf'
folder.mkdir(exist_ok=True)
script = text[start:end]
script += '''
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'layout.xaml'), $xamlText, (New-Object Text.UTF8Encoding($false)))
$catalog = @{ home=$TheChinh; documents=$LoaiVB; tools=$TienIch; missions=$NvSo; inspections=$KiemTraO; units=$DonViO }
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'catalog.json'), ($catalog | ConvertTo-Json -Depth 12), (New-Object Text.UTF8Encoding($false)))
'''
(folder / 'generate_layout.ps1').write_text(script, encoding='utf-8-sig')
installed = Path.home() / 'AppData/Local/Programs/TroLyQTTH/app'
for name in ('logo.png', 'icon.ico'):
    if (installed / name).exists():
        shutil.copy2(installed / name, folder / name)
print('Prepared WPF presentation generator and reference image assets.')
