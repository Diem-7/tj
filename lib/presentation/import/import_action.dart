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

  JournalImportData parseJsonText(String jsonText) {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map) {
      throw const JournalImportException('Import file must be a JSON object.');
    }

    return _parser.parse(Map<String, Object?>.from(decoded)).data;
  }

  Future<JournalImportResult> executeJsonText({
    required String jsonText,
    required JournalImportMode mode,
  }) async {
    return _executor.execute(data: parseJsonText(jsonText), mode: mode);
  }
}
