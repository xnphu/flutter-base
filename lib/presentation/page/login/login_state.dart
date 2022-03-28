import 'package:base/core/error/failures.dart';
import 'package:base/domain/model/index.dart';
import 'package:base/presentation/base/base_page_mixin.dart';
import 'package:base/presentation/base/index.dart';

class LoginState extends BaseState {
  UserModel? user;

  LoginState({
    this.user,
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) : super(
            loadingStatus: loadingStatus ?? LoadingStatus.none,
            failure: failure);

  LoginState copyWith(
      {UserModel? userModel, LoadingStatus? loadingStatus, Failure? failure}) {
    return LoginState(
        user: userModel ?? this.user,
        loadingStatus: loadingStatus,
        failure: failure);
  }
}

class LoginSuccessState extends LoginState {
  LoginSuccessState({required UserModel user}) : super(user: user);
}

class NotCurrentUserState extends LoginState {
  NotCurrentUserState({UserModel? user}) : super(user: user);
}
