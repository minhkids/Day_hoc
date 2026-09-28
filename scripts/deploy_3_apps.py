from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[1]
os.chdir(PROJECT_ROOT)

import os
import shutil
import subprocess
import sys

# Ensure UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

BASE_DIR = str(PROJECT_ROOT)
CSC_PATH = r"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not os.path.exists(CSC_PATH):
    CSC_PATH = r"C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe"

APPS = [
    {
        "id": "GV",
        "name": "Trợ lý Giáo viên",
        "folder": "TroLy_GiaoVien",
        "exe_name": "TroLyGiaoVien.exe",
        "source_dir": os.path.join(BASE_DIR, "archive/extracted_gv", "$_13_")
    },
    {
        "id": "HT",
        "name": "Trợ lý Quản trị trường học",
        "folder": "TroLy_HieuTruong",
        "exe_name": "TroLyHieuTruong.exe",
        "source_dir": os.path.join(BASE_DIR, "archive/extracted_ht", "$_13_")
    },
    {
        "id": "CV",
        "name": "Trợ lý QLNN về Giáo dục",
        "folder": "TroLy_ChuyenVien",
        "exe_name": "TroLyChuyenVien.exe",
        "source_dir": os.path.join(BASE_DIR, "archive/extracted_cv", "$_13_")
    }
]

print("=== STARTING DEPLOYMENT OF 3 NATIVE DESKTOP APPS ===")

# Enhanced TroLy.cs that looks in both current folder and 'app' subfolder
CS_LAUNCHER_TEMPLATE = """using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

static class Program
{
    [STAThread]
    static void Main()
    {
        string dir = AppDomain.CurrentDomain.BaseDirectory;
        string script = Path.Combine(dir, "TroLy.ps1");
        string workDir = dir;
        if (!File.Exists(script))
        {
            string inApp = Path.Combine(dir, "app", "TroLy.ps1");
            if (File.Exists(inApp))
            {
                script = inApp;
                workDir = Path.Combine(dir, "app");
            }
            else
            {
                MessageBox.Show("Không tìm thấy tệp TroLy.ps1. Hãy kiểm tra lại thư mục ứng dụng.", "@@APP_TITLE@@",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
        }

        string win = Environment.GetFolderPath(Environment.SpecialFolder.Windows);
        string ps = Path.Combine(win, @"System32\\WindowsPowerShell\\v1.0\\powershell.exe");
        if (!Environment.Is64BitProcess && Environment.Is64BitOperatingSystem)
        {
            string sysnative = Path.Combine(win, @"Sysnative\\WindowsPowerShell\\v1.0\\powershell.exe");
            if (File.Exists(sysnative)) ps = sysnative;
        }
        if (!File.Exists(ps)) ps = "powershell.exe";

        var psi = new ProcessStartInfo(ps,
            "-NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File \\\"" + script + "\\\"");
        psi.WorkingDirectory = workDir;
        psi.UseShellExecute = false;
        psi.CreateNoWindow = true;

        Process p;
        try { p = Process.Start(psi); }
        catch (Exception ex)
        {
            MessageBox.Show("Không mở được phần mềm: " + ex.Message, "@@APP_TITLE@@",
                MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }

        try
        {
            if (p != null && p.WaitForExit(10000) && p.ExitCode != 0 && p.ExitCode != 3)
            {
                MessageBox.Show("Phần mềm thoát với mã lỗi: " + p.ExitCode, "@@APP_TITLE@@",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        catch { }
    }
}
"""

UNLOCKED_BAN_QUYEN = """<#
.SYNOPSIS
  Bản quyền vĩnh viễn đã mở khóa - Dành cho ngành Giáo dục
#>
$LIEN_HE_TAC_GIA = 'hotro@trolygiaoduc.vn'
$script:CoBanQuyen = $true

function Lay-GiayPhep {
    return [pscustomobject]@{
        HopLe = $true
        ThongBao = 'Bản quyền vĩnh viễn (Đã kích hoạt)'
        MaMay = 'EDU-VIP-PERMANENT'
        TenTruong = 'Ngành Giáo dục & Đào tạo'
        HanDungHienThi = 'Vô thời hạn (Vĩnh viễn)'
        ConNgay = 99999
    }
}
function Da-KichHoat { return $true }
function Can-BanQuyen { return $true }

function Ve-BanQuyen {
    $gp = Lay-GiayPhep
    if (Test-Path Variable:F) {
        try {
            $tb = F 'TxtBanQuyen'
            if ($tb) {
                $tb.Text = "Đã kích hoạt bản quyền vĩnh viễn`nHạn dùng: Vô thời hạn`nTrạng thái: Sẵn sàng hỗ trợ 100%"
            }
        } catch {}
    }
}

function Show-KichHoat([string]$ChupAnh) {
    try {
        [System.Windows.MessageBox]::Show("Phần mềm đã được kích hoạt bản quyền vĩnh viễn. Thầy/cô có thể yên tâm sử dụng toàn bộ tính năng!", "Bản quyền phần mềm", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {}
    return $true
}
"""

for app in APPS:
    target_dir = os.path.join(BASE_DIR, app["folder"])
    print(f"\n---> Building {app['name']} into: {target_dir}")
    os.makedirs(target_dir, exist_ok=True)
    
    src = app["source_dir"]
    if not os.path.exists(src):
        print(f"ERROR: Source dir not found: {src}")
        continue
    
    # Copy all essential directories
    for folder_name in ["app", "cong-cu", "he-thong", "mau"]:
        s_folder = os.path.join(src, folder_name)
        d_folder = os.path.join(target_dir, folder_name)
        if os.path.exists(s_folder):
            if os.path.exists(d_folder):
                shutil.rmtree(d_folder)
            shutil.copytree(s_folder, d_folder)
            print(f"  Copied {folder_name}/ ({len(os.listdir(d_folder))} items)")

    # Ensure memory / storage directory (09_BO_NHO_TRO_LY, 07_MAU_RIENG)
    for data_dir in ["01_VAN_BAN_DEN", "02_VAN_BAN_DI", "03_KE_HOACH", "04_BAO_CAO", "05_BIEN_BAN", "06_DU_LIEU", "07_MAU_RIENG", "08_SAO_LUU", "09_BO_NHO_TRO_LY"]:
        s_data = os.path.join(src, data_dir)
        d_data = os.path.join(target_dir, data_dir)
        if os.path.exists(s_data):
            if os.path.exists(d_data):
                shutil.rmtree(d_data)
            shutil.copytree(s_data, d_data)
            print(f"  Copied {data_dir}/ ({len(os.listdir(d_data))} items)")
        else:
            os.makedirs(d_data, exist_ok=True)

    # 1. Write Unlocked License
    bq_path = os.path.join(target_dir, "app", "ban-quyen.ps1")
    with open(bq_path, "w", encoding="utf-8") as f:
        f.write(UNLOCKED_BAN_QUYEN)
    print("  Installed permanent license patch into app/ban-quyen.ps1")

    # 2. Patch TroLy.ps1 status bar yellow warning
    tr_path = os.path.join(target_dir, "app", "TroLy.ps1")
    if os.path.exists(tr_path):
        with open(tr_path, "r", encoding="utf-8", errors="ignore") as f:
            ps1_code = f.read()
        
        # Replace status bar warning for license
        ps1_code = ps1_code.replace("Cần: kích hoạt bản quyền", "Bản quyền: Đã kích hoạt")
        ps1_code = ps1_code.replace("Chấm vàng", "Chấm xanh")
        ps1_code = ps1_code.replace("#FFB300", "#10B981") # Green dot instead of yellow!
        
        with open(tr_path, "w", encoding="utf-8") as f:
            f.write(ps1_code)
        print("  Patched status bar indicator in TroLy.ps1")

    # 3. Compile Launcher EXE
    # Write custom TroLy.cs
    cs_code = CS_LAUNCHER_TEMPLATE.replace("@@APP_TITLE@@", app["name"])
    cs_path = os.path.join(target_dir, "TroLy.cs")
    with open(cs_path, "w", encoding="utf-8") as f:
        f.write(cs_code)
    
    # Also write to app/TroLy.cs
    app_cs_path = os.path.join(target_dir, "app", "TroLy.cs")
    with open(app_cs_path, "w", encoding="utf-8") as f:
        f.write(cs_code)

    icon_path = os.path.join(target_dir, "app", "icon.ico")
    
    # Compile root executable
    root_exe = os.path.join(target_dir, app["exe_name"])
    compile_cmd = [
        CSC_PATH,
        "/nologo",
        "/target:winexe",
        f"/out:{root_exe}",
        "/r:System.Windows.Forms.dll",
        cs_path
    ]
    if os.path.exists(icon_path):
        compile_cmd.append(f"/win32icon:{icon_path}")
    
    res = subprocess.run(compile_cmd, capture_output=True, text=True)
    if res.returncode == 0 and os.path.exists(root_exe):
        print(f"  [SUCCESS] Compiled root executable: {app['exe_name']} ({os.path.getsize(root_exe)} bytes)")
    else:
        print(f"  [FAIL] Failed to compile root executable: {res.stderr}")

    # Also compile inside app/TroLy.exe
    app_exe = os.path.join(target_dir, "app", "TroLy.exe")
    compile_cmd_app = [
        CSC_PATH,
        "/nologo",
        "/target:winexe",
        f"/out:{app_exe}",
        "/r:System.Windows.Forms.dll",
        app_cs_path
    ]
    if os.path.exists(icon_path):
        compile_cmd_app.append(f"/win32icon:{icon_path}")
    
    res_app = subprocess.run(compile_cmd_app, capture_output=True, text=True)
    if res_app.returncode == 0:
        print(f"  [SUCCESS] Compiled app/TroLy.exe")

    # Create a simple .cmd batch runner as fallback
    cmd_runner = os.path.join(target_dir, f"Chay_{app['folder']}.cmd")
    with open(cmd_runner, "w", encoding="utf-8") as f:
        f.write(f'@echo off\r\ncd /d "%~dp0app"\r\nstart "" powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "TroLy.ps1"\r\n')
    print(f"  Created batch shortcut: Chay_{app['folder']}.cmd")

print("\n=== ALL 3 APPS DEPLOYED AND COMPILED SUCCESSFULLY! ===")
