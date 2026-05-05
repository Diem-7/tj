import 'package:flutter/material.dart';

import '../../domain/performance/performance_summary.dart';
import 'dashboard_formatting.dart';
import 'dashboard_style.dart';

class DashboardHeroCard extends StatelessWidget {
  const DashboardHeroCard({required this.summary, super.key});

  final PerformanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final color = performanceColor(summary.netPnl);

    return SizedBox(
      height: 314,
      child: CockpitPanel(
        accent: color,
        strong: true,
        padding: const EdgeInsets.all(28),
        child: Stack(
          children: [
            Positioned(
              right: -80,
              bottom: -90,
              child: Icon(
                Icons.show_chart,
                size: 260,
                color: color.withValues(alpha: 0.12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Netto PnL',
                  style: TextStyle(
                    color: DashboardColors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 26),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    signedMoney(summary.netPnl),
                    style: TextStyle(
                      color: color,
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _StatusPill(color: color, label: heroStatus(summary.netPnl)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({required this.summary, super.key});

  final PerformanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 2 : 1;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: columns == 1 ? 3.2 : 2.35,
          children: [
            _KpiCard(
              label: 'Trefferquote',
              value: percent(summary.winrate),
              detail: '${summary.tradeCount} abgeschlossene Trades',
              icon: Icons.track_changes,
              accent: DashboardColors.neutral,
            ),
            _KpiCard(
              label: 'Trades',
              value: summary.tradeCount.toString(),
              detail: 'Abgeschlossene Trades',
              icon: Icons.receipt_long,
              accent: DashboardColors.violet,
            ),
            _KpiCard(
              label: 'Profit Factor',
              value: optionalNumber(summary.profitFactor),
              detail: 'Brutto Profit / Brutto Loss',
              icon: Icons.trending_up,
              accent: DashboardColors.positive,
            ),
            _KpiCard(
              label: 'Durchschnitt R',
              value: optionalNumber(summary.averageR),
              detail: summary.averageR == null
                  ? 'Nicht verfuegbar'
                  : 'Pro Trade',
              icon: Icons.functions,
              accent: DashboardColors.violet,
            ),
          ],
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CockpitPanel(
      accent: accent,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: DashboardColors.text,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardColors.mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GlowIcon(icon: icon, color: accent),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_outward, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
