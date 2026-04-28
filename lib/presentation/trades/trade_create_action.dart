import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/accounts/account.dart';
import '../../domain/instruments/instrument.dart';
import '../accounts/account_providers.dart';
import '../instruments/instrument_providers.dart';
import 'trade_create_dialog.dart';
import 'trade_providers.dart';

class TradeCreateAction extends ConsumerWidget {
  const TradeCreateAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final instruments = ref.watch(instrumentsProvider);

    return FloatingActionButton.extended(
      onPressed: accounts.hasValue && instruments.hasValue
          ? () => _openDialog(context, ref, accounts.value!, instruments.value!)
          : null,
      icon: const Icon(Icons.add),
      label: const Text('Trade'),
    );
  }

  Future<void> _openDialog(
    BuildContext context,
    WidgetRef ref,
    List<Account> accounts,
    List<Instrument> instruments,
  ) async {
    final activeAccounts = accounts
        .where((account) => account.isActive)
        .toList();
    final activeInstruments = instruments
        .where((instrument) => instrument.isActive)
        .toList();

    if (activeAccounts.isEmpty || activeInstruments.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Aktives Konto und Instrument erforderlich.'),
          ),
        );
      return;
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => TradeCreateDialog(
        accounts: activeAccounts,
        instruments: activeInstruments,
      ),
    );

    if (saved != true) {
      return;
    }

    ref
      ..invalidate(tradesProvider)
      ..invalidate(filteredTradesProvider)
      ..invalidate(performanceSummaryProvider);
  }
}
