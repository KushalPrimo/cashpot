import 'dart:convert';

import 'package:cashpot/ModelClasses/CardListData.dart';
import 'package:cashpot/ModelClasses/CardTokenData.dart';
import 'package:cashpot/ModelClasses/GetTokenData.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'CreateCustomerVC.dart';
import 'PaymentWebCardVC.dart';
import 'PaymentWebVC.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';

class PaymentOptionVC extends StatefulWidget
{
  @override
  _PaymentOptionVCState createState() => _PaymentOptionVCState();
}

class _PaymentOptionVCState extends State<PaymentOptionVC>
{
  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  GetTokenData getTokenData;
  CardListData cardListData;
  var bankDataTemp;
  List bankListAry = [];
  var balanceStr = "";
  CardTokenData cardTokenData;
  List cardListAry = [];

  getbankListAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
      setState(() {
        cardListData = CardListData.fromJson(json.decode(response.body));
//print("cardListData--------${cardListData.toJson()}");
        bankDataTemp = cardListData.data.toJson();
        bankListAry = bankDataTemp["banks"];
//print("bankListAry-------${bankListAry}");

       var tempAmnt=  int.parse("${bankDataTemp["balance_amount"].toString()}");
      // print(tempAmnt);
        final oCcy = new NumberFormat("#,##0.00", "en_US");
        balanceStr = oCcy.format(tempAmnt).toString();
        cardListAry = bankDataTemp["cards"];
       // print("cardListAry-------${cardListAry[0]["id"]}");
      });
    } else {
      setState(() {
        balanceStr = "0.0";
      });
    }
  }
  removeBankCard(String fundingSource) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "funding_source": fundingSource
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().removefundingsource}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    //print("bankListAry=========${bankListAry}");
    if (resData["status"] == 1) {

      Utility().toast(context, "Funding source removed successfully.");
      getbankListAPI();
    } else {
     Utility().toast(context, "Something went wrong.");
    }
  }

  getIavTokenAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().getIavToken}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    print("RES====bank=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    getTokenData = GetTokenData.fromJson(json.decode(response.body));
//     print("Running........");
    if (resData["status"] == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentWebVC(
                "${getTokenData.token}",
              )));
      print("API SUCCESS-------");
    } else {}
  }

  getIavTokenCardAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().getiavtokencard}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    print("RES====vvv=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    cardTokenData = CardTokenData.fromJson(json.decode(response.body));
//     print("Running........");
    if (resData["status"] == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentWebCardVC(
                "${cardTokenData.token}",
              )));
      print("API SUCCESS-------");
    } else {}
  }

  CheckAccountCreatedAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post("${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}",
        body: data,
        headers: <String, String>
        {
          'authorization': basicAuth,
        });
    //http://112.196.54.37:3009/api/payments/check-dwolla-customer
    //print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
//     signUpData = SigUpData.fromJson(json.decode(response.body));
//     print("Running........");
    if (resData["status"] == 1)
    {
      //  signUpData = SigUpData.fromJson(json.decode(response.body));
      // print("API SUCCESS-------");
      // getIavTokenAPI();
      // Navigator.of(context).pushNamed('/CreateCustomerVC');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCustomerVC("Bank")));
      //
    }
    else if (resData["status"] == 2 || resData["status"] == 3)
    {
      getIavTokenAPI();
//      signUpErrData = SigUpErrData.fromJson(json.decode(response.body));
//      Utility().toast(context, signUpErrData.msg.toString());
    }
    else
    {
      Utility().toast(context, "Error in getting bank accounts");
    }
  }

  CheckAccountCreatedCardAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
   // print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
//    print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    if (resData["status"] == 1) {
      print("API SUCCESS-------");
      // getIavTokenAPI();
      //  Navigator.of(context).pushNamed('/CreateCustomerVC');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateCustomerVC(
                "Card",
              )));
    } else if (resData["status"] == 2 || resData["status"] == 3) {
      getIavTokenCardAPI();
    } else {
      Utility().toast(context, "Error in getting bank accounts");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      getbankListAPI();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final balanceCont = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              "Assets/Clogo-01.svg",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            "Balance \$${balanceStr}",
            style: TextStyle(
                fontFamily: "Helvetica Neue",fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
          )
        ],
      ),
    );
    final PersonalPotHeadCont = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
      child: Text(
        "Personal Pot",
        style: TextStyle(
            fontFamily: "Helvetica Neue",fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
    final BankCardHeadCont = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
      child: Text(
        "Bank Card",
        style: TextStyle(
            fontFamily: "Helvetica Neue", fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
    final BankAccHeadCont = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
      child: Text(
        "Bank Account",
        style: TextStyle(
            fontFamily: "Helvetica Neue",fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
    final BankCardCont = Container(
      margin: EdgeInsets.only(left: 20, top: 20, bottom: 15, right: 20),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ListTile(
              title: cardListAry.length != 0
                  ? Text("${cardListAry[0]["name"]}",style: TextStyle( fontFamily: "Helvetica Neue",),)
                  : Text("Card Name",style: TextStyle( fontFamily: "Helvetica Neue",),),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                RichText(

                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Remove Card',
                          style: TextStyle(
                              fontFamily: "Helvetica Neue",
                              color: AppColor.newSignInColor, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Privacy Policy"');
                              if(cardListAry.length != 0){
                                removeBankCard(cardListAry[0]["id"]);
                              }else{
                                Utility().toast(context, "No card added.");
                              }

                             // removeBankCard
                            }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Add debit card',
                          style: TextStyle(
                              fontFamily: "Helvetica Neue",
                              color: AppColor.newSignInColor, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {

                              CheckAccountCreatedCardAPI();
                            }),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
    final BankAccountCont = Container(
      margin: EdgeInsets.only(left: 20, top: 20, bottom: 15, right: 20),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ListTile(
              title: bankListAry.length != 0
                  ? Text("${bankListAry[0]["bankName"]}",style: TextStyle( fontFamily: "Helvetica Neue",),)
                  : Text("Bank Name",style: TextStyle( fontFamily: "Helvetica Neue",),),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Remove Bank',
                          style: TextStyle(
                              fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Privacy Policy"');
                              if(bankListAry.length != 0){
                                removeBankCard(bankListAry[0]["id"]);
                              }else{
                                Utility().toast(context, "No bank account added.");
                              }
                            }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Add bank account',
                          style: TextStyle(
                              fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Add bank"');
                              CheckAccountCreatedAPI();
                            }),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: AppColor.themeColor,
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          "Payment Options",
          style: TextStyle(
              fontFamily: "Helvetica Neue",fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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

        //automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          PersonalPotHeadCont,
          balanceCont,
          BankCardHeadCont,
          BankCardCont,
          BankAccHeadCont,
          BankAccountCont
        ],
      ),
    );
  }
}
