import '../accounts/account.dart';
import '../instruments/instrument.dart';
import '../setups/setup.dart';
import '../trades/trade.dart';

class JournalExport {
  const JournalExport({
    required this.exportedAt,
    required this.data,
    this.schemaVersion = 1,
    this.app = 'trading_journal',
  });

  final int schemaVersion;
  final DateTime exportedAt;
  final String app;
  final JournalExportData data;

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt.toUtc().toIso8601String(),
      'app': app,
      'data': data.toJson(),
    };
  }
}

class JournalExportData {
  const JournalExportData({
    required this.accounts,
    required this.instruments,
    required this.setups,
    required this.trades,
  });

  final List<Account> accounts;
  final List<Instrument> instruments;
  final List<Setup> setups;
  final List<Trade> trades;

  Map<String, Object?> toJson() {
    return {
      'accounts': accounts.map(_accountToJson).toList(),
      'instruments': instruments.map(_instrumentToJson).toList(),
      'setups': setups.map(_setupToJson).toList(),
      'trades': trades.map(_tradeToJson).toList(),
    };
  }

  static Map<String, Object?> _accountToJson(Account account) {
    return {
      'id': account.id,
      'name': account.name,
      'account_type': account.accountType.dbValue,
      'currency': account.currency,
      'initial_balance': account.initialBalance,
      'is_active': account.isActive,
      'created_at': account.createdAt.toUtc().toIso8601String(),
      'updated_at': account.updatedAt.toUtc().toIso8601String(),
    };
  }

  static Map<String, Object?> _instrumentToJson(Instrument instrument) {
    return {
      'id': instrument.id,
      'symbol': instrument.symbol,
      'name': instrument.name,
      'is_active': instrument.isActive,
      'created_at': instrument.createdAt.toUtc().toIso8601String(),
      'updated_at': instrument.updatedAt.toUtc().toIso8601String(),
    };
  }

  static Map<String, Object?> _setupToJson(Setup setup) {
    return {
      'id': setup.id,
      'name': setup.name,
      'is_active': setup.isActive,
      'created_at': setup.createdAt.toUtc().toIso8601String(),
      'updated_at': setup.updatedAt.toUtc().toIso8601String(),
    };
  }

  static Map<String, Object?> _tradeToJson(Trade trade) {
    return {
      'id': trade.id,
      'account_id': trade.accountId,
      'instrument_id': trade.instrumentId,
      'setup_id': trade.setupId,
      'opened_at': trade.openedAt.toUtc().toIso8601String(),
      'closed_at': trade.closedAt?.toUtc().toIso8601String(),
      'direction': trade.direction.dbValue,
      'entry_price': trade.entryPrice,
      'exit_price': trade.exitPrice,
      'stop_loss_price': trade.stopLossPrice,
      'take_profit_price': trade.takeProfitPrice,
      'quantity': trade.quantity,
      'risk_amount': trade.riskAmount,
      'fees': trade.fees,
      'net_pnl': trade.netPnl,
      'session': trade.session?.dbValue,
      'rating': trade.rating,
      'notes': trade.notes,
      'created_at': trade.createdAt.toUtc().toIso8601String(),
      'updated_at': trade.updatedAt.toUtc().toIso8601String(),
    };
  }
}
