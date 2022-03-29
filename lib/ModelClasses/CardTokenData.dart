// To parse this JSON data, do
//
//     final cardTokenData = cardTokenDataFromJson(jsonString);

import 'dart:convert';

class CardTokenData {
  CardTokenData({
    this.status,
    this.msg,
    this.token,
  });

  int status;
  String msg;
  String token;

  factory CardTokenData.fromRawJson(String str) => CardTokenData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardTokenData.fromJson(Map<String, dynamic> json) => CardTokenData(
    status: json["status"],
    msg: json["msg"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "token": token,
  };
}
