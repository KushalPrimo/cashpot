import 'dart:convert';

import 'package:cashpot/ModelClasses/CardListData.dart';
import 'package:cashpot/ModelClasses/GetTokenData.dart';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Utility.dart';
import '../WebServices.dart';

class TransferFundBankListVC extends StatefulWidget {
  final String amountStr;

  const TransferFundBankListVC(
    this.amountStr,
  );

  @override
  _TransferFundBankListVCState createState() => _TransferFundBankListVCState();
}

class _TransferFundBankListVCState extends State<TransferFundBankListVC> {
  String dropdownValue;
  String dropdownValue2;
  String dropdownValue3;
  bool radio1 = false;
  bool radio2 = false;
  bool radio3 = false;
  CardListData cardListData;
  var bankDataTemp;
  List bankListAry = [];
  var balanceStr = "";
  List cardListAry = [];
  var bankName = [];
  var cardName = [];
  var cardID = [];
  var bankID = [];
  String chooseBankIDStr = "";
  String chooseCardIDStr = "";
  String CardnameStr = "";
  String transfer_type = "standard";
  String givenAmnt = "";
  String FeeStr = "";
  String cashpotFee = "";
  String totalTransAmnt = "";
  var feeData;
  String cardBankValStr = "Bank";

  getbankListAPI() async {
    Utility().onLoading(context, true);
    var sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().usersfundingsources}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    //print("bankListAry=========${bankListAry}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-------${cardListData.toJson()}");
      setState(() {
        cardListData = CardListData.fromJson(json.decode(response.body));
        // print("cardListData--------${cardListData.toJson()}");
        bankDataTemp = cardListData.data.toJson();
        bankListAry = bankDataTemp["banks"];
        // print("bankListAry========${bankListAry.length}");
        for (int i = 0; i < bankListAry.length; i++) {
          // print(bankListAry[i]["bankName"]);
          bankName.add(bankListAry[i]["name"].toString());
          bankID.add(bankListAry[i]["id"].toString());
        }
        //print("_bankName---${bankName}");
        //    balanceStr = bankDataTemp["balance_amount"].toString();
        cardListAry = bankDataTemp["cards"];
        // print("cardListAry========${cardListAry.length}");
        for (int i = 0; i < cardListAry.length; i++) {
          //   print(cardListAry[i]["bankName"]);
          cardName.add(cardListAry[i]["name"].toString());
          cardID.add(cardListAry[i]["id"].toString());
        }
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  transferAmountAPI() async {
    Utility().onLoading(context, true);
    var sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "amount": givenAmnt,
      "to_funding_source": chooseCardIDStr,
      "transfer_type": transfer_type,
      "fees": "0",
    };
    //  print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().wallettobank}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    print("resData=========${resData}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-------TRANSFER");
      Navigator.of(context).pushNamed('/TransferCompletePopUpVC');
    } else {
      Utility().toast(context, "${resData["msg"].toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // print("amount---------${widget.amountStr}");
    Future.delayed(Duration.zero, () {
      getbankListAPI();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> FeesCalCashDialog(BuildContext context) async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                  backgroundColor: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 350, maxHeight: 460),
                    child: Container(
                      //  height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // child: Expanded(
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                // color: Colors.red,
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      //size: 30,
                                    ),
                                    onPressed: () {
                                      print("Cross Clicked");
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              )),
                          Container(
                            //margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Transfer Funds",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Helvetica Neue"),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Divider(
                            color: Colors.black,
                            height: 1,
                          ),
                          ListTile(
                            title: Text(
                              "Transfer Amount",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Helvetica Neue"),
                            ),
                            trailing: Text("\$${givenAmnt}.00"),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 1,
                          ),
                          ListTile(
                            title: Text(
                              "${cardBankValStr}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Helvetica Neue"),
                            ),
                            trailing: Text(
                              "${CardnameStr}",
                              style: TextStyle(
                                fontFamily: "Helvetica Neue",
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 1,
                          ),
                          ListTile(
                            title: Text(
                              "Transfer Fee",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Helvetica Neue"),
                            ),
                            trailing: transfer_type != "standard"
                                ? Text("${FeeStr}")
                                : Text(
                                    "\$${0.0}"), //Text("${FeeStr}",style: TextStyle(fontFamily: "Helvetica Neue",),),//
                          ),
                          Divider(
                            color: Colors.black,
                            height: 1,
                          ),
                          ListTile(
                            title: Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Helvetica Neue"),
                            ),
                            trailing: transfer_type != "standard"
                                ? Text("\$${totalTransAmnt}")
                                : Text(
                                    "\$${givenAmnt}.00"), //Text("\$${totalTransAmnt}",style: TextStyle(fontFamily: "Helvetica Neue",),),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 1,
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 30, right: 30),
                            child: Text(
                              "Transfer rate will be depend on your bank.",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontFamily: "Helvetica Neue"),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: AppColor.newSignInColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 4, bottom: 4),
                                    child: Text(
                                      "               Transfer               ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                  ),
                                  onTap: () {
                                    print(" Clicked");
                                    // removeamntVal();
                                    Navigator.of(context).pop();
                                    transferAmountAPI();
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ));
            });
          });
    }

    feeCalculationAPI() async {
      Utility().onLoading(context, true);
      var sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        // "user_id": sharedPreferences.getString("UserID").toString(),
        //  "login_id": sharedPreferences.getString("UserID").toString(),
        "amount": "${widget.amountStr}"
      };
      // print('data-------------${data}');
      String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
      var response = await http.post(
          "${Webservice().apiUrlPayment}${Webservice().feestranferfundinfo}",
          body: data,
          headers: <String, String>{
            'authorization': basicAuth,
          });
      // print("RES====list=====${json.decode(response.body) as Map}");
      Utility().onLoading(context, false);
      Map resData = json.decode(response.body) as Map;

      //   print("resData=====FEES====${resData}");
      if (resData["status"] == 1) {
        print("API SUCCESS-------Fee calculation");
        setState(() {
          feeData = resData["data"];
          givenAmnt = feeData["given_amount"].toString();
          cashpotFee = feeData["cashpot_fees"].toString();
          FeeStr = feeData["fees"].toString();

          totalTransAmnt = "${feeData["total_amount"].toString()}";
        });
        // print("feeData-------${feeData}");
        await FeesCalCashDialog(context);
      } else {
        Utility().toast(context, "Something went wrong");
      }
    }

    CheckVal() {
      if (radio1 == true && CardnameStr != "") {
        //DO HERE
        feeCalculationAPI();
      } else if (radio2 == true && CardnameStr != "") {
        //DO HERE
        feeCalculationAPI();
      }else if (radio3 == true && CardnameStr != "") {
        //DO HERE
        feeCalculationAPI();
      }
      else {
        Utility().toast(context, "Select card/bank first");
      }
    }


    final InstantTranferCont = Container(
      margin: EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Instant Transfer",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                  color: Colors.black),
            ),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Minutes",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica Neue",
                    fontSize: 18,
                    color: Color(0xff707070)),
              ),
              // SizedBox(
              //   width: 130,
              // ),
              Text(
                "1% Fee",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica Neue",
                    fontSize: 20,
                    color: Color(0xff707070)),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Container(
          //  height: 130,
            width: MediaQuery.of(context).size.width,
            // margin: EdgeInsets.only(),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Select Debit Card",
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica Neue",
                        fontSize: 18,
                        color: Color(0xff707070)),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        radio2 == false
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        color: AppColor.newSignInColor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          print("CLICKED FIRST");
                          radio2 = true;
                          radio1 = false;
                          radio3 = false;
                          dropdownValue = null;
                          dropdownValue3 = null;
                          CardnameStr = "";
                          transfer_type = "instant";
                          cardBankValStr = "Card";
                        });
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 80,

                            margin: EdgeInsets.only(left: 10),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Text(
                                      "Select Card",
                                      style: TextStyle(
                                        fontFamily: "Helvetica Neue",
                                      ),
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    value: dropdownValue2,
                                    items: cardName.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: radio2 == true
                                        ? (selectedItem) {
                                            setState(() {
                                              dropdownValue2 = selectedItem;
                                              chooseCardIDStr = cardID[cardName
                                                  .indexOf(selectedItem)];
                                              CardnameStr = dropdownValue2;
                                              // print(
                                              //     "chooseCardIDStr---instant---${chooseCardIDStr}");
                                            });
                                          }
                                        : null))),
                      ),
                    )
                  ],
                ),
                //10 Aug
              SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Select Bank Account",
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica Neue",
                        fontSize: 18,
                        color: Color(0xff707070)),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        radio3 == false
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        color: AppColor.newSignInColor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          print("CLICKED SECOND");
                          radio3 = true;
                          radio1 = false;
                          radio2 = false;
                          dropdownValue = null;
                          dropdownValue2 = null;
                          CardnameStr = "";
                          transfer_type = "instant";
                          cardBankValStr = "Bank";
                        });
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 80,

                            margin: EdgeInsets.only(left: 10),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Text(
                                      "Select Bank",
                                      style: TextStyle(
                                        fontFamily: "Helvetica Neue",
                                      ),
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    value: dropdownValue3,
                                    items: bankName.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: radio3 == true
                                        ? (selectedItem) {
                                      setState(() {
                                        dropdownValue3 = selectedItem;
                                        chooseCardIDStr = bankID[bankName
                                            .indexOf(selectedItem)];
                                        CardnameStr = dropdownValue3;
                                        // print(
                                        //     "chooseCardIDStr---instant---${chooseCardIDStr}");
                                      });
                                    }
                                        : null))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
    final StandardTransferCont = Container(
      margin: EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Standard Transfer",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Helvetica Neue",
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "1-3 Business Days",
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica Neue",
                    fontSize: 18,
                    color: Color(0xff707070)),
              ),
              // SizedBox(
              //   width: 130,
              // ),
              Text(
                "No Fee",
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica Neue",
                    fontSize: 20,
                    color: Color(0xff707070)),
              ),
            ],
          ),

          SizedBox(
            height: 40,
          ),
          Container(
            //  color: Colors.lightGreen,

            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Select Bank Account",
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica Neue",
                        fontSize: 18,
                        color: Color(0xff707070)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        radio1 == false
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        color: AppColor.newSignInColor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          radio2 = false;
                          radio1 = true;
                          radio3 = false;
                          CardnameStr = "";
                          dropdownValue2 = null;
                          dropdownValue3 = null;
                          transfer_type = "standard";
                          cardBankValStr = "Bank";
                        });
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 80,
                            margin: EdgeInsets.only(left: 10),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Text(
                                      "Select Bank",
                                      style: TextStyle(
                                        fontFamily: "Helvetica Neue",
                                      ),
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    value: dropdownValue,
                                    items: bankName.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: radio1 == true
                                        ? (selectedItem) {
                                      setState(() {
                                        dropdownValue = selectedItem;
                                        chooseCardIDStr = bankID[bankName
                                            .indexOf(selectedItem)];
                                        CardnameStr = dropdownValue;
                                        // print(
                                        //     "chooseCardIDStr------${chooseCardIDStr}");
                                      });
                                    }
                                        : null))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)),
            child: Text(
              "               Transfer               ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              //  transferAmntVal();
              // Navigator.of(context).pushNamed('/TransferFundBankListVC');
              CheckVal();
            },
          )
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          //  backgroundColor: AppColor.themeColor,
          flexibleSpace: Container(
            height: 100,
            child: SvgPicture.asset(
              "Assets/GreenHeader.svg",
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            "Transfer Funds",
            style: TextStyle(
              fontFamily: "Helvetica Neue",
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[InstantTranferCont,StandardTransferCont],
          ),
        ));
  }
}
