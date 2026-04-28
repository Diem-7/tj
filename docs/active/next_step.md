# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 12 is implemented, verified, and reviewed with no findings. The next
slice should be defined before more code changes begin.

## Suggested Next Definition Scope

Recommended next slice:

- add minimal trade edit UI for existing trades
- keep trade delete out of scope
- keep open trade creation out of scope unless it is required for edit reuse and
  explicitly documented
- keep auto-PnL calculation or suggestion out of scope
- keep setup selection or management out of scope
- keep dashboard charts, schema changes, and import/export format changes out of
  scope

## Do Not Implement Yet

- trade edit
- trade delete
- open trade creation
- auto-PnL calculation or suggestion
- setup selection
- setup management
- dashboard charts
- schema changes
- import/export format changes
- recommendations, judging, optimization, or trading decisions

## Verification Already Run

For Slice 12:

- `dart format .`
- `flutter analyze`
- `flutter test`
