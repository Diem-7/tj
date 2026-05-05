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
    required this.sessionSummaries,
    required this.equityPoints,
  });

  final double netPnl;
  final double winrate;
  final double? profitFactor;
  final double? averageR;
  final int tradeCount;
  final Trade? bestTrade;
  final Trade? worstTrade;
  final List<SessionPerformanceSummary> sessionSummaries;
  final List<double> equityPoints;

  factory PerformanceSummary.fromTrades(List<Trade> trades) {
    final includedTrades = trades.where(_hasPerformanceValue).toList()
      ..sort((a, b) => a.closedAt!.compareTo(b.closedAt!));
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
        sessionSummaries: [],
        equityPoints: [],
      );
    }

    final sessionTotals = <TradeSession?, SessionPerformanceSummaryBuilder>{};
    var netPnl = 0.0;
    var wins = 0;
    var grossProfit = 0.0;
    var grossLoss = 0.0;
    var rTotal = 0.0;
    var rCount = 0;
    var bestTrade = includedTrades.first;
    var worstTrade = includedTrades.first;
    final equityPoints = <double>[];

    for (final trade in includedTrades) {
      final pnl = trade.netPnl!;
      netPnl += pnl;
      equityPoints.add(netPnl);
      sessionTotals
          .putIfAbsent(
            trade.session,
            () => SessionPerformanceSummaryBuilder(trade.session),
          )
          .add(pnl);

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
      sessionSummaries: sessionTotals.values
          .map((builder) => builder.build())
          .toList(),
      equityPoints: List.unmodifiable(equityPoints),
    );
  }

  static bool _hasPerformanceValue(Trade trade) {
    return trade.isClosed && trade.netPnl != null;
  }
}

class SessionPerformanceSummary {
  const SessionPerformanceSummary({
    required this.session,
    required this.netPnl,
    required this.tradeCount,
    required this.equityPoints,
  });

  final TradeSession? session;
  final double netPnl;
  final int tradeCount;
  final List<double> equityPoints;
}

class SessionPerformanceSummaryBuilder {
  SessionPerformanceSummaryBuilder(this.session);

  final TradeSession? session;
  var netPnl = 0.0;
  var tradeCount = 0;
  final equityPoints = <double>[];

  void add(double pnl) {
    netPnl += pnl;
    tradeCount++;
    equityPoints.add(netPnl);
  }

  SessionPerformanceSummary build() {
    return SessionPerformanceSummary(
      session: session,
      netPnl: netPnl,
      tradeCount: tradeCount,
      equityPoints: List.unmodifiable(equityPoints),
    );
  }
}
