# Database Model v1

## General Rules

- Database: SQLite.
- Schema is versioned.
- Changes happen only through migrations.
- No data loss through migrations.
- IDs are UUID strings stored as `TEXT`.
- Do not store calculated performance values.
- Trades are the only source of truth.

## Tables

Version 1 tables:

- `accounts`
- `instruments`
- `setups`
- `trades`

## accounts

Required fields:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `account_type TEXT NOT NULL`
- `currency TEXT NOT NULL DEFAULT 'USD'`
- `initial_balance REAL NOT NULL`
- `is_active INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Rules:

- `id` is a UUID string.
- `is_active` stores boolean values as `0` or `1`.
- Accounts are not deleted in v1.
- Accounts can be active or inactive.

## instruments

Required fields:

- `id TEXT PRIMARY KEY`
- `symbol TEXT NOT NULL`
- `name TEXT`
- `is_active INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Initial seeds:

- `NQ`
- `MNQ`

## setups

Required fields:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `is_active INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Rules:

- Setups are predefined.
- Setups are selected, not freely typed.
- Initial setup seeds are still open.

## trades

Required fields:

- `id TEXT PRIMARY KEY`
- `account_id TEXT NOT NULL`
- `instrument_id TEXT NOT NULL`
- `setup_id TEXT`
- `opened_at TEXT NOT NULL`
- `closed_at TEXT`
- `direction TEXT NOT NULL`
- `entry_price REAL NOT NULL`
- `exit_price REAL`
- `stop_loss_price REAL`
- `take_profit_price REAL`
- `quantity REAL NOT NULL`
- `risk_amount REAL`
- `fees REAL`
- `net_pnl REAL`
- `session TEXT`
- `rating INTEGER`
- `notes TEXT`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Rules:

- `direction` values: `long`, `short`.
- `session` values: `asia`, `london`, `new_york`.
- `net_pnl` is the central performance value.
- `r_multiple` is not stored.

## Calculations

`r_multiple`:

```text
net_pnl / risk_amount
```

Null rules:

- no `risk_amount` means no R value
- no `net_pnl` means no performance influence
- no `closed_at` means ignored for performance

## Closed Trade Rule

A trade is closed only when:

- `closed_at` is set
- `exit_price` is set

Only closed trades count for performance.
