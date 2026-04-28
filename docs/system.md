# Trading Journal - System Document v1.0

## Product Identity

The app is a local trading performance and decision journal.

Goals:

- document real trades
- make performance visible
- make decisions traceable

The app must show a clear, honest, and complete picture of trading reality.

This means:

- every trade is traceable
- performance is objectively visible
- behavior can be evaluated
- development over time can be recognized

Core sentence:

> Die App veraendert mein Verhalten nicht. Sie macht mein Verhalten sichtbar.

Core principle:

> Trades -> Aggregation -> Visualisierung

## System Boundaries

The app:

- gives no trading recommendations
- does not judge
- does not optimize
- does not automate
- shows data only

## Version 1 Scope

Version 1 includes:

- accounts
- trades
- filters
- dashboard
- export and import

Supporting entities:

- instruments
- setups

## Accounts

Multiple accounts are possible.

Examples:

- Combine
- Express Funded
- Live

Functions:

- create
- edit
- active/inactive

Accounts are not deleted in v1.

Currency:

- field: `currency`
- stored per account
- default: `USD`

## Trades

Functions:

- create
- edit
- delete
- show

Trade fields:

- `account`
- `instrument`
- `opened_at`
- `closed_at`
- `direction`
- `entry_price`
- `exit_price`
- `stop_loss_price`
- `take_profit_price`
- `quantity`
- `risk_amount`
- `fees`
- `net_pnl`
- `r_multiple`
- `session`
- `setup`
- `rating`
- `notes`

`net_pnl` is the central truth.
`r_multiple` is calculated.

## Trade State

A trade is closed only when:

- `closed_at` is set
- `exit_price` is set

Both values must be set.
Only closed trades count for performance.

## Sessions

Internal values:

- `asia`
- `london`
- `new_york`

UI labels:

- Asia
- London
- New York

## Setups

Setups are predefined and selectable.
No free-text setup input is allowed.

Initial setup seeds are still open.

## Instruments

Instruments start as seeds and can become manageable later.

Initial seeds:

- `NQ`
- `MNQ`

## Validation

Required for all trades:

- `entry_price`
- `quantity > 0`
- `direction`

Required for closed trades:

- `exit_price`
- `closed_at`
- `net_pnl`

## Filters

Filterable by:

- time
- account
- instrument
- session

Rules:

- all analyses use filtered trades
- filter logic is central
- `closed_at` is authoritative
- time filters use only `closed_at`
- open trades are ignored

## Dashboard

Definition:

> visuelles Trading-Cockpit, keine Tabellen

Goal:

- Where do I stand?
- What works?
- What does not?

Core values:

- `net_pnl`
- equity: `initial_balance + net_pnl`
- equity curve

KPIs:

- winrate
- profit factor
- average R
- trade count

Additional views:

- progression
- sessions
- time periods
- best/worst

Account logic:

- default: all accounts
- account selection possible

Core sentence:

> Visuelles Gesamtbild meiner Performance in Sekunden

## Export And Import

Functions:

- JSON export
- JSON import
- `schemaVersion`

Structure:

```json
{
  "schemaVersion": 1,
  "exportedAt": "ISO8601",
  "app": "trading_journal",
  "data": {
    "accounts": [],
    "instruments": [],
    "setups": [],
    "trades": []
  }
}
```

Rules:

- user chooses replace or merge
- no automatic overwrite
- import never runs automatically
- user must consciously confirm replace or merge before data is changed
- only `schemaVersion` 1 is accepted
- unsupported schema versions are rejected before writing anything
- invalid files are rejected before writing anything
- invalid rows reject the whole file in v1

Replace rules:

- replace runs as one transaction
- all v1 tables are cleared first
- imported accounts, instruments, setups, and trades are inserted after clearing
- transaction commits only after all import rows were inserted successfully
- any error rolls back the full transaction
- no partial replace is allowed

Merge rules:

- merge inserts only records whose UUID does not already exist locally
- matching UUID conflicts keep the local record
- imported records with matching UUID conflicts are skipped
- merge never overwrites local records
- skipped conflicts are included in the import result

Import result:

- `mode`: `replace` or `merge`
- `accountsImported`
- `instrumentsImported`
- `setupsImported`
- `tradesImported`
- `skippedConflicts`

## Git Rules

Do not commit:

- `*.db`
- `*.sqlite`
- `*.sqlite3`
- `*_export_*.json`
- `/backups/`
- `/exports/`

## Language

- Code, database, and enums use English.
- UI text uses German.
