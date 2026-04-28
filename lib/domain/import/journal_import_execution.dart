import 'journal_import.dart';

enum JournalImportMode { replace, merge }

abstract class JournalImportExecutor {
  Future<JournalImportResult> execute({
    required JournalImportData data,
    required JournalImportMode mode,
  });
}

class JournalImportResult {
  const JournalImportResult({
    required this.mode,
    required this.accountsImported,
    required this.instrumentsImported,
    required this.setupsImported,
    required this.tradesImported,
    required this.skippedConflicts,
  });

  final JournalImportMode mode;
  final int accountsImported;
  final int instrumentsImported;
  final int setupsImported;
  final int tradesImported;
  final int skippedConflicts;
}
