import os, subprocess, json, time
from pathlib import Path
root=Path.cwd(); out=root/'reports/exe-audit'
apps=[('teacher','TroLyGiaoVien-DocLap','TROLY_TEACHER_DATA_DIR','--screenshots'),('specialist','TroLyChuyenVien-DocLap','TROLY_DATA_DIR','--screenshot-dir'),('school','TroLyQuanTriTruongHoc-DocLap','TROLY_SCHOOL_DATA_DIR','--screenshots')]
results=[]
for name,folder,key,flag in apps:
    data=out/name/'data';data.mkdir(parents=True,exist_ok=True)
    env=os.environ.copy();env[key]=str(data)
    exe=root/'exe'/folder/(folder+'.exe')
    start=time.time()
    with (out/name/'stdout.log').open('w',encoding='utf-8') as stdout, (out/name/'stderr.log').open('w',encoding='utf-8') as stderr:
        p=subprocess.Popen([str(exe),'--smoke',flag,str(out/name/'screenshots')],env=env,stdout=stdout,stderr=stderr)
        try: code=p.wait(timeout=55)
        except subprocess.TimeoutExpired:
            subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],capture_output=True);code='timeout'
    report={'app':name,'exit':code,'seconds':round(time.time()-start,1),'reports':[str(x.relative_to(out)) for x in data.rglob('*') if x.is_file()]}
    results.append(report);print(json.dumps(report),flush=True)
(out/'launch-results.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
