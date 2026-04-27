import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/accounts/account.dart';
import '../../domain/accounts/account_input.dart';
import 'account_providers.dart';
import 'account_type_label.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konten'),
        actions: [
          IconButton(
            tooltip: 'Aktualisieren',
            onPressed: () => ref.invalidate(accountsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: accounts.when(
        data: (items) => _AccountList(accounts: items),
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAccountDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Konto'),
      ),
    );
  }
}

class _AccountList extends StatelessWidget {
  const _AccountList({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const Center(child: Text('Noch keine Konten erfasst.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: accounts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Card(
          child: ListTile(
            title: Text(account.name),
            subtitle: Text('${account.accountType.label} - ${account.currency}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(account.initialBalance.toStringAsFixed(2)),
                Text(account.isActive ? 'Aktiv' : 'Inaktiv'),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showAccountDialog(BuildContext context, WidgetRef ref) async {
  await showDialog<void>(
    context: context,
    builder: (context) => const _AccountDialog(),
  );
  ref.invalidate(accountsProvider);
}

class _AccountDialog extends ConsumerStatefulWidget {
  const _AccountDialog();

  @override
  ConsumerState<_AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends ConsumerState<_AccountDialog> {
  final _nameController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _initialBalanceController = TextEditingController();
  AccountType _accountType = AccountType.combine;
  bool _isActive = true;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Konto erstellen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            DropdownButtonFormField<AccountType>(
              value: _accountType,
              decoration: const InputDecoration(labelText: 'Kontotyp'),
              items: AccountType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _accountType = value);
                }
              },
            ),
            TextFormField(
              controller: _currencyController,
              decoration: const InputDecoration(labelText: 'Waehrung'),
              textCapitalization: TextCapitalization.characters,
            ),
            TextFormField(
              controller: _initialBalanceController,
              decoration: const InputDecoration(labelText: 'Startbalance'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aktiv'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red.shade200)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Speichern'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _error = null);
    final balance = double.tryParse(_initialBalanceController.text) ?? 0;
    final input = AccountInput(
      name: _nameController.text,
      accountType: _accountType,
      currency: _currencyController.text,
      initialBalance: balance,
      isActive: _isActive,
    );

    try {
      await ref.read(accountRepositoryProvider).create(input);
      ref.invalidate(accountsProvider);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on AccountValidationException catch (error) {
      setState(() => _error = error.message);
    }
  }
}
