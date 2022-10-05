import 'package:base/domain/usecase/index.dart';
import 'package:base/presentation/base/index.dart';
import 'index.dart';

class SplashBloc extends BaseBloc<BaseEvent, SplashState> {
  SplashUseCases splashUseCases;

  SplashBloc(this.splashUseCases) : super(initState: SplashState()) {
    on<GetTokenString>(_onGetTokenStringHandler);
  }

  _onGetTokenStringHandler(
      SplashEvent event, Emitter<SplashState> emitter) async {
    emitter(state.copyWith(status: LoadingStatus.loading));
    var r = await splashUseCases.getToken();
    final result = r.fold<SplashState>(
      (l) => state.copyWith(failure: l),
      (r) => GetTokenSuccessState(token: r),
    );
    emitter(result);
  }

  @override
  void dispose() {}
}
