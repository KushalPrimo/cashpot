import 'dart:convert';
import 'package:cashpot/ModelClasses/HistoryListData.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'HistoryDetailVC.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';

class HistoryVC extends StatefulWidget {
  @override
  _HistoryVCState createState() => _HistoryVCState();
}

class _HistoryVCState extends State<HistoryVC> {
HistoryListData historyListData;
  var HistoryListDataAry = [];
  String nameStr = "";
  String userNameStr = "";
  String profilePicStr = "null";
  historyAPI() async {
     Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
    };
   //  print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().potHistory}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
    //print("resData-----_${resData}");
     Utility().onLoading(context, false);
    if (resData["status"] == 1) {
      setState(() {
        historyListData = HistoryListData.fromJson(json.decode(response.body));
        var tempdata = historyListData.toJson();
        HistoryListDataAry = tempdata["data"]["user_pots"];
        nameStr =  tempdata["data"]["user_info"]["name"];
        userNameStr = tempdata["data"]["user_info"]["username"];
        profilePicStr = tempdata["data"]["user_info"]["image"].toString();
      //  print("historyListData data-------$tempdata}");
      });


    } else {
      Utility().toast(context, "Something went wrong");
    }
  }

@override
  void initState() {
    // TODO: implement initState
  Future.delayed(Duration.zero, () {
   historyAPI();
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final upperCont = Container(
      child: ListTile(
          leading: CircleAvatar(
              radius: 28.0,
              backgroundImage:  profilePicStr == "null"
                  ? AssetImage('Assets/profiledummy.png')
                  : NetworkImage(profilePicStr),

          ),
          title: Text(
            "${nameStr}",
            style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("@${userNameStr}",style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 16, fontWeight: FontWeight.w300),),
          trailing: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Transactions',
                    style: TextStyle(color: AppColor.newSignInColor, fontSize: 16),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                       // Navigator.of(context).pushNamed('/TransactionHistoryVC');
                        Navigator.of(context).pushNamed('/TransactionOptionListVC');
                      }),
              ],
            ),
          )),
    );
    final historyList = Container(
      height: MediaQuery.of(context).size.height-200,
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 8,bottom: 8),
          itemCount: HistoryListDataAry.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Divider(
                 // width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: Colors.black54,
                ),
                InkWell(
                  child: Container(
                     // height: 75,
                      //color: Colors.amber[colorCodes[index]],
                      child: ListTile(
                        title: Text('${HistoryListDataAry[index]["pot_name"]}',style: TextStyle(fontFamily: "Helvetica Neue"),),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: AppColor.menuItemColor,
                          size: 40,
                        ),

                      ),

                      ),
                  onTap: (){
                   // Navigator.of(context).pushNamed('/HistoryDetailVC');
                   // print(HistoryListDataAry[index]["cashpot_id"].toString());
                   // print(HistoryListDataAry[index]["pot_name"].toString());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HistoryDetailVC(
                          "${HistoryListDataAry[index]["cashpot_id"].toString()}",
                            '${HistoryListDataAry[index]["pot_name"].toString()}'
                        )));
                  },
                ),
              ],
            );
          }),
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
        title: Text("History",style: TextStyle(fontFamily: "Helvetica Neue"),),
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
          children: <Widget>[upperCont, historyList],
        ),
      ),
    );
  }
}
