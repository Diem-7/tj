# Current Task

## Mode

`define_task`

## Task

Define Slice 2: Instruments.

## Goal

Add the documented instrument foundation after Slice 1.

The slice should make instruments available as real persisted reference data
without introducing trades, filters, performance, dashboard, setups, or export.

## Scope

- add `Instrument` domain model
- add instrument repository contract
- add SQLite `instruments` table through a schema migration
- seed initial instruments `NQ` and `MNQ`
- add SQLite instrument repository and mapper
- add Riverpod providers for instruments
- add a simple German instrument list UI
- keep existing account behavior unchanged

## Out Of Scope

- trade creation
- setup selection
- filters
- performance calculations
- dashboard changes
- import/export
- instrument edit or delete workflows unless explicitly approved later
- unmanaged free-text instruments

## Acceptance Criteria

- `instruments` table uses UUID `TEXT` IDs
- stored fields match `docs/database_model_v1.md`
- seed data contains `NQ` and `MNQ`
- seeding is idempotent
- UI text is German
- code and database names are English
- no SQL appears in UI
- no business logic appears in UI
- no file exceeds 300 lines
- existing account slice remains functional

## Verification Needed In Execute Task

After implementation, Codex should initiate these commands with explicit
outside-sandbox approval:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

## Open Questions

None for this slice.

Initial setup seeds remain open, but setups are out of scope.
