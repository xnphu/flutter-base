import 'package:base/domain/provider/index.dart';
import 'package:base/data/net/api_connection.dart';

const BASE_URL_DEV = 'https://com.google.api.com';
const BASE_URL_STG = 'https://com.google.api.com';
const BASE_URL_PROD = 'https://com.google.api.com';
const URL_CHECK_VERIFY_PIN_CODE = "com.google.api.com";
const URL_POLICY = "https://d28corp.vn/wallet/policy";
const String IMAGE_BASE_URL = 'https://com.google.api.com/storage';

abstract class ApiConfig {
  late String baseUrl;
  late int connectTimeout;
  late int receiveTimeout;
  late String appName;
}

class ApiConfigImpl extends ApiConfig {
  EnviromentProvider enviromentProvider;
  ApiConfigImpl({
    required this.enviromentProvider,
  });

  String get baseUrl {
    final evn = enviromentProvider.getCurrentFlavor();
    switch (evn) {
      case EnviromentFlavor.dev:
        return BASE_URL_DEV;
      case EnviromentFlavor.stg:
        return BASE_URL_STG;
      case EnviromentFlavor.prod:
        return BASE_URL_PROD;
    }
  }

  int connectTimeout = 50000;
  int receiveTimeout = 30000;
  String appName = "app-client";
}
