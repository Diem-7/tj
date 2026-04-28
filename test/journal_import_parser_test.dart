import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/accounts/account.dart';
import 'package:tj/domain/import/journal_import.dart';
import 'package:tj/domain/import/journal_import_parser.dart';
import 'package:tj/domain/trades/trade.dart';

void main() {
  const parser = JournalImportParser();

  test('parses valid v1 json into domain import data', () {
    final result = parser.parse(_validImport());

    expect(result.schemaVersion, 1);
    expect(result.app, 'trading_journal');
    expect(result.exportedAt, DateTime.utc(2026, 1, 4, 12));
    expect(result.data.accounts.single.accountType, AccountType.combine);
    expect(result.data.instruments.single.symbol, 'NQ');
    expect(result.data.setups.single.name, 'Opening Drive');
    expect(result.data.trades.single.direction, TradeDirection.long);
    expect(result.data.trades.single.session, TradeSession.newYork);
    expect(result.data.trades.single.netPnl, 96);
  });

  test('rejects unsupported schema version before row parsing', () {
    final json = _validImport()
      ..['schemaVersion'] = 2
      ..['data'] = {
        'accounts': [
          {'id': ''},
        ],
      };

    expect(() => parser.parse(json), throwsA(isA<JournalImportException>()));
  });

  test('rejects missing top-level data object', () {
    final json = _validImport()..remove('data');

    expect(() => parser.parse(json), throwsA(isA<JournalImportException>()));
  });

  test('rejects the whole file when a row is invalid', () {
    final json = _validImport();
    final data = json['data']! as Map<String, Object?>;
    final accounts = data['accounts']! as List<Map<String, Object?>>;
    accounts.single.remove('initial_balance');

    expect(() => parser.parse(json), throwsA(isA<JournalImportException>()));
  });

  test('rejects closed trade without required closed trade fields', () {
    final json = _validImport();
    final data = json['data']! as Map<String, Object?>;
    final trades = data['trades']! as List<Map<String, Object?>>;
    trades.single.remove('exit_price');

    expect(() => parser.parse(json), throwsA(isA<JournalImportException>()));
  });

  test('rejects invalid uuid fields', () {
    final json = _validImport();
    final data = json['data']! as Map<String, Object?>;
    final trades = data['trades']! as List<Map<String, Object?>>;
    trades.single['account_id'] = 'account-id';

    expect(() => parser.parse(json), throwsA(isA<JournalImportException>()));
  });
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
