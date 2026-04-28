import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/accounts/account.dart';
import '../../domain/instruments/instrument.dart';
import '../../domain/trades/trade.dart';
import '../accounts/account_providers.dart';
import '../instruments/instrument_providers.dart';
import 'trade_form_dialog.dart';
import 'trade_providers.dart';

class TradeEditAction extends ConsumerWidget {
  const TradeEditAction({required this.trade, super.key});

  final Trade trade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final instruments = ref.watch(instrumentsProvider);

    return IconButton(
      tooltip: 'Trade bearbeiten',
      onPressed: accounts.hasValue && instruments.hasValue
          ? () => _openDialog(context, ref, accounts.value!, instruments.value!)
          : null,
      icon: const Icon(Icons.edit),
    );
  }

  Future<void> _openDialog(
    BuildContext context,
    WidgetRef ref,
    List<Account> accounts,
    List<Instrument> instruments,
  ) async {
    final dialogAccounts = _activeWithCurrentAccount(accounts);
    final dialogInstruments = _activeWithCurrentInstrument(instruments);
    final hasCurrentAccount = accounts.any((account) {
      return account.id == trade.accountId;
    });
    final hasCurrentInstrument = instruments.any((instrument) {
      return instrument.id == trade.instrumentId;
    });

    if (!hasCurrentAccount || !hasCurrentInstrument) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Konto oder Instrument fuer Trade fehlt.'),
          ),
        );
      return;
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => TradeFormDialog(
        title: 'Trade bearbeiten',
        accounts: dialogAccounts,
        instruments: dialogInstruments,
        initialTrade: trade,
        onSave: (input) {
          return ref.read(tradeRepositoryProvider).update(trade.id, input);
        },
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

  List<Account> _activeWithCurrentAccount(List<Account> accounts) {
    return accounts
        .where((account) => account.isActive || account.id == trade.accountId)
        .toList();
  }

  List<Instrument> _activeWithCurrentInstrument(List<Instrument> instruments) {
    return instruments.where((instrument) {
      return instrument.isActive || instrument.id == trade.instrumentId;
    }).toList();
  }
}
