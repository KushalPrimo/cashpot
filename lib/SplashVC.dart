import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'main.dart';

class SplashVC extends StatefulWidget
{
  @override
  _SplashVCState createState() => _SplashVCState();
}

class _SplashVCState extends State<SplashVC>
{
  bool _Bigger = false;
  String FCMToken = "";
  Stream<String> _tokenStream;
 //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  startTime() async
  {
    return Timer(Duration(seconds: 3), navigationPage);
  }

  void navigationPage() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("UserID") == null)
      Navigator.of(context).pushReplacementNamed('/Login2VC');
    else
      Navigator.of(context).pushReplacementNamed('/HomeVC');
  }

  Future<void> setToken(String token) async
  {
    print('FCM Token:--- $token');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("FCM_token", token);
  }
  askPermission() async
  {
  await FirebaseMessaging.instance.requestPermission(
    announcement: true,
    carPlay: true,
    criticalAlert: true,
    badge: true,
    sound: true,
  );
  Timer(Duration(seconds: 5), () {
    print(" This line is execute after 5 seconds");
    print(" Do something");
    FirebaseMessaging.instance
        .getToken(
        vapidKey:
        'AAAAX9CsmEQ:APA91bGuS1gTns7QSCgcFscD7neXOeUe7MLiqiIK3ajqqeANakNFZEVTv6IbdNAG4-fs77D20Tamyuz6Rejx828kG2M69vGe1iRqydAvkid3hNsuKeocZT1azUiY4pET-I5yB8X_j2N2')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  });


}

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    FlutterAppBadger.removeBadge();
    askPermission();
    Timer(Duration(microseconds: 1000), () {setState(()=>_Bigger = true);});
    startTime();
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb)
      {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ));

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
        {
          print('A new onMessageOpenedApp event was published!');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SvgPicture.asset(
                  "Assets/WhiteBackgroundSvg.svg",
                  fit: BoxFit.cover,
                ) /* add child content here */,
              ),
              Center(
                child: AnimatedContainer(
                    color: Colors.transparent,
                    width: _Bigger ? 400 : 50,
                    child: SvgPicture.asset("Assets/logo.svg"),
                    duration: Duration(seconds: 5)),
              )
            ],
          ),

//
        ));
  }
}