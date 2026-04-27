import '../../domain/instruments/instrument.dart';
import '../../domain/instruments/instrument_repository.dart';
import '../database/app_database.dart';
import 'instrument_mapper.dart';

class SqliteInstrumentRepository implements InstrumentRepository {
  const SqliteInstrumentRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Instrument>> watchableList() async {
    final db = await _database.open();
    final rows = await db.query('instruments', orderBy: 'symbol ASC');
    return rows.map(InstrumentMapper.fromMap).toList();
  }
}
