import 'package:base/presentation/base/base_page_mixin.dart';

enum NotificationType {
  cashin,
  cashout,
  transfer,
  none,
}

NotificationType getTransactionTypeFrom(String value) {
  switch (value) {
    case "CASHIN":
      return NotificationType.cashin;
    case "CASHOUT":
      return NotificationType.cashout;
    default:
      return NotificationType.none;
  }
}

extension NotificationTypeValue on NotificationType {
  String get title {
    switch (this) {
      case NotificationType.cashin:
        return AppLocalizations.shared.notifyLabelCashIn;
      case NotificationType.cashout:
        return AppLocalizations.shared.notifyLabelCashOut;
      default:
        return AppLocalizations.shared.notifyLabelTransfer;
    }
  }
}

enum NotificationStatus {
  read,
  unread,
}
