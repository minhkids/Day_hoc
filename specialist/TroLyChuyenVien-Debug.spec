# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['E:\\git_hub\\Day_hoc\\specialist\\desktop.py'],
    pathex=[],
    binaries=[],
    datas=[('E:\\git_hub\\Day_hoc\\app\\templates\\chuyen_vien', 'reference-templates'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\host.ps1', 'wpf'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\layout.xaml', 'wpf'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\logo.png', 'wpf'), ('E:\\git_hub\\Day_hoc\\specialist\\wpf\\icon.ico', 'wpf')],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['pandas', 'numpy', 'scipy', 'matplotlib', 'IPython', 'pytest'],
    noarchive=True,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [('v', None, 'OPTION')],
    name='TroLyChuyenVien-Debug',
    debug=True,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['E:\\git_hub\\Day_hoc\\specialist\\wpf\\icon.ico'],
)
