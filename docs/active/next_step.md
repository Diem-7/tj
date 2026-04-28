# Next Step

## Recommended Next Mode

`review_task`

## Reason

Slice 3 is implemented and verified. A review pass should check architecture,
data model alignment, UI boundary, and test coverage before defining the next
slice.

## Review Scope

- confirm trade domain rules match `docs/domain_model_v1.md`
- confirm `trades` schema matches `docs/database_model_v1.md`
- confirm no `r_multiple` or performance KPI is stored
- confirm UI contains no SQL and no trade calculations outside domain
- confirm setup behavior stayed out of scope
- confirm all files remain under 300 lines

## Do Not Implement In Review

- setups
- filters
- dashboard
- performance KPIs
- export/import

## Verification Already Run

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`
