import 'package:base/core/utils/index.dart';
import 'package:base/domain/model/login/token_model.dart';
import 'storage/local_data_storage.dart';

abstract class AuthenCache {
  Future<TokenModel?> getCachedToken();

  Future<bool> putToken(TokenModel token);

  Future<bool> removeToken();
}

class AuthenCacheImpl extends AuthenCache {
  LocalDataStorage _storage;

  AuthenCacheImpl(this._storage);

  static const String TOKEN_KEY = "EWALLET_TOKEN_KEY";

  @override
  Future<TokenModel?> getCachedToken() async {
    var token = await _storage.getString(TOKEN_KEY) ?? '';
    return TokenModel(token: token);
  }

  @override
  Future<bool> putToken(TokenModel token) async {
    await _storage.saveString(TOKEN_KEY, token.token);
    return true;
  }

  @override
  Future<bool> removeToken() async {
    await _storage.remove(TOKEN_KEY);
    return true;
  }
}
