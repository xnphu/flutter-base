import 'package:base/presentation/base/index.dart';
import 'index.dart';

class HomeBloc extends BaseBloc<BaseEvent, HomeState> {
  HomeBloc() : super(initState: HomeState());

  @override
  void dispose() {}
}
