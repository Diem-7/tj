import 'trade.dart';
import 'trade_input.dart';

abstract interface class TradeRepository {
  Future<List<Trade>> watchableList();

  Future<void> create(TradeInput input);

  Future<void> update(String id, TradeInput input);
}
