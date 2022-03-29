import 'dart:async';
import 'dart:convert';
import 'package:cashpot/ModelClasses/CashpotMembersData.dart';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ContactNewClientVC.dart';
import '../ContactNewVC.dart';
import '../ContactVC.dart';
import '../Utility.dart';
import '../WebServices.dart';

class MembersVC extends StatefulWidget
{
  final String cashpotID;
  final String creatorID;
  const MembersVC(this.cashpotID, this.creatorID);
  @override
  _MembersVCState createState() => _MembersVCState();
}

class _MembersVCState extends State<MembersVC>
{
  String profilePicStr = "";
  CashpotMembersData cashpotMembersData;
  var memberListAry = [];
  String UserID = "";
  String cashpotUserIdStr = "";
  MemberListAPI() async
  {
    Utility().onLoading(context, true);
    var sharedPreferences = await SharedPreferences.getInstance();
    Map data =
    {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_id": widget.cashpotID
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().cashpotmembers}",
        body: data,
        headers: <String, String>
        {
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
    Utility().onLoading(context, false);
    if (resData["status"] == 1)
    {
      print("API SUCCESS-------");
      cashpotMembersData =
          CashpotMembersData.fromJson(json.decode(response.body));
      //  print("API cashpotMembersData-------${cashpotMembersData.toJson()}");
      var tempdata = cashpotMembersData.toJson();
      setState(() {
        UserID = sharedPreferences.getString("UserID").toString();
        memberListAry = tempdata["data"];
      });
      print("memberListAry-------${memberListAry}");
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

  removePotMemberAPI(String cashpot_user_id) async
  {
    Utility().onLoading(context, true);
    var sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
      "cashpot_user_id": cashpot_user_id
    };
   // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().removecashpotmember}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
   // print("API SUCCESS-------${resData}");
    Utility().onLoading(context, false);
    if (resData["status"] == 1) {
      Timer(Duration(seconds: 1), () {
        //print("Yeah, this line is printed after 3 seconds");
         MemberListAPI();
      });

      // print("memberListAry-------${memberListAry}");
    } else {
      Utility().toast(context, "Something went wrong");
    }
  }
  removeDialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      // type: AlertType.success,
      title: "Do you want to remove this member?",
      desc: message,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),
      buttons: [
        DialogButton(
          color: AppColor.newSignInColor,
          child: Text(
            "YES",
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
            removePotMemberAPI(cashpotUserIdStr);
           // Navigator.of(context).pushNamed('/PaymentOptionVC');
          },
          width: 120,
        ),
        DialogButton(
          color: AppColor.newSignInColor,
          child: Text(
            "NO",
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
          },
          width: 120,
        ),
      ],
    ).show();
  }
  @override
  void initState() {
    // TODO: implement initState
    // print("sdfghjkl-----${widget.creatorID}");
    Future.delayed(Duration.zero, () {
      MemberListAPI();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabbarCont = Container(
      //color: Colors.red,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              )),
              child: Center(
                child: FlatButton(
                  child: Text(
                    "Members",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: "Helvetica Neue"),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            width: 1,
            color: Colors.black12,
          ),
          Flexible(
            flex: 5,
            child: Container(
              //color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              )),
              child: Center(
                child: FlatButton(
                  child: Text(
                    "Requests",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: "Helvetica Neue"),
                  ),
                  onPressed: () {
                    Utility().toast(context, "Coming soon, after first version");
                    //  Navigator.of(context).pushNamed('/RequestMemVC');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final memberListCont = Container(
      height: 700,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: memberListAry.length != 0
          ? ListView.builder(
              itemCount: memberListAry.length,
              itemBuilder: (context, index) {
                profilePicStr = memberListAry[index]["image"].toString();
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("${memberListAry[index]["name"]}",style: TextStyle(fontFamily: "Helvetica Neue"),),
                        subtitle: Text("@${memberListAry[index]["username"]}",style: TextStyle(fontFamily: "Helvetica Neue")),
                        leading: CircleAvatar(
                          // backgroundColor: Colors.grey,
                          radius: 28.0,
                          backgroundImage: profilePicStr == "null"
                              ? AssetImage('Assets/profiledummy.png')
                              : NetworkImage(profilePicStr),
                        ),
                        trailing: widget.creatorID == UserID
                            ? RichText(
                                text: TextSpan(
                                  //text: 'Hello ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Remove ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: "Helvetica Neue",
                                            fontWeight: FontWeight.w600),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            cashpotUserIdStr =  memberListAry[index]
                                            ["cashpot_user_id"]
                                                .toString();
                                            removeDialogAlert(context,"Doing so will permanently remove individual from pot. Funds not requested or sent will be returned to the member personal pot" );



                                          }
                                    )   // print('remove Clicked');

                                  ],
                                ),
                              )
                            : Text(""),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 2,
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "No member found",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica Neue",
                    color: Colors.black54),
              ),
            ),
    );
    return Scaffold(
      appBar: new AppBar(
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: new Text("Members",style: TextStyle(fontFamily: "Helvetica Neue"),),
        actions: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                )
              ],
            ),
            onTap: () {
              print("Add member Clicked");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactNewVC(
                        widget.cashpotID,
                      )));
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[tabbarCont, memberListCont],
        ),
      ),
    );
  }
}
