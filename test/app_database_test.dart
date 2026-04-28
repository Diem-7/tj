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
}
