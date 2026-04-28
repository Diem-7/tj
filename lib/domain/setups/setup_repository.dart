import 'setup.dart';

abstract interface class SetupRepository {
  Future<List<Setup>> watchableList();
}
