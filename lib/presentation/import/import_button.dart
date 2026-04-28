import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/import/journal_import.dart';
import '../../domain/import/journal_import_execution.dart';
import '../accounts/account_providers.dart';
import '../instruments/instrument_providers.dart';
import '../setups/setup_providers.dart';
import '../trades/trade_providers.dart';
import 'import_error_message.dart';
import 'import_providers.dart';

class ImportButton extends ConsumerStatefulWidget {
  const ImportButton({super.key});

  @override
  ConsumerState<ImportButton> createState() => _ImportButtonState();
}

class _ImportButtonState extends ConsumerState<ImportButton> {
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Journal importieren',
      onPressed: _isImporting ? null : _importJson,
      icon: _isImporting
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.file_upload_outlined),
    );
  }

  Future<void> _importJson() async {
    setState(() => _isImporting = true);

    try {
      final file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'JSON',
            extensions: ['json'],
            mimeTypes: ['application/json'],
            uniformTypeIdentifiers: ['public.json'],
          ),
        ],
      );

      if (!mounted) {
        return;
      }
      if (file == null) {
        _showMessage('Import abgebrochen.');
        return;
      }

      final jsonText = await file.readAsString();
      final action = ref.read(importActionProvider);
      final data = action.parseJsonText(jsonText);

      if (!mounted) {
        return;
      }
      final mode = await _confirmMode(data);
      if (!mounted) {
        return;
      }
      if (mode == null) {
        _showMessage('Import abgebrochen.');
        return;
      }

      final result = await action.executeJsonText(
        jsonText: jsonText,
        mode: mode,
      );

      _refreshImportedData();
      if (mounted) {
        _showMessage(_successMessage(result));
      }
    } catch (error) {
      if (mounted) {
        _showMessage(_errorMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  Future<JournalImportMode?> _confirmMode(JournalImportData data) {
    return showDialog<JournalImportMode>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Import bestaetigen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Diese Daten wurden in der Datei gefunden:'),
              const SizedBox(height: 12),
              _PreviewRow(label: 'Konten', count: data.accounts.length),
              _PreviewRow(label: 'Instrumente', count: data.instruments.length),
              _PreviewRow(label: 'Setups', count: data.setups.length),
              _PreviewRow(label: 'Trades', count: data.trades.length),
              const SizedBox(height: 12),
              const Text(
                'Waehle Ersetzen oder Zusammenfuehren, bevor Daten geaendert '
                'werden.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(JournalImportMode.merge),
              child: const Text('Zusammenfuehren'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(JournalImportMode.replace),
              child: const Text('Ersetzen'),
            ),
          ],
        );
      },
    );
  }

  void _refreshImportedData() {
    ref
      ..invalidate(accountsProvider)
      ..invalidate(instrumentsProvider)
      ..invalidate(setupsProvider)
      ..invalidate(tradesProvider)
      ..invalidate(filteredTradesProvider)
      ..invalidate(performanceSummaryProvider);
  }

  String _successMessage(JournalImportResult result) {
    final mode = switch (result.mode) {
      JournalImportMode.replace => 'Ersetzen',
      JournalImportMode.merge => 'Zusammenfuehren',
    };
    return '$mode abgeschlossen: ${result.accountsImported} Konten, '
        '${result.instrumentsImported} Instrumente, ${result.setupsImported} '
        'Setups, ${result.tradesImported} Trades importiert, '
        '${result.skippedConflicts} Konflikte uebersprungen.';
  }

  String _errorMessage(Object error) {
    return importErrorMessage(error);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 120, child: Text(label)),
          Text(count.toString()),
        ],
      ),
    );
  }
}
