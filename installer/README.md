# Windows release installers

`python installer/build_release.py` builds the three onedir applications into the versioned `releases/<version>/payload` directory, wraps each payload in a self-contained Windows `Setup.exe`, copies the public downloads into `exe/`, and updates `data/app_versions.json` only after all three installers have been built. Pass `--overwrite-installers` when intentionally replacing the existing public Setup.exe files.

Each setup is a four-step wizard (welcome, terms, install location, completion) with that application's logo and icon. The user must check the agreement box on the terms page before the Next button enables. It installs into a per-user directory under `%LOCALAPPDATA%\Programs` by default, keeps each app version in its own folder, creates a Start Menu shortcut and an uninstall entry, and does not remove the app's separate user-data directory when uninstalled.

The setup EXEs require the Windows .NET Framework 4.x runtime, which is included with supported Windows versions. Build dependencies are the repository's Python/PyInstaller environment and the Windows .NET Framework compiler (`csc.exe`).

To publish a later version, update the three `APP_VERSION` values and `VERSION` in `build_release.py`, then build and publish the new installers. The API serves files from the repository's `exe/` directory through `/downloads/`; keep the names in `APPS`, `data/app_versions.json`, and the server's fallback metadata in sync. A temporary ngrok URL is for testing only and should not be embedded as a permanent update host.

After changing the wizard or its visual resources, `python installer/build_release.py --installer-only` recompiles setup EXEs from the existing payload ZIPs without rebuilding the applications.

Shortcuts use the Windows Unicode Shell Link API. `Setup.exe --self-check` saves and reloads a shortcut using the application's Vietnamese name under a Vietnamese test directory, and verifies its target. `Setup.exe --repair-shortcut` recreates the Start Menu shortcut for the installed version without reinstalling the application. Running the wizard again for an already installed version also repairs its shortcut.

The setup embeds a separate, small uninstaller, compiled from `WindowsInstaller.cs` with `UNINSTALLER` defined. Each installation writes it to a new `.maintenance/<id>/Uninstall.exe` path and registers it in Windows Installed Apps and as a Start Menu `Gỡ …` shortcut. Upgrades never overwrite the legacy root-level `Uninstall-*.exe`. Reinstalling the same version repairs both registration and shortcuts.

Uninstall first asks for confirmation and checks that the app is closed. It runs a small temporary worker so it can remove its installed executable. It validates the registered installation root and ownership marker, rejects directory links, removes managed application directories and registration, and preserves personal files. A blocked legacy uninstaller is reported as leftover cleanup rather than making application removal fail. No antivirus exclusions or ACL changes are required by this workflow.

`python installer/verify_lifecycle.py` compiles isolated test installers from existing payload archives and exercises actual fresh installation, upgrade while the old uninstaller is locked, same-version repair, registered uninstaller execution, and data preservation. Test registry keys contain `-InstallTest-`; test files and shortcuts stay under unique temporary directories. It needs permission to create/delete its test HKCU uninstall keys. Results are recorded as `lifecycle-check.json` in the release directory.
