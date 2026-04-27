import '../../domain/accounts/account.dart';

class AccountMapper {
  static Account fromMap(Map<String, Object?> map) {
    return Account(
      id: map['id']! as String,
      name: map['name']! as String,
      accountType: AccountType.fromDb(map['account_type']! as String),
      currency: map['currency']! as String,
      initialBalance: (map['initial_balance']! as num).toDouble(),
      isActive: (map['is_active']! as int) == 1,
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    );
  }

  static Map<String, Object?> toInsertMap(Account account) {
    return {
      'id': account.id,
      'name': account.name,
      'account_type': account.accountType.dbValue,
      'currency': account.currency,
      'initial_balance': account.initialBalance,
      'is_active': account.isActive ? 1 : 0,
      'created_at': account.createdAt.toIso8601String(),
      'updated_at': account.updatedAt.toIso8601String(),
    };
  }

  static Map<String, Object?> toUpdateMap(Account account) {
    final values = toInsertMap(account);
    values.remove('id');
    values.remove('created_at');
    return values;
  }
}
