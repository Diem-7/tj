import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/instruments/instrument.dart';
import 'instrument_providers.dart';

class InstrumentsScreen extends ConsumerWidget {
  const InstrumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instruments = ref.watch(instrumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrumente'),
        actions: [
          IconButton(
            tooltip: 'Aktualisieren',
            onPressed: () => ref.invalidate(instrumentsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: instruments.when(
        data: (items) => _InstrumentList(instruments: items),
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _InstrumentList extends StatelessWidget {
  const _InstrumentList({required this.instruments});

  final List<Instrument> instruments;

  @override
  Widget build(BuildContext context) {
    if (instruments.isEmpty) {
      return const Center(child: Text('Noch keine Instrumente erfasst.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: instruments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final instrument = instruments[index];
        return Card(
          child: ListTile(
            title: Text(instrument.symbol),
            subtitle: Text(instrument.name ?? 'Kein Name hinterlegt'),
            trailing: Text(instrument.isActive ? 'Aktiv' : 'Inaktiv'),
          ),
        );
      },
    );
  }
}
