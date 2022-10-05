import 'package:base/core/error/failures.dart';
import 'package:base/presentation/base/base_state.dart';

class ApplicationState extends BaseState {
  AppLaunchTag tag;
  ApplicationState({
    required this.tag,
    Failure? failure,
    LoadingStatus? status,
  }) : super(failure: failure, loadingStatus: status ?? LoadingStatus.none);

  ApplicationState copyWith({
    AppLaunchTag? tag,
    Failure? failure,
    LoadingStatus? status,
  }) {
    return ApplicationState(
        tag: tag ?? this.tag, failure: failure, status: status);
  }
}

const APP_LAUNCH_ERROR_MESSAGE = "application cannot start";

enum AppLaunchTag {
  main,
  splash,
  login,
  loginBySns,
  home,
  policy,
  rememberLogin,
  updateUser
}
