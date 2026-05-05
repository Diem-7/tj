import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/performance/performance_summary.dart';
import '../export/export_action.dart';
import '../import/import_button.dart';
import '../trades/trade_filter_controls.dart';
import '../trades/trade_providers.dart';
import 'dashboard_best_worst.dart';
import 'dashboard_cards.dart';
import 'dashboard_style.dart';
import 'session_breakdown.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(performanceSummaryProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DashboardColors.backgroundTop,
              DashboardColors.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: summary.when(
            data: (value) => Column(
              children: [
                _DashboardHeader(
                  onRefresh: () => ref.invalidate(performanceSummaryProvider),
                ),
                const TradeFilterControls(),
                Expanded(child: _DashboardContent(summary: value)),
              ],
            ),
            error: (error, stackTrace) => Center(child: Text('$error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: DashboardColors.text,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Dein Trading Cockpit im Ueberblick',
                  style: TextStyle(
                    color: DashboardColors.mutedText,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const ImportButton(),
          const SizedBox(width: 8),
          const ExportAction(),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Aktualisieren',
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, color: DashboardColors.neutral),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.summary});

  final PerformanceSummary summary;

  @override
  Widget build(BuildContext context) {
    if (summary.tradeCount == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Keine geschlossenen Trades mit Netto PnL im Filter.'),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: DashboardHeroCard(summary: summary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: DashboardKpiGrid(summary: summary),
                    ),
                  ],
                )
              else ...[
                DashboardHeroCard(summary: summary),
                const SizedBox(height: 16),
                DashboardKpiGrid(summary: summary),
              ],
              const SizedBox(height: 18),
              DashboardBestWorstPanel(summary: summary),
              const SizedBox(height: 18),
              SessionBreakdown(summaries: summary.sessionSummaries),
            ],
          ),
        );
      },
    );
  }
}
