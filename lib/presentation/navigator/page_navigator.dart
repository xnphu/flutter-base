import 'package:flutter/material.dart';
import 'package:base/presentation/base/base_page.dart';
import 'package:base/presentation/utils/page_tag.dart';

var navigator = PageNavigator();

class PageNavigator {
  materialPush({required BuildContext context, required BasePage page}) {
    RouteSettings settings = RouteSettings(name: page.tag.toString());
    // final route = ObserverRoute(page, settings: settings);
    final route =
        MaterialPageRoute(builder: (context) => page, settings: settings);
    return Navigator.of(context).push(route);
  }

  _materialPushAndRemoveUntil({
    required BuildContext context,
    required BasePage page,
    required RoutePredicate predicate,
  }) {
    RouteSettings settings = RouteSettings(name: page.tag.toString());
    final route =
        MaterialPageRoute(builder: (context) => page, settings: settings);
    Navigator.pushAndRemoveUntil(context, route, predicate);
  }

  materialPushAndRemoveUntilTag({
    required BuildContext context,
    required BasePage page,
    required PageTag stopTag,
  }) {
    _materialPushAndRemoveUntil(
      context: context,
      page: page,
      predicate: (Route<dynamic> route) {
        final match = route.settings.name == stopTag.toString();
        return match;
      },
    );
  }

  materialPushAndRemoveAll({
    required BuildContext context,
    required BasePage page,
  }) {
    _materialPushAndRemoveUntil(
      context: context,
      page: page,
      predicate: (Route<dynamic> route) {
        return false;
      },
    );
  }

  popBack({required BuildContext context, dynamic result}) {
    return Navigator.of(context).pop(result);
  }

  popToRoot({required BuildContext context}) {
    Navigator.of(context).popUntil((Route<dynamic> route) {
      Logger().d(
          " popToRoot --->> ${route.settings.name}  ---->> ${route.isFirst} ");
      return route.isFirst;
    });
  }

  popUntilTag({
    required PageTag stopTag,
    required BuildContext context,
  }) {
    Navigator.of(context).popUntil((Route<dynamic> route) {
      final match = route.settings.name == stopTag.toString();
      Logger().d(
          "popUntilTag -->>$stopTag   --->> ${route.settings.name}  --->> match: $match ");
      return match;
    });
  }
}
