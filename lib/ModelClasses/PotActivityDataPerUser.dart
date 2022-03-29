// To parse this JSON data, do
//
//     final potActivityDataPerUser = potActivityDataPerUserFromJson(jsonString);

import 'dart:convert';

class PotActivityDataPerUser {
  PotActivityDataPerUser({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory PotActivityDataPerUser.fromRawJson(String str) => PotActivityDataPerUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PotActivityDataPerUser.fromJson(Map<String, dynamic> json) => PotActivityDataPerUser(
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
    this.totalAmount,
    this.potActivity,
  });

  int totalAmount;
  List<PotActivity> potActivity;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalAmount: json["total_amount"],
    potActivity: List<PotActivity>.from(json["pot_activity"].map((x) => PotActivity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_amount": totalAmount,
    "pot_activity": List<dynamic>.from(potActivity.map((x) => x.toJson())),
  };
}

class PotActivity {
  PotActivity({
    this.userId,
    this.cashpotId,
    this.message,
    this.amount,
    this.transactionType,
    this.timeDifference,
    this.image,
  });

  int userId;
  int cashpotId;
  String message;
  int amount;
  int transactionType;
  String timeDifference;
  String image;

  factory PotActivity.fromRawJson(String str) => PotActivity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PotActivity.fromJson(Map<String, dynamic> json) => PotActivity(
    userId: json["user_id"],
    cashpotId: json["cashpot_id"],
    message: json["message"],
    amount: json["amount"],
    transactionType: json["transaction_type"],
    timeDifference: json["time_difference"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "cashpot_id": cashpotId,
    "message": message,
    "amount": amount,
    "transaction_type": transactionType,
    "time_difference": timeDifference,
    "image": image,
  };
}
