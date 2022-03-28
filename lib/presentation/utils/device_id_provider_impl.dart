import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:base/domain/provider/device_id_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceIdProviderImpl extends DeviceIdProvider {
  FlutterSecureStorage secureStorage;

  DeviceIdProviderImpl({
    required this.secureStorage,
  });

  static const DEVICE_ID_KEY = "DEVICE_ID_KEY";

  @override
  Future<void> clearDeviceId() async {
    await secureStorage.delete(
      key: DEVICE_ID_KEY,
    );
  }

  @override
  Future<String> getDeviceId() async {
    var savedDeviceID = await secureStorage.read(key: DEVICE_ID_KEY);
    if (savedDeviceID?.isEmpty ?? true) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        savedDeviceID = androidInfo.androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        savedDeviceID = iosDeviceInfo.identifierForVendor;
      }
      await secureStorage.write(key: DEVICE_ID_KEY, value: savedDeviceID);
    }

    return savedDeviceID!;
  }
}
