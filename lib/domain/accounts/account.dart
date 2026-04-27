enum AccountType {
  combine('combine'),
  expressFunded('express_funded'),
  live('live'),
  demo('demo'),
  other('other');

  const AccountType(this.dbValue);

  final String dbValue;

  static AccountType fromDb(String value) {
    return AccountType.values.firstWhere(
      (type) => type.dbValue == value,
      orElse: () => AccountType.other,
    );
  }
}

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.accountType,
    required this.currency,
    required this.initialBalance,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final AccountType accountType;
  final String currency;
  final double initialBalance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
