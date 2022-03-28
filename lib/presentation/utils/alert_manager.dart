import 'package:auto_size_text/auto_size_text.dart';
import 'package:base/presentation/styles/index.dart';
import 'package:base/presentation/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
// import 'package:logger/logger.dart';

class AlertManager {
  static int alertShowingCount = 0;
  static List<String> _showingMessages = [];

  static bool _sameMessageIsShowing(String checkMsg) {
    final index = _showingMessages.indexWhere((element) => checkMsg == element);
    return index >= 0;
  }

  static _onMessageShow(String msg) {
    _showingMessages.add(msg);
  }

  static _onMessageHide(String msg) {
    final index = _showingMessages.indexWhere((element) => msg == element);
    if (index >= 0) {
      _showingMessages.removeAt(index);
    }
  }

  static Future<dynamic> showWidgetDialog(
      {required BuildContext context,
      required Widget child,
      EdgeInsets padding = const EdgeInsets.all(30.0),
      EdgeInsets contentMargin = const EdgeInsets.only(
        top: 15,
        left: 22,
        right: 22,
        bottom: 25,
      )}) async {
    return showGeneralDialog(
        pageBuilder: (context, animation1, animation2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: FocusDetector(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: padding,
                      child: RoundContainer(
                        allRadius: 16,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: contentMargin,
                              child: child,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
            scale: a1.value,
          );
        });
  }

  static Future<bool> showAlert(
      {required BuildContext context,
      String? title,
      required String message,
      String? okActionTitle,
      String? cancelTitle,
      TextStyle? titleStyle,
      TextStyle? messageStyle,
      bool? dismissWithBackPress,
      Color primaryColor = AppColors.primaryColor,
      bool allowShowSameMessageTogether = false}) async {
    if (!allowShowSameMessageTogether && _sameMessageIsShowing(message)) {
      return false;
    }
    List<Widget> actions = [];
    if (cancelTitle?.isNotEmpty ?? false) {
      final cancelWidget = Padding(
        padding: EdgeInsets.all(10),
        child: RoundContainer(
          allRadius: 44,
          height: 44,
          borderColor: primaryColor,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: AutoSizeText(cancelTitle!,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600)),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
          ),
        ),
      );
      actions.add(cancelWidget);
    }

    final okWidget = Padding(
      padding: EdgeInsets.all(10),
      child: RoundContainer(
        allRadius: 44,
        height: 44,
        color: primaryColor,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: AutoSizeText(okActionTitle ?? "OK",
                textAlign: TextAlign.center,
                style: getTextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            onPressed: () {
              return Navigator.of(context).pop(true);
            },
          ),
        ),
      ),
    );
    actions.add(okWidget);
    AlertManager._onMessageShow(message);
    final result = await showGeneralDialog<bool>(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
            scale: a1.value,
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return FocusDetector(
            onFocusGained: () {
              alertShowingCount++;
            },
            onFocusLost: () {
              alertShowingCount--;
              AlertManager._onMessageHide(message);
            },
            child: WillPopScope(
              onWillPop: () async {
                return dismissWithBackPress ?? true;
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: RoundContainer(
                          allRadius: 16,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: (title?.isNotEmpty ?? false) ? 30 : 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: Text(
                                  title ?? '',
                                  textAlign: TextAlign.center,
                                  style: titleStyle ??
                                      getTextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black33,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: Text(message,
                                    textAlign: TextAlign.center,
                                    style: messageStyle ??
                                        getTextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black33,
                                        )),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: actions,
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    return result ?? false;
  }
}
