import 'dart:convert';
import 'package:cashpot/ModelClasses/HistoryDetailData.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';
class HistoryDetailVC extends StatefulWidget {
  final String cashpotId;
  final String NameStr;
  const HistoryDetailVC(
      this.cashpotId,
      this.NameStr,
      );

  @override
  _HistoryDetailVCState createState() => _HistoryDetailVCState();
}

class _HistoryDetailVCState extends State<HistoryDetailVC> {
  HistoryDetailData historyDetailData;
  var historyDetailDataAry = [];
  String nameStr = "";
  String userNameStr = "";
  String profilePicStr = "null";
  String profilePicStr12 = "null";
  var userIDstr = "";

  historyDeatilAPI() async {
    Utility().onLoading(context, true);
    var sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
      "cashpot_id" : widget.cashpotId
    };
     print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().potcreatoractivity}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
   // print("resData---------${resData}");
    Utility().onLoading(context, false);
    if (resData["status"] == 1) {
      setState(() {
        userIDstr = sharedPreferences.getString("UserID").toString();
        historyDetailData = HistoryDetailData.fromJson(json.decode(response.body));
        var tempdata = historyDetailData.toJson();
        historyDetailDataAry = tempdata["data"]["pot_activity"];
        nameStr =  tempdata["data"]["user_info"]["name"];
        userNameStr = tempdata["data"]["user_info"]["username"];
        profilePicStr12 = tempdata["data"]["user_info"]["image"].toString();
      //  print("res======${tempdata["data"]["user_info"].toString()}");
      //  print("historyListData data-------$tempdata}");
      });
    } else {
      Utility().toast(context, resData["msg"].toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      historyDeatilAPI();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final upperCont = Container(
      child: Column(
        children: [
          ListTile(
              leading: CircleAvatar(
                  radius: 28.0,
                  backgroundImage: profilePicStr12 == "null"
                      ? AssetImage('Assets/profiledummy.png')
                      : NetworkImage(profilePicStr12),
              ),
              title: Text(
                "${nameStr}",
                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("@${userNameStr}",style: TextStyle(fontFamily: "Helvetica Neue",),),
              trailing: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Creator',
                        style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black, fontSize: 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Transactions clicked');
                          }),
                  ],
                ),
              )),
          SizedBox(height: 10,),
         // Divider(color: Colors.black,),

        ],
      ),
    );
    final potActivityListCont = Container(
        height: 700,//MediaQuery.of(context).size.height,
       // padding: EdgeInsets.only(top: 10, bottom: 10),
        child: historyDetailDataAry.length != 0?
        ListView.builder(
          itemCount: historyDetailDataAry.length,
          itemBuilder: (context, index) {
            profilePicStr = historyDetailDataAry[index]["image"].toString();
            return
             //  Container(
             // // padding: EdgeInsets.only(bottom: 10),
             //  child:
                Column(
                children: <Widget>[

                  historyDetailDataAry[index]["user_id"].toString() == userIDstr?
                  historyDetailDataAry[index]["status"].toString() == "0"?

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
                        title:
                        Text(
                          "${historyDetailDataAry[index]["message"].toString()}",
                          style: TextStyle(fontFamily: "Helvetica Neue",),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                        )
                        ,
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
                                "${historyDetailDataAry[index]["time_difference"].toString()}",
                                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13),
                              ),
//                          SizedBox(
//                            width: 5,
//                          ),
                              historyDetailDataAry[index]["amount"] != null ?
                              historyDetailDataAry[index]["transaction_type"] == 0?
                              Text(
                                "-\$${historyDetailDataAry[index]["amount"].toString()}.00",
                                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13, color: Colors.red),
                              ):
                              Text(
                                "\$${historyDetailDataAry[index]["amount"].toString()}.00",
                                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13, color: Colors.green),
                              )

                                  :
                              Text(""),
                            ],
                          ),
                        )),
                  ):SizedBox(height: 0,)
                      : historyDetailDataAry[index]["status"].toString() == "1"?
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
                        title:
                        Text(
                          "${historyDetailDataAry[index]["message"].toString()}",
                          style: TextStyle(fontFamily: "Helvetica Neue",),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                        )
                        ,
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
                                "${historyDetailDataAry[index]["time_difference"].toString()}",
                                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13),
                              ),
//                          SizedBox(
//                            width: 5,
//                          ),
                              historyDetailDataAry[index]["amount"] != null ?
                              historyDetailDataAry[index]["transaction_type"] == 0?
                              Text(
                                "-\$${historyDetailDataAry[index]["amount"].toString()}.00",
                                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13, color: Colors.red),
                              ):
                              Text(
                                "\$${historyDetailDataAry[index]["amount"].toString()}.00",
                                style: TextStyle(fontFamily: "Helvetica Neue",fontSize: 13, color: Colors.green),
                              ):
                              Text(""),
                            ],
                          ),
                        )),
                  ): SizedBox(height: 0),
                  SizedBox(
                    height: 5,
                  ),
                  // Divider(
                  //   height: 2,
                  // ),
                ],
              );
           // );
          },
        ):
        Center(
          child: Text("No pot activity",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.w500
            ),
          ),
        )

    );
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: AppColor.themeColor,
        flexibleSpace:
        Container(
          height: 100,
          child: SvgPicture.asset("Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: Text("${widget.NameStr}",style: TextStyle(fontFamily: "Helvetica Neue",),),
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
            upperCont,
            potActivityListCont

          ],
        ),
      ),
    );
  }
}
