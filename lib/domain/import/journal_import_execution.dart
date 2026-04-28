enum JournalImportMode { replace, merge }

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
