import '../../domain/setups/setup.dart';
import '../../domain/setups/setup_repository.dart';
import '../database/app_database.dart';
import 'setup_mapper.dart';

class SqliteSetupRepository implements SetupRepository {
  const SqliteSetupRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Setup>> watchableList() async {
    final db = await _database.open();
    final rows = await db.query('setups', orderBy: 'name ASC');
    return rows.map(SetupMapper.fromMap).toList();
  }
}
