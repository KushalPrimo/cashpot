import 'dart:convert';
import 'package:cashpot/ModelClasses/UserCashpotData.dart';
import 'package:cashpot/ProfileVC.dart';
import 'package:cashpot/Utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppNotificationVC.dart';
import 'CashpotDetailVC.dart';
import 'CreatePotForm.dart';
import 'ModelClasses/ProfileData.dart';
import 'Style/Color.dart';
import 'package:http/http.dart' as http;
import 'WebServices.dart';
import 'main.dart';

class HomeVC extends StatefulWidget
{
  @override
  _HomeVCState createState() => _HomeVCState();
}
class _HomeVCState extends State<HomeVC>
{
  static const _locale = 'en';

  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));

  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String UserName = "";
  String Fname = "";
  String profilePicStr = "";
  String walletAmntStr = "0";
  List userCashPotList = [];
  UsersCashpotData usersCashpotData;
  ProfileData profileData;
  ProfileErrorData profileErrorData;
  String transferCheck = "";
  String badgeStatusStr = "";

  dialogAlert(BuildContext context, String message)
  {
    Alert(
      context: context,
      // type: AlertType.success,
      title: "Cashpot",
      desc: message,
      buttons: [
        DialogButton(
          color: AppColor.newSignInColor,
          child: Text(
            "Cancel",
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
          },
          width: 120,
        ),
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

            Navigator.of(context).pushNamed('/PaymentOptionVC');
          },
          width: 120,
        ),
      ],
    ).show();
  }


  openNotificationCashpotAPI(String cashpot_id) async
  {
    Utility().onLoading(context, true);
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
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
      print("API SUCCESS-------OPEN NOTI");
    } else {
//Commented for SHivam side
      // Utility().toast(context, "${resData["msg"]}");
    }
  }

  notificationBadgeAPI() async
  {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "cashpot_id": "",
      "login_id": sharedPreferences.getString("UserID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
    };
    //  print('data-------request------${body}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    //    print("URL------${Webservice().apiUrlPayment}${Webservice().leavepot}");
    //
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
    if (resData["status"] == 1)
    {
      print("API SUCCESS-----badge_status-----");
      setState(() {
        badgeStatusStr = resData["badge_status"].toString();
      });
    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  openUsernotificationAPI() async
  {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "login_id": sharedPreferences.getString("UserID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
    };
    print('data-------request------$body');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("basicAuth----${basicAuth}");
    var response = await http.post(
        "${Webservice().notificationApiURL}${Webservice().OPEN_USER_NOTIFICATIONS}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    print("RES=========${json.decode(response.body) as Map}");
    //Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //print("resData-------${resData}");
    if (resData["status"] == 1)
    {
      print("API SUCCESS-----USER_NOTIFICATION_OPEN-----");
      notificationBadgeAPI();
    }
    // else
    // {
    //   // Navigator.pop(context);
    //   Utility().toast(context, "Something went wrong");
    // }
  }

  getUserCashpotAPI() async
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
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().getusercashpot}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });

    print("RES=====yyy====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    print("Running........$resData");
    usersCashpotData = UsersCashpotData.fromJson(json.decode(response.body));

    if (resData["status"] == 1)
    {
      setState(()
      {
        usersCashpotData = UsersCashpotData.fromJson(json.decode(response.body));

        var tempData = usersCashpotData.toJson();
        for (int i = 0; i <= tempData["data"].length; i++) {
          setState(() {
            userCashPotList = tempData["data"];
          });
        }
      });
      //print("API SUCCESS-------${userCashPotList}");

      //
    } else
    {
      Utility().toast(context, "${resData["msg"]}");
    }
  }

  getProfileAPI() async
  {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data =
    {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------------${data}');
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
    if (resData["status"] == 1)
    {
      profileData = ProfileData.fromJson(json.decode(response.body));
      // print("profileData-------${profileData.data.toJson()}");
      setState(() {
        sharedPreferences.setString(
            "wallet_amount", profileData.data.walletAmount.toString());
      });

      getUserData();
    } else {
      profileErrorData = ProfileErrorData.fromJson(json.decode(response.body));
      //Utility().toast(context, profileErrorData.message.toString());
    }
  }

  Drawer _buildDrawer(BuildContext context)
  {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                new CircleAvatar(
                  radius: 35.0,
                  // backgroundColor: Colors.grey,
                  backgroundImage: profilePicStr == ""
                      ? AssetImage('Assets/profiledummy.png')
                      : NetworkImage(profilePicStr),
                ),
                Text(
                  "$Fname",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Helvetica Neue",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "@$UserName",
                  style: TextStyle(
                      color: Colors.black45,
                      fontFamily: "Helvetica Neue",
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5, top: 15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "\$${walletAmntStr}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "Helvetica Neue"),
                      ),
                    )),
                Divider(
                  height: 1,
                  color: Colors.black,
                )
              ],
            ),
            onTap: () {
              print("Clicked Profile");
              Navigator.of(context).pop();
              //   Navigator.of(context).pushNamed('/ProfileVC');
              Navigator.of(context)
                  .push(
                    new MaterialPageRoute(builder: (_) => ProfileVC()),
                  )
                  .then((val) => val ? _getRequests() : null);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              "Assets/leftMenu/homeicons.svg",
              fit: BoxFit.fill,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              setState(() {});
              Navigator.of(context).pop();
            },
          ),

          ListTile(
            leading: SvgPicture.asset(
              "Assets/leftMenu/bankIcon.svg",
              fit: BoxFit.fill,
            ),
            title: Text(
              'Transfer Balance',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                transferCheck = "TransferToBack";
              });
              CheckAccountCreatedAPI();
            },
          ),

          ///Removed by client feedback
          // ListTile(
          //   leading: SvgPicture.asset(
          //     "Assets/wavemoney.svg",
          //     fit: BoxFit.fill,
          //   ),
          //   title: Text(
          //     'Wallet Activity',
          //     style: TextStyle(
          //         fontSize: 18.0,
          //         color: Colors.black,
          //         fontWeight: FontWeight.w300),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //        Navigator.of(context).pushNamed('/PersonalWalletActivityVC');
          //   },
          // ),

          ListTile(
            leading: new Stack(
              children: <Widget>[
                SvgPicture.asset(
                  "Assets/leftMenu/bellNotiIcon.svg",
                  fit: BoxFit.fill,
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
            onTap: ()
            {
              print("Notification---");
              //widget.changeScreen(1);
              //Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/AppNotificationVC').then((value) => openUsernotificationAPI());
            },
          ),

          ListTile(
            leading: SvgPicture.asset(
              "Assets/leftMenu/recentIcon.svg",
              fit: BoxFit.fill,
            ),
            title: Text(
              'History',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/HistoryVC');
            },
          ),

          ListTile(
            leading: SvgPicture.asset(
              "Assets/leftMenu/SettingsIcon.svg",
              fit: BoxFit.fill,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/SettingsVC');
            },
          ),

          ListTile(
            leading: SvgPicture.asset(
              "Assets/leftMenu/hepIcons.svg",
              fit: BoxFit.fill,
            ),
            title: Text(
              'Help',
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Helvetica Neue",
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              Navigator.of(context).pop();

              Navigator.of(context).pushNamed('/HelpScreenVC');

              // Utility().toast(context, Message().Inprogress);
              //   Navigator.of(context).pushNamed('/SettingVC');
            },
          ),
        ],
      ),
    );
  }

  getUserData() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      UserName = sharedPreferences.getString("UserName");
      Fname = sharedPreferences.getString("Fname");

      var tempAmnt = int.parse(
          "${sharedPreferences.getString("wallet_amount").toString()}");
      final oCcy = new NumberFormat("#,##0.00", "en_US");
      walletAmntStr = oCcy.format(tempAmnt).toString();
      ;
      if (sharedPreferences.getString("profileImage") != null) {
        profilePicStr = sharedPreferences.getString("profileImage").toString();
      }
    });
  }

  _getRequests() async {
    print("_getRequests_getRequests");
    getUserCashpotAPI();
    getUserData();
    getProfileAPI();
    notificationBadgeAPI();
  }

  CheckAccountCreatedAPI() async {
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
    //http://112.196.54.37:3009/api/payments/check-dwolla-customer
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
//     signUpData = SigUpData.fromJson(json.decode(response.body));
//     print("Running........");
    if (resData["status"] == 1) {
      dialogAlert(context, "Please link your bank account with Cashpot");
    } else if (resData["status"] == 3) {
      if (transferCheck == "") {
        Navigator.of(context).push(_createRoute());
      } else {
        setState(() {
          transferCheck = "";
        });

        Navigator.of(context).pushNamed('/TransferFundVC');
      }
    } else if (resData["status"] == 2) {
      dialogAlert(context, "Please link your bank account with Cashpot");
    } else {
      Utility().toast(context, "Error in getting bank accounts");
    }
  }

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      if(message.notification.body.contains("requested")==true && widget!=AppNotificationVC())
        Navigator.pushNamed(navigatorKey.currentState.context,'/AppNotificationVC');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
    {
      if(message.notification.body.contains("requested")==true && widget!=AppNotificationVC())
        Navigator.pushNamed(navigatorKey.currentState.context,'/AppNotificationVC');
    });
    print(",,,,,,,,,,,,home");
    Future.delayed(Duration.zero, () async
    {
      await getUserCashpotAPI();
      await getUserData();
      await getProfileAPI();
      notificationBadgeAPI();
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final topicsCont = Container(
        margin: EdgeInsets.only(right: 15, left: 10, top: 15),
        // height: 330, //MediaQuery.of(context).size.height-350,
        child: userCashPotList.length == 0 ?
        Container(
                child: Text(
                  "No Active Pots",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
              )
            :
        GridView.count(
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(userCashPotList.length, (index)
                {
                  var profilePicStrPot = "null";
                  profilePicStrPot = "${userCashPotList[index]["potImage"].toString()}";
                  return Center(
                      child: InkWell(
                        child: Card(
                        elevation: 8,
                        //shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15) // if you need this
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              height: 200,
                              width: 180,
                              child: Center(
                                  child: Column(
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  profilePicStrPot != "null" ?
                                  SvgPicture.network("${userCashPotList[index]["potImage"].toString()}", fit: BoxFit.cover)
                                      :
                                  Container(),
//                                  SvgPicture.asset("Assets/ThreeFourthsPot.svg",
//                                      fit: BoxFit.cover),
                                  SizedBox(height: 4),

                                  Text(
                                    "${userCashPotList[index]["pot_name"].toString()}",
                                    style: TextStyle(
                                        color: AppColor.homeTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Helvetica Neue",
                                        fontStyle: FontStyle.normal),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Members ${userCashPotList[index]["pot_members_count"].toString()}",
                                    style: TextStyle(
                                        color: AppColor.homeTextColor,
                                        fontSize: 12,
                                        fontFamily: "Helvetica Neue",
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                              )
                          ),

                          ///Comment for now. Its for Notification badges
                          userCashPotList[index]["notification_count"].toString() != "0" ?
                          new Positioned(
                                  right: 0,
                                  child: new Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${userCashPotList[index]["notification_count"].toString()}',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: "Helvetica Neue",
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              :
                          Container()
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            new MaterialPageRoute(
                                builder: (_) => CashpotDetailVC(
                                      "${userCashPotList[index]["cashpot_id"].toString()}",
                                    )),
                          )
                          .then((val) => val ? _getRequests() : null);
///Commented by shivam
                      // openNotificationCashpotAPI(
                      //     "${userCashPotList[index]["cashpot_id"].toString()}");
                    },
                  ));
                }),
              ));
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColor.themeColor,
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: SvgPicture.asset("Assets/appName.svg", fit: BoxFit.cover),
        actions: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.add,
                    size: 35,
                  ),

                  //Image.asset("Assets/addPot.png"),
                )
              ],
            ),
            onTap: () {
              print("My Feed Clicked");
              CheckAccountCreatedAPI();
            },
          ),
        ],
        //automaticallyImplyLeading: false,
      ),
      drawer: _buildDrawer(context),
      body: topicsCont,
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CreatePotForm(),
    transitionsBuilder: (context, animation, secondaryAnimation, child)
    {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
