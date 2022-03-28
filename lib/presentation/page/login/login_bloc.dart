import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:base/core/error/failures.dart';
import 'package:base/domain/model/index.dart';
import 'package:base/domain/provider/index.dart';
import 'package:base/domain/usecase/index.dart';
import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/page/login/index.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:base/presentation/utils/index.dart';
import 'package:base/presentation/utils/push_notification_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginBloc extends BaseBloc<BaseEvent, LoginState> {
  AuthenticationUseCases _authenticationUseCases;
  BiometricManager biometricManager;
  DeviceIdProvider _deviceProvider;
  LogoutUseCase logoutUseCase;

  LoginBloc(
    this._authenticationUseCases,
    this.biometricManager,
    this._deviceProvider,
    this.logoutUseCase,
  ) : super(initState: LoginState()) {
    on<TapBtnLoginEvent>((e, m) => _loginClickHandler(e.phone!, e.pass!, m));
    on<SignUpSuccessEvent>((e, m) => _loginClickHandler(e.phone!, e.pass!, m));

    on<LoginBiometricCLickedEvent>((e, emitter) {
      emitter(state.copyWith(
          failure: PlatformFailure(
              msg: AppLocalizations
                  .shared.commonMessageAuthorizedByBiometrictNotEnable)));
    });
    on<NotMeButtonCLickEvent>(_onNotMeButtonClickHandler);
  }

  _loginClickHandler(
      String phone, String pass, Emitter<LoginState> emitter) async {
    emitter(state.copyWith(loadingStatus: LoadingStatus.loading));

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String fcmToken = await PushNotificationHandler.shared.getNotifyToken();
    String versionCode = packageInfo.version;
    String deviceName = '';
    String deviceId = '';
    int deviceType = 1;

    if (Platform.isAndroid) {
      deviceType = 1;
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceName = androidInfo.model!;
      // deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      deviceType = 2;
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosDeviceInfo.model!;
      // deviceId = iosDeviceInfo.identifierForVendor;
    }
    deviceId = await _deviceProvider.getDeviceId();
    ParamsLogin paramsLogin = ParamsLogin(
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
        fcmToken: fcmToken,
        phoneNumber: phone,
        password: pass,
        versionCode: versionCode);
    emitter(state.copyWith(loadingStatus: LoadingStatus.loading));
    var r = await _authenticationUseCases.login(params: paramsLogin);

    final result = r.fold<LoginState>((l) => state.copyWith(failure: l),
        (r) => LoginSuccessState(user: r.user!));
    emitter(result);
  }

  _onNotMeButtonClickHandler(
      BaseEvent event, Emitter<LoginState> emitter) async {
    final result = await logoutUseCase.logout(isRemoteLogout: false);
    emitter(NotCurrentUserState(user: state.user));
  }

  @override
  dispose() {}

  @override
  void onPageInitStateEvent(PageInitStateEvent event) {
    super.onPageInitStateEvent(event);
    //PushNotificationHandler.shared.setupPushNotification();
  }
}
