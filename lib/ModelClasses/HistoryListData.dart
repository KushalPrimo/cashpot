// To parse this JSON data, do
//
//     final historyListData = historyListDataFromJson(jsonString);

import 'dart:convert';

class HistoryListData {
  HistoryListData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory HistoryListData.fromRawJson(String str) => HistoryListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryListData.fromJson(Map<String, dynamic> json) => HistoryListData(
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
    this.userInfo,
    this.userPots,
  });

  UserInfo userInfo;
  List<UserPot> userPots;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userInfo: UserInfo.fromJson(json["user_info"]),
    userPots: List<UserPot>.from(json["user_pots"].map((x) => UserPot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_info": userInfo.toJson(),
    "user_pots": List<dynamic>.from(userPots.map((x) => x.toJson())),
  };
}

class UserInfo {
  UserInfo({
    this.username,
    this.name,
    this.image,
  });

  String username;
  String name;
  String image;

  factory UserInfo.fromRawJson(String str) => UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    username: json["username"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "name": name,
    "image": image,
  };
}

class UserPot {
  UserPot({
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

  factory UserPot.fromRawJson(String str) => UserPot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPot.fromJson(Map<String, dynamic> json) => UserPot(
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
  };
}
