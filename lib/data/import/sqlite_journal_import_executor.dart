import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../domain/import/journal_import.dart';
import '../../domain/import/journal_import_execution.dart';
import '../accounts/account_mapper.dart';
import '../database/app_database.dart';
import '../instruments/instrument_mapper.dart';
import '../setups/setup_mapper.dart';
import '../trades/trade_mapper.dart';

class SqliteJournalImportExecutor implements JournalImportExecutor {
  const SqliteJournalImportExecutor(this._database);

  final AppDatabase _database;

  @override
  Future<JournalImportResult> execute({
    required JournalImportData data,
    required JournalImportMode mode,
  }) async {
    return switch (mode) {
      JournalImportMode.replace => _replace(data),
      JournalImportMode.merge => _merge(data),
    };
  }

  Future<JournalImportResult> _replace(JournalImportData data) async {
    final db = await _database.open();
    return db.transaction((txn) async {
      await _clearV1Tables(txn);
      await _insertAll(txn, data);
      return JournalImportResult(
        mode: JournalImportMode.replace,
        accountsImported: data.accounts.length,
        instrumentsImported: data.instruments.length,
        setupsImported: data.setups.length,
        tradesImported: data.trades.length,
        skippedConflicts: 0,
      );
    });
  }

  Future<JournalImportResult> _merge(JournalImportData data) async {
    final db = await _database.open();
    return db.transaction((txn) async {
      var accountsImported = 0;
      var instrumentsImported = 0;
      var setupsImported = 0;
      var tradesImported = 0;
      var skippedConflicts = 0;

      for (final account in data.accounts) {
        if (await _exists(txn, 'accounts', account.id)) {
          skippedConflicts++;
        } else {
          await txn.insert('accounts', AccountMapper.toInsertMap(account));
          accountsImported++;
        }
      }
      for (final instrument in data.instruments) {
        if (await _exists(txn, 'instruments', instrument.id)) {
          skippedConflicts++;
        } else {
          await txn.insert(
            'instruments',
            InstrumentMapper.toInsertMap(instrument),
          );
          instrumentsImported++;
        }
      }
      for (final setup in data.setups) {
        if (await _exists(txn, 'setups', setup.id)) {
          skippedConflicts++;
        } else {
          await txn.insert('setups', SetupMapper.toInsertMap(setup));
          setupsImported++;
        }
      }
      for (final trade in data.trades) {
        if (await _exists(txn, 'trades', trade.id)) {
          skippedConflicts++;
        } else {
          await txn.insert('trades', TradeMapper.toInsertMap(trade));
          tradesImported++;
        }
      }

      return JournalImportResult(
        mode: JournalImportMode.merge,
        accountsImported: accountsImported,
        instrumentsImported: instrumentsImported,
        setupsImported: setupsImported,
        tradesImported: tradesImported,
        skippedConflicts: skippedConflicts,
      );
    });
  }

  Future<void> _clearV1Tables(Transaction txn) async {
    await txn.delete('trades');
    await txn.delete('setups');
    await txn.delete('instruments');
    await txn.delete('accounts');
  }

  Future<void> _insertAll(Transaction txn, JournalImportData data) async {
    for (final account in data.accounts) {
      await txn.insert('accounts', AccountMapper.toInsertMap(account));
    }
    for (final instrument in data.instruments) {
      await txn.insert('instruments', InstrumentMapper.toInsertMap(instrument));
    }
    for (final setup in data.setups) {
      await txn.insert('setups', SetupMapper.toInsertMap(setup));
    }
    for (final trade in data.trades) {
      await txn.insert('trades', TradeMapper.toInsertMap(trade));
    }
  }

  Future<bool> _exists(Transaction txn, String table, String id) async {
    final rows = await txn.query(
      table,
      columns: const ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
