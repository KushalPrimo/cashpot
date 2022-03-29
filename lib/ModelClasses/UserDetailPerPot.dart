// To parse this JSON data, do
//
//     final userDetailPerPot = userDetailPerPotFromJson(jsonString);

import 'dart:convert';

class UserDetailPerPot {
  UserDetailPerPot({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory UserDetailPerPot.fromRawJson(String str) => UserDetailPerPot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDetailPerPot.fromJson(Map<String, dynamic> json) => UserDetailPerPot(
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
    this.name,
    this.username,
    this.image,
    this.amount,
  });

  String name;
  String username;
  String image;
  int amount;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    username: json["username"],
    image: json["image"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "image": image,
    "amount": amount,
  };
}
