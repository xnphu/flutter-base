import 'package:base/core/utils/index.dart';
import 'package:base/data/net/api_endpoint_input.dart';
import 'package:base/presentation/base/base_page.dart';
import '../base/base_api.dart';
import '../base/interface_api.dart';
import 'package:base/domain/model/index.dart';

class AuthenApiImpl extends BaseApi with AuthenApi {
  AuthenApiImpl() : super();

  @override
  Future<BaseResponse<LoginResponse>> login(
      {required ParamsLogin params}) async {
    var body = params.toJson();
    Logger().d("Model login API" + body.toString());
    final connection = await initConnection();
    final json = await connection.execute(ApiInput(
      endPointProvider!.endpoints['sign_in']!,
      body: body,
    ));
    BaseResponse<LoginResponse> response = BaseResponse<LoginResponse>.fromJson(
        json: json, fromJsonModel: LoginResponse.fromJsonModel);
    Logger().d("Model login response: " + response.data!.toJson().toString());

    return response;
  }

  @override
  Future<bool> logout() async {
    final connection = await initConnection();
    final json = await connection.execute(ApiInput(
      endPointProvider!.endpoints['logout']!,
    ));
    BaseResponse response = BaseResponse.fromJson(json: json);
    return response.ok;
  }
}
