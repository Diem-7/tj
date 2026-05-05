# Next Step

## Recommended Next Mode

`review_task`

## Reason

Slice 14 has been implemented and verified in a small UI-only slice. It should
be reviewed before the next task is defined.

## Suggested Review Scope

- `lib/presentation/dashboard/dashboard_screen.dart`
- `docs/active/current_task.md`
- `docs/active/next_step.md`
- `docs/active/latest_handoff.md`

## Review Focus

- Dashboard filter controls are visible without duplicating filter logic.
- Dashboard and trade list still share `tradeFilterProvider`.
- Performance summary still flows through `performanceSummaryProvider`.
- Closed-trade and `closed_at` filter rules remain unchanged.
- No dashboard charts, new KPIs, schema changes, or trade workflow changes were
  added.
- No file exceeds 300 lines.

## Verification Already Run

- `flutter pub get` passed
- `dart format .` passed, 0 files changed
- `flutter analyze` passed, no issues found
- `flutter test` passed, 40 tests

## Keep Out Of Scope

- dashboard charts
- new performance metrics
- new dashboard formulas
- trade delete
- open trade creation
- setup selection
- setup management
- setup seeds
- schema changes
- import/export changes
- auto-PnL calculation or suggestion
- recommendations, judging, optimization, or trading decisions
