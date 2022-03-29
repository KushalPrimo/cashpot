import 'dart:io';

import 'package:cashpot/Settings/DwollaAgreementsVC.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'AddCardVC.dart';
import 'AppNotificationVC.dart';
//import 'ContactNewClientVC.dart';
//import 'ContactVC.dart';
import 'CreatePotForm.dart';
import 'EmailSignuoVC.dart';
import 'ForgotPasswordVC.dart';
import 'HelpScreenVC.dart';
//import 'HistoryDetailVC.dart';
import 'HistoryVC.dart';
import 'HomeVC.dart';
import 'Login2VC.dart';
//import 'NewContactVC.dart';
//import 'PotEditVC.dart';
import 'RightMenu/TransferCompletePopUpVC.dart';
import 'Settings/ContactUsVC.dart';
import 'Settings/DwollaPrivacyPolicyVC.dart';
import 'Settings/EmailNotificationSettingVC.dart';
import 'Settings/FaqVC.dart';
import 'Settings/FeesVC.dart';
import 'Settings/LicensesVC.dart';
import 'Settings/PrivacyPolicyVC.dart';
import 'Settings/PrivacySettingsVC.dart';
import 'Settings/PushNotificationSettingsVC.dart';
import 'PaymentOptionVC.dart';
import 'PersonalWalletAvtivityVC.dart';
import 'PhoneVerifyVC.dart';
import 'PotDetailVC.dart';
//import 'PotMenu/MembersVC.dart';
//import 'PotNotificationVC.dart';
import 'PreviewPotVC.dart';
import 'ProfileVC.dart';
import 'RequestVC.dart';
//import 'RightMenu/TransferFundBankListVC.dart';
import 'RightMenu/TransferFundVC.dart';
import 'Settings/ChangePasswordVC.dart';
import 'Settings/InformationVC.dart';
import 'Settings/NotificationSettingsVC.dart';
import 'Settings/SecuritySettingVC.dart';
import 'Settings/TextNotificationSettingsVC.dart';
import 'Settings/UserAgresmentVC.dart';
import 'SettingsVC.dart';
import 'SignupPopVC.dart';
import 'SplashVC.dart';
import 'TansactionOptionListVC.dart';
import 'TransactionHistoryVC.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';

const iOSLocalizedLabels = false;

/// Create a AndroidNotificationChannel for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the FlutterLocalNotificationsPlugin package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//Device Information Plugin
DeviceInfoPlugin deviceInfo=DeviceInfoPlugin();

// Global Key for Navigating during Notifications
GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();

Map phoneInformation={};

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  FlutterAppBadger.removeBadge();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb)
  {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }
  if(Platform.isIOS)
    {
      IosDeviceInfo iosDeviceInfo=await deviceInfo.iosInfo;
      Map<String,String> data=
      {
        "name":iosDeviceInfo.name,
        "isPhysicalDevice":iosDeviceInfo.isPhysicalDevice.toString(),
        "uniqueId":iosDeviceInfo.identifierForVendor
      };
      phoneInformation=data;
      print("----------- $data");
    }
  else
    {
      AndroidDeviceInfo androidDeviceInfo=await deviceInfo.androidInfo;
      Map<String,String> data=
      {
        "name":androidDeviceInfo.device,
        "isPhysicalDevice":androidDeviceInfo.isPhysicalDevice.toString(),
        "uniqueId":androidDeviceInfo.androidId,
      };
      phoneInformation=data;
      print("-----------$data");
    }

  //final ipV6=await Ipify.ipv4();
  //final ipV64=await Ipify.ipv64(format: Format.JSON);

  //print("++++++ $ipV6");
  //print("++++++ $ipV64");

  runApp(MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  ///For supporting iOS 14+ phone with new updates
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class MyApp extends StatelessWidget
{
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashVC(),
        routes: <String, WidgetBuilder>
        {
          '/Login2VC': (BuildContext context) => Login2VC(),
          '/EmailSignupVC': (BuildContext context) => EmailSignupVC(),
          '/PhoneVerifyVC': (BuildContext context) => PhoneVerifyVC(),
          '/SingupPopVC': (BuildContext context) => SingupPopVC(),
          '/HomeVC': (BuildContext context) => HomeVC(),
          '/CreatePotForm': (BuildContext context) => CreatePotForm(),
          // '/ContactVC': (BuildContext context) => new ContactVC(),
          '/SettingsVC': (BuildContext context) => SettingsVC(),
          '/ProfileVC': (BuildContext context) => ProfileVC(),
          '/HistoryVC': (BuildContext context) => HistoryVC(),
          '/ForgotPasswordVC': (BuildContext context) => ForgotPasswordVC(),
          '/PreviewPotVC': (BuildContext context) => PreviewPotVC(),
          // '/HistoryDetailVC': (BuildContext context) => new HistoryDetailVC(),
          '/AppNotificationVC': (BuildContext context) => AppNotificationVC(),
          // '/CashpotDetailVC': (BuildContext context) => new CashpotDetailVC(),
          '/PotDetailVC': (BuildContext context) => PotDetailVC(),
          '/PaymentOptionVC': (BuildContext context) => PaymentOptionVC(),
          // '/CreateCustomerVC': (BuildContext context) => new CreateCustomerVC(),
          '/AddCardVC': (BuildContext context) => AddCardVC(),
          '/PersonalWalletActivityVC': (BuildContext context) => PersonalWalletActivityVC(),
          // '/MembersVC': (BuildContext context) => new MembersVC(),
          '/RequestMemVC': (BuildContext context) => RequestMemVC(),
          // '/PotNotificationVC': (BuildContext context) => new PotNotificationVC(),
          //'/PotActivityVC': (BuildContext context) => new PotActivityVC(),
          '/TransferFundVC': (BuildContext context) => TransferFundVC(),
          '/NotificationSettingsVC': (BuildContext context) => NotificationSettingsVC(),
          '/SecuritySettingVC': (BuildContext context) => SecuritySettingVC(),
          '/ChangePasswordVC': (BuildContext context) => ChangePasswordVC(),
          '/InformationVC': (BuildContext context) => InformationVC(),
          //'/TransferFundBankListVC': (BuildContext context) => new TransferFundBankListVC(),
          '/PushNotificationSettingsVC': (BuildContext context) => PushNotificationSettingsVC(),
          '/EmailNotificationSettingsVC': (BuildContext context) => EmailNotificationSettingsVC(),
          '/TestNotificationSettingsVC': (BuildContext context) => TestNotificationSettingsVC(),
          '/PrivacySettingsVC': (BuildContext context) => PrivacySettingsVC(),
          '/HelpScreenVC': (BuildContext context) => HelpScreenVC(),
          '/TransferCompletePopUpVC': (BuildContext context) => TransferCompletePopUpVC(),
          '/PrivacyPolicyVC': (BuildContext context) => PrivacyPolicyVC(),
          '/UserAgreementVC': (BuildContext context) => UserAgreementVC(),
          '/FeesVC': (BuildContext context) => FeesVC(),
          '/LicensesVC': (BuildContext context) => LicensesVC(),
          '/FaqVC': (BuildContext context) => FaqVC(),
          '/ContactUsVC': (BuildContext context) => ContactUsVC(),
          '/TransactionHistoryVC': (BuildContext context) => TransactionHistoryVC(),
          '/TransactionOptionListVC': (BuildContext context) => TransactionOptionListVC(),
          '/DwollaAgreementsVC': (BuildContext context) => DwollaAgreementsVC(),
          '/DwollaPrivacyPolicyVC': (BuildContext context) => DwollaPrivacyPolicyVC()
          //'/NewContactVC': (BuildContext context) => new NewContactVC(),
          // '/ContactNewClientVC': (BuildContext context) => new ContactNewClientVC(),
        });
  }
}
