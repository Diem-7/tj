import 'package:flutter_test/flutter_test.dart';
import 'package:tj/domain/accounts/account.dart';
import 'package:tj/domain/accounts/account_input.dart';
import 'package:tj/domain/accounts/account_repository.dart';
import 'package:tj/domain/export/journal_export_service.dart';
import 'package:tj/domain/instruments/instrument.dart';
import 'package:tj/domain/instruments/instrument_repository.dart';
import 'package:tj/domain/setups/setup.dart';
import 'package:tj/domain/setups/setup_repository.dart';
import 'package:tj/domain/trades/trade.dart';
import 'package:tj/domain/trades/trade_input.dart';
import 'package:tj/domain/trades/trade_repository.dart';

void main() {
  test('creates json export with documented top-level shape', () async {
    final createdAt = DateTime.utc(2026, 1, 1);
    final updatedAt = DateTime.utc(2026, 1, 2);
    final service = JournalExportService(
      accountRepository: _AccountRepository([
        Account(
          id: 'account-id',
          name: 'Combine',
          accountType: AccountType.combine,
          currency: 'USD',
          initialBalance: 50000,
          isActive: true,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      ]),
      instrumentRepository: _InstrumentRepository([
        Instrument(
          id: 'instrument-id',
          symbol: 'NQ',
          name: null,
          isActive: true,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      ]),
      setupRepository: _SetupRepository([
        Setup(
          id: 'setup-id',
          name: 'Opening Drive',
          isActive: true,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      ]),
      tradeRepository: _TradeRepository([
        Trade(
          id: 'trade-id',
          accountId: 'account-id',
          instrumentId: 'instrument-id',
          setupId: 'setup-id',
          openedAt: DateTime.utc(2026, 1, 3, 10),
          closedAt: DateTime.utc(2026, 1, 3, 11),
          direction: TradeDirection.long,
          entryPrice: 100,
          exitPrice: 105,
          stopLossPrice: 98,
          takeProfitPrice: 106,
          quantity: 2,
          riskAmount: 50,
          fees: 4,
          netPnl: 96,
          session: TradeSession.newYork,
          rating: 4,
          notes: 'sauber',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      ]),
      now: () => DateTime.utc(2026, 1, 4, 12),
    );

    final export = await service.createExport();
    final json = export.toJson();
    final data = json['data']! as Map<String, Object?>;
    final trades = data['trades']! as List<Map<String, Object?>>;

    expect(json['schemaVersion'], 1);
    expect(json['exportedAt'], '2026-01-04T12:00:00.000Z');
    expect(json['app'], 'trading_journal');
    expect(
      data.keys,
      containsAll(['accounts', 'instruments', 'setups', 'trades']),
    );
    expect(data['accounts'], hasLength(1));
    expect(data['instruments'], hasLength(1));
    expect(data['setups'], hasLength(1));
    expect(trades, hasLength(1));
    expect(trades.single['net_pnl'], 96);
    expect(trades.single['session'], 'new_york');
    expect(trades.single.keys, isNot(contains('r_multiple')));
  });
}

class _AccountRepository implements AccountRepository {
  const _AccountRepository(this._accounts);

  final List<Account> _accounts;

  @override
  Future<List<Account>> watchableList() async => _accounts;

  @override
  Future<void> create(AccountInput input) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(String id, AccountInput input) {
    throw UnimplementedError();
  }
}

class _InstrumentRepository implements InstrumentRepository {
  const _InstrumentRepository(this._instruments);

  final List<Instrument> _instruments;

  @override
  Future<List<Instrument>> watchableList() async => _instruments;
}

class _SetupRepository implements SetupRepository {
  const _SetupRepository(this._setups);

  final List<Setup> _setups;

  @override
  Future<List<Setup>> watchableList() async => _setups;
}

class _TradeRepository implements TradeRepository {
  const _TradeRepository(this._trades);

  final List<Trade> _trades;

  @override
  Future<List<Trade>> watchableList() async => _trades;

  @override
  Future<void> create(TradeInput input) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(String id, TradeInput input) {
    throw UnimplementedError();
  }
}
