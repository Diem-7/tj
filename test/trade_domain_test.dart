import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/trades/trade.dart';
import 'package:tj/domain/trades/trade_input.dart';

void main() {
  test('closed trade requires closedAt and exitPrice', () {
    final trade = _trade(closedAt: DateTime.utc(2026), exitPrice: null);

    expect(trade.isClosed, isFalse);
  });

  test('win loss and r multiple are derived from net pnl and risk', () {
    final trade = _trade(netPnl: 250, riskAmount: 100);

    expect(trade.isWin, isTrue);
    expect(trade.isLoss, isFalse);
    expect(trade.rMultiple, 2.5);
  });

  test('r multiple is null without usable risk', () {
    expect(_trade(netPnl: 50, riskAmount: null).rMultiple, isNull);
    expect(_trade(netPnl: 50, riskAmount: 0).rMultiple, isNull);
  });

  test('trade input validates required references and positive values', () {
    final input = _input(
      accountId: '',
      closedAt: null,
      exitPrice: null,
      netPnl: null,
    );

    expect(input.validate, throwsA(isA<TradeValidationException>()));
  });

  test('trade input rejects partial closed state', () {
    final withoutExit = _input(
      closedAt: DateTime.utc(2026, 1, 2, 11),
      exitPrice: null,
      netPnl: 100,
    );
    final withoutClosedAt = _input(closedAt: null, exitPrice: 105, netPnl: 100);

    expect(withoutExit.validate, throwsA(isA<TradeValidationException>()));
    expect(withoutClosedAt.validate, throwsA(isA<TradeValidationException>()));
  });

  test('trade input requires net pnl for closed trades', () {
    final input = _input(
      closedAt: DateTime.utc(2026, 1, 2, 11),
      exitPrice: 105,
      netPnl: null,
    );

    expect(input.validate, throwsA(isA<TradeValidationException>()));
  });

  test('trade input accepts closed trades with net pnl', () {
    final input = _input(
      closedAt: DateTime.utc(2026, 1, 2, 11),
      exitPrice: 105,
      netPnl: 100,
    );

    expect(input.validate, returnsNormally);
  });
}

TradeInput _input({
  String accountId = 'account-id',
  DateTime? closedAt,
  double? exitPrice,
  double? netPnl,
}) {
  return TradeInput(
    accountId: accountId,
    instrumentId: 'instrument-id',
    setupId: null,
    openedAt: DateTime.utc(2026),
    closedAt: closedAt,
    direction: TradeDirection.long,
    entryPrice: 100,
    exitPrice: exitPrice,
    stopLossPrice: null,
    takeProfitPrice: null,
    quantity: 1,
    riskAmount: null,
    fees: null,
    netPnl: netPnl,
    session: null,
    rating: null,
    notes: null,
  );
}

Trade _trade({
  DateTime? closedAt,
  double? exitPrice = 102,
  double? netPnl,
  double? riskAmount,
}) {
  return Trade(
    id: 'trade-id',
    accountId: 'account-id',
    instrumentId: 'instrument-id',
    setupId: null,
    openedAt: DateTime.utc(2026),
    closedAt: closedAt,
    direction: TradeDirection.long,
    entryPrice: 100,
    exitPrice: exitPrice,
    stopLossPrice: null,
    takeProfitPrice: null,
    quantity: 1,
    riskAmount: riskAmount,
    fees: null,
    netPnl: netPnl,
    session: TradeSession.newYork,
    rating: null,
    notes: null,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );
}
