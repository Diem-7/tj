import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/import/journal_import.dart';
import 'package:tj/presentation/import/import_error_message.dart';

void main() {
  test('shows journal import exception reason', () {
    const error = JournalImportException('Missing data object.');

    final message = importErrorMessage(error);

    expect(message, 'Import fehlgeschlagen: Missing data object.');
  });

  test('shows malformed json format reason without stack details', () {
    late final FormatException error;

    try {
      jsonDecode('{');
    } on FormatException catch (caught) {
      error = caught;
    }

    final message = importErrorMessage(error);

    expect(message, startsWith('Import fehlgeschlagen: '));
    expect(message, contains(error.message));
    expect(message, isNot(contains('FormatException')));
  });
}
