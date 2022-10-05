import 'dart:async';
import 'package:base/core/error/exceptions.dart';
import 'package:base/core/error/failures.dart';
import 'package:base/domain/repository/index.dart';
import 'package:base/domain/usecase/index.dart';
import 'package:base/presentation/base/base_bloc.dart';
import 'package:base/presentation/base/base_event.dart';
import 'package:base/presentation/base/index.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends BaseBloc<ApplicationEvent, ApplicationState> {
  AuthenticationRepository repository;
  LogoutUseCase logoutUseCase;

  PublishSubject<BaseEvent> _broadcastEventManager =
      PublishSubject<BaseEvent>();

  ApplicationBloc({required this.repository, required this.logoutUseCase})
      : super(initState: ApplicationState(tag: AppLaunchTag.splash)) {
    on<AppLaunched>(_onAppLaunchHandler);
    on<LoginSuccessEvent>(_onLoginSuccessHandler);
    on<AccessTokenExpiredEvent>(_onAccessTokenExpiredHandler);
    on<LogoutSuccessEvent>(
        (_, emitter) => emitter(ApplicationState(tag: AppLaunchTag.login)));
  }

  _onAccessTokenExpiredHandler(
      AccessTokenExpiredEvent event, Emitter<ApplicationState> emitter) async {
    final logoutResult = await logoutUseCase.logout(isRemoteLogout: false);
    emitter(logoutResult.fold(
        (l) => ApplicationState(tag: AppLaunchTag.login, failure: l),
        (r) => ApplicationState(
              tag: AppLaunchTag.login,
            )));
  }

  _onLoginSuccessHandler(
      LoginSuccessEvent event, Emitter<ApplicationState> emitter) async {
    if (event.hasUserData) {
      emitter(ApplicationState(tag: AppLaunchTag.home));
    } else {
      emitter(ApplicationState(tag: AppLaunchTag.updateUser));
    }
  }

  _onAppLaunchHandler(
      AppLaunched event, Emitter<ApplicationState> emitter) async {
    AppLaunchTag tag = AppLaunchTag.splash;
    emitter(state.copyWith(status: LoadingStatus.loading));
    try {
      var isLogged = await repository.isLogged();
      if (isLogged) {
        tag = AppLaunchTag.main;
      }
      emitter(state.copyWith(tag: tag));
    } on RemoteException catch (ex) {
      emitter(state.copyWith(
          failure: PlatformFailure(msg: ex.errorMessage),
          tag: (ex.errorCode ?? 0) == ACCESS_TOKEN_EXPIRED_CODE
              ? AppLaunchTag.splash
              : tag));
    } catch (ex) {
      emitter(state.copyWith(
          failure: PlatformFailure(msg: SERVER_ERROR_MESSAGE), tag: tag));
    }
  }

  @override
  void dispose() {
    _broadcastEventManager.close();
  }
}

//broadcast event
extension AppEventCenter on ApplicationBloc {
  Stream<BaseEvent> get broadcastEventStream => _broadcastEventManager.stream;

  void postBroadcastEvent(BaseEvent event) {
    _broadcastEventManager.add(event);
  }
}
