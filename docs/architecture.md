# Architecture v1

## Layers

Required architecture:

> Data -> Domain -> Presentation

Required flow:

> SQLite -> Repository -> Domain -> Riverpod -> UI

## Data Layer

Responsibilities:

- SQLite access
- schema and migrations
- database mapping
- repository implementations

Rules:

- no UI
- no presentation state
- no performance shortcuts

## Domain Layer

Responsibilities:

- entities
- value rules
- validation rules
- calculations

Rules:

- no SQL
- no UI
- no hidden logic

## Presentation Layer

Responsibilities:

- screens
- widgets
- German UI text
- visual state through Riverpod

Rules:

- no SQL
- no business logic
- no duplicate calculations

## Optional Application Layer

Use cases are allowed only when they clarify workflows.

Examples:

- create trade
- validate trade
- import data

Do not add this layer without a documented reason.

## Structure

Required base structure:

```text
lib/
  data/
  domain/
  presentation/
```

Additional folders require a clear purpose.

## Consistency

- same data means same result
- no stored KPIs
- no redundant truth
- trades are the only source of truth
