# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 17 has been implemented, verified, and reviewed with no findings. The
next slice should be defined explicitly before more code changes begin.

## Suggested Next Definition Scope

Recommended next slice:

- define the next smallest dashboard, filter, trade workflow, import/export, or
  cleanup improvement from the binding docs
- keep the current dashboard direction intact
- keep trade delete out of scope unless explicitly selected
- keep setup selection out of scope until setup seeds are confirmed
- keep schema changes and import/export format changes out of scope unless
  selected as the next slice

Possible small cleanup candidates:

- add direct tests for `equityPoints`
- split `trade_form_dialog.dart` below the 300-line target
- define app-wide color tokens

## Do Not Implement Yet

- trade delete
- setup selection
- setup management
- schema changes
- import/export format changes
- auto-PnL calculation
- recommendations, judgement, optimization, or trading decisions

## Verification Already Run

For the reviewed state:

- `flutter analyze`
- `flutter test`
