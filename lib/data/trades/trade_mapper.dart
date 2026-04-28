import '../../domain/trades/trade.dart';

class TradeMapper {
  static Trade fromMap(Map<String, Object?> map) {
    final session = map['session'] as String?;
    return Trade(
      id: map['id']! as String,
      accountId: map['account_id']! as String,
      instrumentId: map['instrument_id']! as String,
      setupId: map['setup_id'] as String?,
      openedAt: DateTime.parse(map['opened_at']! as String),
      closedAt: _dateTimeOrNull(map['closed_at']),
      direction: TradeDirection.fromDb(map['direction']! as String),
      entryPrice: (map['entry_price']! as num).toDouble(),
      exitPrice: _doubleOrNull(map['exit_price']),
      stopLossPrice: _doubleOrNull(map['stop_loss_price']),
      takeProfitPrice: _doubleOrNull(map['take_profit_price']),
      quantity: (map['quantity']! as num).toDouble(),
      riskAmount: _doubleOrNull(map['risk_amount']),
      fees: _doubleOrNull(map['fees']),
      netPnl: _doubleOrNull(map['net_pnl']),
      session: session == null ? null : TradeSession.fromDb(session),
      rating: map['rating'] as int?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    );
  }

  static Map<String, Object?> toInsertMap(Trade trade) {
    return {
      'id': trade.id,
      'account_id': trade.accountId,
      'instrument_id': trade.instrumentId,
      'setup_id': trade.setupId,
      'opened_at': trade.openedAt.toIso8601String(),
      'closed_at': trade.closedAt?.toIso8601String(),
      'direction': trade.direction.dbValue,
      'entry_price': trade.entryPrice,
      'exit_price': trade.exitPrice,
      'stop_loss_price': trade.stopLossPrice,
      'take_profit_price': trade.takeProfitPrice,
      'quantity': trade.quantity,
      'risk_amount': trade.riskAmount,
      'fees': trade.fees,
      'net_pnl': trade.netPnl,
      'session': trade.session?.dbValue,
      'rating': trade.rating,
      'notes': trade.notes,
      'created_at': trade.createdAt.toIso8601String(),
      'updated_at': trade.updatedAt.toIso8601String(),
    };
  }

  static Map<String, Object?> toUpdateMap(Trade trade) {
    final values = toInsertMap(trade);
    values.remove('id');
    values.remove('created_at');
    return values;
  }

  static DateTime? _dateTimeOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    return DateTime.parse(value as String);
  }

  static double? _doubleOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    return (value as num).toDouble();
  }
}
