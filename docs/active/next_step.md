# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 14 is implemented, verified, and reviewed with no findings. The next
slice should be defined explicitly before more code changes begin.

## Suggested Next Definition Scope

Recommended next slice:

- define the next smallest dashboard, filter, or trade workflow improvement from
  the binding docs
- keep trade delete out of scope unless explicitly selected
- keep open trade creation out of scope unless explicitly selected
- keep setup selection out of scope until setup seeds are confirmed
- keep dashboard charts out of scope unless explicitly selected
- keep auto-PnL calculation or suggestion out of scope
- keep schema changes and import/export format changes out of scope unless
  selected as the next slice

## Do Not Implement Yet

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

For Slice 14:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
