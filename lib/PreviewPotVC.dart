import 'package:cashpot/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';
import 'dart:convert';

TextEditingController _potNameTF = new TextEditingController();
TextEditingController _amntPerPersonTF = new TextEditingController();
TextEditingController _goalAmntTF = new TextEditingController();
TextEditingController _endDateTF = new TextEditingController();

class PreviewPotVC extends StatefulWidget {
  @override
  _PreviewPotVCState createState() => _PreviewPotVCState();
}

class _PreviewPotVCState extends State<PreviewPotVC> {
  String nameStr = "";
  String userNameStr = "";
  String profilePicStr = "";
  String potNameStr = "";
  String goalAmount = "";
  String amnperPerson = "";
  String endDateStr = "";
  String statusStr = "0";
  bool status = false;
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
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
        var outputFormat = DateFormat('MM-dd-yyyy');
        var outputDate = outputFormat.format(selectedDate);
        //  print("Selected date------${outputDate}");
        // _endDateTF.text = outputDate;
        setState(() {
          endDateStr = outputDate;
        });
      });
  }

  getUserDeatils() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      nameStr = sharedPreferences.getString("Fname");
      userNameStr = sharedPreferences.getString("UserName");
      potNameStr = sharedPreferences.getString("PotName");
      amnperPerson = sharedPreferences.getString("AmntPerPerson");

      print(amnperPerson);

      goalAmount = sharedPreferences.getString("GoalAmount");
      print(goalAmount);
      endDateStr = sharedPreferences.getString("EndDate");
      _goalAmntTF.text = goalAmount;
      _amntPerPersonTF.text = amnperPerson;
      _potNameTF.text = potNameStr;
      _endDateTF.text = endDateStr;
      if (sharedPreferences.getString("profileImage") != null) {
        profilePicStr = sharedPreferences.getString("profileImage");
      }
    });
  }

  createPotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("amnperPerson------${amnperPerson}");
    print("goal_amount-------${goalAmount}");
    Map body;

    body = {
      "pot_name": potNameStr,
      "amount_per_person": amnperPerson!="" ? amnperPerson:"0",
      "end_date": endDateStr,
      "creator_id": "${sharedPreferences.getString("UserID").toString()}",
      "is_amount_shown": "${sharedPreferences.getString("isShown")
          .toString()}",
      "login_id": "${sharedPreferences.getString("UserID").toString()}",
     "goal_amount": goalAmount!=""?goalAmount:"0",
       "is_shareable": statusStr,
      "users": "${sharedPreferences.getString("contactStr").toString()}",
    };

   // print('data-------------${body}');
    print("${Webservice().apiUrlcashpot}${Webservice().createPot}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().createPot}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES=========${json.decode(response.body).toString()}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    // print("resData-----_${resData}");
    if (resData["status"] == 1) {
      dialogAlert(context, "Pot created successfully");
      //print("API SUCCESS-------");
    } else {
      // print("API Fail-------");
      //  userNumberDataErr = UserNumberDataErr.fromJson(json.decode(response.body));
      Utility().toast(context, "Something went wrong, please try again");
    }
  }

  dialogAlert(BuildContext context, String message) {
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
            // Navigator.of(context).pushNamed("/CashpotDetailVC");
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/HomeVC', (Route<dynamic> route) => false);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () {
      getUserDeatils();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UIcont = Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              height: 80,
              child: Center(
                child: ListTile(
                    leading: CircleAvatar(
                      // backgroundColor: Colors.grey,
                      radius: 28.0,
                      backgroundImage: profilePicStr == ""
                          ? AssetImage('Assets/profiledummy.png')
                          : NetworkImage(profilePicStr),

                      // new AssetImage('Assets/profiledummy.jpg')
                    ),
                    title: Text(
                      "${nameStr}",
                      style: TextStyle(
                          fontFamily: "Helvetica Neue",
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${userNameStr}",style: TextStyle(fontFamily: "Helvetica Neue",),),
                    trailing: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Creator',
                              style: TextStyle(
                                  fontFamily: "Helvetica Neue",
                                  color: Colors.black, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Creator');
                                  // Navigator.of(context).pushNamed('/ProfileVC');
                                }),
                        ],
                      ),
                    )),
              ),
            ),
            Divider(
              height: 2,
              color: Colors.black54,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 75,
              child: Center(
                child: ListTile(
                  leading: SvgPicture.asset("Assets/pots.svg",
                    fit: BoxFit.fill,

                  ),
                  title: Text(
                    "Goal Amount: \$${goalAmount}",
                    style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle(fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                Alert(
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false,
                                    ),
                                    context: context,
                                    title: "Goal Amount",
                                    content: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        TextField(
                                          controller: _goalAmntTF,
                                          decoration: InputDecoration(
                                            prefixText: "\$",
                                            focusedBorder: OutlineInputBorder(
                                              //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                              borderSide:
                                              BorderSide( color: Colors.black26),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                              borderSide:
                                              BorderSide(color: Colors.black26),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            hintText: 'Goal Amount (Optional)',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        color: AppColor.newSignInColor,
                                        onPressed: () {
                                          //validationForgotPsd();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      DialogButton(
                                        color: AppColor.newSignInColor,
                                        onPressed: () {
                                          setState(() {
                                            goalAmount = _goalAmntTF.text;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ]).show();
                              }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 75,
              child: Center(
                child: ListTile(
                  leading: SvgPicture.asset("Assets/reward.svg",
                    fit: BoxFit.fill,
                  ),
                  title: Text(
                    "Amount Per Person: \$${amnperPerson}",
                    style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle(fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                Alert(
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false

                                    ),
                                    context: context,
                                    title: "Amount Per Person (Optional)",
                                    content: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        TextField(
                                          controller: _amntPerPersonTF,
                                          decoration: InputDecoration(
                                            prefixText: "\$",
                                            focusedBorder: OutlineInputBorder(
                                              //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                              borderSide:
                                              BorderSide( color: Colors.black26),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                              borderSide:
                                              BorderSide(color: Colors.black26),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            hintText: 'Amount Per Person',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        color: AppColor.newSignInColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      DialogButton(
                                        color: AppColor.newSignInColor,
                                        onPressed: () {
                                          //validationForgotPsd();
                                          setState(() {
                                            amnperPerson =
                                                _amntPerPersonTF.text;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ]).show();
                              }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 75,
              child: Center(
                child: ListTile(
                  leading: SvgPicture.asset("Assets/PotTagNew01.svg",
                    fit: BoxFit.fill,

                  ),
                  title: Text(
                    "Pot Name: ${potNameStr}",
                    style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle(fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                Alert(
                                    style: AlertStyle(
                                      isCloseButton: false,
                                        isOverlayTapDismiss: false
                                    ),
                                    context: context,
                                    title: "Pot Name",
                                    content: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        TextField(
                                          controller: _potNameTF,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(18),
                                          ],
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                              borderSide:
                                              BorderSide( color: Colors.black26),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              //borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                              borderSide:
                                              BorderSide(color: Colors.black26),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            hintText: 'Pot Name',
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        color: AppColor.newSignInColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      DialogButton(
                                        color: AppColor.newSignInColor,
                                        onPressed: () {
                                          setState(() {
                                            potNameStr = _potNameTF.text;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ]).show();
                              }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 75,
              child: Center(
                child: ListTile(
                  leading: SvgPicture.asset("Assets/cala.svg",
                    fit: BoxFit.fill,
                  ),
                  title: Text(
                    "End Date: ${endDateStr}",
                    style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle(fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                _selectDate(context);
                              }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //color: AppColor.newSignInColor,
              margin: EdgeInsets.only(right: 30, left: 30),
              //height:  MediaQuery.of(context).size.height,
              child: SvgPicture.asset(
                "Assets/sep.svg",
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ) /* add child content here */,
            ),
            Container(
              margin: EdgeInsets.only(right: 25, left: 25, bottom: 15, top: 15),
              child: ListTile(
                leading: Text(
                  "Enable Sharing",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.w500),
                ),
                trailing: Switch(
                  value: status,
                  activeColor: AppColor.newSignInColor,
                  activeTrackColor: AppColor.newSignInColor,
                  inactiveTrackColor: Colors.black12,
                  inactiveThumbColor: AppColor.newSignInColor,
                  onChanged: (value) {
                    setState(() {
                      status = value;
                      if (status == false) {
                        statusStr = "0";
                      } else {
                        statusStr = "1";
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15, left: 15),
              child: Text(
                "Anyone who has this link will be able to request to join this pot.",
                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 14, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, left: 50, top: 20),
              height: 40,
              child: RaisedButton(
                color: AppColor.newSignInColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColor.newSignInColor)),
                child: Text(
                  "Create",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //Navigator.of(context).pushReplacementNamed('/HomeVC');
                  // Navigator.of(context).pushNamed("/CashpotDetailVC");

                  if (potNameStr == "") {
                    Utility().toast(context, Message().potNameMsg);
                  } else {
                    createPotAPI();
                  }
                  //  Utility().toast(context, "Work In-progress");
                },
              ),
            ),
          ],
        ));

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
        title: Text(
          "Preview Pot",
          style: TextStyle(
              fontFamily: "Helvetica Neue", fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      body: UIcont,
    );
  }
}
