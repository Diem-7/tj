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
Conflict handling for matching UUIDs is not defined yet.
