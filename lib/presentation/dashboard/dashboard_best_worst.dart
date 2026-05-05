import 'package:flutter/material.dart';

import '../../domain/performance/performance_summary.dart';
import '../../domain/trades/trade.dart';
import 'dashboard_formatting.dart';
import 'dashboard_style.dart';

class DashboardBestWorstPanel extends StatelessWidget {
  const DashboardBestWorstPanel({required this.summary, super.key});

  final PerformanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 760;
    final bestTrade = _TradeHighlight(
      title: 'Bester Trade',
      trade: summary.bestTrade,
      icon: Icons.emoji_events,
      fallbackColor: DashboardColors.positive,
    );
    final worstTrade = _TradeHighlight(
      title: 'Schlechtester Trade',
      trade: summary.worstTrade,
      icon: Icons.trending_down,
      fallbackColor: DashboardColors.negative,
    );

    return CockpitPanel(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      child: isCompact
          ? Column(
              children: [
                bestTrade,
                _Divider(isCompact: isCompact),
                worstTrade,
              ],
            )
          : Row(
              children: [
                Expanded(child: bestTrade),
                _Divider(isCompact: isCompact),
                Expanded(child: worstTrade),
              ],
            ),
    );
  }
}

class _TradeHighlight extends StatelessWidget {
  const _TradeHighlight({
    required this.title,
    required this.trade,
    required this.icon,
    required this.fallbackColor,
  });

  final String title;
  final Trade? trade;
  final IconData icon;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final pnl = trade?.netPnl;
    final color = pnl == null ? fallbackColor : performanceColor(pnl);

    return Row(
      children: [
        GlowIcon(icon: icon, color: color, size: 74),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: DashboardColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  tradePnl(trade),
                  style: TextStyle(
                    color: color,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tradeDetail(trade) ?? 'Nicht verfuegbar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: DashboardColors.mutedText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? double.infinity : 1,
      height: isCompact ? 1 : 82,
      margin: isCompact
          ? const EdgeInsets.symmetric(vertical: 22)
          : const EdgeInsets.symmetric(horizontal: 24),
      color: DashboardColors.border,
    );
  }
}
