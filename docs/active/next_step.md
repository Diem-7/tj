# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 8b is implemented, verified, and reviewed with no findings. The next
slice needs exact scope definition before import, file save UI, setup workflow,
or additional dashboard work begins.

## Suggested Next Definition Scope

- decide whether the next slice is export file save UI, JSON import definition,
  setup seed definition, setup selection, or dashboard expansion
- define import merge or replace behavior before implementing JSON import
- keep setup filtering out of scope until setup seed behavior is approved
- keep dashboard expansion out of scope unless the next slice explicitly targets
  it

## Do Not Implement Yet

- JSON import
- replace or merge behavior
- import conflict handling
- file picker or filesystem save UI
- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- dashboard charts
- equity curve
- account equity calculation
- time-period grouping
- session breakdowns
- recommendations, judging, optimization, or automation

## Verification Already Run For Slice 8b

- `dart format .` passed, 1 file changed
- `flutter analyze` passed with no issues
- `flutter test` passed
