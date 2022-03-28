import 'package:base/presentation/resources/index.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:logger/logger.dart';

class BiometricInfo {
  bool deviceSupport = true;
  BiometricType biometricType = BiometricType.face;

  BiometricInfo({
    this.deviceSupport = true,
    this.biometricType = BiometricType.face,
  });
}

class BiometricManager {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static BiometricManager shared = BiometricManager._();

  BiometricManager._();

  late BiometricInfo info;

  Future<void> preLoadDeviceInfo() async {
    final deviceSupport = await isDeviceSupported();
    final biometricType = await deviceBiometricType();
    info = BiometricInfo(
        biometricType: biometricType, deviceSupport: deviceSupport);
  }

  Future<bool> supportBiometric() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> isDeviceSupported() async {
    bool support = await _localAuth.isDeviceSupported() &&
        await _localAuth.canCheckBiometrics;

    return support;
  }

  Future<BiometricType> deviceBiometricType() async {
    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      return BiometricType.face;
    }
    return BiometricType.fingerprint;
  }

  Future<bool> authen() async {
    final iosStrings = IOSAuthMessages(
        cancelButton: AppLocalizations.shared.commonButtonCancel,
        goToSettingsButton: AppLocalizations.shared.setting,
        goToSettingsDescription:
            AppLocalizations.shared.commonMessageSetupBiometric,
        lockOut: AppLocalizations.shared.commonMessageSetupBiometric);
    await _localAuth.authenticate(
        stickyAuth: true,
        biometricOnly: true,
        localizedReason: info.biometricType == BiometricType.face
            ? AppLocalizations.shared.commonMessageAuthenByFaceID
            : AppLocalizations.shared.commonMessageAuthenByTouchID,
        useErrorDialogs: true,
        iOSAuthStrings: iosStrings);
    return true;
  }
}
