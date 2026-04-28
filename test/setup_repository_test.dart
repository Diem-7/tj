import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tj/data/database/app_database.dart';
import 'package:tj/data/setups/sqlite_setup_repository.dart';

void main() {
  test('lists setups from sqlite without seeds', () async {
    final database = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final repository = SqliteSetupRepository(database);

    final setups = await repository.watchableList();
    final db = await database.open();
    final columns = await db.rawQuery('PRAGMA table_info(setups)');

    expect(setups, isEmpty);
    expect(columns.map((row) => row['name']), contains('id'));
    expect(columns.map((row) => row['name']), contains('name'));
    expect(columns.map((row) => row['name']), contains('is_active'));
    await db.close();
  });
}
