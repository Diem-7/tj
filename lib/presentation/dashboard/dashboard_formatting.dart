import '../../domain/trades/trade.dart';
import '../trades/trade_labels.dart';

String signedMoney(double value) {
  final prefix = value > 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(2)}';
}

String percent(double value) {
  return '${(value * 100).toStringAsFixed(1)}%';
}

String optionalNumber(double? value) {
  if (value == null) {
    return 'N/A';
  }
  return value.toStringAsFixed(2);
}

String tradePnl(Trade? trade) {
  final pnl = trade?.netPnl;
  if (pnl == null) {
    return 'N/A';
  }
  return signedMoney(pnl);
}

String? tradeDetail(Trade? trade) {
  if (trade == null) {
    return null;
  }
  final session = trade.session?.label ?? 'Keine Session';
  return '${trade.direction.label} - $session';
}

String heroStatus(double value) {
  if (value > 0) {
    return 'Positiver Zeitraum';
  }
  if (value < 0) {
    return 'Negativer Zeitraum';
  }
  return 'Neutraler Zeitraum';
}
