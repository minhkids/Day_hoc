"""Remove reference-app tooling from shipped presentation and its generators."""
from pathlib import Path
import json
import re
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN = re.compile(r'claude|anthropic', re.I)
PRIVACY = 'Yêu cầu và tài liệu đính kèm được gửi qua OpenRouter đến nhà cung cấp model đã cấu hình. API key được bảo vệ bằng tài khoản Windows.'


def clean(text):
    text = re.sub(r'<Border x:Name="TiDoctor".*?</StackPanel>\s*</Grid>\s*</Border>', '', text, flags=re.S)
    text = re.sub(r'^.*@\{ N = \'TiDoctor\'.*\n', '', text, flags=re.M)
    for name in ('BtnCapNhat', 'BtnCaiLai', 'BtnDoctor'):
        text = re.sub(r'<Button\b[^>]*x:Name="' + name + r'"[^>]*/>', '', text)
    text = re.sub(r'Text="Nội dung trao đổi được gửi đến máy chủ của Anthropic[^\"]*"', 'Text="' + PRIVACY + '"', text)
    replacements = {
        'Đăng nhập Claude': 'Cấu hình OpenRouter',
        'tài khoản Claude': 'kết nối OpenRouter',
        'Claude Code: đang kiểm tra...': 'OpenRouter: đang kiểm tra cấu hình...',
        'ChamClaude': 'ChamOpenRouter', 'TxtClaude': 'TxtOpenRouter',
        'Chọn model Claude mà trợ lý dùng trên máy này. Model mạnh làm kỹ hơn nhưng chậm hơn và tốn lượt dùng của tài khoản nhanh hơn.': 'Model AI đã được cấu hình sẵn. Nhập API key OpenRouter để sử dụng.',
        'Hoặc lấy thẳng văn bản mới trên iOffice (cần mở Chrome, đăng nhập iOffice và cài tiện ích Claude in Chrome).': 'Bạn có thể tải văn bản từ iOffice rồi chọn tệp để xử lý.',
        'Cần mở Chrome, tự đăng nhập, cài tiện ích Claude in Chrome.': 'Mở trang web, đăng nhập và tải tệp dữ liệu để xử lý.',
        'Không phụ thuộc Claude Code · ': '',
        'iOffice/Claude in Chrome': 'iOffice',
        'Không có đăng nhập thuê bao Claude Code; AI dùng API do bạn cấu hình.': 'AI dùng API OpenRouter do bạn cấu hình.',
        'OpenRouter/API tương thích, Gemini, Claude API; không đăng nhập thuê bao Claude Code': 'OpenRouter/API tương thích và Gemini',
        'Runs completely independently without Claude Code or external CLI tools.': 'Runs independently through OpenRouter without external CLI tools.',
        'Theo mục 5a CLAUDE.md': 'Theo hướng dẫn kiến thức nghiệp vụ',
    }
    for old, new in replacements.items():
        text = text.replace(old, new)
    return text


def main():
    paths = []
    for app in ('teacher', 'school', 'specialist'):
        paths.extend((ROOT / app / 'wpf').glob('*.xaml'))
        paths.extend((ROOT / app / 'wpf').glob('*.ps1'))
    paths.extend(ROOT / p for p in ('school/generate_host.py', 'school/run_test_pages.ps1',
        'specialist/main.py', 'specialist/README.md', 'school/build.py',
        'app/templates/giao_vien/can-cu-phap-ly.md'))
    for path in paths:
        raw = path.read_bytes()
        text = raw.decode('utf-8-sig')
        updated = clean(text)
        if path.suffix == '.xaml':
            ET.fromstring(updated)
        if FORBIDDEN.search(updated):
            raise ValueError('Reference-provider text remains: ' + str(path.relative_to(ROOT)))
        if updated != text:
            path.write_text(updated, encoding='utf-8-sig' if raw.startswith(b'\xef\xbb\xbf') else 'utf-8')
            print('Cleaned', path.relative_to(ROOT))
    path = ROOT / 'specialist/wpf/catalog.json'
    def strip_items(value):
        if isinstance(value, list):
            return [strip_items(item) for item in value if not isinstance(item, dict) or item.get('N') != 'TiDoctor']
        if isinstance(value, dict):
            return {key: strip_items(item) for key, item in value.items()}
        return value
    data = strip_items(json.loads(path.read_text(encoding='utf-8-sig')))
    text = json.dumps(data, ensure_ascii=False, indent=2) + '\n'
    if FORBIDDEN.search(text):
        raise ValueError('Reference-provider text remains in catalog')
    path.write_text(text, encoding='utf-8')


if __name__ == '__main__':
    main()
