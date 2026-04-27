import 'instrument.dart';

abstract interface class InstrumentRepository {
  Future<List<Instrument>> watchableList();
}
