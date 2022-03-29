import 'dart:convert';
import 'dart:developer';

import 'package:cashpot/ModelClasses/PotActivityData.dart';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Utility.dart';
import '../WebServices.dart';

class PotActivityVC extends StatefulWidget {
  final String cashpotId;
  const PotActivityVC(
    this.cashpotId,
  );

  @override
  _PotActivityVCState createState() => _PotActivityVCState();
}

class _PotActivityVCState extends State<PotActivityVC> {
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String profilePicStr = "";
  PotActivityData potActivityData;
  var potActivityDict = [];
  var userIDstr = "";

  potActivityAPI() async {
     Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
      "cashpot_id": widget.cashpotId,
    };
   // print('data-------------${data}');
   //   print("${Webservice().apiUrlcashpot}${Webservice().potactivitylog}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().potactivitylog}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
     Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //print("resData-----_${resData}");
    if (resData["status"] == 1) {
      setState(() {
        userIDstr = sharedPreferences.getString("UserID").toString();
        potActivityData = PotActivityData.fromJson(json.decode(response.body));
       // print("profileData-------${potActivityData.toJson()["data"]}");
        potActivityDict = potActivityData.toJson()["data"];
      });

    //  log("potActivityDict--data---${potActivityDict}");
    } else {
      // profileErrorData = ProfileErrorData.fromJson(json.decode(response.body));
      Utility().toast(context, "Something went wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      potActivityAPI();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final potActivityListCont = Container(
        height: MediaQuery.of(context).size.height,
       // padding: EdgeInsets.only(top: 10, bottom: 10),
        child: potActivityDict.length != 0?
        ListView.builder(
          itemCount: potActivityDict.length,
          itemBuilder: (context, index) {
            profilePicStr =  potActivityDict[index]["image"].toString();
         //   print(potActivityDict[index]["image"].toString());
            String balanceStr = potActivityDict[index]["amount"].toString();
            if(balanceStr != "null"){
             // print("balanceStr-----${balanceStr}");
              var potAmountInttt = int.parse("${balanceStr}");
              final oCcy =
              new NumberFormat("#,##0.00", "en_US");
              balanceStr = oCcy.format(potAmountInttt).toString();
            }
            return
              Column(
                children: <Widget>[
                  potActivityDict[index]["user_id"].toString() == userIDstr?
                  potActivityDict[index]["status"].toString() == "0"?
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide( //                    <--- top side
                            color: Colors.black,
                            width: 0.3,
                          ),
                        )
                    ),
                    child: ListTile(
                        title:Html(data:"${potActivityDict[index]["message"].toString()}",
                          defaultTextStyle: TextStyle(fontSize: 14),
                        ),
                        leading: CircleAvatar(
                          // backgroundColor: Colors.grey,
                          radius: 28.0,
                          backgroundImage: profilePicStr == "null"
                              ? AssetImage('Assets/profiledummy.png')
                              : NetworkImage(profilePicStr),
                        ),
                        trailing: Container(
                          //width: 90,
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${potActivityDict[index]["time_difference"].toString()}",
                                style: TextStyle(fontSize: 13,fontFamily: "Helvetica Neue"),
                              ),
//                          SizedBox(
//                            width: 5,
//                          ),
                              potActivityDict[index]["amount"] != null ?
                              potActivityDict[index]["transaction_type"] == 0?
                              Text(
                                "-\$${balanceStr}",
                                style: TextStyle(fontSize: 13, color: Colors.red,fontFamily: "Helvetica Neue"),
                              ):
                              Text(
                                "\$${balanceStr}",
                                style: TextStyle(fontSize: 13, color: AppColor.newSignInColor,fontFamily: "Helvetica Neue"),
                              )
                                  :
                              Text(""),
                            ],
                          ),
                        )),
                  ):Container()
                      : potActivityDict[index]["status"].toString() == "1"?
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide( //                    <--- top side
                            color: Colors.black,
                            width: 0.3,
                          ),
                        )
                    ),
                    child: ListTile(
                        title:Html(data: "${potActivityDict[index]["message"].toString()}",
                          defaultTextStyle: TextStyle(fontSize: 14),
                        ),

                        leading: CircleAvatar(
                          // backgroundColor: Colors.grey,
                          radius: 28.0,
                          backgroundImage: profilePicStr == "null"
                              ? AssetImage('Assets/profiledummy.png')
                              : NetworkImage(profilePicStr),
                        ),
                        trailing: Container(
                          //width: 90,
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${potActivityDict[index]["time_difference"].toString()}",
                                style: TextStyle(fontSize: 13,fontFamily: "Helvetica Neue"),
                              ),
//                          SizedBox(
//                            width: 5,
//                          ),
                              potActivityDict[index]["amount"] != null ?
                              potActivityDict[index]["transaction_type"] == 0?
                              Text(
                               // "-\$${potActivityDict[index]["amount"].toString()}.00",
                                "-\$${balanceStr}",
                                style: TextStyle(fontSize: 13, color: Colors.red,fontFamily: "Helvetica Neue"),
                              ):
                              Text(
                                "\$${balanceStr}",
                                style: TextStyle(fontSize: 13, color: AppColor.newSignInColor,fontFamily: "Helvetica Neue"),
                              ):
                              Text(""),
                            ],
                          ),
                        )),
                  ): Container(),
                  SizedBox(
                    height: 0,
                  ),

                ],
              );
           // );
          },
        ):
        Center(
          child: Text("No pot activity",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: "Helvetica Neue"
            ),
          ),
        )

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

          title: Text("Pot Activity",style: TextStyle(fontFamily: "Helvetica Neue"),),
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
        body: potActivityListCont);
  }
}
