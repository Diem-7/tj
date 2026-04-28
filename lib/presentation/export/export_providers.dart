import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/export/journal_export_service.dart';
import '../accounts/account_providers.dart';
import '../instruments/instrument_providers.dart';
import '../setups/setup_providers.dart';
import '../trades/trade_providers.dart';

final journalExportServiceProvider = Provider<JournalExportService>((ref) {
  return JournalExportService(
    accountRepository: ref.watch(accountRepositoryProvider),
    instrumentRepository: ref.watch(instrumentRepositoryProvider),
    setupRepository: ref.watch(setupRepositoryProvider),
    tradeRepository: ref.watch(tradeRepositoryProvider),
  );
});
