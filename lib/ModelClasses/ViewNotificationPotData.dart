// To parse this JSON data, do
//
//     final viewNotificationPotData = viewNotificationPotDataFromJson(jsonString);

import 'dart:convert';

class ViewNotificationPotData {
  ViewNotificationPotData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory ViewNotificationPotData.fromRawJson(String str) => ViewNotificationPotData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ViewNotificationPotData.fromJson(Map<String, dynamic> json) => ViewNotificationPotData(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.username,
    this.notificationId,
    this.name,
    this.amount,
    this.image,
    this.notificationText,
    this.cashRequestId,
  });

  String username;
  String notificationId;
  String name;
  int amount;
  String image;
  String notificationText;
  int cashRequestId;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    username: json["username"],
    notificationId: json["notification_id"],
    name: json["name"],
    amount: json["amount"],
    image: json["image"],
    notificationText: json["notification_text"],
    cashRequestId: json["cash_request_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "notification_id": notificationId,
    "name": name,
    "amount": amount,
    "image": image,
    "notification_text": notificationText,
    "cash_request_id": cashRequestId,
  };
}
