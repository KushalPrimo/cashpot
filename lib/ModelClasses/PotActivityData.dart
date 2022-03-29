// To parse this JSON data, do
//
//     final potActivityData = potActivityDataFromJson(jsonString);

import 'dart:convert';

class PotActivityData {
  PotActivityData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  List<Datum> data;

  factory PotActivityData.fromRawJson(String str) => PotActivityData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PotActivityData.fromJson(Map<String, dynamic> json) => PotActivityData(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
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

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
