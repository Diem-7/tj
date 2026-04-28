import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/trades/trade.dart';
import 'trade_filter_controls.dart';
import 'trade_labels.dart';
import 'trade_providers.dart';

class TradesScreen extends ConsumerWidget {
  const TradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(filteredTradesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trades'),
        actions: [
          IconButton(
            tooltip: 'Aktualisieren',
            onPressed: () => ref.invalidate(tradesProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const TradeFilterControls(),
          Expanded(
            child: trades.when(
              data: (items) => _TradeList(trades: items),
              error: (error, stackTrace) => Center(child: Text('$error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeList extends StatelessWidget {
  const _TradeList({required this.trades});

  final List<Trade> trades;

  @override
  Widget build(BuildContext context) {
    if (trades.isEmpty) {
      return const Center(child: Text('Keine geschlossenen Trades im Filter.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: trades.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final trade = trades[index];
        return Card(
          child: ListTile(
            title: Text('${trade.direction.label} ${trade.quantity}'),
            subtitle: Text(_subtitle(trade)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(trade.isClosed ? 'Geschlossen' : 'Offen'),
                Text(_netPnlText(trade)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _subtitle(Trade trade) {
    final session = trade.session?.label ?? 'Keine Session';
    return '$session - Einstieg ${trade.entryPrice.toStringAsFixed(2)}';
  }

  String _netPnlText(Trade trade) {
    final pnl = trade.netPnl;
    if (pnl == null) {
      return 'Kein PnL';
    }
    return pnl.toStringAsFixed(2);
  }
}
