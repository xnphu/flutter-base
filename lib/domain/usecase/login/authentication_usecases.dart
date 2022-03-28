import 'package:dartz/dartz.dart';
import 'package:base/core/error/failures.dart';
import 'package:base/domain/model/index.dart';
import 'package:base/domain/repository/index.dart';
import '../base_usecase.dart';

abstract class AuthenticationUseCases {
  Future<Either<Failure, LoginResponse>> login({required ParamsLogin params});
}

class AuthenticationUseCaseImpl extends BaseUseCase<LoginResponse>
    implements AuthenticationUseCases {
  AuthenticationRepository authenRepo;
  late ParamsLogin params;

  AuthenticationUseCaseImpl(
    this.authenRepo,
  );

  @override
  Future<Either<Failure, LoginResponse>> login(
      {required ParamsLogin params}) async {
    this.params = params;
    return this.execute();
  }

  @override
  Future<LoginResponse> main() async {
    var result = await authenRepo.login(params: this.params);
    return result.data!;
  }
}
