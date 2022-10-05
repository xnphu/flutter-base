import 'package:base/core/error/failures.dart';
import 'package:base/presentation/base/index.dart';

class SplashState extends BaseState {
  String? token;

  SplashState({
    this.token,
    Failure? failure,
    LoadingStatus? status,
  }) : super(failure: failure, loadingStatus: status ?? LoadingStatus.none);

  SplashState copyWith({
    String? token,
    Failure? failure,
    LoadingStatus? status,
  }) {
    return SplashState(token: token ?? '', failure: failure, status: status);
  }
}

class GetTokenSuccessState extends SplashState {
  GetTokenSuccessState({String? token}) : super(token: token);
}
