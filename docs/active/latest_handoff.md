# Latest Handoff

## Summary

Slice 11 was reviewed with no findings. Closed trade input now consistently
requires `netPnl`, partial closed state is rejected, and the manual trade dialog
requires `Netto PnL` for the current closed-trade creation flow.

## Files Changed

- `docs/active/current_task.md`
- `docs/active/next_step.md`
- `docs/active/latest_handoff.md`

## Code Reviewed

- `lib/domain/trades/trade_input.dart`
- `lib/presentation/trades/trade_create_dialog.dart`
- `test/trade_domain_test.dart`

## Review Findings

No findings.

## Review Notes

- Domain validation rejects partial closed state.
- Domain validation rejects closed trade input without `netPnl`.
- Manual trade creation no longer treats `Netto PnL` as optional.
- Tests cover the new validation cases.
- Import behavior and import/export formats did not change.
- Trade edit, trade delete, open trade creation, auto-PnL, and import error UX
  stayed out of scope.
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

## Suggested Commit Message

```text
fix: require net pnl for closed trades
```

## Recommended Next Mode

`define_task`

## Reason

The validation fix is complete and reviewed. The next stabilization slice should
be defined explicitly before implementation starts.
