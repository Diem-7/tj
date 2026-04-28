# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 11 is implemented, verified, and reviewed with no findings. The next
stabilization slice should be defined before more code changes begin.

## Suggested Next Definition Scope

Recommended next slice:

- improve import error messages so the concrete parser reason is visible
- keep import behavior and import/export format unchanged
- keep trade edit, auto-PnL, dashboard, schema, and setup work out of scope
- add or update focused tests for import error display behavior

## Next Priority After That

- add minimal trade edit UI
- consider auto-PnL suggestion only after validation and import UX are stable

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

For Slice 11:

- `dart format .`
- `flutter analyze`
- `flutter test`
