# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['E:\\git_hub\\Day_hoc\\teacher\\desktop.py'],
    pathex=['E:\\git_hub\\Day_hoc\\specialist', 'E:\\git_hub\\Day_hoc\\build\\teacher-shared'],
    binaries=[],
    datas=[('E:\\git_hub\\Day_hoc\\teacher\\wpf\\school-link.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\teacher\\wpf\\layout.xaml', 'wpf'), ('E:\\git_hub\\Day_hoc\\teacher\\wpf\\host.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\scripts\\verify-ai.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\teacher\\wpf\\logo.png', 'wpf'), ('E:\\git_hub\\Day_hoc\\teacher\\wpf\\icon.ico', 'wpf'), ('E:\\git_hub\\Day_hoc\\app\\templates\\giao_vien', 'templates/giao_vien'), ('E:\\git_hub\\Day_hoc\\app\\mini_apps', 'mini_apps')],
    hiddenimports=['shared_bridge', 'updater'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['numpy', 'pandas', 'matplotlib'],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='TroLyGiaoVien-DocLap',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['E:\\git_hub\\Day_hoc\\teacher\\wpf\\icon.ico'],
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='TroLyGiaoVien-DocLap',
)
