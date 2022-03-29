// To parse this JSON data, do
//
//     final potNotificationsData = potNotificationsDataFromJson(jsonString);

import 'dart:convert';

class PotNotificationsData {
  PotNotificationsData({
    this.status,
    this.msg,
    this.result,
  });

  int status;
  String msg;
  List<Result> result;

  factory PotNotificationsData.fromRawJson(String str) => PotNotificationsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PotNotificationsData.fromJson(Map<String, dynamic> json) => PotNotificationsData(
    status: json["status"],
    msg: json["msg"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.notificationId,
    this.userId,
    this.cashpotId,
    this.notificationText,
    this.isAcceptNotification,
    this.isSeen,
    this.cashpotUserId,
    this.dateCreated,
    this.dateUpdated,
  });

  int notificationId;
  int userId;
  int cashpotId;
  String notificationText;
  int isAcceptNotification;
  int isSeen;
  dynamic cashpotUserId;
  String dateCreated;
  String dateUpdated;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    notificationId: json["notification_id"],
    userId: json["user_id"],
    cashpotId: json["cashpot_id"],
    notificationText: json["notification_text"],
    isAcceptNotification: json["is_accept_notification"],
    isSeen: json["is_seen"],
    cashpotUserId: json["cashpot_user_id"],
    dateCreated: json["date_created"],
    dateUpdated: json["date_updated"],
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "user_id": userId,
    "cashpot_id": cashpotId,
    "notification_text": notificationText,
    "is_accept_notification": isAcceptNotification,
    "is_seen": isSeen,
    "cashpot_user_id": cashpotUserId,
    "date_created": dateCreated,
    "date_updated": dateUpdated,
  };
}
