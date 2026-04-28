import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/accounts/account.dart';
import '../../domain/instruments/instrument.dart';
import '../../domain/trades/trade.dart';
import '../../domain/trades/trade_input.dart';
import 'trade_create_parsing.dart';
import 'trade_labels.dart';
import 'trade_providers.dart';

class TradeCreateDialog extends ConsumerStatefulWidget {
  const TradeCreateDialog({
    required this.accounts,
    required this.instruments,
    super.key,
  });

  final List<Account> accounts;
  final List<Instrument> instruments;

  @override
  ConsumerState<TradeCreateDialog> createState() => _TradeCreateDialogState();
}

class _TradeCreateDialogState extends ConsumerState<TradeCreateDialog> {
  late String _accountId;
  late String _instrumentId;
  final _openedAtController = TextEditingController(
    text: TradeCreateParsing.dateTimeText(),
  );
  final _closedAtController = TextEditingController(
    text: TradeCreateParsing.dateTimeText(),
  );
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _stopLossController = TextEditingController();
  final _takeProfitController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _riskAmountController = TextEditingController();
  final _feesController = TextEditingController();
  final _netPnlController = TextEditingController();
  final _ratingController = TextEditingController();
  final _notesController = TextEditingController();
  TradeDirection _direction = TradeDirection.long;
  TradeSession? _session;
  String? _error;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _accountId = widget.accounts.first.id;
    _instrumentId = widget.instruments.first.id;
  }

  @override
  void dispose() {
    _openedAtController.dispose();
    _closedAtController.dispose();
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _quantityController.dispose();
    _riskAmountController.dispose();
    _feesController.dispose();
    _netPnlController.dispose();
    _ratingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trade erstellen'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _accountField(),
              _instrumentField(),
              _directionField(),
              _dateField(_openedAtController, 'Geoeffnet am'),
              _dateField(_closedAtController, 'Geschlossen am'),
              _numberField(_entryPriceController, 'Einstiegspreis'),
              _numberField(_exitPriceController, 'Ausstiegspreis'),
              _numberField(_quantityController, 'Menge'),
              _numberField(_stopLossController, 'Stop Loss', required: false),
              _numberField(
                _takeProfitController,
                'Take Profit',
                required: false,
              ),
              _numberField(_riskAmountController, 'Risiko', required: false),
              _numberField(_feesController, 'Gebuehren', required: false),
              _numberField(_netPnlController, 'Netto PnL'),
              _sessionField(),
              _numberField(_ratingController, 'Rating', required: false),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notizen'),
                maxLines: 3,
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade200),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: const Text('Speichern'),
        ),
      ],
    );
  }

  Widget _accountField() {
    return DropdownButtonFormField<String>(
      initialValue: _accountId,
      decoration: const InputDecoration(labelText: 'Konto'),
      items: widget.accounts
          .map(
            (account) =>
                DropdownMenuItem(value: account.id, child: Text(account.name)),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _accountId = value);
      },
    );
  }

  Widget _instrumentField() {
    return DropdownButtonFormField<String>(
      initialValue: _instrumentId,
      decoration: const InputDecoration(labelText: 'Instrument'),
      items: widget.instruments
          .map(
            (instrument) => DropdownMenuItem(
              value: instrument.id,
              child: Text(instrument.symbol),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _instrumentId = value);
      },
    );
  }

  Widget _directionField() {
    return DropdownButtonFormField<TradeDirection>(
      initialValue: _direction,
      decoration: const InputDecoration(labelText: 'Richtung'),
      items: TradeDirection.values
          .map(
            (direction) => DropdownMenuItem(
              value: direction,
              child: Text(direction.label),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _direction = value);
      },
    );
  }

  Widget _sessionField() {
    return DropdownButtonFormField<TradeSession?>(
      initialValue: _session,
      decoration: const InputDecoration(labelText: 'Session'),
      items: [
        const DropdownMenuItem<TradeSession?>(
          value: null,
          child: Text('Keine Session'),
        ),
        ...TradeSession.values.map(
          (session) =>
              DropdownMenuItem(value: session, child: Text(session.label)),
        ),
      ],
      onChanged: (value) => setState(() => _session = value),
    );
  }

  Widget _dateField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: '$label (YYYY-MM-DD HH:MM)'),
      keyboardType: TextInputType.datetime,
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool required = true,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: required ? label : '$label optional',
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]'))],
    );
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
      _isSaving = true;
    });

    try {
      await ref.read(tradeRepositoryProvider).create(_input());
      if (mounted) Navigator.of(context).pop(true);
    } on TradeValidationException catch (error) {
      setState(() => _error = error.message);
    } on FormatException catch (error) {
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  TradeInput _input() {
    final exitPrice = TradeCreateParsing.requiredDouble(
      _exitPriceController.text,
      'Ausstiegspreis',
    );
    if (exitPrice <= 0) {
      throw const FormatException(
        'Der Ausstiegspreis muss groesser als 0 sein.',
      );
    }

    return TradeInput(
      accountId: _accountId,
      instrumentId: _instrumentId,
      setupId: null,
      openedAt: TradeCreateParsing.requiredDate(
        _openedAtController.text,
        'Eroeffnungszeit',
      ),
      closedAt: TradeCreateParsing.requiredDate(
        _closedAtController.text,
        'Schlusszeit',
      ),
      direction: _direction,
      entryPrice: TradeCreateParsing.requiredDouble(
        _entryPriceController.text,
        'Einstiegspreis',
      ),
      exitPrice: exitPrice,
      stopLossPrice: TradeCreateParsing.optionalDouble(
        _stopLossController.text,
      ),
      takeProfitPrice: TradeCreateParsing.optionalDouble(
        _takeProfitController.text,
      ),
      quantity: TradeCreateParsing.requiredDouble(
        _quantityController.text,
        'Menge',
      ),
      riskAmount: TradeCreateParsing.optionalDouble(_riskAmountController.text),
      fees: TradeCreateParsing.optionalDouble(_feesController.text),
      netPnl: TradeCreateParsing.requiredDouble(
        _netPnlController.text,
        'Netto PnL',
      ),
      session: _session,
      rating: TradeCreateParsing.optionalInt(_ratingController.text),
      notes: _notesController.text,
    );
  }
}
