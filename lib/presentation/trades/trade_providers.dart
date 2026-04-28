import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/trades/sqlite_trade_repository.dart';
import '../../domain/performance/performance_summary.dart';
import '../../domain/trades/trade.dart';
import '../../domain/trades/trade_filter.dart';
import '../../domain/trades/trade_repository.dart';
import '../accounts/account_providers.dart';

final tradeRepositoryProvider = Provider<TradeRepository>((ref) {
  return SqliteTradeRepository(ref.watch(appDatabaseProvider));
});

final tradesProvider = FutureProvider<List<Trade>>((ref) async {
  return ref.watch(tradeRepositoryProvider).watchableList();
});

final tradeFilterProvider = NotifierProvider<TradeFilterNotifier, TradeFilter>(
  TradeFilterNotifier.new,
);

class TradeFilterNotifier extends Notifier<TradeFilter> {
  @override
  TradeFilter build() {
    return const TradeFilter();
  }

  void setAccountId(String? value) {
    state = state.copyWith(accountId: value, clearAccountId: value == null);
  }

  void setInstrumentId(String? value) {
    state = state.copyWith(
      instrumentId: value,
      clearInstrumentId: value == null,
    );
  }

  void setSession(TradeSession? value) {
    state = state.copyWith(session: value, clearSession: value == null);
  }

  void setClosedDateFrom(DateTime? value) {
    state = state.copyWith(
      closedDateFrom: value,
      clearClosedDateFrom: value == null,
    );
  }

  void setClosedDateTo(DateTime? value) {
    state = state.copyWith(
      closedDateTo: value,
      clearClosedDateTo: value == null,
    );
  }

  void reset() {
    state = const TradeFilter();
  }
}

final filteredTradesProvider = FutureProvider<List<Trade>>((ref) async {
  final trades = await ref.watch(tradesProvider.future);
  final filter = ref.watch(tradeFilterProvider);
  return filter.apply(trades);
});

final performanceSummaryProvider = FutureProvider<PerformanceSummary>((
  ref,
) async {
  final trades = await ref.watch(filteredTradesProvider.future);
  return PerformanceSummary.fromTrades(trades);
});
