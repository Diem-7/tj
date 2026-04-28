# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 6 is implemented, verified, and reviewed with no findings. The next slice
needs exact scope definition before dashboard work begins.

## Suggested Next Definition Scope

- define Slice 7 Dashboard
- decide which performance values appear in the first dashboard view
- decide whether the first dashboard slice includes only KPI cards or also one
  chart
- keep all displayed values derived from `performanceSummaryProvider`
- document included and excluded dashboard UI behavior before implementation
- keep equity curve separate unless explicitly included

## Do Not Implement Yet

- dashboard code
- charts
- equity curve
- account equity calculation
- time-period grouping
- session breakdowns
- setup filter or setup selection
- export/import
- recommendations, judging, optimization, or automation

## Verification Already Run For Slice 6

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
