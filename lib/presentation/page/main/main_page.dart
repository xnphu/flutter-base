import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/navigator/page_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'index.dart';

class MainPage extends BasePage {
  MainPage({required PageTag pageTag}) : super(tag: pageTag);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BasePageState<MainBloc, MainPage, MainRouter> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int pageIndex = 0;

  final pages = [
    const Page(pageName: 'Page 1'),
    const Page(pageName: 'Page 2'),
    const Page(pageName: 'Page 3'),
    const Page(pageName: 'Page 4'),
  ];

  @override
  Widget buildLayout(BuildContext context, BaseBloc<BaseEvent, dynamic> bloc) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer: SafeArea(
        child: Container(
          width: double.infinity,
          child: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(onTap: () => {
                        if(_scaffoldKey.currentState?.isDrawerOpen?? false) {
                          _scaffoldKey.currentState?.closeDrawer()
                        }
                      },child: Text('X'))
                    ],
                  )
                ],
              ),
            ),
          ),
          ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Icon(
            Icons.menu,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Lao Động',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () {},
        );
      }),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Widget buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.work_rounded,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.work_outline_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.widgets_rounded,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.widgets_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            icon: pageIndex == 3
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String pageName;
  const Page({Key? key, required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Text(
          pageName,
          style: getTextStyle(
            color: AppColors.black66,
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
