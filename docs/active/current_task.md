# Current Task

## Mode

`review_task`

## Task

Review Slice 2: Instruments.

## Review Scope

- verify dependencies
- format changed Dart files
- run static analysis
- run tests
- review database version 2 migration
- review `instruments` table shape
- review idempotent `NQ` and `MNQ` seeds
- review data/domain/presentation boundaries
- review Riverpod provider wiring
- review simple German instrument UI
- confirm no trade, setup, filter, performance, dashboard, or export scope was added
- confirm every file stays under 300 lines

## Review Result

Review completed.

No code issues were found.

## Verification

Run after outside-sandbox approval:

- `flutter pub get` passed
- `dart format .` passed with no changes
- `flutter analyze` passed with no issues
- `flutter test` passed

## Open Questions

None for Slice 2.

Still open for later slices:

- initial setup seeds
- exact UI color tokens
- import merge conflict handling
