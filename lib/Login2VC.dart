import 'dart:async';
import 'dart:convert';
import 'package:cashpot/EmailSignuoVC.dart';
import 'package:cashpot/HomeVC.dart';
import 'package:cashpot/ModelClasses/LoginData.dart';
import 'package:cashpot/Utility.dart';
import 'package:cashpot/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Message.dart';
import 'Style/Color.dart';
import 'WebServices.dart';
import 'dart:io' show Platform;
TextEditingController _UsernameTF = new TextEditingController();
TextEditingController _PasswordTF = new TextEditingController();

class Login2VC extends StatefulWidget
{
  @override
  _Login2VCState createState() => _Login2VCState();
}

class _Login2VCState extends State<Login2VC>
{
  bool checkBoxVal = false;
  LoginData loginData;
  LoginErrData loginErrData;
  String platform = "";
  //int signInCount=3;
  //bool loginInFirstTime=false;
  //Duration timeRemaining=Duration(seconds: 20);
  DateTime timeStarted;
  //Timer timer;

  final logoCont = Container(
  // width: 200,
    height: 70,
    child: Center(
      child: SvgPicture.asset("Assets/Group1046.svg",
        fit: BoxFit.fill,
      )
    ),
  );
  _launchURL() async
  {
    const url = 'https://www.cashpotapp.com/terms-of-service';
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'Could not launch $url';
  }
  _launchURL2() async
  {
    const url = 'https://www.cashpotapp.com/privacy-policy';
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'Could not launch $url';
  }
  rememberMe()
  {
    if (checkBoxVal == false)
    {
      _UsernameTF.text = "";
      _PasswordTF.text = "";
    }
  }

  loginAPI() async
  {
        Utility().onLoading(context, true);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        print("++++++Reached");
        Map data =
        {
          'email': _UsernameTF.text,
          'password': _PasswordTF.text,
          "device_token":sharedPreferences.getString("FCM_token").toString(),
          "device_type" :platform,
        };
        data.addAll(phoneInformation);

        print("data------------>: $data");
        var response = (await http.post("${Webservice().apiUrl}${Webservice().login}", body: data));//  print("RES=========${json.decode(response.body) as Map}");
        Utility().onLoading(context, false);
        Map resData = json.decode(response.body) as Map;
        print("++++++++++++ $resData");//     print("Running........");
        if(resData["status"]==0 && resData["Account"]=="False")
          Utility().toast(context, resData["msg"]);
        else if(resData["status"]==1 && resData["Account"]=="True")
          Utility().toast(context,"Try again after ${resData["Time_left"]+1} ${resData["Time_left"]!=0 ? 'minutes':'minute'}");
        else if (resData["status"] == 1)
        {
          loginData = LoginData.fromJson(json.decode(response.body));
          //print("loginData-------${loginData.data.toJson()}");
          sharedPreferences.setString("UserID", loginData.data.userId.toString());
          sharedPreferences.setString("Fname", loginData.data.name.toString());
          sharedPreferences.setString("UserName", loginData.data.username.toString());
          sharedPreferences.setString("wallet_amount", loginData.data.walletAmount.toString());
          sharedPreferences.setString("emailID", loginData.data.email.toString());
          sharedPreferences.setString("AuthToken", loginData.token.toString());
          sharedPreferences.setString("UserPassword", _PasswordTF.text);
          if (loginData.data.image.toString() != "null")
            sharedPreferences.setString("profileImage", "${Webservice().imagePath}${loginData.data.image.toString()}");
          rememberMe();
          print("-----------------------> ready to login into Home");
          Navigator.of(context).pushReplacementNamed('/HomeVC');
          //Navigator.of(context).push(_createRoute());
        }
        else
        {
          //print("------Here");
          loginErrData = LoginErrData.fromJson(json.decode(response.body));
          Utility().toast(context, loginErrData.msg.toString());
        }
  }

  loginValidation()
  {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_UsernameTF.text.isEmpty)
      Utility().toast(context, Message().UsernameErr);
    else if (!_UsernameTF.text.contains("@") || !_UsernameTF.text.contains("."))
      Utility().toast(context, Message().EmailValid);
    else if (_PasswordTF.text.isEmpty)
      Utility().toast(context, Message().PasswordEmpty);
    else if (_PasswordTF.text.length < 8)
      Utility().toast(context, Message().PasswordCharacter);
    else
      loginAPI();
  }

  @override
  void initState()
  {
    super.initState();
    // TODO: implement initState
    //print("**************okay");
    if (Platform.isAndroid)
    {
      // Android-specific code
      platform = "Android";
    } else if (Platform.isIOS)
    {// iOS-specific code
      platform = "iOS";
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final logCont = Container(
      margin: EdgeInsets.only(right: 30, left: 30),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          TextField(
              controller: _UsernameTF,
              cursorColor: Colors.white,
              //textCapitalization: TextCapitalization.words,
              autocorrect: false,
              inputFormatters: [
                BlacklistingTextInputFormatter(new RegExp(r"\s"))], // LengthLimitingTextInputFormatter(26),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Helvetica Neue",
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  height: 5,
                  width: 5,
                  child: Center(
                    child: SvgPicture.asset(
                      "Assets/emailIcon.svg",
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3.0,color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3.0,color: Colors.white),
                ),
                hintText: 'email',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: "Helvetica Neue",
                ),
              ),
              keyboardType: TextInputType.emailAddress),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _PasswordTF,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            inputFormatters: [BlacklistingTextInputFormatter(
                new RegExp(r"\s")
            )],
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "Helvetica Neue",
            ),
            decoration: InputDecoration(
                prefixIcon: Container(
                  height: 5,
                  width: 5,
                  child: Center(
                    child: SvgPicture.asset(
                      "Assets/PsdIcon.svg",

                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3.0,color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3.0,color: Colors.white),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: "Helvetica Neue",
                )),
            obscureText: true,
          ),
          Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: checkBoxVal == false
                      ? Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.white,
                          size: 25,
                        )
                      : Icon(
                          Icons.check_box,
                          color: Colors.white,
                          size: 25,
                        ),
                  onPressed: () {
                    if (checkBoxVal == false) {
                      setState(() {
                        checkBoxVal = true;
                      });
                    } else {
                      setState(() {
                        checkBoxVal = false;
                      });
                    }
                  },
                ),
              ),
              Text(
                "Keep me signed in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),

                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/ForgotPasswordVC');
                },
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            // width: MediaQuery.of(context).size.width,
            // margin: EdgeInsets.only(left: 20),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed('/UserAgreementVC');
                          print('Terms of Service"');
                        }),
                  TextSpan(text: ' and ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                         // _launchURL2();
                          Navigator.of(context).pushNamed('/PrivacyPolicyVC');
                          print('Privacy Policy"');
                        }),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Container(
            height: 50,
            child: RaisedButton(
              color: AppColor.newLoginColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: AppColor.newLoginColor)),
              child: Text(
                "                     Sign In                     ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                loginValidation();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don’t have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                  //  Navigator.of(context).pushNamed('/EmailSignupVC');
                    Navigator.of(context).push(_createRouteForSignup());
                  //  Navigator.of(context).pushNamed('/SingupPopVC');
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // width: MediaQuery.of(context).size.width,

            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // half of height and width of Image
                    ),
                    child: InkWell(
                      child: Image.asset(
                        'Assets/fbCIrcle.png',
                        fit: BoxFit.fill,
                        width: 48,
                        height: 48,
                      ),
                      onTap: () {
                        print("Clicked");
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // half of height and width of Image
                    ),
                    child: InkWell(
                      child: Image.asset(
                        'Assets/twitterCircle.png',
                        fit: BoxFit.fill,
                        width: 48,
                        height: 48,
                      ),
                      onTap: () {
                        print("Clicked");
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
    return Scaffold(
      // backgroundColor: AppColor.themeColor,
     // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(

          child: Stack(
            children: <Widget>[
              Container(

                color: AppColor.newSignInColor,
                width: MediaQuery.of(context).size.width,
                height:  MediaQuery.of(context).size.height,
                child: SvgPicture.asset("Assets/GreenBackground.svg",
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ) /* add child content here */,
              ),

              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                    ),
                    logoCont,
                    logCont
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute()
{
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeVC(),
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

Route _createRouteForSignup()
{
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EmailSignupVC(),
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

