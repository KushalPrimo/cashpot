// To parse this JSON data, do
//
//     final newContactData = newContactDataFromJson(jsonString);

import 'dart:convert';

class NewContactData {
  NewContactData({
    this.status,
    this.msg,
    this.page,
    this.recentData,
    this.data,
  });

  int status;
  String msg;
  String page;
  List<RecentDatum> recentData;
  List<Datum> data;

  factory NewContactData.fromRawJson(String str) => NewContactData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewContactData.fromJson(Map<String, dynamic> json) => NewContactData(
    status: json["status"],
    msg: json["msg"],
    page: json["page"],
    recentData: List<RecentDatum>.from(json["recent_data"].map((x) => RecentDatum.fromJson(x))),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "page": page,
    "recent_data": List<dynamic>.from(recentData.map((x) => x.toJson())),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.image,
    this.username,
    this.name,
    this.number,
    this.email,
    this.userId,
  });

  String image;
  String username;
  String name;
  String number;
  String email;
  int userId;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    image: json["image"] == null ? null : json["image"],
    username: json["username"],
    name: json["name"],
    number: json["number"],
    email: json["email"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "image": image == null ? null : image,
    "username": username,
    "name": name,
    "number": number,
    "email": email,
    "user_id": userId,
  };
}

class RecentDatum {
  RecentDatum({
    this.image,
    this.userId,
    this.username,
    this.name,
    this.email,
    this.number,
  });

  dynamic image;
  int userId;
  String username;
  String name;
  String email;
  String number;

  factory RecentDatum.fromRawJson(String str) => RecentDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecentDatum.fromJson(Map<String, dynamic> json) => RecentDatum(
    image: json["image"],
    userId: json["user_id"],
    username: json["username"],
    name: json["name"],
    email: json["email"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "user_id": userId,
    "username": username,
    "name": name,
    "email": email,
    "number": number,
  };
}
