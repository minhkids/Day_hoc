import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

root=Path(__file__).resolve().parents[1]
host=root/'teacher/wpf/host.ps1'
host.write_text(host.read_text(encoding='utf-8-sig'),encoding='utf-8-sig')
with tempfile.TemporaryDirectory() as data:
    env=os.environ.copy();env['TROLY_TEACHER_DATA_DIR']=data
    result=subprocess.run([sys.executable,str(root/'teacher/desktop.py'),'--smoke','--screenshots',str(root/'reports/teacher/wpf')],env=env,timeout=70,capture_output=True)
    if result.returncode:
        print('EXIT',result.returncode)
        for error in Path(data).glob('*error*'):
            print(error.read_text(encoding='utf-8-sig').encode('ascii','backslashreplace').decode())
        print(result.stdout.decode('utf-8',errors='replace').encode('ascii','backslashreplace').decode())
        print(result.stderr.decode('utf-8',errors='replace').encode('ascii','backslashreplace').decode())
        raise RuntimeError('WPF failed')
    report=json.loads((Path(data)/'wpf-smoke.json').read_text(encoding='utf-8-sig'))
    assert not report['errors'],report['errors']
    assert len(report['pages'])==16
    print('PASS: 16 reference-layout WPF pages, real task button, no dispatcher errors; screenshots reports/teacher/wpf')
