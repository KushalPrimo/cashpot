import 'dart:convert';
import 'package:cashpot/Message.dart';
import 'package:cashpot/Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ModelClasses/CardTokenData.dart';
import 'ModelClasses/GetTokenData.dart';
import 'PaymentWebCardVC.dart';
import 'PaymentWebVC.dart';
import 'Style/Color.dart';
import 'package:http/http.dart' as http;
import 'WebServices.dart';
TextEditingController _AccountTypeTF = new TextEditingController();
TextEditingController _AddressTF = new TextEditingController();
TextEditingController _CityTF = new TextEditingController();
TextEditingController _StateTF = new TextEditingController();
TextEditingController _PostalCodeTF = new TextEditingController();
TextEditingController _DobTF = new TextEditingController();
TextEditingController _SsnTF = new TextEditingController();

class CreateCustomerVC extends StatefulWidget {
  final String accountcheck;
  const CreateCustomerVC(
      this.accountcheck,
      );
  @override
  _CreateCustomerVCState createState() => _CreateCustomerVCState();
}

class _CreateCustomerVCState extends State<CreateCustomerVC> {
  GetTokenData getTokenData;
  CardTokenData cardTokenData;
  DateTime selectedDate = DateTime.now();
bool _isVisible = false;
  @override
  getIavTokenAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {

      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),

    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().getIavToken}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    getTokenData = GetTokenData.fromJson(json.decode(response.body));
//     print("Running........");
    if (resData["status"] == 1) {

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentWebVC(
            "${getTokenData.token}",

          )));
      print("API SUCCESS-------");

    } else{
      Utility().toast(context, "Something went wrong.");
    }
  }
  getIavTokenCardAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {

      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),

    };
    print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().getiavtokencard}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    cardTokenData = CardTokenData.fromJson(json.decode(response.body));
//     print("Running........");
    if (resData["status"] == 1) {

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentWebCardVC(
            "${cardTokenData.token}",

          )));
      print("API SUCCESS-------");

    } else{
      Utility().toast(context, "Something went wrong.");
    }
  }
  CreateCustomerAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'first_name': sharedPreferences.getString("Fname").toString(),
      'last_name': sharedPreferences.getString("Fname").toString(),
      'email': sharedPreferences.getString("emailID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "account_type": _AccountTypeTF.text,
      "address": _AddressTF.text,
      "city": _CityTF.text,
      "state": _StateTF.text.toUpperCase(),
      "postal_code": _PostalCodeTF.text,
      "date_of_birth": _DobTF.text,
      "ssn": _SsnTF.text
    };
    //  print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().createdwollacustomer}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });

    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
   // print("RES======sss===${resData["msg"].toString()}");
    if (resData["status"] == 1) {
       print("API SUCCESS-------");
       if(widget.accountcheck == "Bank"){
         getIavTokenAPI();
       }else{
         getIavTokenCardAPI();
       }

    } else {
      Utility().toast(context, "${resData["msg"].toString()}");
    }
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      //initialEntryMode: DatePickerEntryMode.input,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xff0A5C2F),
              onSurface: Color(0xff0A5C2F),

            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var outputFormat = DateFormat('yyyy-MM-dd');
        var outputDate = outputFormat.format(selectedDate);
        //print("Selected date------${outputDate}");
        _DobTF.text = outputDate;
      });
  }
  CreateCustomerValidation() async {
    FocusScope.of(context).requestFocus(FocusNode());
     if (_AccountTypeTF.text.isEmpty) {
      Utility().toast(context, Message().accountTypeMsg);
    } else if (_AddressTF.text.isEmpty) {
      Utility().toast(context, Message().addressMsg);
    } else if (_CityTF.text.isEmpty) {
      Utility().toast(context, Message().cityMsg);
    } else if (_StateTF.text.isEmpty) {
      Utility().toast(context, Message().stateMsg);
    } else if (_PostalCodeTF.text.isEmpty) {
      Utility().toast(context, Message().postalCodeMsg);
    } else if (_DobTF.text.isEmpty) {
      Utility().toast(context, Message().dobMsg);
    } else if (_SsnTF.text.isEmpty) {
      Utility().toast(context, Message().ssnMsg);
    } else if (_SsnTF.text.length < 4) {
       //Do Here
       Utility().toast(context, Message().ssnCharMsg);
     }
     else {
      //DO HERE
      CreateCustomerAPI();
     //   Navigator.of(context).pushNamed('/AddCardVC');
    }
  }

  Widget build(BuildContext context) {
    final CustContUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _AccountTypeTF,
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
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Account Type',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            readOnly: true,
            onTap: (){
              setState(() {
                _isVisible = true;
              });
            },
          ),

          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey, spreadRadius: 1),
                ],
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Personal",style: TextStyle(fontFamily: "Helvetica Neue",),),
                    onTap: (){
                      print("Personal");
                      setState(() {
                        _isVisible = false;
                        _AccountTypeTF.text = "Personal";
                      });
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    title: Text("Business",style: TextStyle(fontFamily: "Helvetica Neue",),),
                    onTap: (){
                      print("Business");
                      setState(() {
                        _isVisible = false;
                        _AccountTypeTF.text = "Business";
                      });
                    },
                  ),

                ],
              ),
            ),
          ),

          TextField(
            controller: _AddressTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Address',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            // obscureText: true
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _CityTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'City',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            // obscureText: true
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _StateTF,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'State',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            // obscureText: true
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _PostalCodeTF,

            cursorColor: AppColor.themeColor,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Zip Code',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            // obscureText: true
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _DobTF,
            cursorColor: AppColor.themeColor,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Date of Birth',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            // obscureText: true
            readOnly: true,
            onTap: (){
              print("CLICKED");
              _selectDate(context);
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _SsnTF,
            cursorColor: AppColor.themeColor,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'SSN',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            // obscureText: true
          ),
          SizedBox(
            height: 40,
          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)),
            child: Text(
              "                  Create                 ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
            //  Navigator.of(context).pushNamed('/AddCardVC');
              CreateCustomerValidation();
            },
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
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

          title: Text("Create Account",style: TextStyle(fontFamily: "Helvetica Neue",),),
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
        ),
        body: SingleChildScrollView(
          child: CustContUI,
        ));
  }
}
