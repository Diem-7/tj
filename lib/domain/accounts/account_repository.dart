import 'account.dart';
import 'account_input.dart';

abstract interface class AccountRepository {
  Future<List<Account>> watchableList();

  Future<void> create(AccountInput input);

  Future<void> update(String id, AccountInput input);
}
