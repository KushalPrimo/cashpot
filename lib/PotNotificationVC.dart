import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cashpot/ModelClasses/PotNotificationsData.dart';
import 'package:cashpot/ModelClasses/ViewNotificationPotData.dart';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ModelClasses/UserNotificationsData.dart';
import 'ModelClasses/ViewNotificationData.dart';
import 'Utility.dart';
import 'WebServices.dart';

class PotNotificationVC extends StatefulWidget {
  final String cashpotId;
  final String UserAmount;

  const PotNotificationVC(this.cashpotId, this.UserAmount);

  @override
  _PotNotificationVCState createState() => _PotNotificationVCState();
}

class _PotNotificationVCState extends State<PotNotificationVC> {
  String profilePicStr = "";
  PotNotificationsData potNotificationsData;
  UserNotificationsData userNotificationsData;
  ViewNotificationPotData viewNotificationPotData;
  ViewNotificationErrData viewNotificationErrData;
  var NotificationList;

  var tempDataView;
  String NotificationIDstr = "";
  String CashpotRequestIDStr = "";
  String myProfileImage = "null";

  potNotificationListAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": widget.cashpotId
    };
    print('data------potNotificationListAPI-------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    log('Token-------${basicAuth}');
    print("${Webservice().notificationApiURL}${Webservice().getpotnotification}");
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().getpotnotification}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    //  print("bankListAry=========${resData}");
    if (resData["status"] == 1) {
      //  print("API SUCCESS-------Notification.");
      setState(() {
        potNotificationsData =
            PotNotificationsData.fromJson(json.decode(response.body));
        var tempData = potNotificationsData.toJson();
        NotificationList = tempData["result"];
      });

      // print("userNotificationsData--------${NotificationList}");
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  deleteNotAPI(String notificationID) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "notification_id": notificationID
    };
    //print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().deletenotifications}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    // print("resData=========${resData}");
    if (resData["status"] == 1) {
      print("API SUCCESS-------delete Notification");

      potNotificationListAPI();
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  viewAPI(String NotificationID) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    myProfileImage = sharedPreferences.getString("profileImage");
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "notification_id": NotificationID
    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().notificationinfocashrequest}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    //print("bankListAry=========${bankListAry}");
    if (resData["status"] == 1) {
      print("API SUCCESS-------Notification.");
      setState(() {
        viewNotificationPotData =
            ViewNotificationPotData.fromJson(json.decode(response.body));
        tempDataView = viewNotificationPotData.data.toJson();

        NotificationIDstr = "${tempDataView["notification_id"].toString()}";
        CashpotRequestIDStr = "${tempDataView["cash_request_id"].toString()}";
      });

      print("viewNotificationsData----Data----${tempDataView}");

      openPopupForRequest();
    } else {
      viewNotificationErrData =
          ViewNotificationErrData.fromJson(json.decode(response.body));
      var tempVar = viewNotificationErrData.toJson();
      print(tempVar["msg"].toString());
      Utility().toast(context, tempVar["msg"].toString());
    }
  }

  closePop() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  sendMoneyAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cash_request_id": CashpotRequestIDStr,
      "notification_id": NotificationIDstr
    };
    //  print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().acceptcashrequest}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");

    Utility().onLoading(context, false);

    Map resData = json.decode(response.body) as Map;

    print("resData=========${resData}");

    if (resData["status"] == 1) {
      print("API SUCCESS-------Money Sent.");
      Navigator.pop(context);
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
                  height: MediaQuery.of(context).size.height / 3,
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
                        "You sent \$${tempDataView["amount"].toString()} to ${tempDataView["name"].toString()}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Helvetica Neue",
//                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new CircleAvatar(
                            radius: 35.0,
                            // backgroundColor: Colors.grey,
                            backgroundImage:
                                tempDataView["image"].toString() == "null"
                                    ? AssetImage('Assets/profiledummy.png')
                                    : NetworkImage(myProfileImage),
                          ),
                          SvgPicture.asset(
                            "Assets/exchangeArrow.svg",
                            fit: BoxFit.fill,
                          ),
                          new CircleAvatar(
                            radius: 35.0,
                            // backgroundColor: Colors.grey,
                            backgroundImage:
                                tempDataView["image"].toString() == "null"
                                    ? AssetImage('Assets/profiledummy.png')
                                    : NetworkImage(
                                        tempDataView["image"].toString()),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          });
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
      potNotificationListAPI();
    } else {
      Navigator.pop(context);

      // Navigator.pop(context);
      Utility().toast(context, resData["msg".toString()]);
    }
  }

  declineMoneyAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cash_request_id": CashpotRequestIDStr,
      "notification_id": NotificationIDstr
    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().declinecashrequest}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");

    Utility().onLoading(context, false);

    Map resData = json.decode(response.body) as Map;

    //print("bankListAry=========${bankListAry}");

    if (resData["status"] == 1) {
      print("API SUCCESS-------decline Request.");
      Navigator.pop(context);
      Utility().toast(context, "Declined request");
      potNotificationListAPI();
    } else {
      Navigator.pop(context);

      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      potNotificationListAPI();
    });
    super.initState();
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
              color: AppColor.newSignInColor,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            sendMoneyAPI();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.white,
          child: Text(
            "No",
            style: TextStyle(
              fontFamily: "Helvetica Neue",
              color: AppColor.newSignInColor,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            // print("NOOOO");
            //  Navigator.pop(context);
            //   Navigator.pop(context);
            //  Navigator.of(context).pop();
            closePop();
          },
          width: 120,
        ),
      ],
    ).show();
  }

  openPopupForRequest() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => SafeArea(
                child: Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 260, maxHeight: 300),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width - 30,
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
                            // "${NotificationList[index]["name"]}",
                            "Request",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Helvetica Neue"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new CircleAvatar(
                          radius: 35.0,
                          // backgroundColor: Colors.grey,
                          backgroundImage: tempDataView["image"].toString() ==
                                  "null"
                              ? AssetImage('Assets/profiledummy.png')
                              : NetworkImage(tempDataView["image"].toString()),
                        ),
                        Container(
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.only(left: 10),
                            // child: Html(data: "${tempDataView["notification_text"].toString()}")
                            child: Center(
                                child: Html(
                                    data:
                                        "<center>${tempDataView["notification_text"].toString()}.<center/>"))

                            // Text(
                            //   // "${NotificationList[index]["notification_text"]}",
                            //   "${tempDataView["notification_text"].toString()}",
                            //   style: TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black,
                            //       fontFamily: "Helvetica Neue"),
                            //   maxLines: 3,
                            //   textAlign: TextAlign.center,
                            // ),
                            ),
                        Container(
                          // margin: EdgeInsets.all(20),
                          child: Text(
                            // "${NotificationList[index]["notification_text"]}",
                            "\$${tempDataView["amount"].toString()}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Helvetica Neue"),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 30, left: 30, top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  //text: 'Hello ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Send',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.newSignInColor,
                                            fontFamily: "Helvetica Neue",
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pop(context);
                                            if (int.parse(
                                                    "${tempDataView["amount"].toString()}") >
                                                int.parse(
                                                    "${widget.UserAmount}")) {
                                              Utility().toast(context,
                                                  "You have insufficient balance in the pot.");
                                            } else {
                                              dialogAlert(context,
                                                  "Are you sure you want to send ${"\$${tempDataView["amount"].toString()}"} to ${"${tempDataView["name"].toString()}"}");
                                            }
                                          }),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  //text: 'Hello ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Decline',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontFamily: "Helvetica Neue",
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => declineMoneyAPI()),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final potNotificationListCont = Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: NotificationList != null
          ? NotificationList.length != 0
              ? ListView.builder(
                  itemCount: NotificationList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              title: Html(
                                data:
                                    "${NotificationList[index]["notification_text"].toString()}",
                                defaultTextStyle: TextStyle(fontSize: 14),
                              ),

                              // Text(
                              //   "${NotificationList[index]["notification_text"].toString()}",
                              //   style: TextStyle( fontFamily: "Helvetica Neue",),
                              //   textAlign: TextAlign.start,
                              //   maxLines: 3,
                              // ),
                              trailing: Container(
                                width: 90,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    NotificationList[index]
                                                    ["is_accept_notification"]
                                                .toString() ==
                                            "1"
                                        ? InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  right: 5, left: 5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors
                                                        .grey, // set border color
                                                    width:
                                                        1.0), // set border width
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        5.0)), // set rounded corner radius
                                              ),
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontSize: 13),
                                              ),
                                            ),
                                            onTap: () {
                                              print("Tick hefrClicked");
                                              // openPopupForRequest();
                                              viewAPI(NotificationList[index]
                                                      ["notification_id"]
                                                  .toString());
                                            },
                                          )
                                        : Container(
                                            height: 20,
                                            width: 20,
                                            color: Colors.transparent,
                                          ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        print("Cross Clicked");
                                        deleteNotAPI(NotificationList[index]
                                                ["notification_id"]
                                            .toString());
                                      },
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 2,
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No notifications",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica Neue",
                        color: Colors.black54),
                  ),
                )
          : Container(),
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
            "Notifications",
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
              // Navigator.pop(context);
              Navigator.pop(context, true);
            },
          ),
        ),
        body: SafeArea(child: potNotificationListCont));
  }
}
