import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/trades/sqlite_trade_repository.dart';
import '../../domain/trades/trade.dart';
import '../../domain/trades/trade_repository.dart';
import '../accounts/account_providers.dart';

final tradeRepositoryProvider = Provider<TradeRepository>((ref) {
  return SqliteTradeRepository(ref.watch(appDatabaseProvider));
});

final tradesProvider = FutureProvider<List<Trade>>((ref) async {
  return ref.watch(tradeRepositoryProvider).watchableList();
});
