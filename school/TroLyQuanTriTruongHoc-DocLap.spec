# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['E:\\git_hub\\Day_hoc\\school\\desktop.py'],
    pathex=['E:\\git_hub\\Day_hoc\\specialist', 'E:\\git_hub\\Day_hoc'],
    binaries=[],
    datas=[('E:\\git_hub\\Day_hoc\\school\\wpf\\school-link.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\app\\templates\\hieu_truong', 'templates/hieu_truong'), ('E:\\git_hub\\Day_hoc\\school\\wpf\\host.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\scripts\\verify-ai.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\school\\wpf\\layout.xaml', 'wpf'), ('E:\\git_hub\\Day_hoc\\school\\wpf\\logo.png', 'wpf'), ('E:\\git_hub\\Day_hoc\\school\\wpf\\icon.ico', 'wpf'), ('E:\\git_hub\\Day_hoc\\school\\wpf\\missions.json', 'wpf')],
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
    name='TroLyQuanTriTruongHoc-DocLap',
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
    icon=['E:\\git_hub\\Day_hoc\\school\\wpf\\icon.ico'],
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='TroLyQuanTriTruongHoc-DocLap',
)
