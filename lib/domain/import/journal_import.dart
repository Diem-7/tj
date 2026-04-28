import '../accounts/account.dart';
import '../instruments/instrument.dart';
import '../setups/setup.dart';
import '../trades/trade.dart';

class JournalImport {
  const JournalImport({
    required this.schemaVersion,
    required this.exportedAt,
    required this.app,
    required this.data,
  });

  final int schemaVersion;
  final DateTime exportedAt;
  final String app;
  final JournalImportData data;
}

class JournalImportData {
  const JournalImportData({
    required this.accounts,
    required this.instruments,
    required this.setups,
    required this.trades,
  });

  final List<Account> accounts;
  final List<Instrument> instruments;
  final List<Setup> setups;
  final List<Trade> trades;
}

class JournalImportException implements Exception {
  const JournalImportException(this.message);

  final String message;

  @override
  String toString() => 'JournalImportException: $message';
}
