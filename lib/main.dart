import 'package:base/domain/usecase/index.dart';
import 'package:base/presentation/page/main/main_page.dart';
import 'package:base/presentation/page/splash/splash_page.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:base/presentation/utils/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app_injector.dart';
import 'data/net/index.dart';
import 'domain/provider/index.dart';
import 'domain/repository/index.dart';
import 'presentation/app/index.dart';
import 'presentation/base/index.dart';
import 'presentation/page/home/index.dart';
import 'presentation/page/login/index.dart';
import 'presentation/page/login/remember_login_page.dart';
import 'presentation/widgets/index.dart';

late ApplicationBloc appBloc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = blocMonitorDelegate;
  // await Firebase.initializeApp();
  await initializeDateFormatting('vi_VN');
  AppLocalizations.shared.reloadLanguageBundle(languageCode: 'vi');
  await initInjector();
  await Future.wait([
    injector.get<EndPointProvider>().load(),
    injector.get<EnviromentProvider>().preLoadPlatformInfo(),
    injector.get<BiometricManager>().preLoadDeviceInfo(),
  ]);

  appBloc = ApplicationBloc(
      repository: injector<AuthenticationRepository>(),
      logoutUseCase: injector<LogoutUseCase>());

  runApp(
    MultiProvider(
      providers: [
        Provider<NotifyProvider>(create: (_) => NotifyProvider.shared),
        Provider<BiometricManager>(create: (_) => BiometricManager.shared),
      ],
      child: BlocProvider<ApplicationBloc>(
        create: (BuildContext context) => appBloc,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    appBloc.dispatchEvent(AppLaunched());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme:
            TextSelectionThemeData(selectionHandleColor: Colors.transparent),
      ),
      home: LayoutBuilder(builder: (_context, snapshot) {
        return BlocBuilder<ApplicationBloc, BaseState>(
            bloc: appBloc,
            builder: (context, state) {
              final loadingView = ProgressHud(
                child: LoginPage(
                  pageTag: PageTag.login,
                ),
                inAsyncCall: true,
              );

              if (state is ApplicationState) {
                switch (state.tag) {
                  case AppLaunchTag.rememberLogin:
                    return RememberLoginPage(
                      pageTag: PageTag.rememberLogin,
                    );
                  case AppLaunchTag.login:
                    return LoginPage(
                      pageTag: PageTag.login,
                    );
                  case AppLaunchTag.splash:
                    return SplashPage(pageTag: PageTag.splash);
                  case AppLaunchTag.main:
                    return MainPage(pageTag: PageTag.main);
                  default:
                    return loadingView;
                }
              }
              // loading view
              return loadingView;
            });
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    NotifyProvider.shared.dispose();
  }
}
