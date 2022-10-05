import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/navigator/page_navigator.dart';
import 'package:base/presentation/page/main/main_page.dart';
import 'package:base/presentation/page/splash/splash_state.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashRouter extends BaseRouter {
  @override
  onNavigateByState({required BuildContext context, required BaseState state}) {
    if (state is GetTokenSuccessState) {
      if (state.token?.isNotEmpty ?? false) {
        navigator.materialPushAndRemoveAll(
          context: context,
          page: MainPage(pageTag: PageTag.main),
        );
      }
    }
  }
}
