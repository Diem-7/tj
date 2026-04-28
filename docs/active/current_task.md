# Current Task

## Mode

`review_task`

## Task

Review Slice 8c: JSON export file-save UI.

## Goal

Review the dashboard export action, Riverpod wiring, `file_selector`
dependency, generated plugin registrants, and handoff documentation before
starting import, setup workflow, or dashboard expansion.

## Review Result

No findings.

## Reason

The implementation exposes the existing export foundation through presentation
code without adding SQL to UI, performance shortcuts, import behavior, merge
behavior, or trading recommendations.

## Reviewed Scope

- `pubspec.yaml`
- `pubspec.lock`
- generated desktop plugin registrants
- `lib/presentation/export/export_providers.dart`
- `lib/presentation/export/export_action.dart`
- `lib/presentation/dashboard/dashboard_screen.dart`
- active handoff documentation

## Acceptance Notes

- Export action is reachable from the dashboard app bar.
- Export generation uses `JournalExportService`.
- `JournalExportService` is wired through repository providers.
- Export JSON shape remains owned by `JournalExport.toJson()`.
- Formatted JSON is saved through `file_selector`.
- UI feedback text is German.
- No SQL was added to UI files.
- No performance calculation was added to UI files.
- No import, replace, merge, or conflict handling was added.
- No stored performance KPIs were added.
- `r_multiple` is not exported by the export model.
- Desktop plugin registrants match the added `file_selector` package.

## Not Changed

- database schema
- existing repositories
- existing export model shape
- account behavior
- instrument behavior
- trade behavior
- dashboard performance behavior
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
- Exact UI color tokens are still unapproved.

## Verification

Not rerun during review.

Previously documented for Slice 8c:

- `flutter pub get` passed
- `dart format .` passed, 1 file changed
- `flutter analyze` passed with no issues
- `flutter test` passed
