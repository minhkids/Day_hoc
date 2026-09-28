from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[1]
os.chdir(PROJECT_ROOT)

import os
import re
import sys

# Ensure UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

apps = [
    ("GV", r"archive\extracted_gv\$_13_\app\TroLy.ps1"),
    ("HT", r"archive\extracted_ht\$_13_\app\TroLy.ps1"),
    ("CV", r"archive\extracted_cv\$_13_\app\TroLy.ps1")
]

for label, p in apps:
    if not os.path.exists(p):
        print(f"File not found: {p}")
        continue
    with open(p, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    app_id = re.search(r"\$APP_ID\s*=\s*'([^']+)'", content)
    title = re.search(r"\$TEN_PHAN_MEM\s*=\s*'([^']+)'", content)
    version = re.search(r"\$PhienBan\s*=\s*'([^']+)'", content)
    
    print(f"\n==================== {label} ====================")
    print(f"Title: {title.group(1) if title else 'N/A'}")
    print(f"AppID: {app_id.group(1) if app_id else 'N/A'}")
    print(f"Version: {version.group(1) if version else 'N/A'}")
    
    # Extract TheChinh items
    the_chinh = re.findall(r"Tieu\s*=\s*'([^']+)'.*?MoTa\s*=\s*'([^']+)'", content)
    print(f"Total Features/Cards: {len(the_chinh)}")
    for t, m in the_chinh[:8]:
        print(f"  - {t}: {m}")
