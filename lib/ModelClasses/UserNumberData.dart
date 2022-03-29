// To parse this JSON data, do
//
//     final userNumberData = userNumberDataFromJson(jsonString);

import 'dart:convert';

class UserNumberData {
  UserNumberData({
    this.status,
    this.msg,
    this.registeredUser,
    this.nonRegisteredUser,
  });

  int status;
  String msg;
  List<RegisteredUser> registeredUser;
  List<NonRegisteredUser> nonRegisteredUser;

  factory UserNumberData.fromRawJson(String str) => UserNumberData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserNumberData.fromJson(Map<String, dynamic> json) => UserNumberData(
    status: json["status"],
    msg: json["msg"],
    registeredUser: List<RegisteredUser>.from(json["registered_user"].map((x) => RegisteredUser.fromJson(x))),
    nonRegisteredUser: List<NonRegisteredUser>.from(json["non_registered_user"].map((x) => NonRegisteredUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "registered_user": List<dynamic>.from(registeredUser.map((x) => x.toJson())),
    "non_registered_user": List<dynamic>.from(nonRegisteredUser.map((x) => x.toJson())),
  };
}

class NonRegisteredUser {
  NonRegisteredUser({
    this.name,
    this.number,
    this.isInvited,
  });

  String name;
  String number;
  int isInvited;

  factory NonRegisteredUser.fromRawJson(String str) => NonRegisteredUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NonRegisteredUser.fromJson(Map<String, dynamic> json) => NonRegisteredUser(
    name: json["name"],
    number: json["number"],
    isInvited: json["is_invited"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "number": number,
    "is_invited": isInvited,
  };
}

class RegisteredUser {
  RegisteredUser({
    this.userId,
    this.username,
    this.number,
    this.name,
  });

  int userId;
  String username;
  String number;
  String name;

  factory RegisteredUser.fromRawJson(String str) => RegisteredUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisteredUser.fromJson(Map<String, dynamic> json) => RegisteredUser(
    userId: json["user_id"],
    username: json["username"],
    number: json["number"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "number": number,
    "name": name,
  };
}


//*******UserNumberDataErr********//
class UserNumberDataErr {
  UserNumberDataErr({
    this.status,
    this.message,
  });

  int status;
  String message;

  factory UserNumberDataErr.fromRawJson(String str) => UserNumberDataErr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserNumberDataErr.fromJson(Map<String, dynamic> json) => UserNumberDataErr(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
