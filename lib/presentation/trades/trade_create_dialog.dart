import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/accounts/account.dart';
import '../../domain/instruments/instrument.dart';
import 'trade_form_dialog.dart';
import 'trade_providers.dart';

class TradeCreateDialog extends ConsumerWidget {
  const TradeCreateDialog({
    required this.accounts,
    required this.instruments,
    super.key,
  });

  final List<Account> accounts;
  final List<Instrument> instruments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TradeFormDialog(
      title: 'Trade erstellen',
      accounts: accounts,
      instruments: instruments,
      onSave: (input) => ref.read(tradeRepositoryProvider).create(input),
    );
  }
}
