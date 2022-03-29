import 'dart:async';
import 'dart:convert';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashpot/ModelClasses/CashpotDetailData.dart';
import 'package:cashpot/ModelClasses/PotActivityDataPerUser.dart';
import 'package:cashpot/ModelClasses/UserDetailPerPot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Message.dart';
import 'ModelClasses/CardListData.dart';
import 'PotEditVC.dart';
import 'PotMenu/MembersVC.dart';
import 'PotMenu/PotActivityVC.dart';
import 'PotNotificationVC.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';
import 'package:http/http.dart' as http;

TextEditingController _AmountTF = new TextEditingController();
TextEditingController _CashoutAmountTF = new TextEditingController();

class CashpotDetailVC extends StatefulWidget {
  final String cashpotId;

  const CashpotDetailVC(this.cashpotId);

  @override
  _CashpotDetailVCState createState() => _CashpotDetailVCState();
}

class _CashpotDetailVCState extends State<CashpotDetailVC>
{
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String EnteredAddCashAmount = "";
  String EnteredRemoveCashAmount = "";
  String EnteredCashOutAmount = "";
  String UserName = "";
  String Fname = "";
  String profilePicStr = "null";
  String profilePicStrPop = "null";
  String potAmountStr = "0";
  var potAmountInt = 0;
  var amountperPerson = 0;
  String memDepositeAmnt = "";
  var potMemAmountInt = 0;
  CashpotDetailData cashpotDetailData;
  var tempData;
  double progressVal;
  List memberAry = [];
  bool _VisibltyVal = false;
  int index = 0;
  String potImageStr = "null";
  String goalAmountStr = "";
  String potMemStr = "";
  String potCreatorID = "";
  bool checkVal = false;
  CardListData cardListData;
  var bankDataTemp;
  var balanceStr = "";
  var fundiingSource = "";
  var fundingSourceCard = "";
  var bankInfo = [];
  var cardInfo = [];
  String potNameStr = "";
  String UserNameInActPopStr = "";
  String NameInActPopStr = "";
  String BalanceActPop = "0";
  String CreatorID = "";
  String UserID = "";
  PotActivityDataPerUser potActivityDataPerUser;
  var potActivityDataPerUserAry = [];
  bool addCashOptionStr = false;

  // bool checkValforSelectAll = false;
  final List<String> imgList = [
    "Assets/bankofthewest.jpg",
    "Assets/bankofthewest.jpg",
    "Assets/bankofthewest.jpg",
    "Assets/bankofthewest.jpg"
  ];
  bool checkValforSelectAll = false;
  bool checkValforSelect = false;
  Map body = {};
  String AppUserID = "";
  String profilePicStr2 = "";
  var tempDatadia;
  var memberlist = [];
  var checkValforSelectAry = [];
  String potAmontStr = "0";
  String CashpotInfoCreatorID = "";
  int _id;
  int _idForTF;
  int index2 = 0;
  List<TextEditingController> _controllers = new List();
  String checksendReq = "";

  FocusNode focusNode = FocusNode();
  String hintText = '\$0';
  String preText = '\$';
  bool radio1 = true;
  bool radio2 = false;
//
  String dropdownValue;
  String dropdownValue2;
  CardListData cardListData2;
  var bankDataTempForcashOut;
  List bankListAry = [];
  var balanceStrForCashpot = "";
  List cardListAry = [];
  var bankName = [];
  var cardName = [];
  var cardID = [];
  var bankID = [];
  String chooseBankIDStr = "";
  String chooseCardIDStr = "";
  String CardnameStr = "";
  String AmountShowToUserStr = "";

  ///For select option
  bool checkValInstantTransfer = true;
  bool checkValNoFeeTransfer = false;
  String transfer_type = "1";
  String totalAmountAfterFeePtoB = "";
  String feesPtoB = "";
  String givenAmntPtoB = "";
  String cardSelectStr = "";
  String transferOptionForCashout = "0";
bool isEnableAddCashBtn = false;
  ///Cashpot users details
  String cashpotNameUser = "";
  String caspotUserName = "";
  String cashpotUserPic = "";
  String cashpotusersAmountDepostited = "";
  String cashpotusersAmountDepostitedForCaompariasion = "";
  UserDetailPerPot userDetailPerPot;
  var userdetailperPottemp;
  String badgeStatusStr = "";
  String sendReqOptionSelect = "";
  var checkbodyforVal = [];

  //5Aug
  bool personalPotPayVal = false;
  bool cardPayVal = false;
  bool bankPay = false;
bool isCheckedBtn = false;
  ///Cashout variable 13 Aug
  int selectedIndex = null;
  List<String> transfer = [
    "Instant Transfer",
    "Standard Transfer",
    "Personal Pot"
  ];
  List<String> fee = ["1% fee", "No Fee", "No Fee"];
  List<String> daysTaken = ["Minutes", "1-3 Business Days"];

  getUserCashpotAPI2() async {
    memberlist = [];
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "cashpot_id":
          "${sharedPreferences.getString("cashpotIDforpop").toString()}",
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    print("data------------10Aug------${data}");
    setState(() {
      AppUserID = sharedPreferences.getString("UserID").toString();
    });
    //  print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    print("URL------${Webservice().apiUrlcashpot}${Webservice().cashpotinfo}");
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().cashpotinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
      setState(() {
        cashpotDetailData =
            CashpotDetailData.fromJson(json.decode(response.body));
        //  print("RES----cashpotDetailData------${cashpotDetailData.toJson()}");
        tempDatadia = cashpotDetailData.data.toJson();
        // print("tempData--------${tempDatadia}");

        potAmontStr =
            "${tempDatadia["cashpot_info"]["pot_total_amount"].toString()}";

        var potAmountInt = int.parse("${potAmontStr}");
        final oCcy = new NumberFormat("#,##0.00", "en_US");
        potAmontStr = oCcy.format(potAmountInt).toString();

        CashpotInfoCreatorID =
            tempDatadia["cashpot_info"]["creator_id"].toString();
        var memlist2 = tempDatadia["pot_activity"];
        // memberlist = tempData["pot_activity"];
        for (int i = 0; i < memlist2.length; i++) {
          if (memlist2[i]["user_id"].toString() != AppUserID) {
            setState(() {
              memberlist.add(memlist2[i]);
              checkValforSelectAry.add(false);
            });
          }
        }
        //print("sorted----------${memberlist}");
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  SendMoneyTousersAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    body["cashpot_id"] = "${sharedPreferences.getString("cashpotIDforpop").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    print('data-------vvv------$body');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    print("URL------${Webservice().apiUrlPayment}${Webservice().sendcash}");
    // debugPrint("basicAuth----- ${basicAuth}");
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().sendcash}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    print("resData*********************---->>>$resData");
    if (resData["status"] == 1)
    {
      ///This for clear data from testfields after api hit
      // checkValforSelectAll = false;
      // checkValforSelectAry = [];
      // for (int i = 0;
      // i < memberlist.length;
      // i++) {
      //   setState(() {
      //     checkValforSelectAry.add(false);
      //   });
      //   body = {};
      //   _controllers.clear();
      //   //['userArray[${index}][${'to_user_id'}]']
      // }
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context)
          {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: SvgPicture.asset(
                    "Assets/righticon.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Cash Sent",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Color(0xff707070)),
                      ),
                      SvgPicture.asset(
                        "Assets/cashsentIcon.svg",
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 4), () {Navigator.of(context).pop();});

      getUserCashpotAPI();
      getUserData();
      getbalanceAPI();
      notificationBadgeAPI();
      getUsersDetailAmountAPI();
      //getUserCashpotAPI2();
      // Utility().toast(context, "Amount sent.");
    }
    else
    {
      Navigator.pop(context);
      Utility().toast(context, resData["msg"].toString());
    }
  }

  RequestMoneyTousersAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    body["cashpot_id"] =
        "${sharedPreferences.getString("cashpotIDforpop").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    // print('data-------request------${body}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //  print("URL------${Webservice().apiUrlPayment}${Webservice().cashrequest}");
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().cashrequest}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    // print("resData-------${resData}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-----------FOR SEND reuest MONEY");

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: SvgPicture.asset(
                    "Assets/righticon.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Request Sent",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Color(0xff707070)),
                      ),
                      SvgPicture.asset(
                        "Assets/moneyrepop.svg",
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 4), () {
        Navigator.of(context).pop();
      });

      // Timer(Duration(seconds: 1), () {
      getUserCashpotAPI();
      getUserData();
      getbalanceAPI();
      getUsersDetailAmountAPI();
      // });
      //getUserCashpotAPI2();
    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  leavePotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    body["cashpot_id"] =
        "${sharedPreferences.getString("cashpotIDforpop").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    print('data-------request------${body}');

    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //    print("URL------${Webservice().apiUrlPayment}${Webservice().leavepot}");
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().leavepot}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //print("resData-------${resData}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-----------FOR SEND reuest MONEY");
      Navigator.of(context).pushReplacementNamed('/HomeVC');
      //getUserCashpotAPI2();
      Utility().toast(context, "Left successfully");
    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  notificationBadgeAPI() async {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "cashpot_id": widget.cashpotId,
      "login_id": sharedPreferences.getString("UserID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
    };
    //  print('data-------request------${body}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //    print("URL------${Webservice().apiUrlPayment}${Webservice().leavepot}");
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().getnotificationbadges}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    //Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //print("resData-------${resData}");
    if (resData["status"] == 1) {
      print("API SUCCESS-----badge_status-----");
      setState(() {
        badgeStatusStr = resData["badge_status"].toString();
      });
    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  sendAmountConfirmdialogAlert(BuildContext context, String message)
  {
    Alert(
      context: context,
      // type: AlertType.success,
      title: message,
      style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
      // desc: message,
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "YES",
            style: TextStyle(
              color: Colors.green,
              fontFamily: "Helvetica Neue",
              fontSize: 18
            ),
          ),
          onPressed: ()
          {
            Navigator.of(context, rootNavigator: true).pop();
            SendMoneyTousersAPI();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.white,
          child: Text(
            "NO",
            style: TextStyle(
              color: Colors.green,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          width: 120,
        ),
      ],
    ).show();
  }

  sendMoneyValidation()
  {
    // print("body-------_${body}");
    if (body.length != 0)
    {
      if (body.length % 3 == 0)
      {
        if (checksendReq == "send")
        {
          // print("checkbodyforVal------${checkbodyforVal}");
          sendAmountConfirmdialogAlert(context, "Are you sure you want to send money?");
        }
        else
        {
          //Call Req API.
          print("API RUN NEW Request");
          RequestMoneyTousersAPI();
        }
      } else {
        print("API RUN Stuck");
        Utility().toast(context, "Please select member and enter amount");
      }
    } else {
      Utility().toast(context, "Please select member and enter amount");
    }
  }

  ///For CashOut banklist.
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
         print("bankListAry========${bankListAry}");
         //bankListAry
        for (int i = 0; i < bankListAry.length; i++) {
          print(bankListAry[i]["bankName"]);
          bankName.add(bankListAry[i]["name"].toString());
          bankID.add(bankListAry[i]["id"].toString());

        }

         print("_bankName---${bankName}");
        //    balanceStr = bankDataTemp["balance_amount"].toString();
        cardListAry = bankDataTemp["cards"];
        for (int i = 0; i < cardListAry.length; i++) {
          //  print(cardListAry[i]["bankName"]);
          bankName.add(cardListAry[i]["bankName"].toString());
          cardID.add(cardListAry[i]["id"].toString());
        }
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  bankFeesAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {"amount": EnteredCashOutAmount, "transfer_type": transfer_type};
       print('data-------request------${data}');

    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //  print("URL------${Webservice().apiUrlPayment}${Webservice().cashrequest}");
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().feesinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    print("resData-----BANK FEES--${resData}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-----------FOR SEND reuest MONEY");
      var temp = resData["data"];
      totalAmountAfterFeePtoB = temp["total_amount"].toString();
      givenAmntPtoB = temp["given_amount"].toString();
      feesPtoB = temp["fees"].toString();
      await FeesCalDialog(context);
    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  transferPtoBAPI() async {
    // Utility().onLoading(context, true);
    var sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "amount": (int.parse(givenAmntPtoB) - 1).toString(),
      "to_funding_source": chooseCardIDStr,
      "transfer_type": transfer_type == "0"? "standard":"instant",
      "fees": "1",
      "cashpot_id": widget.cashpotId
    };
     print('data------BANK-------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().cashouttobank}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    // print("resData====BANK=====${resData}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-------TRANSFER");

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: SvgPicture.asset(
                    "Assets/righticon.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Cash Out Completed",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Color(0xff707070)),
                      ),
                      SvgPicture.asset(
                        "Assets/ThreeFourthsPot.svg",
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pop();
        getUsersDetailAmountAPI();
        _AmountTF.text = "";
        _CashoutAmountTF.text = "";
        EnteredCashOutAmount = "";
        getUserCashpotAPI();
      });
    } else {
      Utility().toast(context, "${resData["msg"].toString()}");
    }
  }

  getUsersDetailAmountAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "cashpot_id": "${widget.cashpotId}",
      "login_id": "${sharedPreferences.getString("UserID").toString()}",
      "user_id": "${sharedPreferences.getString("UserID").toString()}",
    };
    // print('data-------request------${body}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //  print("URL------${Webservice().apiUrlPayment}${Webservice().cashrequest}");
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().getuserpotamount}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //print("resData-------${resData}");
    if (resData["status"] == 1) {
      setState(() {
        userDetailPerPot =
            UserDetailPerPot.fromJson(json.decode(response.body));
        userdetailperPottemp = userDetailPerPot.data.toJson();
        cashpotNameUser = userdetailperPottemp["name"].toString();
        caspotUserName = userdetailperPottemp["username"].toString();
        cashpotUserPic = userdetailperPottemp["image"].toString();

        cashpotusersAmountDepostited =
            userdetailperPottemp["amount"].toString();
        cashpotusersAmountDepostitedForCaompariasion =
            userdetailperPottemp["amount"].toString();
        // print("cashpotusersAmountDepostited-------${cashpotusersAmountDepostited}");
//6aug
        var potAmountInty = int.parse("${cashpotusersAmountDepostited}");
        final oCcy = new NumberFormat("#,##0.00", "en_US");
        cashpotusersAmountDepostited = oCcy.format(potAmountInty).toString();
        //   print("cashpotusersAmountDepostited-------${cashpotusersAmountDepostited}");
      });
      //  print("userdetailperPottemp------${userdetailperPottemp}");

    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  Future<void> FeesCalDialog(BuildContext context) async {
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
                            "Cash Out Funds",
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
                          trailing: Text(
                            "\$${givenAmntPtoB}",
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
                            "Bank",
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
                          trailing: Text(
                            "\$${feesPtoB}",
                            style: TextStyle(
                              fontFamily: "Helvetica Neue",
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 1,
                        ),
                        ///Commented for client decline the extra hours approval
                        // ListTile(
                        //   title: Text(
                        //     "Maintenance Fee",
                        //     style: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black,
                        //         fontFamily: "Helvetica Neue"),
                        //   ),
                        //   trailing: Text(
                        //     ///Have to changes once backend done
                        //     "\$1",
                        //     style: TextStyle(
                        //       fontFamily: "Helvetica Neue",
                        //     ),
                        //   ),
                        // ),
                        // Divider(
                        //   color: Colors.black,
                        //   height: 1,
                        // ),
                        ListTile(
                          title: Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Helvetica Neue"),
                          ),
                          trailing: Text(
                            "\$${totalAmountAfterFeePtoB}",
                            style: TextStyle(
                              fontFamily: "Helvetica Neue",
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 1,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 30, right: 30),
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
                                    "               Cash Out               ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: "Helvetica Neue"),
                                  ),
                                ),
                                onTap: () {
                                  print(" Clicked");
                                  Navigator.of(context).pop();
                                  Utility().onLoading(context, true);
                                  transferPtoBAPI();
                                  // removeamntVal();
                                  //  Utility().toast(context, "Work In-Progress");

                                  //CALL API HERE
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

  ///Will be used after API hit
  cashOutSucessDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Container(
                child: SvgPicture.asset(
                  "Assets/righticon.svg",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 170,
              ),
              Container(
                margin: EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Cash Out Completed",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none,
                          color: Color(0xff707070)),
                    ),
                    SvgPicture.asset(
                      "Assets/newremovecashIcon.svg",
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              )
            ],
          );
        });
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> selectFeeOptDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: GestureDetector(
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 280, maxHeight: 380),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                  "Cashpot Fees",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: "Helvetica Neue"),
                                ),
                              ),
                              Divider(
                                height: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cashpot Fees",
                                      style: TextStyle(
                                          fontSize: 15,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                    Text(
                                      "\$1.00 Fee",
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Icon(
                                        checkValInstantTransfer == false
                                            ? Icons.radio_button_unchecked
                                            : Icons.radio_button_checked,
                                        color: AppColor.newSignInColor,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          print("CLIECLKD");
                                          transfer_type = "1";
                                          checkValNoFeeTransfer = false;
                                          checkValInstantTransfer = true;
                                        });
                                      },
                                    ),
                                    Text(
                                      "Instant Transfer \nMinutes",
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "1% Fee",
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Icon(
                                        checkValNoFeeTransfer == false
                                            ? Icons.radio_button_unchecked
                                            : Icons.radio_button_checked,
                                        color: AppColor.newSignInColor,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          print("CLIECLKD");
                                          transfer_type = "0";
                                          checkValNoFeeTransfer = true;
                                          checkValInstantTransfer = false;
                                        });
                                      },
                                    ),
                                    Text(
                                      "Standard Transfer \n1-3 Business Days",
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "No Fee",
                                      style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 30, right: 20),
                                    child: InkWell(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.newSignInColor,
                                            fontFamily: "Helvetica Neue"),
                                      ),
                                      onTap: () async {
                                        //print("Remove Clicked");
                                        //  removeamntVal();
                                        bankFeesAPI();

                                        Navigator.of(context).pop();
                                        // await selectFeeOptDialog(context);
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ))),
            );
          });
        });
  }

  //27may
  cashOutValidation() async
  {
    if (EnteredCashOutAmount == "") {
      Utility().toast(context, Message().amountEmptyMsg);
    } else if (EnteredCashOutAmount.contains(RegExp(r'^0+'))) {
      Utility().toast(context, "Please add a valid amount");
    } else if (EnteredCashOutAmount == "2") {
      Utility().toast(context, "Amount should be more than \$2");
    } else if (int.parse(EnteredCashOutAmount) > potAmountInt) {
      Utility().toast(
          context, "Amount should not be more than your deposited amount");
    } else if (int.parse(EnteredCashOutAmount) > potMemAmountInt)
    {
      Utility().toast(
          context, "Amount should not be more than your deposited amount");
    }
    ///This was previous flow of the cashout.
    ///Commented as per client suggestion with new screen.
    // else if (transferOptionForCashout == "0") {
    //   //CALL Personl pot API
    //
    //   personalWalletFeesAPI();
    // }else {
    //   //Bank Transfer API
    //   await selectFeeOptDialog(context);
    //   // Utility().toast(context, "Work In-progress.");
    // }

    else if (transferOptionForCashout == "0") {
      //CALL Personl pot API
      personalWalletFeesAPI();

    } else if (transferOptionForCashout == "2") {
      //CALL instant transfer API
      setState(() {
        transfer_type = "1";
        CardnameStr = bankListAry[0]["name"];
        chooseCardIDStr = bankListAry[0]["id"];
      });

      bankFeesAPI();
    }else {
      //Bank Transfer API
      setState(() {
        transfer_type = "0";
        CardnameStr = bankListAry[0]["name"];
        chooseCardIDStr = bankListAry[0]["id"];
      });

      bankFeesAPI();
     // await selectFeeOptDialog(context);
    }
  }

  personalWalletFeesAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {"amount": EnteredCashOutAmount};
    // print('data-------request------${body}');

    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //  print("URL------${Webservice().apiUrlPayment}${Webservice().cashrequest}");
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().feesinfopottowallet}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    // print("resData-----FEES--${resData}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-----------FOR SEND reuest MONEY");
      transferToPersonalPotCashAPI(
          resData["data"]["total_amount"].toString(), "1");
    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  transferToPersonalPotCashAPI(String amount, String fees) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": widget.cashpotId,
      "amount": amount,
      "fees": fees
    };
    // print('data------Transfer to Wallet-------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().cashouttowallet}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    // print("resData====Wallet=====${resData}");
    if (resData["status"] == 1) {
      print("API SUCCESS-------");

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: SvgPicture.asset(
                    "Assets/righticon.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Cash Out Completed",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Color(0xff707070)),
                      ),
                      SvgPicture.asset(
                        "Assets/ThreeFourthsPot.svg",
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pop();
        getUsersDetailAmountAPI();
        _AmountTF.text = "";
        _CashoutAmountTF.text = "";
        EnteredCashOutAmount = "";
        getUserCashpotAPI();
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }


  ///Cashout New UI by client's change 13 Aug
  Future<void> cashoutDialogNew(BuildContext context) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)
        {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 500, maxHeight: 520),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState)
                      {
                    return Stack(
                      children: [
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 25),
                              Text(
                                "Cash Out",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: "Helvetica Neue"),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "How much do you want to cash out?",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontFamily: "Helvetica Neue"),
                              ),
                              // SizedBox(height: 5),
                              Container(
                                //color: Colors.black26,
                                width: MediaQuery.of(context).size.width / 3,
                                // margin: EdgeInsets.only(top: 15),
                                child: TextField(
                                  controller: _CashoutAmountTF,
                                  cursorColor: AppColor.themeColor,
                                  //showCursor: false,
                                  autocorrect: false,
                                  autofocus: true,
                                  inputFormatters: [
                                    new WhitelistingTextInputFormatter(
                                        RegExp("[0-9]")),
                                  ],
                                  style: TextStyle(
                                      color: AppColor.newSignInColor,
                                      fontSize: 25,
                                      fontFamily: "Helvetica Neue",
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '\$0',
                                      hintStyle: TextStyle(
                                        color: AppColor.newSignInColor,
                                      )),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  // TextInputType.numberWithOptions(
                                  //     signed: true, decimal: true),
                                  onChanged: (string) {
                                    string =
                                        '\$${_formatNumber(string.replaceAll(',', ''))}';
                                    _CashoutAmountTF.value = TextEditingValue(
                                      text: string,
                                      selection: TextSelection.collapsed(
                                          offset: string.length),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                //margin: EdgeInsets.only(top: 20),
                                height: 100,
                                width: 85,
                                child: Container(
                                  height: 100,
                                  child: SvgPicture.asset(
                                    "Assets/newremovecashIcon.svg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: 3,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index)
                                    {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              if (selectedIndex == 0) {
                                                transferOptionForCashout = "2";
                                               // print("selectedIndex------${selectedIndex}");

                                              } else if (selectedIndex == 1) {
                                                transferOptionForCashout = "1";
                                              } else {
                                                transferOptionForCashout = "0";
                                              }
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 75,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    border: Border.all(
                                                      width: 2,
                                                        color:
                                                            selectedIndex ==
                                                                    index
                                                                ? AppColor
                                                                    .newSignInColor
                                                                : Colors
                                                                    .black54),

                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    index != 2
                                                        ? SizedBox(height: 10)
                                                        : Container(height: 0),
                                                    Text(
                                                      transfer[index],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      fee[index],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                    index != 2
                                                        ? Text(
                                                            daysTaken[index],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                          )
                                                        : Container(
                                                            height: 0,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              index == 0
                                                  ? new Positioned(
                                                      right: 2,
                                                      bottom: 0,
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.black45,
                                                        size: 21,
                                                      ))
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),

                              Container(
                                margin: EdgeInsets.only(right: 15, left: 15),
                                child: Text(
                                    "*All pots are subject to a \$1 maintenance fee.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily: "Helvetica Neue"),

                                ),
                              ) ,
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, right: 17, bottom: 8),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      child: Text(
                                        "Cash Out",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.newSignInColor,
                                            fontFamily: "Helvetica Neue"),
                                      ),
                                      onTap: () {
                                        print("CASHOUT CLICKED");
                                        Navigator.of(context).pop();
                                        if (transferOptionForCashout == "0")
                                        {
                                          EnteredCashOutAmount = _CashoutAmountTF.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
                                          cashOutValidation();
                                        }
                                        else if (transferOptionForCashout == "2")
                                        {
                                          EnteredCashOutAmount = _CashoutAmountTF.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
                                          cashOutValidation();
                                        } else {
                                          // Utility().toast(context, "Work In-progress.");
                                          EnteredCashOutAmount =
                                              _CashoutAmountTF.text.replaceAll(
                                                  new RegExp(r'[^\w\s]+'), '');
                                          cashOutValidation();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        new Positioned(
                          top: 7,
                          left: 8,
                          child: GestureDetector(
                              onTap: () {
                                _CashoutAmountTF.text = "";
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    );
                  }),
                )),
          );
        });
  }

  //Cashout API
  Future<void> cashoutDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 500, maxHeight: 530),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // child: Expanded(
                      child: SingleChildScrollView(
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
                                        _CashoutAmountTF.text = "";
                                      },
                                    ),
                                  ),
                                )),
                            Container(
                              //margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Cash Out",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: "Helvetica Neue"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "How much do you want to cash out?",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontFamily: "Helvetica Neue"),
                              ),
                            ),
                            Container(
                              //color: Colors.black26,
                              width: MediaQuery.of(context).size.width / 3,
                              margin: EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _CashoutAmountTF,
                                cursorColor: AppColor.themeColor,
                                //showCursor: false,
                                autocorrect: false,
                                autofocus: true,
                                inputFormatters: [
                                  new WhitelistingTextInputFormatter(
                                      RegExp("[0-9]")),
                                ],
                                style: TextStyle(
                                    color: AppColor.newSignInColor,
                                    fontSize: 25,
                                    fontFamily: "Helvetica Neue",
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '\$0',
                                    hintStyle: TextStyle(
                                      color: AppColor.newSignInColor,
                                    )),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                // TextInputType.numberWithOptions(
                                //     signed: true, decimal: true),
                                onChanged: (string) {
                                  string =
                                      '\$${_formatNumber(string.replaceAll(',', ''))}';
                                  _CashoutAmountTF.value = TextEditingValue(
                                    text: string,
                                    selection: TextSelection.collapsed(
                                        offset: string.length),
                                  );
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 219,
                              width: 159,
                              child: Container(
                                height: 100,
                                child: SvgPicture.asset(
                                  "Assets/newremovecashIcon.svg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.black,
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              // color: Colors.black12,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Icon(
                                                radio1 == false
                                                    ? Icons
                                                        .radio_button_unchecked
                                                    : Icons
                                                        .radio_button_checked,
                                                color: AppColor.newSignInColor,
                                                size: 30,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  print("CLIECLKD");
                                                  transferOptionForCashout =
                                                      "0";
                                                  radio2 = false;
                                                  dropdownValue = null;
                                                  radio1 = true;
                                                });
                                              },
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                RichText(
                                                  text: new TextSpan(
                                                    text: 'Personal Pot\n',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Helvetica Neue"),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text: '\$1 Cashpot Fee',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black54,
                                                            fontFamily:
                                                                "Helvetica Neue"),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 5, left: 5),
                                          child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    radio2 == false
                                                        ? Icons
                                                            .radio_button_unchecked
                                                        : Icons
                                                            .radio_button_checked,
                                                    color:
                                                        AppColor.newSignInColor,
                                                    size: 30,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      print("CLIECLKD");
                                                      transferOptionForCashout =
                                                          "1";
                                                      radio2 = true;
                                                      radio1 = false;
                                                    });
                                                  },
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  // child: Card(
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      //height: 80,
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                              hint: Text(
                                                                "Select Bank",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Helvetica Neue",
                                                                ),
                                                              ),
                                                              icon: Icon(Icons.keyboard_arrow_down),
                                                              isExpanded: true,
                                                              value: dropdownValue,
                                                              items: bankName.map((item) {
                                                                return DropdownMenuItem(
                                                                  value: item,
                                                                  child: Text(
                                                                      item),
                                                                );
                                                              }).toList(),
                                                              onChanged: radio2 == true
                                                                  ? (selectedItem) {
                                                                      setState(
                                                                          () {
                                                                        dropdownValue =
                                                                            selectedItem;
                                                                        chooseCardIDStr =
                                                                            bankID[bankName.indexOf(selectedItem)];
                                                                        CardnameStr =
                                                                            dropdownValue;
                                                                        // print(
                                                                        //     "chooseBankIDStr------${CardnameStr}");
                                                                      });
                                                                    }
                                                                  : null))),
                                                  // ),
                                                )
                                              ])))
                                ],
                              ),
                            ),
                            Divider(
                              height: 3,
                              color: Colors.black,
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(top: 15, right: 20),
                                  child: InkWell(
                                    child: Text(
                                      "Cash Out",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.newSignInColor,
                                          fontFamily: "Helvetica Neue"),
                                    ),
                                    onTap: () async {
                                      //print("Remove Clicked");
                                      //  removeamntVal();
                                      Navigator.of(context).pop();
                                      if (transferOptionForCashout == "0") {
                                        EnteredCashOutAmount =
                                            _CashoutAmountTF.text.replaceAll(
                                                new RegExp(r'[^\w\s]+'), '');
                                        cashOutValidation();
                                      } else {
                                        // Utility().toast(context, "Work In-progress.");
                                        EnteredCashOutAmount =
                                            _CashoutAmountTF.text.replaceAll(
                                                new RegExp(r'[^\w\s]+'), '');
                                        cashOutValidation();
                                      }
                                    },
                                  ),
                                )),
                          ],
                        ),
                      )),
                ),
                onTap: () {
                  print("Outer clicked");
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            );
          });
        });
  }

  //New send money dialog 13th Apr 2021
  Future<void> showInformationDialog(BuildContext context) async
  {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          final TextEditingController _textEditingController = TextEditingController();
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return GestureDetector(
              child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 420, maxHeight: 480),
                      child: SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height / 1.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          // color: Colors.white,
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
                                        onPressed: ()
                                        {
                                          print("Cross Clicked");
                                          checkValforSelectAll = false;
                                          checkValforSelectAry = [];
                                          for (int i = 0;
                                              i < memberlist.length;
                                              i++) {
                                            setState(() {
                                              checkValforSelectAry.add(false);
                                            });
                                            body = {};
                                            _controllers.clear();
                                            //['userArray[${index}][${'to_user_id'}]']
                                          }
                                          print(checkValforSelectAry);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  )),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    sendReqOptionSelect == "send"
                                        ? "Send Cash"
                                        : "Request Cash",
                                    style: TextStyle(
                                        fontFamily: "Helvetica Neue",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 25,
                                  width: MediaQuery.of(context).size.width,
                                  // color: Colors.green,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          //color: Colors.green,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "\$${cashpotusersAmountDepostited}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          "Helvetica Neue",
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.yellow,

                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                "Select All",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor
                                                        .newSignInColor),
                                              ),
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: checkValforSelectAll ==
                                                          false
                                                      ? Icon(
                                                          Icons
                                                              .check_box_outline_blank,
                                                          color: AppColor
                                                              .newSignInColor,
                                                          size: 22,
                                                        )
                                                      : Icon(
                                                          Icons.check_box,
                                                          color: AppColor
                                                              .newSignInColor,
                                                          size: 22,
                                                        ),
                                                  onPressed: () {
                                                    setState(() {
                                                      checkValforSelectAll =
                                                          !checkValforSelectAll;
                                                      checkValforSelectAry = [];
                                                      if (checkValforSelectAll ==
                                                          false) {
                                                        for (int i = 0;
                                                            i <
                                                                memberlist
                                                                    .length;
                                                            i++) {
                                                          setState(() {
                                                            checkValforSelectAry
                                                                .add(false);
                                                          });
                                                          body = {};
                                                          _controllers.clear();

                                                          //['userArray[${index}][${'to_user_id'}]']
                                                        }
                                                        //  print("body-----unSelected----${body}");
                                                      } else {
                                                        // var index = 0;
                                                        for (int i = 0;
                                                            i <
                                                                memberlist
                                                                    .length;
                                                            i++) {
                                                          // print("memberlist------${memberlist}");
                                                          setState(() {
                                                            checkValforSelectAry
                                                                .add(true);
                                                            // userArray[0][to_user_id]
                                                            if (memberlist[i][
                                                                        "user_id"]
                                                                    .toString() !=
                                                                AppUserID) {
                                                              body['userArray[${i}][${'to_user_id'}]'] =
                                                                  memberlist[i][
                                                                          "user_id"]
                                                                      .toString();
                                                              body['userArray[${i}][${'cashpot_id'}]'] =
                                                                  memberlist[i][
                                                                          "cashpot_id"]
                                                                      .toString();
                                                            }
                                                            // index++;
                                                          });
                                                        }
                                                      }
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Divider(
                                color: Colors.black,
                                height: 1,
                              ),
                              memberlist != null ?
                                memberlist.length != 0 ?
                                Container(
                                          height: 270,
                                          padding: EdgeInsets.only(left: 10),
                                          //color: Colors.green,
                                          child: ListView.builder(
                                            itemCount: memberlist.length,
                                            itemBuilder: (context, index)
                                            {
                                              _controllers.add(new TextEditingController());
                                              profilePicStr2 = memberlist[index]["image"].toString();
                                              return AppUserID != memberlist[index]["user_id"].toString()
                                                  ? ListTile(
                                                      contentPadding: EdgeInsets.only(right: 0),
                                                      title: Text(
                                                          "${memberlist[index]["name"].toString()}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily: "Helvetica Neue",
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis
                                                      ),
                                                      subtitle: RichText(
                                                        text: TextSpan(
                                                          text: "@${memberlist[index]["username"].toString()}",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: "Helvetica Neue",
                                                              fontWeight: FontWeight.w200,
                                                              color: Colors.black
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: '\n\$${memberlist[index]["amount"].toString()}.00',
                                                              style: TextStyle(
                                                                  fontFamily: "Helvetica Neue",
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: AppColor.newSignInColor
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      leading: CircleAvatar(
                                                        // backgroundColor: Colors.grey,
                                                        //radius: 20.0,
                                                        backgroundImage: profilePicStr2 == "null" ?
                                                            AssetImage('Assets/profiledummy.png')
                                                                :
                                                            NetworkImage(profilePicStr2),
                                                      ),
                                                      trailing: Container(
                                                        width: 100,
                                                        // color: Colors.grey,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                width: 50,
                                                                height: 30,
                                                                child:
                                                                    TextField(
                                                                  controller: _controllers[index],
                                                                  inputFormatters: [
                                                                    WhitelistingTextInputFormatter(RegExp("[0-9]"))],
                                                                  decoration: InputDecoration(
                                                                      prefixText: " \$",
                                                                      // border: OutlineInputBorder(),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                                                        borderSide: BorderSide(color: Colors.black26),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                                                        borderSide: BorderSide(color: Colors.black26),
                                                                      ),
                                                                      //labelText: 'Password',
                                                                      // hintText:
                                                                      //     " \$",

                                                                      contentPadding: EdgeInsets.only(
                                                                        bottom: 3, // HERE THE IMPORTANT PART
                                                                      )
                                                                  ),
                                                                  keyboardType: TextInputType.numberWithOptions(
                                                                      decimal: true,
                                                                      signed: true
                                                                  ),
                                                                  autofocus: false,
                                                                  textInputAction: TextInputAction.done,
                                                                  // readOnly: _enableTF,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily: "Helvetica Neue",
                                                                    fontSize: 14, // This is not so important
                                                                  ),
                                                                  onChanged: (val)
                                                                  {
                                                                    _idForTF = index;
                                                                    if (sendReqOptionSelect == "send")
                                                                    {
                                                                      //   print("NEWDESp------${int.parse("${cashpotusersAmountDepostited}")}");
                                                                      if (int.parse("${_controllers[index].text.toString()}") > int.parse("$cashpotusersAmountDepostitedForCaompariasion"))
                                                                      {
                                                                        //  Utility().toast(context, "Cannot request amount more than amount per serson");
                                                                        Utility().errorToastForRequest(context, "you have insuffifient balance in the pot");
                                                                        Timer(Duration(seconds: 1), ()
                                                                        {
                                                                          print("Yeah, this line is printed after 3 seconds");
                                                                          setState(()
                                                                              {
                                                                            // _controllers[index].clear();
                                                                            _controllers[index].text = "";
                                                                          });
                                                                        });
                                                                      }
                                                                      else if (_controllers[index].text.contains(RegExp(r'^0+')))
                                                                        Utility().errorToastForRequest(context, "Enter a valid amount");
                                                                      else
                                                                        body['userArray[$_idForTF][${'amount'}]'] = val;
                                                                    }
                                                                    else
                                                                    {
                                                                      if (_controllers[index].text.contains(RegExp(r'^0+')))
                                                                        Utility().errorToastForRequest(context, "Enter a valid amount");
                                                                      else
                                                                        body['userArray[$_idForTF][${'amount'}]'] = val;
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(
                                                                padding: EdgeInsets.zero,
                                                                icon: checkValforSelectAry[index] == false ?
                                                                Icon(
                                                                    Icons.check_box_outline_blank,
                                                                    color: AppColor.newSignInColor,
                                                                    size: 22
                                                                )
                                                                    :
                                                                Icon(
                                                                  Icons.check_box,
                                                                  color: AppColor.newSignInColor,
                                                                  size: 22
                                                                ),
                                                                onPressed: ()
                                                                {
                                                                  setState(()
                                                                  {
                                                                    checkValforSelectAry[index] = !checkValforSelectAry[index];
                                                                    _id = index;
                                                                    //if you want to assign the index somewhere to check
                                                                    if (checkValforSelectAry[index] == false)
                                                                    {
//                                              setState(() {
//                                                checkValforSelectAry.insert(_id, false);
//                                              });
                                                                      body.remove(
                                                                          'userArray[${_id}][${'to_user_id'}]');
                                                                      body.remove(
                                                                          'userArray[${_id}][${'cashpot_id'}]');
                                                                      body.remove(
                                                                          'userArray[${_id}][${'amount'}]');
                                                                      _controllers[
                                                                              _id]
                                                                          .text = "";
                                                                      //  print("body----Single-unSelected----${body}");

                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        //  checkValforSelectAry.insert(_id, true);
                                                                        body['userArray[${_id}][${'to_user_id'}]'] =
                                                                            memberlist[_id]["user_id"].toString();
                                                                        body['userArray[${_id}][${'cashpot_id'}]'] =
                                                                            memberlist[_id]["cashpot_id"].toString();
                                                                        body['userArray[${_id}][${'amount'}]'] =
                                                                            _controllers[_id].text;
                                                                        //index2++;
                                                                      });
                                                                      // print("body-----selected----${body}");

                                                                      // print("index1------${index1}");
                                                                    }
                                                                  });
                                                                  //  print("SELECT ALL CLICKED....${_id}");
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            },
                                          )
                              )
                                        :
                                Container(
                                          height: 270,
                                          child: Center(
                                            child: Text(
                                              "No member",
                                              style: TextStyle(
                                                  fontFamily: "Helvetica Neue",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        )
                                  :
                              Container(height: 270),
                              Divider(height: 1, color: Colors.black),
                              Container(
                                // color: Colors.grey,
                                height: 50,
                                child: Row(
                                  children: <Widget>[
                                    sendReqOptionSelect == "send" ?
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                              // color: Colors.red,
                                        height: 30,
                                        child: Center(
                                          child: RaisedButton(
                                            color: AppColor.newSignInColor,
                                            shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18.0),
                                                      side: BorderSide(color: AppColor.newSignInColor)
                                            ),
                                                  child: Text(
                                                    "     Send     ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Helvetica Neue",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  onPressed: ()
                                                  {
                                                    setState(() {checksendReq = "send";});
                                                    Navigator.pop(context);
                                                    sendMoneyValidation();
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            flex: 5,
                                            child: Container(
                                              //  color: Colors.black,
                                              height: 30,
                                              child: Center(
                                                child: RaisedButton(
                                                  color:
                                                      AppColor.newSignInColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: AppColor
                                                              .newSignInColor)),
                                                  child: Text(
                                                    "   Request   ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Helvetica Neue",
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      checksendReq = "request";
                                                    });
                                                    Navigator.pop(context);
                                                    sendMoneyValidation();
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ))),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            );
          });
        });
  }

  dialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      // type: AlertType.success,
      title: message,
      style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
      // desc: message,
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "YES",
            style: TextStyle(
              color: Colors.green,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            if (personalPotPayVal == true) {
              //PAY WITH PERSONAL WALLET
              print("PERSONAL WALLET");
              payWithPersonalWalletToPotAPI();
            }
            if (cardPayVal == true || bankPay == true) {
              payToCashpotAPI();
            }
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.white,
          child: Text(
            "NO",
            style: TextStyle(
              color: Colors.green,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          width: 120,
        ),
      ],
    ).show();
  }

  amountValidation() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (EnteredAddCashAmount == "") {
      Utility().toast(context, "Add Amount");
    } else if (EnteredAddCashAmount.contains(RegExp(r'^0+'))) {
      Utility().toast(context, "Please add a valid amount");
    }
    //As per client requirement
    // else if (int.parse("${tempData["goal_amount"].toString()}") != 0 && int.parse("${tempData["goal_amount"].toString()}") <
    //     (potAmountInt + int.parse("${EnteredAddCashAmount}"))) {
    //   Utility().toast(context, "Amount should be less than the goal amount");
    // } else if (int.parse("${EnteredAddCashAmount}") > amountperPerson && amountperPerson != 0) {
    //   Utility().toast(context, "Amount should not more than amount per person");
    // }
    else {
      dialogAlert(context,
          "Are you sure you want to add \$${EnteredAddCashAmount} to pot?");
    }
  }

  payToCashpotAPI() async {
    String finalfundingSrc = "";
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (cardPayVal == true) {
      finalfundingSrc = fundingSourceCard;
      //  print("from card------${finalfundingSrc}");
    } else {
      finalfundingSrc = fundiingSource;
      //  print("from bank------${finalfundingSrc}");
    }
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": "${widget.cashpotId}",
      "from_funding_source": fundiingSource,
      "amount": EnteredAddCashAmount,
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().usertocashpot}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //print("bankListAry=========${bankListAry}");
    if (resData["status"] == 1) {
      // print("API SUCCESS-------${cardListData.toJson()}");

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: SvgPicture.asset(
                    "Assets/righticon.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                            10.0) //                 <--- border radius here
                        ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Cash Has Been Added",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Color(0xff707070)),
                      ),
                      SvgPicture.asset(
                        "Assets/addcash.svg",
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 3), () async {
        Navigator.of(context).pop();
        getUsersDetailAmountAPI();
        _AmountTF.text = "";
        EnteredAddCashAmount = "";
        await getUserCashpotAPI();
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  payWithPersonalWalletToPotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": "${widget.cashpotId}",
      "amount": EnteredAddCashAmount,
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().wallettopot}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    //print("bankListAry=========${bankListAry}");
    if (resData["status"] == 1) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: SvgPicture.asset(
                    "Assets/righticon.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                            10.0) //                 <--- border radius here
                        ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Cash Has Been Added",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Color(0xff707070)),
                      ),
                      SvgPicture.asset(
                        "Assets/addcash.svg",
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pop();
        getUsersDetailAmountAPI();
        _AmountTF.text = "";
        addCashOptionStr = false;
        EnteredAddCashAmount = "";
        getUserCashpotAPI();
        getbalanceAPI();
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  getbalanceAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    // print('data-----getbalanceAPI--------${data}');
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
//print("cardListData--------${cardListData.toJson()}");
        bankDataTemp = cardListData.data.toJson();
        balanceStr = "${bankDataTemp["balance_amount"].toString()}";

        var potAmountIntgy = int.parse("${balanceStr}");
        final oCcy = new NumberFormat("#,##0.00", "en_US");
        balanceStr = oCcy.format(potAmountIntgy).toString();
        bankInfo = bankDataTemp["banks"];
        if (bankInfo.length != 0) {
          fundiingSource = bankDataTemp["banks"][0]["id"].toString();
        }
//print("bankInfo=========${bankInfo}");
        cardInfo = bankDataTemp["cards"];
        if (cardInfo.length != 0) {
          fundingSourceCard = bankDataTemp["cards"][0]["id"].toString();
        }
        // print("cardInfo=======${cardInfo}");

        //  print("fundiingSource-----${fundiingSource}");
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  endPotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": widget.cashpotId
    };
    //   print('data-------------${data}');
    // print("${Webservice().apiUrlPayment}${Webservice().endPot}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().endPot}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    // print("resData=========${resData}");
    if (resData["status"] == 1) {
      print("API SUCCESS-------END POT}");
      Navigator.of(context).pushReplacementNamed('/HomeVC');
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  getUserCashpotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("cashpotIDforpop", widget.cashpotId);
    UserID = sharedPreferences.getString("UserID").toString();
    Map data = {
      "cashpot_id": "${widget.cashpotId}",
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------getUserCashpotAPI------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth------${basicAuth}");
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().cashpotinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
      setState(() {
        cashpotDetailData =
            CashpotDetailData.fromJson(json.decode(response.body));
        //   print("RES----cashpotDetailData------${cashpotDetailData.toJson()}");
        tempData = cashpotDetailData.data.cashpotInfo.toJson();
        // print("RES----cashpotDetailData------${tempData}");

        potAmountStr = "${tempData["pot_total_amount"].toString()}";

        var potAmountInt1 = int.parse("${potAmountStr}");
        final oCcy = new NumberFormat("#,##0.00", "en_US");
        potAmountStr = oCcy.format(potAmountInt1).toString();

        potAmountInt = int.parse("${tempData["pot_total_amount"]}");
        potImageStr = tempData["potImage"].toString().toString();
        goalAmountStr = "${tempData["goal_amount"].toString()}";
        var potAmountInt2 = int.parse("${goalAmountStr}");
        final oCcy1 = new NumberFormat("#,##0.00", "en_US");
        goalAmountStr = oCcy1.format(potAmountInt2).toString();

        potMemStr = tempData["pot_members_count"].toString();
        AmountShowToUserStr = tempData["is_amount_shown"].toString();
        amountperPerson = int.parse("${tempData["amount_per_person"]}");
        var tempdata2 = cashpotDetailData.data.toJson();
        memberAry = tempdata2["pot_activity"];
        progressVal = double.parse("${tempData["cashpot_progress"]}") / 100;
        potNameStr = tempData["pot_name"].toString();
        CreatorID = tempData["creator_id"].toString();
        // print("memberAry--------${CreatorID}  ${UserID}");
      });
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }
  openNotificationCashpotAPI(String cashpot_id) async {
   // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": cashpot_id
    };
    // print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().opennotifications}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES=====yyy====${json.decode(response.body) as Map}");
   // Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
      print("API SUCCESS-------OPEN NOTI");
      _getRequests();
    } else {
//Commented for SHivam side
      // Utility().toast(context, "${resData["msg"]}");
    }
  }
  _getRequests() async {
    print("_getRequests_getRequests");
    EnteredAddCashAmount = "";
    getUserCashpotAPI();
    getUserData();
    getbalanceAPI();
    getUserCashpotAPI2();
    notificationBadgeAPI();
  }

  @override
  void initState() {
    // TODO: implement initState
    EnteredAddCashAmount = "";
    Future.delayed(Duration.zero, () {
      getUsersDetailAmountAPI();
      getUserCashpotAPI();
      notificationBadgeAPI();
      getUserData();
      getbalanceAPI();
      getbankListAPI();
      getUserCashpotAPI2();
    });

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //executes after build is done
      setState(() {
        UserName = sharedPreferences.getString("UserName");
        Fname = sharedPreferences.getString("Fname");
        if (sharedPreferences.getString("profileImage") != null) {
          profilePicStr =
              sharedPreferences.getString("profileImage").toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersActivityDialog = Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Expanded(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              ListTile(
                leading: CircleAvatar(
                  // backgroundColor: Colors.grey,
                  radius: 25.0,
                  backgroundImage: profilePicStr == "null"
                      ? AssetImage('Assets/profiledummy.png')
                      : NetworkImage(profilePicStr),
                ),
                title: Text("${NameInActPopStr}"),
                subtitle: Text("${UserNameInActPopStr}"),
                trailing: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Text(
                      "\$$BalanceActPop",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Helvetica Neue",
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: potActivityDataPerUserAry.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "Cashed out \$250",
                        style: TextStyle(
                          fontFamily: "Helvetica Neue",
                        ),
                      ),
                      //subtitle: Text("@AnnieHalls"),
                      //AssetImage('Assets/Group1112.png')
                      leading: SvgPicture.asset("Assets/potmoneyIcon.svg"),
                      trailing: Text(
                        "1 h",
                        style: TextStyle(
                          fontFamily: "Helvetica Neue",
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    child: Text(
                      "Close",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Helvetica Neue",
                          fontWeight: FontWeight.bold,
                          color: AppColor.newSignInColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
    getUsersActivityPotAPI(String cashpotID, String SelectedUserID) async {
      var balStr = "0";
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map data = {
        "user_id": SelectedUserID,
        // sharedPreferences.getString("UserID").toString(),
        "login_id": sharedPreferences.getString("UserID").toString(),
        "cashpot_id": cashpotID
      };
      //   print('data-------------${data}');
      String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
      var response = await http.post(
          "${Webservice().apiUrlcashpot}${Webservice().getuserpotactivitylog}",
          body: data,
          headers: <String, String>{
            'authorization': basicAuth,
          });
      // print("RES====list=====${json.decode(response.body) as Map}");
      Utility().onLoading(context, false);
      Map resData = json.decode(response.body) as Map;
      //  print("resData=========${resData}");
      if (resData["status"] == 1) {
        //  print("API SUCCESS--------");
        setState(() {
          potActivityDataPerUser =
              PotActivityDataPerUser.fromJson(json.decode(response.body));
          var tempdata = potActivityDataPerUser.toJson();
          potActivityDataPerUserAry = tempdata["data"]["pot_activity"];
          // balStr = tempdata["data"]["total_amount"].toString() == "null"
          //     ? "0.00"
          //     : "${tempdata["data"]["total_amount"].toString()}.00";
          balStr = tempdata["data"]["total_amount"].toString();
          var potAmountIntnew = int.parse("${balStr}");
          final oCcy = new NumberFormat("#,##0.00", "en_US");
          balStr = oCcy.format(potAmountIntnew).toString();
        //  print("balStr---------${balStr}");
        });
        print("potActivityDataPerUser--30 dec--${potActivityDataPerUser.toJson()}");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //  child: Expanded(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            // backgroundColor: Colors.grey,
                            radius: 25.0,
                            backgroundImage: profilePicStrPop == "null"
                                ? AssetImage('Assets/profiledummy.png')
                                : NetworkImage(profilePicStrPop),
                          ),
                          title: Text(
                            "${NameInActPopStr}",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Helvetica Neue",
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "${UserNameInActPopStr}",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Helvetica Neue",
                              // fontWeight: FontWeight.w200
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Container(
                            height: 50,
                            width: 80,
                            child: Center(
                              child: Text(
                                "\$$balStr",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Helvetica Neue",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: potActivityDataPerUserAry.length,
                            itemBuilder: (context, index) {
                              String balanceStr =
                                  potActivityDataPerUserAry[index]['amount']
                                      .toString();
                              var potAmountInttt = int.parse("${balanceStr}");
                              final oCcy =
                                  new NumberFormat("#,##0.00", "en_US");
                              balanceStr =
                                  oCcy.format(potAmountInttt).toString();
                              return ListTile(
                                title: potActivityDataPerUserAry[index]
                                            ['message'] ==
                                        "Removed"
                                    ?
                                    // Text("${potActivityDataPerUserAry[index]['message']} \$${potActivityDataPerUserAry[index]['amount']}")
                                    RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                    '${potActivityDataPerUserAry[index]['message']} ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontWeight:
                                                        FontWeight.bold
                                                )
                                            ),
                                            new TextSpan(
                                                text:
                                                    //'\$${potActivityDataPerUserAry[index]['amount']}.00',
                                                    "\$${balanceStr}",

                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      )
                                    :
                                    //  Text("${potActivityDataPerUserAry[index]['message']} \$${potActivityDataPerUserAry[index]['amount']}"),
                                  ///SAGAR
                                    RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                    '${potActivityDataPerUserAry[index]['message']} ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontWeight:
                                                        FontWeight.bold)

                                            ),
                                            new TextSpan(
                                                text:
                                                    // '\$${potActivityDataPerUserAry[index]['amount']}.00',
                                                potActivityDataPerUserAry[index]['message'] == "Added"||potActivityDataPerUserAry[index]['message'] =="Cash out"?
                                                "\$${balanceStr}":"",

                                                // potActivityDataPerUserAry[index]['message'] == "Cash out"?
                                                // "\$${balanceStr}":"",
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    color: AppColor
                                                        .newSignInColor)),
                                          ],
                                        ),
                                      ),
                                leading:
                                    SvgPicture.asset("Assets/potmoneyIcon.svg"),
                                trailing: Text(
                                  "${potActivityDataPerUserAry[index]['time_difference']}",
                                  style: TextStyle(
                                    fontFamily: "Helvetica Neue",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FlatButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Helvetica Neue",
                                    color: AppColor.newSignInColor),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    //   ),
                  ),
                );
              });
            });
      } else {
        print("API FAILED--------");
        Utility().toast(context, "Something went wrong");
      }
    }

    removeCashAPI() async {
      // Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map data = {
        "user_id": sharedPreferences.getString("UserID").toString(),
        "login_id": sharedPreferences.getString("UserID").toString(),
        "cashpot_id": widget.cashpotId,
        "amount": EnteredRemoveCashAmount
      };
      // print('data-------------${data}');
      String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
      var response = await http.post(
          "${Webservice().apiUrlPayment}${Webservice().removeCash}",
          body: data,
          headers: <String, String>{
            'authorization': basicAuth,
          });
      // print("RES====list=====${json.decode(response.body) as Map}");
      Utility().onLoading(context, false);
      Map resData = json.decode(response.body) as Map;

      //print("bankListAry=========${bankListAry}");
      if (resData["status"] == 1) {
        print("API SUCCESS-------");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                    child: SvgPicture.asset(
                      "Assets/righticon.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Cash Has Been Removed",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                              color: Color(0xff707070)),
                        ),
                        SvgPicture.asset(
                          "Assets/delCashIcon.svg",
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pop();
          getUsersDetailAmountAPI();
          _AmountTF.text = "";
          EnteredRemoveCashAmount = "";
          _AmountTF.text = "";
          getUserCashpotAPI();
        });
      } else {
        Utility().toast(context, "Something went wrong");
      }
    }

    removeamntVal() {
      print(EnteredRemoveCashAmount);
      //print("potAmountInt======${potAmountInt}");
      if (EnteredRemoveCashAmount == "") {
        Utility().toast(context, Message().amountEmptyMsg);
      } else if (EnteredRemoveCashAmount.contains(RegExp(r'^0+'))) {
        Utility().toast(context, "Please add a valid amount");
      } else if (int.parse(EnteredRemoveCashAmount) > potAmountInt) {
        Utility().toast(
            context, "Amount should not be more than your deposited amount");
      } else if (int.parse(EnteredRemoveCashAmount) > potMemAmountInt) {
        Utility().toast(
            context, "Amount should not be more than your deposited amount");
      } else {
        // Utility().onLoading(context, false);
        Utility().onLoading(context, true);
        removeCashAPI();
      }
    }

    final removeCashDialog = Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500, maxHeight: 520),
            child: Container(
                // height: MediaQuery.of(context).size.height / 1.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // child: Expanded(
                child: SingleChildScrollView(
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
                                  _AmountTF.text = "";
                                  EnteredRemoveCashAmount = "";
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )),
                      Container(
                        //margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "Remove Cash",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Helvetica Neue"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "How much do you want to remove?",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontFamily: "Helvetica Neue"),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        margin: EdgeInsets.only(top: 15),
                        child: TextField(
                          controller: _AmountTF,
                          cursorColor: AppColor.themeColor,
                          autocorrect: false,
                          autofocus: true,
                          inputFormatters: [
                            new WhitelistingTextInputFormatter(RegExp("[0-9]")),
                          ],
                          style: TextStyle(
                              color: AppColor.newSignInColor,
                              fontSize: 25,
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // prefixText: "\$",
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(31.0)),
                              //   borderSide: BorderSide(
                              //       width: 3, color: AppColor.newSignInColor),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(31.0)),
                              //   borderSide: BorderSide(
                              //       width: 3, color: AppColor.newSignInColor),
                              // ),
                              hintText: '\$0',
                              hintStyle: TextStyle(
                                color: AppColor.newSignInColor,
                                fontFamily: "Helvetica Neue",
                              )),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          // keyboardType: TextInputType.numberWithOptions(
                          //     signed: true, decimal: true),
                          onChanged: (string) {
                            string =
                                '\$${_formatNumber(string.replaceAll(',', ''))}';
                            _AmountTF.value = TextEditingValue(
                              text: string,
                              selection: TextSelection.collapsed(
                                  offset: string.length),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 219,
                        width: 159,
                        child: Container(
                          height: 100,
                          child: SvgPicture.asset(
                            "Assets/newremovecashIcon.svg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                        child: Text(
                          "Cash will be removed from pot but you will remain in the pot.",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontFamily: "Helvetica Neue"),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: InkWell(
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.newSignInColor,
                                    fontFamily: "Helvetica Neue"),
                              ),
                              onTap: () {
                                //print("Remove Clicked");
                                Navigator.of(context).pop();

                                EnteredRemoveCashAmount = _AmountTF.text
                                    .replaceAll(new RegExp(r'[^\w\s]+'), '');
                                removeamntVal();
                              },
                            ),
                          )),
                    ],
                  ),
                ))),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );

    final endPotDialog = Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height / 3.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                "End Pot",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: "Helvetica Neue",
                    color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Are you sure you want to end this pot?",
                  style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.r,
                      decoration: TextDecoration.none,
                      fontFamily: "Helvetica Neue",
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "(All members cash will return to their personal pot)",
                  style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.r,
                      fontFamily: "Helvetica Neue",
                      decoration: TextDecoration.none,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "YES",
                      style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.r,
                          fontFamily: "Helvetica Neue",
                          decoration: TextDecoration.none,
                          color: AppColor.newSignInColor),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      print("YES clicked");
                      Navigator.of(context).pop();
                      endPotAPI();
                    },
                  ),
                  InkWell(
                    child: Text(
                      "NO",
                      style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.r,
                          fontFamily: "Helvetica Neue",
                          decoration: TextDecoration.none,
                          color: AppColor.newSignInColor),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      print("NO clicked");
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ],
          ),
        ));

    final leavePotDialog = Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height / 3.7,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                "Leave Pot",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: "Helvetica Neue",
                    color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Are you sure you want to leave the current pot?",
                  style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.r,
                      fontFamily: "Helvetica Neue",
                      decoration: TextDecoration.none,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "(All cash will return to personal pot)",
                  style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.r,
                      fontFamily: "Helvetica Neue",
                      decoration: TextDecoration.none,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "YES",
                      style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.r,
                          fontFamily: "Helvetica Neue",
                          decoration: TextDecoration.none,
                          color: AppColor.newSignInColor),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      print("Leave pot clicked");

                      Navigator.of(context).pop();
                      await leavePotAPI();
                      // Utility().toast(context, "Work In-progress");
                    },
                  ),
                  InkWell(
                    child: Text(
                      "NO",
                      style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.r,
                          fontFamily: "Helvetica Neue",
                          decoration: TextDecoration.none,
                          color: AppColor.newSignInColor),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      print("NO clicked");
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ],
          ),
        ));
    Drawer _buildDrawer(BuildContext context)
    {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    UserID == CreatorID ? "Creator Options" : "Options",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Helvetica Neue",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  new CircleAvatar(
                    radius: 35.0,
                    // backgroundColor: Colors.grey,
                    backgroundImage: cashpotUserPic == "null"
                        ? AssetImage('Assets/profiledummy.png')
                        : NetworkImage(cashpotUserPic),
                  ),
                  Text(
                    "$cashpotNameUser",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@$caspotUserName",
                    style: TextStyle(
                        color: Colors.black45,
                        fontFamily: "Helvetica Neue",
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 5, top: 15),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "\$${cashpotusersAmountDepostited}",
                              style: TextStyle(
                                  fontFamily: "Helvetica Neue",
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              left: 10, bottom: 5, top: 15, right: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontFamily: "Helvetica Neue",
                                    color: AppColor.newSignInColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Cash Out',
                                      //style: linkStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Navigator.pop(context);
                                          //  await cashoutDialog(context);
                                          await cashoutDialogNew(context);
                                        }),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  )
                ],
              ),
              onTap: () {
                //print("Clicked Profile");
                Navigator.of(context).pop();
                //   Navigator.of(context).pushNamed('/ProfileVC');
              },
            ),
            SizedBox(
              height: 10,
            ),
            UserID == CreatorID
                ? ListTile(
                    leading: SvgPicture.asset(
                      "Assets/grouppeo.svg",
                      fit: BoxFit.fill,
                      height: 28,
                      width: 33,
                    ),
                    title: Text(
                      'Members',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: "Helvetica Neue",
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(
                            new MaterialPageRoute(
                                builder: (_) => MembersVC(
                                      "${widget.cashpotId}",
                                      "${CreatorID}",
                                    )),
                          )
                          .then((val) => val ? _getRequests() : null);
                    },
                  )
                : Container(),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: SvgPicture.asset(
                "Assets/assis.svg",
                fit: BoxFit.fill,
                height: 35,
                width: 35,
              ),
              title: Text(
                'Pot Detail',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.of(context).pop();
                //   Navigator.of(context).pushNamed('/AddedEventListVC');

                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => PotEditVC(
                //           "${widget.cashpotId}",
                //           "${CreatorID}",
                //         )));

                Navigator.of(context)
                    .push(
                      new MaterialPageRoute(
                          builder: (_) => PotEditVC(
                                "${widget.cashpotId}",
                                "${CreatorID}",
                              )),
                    )
                    .then((val) => val ? _getRequests() : null);
              },
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: new Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    "Assets/bellpot.svg",
                    fit: BoxFit.fill,
                    height: 35,
                    width: 35,
                  ),
                  new Positioned(
                    right: 2,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: badgeStatusStr == "1"
                            ? Colors.red
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                    ),
                  )
                ],
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                //widget.changeScreen(1);
                Navigator.of(context).pop();
                // Navigator.of(context).pushNamed('/PotNotificationVC');

                Navigator.of(context)
                    .push(
                      new MaterialPageRoute(
                          builder: (_) => PotNotificationVC(
                              "${widget.cashpotId}",
                              "${cashpotusersAmountDepostitedForCaompariasion}")),
                    )
                    .then((val) => val ? openNotificationCashpotAPI(widget.cashpotId) : null);
              },
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: SvgPicture.asset(
                "Assets/wavemoney.svg",
                fit: BoxFit.fill,
                height: 35,
                width: 35,
              ),
              title: Text(
                'Pot Activity',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.of(context).pop();
                //  Navigator.of(context).pushNamed('/PotActivityVC');

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PotActivityVC(
                          "${widget.cashpotId}",
                        )));
              },
            ),

            ///Removed cash feature by client requirement
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //   leading: SvgPicture.asset(
            //     "Assets/del.svg",
            //     fit: BoxFit.fill,
            //     height: 33,
            //     width: 26,
            //   ),
            //   title: Text(
            //     'Remove Cash',
            //     style: TextStyle(
            //         fontSize: 18.0,
            //         fontFamily: "Helvetica Neue",
            //         color: Colors.black,
            //         fontWeight: FontWeight.w300),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     //Navigator.of(context).pushNamed('/SettingsVC');
            //     showDialog(
            //         barrierDismissible: false,
            //         context: context,
            //         builder: (BuildContext context) {
            //           return removeCashDialog;
            //         });
            //   },
            // ),
            SizedBox(
              height: 60,
            ),
            UserID == CreatorID
                ? ListTile(
                    leading: SvgPicture.asset(
                      "Assets/endpot.svg",
                      fit: BoxFit.fill,
                      height: 28.5,
                      width: 28.5,
                    ),
                    title: Text(
                      'End Pot',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: "Helvetica Neue",
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return endPotDialog;
                          });
                    },
                  )
                : ListTile(
                    leading: SvgPicture.asset(
                      "Assets/endpot.svg",
                      fit: BoxFit.fill,
                      height: 28.5,
                      width: 28.5,
                    ),
                    title: Text(
                      'Leave Pot',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Helvetica Neue",
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Utility().toast(context, "Work In-progress");
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return leavePotDialog;
                          });
                    },
                  ),
          ],
        ),
      );
    }

    payWithPersonalPotValidation() {
      FocusScope.of(context).requestFocus(FocusNode());
      print(int.parse("${tempData["goal_amount"].toString()}"));
      if (EnteredAddCashAmount.isEmpty) {
        Utility().toast(context, "Add Amount");
      } else if (EnteredAddCashAmount.contains(RegExp(r'^0+'))) {
        Utility().toast(context, "Please add a valid amount");
      }
      // else if (int.parse("${tempData["goal_amount"].toString()}") != 0 && int.parse("${tempData["goal_amount"].toString()}") <
      //     (potAmountInt + int.parse("${EnteredAddCashAmount.toString()}"))) {
      //   Utility().toast(context, "Amount should be less than the goal amount");
      // }
      else if (int.parse("${EnteredAddCashAmount.toString()}") >
          int.parse("${bankDataTemp["balance_amount"].toString()}")) {
        Utility().toast(context, "Insufficient balance in your wallet");
      }
      // else if (int.parse("${EnteredAddCashAmount.toString()}") > amountperPerson && amountperPerson != 0) {
      //   Utility()
      //       .toast(context, "Amount should not more than amount per person");
      // }
      else {
        dialogAlert(context,
            "Are you sure you want to add \$${EnteredAddCashAmount} to pot?");
      }
    } //balanceStr

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(4.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.cover, width: 500.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 20.0),
                            child: Text(
                              'Bank of the West',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Helvetica Neue",
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();


    Future<void> AddCashDialogNew(BuildContext context) async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 400, maxHeight: 450),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height:  MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
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
                                          _AmountTF.text = "";
                                          EnteredAddCashAmount = "";
                                          addCashOptionStr = false;
                                           personalPotPayVal = false;
                                           cardPayVal = false;
                                           bankPay = false;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  )),
                              Container(
                                //margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Add Cash",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Enter Amount:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Helvetica Neue",
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        controller: _AmountTF,
                                        cursorColor: AppColor.themeColor,
                                        autofocus: true,
                                        autocorrect: false,
                                        inputFormatters: [
                                          new WhitelistingTextInputFormatter(
                                              RegExp("[0-9]")),
                                        ],
                                        style: TextStyle(
                                            color: AppColor.newSignInColor,
                                            fontSize: 25,
                                            fontFamily: "Helvetica Neue",
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "\$0",
                                            hintStyle: TextStyle(
                                              color: AppColor.newSignInColor,
                                            )),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        // keyboardType: TextInputType.numberWithOptions(
                                        //     signed: true, decimal: true),
                                        onChanged: (string) {


                                          print(_AmountTF.text);
                                          if(_AmountTF.text.length == 0){
                                            print("testttt");

                                            setState(() {
                                              _AmountTF.text = "";
                                            });

                                          }else{

                                            string =
                                            '\$${_formatNumber(string.replaceAll(',', ''))}';
                                            _AmountTF.value = TextEditingValue(
                                              text: string,
                                              selection: TextSelection.collapsed(
                                                  offset: string.length),
                                            );
                                            setState(() {
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(flex: 1, child: Container())
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                height: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          child: Container(
                                              //color: Colors.blue,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // border: Border.all(color: Colors.black54, width: 0.8),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: personalPotPayVal ==
                                                            true
                                                        ? AppColor
                                                            .newSignInColor
                                                            .withOpacity(0.8)
                                                        : Colors.grey
                                                            .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(0,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    child: SvgPicture.asset(
                                                      "Assets/leftMenu/addCashNewIcon.svg",
                                                    ),
                                                  ),
                                                  Text(
                                                    "Personal Pot",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Helvetica Neue",
                                                    ),
                                                  )
                                                ],
                                              )),
                                          onTap: () {
                                            print("CLiecked Personal");
                                            setState(() {
                                              isCheckedBtn = true;
                                              personalPotPayVal = true;
                                              cardPayVal = false;
                                              bankPay = false;
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          child: Container(
                                              //color: Colors.blue,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // border: Border.all(color: Colors.black54, width: 0.8),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: cardPayVal == true
                                                        ? AppColor
                                                            .newSignInColor
                                                            .withOpacity(0.8)
                                                        : Colors.grey
                                                            .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(0,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    child: SvgPicture.asset(
                                                      "Assets/leftMenu/addCardNewIcon.svg",
                                                    ),
                                                  ),
                                                  Text(
                                                    "Card",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Helvetica Neue",
                                                    ),
                                                  )
                                                ],
                                              )),
                                          onTap: () {
                                            setState(() {
                                              if (fundingSourceCard != "") {
                                                // print(
                                                //     "fundingSourceCard=====  ${fundingSourceCard}");
                                                isCheckedBtn = true;
                                                personalPotPayVal = false;
                                                cardPayVal = true;
                                                bankPay = false;
                                              } else {
                                                Utility().toast(
                                                    context, "Card not added.");
                                              }
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          child: Container(
                                            //color: Colors.blue,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // border: Border.all(color: Colors.black54, width: 0.8),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: bankPay == true
                                                      ? AppColor.newSignInColor
                                                          .withOpacity(0.8)
                                                      : Colors.grey
                                                          .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: SvgPicture.asset(
                                                    "Assets/leftMenu/addBankNewIcon.svg",
                                                  ),
                                                ),
                                                Text(
                                                  "Bank Account",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (fundiingSource != "") {
                                                // print(
                                                //     "fundiingSource-------Bank-------${fundiingSource}");
                                                isCheckedBtn = true;
                                                personalPotPayVal = false;
                                                cardPayVal = false;
                                                bankPay = true;
                                              } else {
                                                Utility().toast(context,
                                                    "Bank account not added.");
                                              }
                                            });
                                          },
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              RaisedButton(
                                  color: (_AmountTF.text.length != 0 && (isCheckedBtn == true)) == false ? Colors.grey[200]: AppColor.newSignInColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      // side: BorderSide(
                                      //     color: AppColor.newSignInColor)
                                  ),
                                  child: Text(
                                    "               Add               ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Helvetica Neue",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (personalPotPayVal == true) {
                                      EnteredAddCashAmount = _AmountTF.text
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '');
                                      payWithPersonalPotValidation();
                                    }
                                    if (cardPayVal == true) {
                                      EnteredAddCashAmount = _AmountTF.text
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '');
                                      amountValidation();
                                    }
                                    if (bankPay == true) {
                                      EnteredAddCashAmount = _AmountTF.text
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '');
                                      amountValidation();
                                    }
                                    // if (addCashOptionStr == true) {
                                    //   EnteredAddCashAmount =
                                    //       _AmountTF.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
                                    //   payWithPersonalPotValidation();
                                    // } else {
                                    //   EnteredAddCashAmount =
                                    //       _AmountTF.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
                                    //   amountValidation();
                                    // }
                                  })
                            ],
                          ),
                        ),
                        //   ),
                      ),
                    )),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              );
            });
          });
    }

/*
    Future<void> AddCashDialog(BuildContext context) async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 480, maxHeight: 520),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height:  MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
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
                                          _AmountTF.text = "";
                                          EnteredAddCashAmount = "";
                                          addCashOptionStr = false;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  )),
                              Container(
                                //margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Add Cash",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.black),
                                ),
                              ),
                              ListTile(
                                leading: Text(
                                  "Personal Pot:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.black),
                                ),
                                trailing: InkWell(
                                  child: Container(
                                    //padding: EdgeInsets.all(20),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: addCashOptionStr == false
                                            ? AppColor.newSignInColor
                                            : Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Center(
                                      child: Text(
                                        "\$$balanceStr",
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Helvetica Neue",
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    print("CLICKED....");
                                    setState(() {
                                      if (addCashOptionStr == false) {
                                        addCashOptionStr = true;
                                        // print(addCashOptionStr);
                                      } else {
                                        addCashOptionStr = false;
                                        //print(addCashOptionStr);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 17, bottom: 5),
                                child: Text(
                                  "Cards",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      // autoPlay: true,
                                      aspectRatio: 2.0,
                                      enlargeCenterPage: true,
                                    ),
                                    items: imageSliders,
                                  ),
                                ],
                              )),
                              Container(
                                margin: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width / 3,
                                // margin: EdgeInsets.only(top: 15),
                                child: TextField(
                                  controller: _AmountTF,
                                  cursorColor: AppColor.themeColor,
                                  autofocus: true,
                                  autocorrect: false,
                                  inputFormatters: [
                                    new WhitelistingTextInputFormatter(
                                        RegExp("[0-9]")),
                                  ],
                                  style: TextStyle(
                                      color: AppColor.newSignInColor,
                                      fontSize: 25,
                                      fontFamily: "Helvetica Neue",
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "\$0",
                                      hintStyle: TextStyle(
                                        color: AppColor.newSignInColor,
                                      )),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  // keyboardType: TextInputType.numberWithOptions(
                                  //     signed: true, decimal: true),
                                  onChanged: (string) {
                                    string =
                                        '\$${_formatNumber(string.replaceAll(',', ''))}';
                                    _AmountTF.value = TextEditingValue(
                                      text: string,
                                      selection: TextSelection.collapsed(
                                          offset: string.length),
                                    );
                                  },
                                ),
                              ),
                              RaisedButton(
                                  color: AppColor.newSignInColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: AppColor.newSignInColor)),
                                  child: Text(
                                    "               Add               ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Helvetica Neue",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (addCashOptionStr == true) {
                                      EnteredAddCashAmount = _AmountTF.text
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '');
                                      payWithPersonalPotValidation();
                                    } else {
                                      EnteredAddCashAmount = _AmountTF.text
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '');
                                      amountValidation();
                                    }
                                  })
                            ],
                          ),
                        ),
                        //   ),
                      ),
                    )),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              );
            });
          });
    }
*/

    final potCont = Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "\$$potAmountStr",
            style: TextStyle(
                fontSize: 25,
                fontFamily: "Helvetica Neue",
                color: AppColor.signInColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 192,
            width: 140,
            child: potImageStr != "null"
                ? SvgPicture.network("$potImageStr", fit: BoxFit.cover)
                : Container(),
          ),
          SizedBox(
            height: 10,
          ),
          goalAmountStr != "0.00"
              ? Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: LinearProgressIndicator(
                      value: progressVal,
                      backgroundColor: Colors.black12,

                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.newSignInColor),

//                valueColor:
//                    new AlwaysStoppedAnimation<Color>(AppColor.newSignInColor),
                      //   value: progressVal //
                    ),
                  ),
                )
              : Container(),
          goalAmountStr != "0.00"
              ? Container(
                  margin: EdgeInsets.only(top: 3),
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    goalAmountStr != "null.00"
                        ? "Goal \$${goalAmountStr}"
                        : "Goal",
                    style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    textAlign: TextAlign.end,
                  ))
              : Container()
        ],
      ),
    );
    final contUI = Container(
      //color: Colors.green,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "${potMemStr} Members",
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    "Amount",
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                    ),
                  )),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.black,
          )
        ],
      ),
    );
    final memberListCont = Container(
      height: 400,
      child: ListView.builder(
        itemCount: memberAry.length,
        itemBuilder: (context, index) {
          profilePicStr = memberAry[index]["image"].toString();
          BalanceActPop = "${memberAry[index]["amount"]}";
          var potAmountInteger = int.parse("${BalanceActPop}");
          final oCcyy = new NumberFormat("#,##0.00", "en_US");
          BalanceActPop = oCcyy.format(potAmountInteger).toString();
//print("BalanceActPop---------${BalanceActPop}");
          if (memberAry[index]["user_id"].toString() == UserID) {
            memDepositeAmnt = memberAry[index]["amount"].toString();
            potMemAmountInt = int.parse(memberAry[index]["amount"].toString());
            //  print("potMemAmountInt-----${potMemAmountInt}");
          }
          return ListTile(
            title: Text(
              "${memberAry[index]["name"]}",
              style: TextStyle(
                  fontFamily: "Helvetica Neue",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "@${memberAry[index]["username"]}",
              style: TextStyle(
                fontFamily: "Helvetica Neue",
              ),
            ),
            leading: CircleAvatar(
              // backgroundColor: Colors.grey,
              radius: 28.0,
              backgroundImage: profilePicStr == "null"
                  ? AssetImage('Assets/profiledummy.png')
                  : NetworkImage(profilePicStr),
            ),
            trailing: AppUserID == memberAry[index]["user_id"].toString()
                ? Text(
                    // "\$${memberAry[index]["amount"]}.00",
                    "\$${BalanceActPop}",
                    style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.bold,
                        color: AppColor.newSignInColor),
                  )
                :
                //AmountShowToUserStr
                Text(
                    //"\$${memberAry[index]["amount"]}.00",
                    "\$${BalanceActPop}",
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onTap: () {
              setState(() {
                UserNameInActPopStr = "@${memberAry[index]["username"]}";
                NameInActPopStr = "${memberAry[index]["name"]}";
                profilePicStrPop = memberAry[index]["image"].toString();
                BalanceActPop = "${memberAry[index]["amount"]}";
                var potAmountIntt = int.parse("${BalanceActPop}");
                final oCcyr = new NumberFormat("#,##0.00", "en_US");
                BalanceActPop = oCcyr.format(potAmountIntt).toString();
              });

              getUsersActivityPotAPI(memberAry[index]["cashpot_id"].toString(),
                  memberAry[index]["user_id"].toString());
            },
          );
        },
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: AppColor.themeColor,
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: Text("$potNameStr"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      endDrawer: _buildDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) async
        {
          this.index = index;
          if (index == 0)
          {
            setState(() {
              sendReqOptionSelect = "send";
            });
            await showInformationDialog(context);
          } else if (index == 1) {
            // await AddCashDialog(context);
            await AddCashDialogNew(context);
            //   print("index---${index}");
          } else if (index == 2) {
            setState(() {
              sendReqOptionSelect = "request";
            });
            await showInformationDialog(context);
          }
        }, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Assets/Layer 2.svg",
              fit: BoxFit.fill,
              height: 22,
              width: 22,
            ),
            title: new Text('Send',
                style: TextStyle(
                    fontFamily: "Helvetica Neue",
                    color: AppColor.newSignInColor)),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Assets/Group 39.svg",
              fit: BoxFit.fill,
              height: 22,
              width: 22,
            ),
            title: new Text(
              'Add Cash',
              style: TextStyle(
                  fontFamily: "Helvetica Neue", color: AppColor.newSignInColor),
            ),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                //  "Assets/wavemoney.svg",
                "Assets/moneyreq.svg",
                height: 22,
                width: 22,
                fit: BoxFit.fill,
                // color: Colors.black26,
              ),
              title: Text(
                'Request',
                style: TextStyle(
                    fontFamily: "Helvetica Neue",
                    color: AppColor.newSignInColor),
              ))
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  potCont,
                  contUI,
                  memberListCont,
                ],
              ),
            ),
            // requestContainer
          ],
        ),
      ),
    );
  }
}
