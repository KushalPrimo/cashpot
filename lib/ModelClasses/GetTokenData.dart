// To parse this JSON data, do
//
//     final getTokenData = getTokenDataFromJson(jsonString);

import 'dart:convert';

class GetTokenData {
  GetTokenData({
    this.status,
    this.msg,
    this.token,
  });

  int status;
  String msg;
  String token;

  factory GetTokenData.fromRawJson(String str) => GetTokenData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTokenData.fromJson(Map<String, dynamic> json) => GetTokenData(
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
