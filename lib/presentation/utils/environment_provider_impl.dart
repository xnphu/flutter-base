import 'package:base/domain/provider/environment_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class EnvironmentProviderImpl implements EnviromentProvider {
  late PackageInfo _packageInfo;
  Future<void> preLoadPlatformInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  EnviromentFlavor getCurrentFlavor() {
    if (_packageInfo.packageName.endsWith("dev")) {
      return EnviromentFlavor.dev;
    }
    if (_packageInfo.packageName.endsWith("stg")) {
      return EnviromentFlavor.stg;
    }
    return EnviromentFlavor.prod;
  }
}
