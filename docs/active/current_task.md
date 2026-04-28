# Current Task

## Mode

`review_task`

## Task

Review Slice 8a: Setup persistence foundation.

## Goal

Check the implemented setup persistence foundation against the binding
documents before export/import or setup UI work starts.

## Review Result

No findings.

## Reason

`Setup` is part of the binding v1 domain model and the `setups` table is part of
the binding v1 database model. Current implementation has `setup_id` on trades,
but no setup entity, table, mapper, or repository. Export/import requires a
stable data shape that includes `setups`, so this foundation should exist before
export data is produced.

## Scope

- add a `setups` table through a non-destructive database migration
- add a `Setup` domain entity
- add a setup repository interface
- add a SQLite setup repository implementation
- add a setup mapper
- expose setup listing through Riverpod if needed by the repository pattern
- keep setup seeds empty for now
- add focused tests for database migration/table creation and setup mapping or
  repository listing

## Out Of Scope

- setup selection in trade forms
- setup filtering
- setup create/edit/delete UI
- predefined setup seed names
- dashboard changes
- export/import implementation
- trading recommendations, judging, optimization, or automation
- UI color-token polishing

## Acceptance Criteria

- The SQLite schema includes `setups` with the fields from
  `docs/database_model_v1.md`.
- Existing databases migrate without data loss.
- Setup IDs are UUID strings stored as `TEXT`.
- Code, database fields, and enum-like values remain English.
- No setup seeds are inserted until names are approved.
- No SQL is added to UI files.
- No business logic is added to UI files.
- No performance KPI is stored.
- Trades remain the only source of performance truth.
- All touched files stay under 300 lines.
- Active handoff documentation is updated after implementation.

## Implementation Result

- Added the `setups` table to new databases.
- Added a version 4 migration that creates `setups` for existing databases.
- Added setup domain, mapper, SQLite repository, and Riverpod providers.
- Kept setup seeds empty because initial setup names are still undefined.
- Added focused tests for empty setup listing and v3-to-v4 migration.

## Reviewed Scope

- database version 4 migration for `setups`
- setup domain entity and repository interface
- SQLite setup mapper and repository
- setup Riverpod providers
- setup repository test
- database migration test
- active handoff documentation

## Acceptance Notes

- The SQLite schema includes `setups` with the fields from
  `docs/database_model_v1.md`.
- Existing database migration is covered by a focused v3-to-v4 test.
- No setup seeds were inserted.
- No SQL was added to UI files.
- No business logic was added to UI files.
- No performance KPI was stored.
- Trades remain the only source of performance truth.
- Setup selection, filtering, management UI, and export/import remain out of
  scope.
- All touched files stay under 300 lines.

## Open Questions

- Initial setup seeds are still undefined.
- Setup selection behavior remains out of scope until setup seed or empty setup
  behavior is approved.
- Exact UI color tokens are still unapproved.

## Verification

- `dart format .` passed, 0 files changed
- `flutter analyze` passed with no issues
- `flutter test` passed
