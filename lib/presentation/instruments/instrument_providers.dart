import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/instruments/sqlite_instrument_repository.dart';
import '../../domain/instruments/instrument.dart';
import '../../domain/instruments/instrument_repository.dart';
import '../accounts/account_providers.dart';

final instrumentRepositoryProvider = Provider<InstrumentRepository>((ref) {
  return SqliteInstrumentRepository(ref.watch(appDatabaseProvider));
});

final instrumentsProvider = FutureProvider<List<Instrument>>((ref) async {
  return ref.watch(instrumentRepositoryProvider).watchableList();
});
