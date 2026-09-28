from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[1]
os.chdir(PROJECT_ROOT)

import os
import json

def analyze_dir(path):
    info = {"files": [], "dirs": {}}
    if not os.path.exists(path):
        return None
    for item in sorted(os.listdir(path)):
        full = os.path.join(path, item)
        if os.path.isdir(full):
            info["dirs"][item] = len(os.listdir(full))
        else:
            info["files"].append((item, os.path.getsize(full)))
    return info

print("=== 1. USER'S INSTALLED APP: C:\\Users\\Admin\\AppData\\Local\\Programs\\TroLyQTTH ===")
user_app = r"C:\Users\Admin\AppData\Local\Programs\TroLyQTTH"
for sub in ["", "app", "cong-cu", "he-thong", "mau"]:
    target = os.path.join(user_app, sub) if sub else user_app
    print(f"\n--- {target} ---")
    data = analyze_dir(target)
    if data:
        print(f"Dirs: {data['dirs']}")
        print(f"Files: {[f[0] for f in data['files']]}")

print("\n=== 2. USER'S DATA WORKSPACE: D:\\TROLY_HT_PHT ===")
data_ws = r"D:\TROLY_HT_PHT"
data = analyze_dir(data_ws)
if data:
    print(f"Dirs: {data['dirs']}")
    print(f"Files: {[f[0] for f in data['files']]}")
    if os.path.exists(os.path.join(data_ws, "09_BO_NHO_TRO_LY")):
        bn = os.path.join(data_ws, "09_BO_NHO_TRO_LY")
        print(f"09_BO_NHO_TRO_LY files: {os.listdir(bn)}")

print("\n=== 3. EXTRACTED PACKAGES ROOT COMPARISON ===")
for code, folder in [("GV", "archive/extracted_gv"), ("HT", "archive/extracted_ht"), ("CV", "archive/extracted_cv")]:
    # Look for the internal folder that contains 'app'
    for r, d, f in os.walk(folder):
        if "app" in d and "mau" in d:
            print(f"\n[{code}] Found app root at: {r}")
            app_dir = analyze_dir(os.path.join(r, "app"))
            mau_dir = analyze_dir(os.path.join(r, "mau"))
            congcu_dir = analyze_dir(os.path.join(r, "cong-cu"))
            print(f"  app files: {[f[0] for f in app_dir['files']]}")
            print(f"  mau subdirs: {list(mau_dir['dirs'].keys())}")
            print(f"  cong-cu files: {[f[0] for f in congcu_dir['files']]}")
            break
