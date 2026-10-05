"""Build the new preschool installer without changing other apps or publishing."""
import importlib.util
from pathlib import Path
import shutil
import subprocess
import zipfile

root=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('release_tools',root/'installer/build_release.py')
release=importlib.util.module_from_spec(spec);spec.loader.exec_module(release)
release.VERSION='1.0.6'
release.RELEASE=root/'releases/preschool-1.0.6'
release.INSTALLERS=release.RELEASE/'installers'
release.INSTALLERS.mkdir(parents=True,exist_ok=True)
app=dict(id='preschool',title='Trợ lý Giáo viên Mầm non',folder='TroLyGiaoVienMamNon',
         binary='TroLyGiaoVienMamNon/TroLyGiaoVienMamNon.exe',registry='TroLyGiaoVienMamNon',
         setup='TroLyGiaoVienMamNon-Setup.exe',logo=root/'preschool/wpf/logo.png',icon=root/'preschool/wpf/icon.ico')
archive=release.RELEASE/'preschool-payload.zip'
source=root/'exe/TroLyGiaoVienMamNon'
if not (source/'TroLyGiaoVienMamNon.exe').is_file(): raise FileNotFoundError('Run preschool/build.py first')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
    for path in sorted(source.rglob('*')):
        if path.is_file(): z.write(path,Path(source.name)/path.relative_to(source))
output=release.compile_installer(app,archive)
subprocess.run([str(output),'--self-check'],check=True,timeout=90)
destination=root/'exe'/app['setup'];shutil.copy2(output,destination)
print('Created:',destination)
