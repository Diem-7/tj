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

    return CockpitPanel(
      padding: const EdgeInsets.all(22),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900 ? 3 : 1;
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: columns == 1 ? 3.3 : 2.05,
                children: cards.map(_SessionCard.new).toList(),
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
            ),
      if (bySession.containsKey(null)) bySession[null]!,
    ];
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.summary);

  final SessionPerformanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final color = performanceColor(summary.netPnl);

    return CockpitPanel(
      accent: color,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            bottom: -16,
            child: Container(
              width: 150,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.42),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              GlowIcon(
                icon: _sessionIcon(summary.session),
                color: color,
                size: 64,
              ),
              const SizedBox(width: 22),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        signedMoney(summary.netPnl),
                        style: TextStyle(
                          color: color,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
