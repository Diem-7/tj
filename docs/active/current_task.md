# Current Task

## Mode

`review_task`

## Task

Review Slice 6: Performance foundation.

## Goal

Check the implemented performance foundation against the binding documents
before dashboard work is defined.

## Review Result

No findings.

## Reviewed Scope

- central `PerformanceSummary` domain calculation
- exclusion of open, partial, and missing-`netPnl` trades
- net PnL, winrate, profit factor, average R, trade count, best trade, and
  worst trade rules
- Riverpod performance provider from filtered trades
- focused performance tests
- active handoff documentation

## Acceptance Notes

- Performance logic lives in the domain layer.
- UI and providers do not duplicate KPI formulas.
- SQL remains in the data layer only.
- Calculations use filtered closed trades.
- Open trades do not influence performance.
- Trades without both `closedAt` and `exitPrice` do not influence performance.
- Trades with null `netPnl` do not influence performance values.
- `tradeCount` counts only trades included in performance calculations.
- `netPnl` is the sum of included trade `netPnl` values.
- `winrate` is wins divided by included trade count.
- `profitFactor` is gross profit divided by absolute gross loss.
- `averageR` averages only non-null R values.
- `bestTrade` and `worstTrade` are selected by `netPnl`.
- No performance values are stored.
- No database migration was added.
- No dashboard UI was added.
- Code, database, and enum names remain English.
- All reviewed files stay under 300 lines.

## Open Questions

- Initial setup seeds are still undefined.
- Setup filtering remains out of scope until setup seed or empty setup behavior
  is approved.

## Verification

Already run after implementation:

- `flutter pub get` passed
- `dart format .` passed, 0 files changed
- `flutter analyze` passed with no issues
- `flutter test` passed
