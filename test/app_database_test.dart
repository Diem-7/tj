import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tj/data/database/app_database.dart';

void main() {
  test('seeds initial instruments', () async {
    final database = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );

    final db = await database.open();
    final rows = await db.query('instruments', orderBy: 'symbol ASC');

    expect(rows.map((row) => row['symbol']), ['MNQ', 'NQ']);
    expect(rows.every((row) => row['is_active'] == 1), isTrue);
    await db.close();
  });

  test('creates trades table', () async {
    final database = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );

    final db = await database.open();
    final rows = await db.rawQuery('PRAGMA table_info(trades)');

    expect(rows.map((row) => row['name']), contains('net_pnl'));
    expect(rows.map((row) => row['name']), isNot(contains('r_multiple')));
    await db.close();
  });

  test('migrates existing database to setups table', () async {
    final directory = await Directory.systemTemp.createTemp('tj_db_test_');
    final path = '${directory.path}${Platform.pathSeparator}journal.sqlite';
    final oldDb = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 3,
        onCreate: (db, version) async {
          await db.execute('''
CREATE TABLE accounts (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  account_type TEXT NOT NULL,
  currency TEXT NOT NULL DEFAULT 'USD',
  initial_balance REAL NOT NULL,
  is_active INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');
          await db.execute('''
CREATE TABLE instruments (
  id TEXT PRIMARY KEY,
  symbol TEXT NOT NULL,
  name TEXT,
  is_active INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');
          await db.execute('''
CREATE TABLE trades (
  id TEXT PRIMARY KEY,
  account_id TEXT NOT NULL,
  instrument_id TEXT NOT NULL,
  setup_id TEXT,
  opened_at TEXT NOT NULL,
  closed_at TEXT,
  direction TEXT NOT NULL,
  entry_price REAL NOT NULL,
  exit_price REAL,
  stop_loss_price REAL,
  take_profit_price REAL,
  quantity REAL NOT NULL,
  risk_amount REAL,
  fees REAL,
  net_pnl REAL,
  session TEXT,
  rating INTEGER,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');
          await db.insert('accounts', {
            'id': 'account-id',
            'name': 'Combine',
            'account_type': 'combine',
            'currency': 'USD',
            'initial_balance': 50000,
            'is_active': 1,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
          });
        },
      ),
    );
    await oldDb.close();

    final database = AppDatabase(factory: databaseFactoryFfi, path: path);
    final db = await database.open();
    final setupColumns = await db.rawQuery('PRAGMA table_info(setups)');
    final accounts = await db.query('accounts');
    final setups = await db.query('setups');

    expect(setupColumns.map((row) => row['name']), contains('name'));
    expect(accounts, hasLength(1));
    expect(setups, isEmpty);
    await db.close();
    await directory.delete(recursive: true);
  });
}
