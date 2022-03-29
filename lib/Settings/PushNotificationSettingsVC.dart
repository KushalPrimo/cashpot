import 'dart:convert';

import 'package:cashpot/ModelClasses/NotificationResultVC.dart';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Utility.dart';
import '../WebServices.dart';
class PushNotificationSettingsVC extends StatefulWidget {
  @override
  _PushNotificationSettingsVCState createState() => _PushNotificationSettingsVCState();
}

class _PushNotificationSettingsVCState extends State<PushNotificationSettingsVC> {
 NotificationResultVc notificationResultVc;
 var tempData;
  bool _switchValue=true;
  bool _switchValue1=true;
  bool _switchValue2=true;
  bool _switchValue3=true;
  bool _switchValue4=true;
  bool _switchValue5=true;
  bool _switchValue6=true;
  bool _switchValue7=true;

  getNotificationResultAPI() async {
     Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "login_id": sharedPreferences.getString("UserID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().getnotificationpermissions}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //print("RES=========${json.decode(response.body) as Map}");
     Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
      notificationResultVc =
          NotificationResultVc.fromJson(json.decode(response.body));
      setState(() {
         tempData = notificationResultVc.result.toJson();
        tempData["push_bank_transfer"].toString()=="0"?_switchValue1 = false:_switchValue1 = true;
        tempData["push_cash_request_payment_recieved"].toString()=="0"?_switchValue2 = false:_switchValue2 = true;
        tempData["push_cash_request_payment_send"].toString()=="0"?_switchValue3 = false:_switchValue3 = true;
        tempData["push_cash_request_recieved"].toString()=="0"?_switchValue4 = false:_switchValue4 = true;
        tempData["push_cash_request_sent"].toString()=="0"?_switchValue5 = false:_switchValue5 = true;
        tempData["push_join_request"].toString()=="0"?_switchValue6 = false:_switchValue6 = true;
     //   print("tempData-----${tempData}");
      });

    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

 updateNotificationAPI() async {
   Utility().onLoading(context, true);
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   Map data = {
     "login_id": sharedPreferences.getString("UserID").toString(),
     "user_id": sharedPreferences.getString("UserID").toString(),
     "push_bank_transfer":_switchValue1==true?"1":"0",
     "push_cash_request_payment_recieved":_switchValue2==true?"1":"0",
     "push_cash_request_payment_send":_switchValue3==true?"1":"0",
     "push_cash_request_recieved":_switchValue4==true?"1":"0",
     "push_cash_request_sent":_switchValue5==true?"1":"0",
     "push_join_request":_switchValue6==true?"1":"0",
     "email_bank_transfer": tempData["push_bank_transfer"].toString(),
   "email_cash_request_payment_recieved":tempData["email_cash_request_payment_recieved"].toString(),
     "email_cash_request_payment_send":tempData["email_cash_request_payment_send"].toString(),
     "email_add_cash_denied":tempData["email_add_cash_denied"].toString(),
     "email_cash_request_recieved":tempData["email_cash_request_recieved"].toString(),
     "email_cash_request_sent":tempData["email_cash_request_sent"].toString(),
     "email_cash_request_denied":tempData["email_cash_request_denied"].toString(),
     "email_join_pot_request":tempData["email_join_pot_request"].toString(),
     "text_bank_transfer":tempData["text_bank_transfer"].toString(),
     "text_cash_request_payment_recieved":tempData["text_cash_request_payment_recieved"].toString(),
     "text_cash_request_payment_send":tempData["text_cash_request_payment_send"].toString(),
     "text_add_cash_denied":tempData["text_add_cash_denied"].toString(),
     "text_cash_request_recieved":tempData["text_cash_request_recieved"].toString(),
     "text_cash_request_sent":tempData["text_cash_request_sent"].toString(),
     "text_cash_request_denied":tempData["text_cash_request_denied"].toString(),
   };
   // print('data-------Update------${data}');
   String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
   // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
   var response = await http.post(
       "${Webservice().notificationApiURL}${Webservice().updatenotificationpermissions}",
       body: data,
       headers: <String, String>{
         'authorization': basicAuth,
       });
   //print("RES=========${json.decode(response.body) as Map}");
   Utility().onLoading(context, false);
   Map resData = json.decode(response.body) as Map;

   if (resData["status"] == 1) {

     getNotificationResultAPI();

   } else {
     Utility().toast(context, "Something went wrong");
   }
 }
 @override
 void initState() {
   // TODO: implement initState

   Future.delayed(Duration.zero, () {
     getNotificationResultAPI();
   });

   super.initState();
 }
  @override
  Widget build(BuildContext context) {
    final cashNotiCont = Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15, left: 15, top: 15),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Cash Transactions",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Bank Transfer",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                 // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue1,
              onChanged: (value) {
                setState(() {
                  _switchValue1 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Cash Request Payment Received",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue2,
              onChanged: (value) {
                setState(() {
                  _switchValue2 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Cash Request Payment Sent",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue3,
              onChanged: (value) {
                setState(() {
                  _switchValue3 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
    final requestNotiCont = Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(right: 15, left: 15, top: 15),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Request",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Cash Request Received",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue4,
              onChanged: (value) {
                setState(() {
                  _switchValue4 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Cash Request Sent",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue5,
              onChanged: (value) {
                setState(() {
                  _switchValue5 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Join Pot Request",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue6,
              onChanged: (value) {
                setState(() {
                  _switchValue6 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
    // final mentionNotiCont = Container(
    //   child: Column(
    //     children: <Widget>[
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Container(
    //         margin: EdgeInsets.only(right: 15, left: 15, top: 15),
    //         width: MediaQuery.of(context).size.width,
    //         child: Text(
    //           "Mention",
    //           style: TextStyle(
    //               fontSize: 20,
    //               fontFamily: "Helvetica Neue",
    //               fontWeight: FontWeight.bold,
    //               color: Colors.black),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 15,
    //       ),
    //       Divider(
    //         height: 1,
    //       ),
    //       ListTile(
    //         leading: Text(
    //           "Chat Mentions",
    //           style: TextStyle(
    //               fontSize: 20,
    //               fontFamily: "Helvetica Neue",
    //               // fontWeight: FontWeight.bold,
    //               color: Color(0xff707070)),
    //
    //         ),
    //         trailing: CupertinoSwitch(
    //           value: _switchValue,
    //           onChanged: (value) {
    //             setState(() {
    //               _switchValue = value;
    //             });
    //           },
    //         ),
    //       ),
    //       Divider(
    //         height: 1,
    //       ),
    //
    //     ],
    //   ),
    // );
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

          title: Text("Push Notification"),
          actions: <Widget>[
            FlatButton(
              child: Text("Save",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Helvetica Neue",
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                updateNotificationAPI();
                //DO HERE
              },
            ),
          ],

        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              cashNotiCont,
              requestNotiCont,
             // mentionNotiCont
            ],
          ),
        )
    );
  }
}
