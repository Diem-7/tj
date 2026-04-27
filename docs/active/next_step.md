# Next Step

## Required Review

Review the Slice 1 implementation.

Recommended local verification commands, if approved:

- `flutter pub get` to resolve the new dependencies
- `dart format` to format changed Dart files
- `flutter analyze` to check static issues
- `flutter test` to run the widget test

## Recommended Next Mode

`review_task`

## Reason

Slice 1 code has been implemented, but dependency resolution and verification
were not run because those commands require explicit approval.

## Review Focus

- layer boundaries: Data -> Domain -> Presentation
- SQLite schema matches `docs/database_model_v1.md`
- no SQL in UI
- no performance or trade scope added
- all files stay under 300 lines
