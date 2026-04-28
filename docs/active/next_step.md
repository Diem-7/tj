# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 7 is implemented, verified, and reviewed with no findings. The next slice
needs exact scope definition before any chart, equity, export, or further
dashboard work begins.

## Suggested Next Definition Scope

- decide whether the next slice is dashboard progression, dashboard sessions,
  equity curve, or export/import
- define the exact displayed values before implementation
- document any needed domain calculation before UI work
- keep all displayed values derived from trades
- keep setup filtering out of scope until setup seed behavior is approved

## Do Not Implement Yet

- charts
- equity curve
- account equity calculation
- time-period grouping
- session breakdowns
- setup filtering or setup selection
- export/import
- recommendations, judging, optimization, or automation

## Verification Already Run For Slice 7

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
