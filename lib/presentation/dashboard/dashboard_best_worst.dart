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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: isCompact
          ? Column(
              children: [
                bestTrade,
                _Divider(isCompact: isCompact),
                worstTrade,
              ],
            )
          : IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: bestTrade),
                  _Divider(isCompact: isCompact),
                  Expanded(child: worstTrade),
                ],
              ),
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GlowIcon(icon: icon, color: color, size: 68),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tradePnl(trade),
                    style: TextStyle(
                      color: color,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
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
      ),
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
          ? const EdgeInsets.symmetric(vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 20),
      color: DashboardColors.border,
    );
  }
}
