import 'package:uuid/uuid.dart';

import '../../domain/accounts/account.dart';
import '../../domain/accounts/account_input.dart';
import '../../domain/accounts/account_repository.dart';
import '../database/app_database.dart';
import 'account_mapper.dart';

class SqliteAccountRepository implements AccountRepository {
  SqliteAccountRepository(this._database, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final Uuid _uuid;

  @override
  Future<List<Account>> watchableList() async {
    final db = await _database.open();
    final rows = await db.query('accounts', orderBy: 'created_at DESC');
    return rows.map(AccountMapper.fromMap).toList();
  }

  @override
  Future<void> create(AccountInput input) async {
    input.validate();
    final now = DateTime.now().toUtc();
    final account = Account(
      id: _uuid.v4(),
      name: input.name.trim(),
      accountType: input.accountType,
      currency: _normalizeCurrency(input.currency),
      initialBalance: input.initialBalance,
      isActive: input.isActive,
      createdAt: now,
      updatedAt: now,
    );

    final db = await _database.open();
    await db.insert('accounts', AccountMapper.toInsertMap(account));
  }

  @override
  Future<void> update(String id, AccountInput input) async {
    input.validate();
    final db = await _database.open();
    final existing = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (existing.isEmpty) {
      return;
    }

    final current = AccountMapper.fromMap(existing.single);
    final account = Account(
      id: current.id,
      name: input.name.trim(),
      accountType: input.accountType,
      currency: _normalizeCurrency(input.currency),
      initialBalance: input.initialBalance,
      isActive: input.isActive,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    await db.update(
      'accounts',
      AccountMapper.toUpdateMap(account),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  String _normalizeCurrency(String value) => value.trim().toUpperCase();
}
