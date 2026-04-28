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
    session: TradeSession.london,
    rating: null,
    notes: null,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );
}
