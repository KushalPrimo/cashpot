import 'dart:convert';

import 'package:cashpot/Style/Color.dart';
import 'package:cashpot/Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Message.dart';
import '../WebServices.dart';
TextEditingController _CurrentPsdTF = new TextEditingController();
TextEditingController _NewPsdTF = new TextEditingController();
TextEditingController _ConfirmPsdTF = new TextEditingController();
class ChangePasswordVC extends StatefulWidget {
  @override
  _ChangePasswordVCState createState() => _ChangePasswordVCState();
}

class _ChangePasswordVCState extends State<ChangePasswordVC> {
  logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Login2VC', (Route<dynamic> route) => false);
  }
  dialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      title: "Cashpot",
      desc: message,
      style: AlertStyle(
        isCloseButton: false,
      ),
      buttons: [
        DialogButton(
          color: AppColor.newSignInColor,
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white,
              fontFamily: "Helvetica Neue",
                fontSize: 18,
                ),
          ),
          onPressed: () {
            logout();
          },
          width: 120,
        ),

      ],
    ).show();
  }
  ChangePsdAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
      "old_password" : _CurrentPsdTF.text,
      "new_password" : _NewPsdTF.text
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http
        .post("${Webservice().apiUrl}${Webservice().changePassword}", body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        }
    );
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
//     print("Running........");
    if (resData["status"] == 1) {
      _ConfirmPsdTF.text = "";
      _CurrentPsdTF.text = "";
      _NewPsdTF.text = "";
      dialogAlert(context,"Password changed successfully, Please login with new password");

    } else {
      Utility().toast(context, "Something went wrong");
    }
  }
  loginValidation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    FocusScope.of(context).requestFocus(FocusNode());
    if (_CurrentPsdTF.text.isEmpty) {
      Utility().toast(context, Message().currentPSDMsg);
    }else if(_CurrentPsdTF.text != sharedPreferences.getString("UserPassword").toString()){
      Utility().toast(context, Message().currentPsdMismatchMsg);
    }else if (_NewPsdTF.text.isEmpty){
      Utility().toast(context, Message().NewPsdMsg);
    }else if(_ConfirmPsdTF.text.isEmpty){
      Utility().toast(context, Message().ConfirmPsdMsg);
    }else if(_NewPsdTF.text.length < 8){
      Utility().toast(context, Message().PasswordCharacter);
    }else if(_ConfirmPsdTF.text.length < 8){
      Utility().toast(context, Message().PasswordCharacter);
    } else if(_NewPsdTF.text != _ConfirmPsdTF.text){
      Utility().toast(context, Message().PsdMismatchMsg);

    }else{
      //DO HERE
      ChangePsdAPI();
    }

  }
  @override
  Widget build(BuildContext context) {
    final formUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          TextField(
             controller: _CurrentPsdTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
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
                hintText: 'Current Password',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
          ),
          SizedBox(
            height: 50,
          ),
          TextField(
             controller: _NewPsdTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
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
                hintText: 'New Password',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
          ),
          SizedBox(
            height: 50,
          ),
          TextField(
            controller: _ConfirmPsdTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
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
                hintText: 'Confirm Password',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
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
              "                  Save                  ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              loginValidation();
            },
          )
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
        title: Text("Change Password",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),
      body: SingleChildScrollView(
        child: formUI,
      ),
    );
  }
}
