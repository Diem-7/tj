import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/performance/performance_summary.dart';
import 'package:tj/domain/trades/trade.dart';

void main() {
  test('returns empty values without trades', () {
    final summary = PerformanceSummary.fromTrades([]);

    expect(summary.netPnl, 0);
    expect(summary.winrate, 0);
    expect(summary.profitFactor, isNull);
    expect(summary.averageR, isNull);
    expect(summary.tradeCount, 0);
    expect(summary.bestTrade, isNull);
    expect(summary.worstTrade, isNull);
    expect(summary.sessionSummaries, isEmpty);
  });

  test('calculates mixed performance values from closed trades', () {
    final trades = [
      _trade(id: 'win', netPnl: 300, riskAmount: 100),
      _trade(id: 'loss', netPnl: -100, riskAmount: 50),
      _trade(id: 'flat', netPnl: 0, riskAmount: 25),
    ];

    final summary = PerformanceSummary.fromTrades(trades);

    expect(summary.netPnl, 200);
    expect(summary.winrate, 1 / 3);
    expect(summary.profitFactor, 3);
    expect(summary.averageR, (3 + -2 + 0) / 3);
    expect(summary.tradeCount, 3);
    expect(summary.bestTrade?.id, 'win');
    expect(summary.worstTrade?.id, 'loss');
  });

  test('groups session performance from included trades', () {
    final summary = PerformanceSummary.fromTrades([
      _trade(id: 'asia-win', netPnl: 300, session: TradeSession.asia),
      _trade(id: 'asia-loss', netPnl: -100, session: TradeSession.asia),
      _trade(id: 'london-win', netPnl: 50, session: TradeSession.london),
      _trade(id: 'no-session', netPnl: -25, session: null),
    ]);

    final asia = _sessionSummary(summary, TradeSession.asia);
    final london = _sessionSummary(summary, TradeSession.london);
    final noSession = _sessionSummary(summary, null);

    expect(asia.netPnl, 200);
    expect(asia.tradeCount, 2);
    expect(london.netPnl, 50);
    expect(london.tradeCount, 1);
    expect(noSession.netPnl, -25);
    expect(noSession.tradeCount, 1);
  });

  test('excludes trades without performance value from session groups', () {
    final summary = PerformanceSummary.fromTrades([
      _trade(id: 'included', netPnl: 100, session: TradeSession.newYork),
      _trade(
        id: 'open',
        netPnl: 500,
        withoutClosedAt: true,
        session: TradeSession.newYork,
      ),
      _trade(
        id: 'partial',
        netPnl: 500,
        exitPrice: null,
        session: TradeSession.newYork,
      ),
      _trade(id: 'missing-pnl', netPnl: null, session: TradeSession.london),
    ]);

    expect(summary.sessionSummaries, hasLength(1));
    expect(summary.sessionSummaries.single.session, TradeSession.newYork);
    expect(summary.sessionSummaries.single.netPnl, 100);
    expect(summary.sessionSummaries.single.tradeCount, 1);
  });

  test('returns null profit factor without losses', () {
    final summary = PerformanceSummary.fromTrades([
      _trade(id: 'first', netPnl: 100),
      _trade(id: 'second', netPnl: 50),
    ]);

    expect(summary.profitFactor, isNull);
  });

  test('averages only trades with r values', () {
    final summary = PerformanceSummary.fromTrades([
      _trade(id: 'with-r', netPnl: 100, riskAmount: 50),
      _trade(id: 'without-risk', netPnl: 50, riskAmount: null),
      _trade(id: 'zero-risk', netPnl: -50, riskAmount: 0),
    ]);

    expect(summary.averageR, 2);
  });

  test('ignores trades without closed state or net pnl', () {
    final summary = PerformanceSummary.fromTrades([
      _trade(id: 'included', netPnl: 100),
      _trade(id: 'open', netPnl: 500, withoutClosedAt: true),
      _trade(id: 'partial', netPnl: 500, exitPrice: null),
      _trade(id: 'missing-pnl', netPnl: null),
    ]);

    expect(summary.tradeCount, 1);
    expect(summary.netPnl, 100);
    expect(summary.bestTrade?.id, 'included');
    expect(summary.worstTrade?.id, 'included');
  });
}

Trade _trade({
  required String id,
  double? netPnl,
  double? riskAmount = 100,
  DateTime? closedAt,
  bool withoutClosedAt = false,
  double? exitPrice = 101,
  TradeSession? session = TradeSession.london,
}) {
  return Trade(
    id: id,
    accountId: 'account-id',
    instrumentId: 'instrument-id',
    setupId: null,
    openedAt: DateTime.utc(2026),
    closedAt: withoutClosedAt ? null : closedAt ?? DateTime.utc(2026, 1, 2),
    direction: TradeDirection.long,
    entryPrice: 100,
    exitPrice: exitPrice,
    stopLossPrice: null,
    takeProfitPrice: null,
    quantity: 1,
    riskAmount: riskAmount,
    fees: null,
    netPnl: netPnl,
    session: session,
    rating: null,
    notes: null,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );
}

SessionPerformanceSummary _sessionSummary(
  PerformanceSummary summary,
  TradeSession? session,
) {
  return summary.sessionSummaries.singleWhere(
    (sessionSummary) => sessionSummary.session == session,
  );
}
