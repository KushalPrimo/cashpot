// To parse this JSON data, do
//
//     final cardListData = cardListDataFromJson(jsonString);

import 'dart:convert';

class CardListData {
  CardListData({
    this.status,
    this.msg,
    this.data,
  });

  int status;
  String msg;
  Data data;

  factory CardListData.fromRawJson(String str) => CardListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardListData.fromJson(Map<String, dynamic> json) => CardListData(
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
    this.banks,
    this.cards,
    this.balanceAmount,
  });

  List<Bank> banks;
  List<dynamic> cards;
  int balanceAmount;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
    cards: List<dynamic>.from(json["cards"].map((x) => x)),
    balanceAmount: json["balance_amount"],
  );

  Map<String, dynamic> toJson() => {
    "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
    "cards": List<dynamic>.from(cards.map((x) => x)),
    "balance_amount": balanceAmount,
  };
}

class Bank {
  Bank({
    this.id,
    this.status,
    this.removed,
    this.type,
    this.bankAccountType,
    this.name,
    this.bankName,
  });

  String id;
  String status;
  bool removed;
  String type;
  String bankAccountType;
  String name;
  String bankName;

  factory Bank.fromRawJson(String str) => Bank.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    id: json["id"],
    status: json["status"],
    removed: json["removed"],
    type: json["type"],
    bankAccountType: json["bankAccountType"],
    name: json["name"],
    bankName: json["bankName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "removed": removed,
    "type": type,
    "bankAccountType": bankAccountType,
    "name": name,
    "bankName": bankName,
  };
}
