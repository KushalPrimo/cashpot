import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Message.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';

TextEditingController _EmailTF = new TextEditingController();

class ForgotPasswordVC extends StatefulWidget {
  @override
  _ForgotPasswordVCState createState() => _ForgotPasswordVCState();
}

class _ForgotPasswordVCState extends State<ForgotPasswordVC> {
  final assetLogo = Container(
    child: Center(
      child: SvgPicture.asset("Assets/Clogo01.svg",
        fit: BoxFit.fill,
      )
    ),
  );

  dialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      // type: AlertType.success,
      title: "Cashpot",
      desc: message,
      buttons: [
        DialogButton(
          color: AppColor.themeColor,
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
            setState(() {
              _EmailTF.text = "";
            });
            //
          },
          width: 120,
        ),
      ],
    ).show();
  }

  forgotPsdAPI() async {
    Utility().onLoading(context, true);
    Map data = {
      'email': _EmailTF.text,
    };
    //  print('data-------------${data}');
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().forgetpassword}",
        body: data);
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    print('data-------------${resData}');
    if (resData["status"] == 1) {
      dialogAlert(context, "Password sent to your email address");
    } else {
      Utility().toast(context, "email address was not found");
    }
  }

  emailValidation() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_EmailTF.text.isEmpty) {
      Utility().toast(context, Message().EmailErr);
    } else if (!_EmailTF.text.contains("@") || !_EmailTF.text.contains(".")) {
      Utility().toast(context, Message().EmailValid);
    } else {
      forgotPsdAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _EmailTF,
            cursorColor: AppColor.themeColor,
            autocorrect: false,
            inputFormatters: [BlacklistingTextInputFormatter(
                new RegExp(r"\s")
            )],
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Enter your email',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)),
            child: Text(
              "                Send Password                ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
//              Navigator.of(context).pushNamed('/PhoneVerifyVC');
              emailValidation();
            },
          )
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
            fit: BoxFit.fill,
          ),
        ),

        title: Text("Forgot Password",style: TextStyle(fontFamily: "Helvetica Neue",),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            assetLogo,
            SizedBox(
              height: 20,
            ),
            formUI
          ],
        ),
      ),
    );
  }
}
