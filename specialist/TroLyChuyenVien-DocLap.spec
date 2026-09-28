# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['E:\\git_hub\\Day_hoc\\specialist\\desktop.py'],
    pathex=['E:\\git_hub\\Day_hoc\\specialist', 'E:\\git_hub\\Day_hoc'],
    binaries=[],
    datas=[('E:\\git_hub\\Day_hoc\\specialist\\wpf\\school-link.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\app\\templates\\chuyen_vien', 'reference-templates'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\host.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\scripts\\verify-ai.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\layout.xaml', 'wpf'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\logo.png', 'wpf'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\icon.ico', 'wpf')],
    hiddenimports=['updater'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['pandas', 'numpy', 'scipy', 'matplotlib', 'IPython', 'pytest'],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='TroLyChuyenVien-DocLap',
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
    icon=['E:\\git_hub\\Day_hoc\\specialist\\wpf\\icon.ico'],
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='TroLyChuyenVien-DocLap',
)
