# Next Step

## Recommended Next Mode

`review_task`

## Reason

Slice 2 has been implemented and verified. A review should check boundaries,
migration behavior, seed correctness, UI scope, and file sizes before moving to
the next slice.

## Review Target

Slice 2: Instruments

Review:

- database version 2 migration
- `instruments` table shape
- idempotent `NQ` and `MNQ` seeds
- data/domain/presentation boundaries
- Riverpod provider wiring
- simple German instrument UI
- test coverage
- file size rule

## Still Out Of Scope

- trades
- setups
- filters
- performance calculations
- dashboard
- export/import
