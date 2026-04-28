import '../../domain/trades/trade.dart';
import '../../domain/trades/trade_input.dart';
import 'trade_create_parsing.dart';

class TradeFormInput {
  const TradeFormInput._();

  static TradeInput fromFields({
    required String accountId,
    required String instrumentId,
    required String? setupId,
    required String openedAt,
    required String closedAt,
    required TradeDirection direction,
    required String entryPrice,
    required String exitPrice,
    required String stopLossPrice,
    required String takeProfitPrice,
    required String quantity,
    required String riskAmount,
    required String fees,
    required String netPnl,
    required TradeSession? session,
    required String rating,
    required String notes,
  }) {
    final parsedExitPrice = TradeCreateParsing.requiredDouble(
      exitPrice,
      'Ausstiegspreis',
    );
    if (parsedExitPrice <= 0) {
      throw const FormatException(
        'Der Ausstiegspreis muss groesser als 0 sein.',
      );
    }

    return TradeInput(
      accountId: accountId,
      instrumentId: instrumentId,
      setupId: setupId,
      openedAt: TradeCreateParsing.requiredDate(openedAt, 'Eroeffnungszeit'),
      closedAt: TradeCreateParsing.requiredDate(closedAt, 'Schlusszeit'),
      direction: direction,
      entryPrice: TradeCreateParsing.requiredDouble(
        entryPrice,
        'Einstiegspreis',
      ),
      exitPrice: parsedExitPrice,
      stopLossPrice: TradeCreateParsing.optionalDouble(stopLossPrice),
      takeProfitPrice: TradeCreateParsing.optionalDouble(takeProfitPrice),
      quantity: TradeCreateParsing.requiredDouble(quantity, 'Menge'),
      riskAmount: TradeCreateParsing.optionalDouble(riskAmount),
      fees: TradeCreateParsing.optionalDouble(fees),
      netPnl: TradeCreateParsing.requiredDouble(netPnl, 'Netto PnL'),
      session: session,
      rating: TradeCreateParsing.optionalInt(rating),
      notes: notes,
    );
  }
}
