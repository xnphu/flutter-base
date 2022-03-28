import 'package:base/core/utils/index.dart';
import 'package:base/presentation/base/index.dart';
import 'package:base/presentation/navigator/page_navigator.dart';
import 'package:base/presentation/page/home/home_page.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:base/presentation/utils/index.dart';
import 'package:base/presentation/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'index.dart';

class LoginPage extends BasePage {
  LoginPage({required PageTag pageTag}) : super(tag: pageTag);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends BasePageState<LoginBloc, LoginPage, LoginRouter> {
  late PropertyController _accountController = PropertyController(
      initValidValue: true,
      initMessage: AppLocalizations.shared.commonMessagePhoneError);
  late PropertyController _passwordController;
  String? _password;
  String? _phone;

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  bool get willListenApplicationEvent => true;

  @override
  void initState() {
    super.initState();

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
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      var page = SafeArea(
        child: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _AppLogoWidget(),
                  const _AppNameWidget(),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInputPhoneNumberView(),
                          _buildInputPasswordView(),
                        ],
                      )),
                      const SizedBox(width: 15),
                      _buildBiometricButton(),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildLoginButton(),
                  Container(
                    margin: const EdgeInsets.only(top: 60, bottom: 20),
                    child: Text(
                      AppLocalizations.shared.loginPageLabelDontHaveAccount,
                      style: getTextStyle(color: AppColors.white),
                    ),
                  ),
                  //_buildRegisterButton(),
                  const _RegisterButtonWidget(),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          navigator.materialPush(context: context, page: HomePage(pageTag: PageTag.home));
                        },
                        child: _buildSubButton(
                            label: AppLocalizations.shared.loginPageButtonNews,
                            image: AppImages.icNews),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _buildSubButton(
                            label: AppLocalizations.shared.loginPageButtonFAQ,
                            image: AppImages.icQnA),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _buildSubButton(
                            label:
                                AppLocalizations.shared.loginPageButtonContact,
                            image: AppImages.icContact),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
      return ProgressHud(
        child: page,
        inAsyncCall: state.loadingStatus == LoadingStatus.loading,
      );
    });
  }

  _buildInputPhoneNumberView() {
    return ValidatedInputField(
      hintText: AppLocalizations.shared.commonLabelInputPhoneHint,
      prefixImage: AppImages.icPhone,
      propertyController: _accountController,
      keyboardType: TextInputType.number,
      inputFormatters: phoneNumberFormatter,
      validator: Validators.isPhoneNumberValid,
      onInputChanged: (value) {
        _phone = value;
      },
    );
  }

  _buildInputPasswordView() {
    return ValidatedInputField(
      hintText: AppLocalizations.shared.commonLabelInputPasswordHint,
      prefixImage: AppImages.icPassword,
      propertyController: _passwordController,
      isShowObscureControl: true,
      obscureText: true,
      inputFormatters: passwordFormatter,
      keyboardType: TextInputType.number,
      onInputChanged: (value) {
        _password = value;
      },
      validator: Validators.isPasswordValid,
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
                bloc.dispatchEvent(LoginBiometricCLickedEvent());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                ],
              )),
        ),
      );
    });
  }

  _buildLoginButton() {
    return Ink(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(200),
          borderRadius: const BorderRadius.all(const Radius.circular(25))),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          bool _passValid = Validators.isPasswordValid(_password ?? '', null);
          bool _phoneValid = Validators.isPhoneNumberValid(_phone ?? '', null);
          _passwordController.isValid.add(_passValid);
          _accountController.isValid.add(_phoneValid);
          if (_passValid && _phoneValid) {
            hideKeyboard(context);
            bloc.dispatchEvent(
                TapBtnLoginEvent(phone: _phone, pass: _password));
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

  _buildRegisterButton() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(25)),
          border: Border.all(color: Colors.white)),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {},
        child: Center(
          child: Text(
            AppLocalizations.shared.loginPageButtonRegister,
            style: getTextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
        ),
      ),
    );
  }

  _buildSubButton({required String label, required AssetImage image}) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: image,
              width: 46,
              height: 46,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: getTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class _AppNameWidget extends StatelessWidget {
  final double topPadding;
  final double bottomPadding;

  const _AppNameWidget({this.topPadding = 0, this.bottomPadding = 0});

  @override
  Widget build(BuildContext context) {
    Logger().d('tungvt --->> _AppNameWidget build()');
    return Padding(
      padding:
          EdgeInsets.only(top: this.topPadding, bottom: this.bottomPadding),
      child: Text(
        AppLocalizations.shared.appName,
        style: getTextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class _AppLogoWidget extends StatelessWidget {
  const _AppLogoWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Container(
            width: 120,
            height: 120,
            child: const Image(
              image: AppImages.icLogo,
              fit: BoxFit.contain,
            )),
      ),
    );
  }
}

class _RegisterButtonWidget extends StatelessWidget {
  const _RegisterButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: Colors.white)),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {},
        child: Center(
          child: Text(
            AppLocalizations.shared.loginPageButtonRegister,
            style: getTextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
        ),
      ),
    );
  }
}

class _PhoneNumberInputWidget extends StatelessWidget {
  final PropertyController? controller;
  final Function(String)? onInputChanged;

  const _PhoneNumberInputWidget({this.controller, this.onInputChanged});

  @override
  Widget build(BuildContext context) {
    Logger().d('tungvt ---->> build _PhoneNumberInputWidget');
    return ValidatedInputField(
      hintText: AppLocalizations.shared.commonLabelInputPhoneHint,
      prefixImage: AppImages.icPhone,
      propertyController: this.controller,
      keyboardType: TextInputType.number,
      inputFormatters: phoneNumberFormatter,
      validator: Validators.isPhoneNumberValid,
      onInputChanged: this.onInputChanged,
    );
  }
}
