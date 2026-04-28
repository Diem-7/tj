enum TradeDirection {
  long('long'),
  short('short');

  const TradeDirection(this.dbValue);

  final String dbValue;

  static TradeDirection fromDb(String value) {
    return TradeDirection.values.firstWhere(
      (direction) => direction.dbValue == value,
    );
  }
}

enum TradeSession {
  asia('asia'),
  london('london'),
  newYork('new_york');

  const TradeSession(this.dbValue);

  final String dbValue;

  static TradeSession fromDb(String value) {
    return TradeSession.values.firstWhere(
      (session) => session.dbValue == value,
    );
  }
}

class Trade {
  const Trade({
    required this.id,
    required this.accountId,
    required this.instrumentId,
    required this.setupId,
    required this.openedAt,
    required this.closedAt,
    required this.direction,
    required this.entryPrice,
    required this.exitPrice,
    required this.stopLossPrice,
    required this.takeProfitPrice,
    required this.quantity,
    required this.riskAmount,
    required this.fees,
    required this.netPnl,
    required this.session,
    required this.rating,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String accountId;
  final String instrumentId;
  final String? setupId;
  final DateTime openedAt;
  final DateTime? closedAt;
  final TradeDirection direction;
  final double entryPrice;
  final double? exitPrice;
  final double? stopLossPrice;
  final double? takeProfitPrice;
  final double quantity;
  final double? riskAmount;
  final double? fees;
  final double? netPnl;
  final TradeSession? session;
  final int? rating;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isClosed => closedAt != null && exitPrice != null;

  bool get isWin => netPnl != null && netPnl! > 0;

  bool get isLoss => netPnl != null && netPnl! < 0;

  double? get rMultiple {
    final risk = riskAmount;
    final pnl = netPnl;
    if (risk == null || risk == 0 || pnl == null) {
      return null;
    }
    return pnl / risk;
  }
}
