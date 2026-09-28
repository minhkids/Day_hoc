"""Install the shared workspace toolbar into source and packaged WPF hosts."""
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]
LINE = ". (Join-Path $PSScriptRoot 'school-link.ps1')"

def main():
    for source, package in [('teacher','TroLyGiaoVien-DocLap'),('school','TroLyQuanTriTruongHoc-DocLap'),('specialist','TroLyChuyenVien-DocLap')]:
        for folder in [ROOT/source/'wpf', ROOT/'dist'/package/'_internal'/'wpf']:
            host = folder/'host.ps1'
            if not host.exists():
                raise FileNotFoundError(host)
            content = host.read_text(encoding='utf-8-sig')
            if LINE not in content:
                anchor = '[void]$window.ShowDialog()'
                if anchor not in content:
                    raise ValueError('Missing WPF anchor: '+str(host))
                content=content.replace(anchor, LINE+'\n'+anchor)
                host.write_text(content,encoding='utf-8-sig')
            (folder/'school-link.ps1').write_text((ROOT/'collaboration_server/school-link.ps1').read_text(encoding='utf-8'),encoding='utf-8-sig')
        build=ROOT/source/'build.py'
        content=build.read_text(encoding='utf-8')
        if 'school-link.ps1' not in content:
            # Ensure future EXE rebuilds retain the integration.
            anchor="'--add-data',"
            position=content.index(anchor)
            content=content[:position]+"'--add-data', str(Path(__file__).resolve().parent / 'wpf' / 'school-link.ps1') + ';wpf',\n "+content[position:]
            build.write_text(content,encoding='utf-8')
    print('Integrated source and all three dist applications.')

if __name__=='__main__': main()
