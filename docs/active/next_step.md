# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 9e is implemented, verified, and reviewed with no findings. The next
slice should be defined before adding more import workflow, dashboard, or setup
work.

## Suggested Next Definition Scope

- decide the next smallest product slice
- keep dashboard charts, setup selection, setup filtering, and setup management
  out of scope unless explicitly selected
- preserve the import rules already implemented and reviewed
- keep the Data -> Domain -> Presentation layering intact

## Do Not Implement Yet

- dashboard charts
- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- recommendations, judging, optimization, or automation

## Verification Already Run

For Slice 9e:

- `dart format .`
- `flutter analyze`
- `flutter test`
