# Current Task

## Mode

`execute_task`

## Task

Implement Slice 3: Trades foundation.

## Goal

Add the first trade domain, persistence, provider, UI shell, and focused tests
without adding setups, filters, dashboard, export/import, or performance KPIs.

## Completed Scope

- added trade domain model with direction and session enums
- added trade domain logic:
  - `isClosed`
  - `isWin`
  - `isLoss`
  - `rMultiple`
- added trade input validation for required references and positive base values
- added SQLite version 3 migration for `trades`
- added trade mapper
- added trade repository contract and SQLite implementation
- wired Riverpod providers
- added simple German trade list shell
- added focused tests for trade persistence and domain logic

## Explicitly Not Changed

- setup table implementation
- setup seed selection
- filters
- performance calculations
- dashboard
- export/import
- recommendations, judging, optimization, or automation

## Acceptance Notes

- `trades` table follows `docs/database_model_v1.md`
- IDs are UUID strings stored as `TEXT`
- `setup_id` is nullable
- closed trade logic requires both `closed_at` and `exit_price`
- `r_multiple` is calculated in domain and not stored
- no stored performance KPIs were introduced
- UI contains no SQL
- domain contains no SQL and no UI
- all files stay under 300 lines

## Open Questions

- Initial setup seeds are still undefined.
- Setup selection must wait until setup seeds or empty setup behavior are
  explicitly approved.

## Verification

- `flutter pub get` passed
- `dart format .` passed with no changes
- `flutter analyze` passed with no issues
- `flutter test` passed
