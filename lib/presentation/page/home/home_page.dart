import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/navigator/page_navigator.dart';
import 'package:base/presentation/page/home/home_bloc.dart';
import 'package:base/presentation/page/home/index.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'index.dart';

class HomePage extends BasePage {
  HomePage({required PageTag pageTag}) : super(tag: pageTag);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomeBloc, HomePage, HomeRouter> {
  @override
  Widget buildLayout(BuildContext context, BaseBloc<BaseEvent, dynamic> bloc) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            buildAppbar(title: 'Home'),
          ],
        ),
      ),
    );
  }
}
