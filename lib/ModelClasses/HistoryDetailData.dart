// To parse this JSON data, do
//
//     final historyDetailData = historyDetailDataFromJson(jsonString);

import 'dart:convert';

class HistoryDetailData {
  HistoryDetailData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory HistoryDetailData.fromRawJson(String str) => HistoryDetailData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryDetailData.fromJson(Map<String, dynamic> json) => HistoryDetailData(
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
    this.userInfo,
    this.potActivity,
  });

  UserInfo userInfo;
  List<PotActivity> potActivity;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userInfo: UserInfo.fromJson(json["user_info"]),
    potActivity: List<PotActivity>.from(json["pot_activity"].map((x) => PotActivity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_info": userInfo.toJson(),
    "pot_activity": List<dynamic>.from(potActivity.map((x) => x.toJson())),
  };
}

class PotActivity {
  PotActivity({
    this.potActivityId,
    this.userId,
    this.cashpotId,
    this.message,
    this.amount,
    this.status,
    this.transactionType,
    this.timeDifference,
    this.image,
  });

  int potActivityId;
  int userId;
  int cashpotId;
  String message;
  int amount;
  int status;
  int transactionType;
  String timeDifference;
  String image;

  factory PotActivity.fromRawJson(String str) => PotActivity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PotActivity.fromJson(Map<String, dynamic> json) => PotActivity(
    potActivityId: json["pot_activity_id"],
    userId: json["user_id"],
    cashpotId: json["cashpot_id"],
    message: json["message"],
    amount: json["amount"] == null ? null : json["amount"],
    status: json["status"],
    transactionType: json["transaction_type"],
    timeDifference: json["time_difference"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "pot_activity_id": potActivityId,
    "user_id": userId,
    "cashpot_id": cashpotId,
    "message": message,
    "amount": amount == null ? null : amount,
    "status": status,
    "transaction_type": transactionType,
    "time_difference": timeDifference,
    "image": image,
  };
}

class UserInfo {
  UserInfo({
    this.username,
    this.name,
    this.image,
  });

  String username;
  String name;
  String image;

  factory UserInfo.fromRawJson(String str) => UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    username: json["username"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "name": name,
    "image": image,
  };
}
