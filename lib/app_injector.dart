import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:base/data/local/index.dart';
import 'package:base/data/remote/api/index.dart';
import 'package:base/data/remote/base/index.dart';
import 'package:base/data/repository/index.dart';

import 'package:base/presentation/page/home/index.dart';
import 'package:base/presentation/page/login/index.dart';

import 'package:base/presentation/utils/device_id_provider_impl.dart';
import 'package:base/presentation/utils/index.dart';
import 'package:base/presentation/utils/push_notification_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_status.dart';
import 'data/net/index.dart';
import 'domain/provider/index.dart';
import 'domain/repository/index.dart';
import 'domain/usecase/index.dart';
import 'presentation/utils/environment_provider_impl.dart';

GetIt injector = GetIt.asNewInstance();

initInjector() {
  // Utils
  injector.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  injector.registerLazySingleton<Connectivity>(() => Connectivity());
  injector.registerLazySingleton<FlutterSecureStorage>(
      () => FlutterSecureStorage());
  injector.registerLazySingleton<EndPointProvider>(() => EndPointProvider());
  injector.registerLazySingleton<EnviromentProvider>(
      () => EnvironmentProviderImpl());
  injector
      .registerLazySingleton<BiometricManager>(() => BiometricManager.shared);
  injector.registerLazySingleton<NotifyProvider>(() => NotifyProvider.shared);
  injector.registerLazySingleton<PushNotificationHandler>(
      () => PushNotificationHandler.shared);
  injector.registerFactory<DeviceIdProvider>(
      () => DeviceIdProviderImpl(secureStorage: injector()));
  //API
  injector.registerLazySingleton<ApiConfig>(() => ApiConfigImpl(
        enviromentProvider: injector(),
      ));
  injector.registerLazySingleton<NetworkStatus>(
      () => NetworkStatusImpl(injector(), injector()));

  injector.registerFactory<BookingRequestHeaderBuilder>(() =>
      BookingRequestHeaderBuilder(
          tokenCache: injector(), apiConfig: injector()));
  injector.registerFactory<AuthenApi>(() => AuthenApiImpl());

//Cache
  injector
      .registerFactory<LocalDataStorage>(() => SharePreferenceStorageImpl());
  injector
      .registerLazySingleton<AuthenCache>(() => AuthenCacheImpl(injector()));

// Repository
  injector.registerFactory<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            injector(),
            injector(),
          ));
//Bloc
  injector.registerFactory<LoginBloc>(
      () => LoginBloc(injector(), injector(), injector(), injector()));
  injector.registerFactory<HomeBloc>(() => HomeBloc());

  // router
  injector.registerFactory<LoginRouter>(() => LoginRouter());
  injector.registerFactory<HomeRouter>(() => HomeRouter());
  // use case
  injector.registerFactory<AuthenticationUseCases>(
      () => AuthenticationUseCaseImpl(injector()));
  injector.registerFactory<LogoutUseCase>(() => LogoutUseCaseImpl(injector()));
}
