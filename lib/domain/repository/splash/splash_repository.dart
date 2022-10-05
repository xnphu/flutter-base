import 'package:base/domain/model/index.dart';

abstract class SplashRepository {
  Future<String> getToken();
}
