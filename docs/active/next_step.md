# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 8a is implemented, verified, and reviewed with no findings. The next
slice needs exact scope definition before export/import, setup selection, or
additional dashboard work begins.

## Suggested Next Definition Scope

- decide whether the next slice is export foundation, setup seed definition, or
  setup selection
- define the exact data shape before export/import implementation
- keep merge conflict behavior out of scope unless it is explicitly defined
- keep setup filtering out of scope until setup seed behavior is approved

## Do Not Implement Yet

- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- dashboard charts
- equity curve
- account equity calculation
- time-period grouping
- session breakdowns
- export/import
- recommendations, judging, optimization, or automation

## Verification Already Run For Slice 8a

- `dart format .`
- `flutter analyze`
- `flutter test`
