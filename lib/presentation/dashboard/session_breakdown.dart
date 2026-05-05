import 'package:flutter/material.dart';

import '../../domain/performance/performance_summary.dart';
import '../trades/trade_labels.dart';

class SessionBreakdown extends StatelessWidget {
  const SessionBreakdown({required this.summaries, super.key});

  final List<SessionPerformanceSummary> summaries;

  @override
  Widget build(BuildContext context) {
    if (summaries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sessions', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: summaries.map(_SessionCard.new).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.summary);

  final SessionPerformanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 220),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _sessionLabel(summary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  _signedMoney(summary.netPnl),
                  style: textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 4),
              Text('${summary.tradeCount} Trades', style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  String _sessionLabel(SessionPerformanceSummary summary) {
    return summary.session?.label ?? 'Keine Session';
  }

  String _signedMoney(double value) {
    final prefix = value > 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(2)}';
  }
}
