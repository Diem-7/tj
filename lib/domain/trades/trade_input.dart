import 'trade.dart';

class TradeInput {
  const TradeInput({
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
  });

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

  void validate() {
    if (accountId.trim().isEmpty) {
      throw const TradeValidationException('Das Konto ist erforderlich.');
    }
    if (instrumentId.trim().isEmpty) {
      throw const TradeValidationException('Das Instrument ist erforderlich.');
    }
    if (entryPrice <= 0) {
      throw const TradeValidationException(
        'Der Einstiegspreis muss groesser als 0 sein.',
      );
    }
    if (quantity <= 0) {
      throw const TradeValidationException(
        'Die Menge muss groesser als 0 sein.',
      );
    }
    final hasClosedAt = closedAt != null;
    final hasExitPrice = exitPrice != null;
    if (hasClosedAt != hasExitPrice) {
      throw const TradeValidationException(
        'Geschlossene Trades brauchen Schlusszeit und Ausstiegspreis.',
      );
    }
    if (hasClosedAt && netPnl == null) {
      throw const TradeValidationException(
        'Netto PnL ist fuer geschlossene Trades erforderlich.',
      );
    }
  }
}

class TradeValidationException implements Exception {
  const TradeValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
