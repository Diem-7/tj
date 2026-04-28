# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 8c is implemented and reviewed with no findings. The next slice should be
defined before import, setup workflow, dashboard expansion, or export/import
conflict behavior is changed.

## Suggested Next Definition Scope

- decide whether the next slice is JSON import definition, setup seed
  definition, setup selection, setup management, or dashboard expansion
- define import replace, merge, and conflict behavior before implementing JSON
  import
- keep setup selection and setup filtering out of scope until setup seed or
  empty setup behavior is approved
- keep dashboard expansion out of scope unless the next slice explicitly targets
  it

## Do Not Implement Yet

- JSON import
- replace or merge behavior
- import conflict handling
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

## Verification Already Run For Slice 8c

- `flutter pub get` passed
- `dart format .` passed, 1 file changed
- `flutter analyze` passed with no issues
- `flutter test` passed
