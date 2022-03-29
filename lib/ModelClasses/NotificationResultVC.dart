// To parse this JSON data, do
//
//     final notificationResultVc = notificationResultVcFromJson(jsonString);

import 'dart:convert';

class NotificationResultVc {
  NotificationResultVc({
    this.status,
    this.msg,
    this.result,
  });

  int status;
  String msg;
  Result result;

  factory NotificationResultVc.fromRawJson(String str) => NotificationResultVc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationResultVc.fromJson(Map<String, dynamic> json) => NotificationResultVc(
    status: json["status"],
    msg: json["msg"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "result": result.toJson(),
  };
}

class Result {
  Result({
    this.notificationPermissionId,
    this.userId,
    this.pushBankTransfer,
    this.pushCashRequestPaymentRecieved,
    this.pushCashRequestPaymentSend,
    this.pushCashRequestRecieved,
    this.pushCashRequestSent,
    this.pushJoinRequest,
    this.emailBankTransfer,
    this.emailCashRequestPaymentRecieved,
    this.emailCashRequestPaymentSend,
    this.emailAddCashDenied,
    this.emailCashRequestRecieved,
    this.emailCashRequestSent,
    this.emailCashRequestDenied,
    this.emailJoinPotRequest,
    this.textBankTransfer,
    this.textCashRequestPaymentRecieved,
    this.textCashRequestPaymentSend,
    this.textAddCashDenied,
    this.textCashRequestRecieved,
    this.textCashRequestSent,
    this.textCashRequestDenied,
  });

  int notificationPermissionId;
  int userId;
  int pushBankTransfer;
  int pushCashRequestPaymentRecieved;
  int pushCashRequestPaymentSend;
  int pushCashRequestRecieved;
  int pushCashRequestSent;
  int pushJoinRequest;
  int emailBankTransfer;
  int emailCashRequestPaymentRecieved;
  int emailCashRequestPaymentSend;
  int emailAddCashDenied;
  int emailCashRequestRecieved;
  int emailCashRequestSent;
  int emailCashRequestDenied;
  int emailJoinPotRequest;
  int textBankTransfer;
  int textCashRequestPaymentRecieved;
  int textCashRequestPaymentSend;
  int textAddCashDenied;
  int textCashRequestRecieved;
  int textCashRequestSent;
  int textCashRequestDenied;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    notificationPermissionId: json["notification_permission_id"],
    userId: json["user_id"],
    pushBankTransfer: json["push_bank_transfer"],
    pushCashRequestPaymentRecieved: json["push_cash_request_payment_recieved"],
    pushCashRequestPaymentSend: json["push_cash_request_payment_send"],
    pushCashRequestRecieved: json["push_cash_request_recieved"],
    pushCashRequestSent: json["push_cash_request_sent"],
    pushJoinRequest: json["push_join_request"],
    emailBankTransfer: json["email_bank_transfer"],
    emailCashRequestPaymentRecieved: json["email_cash_request_payment_recieved"],
    emailCashRequestPaymentSend: json["email_cash_request_payment_send"],
    emailAddCashDenied: json["email_add_cash_denied"],
    emailCashRequestRecieved: json["email_cash_request_recieved"],
    emailCashRequestSent: json["email_cash_request_sent"],
    emailCashRequestDenied: json["email_cash_request_denied"],
    emailJoinPotRequest: json["email_join_pot_request"],
    textBankTransfer: json["text_bank_transfer"],
    textCashRequestPaymentRecieved: json["text_cash_request_payment_recieved"],
    textCashRequestPaymentSend: json["text_cash_request_payment_send"],
    textAddCashDenied: json["text_add_cash_denied"],
    textCashRequestRecieved: json["text_cash_request_recieved"],
    textCashRequestSent: json["text_cash_request_sent"],
    textCashRequestDenied: json["text_cash_request_denied"],
  );

  Map<String, dynamic> toJson() => {
    "notification_permission_id": notificationPermissionId,
    "user_id": userId,
    "push_bank_transfer": pushBankTransfer,
    "push_cash_request_payment_recieved": pushCashRequestPaymentRecieved,
    "push_cash_request_payment_send": pushCashRequestPaymentSend,
    "push_cash_request_recieved": pushCashRequestRecieved,
    "push_cash_request_sent": pushCashRequestSent,
    "push_join_request": pushJoinRequest,
    "email_bank_transfer": emailBankTransfer,
    "email_cash_request_payment_recieved": emailCashRequestPaymentRecieved,
    "email_cash_request_payment_send": emailCashRequestPaymentSend,
    "email_add_cash_denied": emailAddCashDenied,
    "email_cash_request_recieved": emailCashRequestRecieved,
    "email_cash_request_sent": emailCashRequestSent,
    "email_cash_request_denied": emailCashRequestDenied,
    "email_join_pot_request": emailJoinPotRequest,
    "text_bank_transfer": textBankTransfer,
    "text_cash_request_payment_recieved": textCashRequestPaymentRecieved,
    "text_cash_request_payment_send": textCashRequestPaymentSend,
    "text_add_cash_denied": textAddCashDenied,
    "text_cash_request_recieved": textCashRequestRecieved,
    "text_cash_request_sent": textCashRequestSent,
    "text_cash_request_denied": textCashRequestDenied,
  };
}
