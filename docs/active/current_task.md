# Current Task

## Mode

`review_task`

## Task

Review Slice 11: closed trade net PnL validation.

## Goal

Review the validation fix before starting the next stabilization slice.

## Review Result

No findings.

## Reviewed Scope

- `lib/domain/trades/trade_input.dart`
- `lib/presentation/trades/trade_create_dialog.dart`
- `test/trade_domain_test.dart`
- active handoff documentation

## Review Notes

- `TradeInput.validate` rejects partial closed state.
- `TradeInput.validate` rejects closed trades without `netPnl`.
- Closed manual trade creation parses `Netto PnL` as required.
- Focused tests cover partial closed state, missing `netPnl`, and valid closed
  trade input.
- Import behavior and import/export formats were not changed.
- Trade edit, trade delete, open trade creation, auto-PnL, and import error UX
  stayed out of scope.
- UI code contains no SQL.
- No file exceeds 300 lines.

## What Did Not Change During Review

- app code
- SQLite schema
- repository contracts
- import behavior
- export format
- dashboard formulas
- trade edit or delete
- open trade creation
- auto-PnL calculation or suggestion
- setup seeds
- setup selection
- setup management UI
- recommendations, judging, optimization, or automation

## Open Questions

No blocking questions for Slice 11.

Non-blocking:

- Existing invalid local trades are not repaired by this slice.
- Import error messages remain the next critical UX issue.
- Old invalid export files remain invalid until data is corrected or a separate
  repair/import strategy exists.

## Verification

No verification command was run during review. Slice 11 verification was already
run during execute:

- `dart format .` passed
- `flutter analyze` passed with no issues
- `flutter test` passed, 37 tests
