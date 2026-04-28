import '../accounts/account.dart';
import '../instruments/instrument.dart';
import '../setups/setup.dart';
import '../trades/trade.dart';
import 'journal_import.dart';

class JournalImportParser {
  const JournalImportParser();

  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  JournalImport parse(Map<String, Object?> json) {
    final schemaVersion = _requiredInt(json, 'schemaVersion');
    if (schemaVersion != 1) {
      throw const JournalImportException('Unsupported schemaVersion.');
    }

    final app = _requiredString(json, 'app');
    if (app != 'trading_journal') {
      throw const JournalImportException('Unsupported app.');
    }

    return JournalImport(
      schemaVersion: schemaVersion,
      exportedAt: _requiredDate(json, 'exportedAt'),
      app: app,
      data: _parseData(_requiredMap(json, 'data')),
    );
  }

  JournalImportData _parseData(Map<String, Object?> json) {
    return JournalImportData(
      accounts: _requiredRows(
        json,
        'accounts',
      ).map(_parseAccount).toList(growable: false),
      instruments: _requiredRows(
        json,
        'instruments',
      ).map(_parseInstrument).toList(growable: false),
      setups: _requiredRows(
        json,
        'setups',
      ).map(_parseSetup).toList(growable: false),
      trades: _requiredRows(
        json,
        'trades',
      ).map(_parseTrade).toList(growable: false),
    );
  }

  Account _parseAccount(Map<String, Object?> json) {
    return Account(
      id: _requiredUuid(json, 'id'),
      name: _requiredString(json, 'name'),
      accountType: _requiredAccountType(json, 'account_type'),
      currency: _requiredString(json, 'currency'),
      initialBalance: _requiredDouble(json, 'initial_balance'),
      isActive: _requiredBool(json, 'is_active'),
      createdAt: _requiredDate(json, 'created_at'),
      updatedAt: _requiredDate(json, 'updated_at'),
    );
  }

  Instrument _parseInstrument(Map<String, Object?> json) {
    return Instrument(
      id: _requiredUuid(json, 'id'),
      symbol: _requiredString(json, 'symbol'),
      name: _optionalString(json, 'name'),
      isActive: _requiredBool(json, 'is_active'),
      createdAt: _requiredDate(json, 'created_at'),
      updatedAt: _requiredDate(json, 'updated_at'),
    );
  }

  Setup _parseSetup(Map<String, Object?> json) {
    return Setup(
      id: _requiredUuid(json, 'id'),
      name: _requiredString(json, 'name'),
      isActive: _requiredBool(json, 'is_active'),
      createdAt: _requiredDate(json, 'created_at'),
      updatedAt: _requiredDate(json, 'updated_at'),
    );
  }

  Trade _parseTrade(Map<String, Object?> json) {
    final closedAt = _optionalDate(json, 'closed_at');
    final exitPrice = _optionalDouble(json, 'exit_price');
    final netPnl = _optionalDouble(json, 'net_pnl');
    if (closedAt != null || exitPrice != null) {
      if (closedAt == null || exitPrice == null || netPnl == null) {
        throw const JournalImportException('Invalid closed trade.');
      }
    }

    final quantity = _requiredDouble(json, 'quantity');
    if (quantity <= 0) {
      throw const JournalImportException(
        'Trade quantity must be greater than zero.',
      );
    }

    return Trade(
      id: _requiredUuid(json, 'id'),
      accountId: _requiredUuid(json, 'account_id'),
      instrumentId: _requiredUuid(json, 'instrument_id'),
      setupId: _optionalUuid(json, 'setup_id'),
      openedAt: _requiredDate(json, 'opened_at'),
      closedAt: closedAt,
      direction: _requiredTradeDirection(json, 'direction'),
      entryPrice: _requiredDouble(json, 'entry_price'),
      exitPrice: exitPrice,
      stopLossPrice: _optionalDouble(json, 'stop_loss_price'),
      takeProfitPrice: _optionalDouble(json, 'take_profit_price'),
      quantity: quantity,
      riskAmount: _optionalDouble(json, 'risk_amount'),
      fees: _optionalDouble(json, 'fees'),
      netPnl: netPnl,
      session: _optionalTradeSession(json, 'session'),
      rating: _optionalInt(json, 'rating'),
      notes: _optionalString(json, 'notes'),
      createdAt: _requiredDate(json, 'created_at'),
      updatedAt: _requiredDate(json, 'updated_at'),
    );
  }

  AccountType _requiredAccountType(Map<String, Object?> json, String key) {
    final value = _requiredString(json, key);
    for (final type in AccountType.values) {
      if (type.dbValue == value) {
        return type;
      }
    }
    throw JournalImportException('Invalid $key.');
  }

  TradeDirection _requiredTradeDirection(
    Map<String, Object?> json,
    String key,
  ) {
    final value = _requiredString(json, key);
    for (final direction in TradeDirection.values) {
      if (direction.dbValue == value) {
        return direction;
      }
    }
    throw JournalImportException('Invalid $key.');
  }

  TradeSession? _optionalTradeSession(Map<String, Object?> json, String key) {
    final value = _optionalString(json, key);
    if (value == null) {
      return null;
    }
    for (final session in TradeSession.values) {
      if (session.dbValue == value) {
        return session;
      }
    }
    throw JournalImportException('Invalid $key.');
  }

  List<Map<String, Object?>> _requiredRows(
    Map<String, Object?> json,
    String key,
  ) {
    final value = json[key];
    if (value is! List) {
      throw JournalImportException('Missing $key array.');
    }
    return value
        .map((row) {
          if (row is Map<String, Object?>) {
            return row;
          }
          if (row is Map) {
            return Map<String, Object?>.from(row);
          }
          throw JournalImportException('Invalid $key row.');
        })
        .toList(growable: false);
  }

  Map<String, Object?> _requiredMap(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return Map<String, Object?>.from(value);
    }
    throw JournalImportException('Missing $key object.');
  }

  String _requiredString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    throw JournalImportException('Missing $key.');
  }

  String? _optionalString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    throw JournalImportException('Invalid $key.');
  }

  String _requiredUuid(Map<String, Object?> json, String key) {
    final value = _requiredString(json, key);
    if (_uuidPattern.hasMatch(value)) {
      return value;
    }
    throw JournalImportException('Invalid $key.');
  }

  String? _optionalUuid(Map<String, Object?> json, String key) {
    final value = _optionalString(json, key);
    if (value == null || _uuidPattern.hasMatch(value)) {
      return value;
    }
    throw JournalImportException('Invalid $key.');
  }

  int _requiredInt(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is int) {
      return value;
    }
    throw JournalImportException('Missing $key.');
  }

  int? _optionalInt(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    throw JournalImportException('Invalid $key.');
  }

  double _requiredDouble(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    throw JournalImportException('Missing $key.');
  }

  double? _optionalDouble(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    throw JournalImportException('Invalid $key.');
  }

  bool _requiredBool(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    throw JournalImportException('Missing $key.');
  }

  DateTime _requiredDate(Map<String, Object?> json, String key) {
    final value = _requiredString(json, key);
    final date = DateTime.tryParse(value);
    if (date != null) {
      return date;
    }
    throw JournalImportException('Invalid $key.');
  }

  DateTime? _optionalDate(Map<String, Object?> json, String key) {
    final value = _optionalString(json, key);
    if (value == null) {
      return null;
    }
    final date = DateTime.tryParse(value);
    if (date != null) {
      return date;
    }
    throw JournalImportException('Invalid $key.');
  }
}
