# Next Step

## Recommended Next Mode

`define_task`

## Reason

Slice 9b and its UUID validation fix are reviewed with no findings. The next
import implementation slice should be defined before database replace, merge,
transaction, provider, or UI work begins.

## Suggested Next Definition Scope

- define the next JSON import implementation slice
- likely define non-UI import execution contracts for replace or merge
- keep database mutation scope explicit and transactional
- keep file picker UI out of scope until import execution contracts are stable
- avoid adding large logic to `journal_import_parser.dart`, which is close to
  the file size limit

## Do Not Implement Yet

- file picker import UI
- Riverpod import providers
- dashboard charts
- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- recommendations, judging, optimization, or automation

## Verification Already Run

For the UUID validation fix:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
