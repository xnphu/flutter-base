import 'package:base/presentation/base/index.dart';

abstract class HomeEvent extends BaseEvent {}

class GetWalletEvent extends HomeEvent {}

class LogoutRequestEvent extends HomeEvent {}
