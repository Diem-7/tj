# Current Task

## Mode

`execute_task`

## Task

Implement Slice 1: Foundation + Accounts.

## Approved Scope

- create `lib/data`
- create `lib/domain`
- create `lib/presentation`
- add SQLite database foundation
- use `sqflite_common_ffi`
- create the `accounts` table with UUID `TEXT` IDs
- support `account_type` values:
  - `combine`
  - `express_funded`
  - `live`
  - `demo`
  - `other`
- add account domain model and validation
- add account repository flow
- add account create flow
- add account list as cards
- use German UI text

## Approved Editable Account Fields

- `name`
- `account_type`
- `currency`
- `initial_balance`
- `is_active`

## Explicit Non-Scope

Do not add:

- trades
- instruments management
- setup management
- filters
- dashboard
- performance KPIs
- export/import
- recommendations or behavior scoring
- fake performance data

## Verification Commands

Not run in this step because CLI rules require explicit command approval:

- `flutter pub get`
- `dart format`
- `flutter analyze`
- `flutter test`
