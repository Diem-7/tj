# Current Task

## Mode

`execute_task`

## Task

Execute Slice 14: dashboard filter visibility.

## Goal

Make the dashboard's filtered performance context visible and directly
controllable from the dashboard, using the already existing central trade
filter state.

## Implementation

The dashboard now renders the existing `TradeFilterControls` above the
performance content.

## Scope Completed

- Exposed the existing filter controls on the dashboard.
- Kept one shared filter state for trades and dashboard.
- Kept dashboard metrics based on `performanceSummaryProvider`.
- Kept filter behavior based on closed trades and `closed_at`.
- Kept UI text in German.

## What Did Not Change

- filter logic
- stored KPIs
- SQL usage
- dashboard charts
- performance metrics
- dashboard formulas
- SQLite schema
- import/export behavior
- trade delete
- open trade creation
- setup selection
- setup management
- setup seeds
- auto-PnL calculation or suggestion
- recommendations, judging, optimization, or automation

## Open Questions

No blocking questions.

Non-blocking:

- The existing filter controls remain in `presentation/trades`. Reuse was kept
  as-is for this small slice because the controls already represent the central
  trade filter state and no new shared abstraction was needed.
- Setup seeds and setup selection remain unresolved and out of scope.
- Exact UI color tokens remain unresolved and out of scope.

## Verification

Completed:

- `flutter pub get` passed
- `dart format .` passed, 0 files changed
- `flutter analyze` passed, no issues found
- `flutter test` passed, 40 tests
