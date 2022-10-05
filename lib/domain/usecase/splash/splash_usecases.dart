import 'package:dartz/dartz.dart';
import 'package:base/core/error/failures.dart';
import 'package:base/domain/model/index.dart';
import 'package:base/domain/repository/index.dart';
import '../base_usecase.dart';

abstract class SplashUseCases {
  Future<Either<Failure, String>> getToken();
}

class SplashUseCaseImpl extends BaseUseCase<String>
    implements SplashUseCases {
  SplashRepository splashRepo;

  SplashUseCaseImpl(
    this.splashRepo,
  );

  @override
  Future<Either<Failure, String>> getToken() async {
    return execute();
  }

  @override
  Future<String> main() async {
    var result = await splashRepo.getToken();
    return result;
  }
}
