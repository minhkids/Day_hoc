"""Adapt reference presentation to the OpenRouter-only teacher app."""
from pathlib import Path
import re
from xml.sax.saxutils import escape


def clean_layout():
    path=Path(__file__).resolve().parent/'wpf/layout.xaml'
    text=path.read_text(encoding='utf-8-sig')
    for name in ('BtnCapNhat','BtnCaiLai','BtnDoctor'):
        text=re.sub(r'<Button\b[^>]*x:Name="'+name+r'"[^>]*/>', '', text)
    # The tile has nested borders: remove precisely through its final StackPanel/Grid.
    text=re.sub(r'<Border x:Name="TiDoctor".*?</StackPanel>\s*</Grid>\s*</Border>', '', text, flags=re.S)
    replacements={
        'Đăng nhập cũ':'Cấu hình OpenRouter',
        'Tình trạng công cụ, tài khoản cũ, mô hình AI, thông tin giáo viên và bộ nhớ của trợ lý.':'Kết nối OpenRouter, mô hình AI, thông tin giáo viên và bộ nhớ của trợ lý.',
        'Nhà cung cấp cũ: đang kiểm tra...':'OpenRouter: đang kiểm tra cấu hình...',
        'Đăng nhập: đang kiểm tra...':'API key: đang kiểm tra...',
        'Chọn model cũ mà trợ lý dùng trên máy này.':'Model OpenRouter hiện tại. Bấm Cấu hình OpenRouter để nhập API key và mã model của bạn.',
        'ChamNhaCungCapCu':'ChamOpenRouter','TxtNhaCungCapCu':'TxtOpenRouter',
    }
    for old,new in replacements.items():text=text.replace(old,new)
    privacy='Yêu cầu và tài liệu đính kèm được gửi qua OpenRouter đến nhà cung cấp model đã cấu hình. Chỉ gửi dữ liệu học sinh cần thiết cho công việc. API key được bảo vệ bằng Windows DPAPI; bản sao lưu không chứa key.'
    text=re.sub(r'Text="Nội dung trao đổi được gửi đến máy chủ AI[^\"]*"', 'Text="'+escape(privacy)+'"', text)
    import xml.etree.ElementTree as ET
    ET.fromstring(text)
    path.write_text(text,encoding='utf-8')

if __name__=='__main__':clean_layout()
