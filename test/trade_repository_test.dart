import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tj/data/database/app_database.dart';
import 'package:tj/data/trades/sqlite_trade_repository.dart';
import 'package:tj/domain/trades/trade.dart';
import 'package:tj/domain/trades/trade_input.dart';

void main() {
  test('creates and lists trades from sqlite', () async {
    final database = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final repository = SqliteTradeRepository(database);

    await repository.create(
      TradeInput(
        accountId: 'account-id',
        instrumentId: 'instrument-id',
        setupId: null,
        openedAt: DateTime.utc(2026, 1, 2, 10),
        closedAt: DateTime.utc(2026, 1, 2, 11),
        direction: TradeDirection.short,
        entryPrice: 100,
        exitPrice: 95,
        stopLossPrice: 102,
        takeProfitPrice: 94,
        quantity: 2,
        riskAmount: 50,
        fees: 4,
        netPnl: 120,
        session: TradeSession.london,
        rating: 4,
        notes: ' sauber ',
      ),
    );

    final trades = await repository.watchableList();
    final db = await database.open();
    final columns = await db.rawQuery('PRAGMA table_info(trades)');

    expect(trades, hasLength(1));
    expect(trades.single.setupId, isNull);
    expect(trades.single.direction, TradeDirection.short);
    expect(trades.single.session, TradeSession.london);
    expect(trades.single.notes, 'sauber');
    expect(trades.single.rMultiple, 2.4);
    expect(columns.map((row) => row['name']), isNot(contains('r_multiple')));
    await db.close();
  });
}
