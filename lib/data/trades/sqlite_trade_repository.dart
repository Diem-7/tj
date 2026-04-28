import 'package:uuid/uuid.dart';

import '../../domain/trades/trade.dart';
import '../../domain/trades/trade_input.dart';
import '../../domain/trades/trade_repository.dart';
import '../database/app_database.dart';
import 'trade_mapper.dart';

class SqliteTradeRepository implements TradeRepository {
  SqliteTradeRepository(this._database, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final Uuid _uuid;

  @override
  Future<List<Trade>> watchableList() async {
    final db = await _database.open();
    final rows = await db.query('trades', orderBy: 'opened_at DESC');
    return rows.map(TradeMapper.fromMap).toList();
  }

  @override
  Future<void> create(TradeInput input) async {
    input.validate();
    final now = DateTime.now().toUtc();
    final trade = _fromInput(id: _uuid.v4(), input: input, now: now);

    final db = await _database.open();
    await db.insert('trades', TradeMapper.toInsertMap(trade));
  }

  @override
  Future<void> update(String id, TradeInput input) async {
    input.validate();
    final db = await _database.open();
    final existing = await db.query(
      'trades',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (existing.isEmpty) {
      return;
    }

    final current = TradeMapper.fromMap(existing.single);
    final trade = _fromInput(
      id: current.id,
      input: input,
      now: DateTime.now().toUtc(),
      createdAt: current.createdAt,
    );

    await db.update(
      'trades',
      TradeMapper.toUpdateMap(trade),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Trade _fromInput({
    required String id,
    required TradeInput input,
    required DateTime now,
    DateTime? createdAt,
  }) {
    return Trade(
      id: id,
      accountId: input.accountId.trim(),
      instrumentId: input.instrumentId.trim(),
      setupId: _trimmedOrNull(input.setupId),
      openedAt: input.openedAt,
      closedAt: input.closedAt,
      direction: input.direction,
      entryPrice: input.entryPrice,
      exitPrice: input.exitPrice,
      stopLossPrice: input.stopLossPrice,
      takeProfitPrice: input.takeProfitPrice,
      quantity: input.quantity,
      riskAmount: input.riskAmount,
      fees: input.fees,
      netPnl: input.netPnl,
      session: input.session,
      rating: input.rating,
      notes: _trimmedOrNull(input.notes),
      createdAt: createdAt ?? now,
      updatedAt: now,
    );
  }

  String? _trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
