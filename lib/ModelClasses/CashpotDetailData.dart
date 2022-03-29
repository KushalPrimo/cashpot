// To parse this JSON data, do
//
//     final cashpotDetailData = cashpotDetailDataFromJson(jsonString);

import 'dart:convert';

class CashpotDetailData {
  CashpotDetailData({
    this.status,
    this.msg,
    this.data,
    this.error,
  });

  int status;
  String msg;
  Data data;
  List<dynamic> error;

  factory CashpotDetailData.fromRawJson(String str) => CashpotDetailData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashpotDetailData.fromJson(Map<String, dynamic> json) => CashpotDetailData(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
    error: List<dynamic>.from(json["error"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
    "error": List<dynamic>.from(error.map((x) => x)),
  };
}

class Data {
  Data({
    this.cashpotInfo,
    this.potActivity,
  });

  CashpotInfo cashpotInfo;
  List<PotActivity> potActivity;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cashpotInfo: CashpotInfo.fromJson(json["cashpot_info"]),
    potActivity: List<PotActivity>.from(json["pot_activity"].map((x) => PotActivity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cashpot_info": cashpotInfo.toJson(),
    "pot_activity": List<dynamic>.from(potActivity.map((x) => x.toJson())),
  };
}

class CashpotInfo {
  CashpotInfo({
    this.cashpotId,
    this.potName,
    this.goalAmount,
    this.amountPerPerson,
    this.potTotalAmount,
    this.endDate,
    this.creatorId,
    this.isDeleted,
    this.isShareable,
    this.isAmountShown,
    this.shareableLink,
    this.dateUpdated,
    this.dateCreated,
    this.potImage,
    this.cashpotProgress,
    this.potMembersCount,
  });

  int cashpotId;
  String potName;
  int goalAmount;
  String amountPerPerson;
  int potTotalAmount;
  String endDate;
  int creatorId;
  int isDeleted;
  int isShareable;
  int isAmountShown;
  dynamic shareableLink;
  String dateUpdated;
  String dateCreated;
  String potImage;
  double cashpotProgress;
  int potMembersCount;

  factory CashpotInfo.fromRawJson(String str) => CashpotInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashpotInfo.fromJson(Map<String, dynamic> json) => CashpotInfo(
    cashpotId: json["cashpot_id"],
    potName: json["pot_name"],
    goalAmount: json["goal_amount"],
    amountPerPerson: json["amount_per_person"],
    potTotalAmount: json["pot_total_amount"],
    endDate: json["end_date"],
    creatorId: json["creator_id"],
    isDeleted: json["is_deleted"],
    isShareable: json["is_shareable"],
    isAmountShown: json["is_amount_shown"],
    shareableLink: json["shareable_link"],
    dateUpdated: json["date_updated"],
    dateCreated: json["date_created"],
    potImage: json["potImage"],
    cashpotProgress: json["cashpot_progress"].toDouble(),
    potMembersCount: json["pot_members_count"],
  );

  Map<String, dynamic> toJson() => {
    "cashpot_id": cashpotId,
    "pot_name": potName,
    "goal_amount": goalAmount,
    "amount_per_person": amountPerPerson,
    "pot_total_amount": potTotalAmount,
    "end_date": endDate,
    "creator_id": creatorId,
    "is_deleted": isDeleted,
    "is_shareable": isShareable,
    "is_amount_shown": isAmountShown,
    "shareable_link": shareableLink,
    "date_updated": dateUpdated,
    "date_created": dateCreated,
    "potImage": potImage,
    "cashpot_progress": cashpotProgress,
    "pot_members_count": potMembersCount,
  };
}

class PotActivity {
  PotActivity({
    this.amount,
    this.userId,
    this.name,
    this.username,
    this.cashpotId,
    this.image,
  });

  int amount;
  int userId;
  String name;
  String username;
  int cashpotId;
  dynamic image;

  factory PotActivity.fromRawJson(String str) => PotActivity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PotActivity.fromJson(Map<String, dynamic> json) => PotActivity(
    amount: json["amount"],
    userId: json["user_id"],
    name: json["name"],
    username: json["username"],
    cashpotId: json["cashpot_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "user_id": userId,
    "name": name,
    "username": username,
    "cashpot_id": cashpotId,
    "image": image,
  };
}
