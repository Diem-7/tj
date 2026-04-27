# Current Task

## Mode

`define_task`

## Task

Define the next executable slice after documentation foundation.

## Proposed Next Slice

Slice 1: Foundation + Accounts

## Goal

Create the first real app foundation for local account management while staying
inside the documented product boundary.

The slice must establish:

- `lib/data`
- `lib/domain`
- `lib/presentation`
- SQLite database foundation
- `accounts` table using UUID `TEXT` IDs
- domain model for accounts
- account repository flow
- account create flow
- account list shown as cards

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

## Decisions Needed Before Execute

- approve `account_type` values: `combine`, `express_funded`, `live`
- approve SQLite package choice
- approve editable account fields after creation

## Proposed Defaults

- `account_type`: `combine`, `express_funded`, `live`
- SQLite package: `sqflite`
- account editing fields: `name`, `account_type`, `currency`, `initial_balance`,
  `is_active`

## Verification Commands For Execute Step

Do not run until approved:

- `flutter pub get` after dependency changes
- `dart format` after Dart file changes
- `flutter analyze` after implementation
- `flutter test` after implementation
