from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[1]
os.chdir(PROJECT_ROOT)

import os
import shutil

for name, folder in [('GV', 'archive/extracted_gv'), ('HT', 'archive/extracted_ht'), ('CV', 'archive/extracted_cv')]:
    print(f"=== {name}: {folder} ===")
    if os.path.exists(folder):
        for item in os.listdir(folder):
            item_path = os.path.join(folder, item)
            if os.path.isdir(item_path):
                subitems = os.listdir(item_path)
                print(f"  Folder: {item} (subitems: {len(subitems)})")
                if 'app' in subitems:
                    print(f"    -> Contains 'app' folder!")
                    print(f"    app files: {os.listdir(os.path.join(item_path, 'app'))}")
                if 'cong-cu' in subitems:
                    print(f"    -> Contains 'cong-cu' folder! ({len(os.listdir(os.path.join(item_path, 'cong-cu')))} tools)")
                if 'mau' in subitems:
                    print(f"    -> Contains 'mau' folder! ({len(os.listdir(os.path.join(item_path, 'mau')))} templates)")
                if 'he-thong' in subitems:
                    print(f"    -> Contains 'he-thong' folder!")
