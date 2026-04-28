import '../trades/trade.dart';

class PerformanceSummary {
  const PerformanceSummary({
    required this.netPnl,
    required this.winrate,
    required this.profitFactor,
    required this.averageR,
    required this.tradeCount,
    required this.bestTrade,
    required this.worstTrade,
  });

  final double netPnl;
  final double winrate;
  final double? profitFactor;
  final double? averageR;
  final int tradeCount;
  final Trade? bestTrade;
  final Trade? worstTrade;

  factory PerformanceSummary.fromTrades(List<Trade> trades) {
    final includedTrades = trades.where(_hasPerformanceValue).toList();
    final tradeCount = includedTrades.length;

    if (tradeCount == 0) {
      return const PerformanceSummary(
        netPnl: 0,
        winrate: 0,
        profitFactor: null,
        averageR: null,
        tradeCount: 0,
        bestTrade: null,
        worstTrade: null,
      );
    }

    var netPnl = 0.0;
    var wins = 0;
    var grossProfit = 0.0;
    var grossLoss = 0.0;
    var rTotal = 0.0;
    var rCount = 0;
    var bestTrade = includedTrades.first;
    var worstTrade = includedTrades.first;

    for (final trade in includedTrades) {
      final pnl = trade.netPnl!;
      netPnl += pnl;

      if (pnl > 0) {
        wins++;
        grossProfit += pnl;
      } else if (pnl < 0) {
        grossLoss += pnl.abs();
      }

      final rMultiple = trade.rMultiple;
      if (rMultiple != null) {
        rTotal += rMultiple;
        rCount++;
      }

      if (pnl > bestTrade.netPnl!) {
        bestTrade = trade;
      }
      if (pnl < worstTrade.netPnl!) {
        worstTrade = trade;
      }
    }

    return PerformanceSummary(
      netPnl: netPnl,
      winrate: wins / tradeCount,
      profitFactor: grossLoss == 0 ? null : grossProfit / grossLoss,
      averageR: rCount == 0 ? null : rTotal / rCount,
      tradeCount: tradeCount,
      bestTrade: bestTrade,
      worstTrade: worstTrade,
    );
  }

  static bool _hasPerformanceValue(Trade trade) {
    return trade.isClosed && trade.netPnl != null;
  }
}
