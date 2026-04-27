import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase({DatabaseFactory? factory}) : _factory = factory;

  final DatabaseFactory? _factory;
  Database? _database;

  Future<Database> open() async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }

    sqfliteFfiInit();
    final factory = _factory ?? databaseFactoryFfi;
    final basePath = await factory.getDatabasesPath();
    await Directory(basePath).create(recursive: true);
    final path = '$basePath${Platform.pathSeparator}trading_journal.sqlite';

    final database = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
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
        },
      ),
    );
    _database = database;
    return database;
  }
}
