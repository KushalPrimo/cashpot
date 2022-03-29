// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

class ProfileData {
  ProfileData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory ProfileData.fromRawJson(String str) => ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
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
    this.userId,
    this.name,
    this.image,
    this.email,
    this.username,
    this.password,
    this.number,
    this.userType,
    this.socialId,
    this.isDeleted,
    this.deviceToken,
    this.deviceType,
    this.userDwollaLink,
    this.walletAmount,
    this.dateCreated,
    this.dateUpdated,
  });

  int userId;
  String name;
  String image;
  String email;
  String username;
  String password;
  String number;
  int userType;
  String socialId;
  int isDeleted;
  String deviceToken;
  String deviceType;
  String userDwollaLink;
  int walletAmount;
  String dateCreated;
  String dateUpdated;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    name: json["name"],
    image: json["image"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    number: json["number"],
    userType: json["user_type"],
    socialId: json["social_id"],
    isDeleted: json["is_deleted"],
    deviceToken: json["device_token"],
    deviceType: json["device_type"],
    userDwollaLink: json["user_dwolla_link"],
    walletAmount: json["wallet_amount"],
    dateCreated: json["date_created"],
    dateUpdated: json["date_updated"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "image": image,
    "email": email,
    "username": username,
    "password": password,
    "number": number,
    "user_type": userType,
    "social_id": socialId,
    "is_deleted": isDeleted,
    "device_token": deviceToken,
    "device_type": deviceType,
    "user_dwolla_link": userDwollaLink,
    "wallet_amount": walletAmount,
    "date_created": dateCreated,
    "date_updated": dateUpdated,
  };
}



//ProfileError DAta
class ProfileErrorData {
  ProfileErrorData({
    this.status,
    this.message,
  });

  int status;
  String message;

  factory ProfileErrorData.fromRawJson(String str) => ProfileErrorData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileErrorData.fromJson(Map<String, dynamic> json) => ProfileErrorData(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
