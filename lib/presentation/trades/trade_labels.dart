import '../../domain/trades/trade.dart';

extension TradeDirectionLabel on TradeDirection {
  String get label {
    return switch (this) {
      TradeDirection.long => 'Long',
      TradeDirection.short => 'Short',
    };
  }
}

extension TradeSessionLabel on TradeSession {
  String get label {
    return switch (this) {
      TradeSession.asia => 'Asien',
      TradeSession.london => 'London',
      TradeSession.newYork => 'New York',
    };
  }
}
