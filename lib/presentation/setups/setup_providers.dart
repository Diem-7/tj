import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/setups/sqlite_setup_repository.dart';
import '../../domain/setups/setup.dart';
import '../../domain/setups/setup_repository.dart';
import '../accounts/account_providers.dart';

final setupRepositoryProvider = Provider<SetupRepository>((ref) {
  return SqliteSetupRepository(ref.watch(appDatabaseProvider));
});

final setupsProvider = FutureProvider<List<Setup>>((ref) async {
  return ref.watch(setupRepositoryProvider).watchableList();
});
