import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'export_providers.dart';

class ExportAction extends ConsumerStatefulWidget {
  const ExportAction({super.key});

  @override
  ConsumerState<ExportAction> createState() => _ExportActionState();
}

class _ExportActionState extends ConsumerState<ExportAction> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Journal exportieren',
      onPressed: _isSaving ? null : _saveExport,
      icon: _isSaving
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.ios_share_outlined),
    );
  }

  Future<void> _saveExport() async {
    setState(() => _isSaving = true);

    try {
      final export = await ref
          .read(journalExportServiceProvider)
          .createExport();
      final fileName = _exportFileName(export.exportedAt);
      final location = await getSaveLocation(
        suggestedName: fileName,
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
      if (location == null) {
        _showMessage('Export abgebrochen.');
        return;
      }

      final json = const JsonEncoder.withIndent('  ').convert(export.toJson());
      final bytes = Uint8List.fromList(utf8.encode(json));
      final file = XFile.fromData(
        bytes,
        mimeType: 'application/json',
        name: fileName,
      );
      await file.saveTo(location.path);

      if (mounted) {
        _showMessage('Export gespeichert.');
      }
    } catch (error) {
      if (mounted) {
        _showMessage('Export fehlgeschlagen: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _exportFileName(DateTime exportedAt) {
    final timestamp = exportedAt
        .toUtc()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    return 'trading_journal_export_$timestamp.json';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
