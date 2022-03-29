import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ModelClasses/PersonalWalletData.dart';
import 'Utility.dart';
import 'WebServices.dart';

class PersonalWalletActivityVC extends StatefulWidget {
  @override
  _PersonalWalletActivityVCState createState() =>
      _PersonalWalletActivityVCState();
}

class _PersonalWalletActivityVCState extends State<PersonalWalletActivityVC> {
  PersonalWalletData personalWalletData;
  var tempDict = [];
  String profilePicStr = "";

  getWalletActAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_id": sharedPreferences.getString("UserID").toString(),
      "login_id": sharedPreferences.getString("UserID").toString(),
    };
    print('data-------------${data}');
    print("${Webservice().apiUrlPayment}${Webservice().walletactivity}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().walletactivity}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    // print("RES====vvv=====${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    print("RES====vvv=====${resData}");
    if (resData["status"] == 1) {
      setState(() {
        personalWalletData =
            PersonalWalletData.fromJson(json.decode(response.body));
       // print("Running........${personalWalletData.toJson()}");

        tempDict = personalWalletData.toJson()["data"];
        print("Running...data.....${tempDict}");
      });
      print("API SUCCESS-------");
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      getWalletActAPI();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifiList = Container(
        height: MediaQuery.of(context).size.height,
        child: tempDict.length != 0
            ? ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: tempDict.length, //entries.length,
                itemBuilder: (BuildContext context, int index) {
                  profilePicStr = '${tempDict[index]["profile_pic"]}';
                  return Column(
                    children: <Widget>[
                      InkWell(
                        child: ListTile(
                            title: Text(
                              '${tempDict[index]["msg"]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Helvetica Neue",
                                  fontSize: 13,
                                  color: Colors.black),
                              maxLines: 2,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: profilePicStr == "null"
                                  ? AssetImage('Assets/profiledummy.png')
                                  : NetworkImage(profilePicStr),
                            ),
                            trailing:
                                tempDict[index]["transaction_type"] == "DEBIT"
                                    ? Text(
                                        '-\$${tempDict[index]["amount"]}.00',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            fontFamily: "Helvetica Neue",
                                            color: Colors.red),
                                      )
                                    : Text(
                                        '\$${tempDict[index]["amount"]}.00',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            fontFamily: "Helvetica Neue",
                                            color: Colors.green),
                                      )),
                        onTap: () {
                          // Navigator.of(context).pushNamed('/HistoryDetailVC');
                        },
                      ),
                    ],
                  );
                })
            : Container(
                margin: EdgeInsets.only(right: 15, left: 10, top: 15),
                child: Text(
                  "No Activity",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
              ));
    return Scaffold(
      appBar: AppBar(
        //  backgroundColor: AppColor.themeColor,
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: Text("Wallet Activity"),
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
        child: Column(
          children: <Widget>[
            notifiList,
          ],
        ),
      ),
    );
  }
}
