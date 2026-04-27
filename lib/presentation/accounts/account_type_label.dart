import '../../domain/accounts/account.dart';

extension AccountTypeLabel on AccountType {
  String get label {
    switch (this) {
      case AccountType.combine:
        return 'Combine';
      case AccountType.expressFunded:
        return 'Express Funded';
      case AccountType.live:
        return 'Live';
      case AccountType.demo:
        return 'Demo';
      case AccountType.other:
        return 'Other';
    }
  }
}
