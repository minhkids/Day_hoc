import sys,os,threading,subprocess
from pathlib import Path
root=Path.cwd();sys.path.insert(0,str(root/'school'));import desktop
out=root/'reports/exe-audit/school';bridge=desktop.Bridge(out/'source-data');s=desktop.shared.create_server(bridge,'audit-local');threading.Thread(target=s.serve_forever,daemon=True).start()
env=os.environ.copy();env.update(TROLY_BRIDGE_URL=f'http://127.0.0.1:{s.server_port}',TROLY_BRIDGE_TOKEN='audit-local',TROLY_SCHOOL_DATA_DIR=str(out/'data'))
p=subprocess.run(['powershell','-NoProfile','-STA','-ExecutionPolicy','Bypass','-File',str(root/'reports/exe-audit/instrumented-school/_internal/wpf/host.ps1')],env=env,capture_output=True,timeout=40)
(out/'harness-stdout.log').write_bytes(p.stdout);(out/'harness-stderr.log').write_bytes(p.stderr);print(p.returncode);print(p.stderr.decode(errors='replace').encode('ascii','backslashreplace').decode()[:4000]);s.shutdown()
