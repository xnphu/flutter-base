import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  static AppLocalizations shared = AppLocalizations._();
  Map<dynamic, dynamic> _localisedValues = {};

  AppLocalizations._() {}

  static AppLocalizations of(BuildContext context) {
    return shared;
  }

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }

  // defined text
  String get appName => text('app_name');
  String get sessionExpiredMessage =>
      text('common_message_error_session_expired');
  String get commonMessageConnectionError =>
      text('common_message_connection_error');
  String get commonMessageServerMaintenance =>
      text('common_message_server_maintenance');
  String get commonMessagePasswordError =>
      text('common_message_password_error');
  String get commonMessagePhoneError => text('common_message_phone_error');
  String get commonMessageConfirmPasswordError =>
      text('common_message_confirm_password_error');
  String get commonMessageFullnameError =>
      text('common_message_fullname_error');
  String get commonMessageRequiredField => text('common_message_require_field');
  String get commonMessageEmailError => text('commonMessageEmailError');
  String get commonMessageIdCardError => text('commonMessageIdCardError');

  String get commonLabelInputPhoneHint => text('common_label_input_phone_hint');
  String get commonLabelInputPasswordHint =>
      text('common_label_input_password_hint');
  String get commonButtonTouchId => text('login_button_touchid');
  String get commonButtonFaceId => text('login_button_faceid');
  String get loginPageButtonLogin => text('login_button_login');
  String get loginPageButtonRegister => text('login_button_register');
  String get loginPageLabelDontHaveAccount =>
      text('login_label_dont_have_account');
  String get loginPageButtonNews => text('login_button_news');
  String get loginPageButtonFAQ => text('login_button_faq');
  String get loginPageButtonContact => text('login_button_contact');

  String get fullName => text('regisger_label_full_name');
  String get amount => text('home_label_amount');
  String get hello => text('home_label_greeting');
  String get transaction => text('home_menu_label_transaction');
  String get account => text('home_menu_label_account');
  String get setting => text('home_menu_label_setting');
  String get notification => text('home_menu_label_notification');
  String get yes => text('yes');
  String get no => text('no');
  String get unlink => text('unlink');

  String get commonButtonCancel => text('common_button_cancel');
  String get commonMessageAuthenByFaceID =>
      text('common_message_authen_by_faceid');
  String get commonMessageAuthenByTouchID =>
      text('common_message_authen_by_touchid');
  String get commonMessageAuthenBiometricError =>
      text('common_message_authen_biometric_error');
  String get commonMessageSetupBiometric =>
      text('common_message_setup_biometric');
  String get rememberLoginButtonNotMe => text('remember_login_button_not_me');
  String get commonMessageAuthorizedByBiometrictNotEnable =>
      text('common_message_authorized_biometric_not_enable');
  String get settingMessageEnableBiometricAuthen =>
      text('setting_message_enable_biometric_authen');

  String get notificationButtonMarkReadAll =>
      text('notification_button_mark_read_all');
  String get notifyListMessageMarkAsReadAllConfirm =>
      text('notification_message_mark_read_all_conrim');
  String get notifyLabelCashIn => text('notification_label_cashin');
  String get notifyLabelCashOut => text('notification_label_cashout');
  String get notifyLabelTransfer => text('notification_label_transfer');
  String get notifyLabelPromo => text('notification_label_promo');
  String get commonMessageNoData => text('common_message_no_data');
  String get notifyDetailTitle => text('notification_detail_label');

  Future<void> reloadLanguageBundle({required String languageCode}) async {
    String path = "assets/jsons/localization_vi.json";
    String jsonContent = "";
    try {
      jsonContent = await rootBundle.loadString(path);
    } catch (_) {
      //use default Vietnamese
      jsonContent =
          await rootBundle.loadString("assets/jsons/localization_vi.json");
    }
    _localisedValues = json.decode(jsonContent);
  }
}
