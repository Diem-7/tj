# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 9c is implemented, verified, and reviewed with no findings. The next
import slice should be defined before provider or UI work begins.

## Suggested Next Definition Scope

- define the next JSON import integration slice
- likely decide whether the next slice is:
  - Riverpod import provider wiring around parser and executor
  - or import confirmation/file picker UI
- keep user confirmation explicit before replace or merge can mutate data
- keep parser and executor contracts stable unless review finds a concrete need
- keep dashboard, setup, and performance work out of scope

## Do Not Implement Yet

- file picker import UI
- Riverpod import providers
- import confirmation dialogs
- dashboard charts
- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- recommendations, judging, optimization, or automation

## Verification Already Run

For Slice 9c:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
