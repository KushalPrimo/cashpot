// To parse this JSON data, do
//
//     final transactionHistaoryData = transactionHistaoryDataFromJson(jsonString);

import 'dart:convert';

class TransactionHistaoryData {
  TransactionHistaoryData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  List<Datum> data;

  factory TransactionHistaoryData.fromRawJson(String str) => TransactionHistaoryData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionHistaoryData.fromJson(Map<String, dynamic> json) => TransactionHistaoryData(
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
    this.amount,
    this.time,
  });

  String msg;
  String username;
  String name;
  int amount;
  String time;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    msg: json["msg"],
    username: json["username"],
    name: json["name"],
    amount: json["amount"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "username": username,
    "name": name,
    "amount": amount,
    "time": time,
  };
}
