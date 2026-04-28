import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/import/sqlite_journal_import_executor.dart';
import '../../domain/import/journal_import_execution.dart';
import '../../domain/import/journal_import_parser.dart';
import '../accounts/account_providers.dart';
import 'import_action.dart';

final journalImportParserProvider = Provider<JournalImportParser>((ref) {
  return const JournalImportParser();
});

final journalImportExecutorProvider = Provider<JournalImportExecutor>((ref) {
  return SqliteJournalImportExecutor(ref.watch(appDatabaseProvider));
});

final importActionProvider = Provider<ImportAction>((ref) {
  return ImportAction(
    parser: ref.watch(journalImportParserProvider),
    executor: ref.watch(journalImportExecutorProvider),
  );
});
