# Current Task

## Mode

`execute_task`

## Task

Execute Slice 17: Dashboard layout tightening + responsiveness.

## Goal

Tighten the existing dashboard overhaul without changing product scope,
repository flow, or the overall cockpit direction.

## Implementation Result

Implemented:

- reduced dashboard spacing and header scale
- aligned hero and KPI block heights on desktop
- replaced KPI `GridView.count` with fixed-height responsive rows/columns
- replaced session `GridView.count` with fixed-height responsive rows/columns
- reduced glow and shadow strength in shared dashboard panels
- made panel borders clearer and more structural
- tightened best/worst panel height and internal spacing
- added real cumulative `netPnl` sparkline data to performance summaries
- rendered hero and session sparklines from filtered closed trades only

## Equity Curve Rule

Implemented without fake curves.

Visible curves now use `PerformanceSummary.equityPoints` and
`SessionPerformanceSummary.equityPoints`.

Those points are derived from trades already passed into
`performanceSummaryProvider`:

- closed trades only
- `netPnl` required
- sorted by `closedAt`
- cumulative `netPnl`
- no stored KPI or curve values

## Files Changed

- `lib/domain/performance/performance_summary.dart`
- `lib/presentation/dashboard/dashboard_screen.dart`
- `lib/presentation/dashboard/dashboard_cards.dart`
- `lib/presentation/dashboard/dashboard_best_worst.dart`
- `lib/presentation/dashboard/dashboard_style.dart`
- `lib/presentation/dashboard/session_breakdown.dart`
- `docs/active/current_task.md`
- `docs/active/next_step.md`
- `docs/active/latest_handoff.md`

## What Did Not Change

- SQLite schema
- repositories
- provider flow
- filter logic
- import/export behavior
- trade create/edit/delete behavior
- setup selection or setup management
- auto-PnL calculation
- recommendations, judgement, optimization, or automation

## Open Questions

No blocking questions.

Non-blocking:

- Exact app-wide color tokens are still not globally approved.

## Verification

Completed:

- `dart format .` passed
- `flutter analyze` passed, no issues found
- `flutter test` passed, 42 tests
