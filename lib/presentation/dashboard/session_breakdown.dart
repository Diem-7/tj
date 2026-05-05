import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/performance/performance_summary.dart';
import '../../domain/trades/trade.dart';
import '../trades/trade_labels.dart';
import 'dashboard_formatting.dart';
import 'dashboard_style.dart';

class SessionBreakdown extends StatelessWidget {
  const SessionBreakdown({required this.summaries, super.key});

  final List<SessionPerformanceSummary> summaries;

  @override
  Widget build(BuildContext context) {
    final cards = _orderedSummaries();
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxPnl = cards.fold<double>(0, (prev, s) => math.max(prev, s.netPnl));

    return CockpitPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: DashboardColors.mutedText, size: 20),
              SizedBox(width: 10),
              Text(
                'Session Performance',
                style: TextStyle(
                  color: DashboardColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 900) {
                return SizedBox(
                  height: 166,
                  child: Row(
                    children: [
                      for (var index = 0; index < cards.length; index++) ...[
                        Expanded(
                          child: _SessionCard(
                            cards[index],
                            isTop: cards[index].netPnl == maxPnl && maxPnl > 0,
                          ),
                        ),
                        if (index != cards.length - 1)
                          const SizedBox(width: 12),
                      ],
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  for (var index = 0; index < cards.length; index++) ...[
                    SizedBox(
                      height: 132,
                      child: _SessionCard(
                        cards[index],
                        isTop: cards[index].netPnl == maxPnl && maxPnl > 0,
                      ),
                    ),
                    if (index != cards.length - 1) const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<SessionPerformanceSummary> _orderedSummaries() {
    final bySession = {
      for (final summary in summaries) summary.session: summary,
    };

    return [
      for (final session in TradeSession.values)
        bySession[session] ??
            SessionPerformanceSummary(
              session: session,
              netPnl: 0,
              tradeCount: 0,
              equityPoints: const [],
            ),
      if (bySession.containsKey(null)) bySession[null]!,
    ];
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.summary, {this.isTop = false});

  final SessionPerformanceSummary summary;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final color = performanceColor(summary.netPnl);

    return CockpitPanel(
      accent: color,
      strong: isTop,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(
            left: 8,
            right: 8,
            bottom: 4,
            height: 44,
            child: IgnorePointer(
              child: EquitySparkline(
                points: summary.equityPoints,
                color: color,
                fill: false,
              ),
            ),
          ),
          Row(
            children: [
              GlowIcon(
                icon: _sessionIcon(summary.session),
                color: color,
                size: 54,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _sessionLabel(summary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DashboardColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        signedMoney(summary.netPnl),
                        style: TextStyle(
                          color: color,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${summary.tradeCount} Trades',
                      style: const TextStyle(
                        color: DashboardColors.mutedText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _sessionLabel(SessionPerformanceSummary summary) {
    return summary.session?.label ?? 'Keine Session';
  }

  IconData _sessionIcon(TradeSession? session) {
    return switch (session) {
      TradeSession.asia => Icons.wb_twilight,
      TradeSession.london => Icons.account_balance,
      TradeSession.newYork => Icons.location_city,
      null => Icons.more_horiz,
    };
  }
}
