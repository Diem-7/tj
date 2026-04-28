import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tj/data/database/app_database.dart';
import 'package:tj/data/import/sqlite_journal_import_executor.dart';
import 'package:tj/domain/accounts/account.dart';
import 'package:tj/domain/import/journal_import.dart';
import 'package:tj/domain/import/journal_import_execution.dart';
import 'package:tj/domain/instruments/instrument.dart';
import 'package:tj/domain/setups/setup.dart';
import 'package:tj/domain/trades/trade.dart';

void main() {
  test('replace clears and imports all v1 tables in one transaction', () async {
    final database = _database();
    final executor = SqliteJournalImportExecutor(database);

    final result = await executor.execute(
      data: _importData('101'),
      mode: JournalImportMode.replace,
    );

    final db = await database.open();
    expect(result.mode, JournalImportMode.replace);
    expect(result.accountsImported, 1);
    expect(result.instrumentsImported, 1);
    expect(result.setupsImported, 1);
    expect(result.tradesImported, 1);
    expect(result.skippedConflicts, 0);
    expect(await _count(db, 'accounts'), 1);
    expect(await _count(db, 'instruments'), 1);
    expect(await _count(db, 'setups'), 1);
    expect(await _count(db, 'trades'), 1);
    await db.close();
  });

  test('replace rolls back completely when an insert fails', () async {
    final database = _database();
    final executor = SqliteJournalImportExecutor(database);
    final original = _importData('201');
    await executor.execute(data: original, mode: JournalImportMode.replace);

    final duplicate = _account('301');
    final invalid = JournalImportData(
      accounts: [duplicate, duplicate],
      instruments: [_instrument('301')],
      setups: const [],
      trades: const [],
    );

    await expectLater(
      executor.execute(data: invalid, mode: JournalImportMode.replace),
      throwsException,
    );

    final db = await database.open();
    final accounts = await db.query('accounts');
    final instruments = await db.query('instruments');
    expect(accounts, hasLength(1));
    expect(accounts.single['id'], original.accounts.single.id);
    expect(instruments, hasLength(1));
    expect(instruments.single['id'], original.instruments.single.id);
    await db.close();
  });

  test('merge inserts only non-conflicting records', () async {
    final database = _database();
    final executor = SqliteJournalImportExecutor(database);
    final existing = _importData('401');
    await executor.execute(data: existing, mode: JournalImportMode.replace);

    final incoming = JournalImportData(
      accounts: [_account('401', name: 'Imported Change')],
      instruments: [_instrument('402')],
      setups: [_setup('402')],
      trades: [_trade('402', accountId: _id('account', '401'))],
    );

    final result = await executor.execute(
      data: incoming,
      mode: JournalImportMode.merge,
    );

    final db = await database.open();
    final account = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [_id('account', '401')],
    );
    expect(result.accountsImported, 0);
    expect(result.instrumentsImported, 1);
    expect(result.setupsImported, 1);
    expect(result.tradesImported, 1);
    expect(result.skippedConflicts, 1);
    expect(account.single['name'], 'Account 401');
    expect(await _count(db, 'accounts'), 1);
    expect(await _count(db, 'instruments'), 2);
    expect(await _count(db, 'setups'), 2);
    expect(await _count(db, 'trades'), 2);
    await db.close();
  });

  test('merge reports skipped conflicts across all v1 tables', () async {
    final database = _database();
    final executor = SqliteJournalImportExecutor(database);
    final existing = _importData('501');
    await executor.execute(data: existing, mode: JournalImportMode.replace);

    final result = await executor.execute(
      data: existing,
      mode: JournalImportMode.merge,
    );

    final db = await database.open();
    expect(result.accountsImported, 0);
    expect(result.instrumentsImported, 0);
    expect(result.setupsImported, 0);
    expect(result.tradesImported, 0);
    expect(result.skippedConflicts, 4);
    expect(await _count(db, 'accounts'), 1);
    expect(await _count(db, 'instruments'), 1);
    expect(await _count(db, 'setups'), 1);
    expect(await _count(db, 'trades'), 1);
    await db.close();
  });
}

AppDatabase _database() {
  return AppDatabase(factory: databaseFactoryFfi, path: inMemoryDatabasePath);
}

JournalImportData _importData(String suffix) {
  return JournalImportData(
    accounts: [_account(suffix)],
    instruments: [_instrument(suffix)],
    setups: [_setup(suffix)],
    trades: [_trade(suffix)],
  );
}

Account _account(String suffix, {String? name}) {
  return Account(
    id: _id('account', suffix),
    name: name ?? 'Account $suffix',
    accountType: AccountType.combine,
    currency: 'USD',
    initialBalance: 50000,
    isActive: true,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  );
}

Instrument _instrument(String suffix) {
  return Instrument(
    id: _id('instrument', suffix),
    symbol: 'NQ$suffix',
    name: null,
    isActive: true,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  );
}

Setup _setup(String suffix) {
  return Setup(
    id: _id('setup', suffix),
    name: 'Setup $suffix',
    isActive: true,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  );
}

Trade _trade(String suffix, {String? accountId}) {
  return Trade(
    id: _id('trade', suffix),
    accountId: accountId ?? _id('account', suffix),
    instrumentId: _id('instrument', suffix),
    setupId: _id('setup', suffix),
    openedAt: DateTime.utc(2026, 1, 3, 10),
    closedAt: DateTime.utc(2026, 1, 3, 11),
    direction: TradeDirection.long,
    entryPrice: 100,
    exitPrice: 105,
    stopLossPrice: 98,
    takeProfitPrice: 106,
    quantity: 2,
    riskAmount: 50,
    fees: 4,
    netPnl: 96,
    session: TradeSession.newYork,
    rating: 4,
    notes: 'sauber',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  );
}

String _id(String table, String suffix) {
  final prefix = switch (table) {
    'account' => '1',
    'instrument' => '2',
    'setup' => '3',
    'trade' => '4',
    _ => throw ArgumentError.value(table, 'table'),
  };
  return '00000000-0000-4000-8000-00000000$prefix$suffix';
}

Future<int> _count(Database db, String table) async {
  final result = await db.rawQuery('SELECT COUNT(*) AS count FROM $table');
  return result.single['count']! as int;
}

final _createdAt = DateTime.utc(2026, 1);
final _updatedAt = DateTime.utc(2026, 1, 2);
