# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 9d is implemented, verified, and reviewed with no findings. The next
import slice should be defined before UI work begins so file picking,
confirmation, and mutation timing stay explicit.

## Suggested Next Definition Scope

- define the next JSON import UI integration slice
- likely focus on import file picker plus preview/confirmation boundary
- require explicit user choice between replace and merge before mutation
- use the existing `importActionProvider`
- keep parser, executor, and provider contracts stable unless review finds a
  concrete need
- keep dashboard, setup, and performance work out of scope

## Do Not Implement Yet

- dashboard charts
- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- recommendations, judging, optimization, or automation

## Verification Already Run

For Slice 9d:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
