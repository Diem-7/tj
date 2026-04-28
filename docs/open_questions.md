# Open Questions

## Account Type Values

Resolved for Slice 1.

Approved values:

- `combine`
- `express_funded`
- `live`
- `demo`
- `other`

## Initial Setup Seeds

Setups must be predefined and selectable.

Current state:

- setup seeds are not fixed
- setups may start empty or with a few own setups

Needs confirmation before implementing setup selection.

## Exact UI Color Tokens

Approved direction:

- dark blue
- glassmorphism
- cards
- premium trading cockpit

Exact colors are not approved yet.

## SQLite Package Choice

SQLite is required.

Resolved for Slice 1:

- `sqflite_common_ffi`

## Account Editing Fields

Accounts can be edited.

Resolved for Slice 1.

Approved editable fields:

- `name`
- `account_type`
- `currency`
- `initial_balance`
- `is_active`

## Import Merge Conflicts

Import supports replace or merge.

Resolved for Slice 9a.

Approved behavior:

- local record wins
- imported matching UUID is skipped
- merge never overwrites local records
- skipped conflicts are reported in the import result

Related approved import rules:

- replace runs as one transaction
- replace clears all v1 tables, inserts import data, then commits
- replace rolls back completely on error
- invalid files reject the whole import
- invalid rows reject the whole import in v1
- only `schemaVersion` 1 is accepted
- import never runs automatically
- user must consciously confirm replace or merge
