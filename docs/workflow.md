# Workflow

## Principle

Work in small steps:

> denken -> bauen

## Modes

Modes:

- `define_task`
- `execute_task`
- `review_task`

No implementation starts before the task is defined and accepted.

## Slice Order

Required order:

1. Foundation
2. Accounts
3. Instruments
4. Trades
5. Filter
6. Performance
7. Dashboard
8. Export

## Slice 1

Slice 1 is foundation plus accounts only.

Included:

- documents
- project structure
- SQLite foundation
- correct `accounts` table with UUID/TEXT IDs
- account create
- account list

Excluded:

- dashboard
- trades
- performance KPIs
- fake performance data

## Definition Of Done

A slice is done when:

- it runs stable
- logic is correct
- rules are followed
- documentation is updated
- no file exceeds 300 lines

## End Of Step Summary

At the end of every step, create a handoff summary.

The summary must include:

- summary of completed work
- files changed
- what was not changed
- open questions
- suggested commit message
- recommended next mode
- reason for the next mode

Example:

```text
Suggested commit message:
docs: initialize trading journal project rules

Recommended next mode:
define_task

Reason:
The next implementation slice needs exact scope approval before code changes.
```

## Verification

Verification is local.

Commands may be needed:

- `flutter analyze`
- `flutter test`
- `dart format`
- `flutter pub get`
- `flutter build`
- `dart run`

Codex must initiate verification commands itself, but only with explicit
approval for execution outside the sandbox.

Codex must:

- start the command itself
- request approval for execution outside the sandbox
- wait for approval
- run the command after approval
- not silently skip verification commands
- not ask the user to run the command manually

After `execute_task`, Codex should automatically run:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

These commands must run outside the sandbox after approval.

## Stop Rules

Stop when:

- a name is unclear
- a file would exceed 300 lines
- structure would be violated
- requirements are unclear
- implementation would require guessing
