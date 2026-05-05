# Next Step

## Recommended Next Mode

`review_task`

## Reason

Slice 17 has been implemented and should be reviewed after verification. The
review should focus on layout stability, real curve data, and keeping the slice
inside the dashboard-only boundary.

## Review Scope

Review:

- dashboard spacing and hierarchy
- fixed card heights and responsive stacking
- absence of fragile dashboard grids
- reduced glow and clearer borders
- real cumulative `netPnl` curve data
- unchanged Data -> Domain -> Presentation flow
- file length rule

## Do Not Add During Review

- new features
- schema changes
- import/export changes
- trade workflow changes
- setup selection
- recommendations, judgement, optimization, or automation

## Verification

Completed for Slice 17:

- `dart format .` passed
- `flutter analyze` passed, no issues found
- `flutter test` passed, 42 tests
