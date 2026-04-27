# Current Task

## Mode

`execute_task`

## Task

Implement Slice 2: Instruments.

## Result

Implementation completed.

## Completed Scope

- added `Instrument` domain model
- added instrument repository contract
- added SQLite `instruments` table in database version 2
- added migration from database version 1 to version 2
- seeded initial instruments `NQ` and `MNQ`
- added SQLite instrument mapper and repository
- added Riverpod providers for instruments
- added simple German instrument list UI
- added bottom navigation for accounts and instruments
- added database test for instrument seeds
- updated widget test for the new navigation

## Out Of Scope Kept

- trade creation
- setup selection
- filters
- performance calculations
- dashboard changes
- import/export
- instrument edit or delete workflows
- free-text instrument creation

## Verification

Run after outside-sandbox approval:

- `flutter pub get` passed
- `dart format .` passed
- `flutter analyze` passed with no issues
- `flutter test` passed

## Open Questions

None for Slice 2.

Still open for later slices:

- initial setup seeds
- exact UI color tokens
- import merge conflict handling
