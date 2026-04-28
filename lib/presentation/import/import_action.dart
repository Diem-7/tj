import 'dart:convert';

import '../../domain/import/journal_import.dart';
import '../../domain/import/journal_import_execution.dart';
import '../../domain/import/journal_import_parser.dart';

class ImportAction {
  const ImportAction({
    required JournalImportParser parser,
    required JournalImportExecutor executor,
  }) : _parser = parser,
       _executor = executor;

  final JournalImportParser _parser;
  final JournalImportExecutor _executor;

  Future<JournalImportResult> executeJsonText({
    required String jsonText,
    required JournalImportMode mode,
  }) async {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map) {
      throw const JournalImportException('Import file must be a JSON object.');
    }

    final import = _parser.parse(Map<String, Object?>.from(decoded));
    return _executor.execute(data: import.data, mode: mode);
  }
}
