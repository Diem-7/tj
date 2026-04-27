import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase({DatabaseFactory? factory, String? path})
    : _factory = factory,
      _path = path;

  final DatabaseFactory? _factory;
  final String? _path;
  Database? _database;

  Future<Database> open() async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }

    sqfliteFfiInit();
    final factory = _factory ?? databaseFactoryFfi;
    final configuredPath = _path;
    final path = configuredPath ?? await _defaultPath(factory);

    final database = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await _createAccountsTable(db);
          await _createInstrumentsTable(db);
          await _seedInstruments(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await _createInstrumentsTable(db);
            await _seedInstruments(db);
          }
        },
      ),
    );
    _database = database;
    return database;
  }

  Future<void> _createAccountsTable(Database db) async {
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
  }

  Future<void> _createInstrumentsTable(Database db) async {
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
  }

  Future<void> _seedInstruments(Database db) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await db.insert('instruments', {
      'id': '00000000-0000-4000-8000-000000000001',
      'symbol': 'NQ',
      'name': null,
      'is_active': 1,
      'created_at': now,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('instruments', {
      'id': '00000000-0000-4000-8000-000000000002',
      'symbol': 'MNQ',
      'name': null,
      'is_active': 1,
      'created_at': now,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<String> _defaultPath(DatabaseFactory factory) async {
    final basePath = await factory.getDatabasesPath();
    await Directory(basePath).create(recursive: true);
    return '$basePath${Platform.pathSeparator}trading_journal.sqlite';
  }
}
