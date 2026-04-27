# Trading Journal - Agent Rules

## Product Boundary

This app is a local trading performance and decision journal.

Core sentence:

> Die App veraendert mein Verhalten nicht. Sie macht mein Verhalten sichtbar.

The app documents real trades, aggregates trade data, and visualizes performance.
It does not give recommendations, does not judge trades, does not optimize
behavior, and does not automate trading decisions.

## Binding Documents

The documents in `docs/` are the binding source for future work.

Primary documents:

- `docs/system.md`
- `docs/architecture.md`
- `docs/database_model_v1.md`
- `docs/domain_model_v1.md`
- `docs/design.md`
- `docs/workflow.md`
- `docs/open_questions.md`

If a requirement is unclear, stop and document the question before changing code.

## Architecture Rules

Required layers:

> Data -> Domain -> Presentation

Required flow:

> SQLite -> Repository -> Domain -> Riverpod -> UI

Rules:

- no SQL in UI
- no business logic in UI
- no UI in domain
- no duplicate truth
- no stored performance KPIs
- trades are the only source of truth

## Data Rules

- IDs are UUID strings stored as `TEXT`.
- Code, database, and enums use English.
- UI text uses German.
- `net_pnl` is the central performance value.
- Performance uses closed trades only.
- A trade is closed only when `closed_at` and `exit_price` are set.
- Time filters use `closed_at` only.

## Implementation Rules

- Work in small slices.
- Do not expand scope.
- Do not add undocumented features.
- Keep every file under 300 lines.
- One file has one purpose.
- Use clear, specific names.

## End Of Step Rule

At the end of every step, create or update a short handoff summary.

The summary must include:

- what changed
- what did not change
- open questions
- suggested commit message
- recommended next mode
- why that mode is recommended

Recommended modes:

- `define_task`
- `execute_task`
- `review_task`

## CLI Rules

Do not run build, verification, or dependency commands without explicit user
approval.

If verification is needed, name the local command and explain the reason.

Relevant commands:

- `flutter analyze`
- `flutter test`
- `dart format`
- `flutter pub get`
- `flutter build`
- `dart run`
