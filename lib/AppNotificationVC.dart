import 'dart:convert';
import 'package:cashpot/ModelClasses/UserNotificationsData.dart';
import 'package:cashpot/ModelClasses/ViewNotificationData.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'HomeVC.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';
import 'main.dart';

class AppNotificationVC extends StatefulWidget
{
  @override
  _AppNotificationVCState createState() => _AppNotificationVCState();
}

class _AppNotificationVCState extends State<AppNotificationVC>
{
  String profilePicStr = "";
  UserNotificationsData userNotificationsData;
  var NotificationList = [];
  ViewNotificationData viewNotificationData;
  var tempDataView;
  ViewNotificationErrData viewNotificationErrData;
  notificationListAPI() async
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
        "${Webservice().notificationApiURL}${Webservice().getUsersNotification}",
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
      setState(()
      {
        userNotificationsData = UserNotificationsData.fromJson(json.decode(response.body));
        var tempData = userNotificationsData.toJson();
        NotificationList = tempData["result"];
      });
     print("userNotificationsData--------${NotificationList}");
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }
  dialogAlert(BuildContext context, String message)
  {
    Alert(
      context: context,
      // type: AlertType.success,
      title: "Cashpot",
      desc: message,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),
      buttons: [
        DialogButton(
          color: AppColor.newSignInColor,
          child: Text(
            "Ok",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            // Utility().toast(context,
            //     "Work in-progress, pot details will be on next build.");

            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pushNamed('/HomeVC');
          },
          width: 120,
        ),
      ],
    ).show();
  }
  joinPotAPI(String cashpot_user_id, String notificationID) async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_user_id": cashpot_user_id,
      "notification_id": notificationID
    };
    //print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().acceptpotrequest}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    // print("resData=========${resData}");
    if (resData["status"] == 1) {
      print("API SUCCESS-------JOIN POT");
    // Navigator.pop(context);
      dialogAlert(context,"Pot joined successfully.");
     // Navigator.of(context).pushNamed('/HomeVC');
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil('/HomeVC', (Route<dynamic> route) => false);
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  declinePotAPI(String cashpot_user_id, String notificationID) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_user_id": cashpot_user_id,
      "notification_id": notificationID
    };

    //print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().declinepotrequest}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    // print("resData=========${resData}");
    if (resData["status"] == 1) {
      print("API SUCCESS-------decline POT");
      Navigator.pop(context);
      notificationListAPI();
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

      notificationListAPI();
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }
  viewAPI(String NotificationID) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "notification_id": NotificationID
    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().notificationinfo}",
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
        viewNotificationData =
            ViewNotificationData.fromJson(json.decode(response.body));
        tempDataView = viewNotificationData.data.toJson();

      });

      print("userNotificationsData--------${tempDataView}");
      openPopupForRequest();
    } else {
      viewNotificationErrData =
          ViewNotificationErrData.fromJson(json.decode(response.body));
      var tempVar = viewNotificationErrData.toJson();
      Utility().toast(context, tempVar["msg"].toString());
    }
  }

  openPopupForRequest() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:ConstrainedBox(
                    constraints:
                    BoxConstraints(minHeight: 250, maxHeight: 280),

                 child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                   // height: MediaQuery.of(context).size.height / 2.8,
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
                            "${tempDataView["name"].toString()}",
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
                          margin: EdgeInsets.all(20),
                          child: Center(child: Html(data: "<center>${tempDataView["notification_text"].toString()}.<center/>"))
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
                          margin: EdgeInsets.only(right: 30, left: 30, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  //text: 'Hello ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Join',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Helvetica Neue",
                                            color: AppColor.newSignInColor,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => joinPotAPI(
                                              tempDataView["cashpot_user_id"]
                                                  .toString(),
                                              tempDataView["notification_id"]
                                                  .toString())),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  //text: 'Hello ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'No',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.newSignInColor,
                                            fontFamily: "Helvetica Neue",
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => declinePotAPI(
                                              tempDataView["cashpot_user_id"]
                                                  .toString(),
                                              tempDataView["notification_id"]
                                                  .toString())),
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
            )
        )
    );
  }

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      if(message.notification.body.contains("requested")==true && widget==AppNotificationVC())
        Navigator.pushNamed(navigatorKey.currentState.context,'/AppNotificationVC');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
    {
      if(message.notification.body.contains("requested")==true && widget==AppNotificationVC())
        Navigator.pushNamed(navigatorKey.currentState.context,'/AppNotificationVC');
    });
    Future.delayed(Duration.zero, () {
      notificationListAPI();
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final NotificationListCont = Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: NotificationList != null?
      NotificationList.length != 0
          ? ListView.builder(
              itemCount: NotificationList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          title: Html(
                            data:"${NotificationList[index]["notification_text"].toString()}",
                         defaultTextStyle: TextStyle(fontSize: 14),

                          ),
                          // Text(
                          //   "${NotificationList[index]["notification_text"].toString()}",
                          //   style: TextStyle(fontFamily: "Helvetica Neue",),
                          //   textAlign: TextAlign.start,
                          //   maxLines: 3,
                          // ),
                          trailing: Container(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                NotificationList[index]["is_accept_notification"].toString() == "1"
                                    ? InkWell(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 5, left: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors
                                                    .grey, // set border color
                                                width: 1.0), // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0)), // set rounded corner radius
                                          ),
                                          child: Text(
                                            "View",
                                            style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13),
                                          ),
                                        ),
                                        onTap: () {
                                          print("Tick Clicked");

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
                                  onTap: ()
                                  {
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
            ):Container(),
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
        title: Text("Notifications",style: TextStyle(fontFamily: "Helvetica Neue",),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: ()
          {
            Navigator.popUntil(context,ModalRoute.withName('/HomeVC'));
          },
        ),
      ),
      body: SafeArea(child: NotificationListCont)


    );
  }
}
