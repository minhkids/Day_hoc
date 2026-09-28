"""Exercise WPF send -> async response -> save with a mock provider, no network."""
import json
import os
from pathlib import Path
import sys
import tempfile
from unittest.mock import patch
import desktop

root=Path(__file__).resolve().parents[1]
report=root/'reports/preschool/ai-ui';report.mkdir(parents=True,exist_ok=True)
host=root/'preschool/wpf/host.ps1';host.write_text(host.read_text(encoding='utf-8-sig').lstrip('\ufeff'),encoding='utf-8-sig')
class Response:
    status_code=200
    def json(self): return {'choices':[{'message':{'content':'# Khám phá màu sắc\n\nMục tiêu: Trẻ quan sát và gọi tên màu quen thuộc.\n\nChuẩn bị: Thẻ màu và đồ vật trong lớp.\n\nTổ chức: Cùng trẻ tìm đồ vật theo màu.\n\nQuan sát: Giáo viên ghi nhận sau hoạt động.'}}]}
calls=[]
def post(url,**kwargs):
    calls.append(dict(url=url,model=kwargs['json']['model'],preschool_context='Giáo viên Mầm non' in kwargs['json']['messages'][0]['content']))
    return Response()
with tempfile.TemporaryDirectory(prefix='preschool-ai-ui-') as tmp:
    os.environ['TROLY_PRESCHOOL_DATA_DIR']=tmp
    bridge=desktop.Bridge(tmp);bridge.dispatch('settings',dict(profile=dict(model='mock/preschool'),key='mock-key-not-real'))
    sys.argv=[str(root/'preschool/desktop.py'),'--smoke','--smoke-ai','--screenshots',str(report)]
    with patch.object(desktop.core.requests,'post',post): code=desktop.launch()
    path=Path(tmp)/'wpf-smoke.json'
    if not path.exists():
        for p in Path(tmp).glob('*error*'): print(p.read_text(encoding='utf-8-sig').encode('ascii','backslashreplace').decode())
        raise SystemExit(code or 1)
    result=json.loads(path.read_text(encoding='utf-8-sig'));result['mock_calls']=calls
    (report/'result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    assert code==0 and not result['errors'],result
    assert len(calls)==1 and calls[0]['preschool_context']
    docs=bridge.dispatch('state',{})['document']
    assert any('Thẻ màu' in d['body'] for d in docs)
    print('PASS: WPF Send -> async provider mock -> answer -> editor -> saved document. Real OpenRouter not called.')
