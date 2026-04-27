import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/accounts/sqlite_account_repository.dart';
import '../../data/database/app_database.dart';
import '../../domain/accounts/account.dart';
import '../../domain/accounts/account_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return SqliteAccountRepository(ref.watch(appDatabaseProvider));
});

final accountsProvider = FutureProvider<List<Account>>((ref) async {
  return ref.watch(accountRepositoryProvider).watchableList();
});
