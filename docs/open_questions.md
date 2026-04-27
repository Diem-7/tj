# Open Questions

## Account Type Values

The database requires `account_type`.

Possible values from the system examples:

- `combine`
- `express_funded`
- `live`

Needs confirmation before implementing accounts.

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
The exact Flutter package is not approved yet.

Needs confirmation before adding dependencies.

## Account Editing Fields

Accounts can be edited.
It is not defined which fields are editable after creation.

Fields needing decision:

- `account_type`
- `currency`
- `initial_balance`

## Import Merge Conflicts

Import supports replace or merge.
Conflict handling for matching UUIDs is not defined yet.
