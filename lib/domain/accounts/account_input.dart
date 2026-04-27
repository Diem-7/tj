import 'account.dart';

class AccountInput {
  const AccountInput({
    required this.name,
    required this.accountType,
    required this.currency,
    required this.initialBalance,
    required this.isActive,
  });

  final String name;
  final AccountType accountType;
  final String currency;
  final double initialBalance;
  final bool isActive;

  void validate() {
    if (name.trim().isEmpty) {
      throw const AccountValidationException('Der Name ist erforderlich.');
    }
    if (currency.trim().isEmpty) {
      throw const AccountValidationException('Die Waehrung ist erforderlich.');
    }
    if (initialBalance < 0) {
      throw const AccountValidationException(
        'Die Startbalance darf nicht negativ sein.',
      );
    }
  }
}

class AccountValidationException implements Exception {
  const AccountValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
