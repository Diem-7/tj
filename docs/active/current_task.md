# Current Task

## Mode

`review_task`

## Task

Review Slice 9c: JSON import execution contracts.

## Goal

Review the non-UI JSON import execution slice before any Riverpod provider,
file picker UI, confirmation dialog, or unrelated workflow work starts.

## Review Result

No findings.

## Reviewed Scope

- `lib/domain/import/journal_import_execution.dart`
- `lib/data/import/sqlite_journal_import_executor.dart`
- `lib/data/instruments/instrument_mapper.dart`
- `lib/data/setups/setup_mapper.dart`
- `test/journal_import_executor_test.dart`
- active handoff documentation

## Review Notes

- `JournalImportMode` and `JournalImportResult` provide the defined execution
  contract without UI or Riverpod coupling.
- Replace runs inside one SQLite transaction.
- Replace clears all v1 tables in dependency-safe order before inserting import
  rows.
- Replace rollback is covered by a duplicate primary key insert test.
- Merge runs inside one SQLite transaction.
- Merge checks conflicts by UUID per v1 table.
- Merge keeps local records when UUIDs match and skips imported conflicts.
- Merge result counts match imported rows and skipped conflicts in tests.
- Import execution remains outside `journal_import_parser.dart`.
- SQL and database mutation remain in the data layer.
- No file exceeds 300 lines.

## What Did Not Change During Review

- app code
- SQLite schema
- parser behavior
- repository contracts
- Riverpod providers
- import UI
- export model shape
- dashboard behavior
- performance formulas
- stored performance KPIs
- setup seeds
- setup selection
- setup filtering
- setup management UI
- recommendations, judging, optimization, or automation

## Open Questions

No blocking questions for Slice 9c.

Non-blocking:

- Initial setup seeds are still undefined, but not relevant for the reviewed
  import execution slice.
- Exact UI color tokens are still unapproved, but not relevant for the reviewed
  import execution slice.

## Verification

No verification command was run during review. Slice 9c verification was already
run during execute:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
