"""Launch each actual EXE and exercise WPF AI buttons with synthetic documents.

Uses an isolated temporary data directory. Credentials are loaded by the app from
the configured .env; no credentials, user documents or model answers enter reports.
"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

from docx import Document

ROOT = Path(__file__).resolve().parents[1]
APPS = {
    'teacher': ('TroLyGiaoVien-DocLap', 'TROLY_TEACHER_DATA_DIR'),
    'school': ('TroLyQuanTriTruongHoc-DocLap', 'TROLY_SCHOOL_DATA_DIR'),
    'specialist': ('TroLyChuyenVien-DocLap', 'TROLY_DATA_DIR'),
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--payload-root', type=Path)
    parser.add_argument('--app', choices=list(APPS))
    parser.add_argument('--report-dir', type=Path, required=True)
    args = parser.parse_args()
    args.report_dir.mkdir(parents=True, exist_ok=True)
    failed = False
    for app, (binary, data_env) in APPS.items():
        if args.app and args.app != app:
            continue
        with tempfile.TemporaryDirectory(prefix='troly-ai-check-') as folder:
            report = (args.report_dir / (app + '.json')).resolve()
            report.unlink(missing_ok=True)
            attachment = Path(folder) / 'synthetic.docx'
            doc = Document()
            doc.add_paragraph('Ma kiem thu: AI-CHECK-7429. So hoc sinh: 128. Du lieu gia lap.')
            doc.save(attachment)
            env = os.environ.copy()
            env.update({data_env: str(Path(folder) / 'data'), 'TROLY_VERIFY_APP': app,
                        'TROLY_AI_REPORT': str(report), 'TROLY_VERIFY_DOCUMENT': str(attachment)})
            if args.payload_root:
                command = [str(args.payload_root.resolve() / app / binary / (binary + '.exe'))]
            else:
                command = [sys.executable, str(ROOT / app / 'desktop.py')]
            startup = subprocess.STARTUPINFO()
            startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
            startup.wShowWindow = 0
            process = subprocess.Popen(command + ['--verify-ai'], cwd=ROOT, env=env,
                                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                                       startupinfo=startup)
            try:
                code = process.wait(timeout=700)
            except subprocess.TimeoutExpired:
                subprocess.run(['taskkill', '/PID', str(process.pid), '/T', '/F'], capture_output=True)
                code = -1
            if report.exists():
                result = json.loads(report.read_text(encoding='utf-8-sig'))
                print(json.dumps({'app': app, 'exit': code, **result}, ensure_ascii=True), flush=True)
                failed |= code != 0 or bool(result['errors'])
            else:
                print(f'FAIL {app}: exit={code}, no WPF verification report', flush=True)
                failed = True
    return int(failed)


if __name__ == '__main__':
    sys.exit(main())
