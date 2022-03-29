// To parse this JSON data, do
//
//     final uploadImageData = uploadImageDataFromJson(jsonString);

import 'dart:convert';

class UploadImageData {
  UploadImageData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  String data;

  factory UploadImageData.fromRawJson(String str) => UploadImageData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UploadImageData.fromJson(Map<String, dynamic> json) => UploadImageData(
    status: json["status"],
    msg: json["msg"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data,
  };
}
