import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/accounts/account.dart';
import '../../domain/instruments/instrument.dart';
import '../../domain/trades/trade.dart';
import '../../domain/trades/trade_input.dart';
import 'trade_create_parsing.dart';
import 'trade_form_formatting.dart';
import 'trade_form_input.dart';
import 'trade_labels.dart';

class TradeFormDialog extends StatefulWidget {
  const TradeFormDialog({
    required this.title,
    required this.accounts,
    required this.instruments,
    required this.onSave,
    this.initialTrade,
    super.key,
  });

  final String title;
  final List<Account> accounts;
  final List<Instrument> instruments;
  final Trade? initialTrade;
  final Future<void> Function(TradeInput input) onSave;

  @override
  State<TradeFormDialog> createState() => _TradeFormDialogState();
}

class _TradeFormDialogState extends State<TradeFormDialog> {
  late String _accountId;
  late String _instrumentId;
  late final TextEditingController _openedAtController;
  late final TextEditingController _closedAtController;
  late final TextEditingController _entryPriceController;
  late final TextEditingController _exitPriceController;
  late final TextEditingController _stopLossController;
  late final TextEditingController _takeProfitController;
  late final TextEditingController _quantityController;
  late final TextEditingController _riskAmountController;
  late final TextEditingController _feesController;
  late final TextEditingController _netPnlController;
  late final TextEditingController _ratingController;
  late final TextEditingController _notesController;
  late TradeDirection _direction;
  late TradeSession? _session;
  String? _error;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final trade = widget.initialTrade;
    _accountId = trade?.accountId ?? widget.accounts.first.id;
    _instrumentId = trade?.instrumentId ?? widget.instruments.first.id;
    _direction = trade?.direction ?? TradeDirection.long;
    _session = trade?.session;
    _openedAtController = TextEditingController(
      text:
          TradeFormFormatting.dateText(trade?.openedAt) ??
          TradeCreateParsing.dateTimeText(),
    );
    _closedAtController = TextEditingController(
      text:
          TradeFormFormatting.dateText(trade?.closedAt) ??
          TradeCreateParsing.dateTimeText(),
    );
    _entryPriceController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.entryPrice),
    );
    _exitPriceController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.exitPrice),
    );
    _stopLossController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.stopLossPrice),
    );
    _takeProfitController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.takeProfitPrice),
    );
    _quantityController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.quantity) ?? '1',
    );
    _riskAmountController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.riskAmount),
    );
    _feesController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.fees),
    );
    _netPnlController = TextEditingController(
      text: TradeFormFormatting.numberText(trade?.netPnl),
    );
    _ratingController = TextEditingController(text: trade?.rating?.toString());
    _notesController = TextEditingController(text: trade?.notes);
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
      title: Text(widget.title),
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
      await widget.onSave(_input());
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
    return TradeFormInput.fromFields(
      accountId: _accountId,
      instrumentId: _instrumentId,
      setupId: widget.initialTrade?.setupId,
      openedAt: _openedAtController.text,
      closedAt: _closedAtController.text,
      direction: _direction,
      entryPrice: _entryPriceController.text,
      exitPrice: _exitPriceController.text,
      stopLossPrice: _stopLossController.text,
      takeProfitPrice: _takeProfitController.text,
      quantity: _quantityController.text,
      riskAmount: _riskAmountController.text,
      fees: _feesController.text,
      netPnl: _netPnlController.text,
      session: _session,
      rating: _ratingController.text,
      notes: _notesController.text,
    );
  }
}
