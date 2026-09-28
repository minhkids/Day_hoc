# Preschool UI 1.0.1 — 2026-09-24

The redesign reduces home actions to four, groups all 14 navigation entries,
shortens form headings and buttons, collapses supporting templates and specialist
legal tools, replaces legal category buttons with a dropdown, and groups child
health, family and address fields into expandable sections. Existing field keys,
save handlers and storage behavior are retained.

## Validation

- Source WPF: 14 pages, no dispatcher errors. Checks include home shortcut,
  expanded template selection, three child detail groups, legal category selection,
  settings, record creation/editing, document saving and Office exports.
- Screenshots taken at normal size and 1060 × 700; long pages remain scrollable.
- Unit suite: 10/11 passed. `test_legal_link_verification_mechanism` failed at
  the existing assertion that a live external URL must be valid. External HTTP
  requests were refused in this environment. This release does not establish
  the validity of online legal sources.
- Installer build and `--self-check`: passed; version 1.0.1.
- Packaged EXE: all 14 pages and the same action checks passed, clean exit;
  evidence in `packaged/result.json` and screenshots alongside it.
- AI UI: Send → simulated provider → answer → editor → saved document passed.
  Real OpenRouter was not called.
- Packaged WPF assets: no Claude/Anthropic text matches.

Artifacts: `exe/TroLyGiaoVienMamNon-Setup.exe` and
`exe/TroLyGiaoVienMamNon/TroLyGiaoVienMamNon.exe`.
