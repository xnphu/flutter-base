import 'package:base/data/local/index.dart';
import 'package:base/data/remote/base/interface_api.dart';
import 'package:base/domain/model/index.dart';
import 'package:base/domain/repository/index.dart';
import 'package:logger/logger.dart';

class SplashRepositoryImpl implements SplashRepository {
  AuthenCache _authenCache;

  SplashRepositoryImpl(
    this._authenCache,
  );

  // @override
  // Future<BaseResponse<LoginResponse>> login(
  //     {required ParamsLogin params}) async {
  //   final response = await _authenApi.login(params: params);
  //   _authenCache.putToken(
  //       TokenModel(token: response.data!.token!), params.password);
  //   return response;
  // }

  @override
  Future<String> getToken() {
    _authenCache.putToken(TokenModel(token: 'token'));
    return Future.delayed(const Duration(seconds: 4), () {
      return 'token';
    });
  }
}
