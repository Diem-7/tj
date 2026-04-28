# Current Task

## Mode

`review_task`

## Task

Review Slice 8b: JSON export foundation.

## Goal

Review the read-only JSON export foundation against the binding documents before
import, file save UI, setup workflow, or dashboard work starts.

## Review Result

No findings.

## Reason

The export foundation should preserve journal data in the documented JSON shape
without creating duplicate performance truth, import write behavior, or UI-layer
business logic.

## Reviewed Scope

- `lib/domain/export/journal_export.dart`
- `lib/domain/export/journal_export_service.dart`
- `test/journal_export_service_test.dart`
- active handoff documentation

## Acceptance Notes

- Export JSON has the required top-level keys: `schemaVersion`, `exportedAt`,
  `app`, and `data`.
- Export data includes `accounts`, `instruments`, `setups`, and `trades`.
- Export generation reads through repository interfaces.
- No SQL was added to UI files.
- No export business logic was added to UI files.
- No import write behavior was added.
- No replace or merge behavior was added.
- No performance KPI is stored or exported as stored truth.
- `r_multiple` is not exported.
- `net_pnl` remains the central performance value on trades.
- Code and JSON keys remain English.
- All touched files stay under 300 lines.

## Not Changed

- database schema
- existing repositories
- UI screens
- dashboard
- performance formulas
- stored performance KPIs
- setup seeds
- setup selection
- setup filtering
- setup management UI
- JSON import
- import merge or replace behavior
- trading recommendations, judging, optimization, or automation

## Open Questions

- Import merge conflict handling for matching UUIDs remains undefined.
- Initial setup seeds are still undefined.
- Setup selection behavior remains out of scope until setup seed or empty setup
  behavior is approved.
- Exact UI color tokens are still unapproved.

## Verification

- `dart format .` passed, 1 file changed
- `flutter analyze` passed with no issues
- `flutter test` passed
