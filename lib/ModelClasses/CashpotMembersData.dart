// To parse this JSON data, do
//
//     final cashpotMembersData = cashpotMembersDataFromJson(jsonString);

import 'dart:convert';

class CashpotMembersData {
  CashpotMembersData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  List<Datum> data;

  factory CashpotMembersData.fromRawJson(String str) => CashpotMembersData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashpotMembersData.fromJson(Map<String, dynamic> json) => CashpotMembersData(
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
    this.userId,
    this.cashpotId,
    this.cashpotUserId,
    this.username,
    this.name,
    this.image,
  });

  int userId;
  int cashpotId;
  int cashpotUserId;
  String username;
  String name;
  String image;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["user_id"],
    cashpotId: json["cashpot_id"],
    cashpotUserId: json["cashpot_user_id"],
    username: json["username"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "cashpot_id": cashpotId,
    "cashpot_user_id": cashpotUserId,
    "username": username,
    "name": name,
    "image": image,
  };
}
