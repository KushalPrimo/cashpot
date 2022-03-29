import 'dart:convert';
import 'dart:developer';
import 'package:cashpot/Style/Color.dart';
import 'package:cashpot/networkOperations/NetworkResponse.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Message.dart';
import 'Utility.dart';
import 'WebServices.dart';
import 'package:cashpot/ModelClasses/SignUpData.dart';
import 'dart:io' show Platform;
import 'package:cashpot/networkOperations/NetworkClass.dart';
import 'package:cashpot/Utility.dart';
//import 'package:email_validator/email_validator.dart';

TextEditingController _FirstNameTF = new TextEditingController();
TextEditingController _LastNameTF = new TextEditingController();
TextEditingController _EmailTF = new TextEditingController();
TextEditingController _UserNameTF = new TextEditingController();
TextEditingController _PasswordTF = new TextEditingController();
TextEditingController _ConfirmPasswordTF = new TextEditingController();
const int requestLogin=2;

class EmailSignupVC extends StatefulWidget
{
  @override
  _EmailSignupVCState createState() => _EmailSignupVCState();
}

class _EmailSignupVCState extends State<EmailSignupVC> implements NetworkResponse
{
  bool checkBoxVal = false;
  SigUpData signUpData;
  SigUpErrData signUpErrData;
  String platform = "";
  List<bool> checkFlagsForPassword=[false,false,false,false];
  final register = "users/register";
  final requestRegister = 2;


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
            // Navigator.pop(context);
            Navigator.of(context).pushNamed('/PhoneVerifyVC'); //TODO
          },
          width: 120,
        ),
      ],
    ).show();
  }
  checkExistingEmailAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data =
    {
      "email": _EmailTF.text,
      "username": _UserNameTF.text,
    };
    //print('data-----getbalanceAPI--------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    //log(basicAuth);
    //print("${Webservice().apiUrl}${Webservice().checkdublicate}");
    var response = await http.post("${Webservice().apiUrl}${Webservice().checkdublicate}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====list=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
  // print("resData=========${resData}");
    if (resData["status"] == 1)
    {
      // print("API SUCCESS-------${cardListData.toJson()}");
      sharedPreferences.setString("first_name", "${_FirstNameTF.text.toString()} ${_LastNameTF.text.toString()}");
      //  sharedPreferences.setString("last_name", _LastNameTF.text.toString());
      sharedPreferences.setString("email_Id", _EmailTF.text.toString());
      sharedPreferences.setString("username_Name", _UserNameTF.text.toString());
      sharedPreferences.setString("password", _PasswordTF.text.toString());
      sharedPreferences.setString("Device_Type", platform);
      sharedPreferences.setString("UserPassword", _PasswordTF.text);
      clearFields();

      print("---------Started");
      //dialogAlert(context, "We have sent you an verification email. Click on 'OK' to verify your phone number");
      Navigator.of(context).pushNamed('/PhoneVerifyVC'); //TODO
    }
    else
    {
      Utility().toast(context, "${resData["msg"].toString()}");
    }
  }

  void  callRegisterAPI()
  {
    try
    {
      Map map =
      {
        "first_name": _FirstNameTF.text.toString(),
        "email": _EmailTF.text.toString(),
        //"password": _PasswordTF.text.toString(),
        //"device_token": "Device Token",
      };
      print('----------------- $map');
      NetworkClass.fromNetworkClass(register, this ,requestRegister, map).callPostService(context, true);
    }on Exception catch (e)
    {
      print(e);
    }
  }

  clearFields()
  {
    _FirstNameTF.text = "";
    _LastNameTF.text = "";
    _EmailTF.text = "";
    _UserNameTF.text = "";
    _PasswordTF.text = "";
    _ConfirmPasswordTF.text = "";
    checkBoxVal = false;
  }

  @override
  void initState()
  {
    super.initState();
    // TODO: implement initState
    if (Platform.isAndroid)
    {
      // Android-specific code
      platform = "Android";
    }
    else if (Platform.isIOS)
    {
      // iOS-specific code
      platform = "iOS";
    }
  }
  final assetLogo = Container(
    child: Center(
      child: SvgPicture.asset("Assets/Clogo01.svg",
        fit: BoxFit.fill,
      )
    ),
  );

  signUpValidation() async
  {
    FocusScope.of(context).requestFocus(FocusNode());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_FirstNameTF.text.isEmpty)
      Utility().toast(context, Message().FirstnameErr);
    else if (_FirstNameTF.text.length < 3 || _FirstNameTF.text.length > 20)
      Utility().toast(context, Message().FirstnameCharacter);
   else if (_LastNameTF.text.isEmpty)
     Utility().toast(context, Message().LastnameErr);
   else if (_LastNameTF.text.length < 3 || _LastNameTF.text.length > 20)
     Utility().toast(context, Message().LastnameCharacter);

    else if (_EmailTF.text.isEmpty)
        Utility().toast(context, Message().EmailErr);
    else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_EmailTF.text)==false)
      Utility().toast(context, Message().EmailValid);
    else if (_UserNameTF.text.isEmpty)
      Utility().toast(context, Message().UsernameErr);
    else if(_UserNameTF.text.length < 3 || _UserNameTF.text.length > 20)
      Utility().toast(context, Message().UsernameCharacter);
    else if (checkFlagsForPassword.elementAt(0)==false) //This condition never runs
      Utility().toast(context, Message().PasswordEmpty);
    else if (checkFlagsForPassword.elementAt(1)==false)
      Utility().toast(context, Message().noLetterInPswd);
    else if (checkFlagsForPassword.elementAt(2)==false)
      Utility().toast(context, Message().noNumberInPswd);
    else if (checkFlagsForPassword.elementAt(3)==false)
      Utility().toast(context, Message().noSpecialCharacterInPswd);
    else if (_ConfirmPasswordTF.text.isEmpty)
      Utility().toast(context, Message().PasswordEmpty);
    else if (_PasswordTF.text !=_ConfirmPasswordTF.text)
      Utility().toast(context, Message().PsdMismatchMsg);
    else if (checkBoxVal == false)
      Utility().errorToast(context, Message().TCErrMasg,Colors.red);
    else
    {
      print("ok, ready to go");
      checkExistingEmailAPI();
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final formUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
//  padding:
//  EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _FirstNameTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            inputFormatters: [
              BlacklistingTextInputFormatter(new RegExp(r"\s")),
                LengthLimitingTextInputFormatter(20),
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
                hintText: 'First name',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "First name",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: "Helvetica Neue",
              ),
            ),
          ),
         SizedBox(
           height: 20,
         ),
         TextField(
           controller: _LastNameTF,
           cursorColor: AppColor.themeColor,
           autocorrect: false,
           inputFormatters: [
             BlacklistingTextInputFormatter(new RegExp(r"\s")),
             LengthLimitingTextInputFormatter(20),
           ],
           textCapitalization: TextCapitalization.words,
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
               hintText: 'Last name',
               hintStyle: TextStyle(
                 color: Colors.black54,
                 fontFamily: "Helvetica Neue",
               )),
         ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Last name",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Helvetica Neue",
                  fontSize: 14
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _EmailTF,
            cursorColor: AppColor.themeColor,
            //textCapitalization: TextCapitalization.words,
            autocorrect: false,
            onChanged: (value){print(">>>>>>>>>>>>>>>>>>>>$value");},
            //inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
            style: TextStyle(color: Colors.black, fontFamily: "Helvetica Neue", fontSize: 18),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3,color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31.0)),
                  borderSide: BorderSide(width: 3,color: Colors.grey),
                ),
                hintText: 'email',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            keyboardType: TextInputType.emailAddress,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Never shown to the public",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Helvetica Neue",
                  fontSize: 14
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _UserNameTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            inputFormatters: [BlacklistingTextInputFormatter(
                new RegExp(r"\s")),
              LengthLimitingTextInputFormatter(20),
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
                hintText: 'username',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Unique, no space",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Helvetica Neue",
                  fontSize: 14
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
              controller: _PasswordTF,
              cursorColor: AppColor.themeColor,
              //textCapitalization: TextCapitalization.words,
              autocorrect: false,
              obscureText: true,
              onChanged: (String value)
              {
                if(value==null || value.isEmpty)
                  {
                    for(int i=0;i<checkFlagsForPassword.length-1;i++)
                        checkFlagsForPassword[i]=false;
                  }
                if(value.length>=8)
                  checkFlagsForPassword[0]=true;
                if(value.length<8)
                  checkFlagsForPassword[0]=false;

                for(int i=0;i<=value.length-1;i++)
                  {
                    if(value.codeUnitAt(i)>=97 && value.codeUnitAt(i)<=122 || value.codeUnitAt(i)>=65 && value.codeUnitAt(i)<=90)
                      {
                        checkFlagsForPassword[1]=true;
                        break;
                      }
                    else
                      checkFlagsForPassword[1]=false;
                  }
                for(int i=0;i<=value.length-1;i++)
                {
                  if(value.codeUnitAt(i)>=48 && value.codeUnitAt(i)<=57)
                  {
                    checkFlagsForPassword[2]=true;
                    break;
                  }
                  else
                    checkFlagsForPassword[2]=false;
                }
                for(int i=0;i<=value.length-1;i++)
                {
                  if(value.contains("!") || value.contains("@") || value.contains("#") || value.contains("\$") || value.contains("%") || value.contains("^") || value.contains("&") || value.contains("*") || value.contains("(") || value.contains(")") || value.contains("-") || value.contains("_") || value.contains("=") || value.contains("+") || value.contains("[") || value.contains("]") || value.contains("{") || value.contains("}") || value.contains("|") || value.contains(";") || value.contains(":") || value.contains("'") || value.contains('"') || value.contains(",") || value.contains("<") || value.contains(".") || value.contains(">") || value.contains("?") || value.contains("/") || value.contains("`") || value.contains("~"))
                  {
                    checkFlagsForPassword[3]=true;

                    break;
                  }
                  else
                    checkFlagsForPassword[3]=false;
                }
                // for(int i=0;i<=checkFlagsForPassword.length-1;i++)
                //   print("+++++++++++++${checkFlagsForPassword[i]}");
                //   print("^^^^^^^^^^^^^^^$value");
              },
              //inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
              style: TextStyle(color: Colors.black, fontFamily: "Helvetica Neue", fontSize: 18),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(31.0)),
                    borderSide: BorderSide(width: 3,color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(31.0)),
                    borderSide: BorderSide(width: 3,color: Colors.grey),
                  ),
                  
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black54, fontFamily: "Helvetica Neue")
              )
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "At least 8 characters including a letter, number and symbol.",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Helvetica Neue",
                  fontSize: 14
              ),
            ),
          ),
          ///NEW 11 Nov
          SizedBox(
            height: 20,
          ),
          TextField(
              controller: _ConfirmPasswordTF,
              cursorColor: AppColor.themeColor,
              //textCapitalization: TextCapitalization.words,
              autocorrect: false,
              obscureText: true,
              //inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
              style: TextStyle(color: Colors.black, fontFamily: "Helvetica Neue", fontSize: 18),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(31.0)),
                    borderSide: BorderSide(width: 3,color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(31.0)),
                    borderSide: BorderSide(width: 3,color: Colors.grey),
                  ),
                  hintText: 'Confirm password',
                  hintStyle: TextStyle(color: Colors.black54, fontFamily: "Helvetica Neue",)
              ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "At least 8 characters including a letter, number and symbol.",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Helvetica Neue",
                  fontSize: 14
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: checkBoxVal == false
                        ? Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.black54,
                            size: 25,
                          )
                        : Icon(
                            Icons.check_box,
                            color: Colors.black54,
                            size: 25
                          ),
                    onPressed: ()
                    {
                      if (checkBoxVal == false)
                      {
                        setState(()
                        {
                          checkBoxVal = true;
                        });
                      }
                      else {
                        setState(() {
                          checkBoxVal = false;
                        });
                      }
                    },
                  ),
                ),

                Expanded(
                  child: RichText(
                    //overflow: TextOverflow.clip,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'By checking this box you agree to our ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Helvetica Neue",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: AppColor.newSignInColor,
                              fontSize: 18,
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = ()
                              {
                                Navigator.of(context).pushNamed('/UserAgreementVC');
                                print('Terms of Service"');
                              }),
                        TextSpan(text: ' and ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Helvetica Neue",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColor.newSignInColor,
                              fontSize: 18,
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = ()
                              {
                                Navigator.of(context).pushNamed('/PrivacyPolicyVC');
                                print('Privacy Policy"');
                              }),
                        TextSpan(
                          text: ', as well as our partner ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Helvetica Neue",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                            text: "Dwolla's Terms of Services",
                            style: TextStyle(
                              color: AppColor.newSignInColor,
                              fontSize: 18,
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = ()
                              {
                                Navigator.of(context).pushNamed('/DwollaAgreementsVC');
                                print('Dwolla"s Terms of Services');
                              }),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Helvetica Neue",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColor.newSignInColor,
                              fontSize: 18,
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed('/DwollaPrivacyPolicyVC');
                                print('Privacy Policy"');
                              }),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Helvetica Neue",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColor.newSignInColor),
              shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColor.newSignInColor)
                )
              )
            ) ,
            //color: AppColor.newSignInColor,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(18.0),
            //     side: BorderSide(color: AppColor.newSignInColor)),
            child: Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                "          Agree & Continue          ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.w500),
              ),
            ),
            onPressed: ()
            {
              signUpValidation(); //Navigator.of(context).pushNamed('/PhoneVerifyVC');
            },
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: AppColor.themeColor,
        flexibleSpace:
        Container(
          height: 100,
          child: SvgPicture.asset("Assets/GreenHeader.svg",
          fit: BoxFit.fill,
          ),
        ),

        title: Text(
          "Sign Up",
          style: TextStyle(
              fontFamily: "Helvetica Neue",fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            clearFields();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            assetLogo,
            formUI
          ],
        ),
      ),
    );
  }

  @override
  void onError({Key key, int requestCode, String response})
  {
    try {
      switch (requestCode)
      {
        case requestLogin:
          print(" error in login");
      }
    } on Exception catch (e)
    {
      print("---------------$e");
    }
    ;
  }

  @override
  Future<void> onResponse({Key key, int requestCode, String response}) async
  {
    // TODO: implement onResponse
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try
    {
      switch (requestCode)
      {
        case requestLogin:
          Map<String, dynamic> loginData = jsonDecode(response);
          // print(loginData.toString());
          if (loginData['status'] == 1)
          {
            print("Got the Response Here");
            // setState(()
            // {
            //   loginData = LoginDataModel.fromJson(json.decode(response)).toJson();
            //   //var tempData =  loginData.map.();
            //   print(loginData['data']);
            //   sharedPreferences.setString("UserID", "${loginData["data"]["user_id"]}".toString());
            //   sharedPreferences.setString("LoginID", "${loginData["data"]["user_id"]}".toString());
            //   sharedPreferences.setString("AuthToken", "${loginData["token"].toString()}");
            //   sharedPreferences.setString("UserName", "${loginData["data"]["first_name"].toString()}");
            //   sharedPreferences.setString("EmailID", "${loginData["data"]["email"].toString()}");
            //   sharedPreferences.setString("UserPassword", "${_password.text}");
            //   print(sharedPreferences.getString("EmailID"));
            //   print(sharedPreferences.getString("UserPassword"));
            //   //  print("loginData-----${loginData["email"]}");
            //   // print("login successful");
            // });
            // Navigator.of(context).pushReplacementNamed('/DashbordVC');
            // // Navigator.of(context)
            // //     .pushNamedAndRemoveUntil('/DashbordVC', (Route<dynamic> route) => false);
          }
          else
          {
            print("API fail---------");
            Utility().toast(context, "${loginData["msg"].toString()}");
          }
      }
    } on Exception catch (e) {print("API fail--------- $e");}
  }
}
