"""Launch source or packaged WPF, exercise navigation and actual form buttons."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

root=Path(__file__).resolve().parents[1]
packaged='--exe' in sys.argv
target=root/'exe/TroLyGiaoVienMamNon/TroLyGiaoVienMamNon.exe'
report=root/'reports/preschool'/('packaged' if packaged else 'source')
report.mkdir(parents=True,exist_ok=True)
host=root/'preschool/wpf/host.ps1'
host.write_text(host.read_text(encoding='utf-8-sig').lstrip('\ufeff'),encoding='utf-8-sig')
with tempfile.TemporaryDirectory(prefix='preschool-smoke-') as tmp:
    env=os.environ.copy();env['TROLY_PRESCHOOL_DATA_DIR']=tmp
    cmd=[str(target)] if packaged else [sys.executable,str(root/'preschool/desktop.py')]
    r=subprocess.run(cmd+['--smoke','--screenshots',str(report)],env=env,capture_output=True,timeout=100)
    result=Path(tmp)/'wpf-smoke.json'
    if result.exists():
        data=json.loads(result.read_text(encoding='utf-8-sig'))
        (report/'result.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
        print(json.dumps(data,ensure_ascii=True))
    else: data={}
    if r.returncode or not result.exists() or data.get('errors'):
        for p in Path(tmp).glob('*error*'): print(p.read_text(encoding='utf-8-sig').encode('ascii','backslashreplace').decode())
        print(r.stdout.decode('utf-8',errors='replace').encode('ascii','backslashreplace').decode())
        print(r.stderr.decode('utf-8',errors='replace').encode('ascii','backslashreplace').decode())
        raise SystemExit(r.returncode or 1)
    assert len(data['pages'])==14
    print('PASS: 14 pages, form create/edit/save, children profile, ward address conversion, legal circulars, Office and journal exports, clean exit.')
