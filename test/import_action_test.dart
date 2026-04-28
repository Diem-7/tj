import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/import/journal_import.dart';
import 'package:tj/domain/import/journal_import_execution.dart';
import 'package:tj/domain/import/journal_import_parser.dart';
import 'package:tj/presentation/import/import_action.dart';

void main() {
  test('parses json text and executes import with explicit mode', () async {
    final executor = _FakeImportExecutor();
    final action = ImportAction(
      parser: const JournalImportParser(),
      executor: executor,
    );

    final result = await action.executeJsonText(
      jsonText: jsonEncode(_validImport()),
      mode: JournalImportMode.merge,
    );

    expect(result.mode, JournalImportMode.merge);
    expect(executor.callCount, 1);
    expect(executor.lastMode, JournalImportMode.merge);
    expect(executor.lastData?.accounts.single.name, 'Combine');
  });

  test('parses json text for preview before executing import', () {
    final executor = _FakeImportExecutor();
    final action = ImportAction(
      parser: const JournalImportParser(),
      executor: executor,
    );

    final data = action.parseJsonText(jsonEncode(_validImport()));

    expect(data.accounts.length, 1);
    expect(data.instruments.length, 1);
    expect(data.setups.length, 1);
    expect(data.trades.length, 1);
    expect(executor.callCount, 0);
  });

  test('rejects non-object json before executing import', () async {
    final executor = _FakeImportExecutor();
    final action = ImportAction(
      parser: const JournalImportParser(),
      executor: executor,
    );

    await expectLater(
      action.executeJsonText(jsonText: '[]', mode: JournalImportMode.replace),
      throwsA(isA<JournalImportException>()),
    );
    expect(executor.callCount, 0);
  });

  test('rejects invalid import rows before executing import', () async {
    final executor = _FakeImportExecutor();
    final action = ImportAction(
      parser: const JournalImportParser(),
      executor: executor,
    );
    final json = _validImport();
    final data = json['data']! as Map<String, Object?>;
    final accounts = data['accounts']! as List<Map<String, Object?>>;
    accounts.single.remove('initial_balance');

    await expectLater(
      action.executeJsonText(
        jsonText: jsonEncode(json),
        mode: JournalImportMode.replace,
      ),
      throwsA(isA<JournalImportException>()),
    );
    expect(executor.callCount, 0);
  });
}

class _FakeImportExecutor implements JournalImportExecutor {
  int callCount = 0;
  JournalImportData? lastData;
  JournalImportMode? lastMode;

  @override
  Future<JournalImportResult> execute({
    required JournalImportData data,
    required JournalImportMode mode,
  }) async {
    callCount++;
    lastData = data;
    lastMode = mode;
    return JournalImportResult(
      mode: mode,
      accountsImported: data.accounts.length,
      instrumentsImported: data.instruments.length,
      setupsImported: data.setups.length,
      tradesImported: data.trades.length,
      skippedConflicts: 0,
    );
  }
}

Map<String, Object?> _validImport() {
  const createdAt = '2026-01-01T00:00:00.000Z';
  const updatedAt = '2026-01-02T00:00:00.000Z';
  return {
    'schemaVersion': 1,
    'exportedAt': '2026-01-04T12:00:00.000Z',
    'app': 'trading_journal',
    'data': {
      'accounts': [
        {
          'id': '00000000-0000-4000-8000-000000000101',
          'name': 'Combine',
          'account_type': 'combine',
          'currency': 'USD',
          'initial_balance': 50000,
          'is_active': true,
          'created_at': createdAt,
          'updated_at': updatedAt,
        },
      ],
      'instruments': [
        {
          'id': '00000000-0000-4000-8000-000000000201',
          'symbol': 'NQ',
          'name': null,
          'is_active': true,
          'created_at': createdAt,
          'updated_at': updatedAt,
        },
      ],
      'setups': [
        {
          'id': '00000000-0000-4000-8000-000000000301',
          'name': 'Opening Drive',
          'is_active': true,
          'created_at': createdAt,
          'updated_at': updatedAt,
        },
      ],
      'trades': [
        {
          'id': '00000000-0000-4000-8000-000000000401',
          'account_id': '00000000-0000-4000-8000-000000000101',
          'instrument_id': '00000000-0000-4000-8000-000000000201',
          'setup_id': '00000000-0000-4000-8000-000000000301',
          'opened_at': '2026-01-03T10:00:00.000Z',
          'closed_at': '2026-01-03T11:00:00.000Z',
          'direction': 'long',
          'entry_price': 100,
          'exit_price': 105,
          'stop_loss_price': 98,
          'take_profit_price': 106,
          'quantity': 2,
          'risk_amount': 50,
          'fees': 4,
          'net_pnl': 96,
          'session': 'new_york',
          'rating': 4,
          'notes': 'sauber',
          'created_at': createdAt,
          'updated_at': updatedAt,
        },
      ],
    },
  };
}
