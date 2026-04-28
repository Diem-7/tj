# Current Task

## Mode

`review_task`

## Task

Review Slice 9a: JSON import behavior contract.

## Goal

Review the documented JSON import rules before implementation starts.

## Review Result

No findings.

## Reason

The binding documentation matches the approved import decisions: local record
wins for merge conflicts, replace is transactional, invalid files and invalid
rows reject the whole import, only `schemaVersion` 1 is accepted, and import
requires conscious user confirmation.

## Reviewed Scope

- `docs/system.md`
- `docs/open_questions.md`
- `docs/active/current_task.md`
- `docs/active/next_step.md`
- `docs/active/latest_handoff.md`

## Review Notes

- `docs/system.md` describes replace and merge behavior clearly.
- `docs/open_questions.md` no longer lists import merge conflicts as unresolved.
- Import behavior respects `no automatic overwrite`.
- Matching UUID conflict behavior is explicit.
- Invalid file and invalid row behavior is explicit.
- No SQL, repository, Riverpod, or UI implementation was added.
- No setup seed, setup selection, dashboard, or KPI behavior was changed.
- Git status shows only documentation files changed.

## Final Import Rules

- UUID conflict during merge: local record wins.
- Merge conflict rows: imported record is skipped.
- Replace: all v1 tables are cleared and reloaded in one transaction.
- Replace failure: rollback, no partial changes.
- Invalid file: reject whole file.
- Invalid row: reject whole file in v1.
- Schema version: only `schemaVersion` 1 is accepted.
- Import result reports `mode`, `accountsImported`, `instrumentsImported`,
  `setupsImported`, `tradesImported`, and `skippedConflicts`.
- Import never runs automatically.
- User must consciously confirm replace or merge.

## Not Changed

- app code
- database schema
- repositories
- export model shape
- dashboard behavior
- performance formulas
- stored performance KPIs
- setup seeds
- setup selection
- setup filtering
- setup management UI
- JSON import implementation
- recommendations, judging, optimization, or automation

## Open Questions

- Initial setup seeds are still undefined.
- Exact UI color tokens are still unapproved.

## Verification

No verification command was run. This review step covered documentation only.
