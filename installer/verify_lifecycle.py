"""Exercise real setup/uninstall executables with isolated manifests and temporary data."""
from pathlib import Path
import json
import os
import subprocess
import uuid

import build_release as release


def main():
    release.INSTALLERS.mkdir(parents=True, exist_ok=True)
    results = []
    for app in release.APPS:
        token = uuid.uuid4().hex
        test = dict(app)
        test.update(id=app['id'] + '-InstallTest-' + token,
                    registry=app['registry'] + '-InstallTest-' + token,
                    title='Kiểm thử ' + app['id'] + ' ' + token[:8],
                    setup=app['id'] + '-InstallTest-' + token + '.exe')
        archive = release.RELEASE / (app['id'] + '-payload.zip')
        executable = release.compile_installer(test, archive)
        result = subprocess.run([str(executable), '--integration-check'], capture_output=True,
                                timeout=120, encoding='utf-8', errors='replace')
        print(result.stdout)
        if result.returncode:
            raise RuntimeError(result.stderr or f'Installer test failed: {app["id"]}')
        if 'PASS ' not in result.stdout:
            raise RuntimeError(f'Installer test produced no success evidence: {app["id"]}')
        results.append({'app': app['id'], 'exit_code': result.returncode, 'evidence': result.stdout})
    report = release.RELEASE / 'lifecycle-check.json'
    report.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding='utf-8')
    print('Lifecycle results:', report)


if __name__ == '__main__':
    main()
