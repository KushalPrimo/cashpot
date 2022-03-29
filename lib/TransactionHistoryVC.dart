
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ModelClasses/TransactionHistaoryData.dart';
import 'Utility.dart';
import 'WebServices.dart';
class TransactionHistoryVC extends StatefulWidget {
  @override
  _TransactionHistoryVCState createState() => _TransactionHistoryVCState();
}

class _TransactionHistoryVCState extends State<TransactionHistoryVC> {
  TransactionHistaoryData transactionHistaoryData;
  var HistoryListDataAry = [];
  historyAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
    };
    // print('data-------------${data}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlPayment}${Webservice().transactionactivity}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
   // print("resData-----_${resData}");
    Utility().onLoading(context, false);
    if (resData["status"] == 1) {
      setState(() {
       transactionHistaoryData = TransactionHistaoryData.fromJson(json.decode(response.body));
        var tempdata = transactionHistaoryData.toJson();
      // print("historyListData data-------$tempdata}");
         HistoryListDataAry = tempdata["data"];
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
    final historyList = Container(
      height: MediaQuery.of(context).size.height,
      child: HistoryListDataAry.length != 0?
      ListView.builder(
          padding: const EdgeInsets.only(top: 8,bottom: 8),
          itemCount: HistoryListDataAry.length,

          itemBuilder: (BuildContext context, int index) {

            return Column(
              children: <Widget>[

                InkWell(
                  child: Container(
                    // height: 75,
                    //color: Colors.amber[colorCodes[index]],
                    child: ListTile(
                      title: Text('${HistoryListDataAry[index]["msg"]}',style: TextStyle( fontFamily: "Helvetica Neue",),),
                      trailing: Container(
                        height: 40,
                        child: Column(
                          children: [
                            Text('${HistoryListDataAry[index]["time"]}',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Helvetica Neue",
                            ),
                            ),
                            Text("\$${HistoryListDataAry[index]["amount"]}.00",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Helvetica Neue",
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                      leading:  SvgPicture.asset(
                        "Assets/Clogo-01.svg",
                        fit: BoxFit.contain,
                      ),
                    ),

                  ),
                  // onTap: (){
                  //
                  // },
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                ),
              ],
            );
          }):
      Container(
        child: Center(
          child: Text(
            "No Transactions",
            style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
                fontFamily: "Helvetica Neue",
              color: Colors.black54
            )
          ),
        ),
      )
      ,


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
        title: Text("Transactions",style: TextStyle( fontFamily: "Helvetica Neue",),),
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
      body: historyList
    );
  }
}
