from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[1]
os.chdir(PROJECT_ROOT)

import re

with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Fix the comment leak
if '!-- SECTION: FAQ (#hoi-dap) -->' in content:
    content = content.replace('!-- SECTION: FAQ (#hoi-dap) -->', '<!-- SECTION: FAQ (#hoi-dap) -->')
    print("Fixed FAQ comment leak!")
else:
    content = re.sub(r'!?--\s*SECTION:\s*FAQ[^>]*-->', '<!-- SECTION: FAQ (#hoi-dap) -->', content)
    print("Checked FAQ comment")

# 2. Extract header brand and replace footer brand
header_brand_m = re.search(r'(<a class="brand" href="#trang-chu">.*?</a>)', content, re.DOTALL)
if header_brand_m:
    header_brand_html = header_brand_m.group(1)
    print("Found header brand html, length:", len(header_brand_html))
    
    # Check footer brand
    footer_idx = content.rfind('<footer')
    if footer_idx != -1:
        footer_part = content[footer_idx:]
        footer_brand_m = re.search(r'<a class="brand" href="#trang-chu">.*?</a>', footer_part, re.DOTALL)
        if footer_brand_m:
            footer_brand_old = footer_brand_m.group(0)
            print("Found footer brand html, length:", len(footer_brand_old))
            footer_part_new = footer_part.replace(footer_brand_old, header_brand_html)
            content = content[:footer_idx] + footer_part_new
            print("Successfully synced footer brand logo with header brand logo!")
        else:
            print("Footer brand not found in footer")

# 3. Check for any other broken comments or leaks like '!--'
leaks = re.findall(r'(?<!<)!--[^\n>]*', content)
print("Any other comment leaks?", leaks)

# 4. Save updated content
with open('index.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("index.html updated successfully!")
