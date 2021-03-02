import 'package:auth/auth.dart';
import 'package:flutter_application_login/cache/local_store_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_TOKEN = 'CACHED_TOKEN';

class LocalStore implements ILocalStore {
  final SharedPreferences sharedPrefrences;
  LocalStore(this.sharedPrefrences);

  @override
  delete(Token token) {
    sharedPrefrences.remove(CACHED_TOKEN);
  }

  @override
  Future<Token> fetch() {
    final tokenStr = sharedPrefrences.getString(CACHED_TOKEN);
    if (tokenStr != null) return Future.value(Token(tokenStr));

    return null;
  }

  @override
  Future save(Token token) {
    return sharedPrefrences.setString(CACHED_TOKEN, token.value);
  }
}
