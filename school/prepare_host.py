"""Reuse working WPF interaction helpers, then attach school-specific pages."""
from pathlib import Path
root=Path(__file__).resolve().parent
source=(root.parent/'teacher/wpf/host.ps1').read_text(encoding='utf-8-sig')
source=source[:source.index('# Wire named reference cards')]
source=source.replace('TROLY_TEACHER_DATA_DIR','TROLY_SCHOOL_DATA_DIR')
source=source.replace('Trợ lý Giáo viên','Trợ lý Quản trị trường học').replace('giáo viên','nhà trường').replace('Giáo viên','Quản trị trường học')
source=source.replace("@('subject','Môn dạy'),@('classes','Lớp dạy'),@('homeroom','Lớp chủ nhiệm')","@('position','Chức danh'),@('school_level','Cấp học'),@('parent','Cơ quan chủ quản'),@('principal','Hiệu trưởng'),@('vice_principals','Phó Hiệu trưởng'),@('party_org','Đảng ủy / chi bộ'),@('school_team','Tổ chuyên môn'),@('ioffice','Địa chỉ iOffice')")
source=source.replace("role='Quản trị trường học';position='Quản trị trường học'","role='Quản trị trường học'")
source=source.replace("$script:data.profile.subject+' · '+$script:data.profile.classes","$script:data.profile.position+' · '+$script:data.profile.school_level")
source=source.replace("$ctx.record){$item.id=$ctx.record.id};[void](Api 'save' @{kind=$ctx.kind;item=$item})","$ctx.record){$item.id=$ctx.record.id};$ctx.record=Api 'save' @{kind=$ctx.kind;item=$item}")
source+='\n'+(root/'wpf/school_actions.ps1').read_text(encoding='utf-8-sig')
(root/'wpf/host.ps1').write_text(source,encoding='utf-8-sig')
print('Prepared school WPF host')
