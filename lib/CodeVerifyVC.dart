import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Message.dart';
import 'ModelClasses/LoginData.dart';
import 'ModelClasses/SignUpData.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';

TextEditingController _OtpTF = new TextEditingController();

class CodeVerifyVC extends StatefulWidget
{
  final String OTP;
  final String PhoneNumber;
  final String PhoneWithoutCode;
  const CodeVerifyVC(this.OTP, this.PhoneNumber, this.PhoneWithoutCode);

  @override
  _CodeVerifyVCState createState() => _CodeVerifyVCState();
}

class _CodeVerifyVCState extends State<CodeVerifyVC> {
  SigUpData signUpData;
  SigUpErrData signUpErrData;
  LoginData loginData;
  LoginErrData loginErrData;
  String OTPstr = "";
  final assetLogo = Container(
    child: Center(
      child: SvgPicture.asset("Assets/Clogo01.svg",
        fit: BoxFit.fill,
      )
    ),
  );

  @override
  void initState()
  {
    // TODO: implement initState
    setState(() {OTPstr = widget.OTP;});
    super.initState();
  }

  PhoneVerifyAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("${sharedPreferences.getString("UserID")}");
    Map data = {
      'number': widget.PhoneNumber,
      'user_id': sharedPreferences.getString("UserID")
    };
    //  print('data-------------${body}');
    var response = await http
        .post("${Webservice().apiUrl}${Webservice().updateNumber}", body: data);
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1)
    {
      Navigator.of(context).pushNamed('/SingupPopVC');
    } else {
      Utility().toast(context, "Something went wrong!");
    }
  }

  removePrevioiusData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("first_name");
   // sharedPreferences.remove("last_name");
    sharedPreferences.remove("email_Id");
    sharedPreferences.remove("username_Name");
    sharedPreferences.remove("password");
    sharedPreferences.remove("Device_Type");
  }

  LoginAPI() async
  {

    //Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': sharedPreferences.getString("email_Id"),
      'password': sharedPreferences.getString("password"),
      'device_token': sharedPreferences.getString("FCM_token").toString(),
      'device_type': sharedPreferences.getString("Device_Type"),
    };
    print('data-------------$data');
    //if (resData["status"] == 1)
    //{
    var response;
    try
    {
      response = await http.post("${Webservice().apiUrl}${Webservice().login}", body: data);
      Utility().onLoading(context, false);
      Map resData = json.decode(response.body) as Map;
      loginData = LoginData.fromJson(json.decode(response.body));
      print("loginData-------${loginData.data.toJson()}");
      sharedPreferences.setString("UserID", loginData.data.userId.toString());
      sharedPreferences.setString("Fname", loginData.data.name.toString());
      sharedPreferences.setString("UserName", loginData.data.username.toString());
      sharedPreferences.setString("wallet_amount", loginData.data.walletAmount.toString());
      sharedPreferences.setString("emailID", loginData.data.email.toString());
      sharedPreferences.setString("AuthToken", loginData.token.toString());
      //
      if(loginData.data.image.toString() != "null")
      {
        sharedPreferences.setString("profileImage", "${Webservice().imagePath}${loginData.data.image.toString()}");
      }
      removePrevioiusData();
      //Navigator.of(context).pushNamed('/SingupPopVC');
    }catch(exception)
    {
        loginErrData = LoginErrData.fromJson(json.decode(response.body));
        Utility().toast(context, loginErrData.msg.toString());
    }
    //}
    // else
    // {
    //   loginErrData = LoginErrData.fromJson(json.decode(response.body));
    //   Utility().toast(context, loginErrData.msg.toString());
    // }
  }

  SignUpAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data =
    {
      'name': sharedPreferences.getString("first_name"),
      //'last_name': sharedPreferences.getString("last_name"),
      'email': sharedPreferences.getString("email_Id"),
      'username': sharedPreferences.getString("username_Name"),
      'password': sharedPreferences.getString("password"),
      'number': "${widget.PhoneNumber.toString()}",
      'user_type': '0',
      'social_id': '1',
      'device_token': sharedPreferences.getString("FCM_token").toString(),
      'device_type': sharedPreferences.getString("Device_Type")
    };
    print("data------$data");
    print("${Webservice().apiUrl}${Webservice().signup}");
    var response = await http.post("${Webservice().apiUrl}${Webservice().signup}", body: data);
    Map resData = json.decode(response.body) as Map;
    if (resData["status"] == 1)
    {
      signUpData = SigUpData.fromJson(json.decode(response.body));
//      sharedPreferences.setString("UserID", signUpData.data.userId.toString());
//      sharedPreferences.setString(
//          "Fname", signUpData.data.firstName.toString());
//      sharedPreferences.setString(
//          "UserName", signUpData.data.username.toString());
//      sharedPreferences.setString("emailID", signUpData.data.email.toString());
      dialogAlert(context, "We have sent you an email to Verify your email address.");
    }
    else
    {
      Utility().onLoading(context, false);
      signUpErrData = SigUpErrData.fromJson(json.decode(response.body));
      Utility().toast(context, signUpErrData.msg.toString());
    }
  }

  OtpAPI() async
  {
    Utility().onLoading(context, true);
    Map data =
    {
      'number': "${widget.PhoneNumber}",
      "num_without_code": "${widget.PhoneWithoutCode}"
    };
    print("data---------$data");
    var response = await http.post("${Webservice().apiUrl}${Webservice().verifyNumber}", body: data);
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

//     print("Running........");
    if (resData["status"] == 1) {
      setState(() {
        OTPstr = resData["otp"].toString();
      });
    //  print("Running........${resData["otp"].toString()}");
     Utility().toast(context, "OTP sent to entered number");
      // Navigator.of(context).pushReplacementNamed('/HomeVC');
    } else {

      Utility().toast(context,"${resData["msg"].toString()}");
    }
  }

  OtpValidation()
  {
    if (_OtpTF.text.isEmpty)
    {
      Utility().toast(context, Message().OtpErr);
    }
    else if (_OtpTF.text.length < 4)
    {
      Utility().toast(context, Message().OtpErrMsg);
    }
    else if (_OtpTF.text != OTPstr)
    {
      Utility().errorToast(context, Message().OtpErrMsg,Colors.red);
    }
    else
    {
      //DO HERE
      SignUpAPI();
    }
  }

  dialogAlert(BuildContext context, String message)
  {
    //AppColors appColors=AppColors();
    Alert(
      context: context,
      title: "Confirmation",
      style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false,
          //backgroundColor: appColors.PRIMARY_COLOR,
          titleStyle: TextStyle(color: Colors.black, fontFamily:"Helvetica Neue"),
          descStyle: TextStyle(color: Colors.black, fontFamily: "Helvetica Neue",fontWeight: FontWeight.w400)),
      desc: message,
      buttons: [
        DialogButton(
          color: AppColor.newSignInColor,
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              //fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: ()
          {
            Navigator.of(context, rootNavigator: true).pop();
            Utility().onLoading(context, false);
            //Navigator.of(context).pop
            Navigator.popUntil(context,ModalRoute.withName('/Login2VC'));
            //Navigator.of(context).popUntil(this.context,ModalRoute.withName('Login2VC'));
            //LoginAPI();
            // Navigator.pop(context);
            //Navigator.of(context).pushNamed('/PhoneVerifyVC'); //TODO
          },
          width: 120,
        ),
      ],
    ).show();
  }
  @override
  Widget build(BuildContext context)
  {
    final formUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _OtpTF,
            cursorColor: AppColor.themeColor,
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3,color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3,color: Colors.grey),
                ),
                hintText: 'Enter 4-digit Code',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 150,
          ),
          RichText(
            text: TextSpan(
              style:
              TextStyle(color: AppColor.newSignInColor),
              children: <TextSpan>[
                TextSpan(
                    text: 'Resend code',
                    //style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = ()
                      {
                       // print('Resend code');
                        OtpAPI();
                       // Utility().toast(context, "Work in-progress");
                      }),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)),
            child: Text(
              "                  Submit                  ",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Helvetica Neue",
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onPressed: ()
            {
              OtpValidation();
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
      //  backgroundColor: AppColor.themeColor,
        flexibleSpace:
        Container(
          height: 100,
          child: SvgPicture.asset("Assets/GreenHeader.svg",
          fit: BoxFit.fill
        ),
      ),

        title: Text(
          "Verify Code",
          style: TextStyle(
              fontFamily: "Helvetica Neue",fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            assetLogo,
            SizedBox(

              height: 100,
            ),
            formUI
          ],
        ),
      ),
    );
  }
}
