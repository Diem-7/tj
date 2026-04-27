# Domain Model v1

## Entities

Entities:

- `Account`
- `Instrument`
- `Setup`
- `Trade`

## Account

Fields:

- `id`
- `name`
- `accountType`
- `currency`
- `initialBalance`
- `isActive`
- `createdAt`
- `updatedAt`

Rules:

- `id` is a UUID string.
- `currency` defaults to `USD`.
- Accounts are not deleted in v1.

## Instrument

Fields:

- `id`
- `symbol`
- `name`
- `isActive`
- `createdAt`
- `updatedAt`

Initial seeds:

- `NQ`
- `MNQ`

## Setup

Fields:

- `id`
- `name`
- `isActive`
- `createdAt`
- `updatedAt`

Rules:

- predefined only
- selectable only
- no free-text input

## Trade

Fields:

- `id`
- `accountId`
- `instrumentId`
- `setupId`
- `openedAt`
- `closedAt`
- `direction`
- `entryPrice`
- `exitPrice`
- `stopLossPrice`
- `takeProfitPrice`
- `quantity`
- `riskAmount`
- `fees`
- `netPnl`
- `session`
- `rating`
- `notes`
- `createdAt`
- `updatedAt`

Domain logic:

- `isClosed`
- `isWin`
- `isLoss`
- `rMultiple`

Rules:

- `isClosed` requires `closedAt` and `exitPrice`.
- `isWin` is based on `netPnl > 0`.
- `isLoss` is based on `netPnl < 0`.
- `rMultiple` is `netPnl / riskAmount`.
- If `riskAmount` is null or zero, `rMultiple` is null.

## Performance

Calculated values:

- net PnL
- winrate
- profit factor
- average R
- trade count
- best trade
- worst trade

Rules:

- use filtered closed trades only
- use `closed_at` for time periods
- use `net_pnl` as central value
- store no performance values
