// To parse this JSON data, do
//
//     final usersCashpotData = usersCashpotDataFromJson(jsonString);

import 'dart:convert';

class UsersCashpotData {
  UsersCashpotData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  List<Datum> data;

  factory UsersCashpotData.fromRawJson(String str) => UsersCashpotData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsersCashpotData.fromJson(Map<String, dynamic> json) => UsersCashpotData(
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
    this.cashpotId,
    this.potName,
    this.goalAmount,
    this.amountPerPerson,
    this.endDate,
    this.creatorId,
    this.potTotalAmount,
    this.potImage,
    this.potMembersCount,
    this.notificationCount,
  });

  int cashpotId;
  String potName;
  int goalAmount;
  String amountPerPerson;
  String endDate;
  int creatorId;
  int potTotalAmount;
  String potImage;
  int potMembersCount;
  int notificationCount;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    cashpotId: json["cashpot_id"],
    potName: json["pot_name"],
    goalAmount: json["goal_amount"] == null ? null : json["goal_amount"],
    amountPerPerson: json["amount_per_person"] == null ? null : json["amount_per_person"],
    endDate: json["end_date"],
    creatorId: json["creator_id"],
    potTotalAmount: json["pot_total_amount"],
    potImage: json["potImage"] == null ? null : json["potImage"],
    potMembersCount: json["pot_members_count"],
    notificationCount: json["notification_count"],
  );

  Map<String, dynamic> toJson() => {
    "cashpot_id": cashpotId,
    "pot_name": potName,
    "goal_amount": goalAmount == null ? null : goalAmount,
    "amount_per_person": amountPerPerson == null ? null : amountPerPerson,
    "end_date": endDate,
    "creator_id": creatorId,
    "pot_total_amount": potTotalAmount,
    "potImage": potImage == null ? null : potImage,
    "pot_members_count": potMembersCount,
    "notification_count": notificationCount,
  };
}
