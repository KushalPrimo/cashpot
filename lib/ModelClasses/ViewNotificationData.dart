// To parse this JSON data, do
//
//     final viewNotificationData = viewNotificationDataFromJson(jsonString);

import 'dart:convert';

class ViewNotificationData {
  ViewNotificationData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory ViewNotificationData.fromRawJson(String str) => ViewNotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ViewNotificationData.fromJson(Map<String, dynamic> json) => ViewNotificationData(
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
    this.image,
    this.notificationText,
    this.cashpotUserId,
  });

  String username;
  String notificationId;
  String name;
  String image;
  String notificationText;
  int cashpotUserId;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    username: json["username"],
    notificationId: json["notification_id"],
    name: json["name"],
    image: json["image"],
    notificationText: json["notification_text"],
    cashpotUserId: json["cashpot_user_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "notification_id": notificationId,
    "name": name,
    "image": image,
    "notification_text": notificationText,
    "cashpot_user_id": cashpotUserId,
  };
}


//Error Class
class ViewNotificationErrData {
  ViewNotificationErrData({
    this.status,
    this.msg,
    this.error,
  });

  int status;
  String msg;
  List<dynamic> error;

  factory ViewNotificationErrData.fromRawJson(String str) => ViewNotificationErrData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ViewNotificationErrData.fromJson(Map<String, dynamic> json) => ViewNotificationErrData(
    status: json["status"],
    msg: json["msg"],
    error: List<dynamic>.from(json["error"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "error": List<dynamic>.from(error.map((x) => x)),
  };
}
