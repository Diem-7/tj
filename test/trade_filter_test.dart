import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/trades/trade.dart';
import 'package:tj/domain/trades/trade_filter.dart';

void main() {
  test('uses closed trades only', () {
    final filter = const TradeFilter();
    final trades = [
      _trade(id: 'closed', closedAt: DateTime.utc(2026), exitPrice: 101),
      _trade(id: 'open', withoutClosedAt: true, exitPrice: null),
      _trade(id: 'partial', closedAt: DateTime.utc(2026), exitPrice: null),
    ];

    expect(filter.apply(trades).map((trade) => trade.id), ['closed']);
  });

  test('filters time range by closed date only', () {
    final filter = TradeFilter(
      closedDateFrom: DateTime.utc(2026, 2, 1),
      closedDateTo: DateTime.utc(2026, 2, 28),
    );
    final trades = [
      _trade(
        id: 'opened-before',
        openedAt: DateTime.utc(2026, 1, 10),
        closedAt: DateTime.utc(2026, 2, 1, 22),
      ),
      _trade(
        id: 'closed-after',
        openedAt: DateTime.utc(2026, 2, 15),
        closedAt: DateTime.utc(2026, 3, 1),
      ),
    ];

    expect(filter.apply(trades).map((trade) => trade.id), ['opened-before']);
  });

  test('unset filters do not restrict closed trades', () {
    final filter = const TradeFilter();
    final trades = [
      _trade(id: 'first', accountId: 'a1', instrumentId: 'i1'),
      _trade(id: 'second', accountId: 'a2', instrumentId: 'i2'),
    ];

    expect(filter.apply(trades), hasLength(2));
  });

  test('filters by account instrument and session when set', () {
    final filter = const TradeFilter(
      accountId: 'account-a',
      instrumentId: 'instrument-a',
      session: TradeSession.london,
    );
    final trades = [
      _trade(id: 'match'),
      _trade(id: 'account', accountId: 'account-b'),
      _trade(id: 'instrument', instrumentId: 'instrument-b'),
      _trade(id: 'session', session: TradeSession.newYork),
    ];

    expect(filter.apply(trades).map((trade) => trade.id), ['match']);
  });
}

Trade _trade({
  required String id,
  String accountId = 'account-a',
  String instrumentId = 'instrument-a',
  DateTime? openedAt,
  DateTime? closedAt,
  bool withoutClosedAt = false,
  double? exitPrice = 101,
  TradeSession? session = TradeSession.london,
}) {
  return Trade(
    id: id,
    accountId: accountId,
    instrumentId: instrumentId,
    setupId: null,
    openedAt: openedAt ?? DateTime.utc(2026, 1, 1),
    closedAt: withoutClosedAt ? null : closedAt ?? DateTime.utc(2026, 1, 1),
    direction: TradeDirection.long,
    entryPrice: 100,
    exitPrice: exitPrice,
    stopLossPrice: null,
    takeProfitPrice: null,
    quantity: 1,
    riskAmount: 100,
    fees: null,
    netPnl: 50,
    session: session,
    rating: null,
    notes: null,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}
