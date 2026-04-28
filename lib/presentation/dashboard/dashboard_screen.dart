import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/performance/performance_summary.dart';
import '../../domain/trades/trade.dart';
import '../trades/trade_labels.dart';
import '../trades/trade_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(performanceSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Aktualisieren',
            onPressed: () => ref.invalidate(performanceSummaryProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: summary.when(
        data: (value) => _DashboardContent(summary: value),
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
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

    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: _columnCount(MediaQuery.sizeOf(context).width),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _MetricCard(
          label: 'Netto PnL',
          value: _signedMoney(summary.netPnl),
          icon: Icons.account_balance_wallet_outlined,
        ),
        _MetricCard(
          label: 'Trefferquote',
          value: _percent(summary.winrate),
          icon: Icons.track_changes_outlined,
        ),
        _MetricCard(
          label: 'Profit Factor',
          value: _optionalNumber(summary.profitFactor),
          icon: Icons.balance_outlined,
        ),
        _MetricCard(
          label: 'Durchschnitt R',
          value: _optionalNumber(summary.averageR),
          icon: Icons.functions,
        ),
        _MetricCard(
          label: 'Trades',
          value: summary.tradeCount.toString(),
          icon: Icons.receipt_long_outlined,
        ),
        _MetricCard(
          label: 'Bester Trade',
          value: _tradePnl(summary.bestTrade),
          detail: _tradeDetail(summary.bestTrade),
          icon: Icons.trending_up,
        ),
        _MetricCard(
          label: 'Schlechtester Trade',
          value: _tradePnl(summary.worstTrade),
          detail: _tradeDetail(summary.worstTrade),
          icon: Icons.trending_down,
        ),
      ],
    );
  }

  int _columnCount(double width) {
    if (width >= 1000) {
      return 4;
    }
    if (width >= 640) {
      return 3;
    }
    return 2;
  }

  String _signedMoney(double value) {
    final prefix = value > 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(2)}';
  }

  String _percent(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  String _optionalNumber(double? value) {
    if (value == null) {
      return 'Nicht verfuegbar';
    }
    return value.toStringAsFixed(2);
  }

  String _tradePnl(Trade? trade) {
    final pnl = trade?.netPnl;
    if (pnl == null) {
      return 'Nicht verfuegbar';
    }
    return _signedMoney(pnl);
  }

  String? _tradeDetail(Trade? trade) {
    if (trade == null) {
      return null;
    }
    final session = trade.session?.label ?? 'Keine Session';
    return '${trade.direction.label} - $session';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(value, style: textTheme.headlineSmall),
            ),
            if (detail != null) ...[
              const SizedBox(height: 4),
              Text(
                detail!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
