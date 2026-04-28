# Current Task

## Mode

`review_task`

## Task

Review Slice 12: import error messages show the concrete parser reason.

## Goal

Review the import error message change before defining the next slice.

## Review Result

No findings.

## Reviewed Scope

- `lib/presentation/import/import_button.dart`
- `lib/presentation/import/import_error_message.dart`
- `test/import_error_message_test.dart`
- active handoff documentation

## Review Notes

- `ImportButton` still owns the import workflow and now delegates only message
  formatting to a presentation helper.
- `importErrorMessage` surfaces `JournalImportException.message` without using
  the exception object's `toString`.
- `importErrorMessage` surfaces `FormatException.message` without showing noisy
  exception object text.
- Focused tests cover parser errors and malformed JSON errors.
- Import parser behavior did not change.
- Import execution behavior did not change.
- Import/export JSON format did not change.
- No SQL was added to UI code.
- No file exceeds 300 lines.

## What Did Not Change During Review

- app code
- tests
- SQLite schema
- repository contracts
- parser behavior
- import execution behavior
- import/export JSON format
- replace or merge behavior
- dashboard formulas
- trade edit or delete
- open trade creation
- auto-PnL calculation or suggestion
- setup seeds
- setup selection
- setup management UI
- recommendations, judging, optimization, or automation

## Open Questions

No blocking questions for Slice 12.

Non-blocking:

- Parser reasons are still English because code, database, and enums use English;
  the surrounding user-facing import failure text remains German.
- Existing invalid exports remain invalid; this slice only makes the reason
  visible.

## Verification

No verification command was run during review. Slice 12 verification was already
run during execute:

- `dart format .` passed, 0 files changed
- `flutter analyze` passed, no issues found
- `flutter test` passed, 39 tests
