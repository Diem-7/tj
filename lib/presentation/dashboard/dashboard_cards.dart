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
      height: 296,
      child: CockpitPanel(
        accent: color,
        strong: true,
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Positioned(
              left: 2,
              right: 4,
              bottom: 0,
              height: 132,
              child: IgnorePointer(
                child: EquitySparkline(
                  points: summary.equityPoints,
                  color: color,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PERFORMANCE METRICS',
                  style: TextStyle(
                    color: DashboardColors.violet,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Netto PnL',
                  style: TextStyle(
                    color: DashboardColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    signedMoney(summary.netPnl),
                    style: TextStyle(
                      color: color,
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
        final isTwoColumn = constraints.maxWidth >= 540;
        final items = [
          _KpiItem(
            label: 'Trefferquote',
            value: percent(summary.winrate),
            detail: '${summary.tradeCount} abgeschlossene Trades',
            icon: Icons.track_changes,
            accent: DashboardColors.neutral,
          ),
          _KpiItem(
            label: 'Trades',
            value: summary.tradeCount.toString(),
            detail: 'Abgeschlossene Trades',
            icon: Icons.receipt_long,
            accent: DashboardColors.violet,
          ),
          _KpiItem(
            label: 'Profit Factor',
            value: optionalNumber(summary.profitFactor),
            detail: 'Brutto Profit / Brutto Loss',
            icon: Icons.trending_up,
            accent: DashboardColors.positive,
          ),
          _KpiItem(
            label: 'Durchschnitt R',
            value: optionalNumber(summary.averageR),
            detail: summary.averageR == null ? 'Nicht verfuegbar' : 'Pro Trade',
            icon: Icons.functions,
            accent: DashboardColors.violet,
          ),
        ];

        return CockpitPanel(
          padding: EdgeInsets.zero,
          child: isTwoColumn
              ? Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(child: items[0]),
                          _VerticalDivider(),
                          Expanded(child: items[1]),
                        ],
                      ),
                    ),
                    _HorizontalDivider(),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(child: items[2]),
                          _VerticalDivider(),
                          Expanded(child: items[3]),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    items[0],
                    _HorizontalDivider(),
                    items[1],
                    _HorizontalDivider(),
                    items[2],
                    _HorizontalDivider(),
                    items[3],
                  ],
                ),
        );
      },
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, color: DashboardColors.border);
  }
}

class _HorizontalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: DashboardColors.border);
  }
}

class _KpiItem extends StatelessWidget {
  const _KpiItem({
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
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: DashboardColors.text,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
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
          const SizedBox(width: 8),
          GlowIcon(icon: icon, color: accent, size: 40),
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
