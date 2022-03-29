import 'dart:convert';
import 'package:cashpot/ModelClasses/ProfileData.dart';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Message.dart';
import '../Utility.dart';
import '../WebServices.dart';
import 'TransferFundBankListVC.dart';

TextEditingController _AmountTF = new TextEditingController();

class TransferFundVC extends StatefulWidget {
  @override
  _TransferFundVCState createState() => _TransferFundVCState();
}

class _TransferFundVCState extends State<TransferFundVC> {
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String EnteredAmount = "";
  ProfileData profileData;
  ProfileErrorData profileErrorData;
  String walletAmntStr = "0";
  FocusNode focusNode = FocusNode();
  String hintText = '\$0';
  String preText = '';
  var potAmountInt = 0;


  Future getProfileAPI() async {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
    };
    print('data-------------${data}');
    //  print("${Webservice().apiUrl}${Webservice().getuserinfo}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().getuserinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
    //print("resData-----_${resData}");
    if (resData["status"] == 1) {
      setState(() {
        profileData = ProfileData.fromJson(json.decode(response.body));
        walletAmntStr = profileData.data.walletAmount.toString();
        // print("Eg. 1: ${walletAmntStr}");
        potAmountInt = int.parse("${profileData.data.walletAmount}");
        final oCcy = new NumberFormat("#,##0.00", "en_US");
        walletAmntStr = oCcy.format(potAmountInt).toString();
      });

      // print("profileData-------${profileData.data.walletAmount.toString()}");

    } else {
      profileErrorData = ProfileErrorData.fromJson(json.decode(response.body));
      //Utility().toast(context, profileErrorData.message.toString());
    }
  }

  transferAmntVal() {
    // print("_AmountTF.text----_${_AmountTF.text}");
    if (EnteredAmount == "") {
      Utility().toast(context, Message().amountEmptyMsg);
    } else if (EnteredAmount.contains(RegExp(r'^0+'))) {
      Utility().toast(context, "Please add a valid amount");
    } else if (int.parse(EnteredAmount) > potAmountInt) {
      Utility()
          .toast(context, "Amount should not be more than your wallet amount");
    } else if (EnteredAmount.contains("-")) {
      Utility().toast(context, "Please add a valid amount");
    } else {
      //DO here
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TransferFundBankListVC(
                "${EnteredAmount}",
              )));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    EnteredAmount = "";
    Future.delayed(Duration.zero, () {
      getProfileAPI();
      _AmountTF.text = "";
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          hintText = '';
          preText = "\$";
        } else {
          hintText = '\$0';
          preText = "\$";
        }
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UICont = Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            'Enter Amount',
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Helvetica Neue",
                color: Color(0xff707070),
                fontWeight: FontWeight.bold),
          ),
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                  autocorrect: false,
                  controller: _AmountTF,
                  cursorColor: AppColor.themeColor,
                  // showCursor: false,
                  // focusNode: focusNode,
                  autofocus: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                      color: AppColor.newSignInColor,
                      fontSize: 25,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      //prefixText: "${preText}",
                      border: InputBorder.none,
                      // focusedBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(31.0)),
                      //   borderSide:
                      //   BorderSide(width: 3, color: AppColor.newSignInColor),
                      // ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(31.0)),
                      //   borderSide:
                      //   BorderSide(width: 3, color: AppColor.newSignInColor),
                      // ),
                      hintText: "\$0",
                      //hintText,
                      hintStyle: TextStyle(
                        color: AppColor.newSignInColor,
                      )),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  //TextInputType.numberWithOptions(signed: true, decimal: true),
                  onChanged: (string) {
                    string = '\$${_formatNumber(string.replaceAll(',', ''))}';
                    _AmountTF.value = TextEditingValue(
                      text: string,
                      selection: TextSelection.collapsed(offset: string.length),
                    );
                  },
                ),
              ),
              // Icon(
              //   Icons.arrow_drop_up,
              //   color: Color(0xff707070),
              //   size: 30,
              // ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 279,
            width: 200,
            child: Container(
              height: 100,
              child: SvgPicture.asset(
                "Assets/ThreeFourthsPotIcon.svg",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Your pot balance is \$$walletAmntStr',
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Helvetica Neue",
                color: Color(0xff707070),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 35,

          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)),
            child: Text(
              "                  Next                  ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              EnteredAmount =
                  _AmountTF.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
              transferAmntVal();
              // Navigator.of(context).pushNamed('/TransferFundBankListVC');
            },
          )
        ],
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: new Text(
          "Transfer Funds",
          style: TextStyle(
            fontFamily: "Helvetica Neue",
          ),
        ),
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: UICont,
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }
}
