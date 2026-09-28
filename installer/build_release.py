"""Build versioned portable payloads and self-contained Windows Setup.exe releases."""
from __future__ import annotations

import json
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
import zipfile


ROOT = Path(__file__).resolve().parents[1]
VERSION = "1.0.7"
RELEASE = ROOT / "releases" / VERSION
PAYLOADS = RELEASE / "payload"
INSTALLERS = RELEASE / "installers"
TERMS = ROOT / "installer" / "TERMS_VI.md"
CS_SOURCE = ROOT / "installer" / "WindowsInstaller.cs"
DESTINATIONS = ROOT / "exe"

APPS = (
    {
        "id": "teacher", "name": "Trợ lý Giáo viên",
        "title": "Trợ lý Giáo viên", "folder": "TroLyGiaoVienDocLap",
        "binary": "TroLyGiaoVien-DocLap/TroLyGiaoVien-DocLap.exe",
        "setup": "TroLyGiaoVien-Setup.exe", "registry": "TroLyGiaoVienDocLap",
        "logo": ROOT / "teacher" / "wpf" / "logo.png", "icon": ROOT / "teacher" / "wpf" / "icon.ico",
        "build": ROOT / "teacher" / "build.py",
        "change": "- Gỡ các mục và tài nguyên liên quan đến Claude Code/nhà cung cấp cũ.\n- Thêm xóa hội thoại, tạo đề theo mẫu bằng AI và thư viện câu nhận xét học sinh.",
    },
    {
        "id": "school", "name": "Trợ lý Quản trị trường học",
        "title": "Trợ lý Quản trị trường học", "folder": "TroLyQuanTriTruongHocDocLap",
        "binary": "TroLyQuanTriTruongHoc-DocLap/TroLyQuanTriTruongHoc-DocLap.exe",
        "setup": "TroLyHieuTruong-Setup.exe", "registry": "TroLyQuanTriTruongHocDocLap",
        "logo": ROOT / "school" / "wpf" / "logo.png", "icon": ROOT / "school" / "wpf" / "icon.ico",
        "build": ROOT / "school" / "build.py",
        "change": "- Gỡ các mục và tài nguyên liên quan đến Claude Code/nhà cung cấp cũ.\n- Cập nhật tài nguyên giao diện dùng chung.",
    },
    {
        "id": "specialist", "name": "Trợ lý Chuyên viên QLNN Giáo dục",
        "title": "Trợ lý Chuyên viên QLNN Giáo dục", "folder": "TroLyChuyenVienDocLap",
        "binary": "TroLyChuyenVien-DocLap/TroLyChuyenVien-DocLap.exe",
        "setup": "TroLyChuyenVien-Setup.exe", "registry": "TroLyChuyenVienDocLap",
        "logo": ROOT / "specialist" / "wpf" / "logo.png", "icon": ROOT / "specialist" / "wpf" / "icon.ico",
        "build": ROOT / "specialist" / "build.py",
        "change": "- Gỡ các mục và tài nguyên liên quan đến Claude Code/nhà cung cấp cũ.\n- Cập nhật tài nguyên giao diện dùng chung.",
    },
)


def run_builds() -> None:
    subprocess.run([sys.executable, str(ROOT / 'scripts' / 'clean_legacy_ai_assets.py')], cwd=ROOT, check=True)
    for app in APPS:
        output = PAYLOADS / app["id"]
        env = os.environ.copy()
        env["TROLY_DIST_DIR"] = str(output)
        subprocess.run([sys.executable, str(app["build"])], cwd=ROOT, env=env, check=True)
        if not (output / app["binary"]).is_file():
            raise FileNotFoundError("Build không tạo được " + str(output / app["binary"]))


def make_payload(app: dict) -> Path:
    source = PAYLOADS / app["id"] / (Path(app["binary"]).parts[0])
    archive = RELEASE / (app["id"] + "-payload.zip")
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as output:
        for path in sorted(source.rglob("*")):
            if path.is_file():
                output.write(path, Path(source.name) / path.relative_to(source))
    return archive


def compile_installer(app: dict, archive: Path) -> Path:
    manifest_path = RELEASE / (app["id"] + "-setup-manifest.json")
    manifest = {
        "app_id": app["id"], "app_name": app["title"],
        "install_folder": app["folder"], "executable": app["binary"],
        "version": VERSION, "registry_key": app["registry"],
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False), encoding="utf-8")
    output = INSTALLERS / app["setup"]
    resources = [
        "/resource:" + str(archive) + ",TroLy.Payload.zip",
        "/resource:" + str(TERMS) + ",TroLy.TERMS_VI.txt",
        "/resource:" + str(manifest_path) + ",TroLy.SetupManifest.json",
        "/resource:" + str(app["logo"]) + ",TroLy.Logo.png",
    ]
    compiler = Path(os.environ.get("WINDIR", r"C:\Windows")) / "Microsoft.NET" / "Framework64" / "v4.0.30319" / "csc.exe"
    if not compiler.is_file():
        compiler = Path(os.environ.get("WINDIR", r"C:\Windows")) / "Microsoft.NET" / "Framework" / "v4.0.30319" / "csc.exe"
    if not compiler.is_file():
        raise FileNotFoundError("Không tìm thấy trình biên dịch .NET Framework (csc.exe).")
    uninstaller = RELEASE / (app["id"] + "-Uninstall.exe")
    shared_options = [str(compiler), "/nologo", "/target:winexe", "/optimize+", "/codepage:65001", "/win32icon:" + str(app["icon"]),
               "/reference:System.Windows.Forms.dll", "/reference:System.Drawing.dll",
               "/reference:System.IO.Compression.dll", "/reference:System.IO.Compression.FileSystem.dll",
               "/reference:Microsoft.CSharp.dll"]
    subprocess.run([*shared_options, "/define:UNINSTALLER", "/out:" + str(uninstaller),
                    "/resource:" + str(manifest_path) + ",TroLy.SetupManifest.json", str(CS_SOURCE)], cwd=ROOT, check=True)
    resources.append("/resource:" + str(uninstaller) + ",TroLy.Uninstall.exe")
    command = [*shared_options, "/out:" + str(output), *resources, str(CS_SOURCE)]
    subprocess.run(command, cwd=ROOT, check=True)
    return output


def update_release_metadata() -> None:
    path = ROOT / "data" / "app_versions.json"
    versions = json.loads(path.read_text(encoding="utf-8"))
    for app in APPS:
        item = versions.setdefault(app["id"], {})
        item.update({
            "name": app["name"], "latest_version": VERSION,
            "download_url": "/downloads/" + app["setup"],
            "changelog": app["change"], "mandatory": False,
            "release_date": "2026-09-23",
        })
    temporary = path.with_suffix(".json.tmp")
    temporary.write_text(json.dumps(versions, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    temporary.replace(path)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--installer-only", action="store_true", help="Recompile setup EXEs from the existing versioned payload archives.")
    parser.add_argument("--overwrite-installers", action="store_true", help="Replace existing public Setup.exe files after a successful build.")
    options = parser.parse_args()
    RELEASE.mkdir(parents=True, exist_ok=True)
    PAYLOADS.mkdir(parents=True, exist_ok=True)
    INSTALLERS.mkdir(parents=True, exist_ok=True)
    if options.installer_only:
        for app in APPS:
            archive = RELEASE / (app["id"] + "-payload.zip")
            if not archive.is_file():
                raise FileNotFoundError("Payload archive is missing: " + str(archive))
            setup = compile_installer(app, archive)
            destination = DESTINATIONS / setup.name
            if destination.exists() and not options.overwrite_installers:
                raise FileExistsError("Không ghi đè bộ cài đã có: " + str(destination))
            shutil.copy2(setup, destination)
        update_release_metadata()
        print("Recompiled the three installers from the existing payloads.")
        return
    for app in APPS:
        destination = DESTINATIONS / app["setup"]
        if destination.exists() and not options.overwrite_installers:
            raise FileExistsError("Không ghi đè bộ cài đã có: " + str(destination))
    run_builds()
    for app in APPS:
        archive = make_payload(app)
        setup = compile_installer(app, archive)
        shutil.copy2(setup, DESTINATIONS / setup.name)
    update_release_metadata()
    print("Built version " + VERSION + " installers:")
    for app in APPS:
        print(DESTINATIONS / app["setup"])


if __name__ == "__main__":
    main()
