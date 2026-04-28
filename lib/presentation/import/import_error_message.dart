import '../../domain/import/journal_import.dart';

String importErrorMessage(Object error) {
  final reason = switch (error) {
    JournalImportException(:final message) => message,
    FormatException(:final message) => message,
    _ => error.toString(),
  };

  return 'Import fehlgeschlagen: $reason';
}
