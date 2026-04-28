import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/accounts/account.dart';
import '../../domain/instruments/instrument.dart';
import '../../domain/trades/trade.dart';
import '../accounts/account_providers.dart';
import '../instruments/instrument_providers.dart';
import 'trade_labels.dart';
import 'trade_providers.dart';

class TradeFilterControls extends ConsumerWidget {
  const TradeFilterControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final instruments =
        ref.watch(instrumentsProvider).value ?? const <Instrument>[];
    final filter = ref.watch(tradeFilterProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _AccountFilter(
                selectedId: filter.accountId,
                accounts: accounts,
                onChanged: ref.read(tradeFilterProvider.notifier).setAccountId,
              ),
              _InstrumentFilter(
                selectedId: filter.instrumentId,
                instruments: instruments,
                onChanged: (value) => ref
                    .read(tradeFilterProvider.notifier)
                    .setInstrumentId(value),
              ),
              _SessionFilter(
                selected: filter.session,
                onChanged: ref.read(tradeFilterProvider.notifier).setSession,
              ),
              _DateButton(
                label: 'Von',
                value: filter.closedDateFrom,
                onSelected: (value) => ref
                    .read(tradeFilterProvider.notifier)
                    .setClosedDateFrom(value),
              ),
              _DateButton(
                label: 'Bis',
                value: filter.closedDateTo,
                onSelected: (value) => ref
                    .read(tradeFilterProvider.notifier)
                    .setClosedDateTo(value),
              ),
              TextButton.icon(
                onPressed: ref.read(tradeFilterProvider.notifier).reset,
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Zuruecksetzen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountFilter extends StatelessWidget {
  const _AccountFilter({
    required this.selectedId,
    required this.accounts,
    required this.onChanged,
  });

  final String? selectedId;
  final List<Account> accounts;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String?>(
      key: ValueKey(selectedId ?? 'all-accounts'),
      label: const Text('Konto'),
      width: 180,
      initialSelection: selectedId,
      dropdownMenuEntries: [
        const DropdownMenuEntry(value: null, label: 'Alle Konten'),
        ...accounts.map(
          (account) =>
              DropdownMenuEntry(value: account.id, label: account.name),
        ),
      ],
      onSelected: onChanged,
    );
  }
}

class _InstrumentFilter extends StatelessWidget {
  const _InstrumentFilter({
    required this.selectedId,
    required this.instruments,
    required this.onChanged,
  });

  final String? selectedId;
  final List<Instrument> instruments;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String?>(
      key: ValueKey(selectedId ?? 'all-instruments'),
      label: const Text('Instrument'),
      width: 180,
      initialSelection: selectedId,
      dropdownMenuEntries: [
        const DropdownMenuEntry(value: null, label: 'Alle Instrumente'),
        ...instruments.map(
          (instrument) =>
              DropdownMenuEntry(value: instrument.id, label: instrument.symbol),
        ),
      ],
      onSelected: onChanged,
    );
  }
}

class _SessionFilter extends StatelessWidget {
  const _SessionFilter({required this.selected, required this.onChanged});

  final TradeSession? selected;
  final ValueChanged<TradeSession?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<TradeSession?>(
      key: ValueKey(selected?.dbValue ?? 'all-sessions'),
      label: const Text('Session'),
      width: 180,
      initialSelection: selected,
      dropdownMenuEntries: [
        const DropdownMenuEntry(value: null, label: 'Alle Sessions'),
        ...TradeSession.values.map(
          (session) => DropdownMenuEntry(value: session, label: session.label),
        ),
      ],
      onSelected: onChanged,
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onSelected,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onSelected;

  @override
  Widget build(BuildContext context) {
    final date = value;
    return OutlinedButton.icon(
      onPressed: () => _selectDate(context),
      icon: const Icon(Icons.calendar_month),
      label: Text(date == null ? label : '$label ${_dateText(date)}'),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    onSelected(selected);
  }

  String _dateText(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day.$month.${value.year}';
  }
}
