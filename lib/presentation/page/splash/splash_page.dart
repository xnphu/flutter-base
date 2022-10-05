import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/navigator/page_navigator.dart';
import 'package:base/presentation/page/home/home_bloc.dart';
import 'package:base/presentation/page/home/index.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'index.dart';

class SplashPage extends BasePage {
  SplashPage({required PageTag pageTag}) : super(tag: pageTag);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends BasePageState<SplashBloc, SplashPage, SplashRouter> {
  @override
  void initState() {
    super.initState();
    bloc.dispatchEvent(GetTokenString());
  }
  
  @override
  Widget buildLayout(BuildContext context, BaseBloc<BaseEvent, dynamic> bloc) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Splash'),
            ),
          ],
        ),
      ),
    );
  }
}
