// To parse this JSON data, do
//
//     final personalWalletData = personalWalletDataFromJson(jsonString);

import 'dart:convert';

class PersonalWalletData {
  PersonalWalletData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  List<Datum> data;

  factory PersonalWalletData.fromRawJson(String str) => PersonalWalletData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonalWalletData.fromJson(Map<String, dynamic> json) => PersonalWalletData(
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
    this.msg,
    this.username,
    this.name,
    this.transactionType,
    this.profilePic,
    this.amount,
  });

  String msg;
  String username;
  String name;
  String transactionType;
  String profilePic;
  int amount;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    msg: json["msg"],
    username: json["username"],
    name: json["name"],
    transactionType: json["transaction_type"],
    profilePic: json["profile_pic"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "username": username,
    "name": name,
    "transaction_type": transactionType,
    "profile_pic": profilePic,
    "amount": amount,
  };
}
