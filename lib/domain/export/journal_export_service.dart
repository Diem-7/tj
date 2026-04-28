import '../accounts/account_repository.dart';
import '../instruments/instrument_repository.dart';
import '../setups/setup_repository.dart';
import '../trades/trade_repository.dart';
import 'journal_export.dart';

class JournalExportService {
  const JournalExportService({
    required AccountRepository accountRepository,
    required InstrumentRepository instrumentRepository,
    required SetupRepository setupRepository,
    required TradeRepository tradeRepository,
    DateTime Function()? now,
  }) : _accountRepository = accountRepository,
       _instrumentRepository = instrumentRepository,
       _setupRepository = setupRepository,
       _tradeRepository = tradeRepository,
       _now = now ?? DateTime.now;

  final AccountRepository _accountRepository;
  final InstrumentRepository _instrumentRepository;
  final SetupRepository _setupRepository;
  final TradeRepository _tradeRepository;
  final DateTime Function() _now;

  Future<JournalExport> createExport() async {
    final accounts = await _accountRepository.watchableList();
    final instruments = await _instrumentRepository.watchableList();
    final setups = await _setupRepository.watchableList();
    final trades = await _tradeRepository.watchableList();

    return JournalExport(
      exportedAt: _now().toUtc(),
      data: JournalExportData(
        accounts: accounts,
        instruments: instruments,
        setups: setups,
        trades: trades,
      ),
    );
  }
}
