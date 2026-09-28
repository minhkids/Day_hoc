"""Extract school presentation without executing the installed app's service code."""
from pathlib import Path
import re
import shutil
import json
from xml.sax.saxutils import escape

root=Path(__file__).resolve().parent
installed=Path.home()/'AppData/Local/Programs/TroLyQTTH/app'
source=(installed/'TroLy.ps1').read_text(encoding='utf-8-sig')
script=source[source.index('$ICON_BIEUDO ='):source.index('try {\n    [xml]$xaml = $xamlText')]
script=script.replace(". (Join-Path $AppDir 'nhiem-vu.ps1')",'')
script=script.replace("$xamlText = $xamlText.Replace('@@NHIEMVU@@', (XAML-NhiemVu))",'')
folder=root/'wpf';folder.mkdir(parents=True,exist_ok=True)
script+="\n[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'layout.xaml'), $xamlText, (New-Object Text.UTF8Encoding($false)))\n"
(folder/'generate_layout.ps1').write_text(script,encoding='utf-8-sig')
for name in ('logo.png','icon.ico'):shutil.copy2(installed/name,folder/name)

def finish_layout():
    path=folder/'layout.xaml';text=path.read_text(encoding='utf-8-sig')
    catalog=root.parent/'app/templates/hieu_truong/kien-thuc/nhiem-vu/_danh-muc.md'
    tasks=[]
    for line in catalog.read_text(encoding='utf-8-sig').splitlines():
        cells=[c.strip().strip('`') for c in line.strip('|').split('|')]
        if len(cells)>=9 and re.fullmatch(r'(ht|pht|tt)-[a-z-]+',cells[0]):
            tasks.append(dict(id=cells[0],role=cells[1],title=cells[2],description=cells[3],prompt=cells[4],icon=cells[7],color=cells[8]))
    groups=[]
    for role,title in [('HT','NHIỆM VỤ CỦA HIỆU TRƯỞNG'),('PHT','NHIỆM VỤ CỦA PHÓ HIỆU TRƯỞNG'),('TT','NHIỆM VỤ CỦA TỔ TRƯỞNG CHUYÊN MÔN')]:
        cards=[]
        for task in tasks:
            if task['role']!=role:continue
            icon=task['icon'] if re.fullmatch('[0-9A-Fa-f]{4}',task['icon']) else 'E8A5'
            cards.append(f'''<Border x:Name="NvO_{task['id'].replace('-','_')}" Tag="mission:{task['id']}" Style="{{StaticResource OChucNang}}" Background="White" Padding="18,16"><Grid><Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions><Border Width="48" Height="48" CornerRadius="12" Background="{task['color']}" VerticalAlignment="Top"><TextBlock Text="&#x{icon};" FontFamily="Segoe MDL2 Assets" FontSize="22" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><StackPanel Grid.Column="1" Margin="14,0,0,0"><TextBlock Text="{escape(task['title'], {chr(34):'&quot;'})}" FontSize="15.5" FontWeight="Bold" Foreground="#0B2B6B" TextWrapping="Wrap"/><TextBlock Text="{escape(task['description'], {chr(34):'&quot;'})}" FontSize="11.5" Foreground="#5B6B7F" TextWrapping="Wrap" TextTrimming="CharacterEllipsis" MaxHeight="32" Margin="0,2,0,0" LineHeight="16"/></StackPanel></Grid></Border>''')
        groups.append(f'<StackPanel x:Name="NhomNV_{role}"><TextBlock Text="{title}" FontSize="13" FontWeight="Bold" Foreground="#2F6FE0" Margin="8,10,6,8"/><UniformGrid Columns="3">'+''.join(cards)+'</UniformGrid></StackPanel>')
    text=text.replace('@@NHIEMVU@@',''.join(groups))
    for name in ('BtnCapNhat','BtnCaiLai','BtnDoctor'):
        text=re.sub(r'<Button\b[^>]*x:Name="'+name+r'"[^>]*/>','',text)
    text=re.sub(r'<Border x:Name="TiDoctor".*?</StackPanel>\s*</(?:Grid>\s*</)?Border>','',text,flags=re.S)
    text=text.replace('ChamNhaCungCapCu','ChamOpenRouter').replace('TxtNhaCungCapCu','TxtOpenRouter')
    # Replace reference-provider UI text, including browser-extension instructions.
    def replace_attribute(match):
        name,value=match.group(1),match.group(2)
        if not re.search(r'nhà cung cấp cũ|tiện ích trình duyệt cũ',value,re.I):return match.group(0)
        if name=='Header' or name=='Content':new='Cấu hình OpenRouter'
        elif 'model' in value.lower():new='Model OpenRouter đang cấu hình. Bấm Cấu hình OpenRouter để thay đổi.'
        elif 'dữ liệu' in value.lower() or 'máy chủ' in value.lower():new='Yêu cầu và tài liệu đính kèm được gửi qua OpenRouter đến nhà cung cấp model đã chọn. Chỉ gửi dữ liệu cần thiết cho công việc.'
        else:new='Kết nối OpenRouter và cấu hình API key trong Cài đặt.'
        return name+'="'+new+'"'
    text=re.sub(r'(Text|Content|Header|ToolTip)="([^\"]*)"',replace_attribute,text)
    import xml.etree.ElementTree as ET
    ET.fromstring(text)
    assert '@@' not in text
    path.write_text(text,encoding='utf-8')
    (folder/'missions.json').write_text(json.dumps(tasks,ensure_ascii=False,indent=2),encoding='utf-8')
    print('Prepared school layout and',len(tasks),'mission cards')

if __name__=='__main__':
    import subprocess
    subprocess.run(['powershell','-NoProfile','-ExecutionPolicy','Bypass','-File',str(folder/'generate_layout.ps1')],check=True)
    finish_layout()
