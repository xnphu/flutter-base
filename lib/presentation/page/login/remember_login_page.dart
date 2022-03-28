import 'package:base/core/utils/index.dart';
import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/page/login/index.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:base/presentation/utils/index.dart';
import 'package:base/presentation/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class RememberLoginPage extends BasePage {
  RememberLoginPage({required PageTag pageTag}) : super(tag: pageTag);

  @override
  State<StatefulWidget> createState() => RememberLoginPageState();
}

class RememberLoginPageState
    extends BasePageState<LoginBloc, RememberLoginPage, LoginRouter> {
  late PropertyController _passwordController;
  String? _password;

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  void initState() {
    super.initState();
    PropertyController(
        initValidValue: true,
        initMessage: AppLocalizations.shared.commonMessagePhoneError);
    _passwordController = PropertyController(
        initValidValue: true,
        initMessage: AppLocalizations.shared.commonMessagePasswordError);
  }

  @override
  void stateListenerHandler(BaseState state) async {
    super.stateListenerHandler(state);
  }

  @override
  Widget buildLayout(BuildContext context, BaseBloc bloc) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        var page = SafeArea(
          child: GestureDetector(
            onTap: () => hideKeyboard(context),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                _buildUserDataView(state),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildInputPasswordView(),
                            SizedBox(
                              height: 20,
                            ),
                            _buildLoginButton()
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      _buildBiometricButton(),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  color: Colors.transparent,
                ))
              ],
            ),
          ),
        );
        return ProgressHud(
          child: page,
          inAsyncCall: state.loadingStatus == LoadingStatus.loading,
        );
      }),
    );
  }

  _buildUserDataView(LoginState state) {
    return Container(
      color: AppColors.greyTransparent,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.shared.hello,
                    style: getTextStyle(color: AppColors.whiteText),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    state.user?.name ?? '',
                    style: getTextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildNotMeButton(),
                ],
              ),
            ),
            Container(
              width: 85,
              height: 85,
              child: Image(
                image: AppImages.icDefaultAvatar,
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildNotMeButton() {
    return InkWell(
      onTap: () {
        bloc.dispatchEvent(NotMeButtonCLickEvent());
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 15,
              height: 15,
              child: Image(
                image: AppImages.icAccount,
                fit: BoxFit.contain,
              )),
          SizedBox(
            width: 5,
          ),
          Text(
            AppLocalizations.shared.rememberLoginButtonNotMe,
            style: getTextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  _buildBiometricButton() {
    return Consumer<BiometricManager>(builder: (_, biometricManager, w) {
      BiometricInfo info = biometricManager.info;
      return RoundContainer(
        color: Colors.transparent,
        allRadius: 10,
        width: 90,
        borderColor: Colors.white,
        child: Center(
          child: TextButton(
              onPressed: () {
                bloc.dispatchEvent(BiometrictButtonClickEvent());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 40,
                    child: Image(
                      image: (info.biometricType == BiometricType.face)
                          ? AppImages.icFaceId
                          : AppImages.icTouchId,
                      color: AppColors.primaryColor,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      (info.biometricType == BiometricType.face)
                          ? AppLocalizations.shared.commonButtonFaceId
                          : AppLocalizations.shared.commonButtonTouchId,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          lineHeight: 1.2),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )),
        ),
      );
    });
  }

  _buildLoginButton() {
    return Ink(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          bool _passValid = Validators.isPasswordValid(_password ?? '', null);
          _passwordController.isValid.add(_passValid);
          if (_passValid) {
            hideKeyboard(context);
            bloc.dispatchEvent(RequestLoginEvent(pass: _password!));
          }
        },
        child: Center(
            child: Text(
          AppLocalizations.shared.loginPageButtonLogin.toUpperCase(),
          style: getTextStyle(color: Colors.white),
        )),
      ),
    );
  }

  _buildInputPasswordView() {
    return ValidatedInputField(
      hintText: AppLocalizations.shared.commonLabelInputPasswordHint,
      prefixImage: AppImages.icPassword,
      propertyController: _passwordController,
      keyboardType: TextInputType.number,
      inputFormatters: passwordFormatter,
      isShowObscureControl: true,
      obscureText: true,
      onInputChanged: (value) {
        _password = value;
      },
      validator: Validators.isPasswordValid,
    );
  }
}
