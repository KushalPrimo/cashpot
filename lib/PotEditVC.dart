import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Message.dart';
import 'ModelClasses/CashpotDetailData.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';
TextEditingController _potNameTF = new TextEditingController();
TextEditingController _amntPerPersonTF = new TextEditingController();
TextEditingController _goalAmntTF = new TextEditingController();
TextEditingController _endDateTF = new TextEditingController();
class PotEditVC extends StatefulWidget {
  final String cashpotID;
  final String creatorID;
  const PotEditVC(
      this.cashpotID,
      this.creatorID
      );
  @override
  _PotEditVCState createState() => _PotEditVCState();
}

class _PotEditVCState extends State<PotEditVC> {
  String statusStr = "0";
  bool status = false;
  CashpotDetailData cashpotDetailData;
  String goalAmntStr = "";
  String amntPerPrsnStr = "";
  String potNameStr = "";
  String endDateStr = "";

  String goalAmntStr2 = "";
  String amntPerPrsnStr2 = "";
  String potNameStr2 = "";
  String endDateStr2 = "";

  var tempDatainfo;
  String creatorNameStr = "";
  String creatorUserNameStr = "";
  String profilePicStr = "null";
  String isamntshown = "0";
  String potnamekeyStr = "0";
  String goalamountkeyStr = "0";
  String amountperersonkeyStr = "0";
  String end_datekeyStr = "0";
  DateTime selectedDate = DateTime.now();

  String creatorID = "";
  String UserIDStr = "";

  String pottotalAmountDeposited = "";
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
  getUserCashpotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "cashpot_id":
      "${widget.cashpotID}",
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().cashpotinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
      setState(() {
        cashpotDetailData =
            CashpotDetailData.fromJson(json.decode(response.body));
        //  print("RES----cashpotDetailData------${cashpotDetailData.toJson()}");
      var tempData = cashpotDetailData.data.toJson();
       // print("tempData--------${tempData}");

        tempDatainfo = tempData["cashpot_info"];
        pottotalAmountDeposited = tempDatainfo["pot_total_amount"].toString();
        print("pottotalAmountDeposited-------${pottotalAmountDeposited}");
        potNameStr = tempDatainfo["pot_name"].toString();
        goalAmntStr = tempDatainfo["goal_amount"].toString();

        amntPerPrsnStr = tempDatainfo["amount_per_person"].toString();
        print("amntPerPrsnStr------${amntPerPrsnStr}");
        endDateStr = tempDatainfo["end_date"].toString();
        //
        potNameStr2 = tempDatainfo["pot_name"].toString();
        goalAmntStr2 = tempDatainfo["goal_amount"].toString();
        amntPerPrsnStr2 = tempDatainfo["amount_per_person"].toString();
        endDateStr2 = tempDatainfo["end_date"].toString();
        //
        isamntshown = tempDatainfo["is_amount_shown"].toString();
        _goalAmntTF.text = goalAmntStr == "0"? "": goalAmntStr;
        _amntPerPersonTF.text = amntPerPrsnStr == "0"? "":amntPerPrsnStr;
        _potNameTF.text = potNameStr;
        _endDateTF.text = endDateStr;
        statusStr = tempDatainfo["is_shareable"].toString();
      //  print("statusStr--------${statusStr}");
         tempDatainfo["is_shareable"].toString() == "0" ? status = false:status = true;
      });
     // print("tempDatainfo--------${tempDatainfo}");


    } else {
      Utility().toast(context, "Something went wrong");
    }
  }
  getCreatorDetailsAPI() async {
   // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  UserIDStr = sharedPreferences.getString("UserID").toString();
    Map data = {
      "cashpot_id":
      "${widget.cashpotID}",
      "login_id": sharedPreferences.getString("UserID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
    };

    // print('data-------vvv------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().creatorcashpotinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //print("RES=========${json.decode(response.body) as Map}");
   // Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
//print("resData=========${resData}");
    if (resData["status"] == 1) {
setState(() {
  profilePicStr = resData["data"]["image"].toString();
  creatorID = resData["data"]["user_id"].toString();
  creatorNameStr = resData["data"]["name"].toString();
  creatorUserNameStr = "@${resData["data"]["username"].toString()}";
});
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  editPotAPI() async {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
setState(() {
  if(goalAmntStr2 != goalAmntStr){
    //goalAmntStr
    goalamountkeyStr = "1";
  }
  if(amntPerPrsnStr2 != amntPerPrsnStr){
    //_amntPerPersonTF.text
    amountperersonkeyStr = "1";
  }
  if(potNameStr2 != _potNameTF.text){
    potnamekeyStr = "1";
    print("potnamekeyStr----${potnamekeyStr}");
  }
  if(endDateStr2 != endDateStr){
    end_datekeyStr = "1";
  }
});
    Map data;
    data = {
      "cashpot_id": "${widget.cashpotID}",
      "login_id": sharedPreferences.getString("UserID").toString(),
      "user_id": sharedPreferences.getString("UserID").toString(),
      "pot_name": potNameStr,
      "amount_per_person": amntPerPrsnStr !="0"?amntPerPrsnStr:"0",
      "end_date": endDateStr,
      "is_amount_shown": isamntshown,
      "goal_amount": goalAmntStr!="0"?goalAmntStr:"0",
      "is_shareable": statusStr,
      "pot_name_key": potnamekeyStr,
      "goal_amount_key": goalamountkeyStr,
      "amount_per_person_key": amountperersonkeyStr,
      "end_date_key": end_datekeyStr
    };

  //  print('data-------editpot------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    // print("URL------${Webservice().apiUrlPayment}${Webservice().checkdwollacustomer}");
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().editCashpot}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
  //  print("RES=========${json.decode(response.body) as Map}");
    // Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

    if (resData["status"] == 1) {
     //DO HERE

      dialogAlert(context,"Pot updated succesfully");

    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  editPotValidation(){
    if (potNameStr == "") {
      Utility().toast(context, Message().potNameMsg);
    }
    else if (potNameStr.length < 3 || potNameStr.length > 18) {
      //Do Here
      Utility().toast(context, Message().PotnameCharMsg);
    } else if(int.parse(goalAmntStr) < int.parse(pottotalAmountDeposited) ){
      Utility().toast(context, "Goal amount should not less than the deposited amount in the pot");
    }
    else if(goalAmntStr != "0" && amntPerPrsnStr != "0"){
      if(int.parse(goalAmntStr) < int.parse(amntPerPrsnStr)){
        Utility().toast(context, "Goal amount should not less than amount per person");
      }
      else {
        //DO HERE Call API
        editPotAPI();
      }
    }
    else {
      editPotAPI();
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
        isOverlayTapDismiss: false
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
            Navigator.pop(context, true);
           //
            // Navigator.of(context).pushNamed("/CashpotDetailVC");

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
      getUserCashpotAPI();
      getCreatorDetailsAPI();
    });

    super.initState();
  }
  Future<void> share() async {
    print("share-----");
    await FlutterShare.share(
        title: 'Cashpot',
        text: 'You recieved ${potNameStr} request from ${creatorUserNameStr}',
        linkUrl: 'https://www.cashpotus.com',
       /// chooserTitle: 'Example Chooser Title'
    );
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
                      backgroundImage: profilePicStr == "null"
                          ? AssetImage('Assets/profiledummy.png')
                          : NetworkImage(profilePicStr),

                      // new AssetImage('Assets/profiledummy.jpg')
                    ),
                    title: Text(
                      "${creatorNameStr}",
                      style: TextStyle(
                          fontFamily: "Helvetica Neue", fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${creatorUserNameStr}"),
                    trailing: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Creator',
                              style: TextStyle(
                                  fontFamily: "Helvetica Neue",color: Colors.black, fontSize: 18),
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
                    goalAmntStr != "0" ?
                    "Goal Amount: \$${goalAmntStr}":
                    "Goal Amount:",
                    style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: UserIDStr == creatorID ? RichText(
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
                                    context: context,
                                    title: "Goal Amount (Optional)",
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false
                                    ),
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
                                            hintText: 'Goal Amount',
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
                                            goalAmntStr = _goalAmntTF.text;

                                          });
                                         // print("goalAmntStr----${goalAmntStr}  ${goalamountkeyStr}");
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
                  ):
                  Container(width: 1),

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
                    amntPerPrsnStr != "0"?
                    "Amount Per Person: \$${amntPerPrsnStr}":
                    "Amount Per Person:"
                    ,
                    style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: UserIDStr == creatorID? RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle( fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                Alert(
                                    context: context,
                                    title: "Amount Per Person (Optional)",
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false
                                    ),
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
                                            amntPerPrsnStr =
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
                  ):
                  Container(width: 1,),
                ),
              ),
            ),
            Container(
              height: 75,
              child: Center(
                child: ListTile(
                  leading: SvgPicture.asset("Assets/newTag.svg",
                    fit: BoxFit.fill,

                  ),
                  title: Text(
                    "Pot Name: ${potNameStr}",
                    style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: UserIDStr == creatorID? RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle( fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                Alert(
                                    context: context,
                                    title: "Pot Name",
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false

                                    ),
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
                                            fontFamily: "Helvetica Neue",
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ]).show();
                              }),
                      ],
                    ),
                  ):
                  Container(width: 1,),
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
                    style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black),
                  ),
                  trailing: UserIDStr == creatorID? RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Edit',
                            style:
                            TextStyle( fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Edit');
                                // Navigator.of(context).pushNamed('/ProfileVC');
                                _selectDate(context);
                              }),
                      ],
                    ),
                  ):
                  Container(width: 1,),
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
           UserIDStr == creatorID? Container(
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
                  activeColor: AppColor.newSignInColor,
                  activeTrackColor: AppColor.newSignInColor,
                  inactiveTrackColor: Colors.black12,
                  inactiveThumbColor: AppColor.newSignInColor,
                  value: status,
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
            ):
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Anyone who has this link will be able to request to join this pot.",
                      style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 13, color: Colors.black45),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                   //
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all( 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.newSignInColor)
                        ),
                        child: Text(
                          "Share Pot",
                          style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 14, color: AppColor.newSignInColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: statusStr !="0"?share:null,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, left: 50, top: 50),
              height: 40,
              child: RaisedButton(
                color: AppColor.newSignInColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColor.newSignInColor)),
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //Navigator.of(context).pushReplacementNamed('/HomeVC');
                  // Navigator.of(context).pushNamed("/CashpotDetailVC");
                  editPotValidation();
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
          "Pot Detail",
          style: TextStyle(
              fontFamily: "Helvetica Neue",fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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

