import 'dart:async';
import 'dart:convert';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ModelClasses/NewContactData.dart';
import 'Utility.dart';
import 'WebServices.dart';

class ContactNewClientVC extends StatefulWidget {
  final String cashpotId;

  const ContactNewClientVC(this.cashpotId);

  @override
  _ContactNewClientVCState createState() => _ContactNewClientVCState();
}

class _ContactNewClientVCState extends State<ContactNewClientVC> {
  final ScrollController _controller = ScrollController();
  NewContactData newContactData;
  var checkList = [];
  var checkList2 = [];
  var recentContactList = [];
  var contactList = [];
  var selectedContactList = [];
  int pageNo = 1;
  String searchTextStr = "";
  String profilePicStr2 = "null";
  String ContctStrForPot = "";
  Map bodyForExistingPot = {};
  bool forconload = false;

  fetchontactsAPI(int pagenumber, String searchText) async {
    if (forconload != false) {
      Utility().toast(context, "Loading contacts");
    } else {
      Utility().onLoading(context, true);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "user_id": "${sharedPreferences.getString("UserID").toString()}",
      "login_id": "${sharedPreferences.getString("UserID").toString()}",
      "page": "${pagenumber}",
      "text": "${searchText}",
      "cashpot_id": widget.cashpotId.toString() != "createPot"
          ? widget.cashpotId.toString()
          : ""
    };
    // print('data-------vvv------${body}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().searchusers}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //print("RES=========${json.decode(response.body) as Map}");

    if (forconload == false) {
      Utility().onLoading(context, false);
    }
    Map resData = json.decode(response.body) as Map;
    // print("resData-----Search----${resData}");
    if (resData["status"] == 1) {
      forconload = true;
      print("API SUCCESS-----------");
      newContactData = NewContactData.fromJson(json.decode(response.body));
      //  print("newContactData-------${newContactData.toJson()}");
      setState(() {
        var tempDict = newContactData.toJson();
        //    print("tempDict----${tempDict["recent_data"].length}");
        //    print("tempDict----${tempDict["data"].length}");
        if (tempDict["data"].length == 0) {
          Utility().toast(context, "No more contacts found");
        }
        recentContactList.clear();
        for (int i = 0; i < tempDict["recent_data"].length; i++) {
          recentContactList.add(tempDict["recent_data"][i]);
        }
        for (int i = 0; i < tempDict["data"].length; i++) {
          contactList.add(tempDict["data"][i]);
        }
        // print("tempDict--------${tempDict}");
      });

      // log("contactList---$contactList");

    } else {
      // Navigator.pop(context);
      Utility().toast(context, "Something went wrong");
    }
  }

  _onScroll() {
    // print("pageNo-----");
    FocusScope.of(context).requestFocus(FocusNode());
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageNo++;
      });
      // print("pageNo-----${pageNo}");

      fetchontactsAPI(pageNo, searchTextStr); //HIT METHOD
    }
  }

  AddSelectedMemInExistingPotAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bodyForExistingPot["cashpot_id"] = "${widget.cashpotId}";
    bodyForExistingPot["user_id"] =
        "${sharedPreferences.getString("UserID").toString()}";
    bodyForExistingPot["login_id"] =
        "${sharedPreferences.getString("UserID").toString()}";
    bodyForExistingPot["users"] = ContctStrForPot;
    // print('data-----body--------${bodyForExistingPot}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrlcashpot}${Webservice().addmembers}",
        body: bodyForExistingPot,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body).toString()}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //   print("resData---resData--${resData}");
    if (resData["status"] == 1) {
      Utility().toast(context, "Pot invite sent successfully");
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil('/HomeVC', (Route<dynamic> route) => false);
      Navigator.pop(context);

    } else {
      //  print("API FAILURE------");

      Utility().toast(context, "Something went wrong");
    }
  }

  contactStrMethod() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("contactStr", selectedContactList.join(","));
    if (widget.cashpotId.toString() != "createPot") {
      setState(() {
        if (selectedContactList.length != 0) {
          ContctStrForPot = selectedContactList.join(",");
        }
      });
      if (ContctStrForPot != "") {
        AddSelectedMemInExistingPotAPI();
      } else {
        Utility().toast(context, "Please select atleast one contact");
      }
    } else {
      setState(() {
        if (selectedContactList.length != 0) {
          ContctStrForPot = selectedContactList.join(",");
        }
      });
      if (ContctStrForPot != "") {
        Navigator.of(context).pushNamed('/PreviewPotVC');
      } else {
        Utility().toast(context, "Please select atleast one contact");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(_onScroll);

    Future.delayed(Duration.zero, () {
      fetchontactsAPI(1, searchTextStr);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchTextCont = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: Text(
        "Must invite at least one member to create a pot",
        textScaleFactor: 1.0,
        style: TextStyle(
            fontFamily: "Helvetica Neue",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
    final searchCont = Container(
      //color: Colors.brown,
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      child: Card(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: TextField(
            // controller: _NameTF,
            cursorColor: Colors.black,
            autocorrect: false,
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(4.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(width: 1, color: AppColor.newSignInColor),
              ),
              filled: true,
              hintStyle: new TextStyle(
                  fontFamily: "Helvetica Neue", color: Colors.grey[800]),
              hintText: "Name, @Username, Phone, Email",
              fillColor: Colors.white,
            ),
            textAlign: TextAlign.center,
            onChanged: (text) {
              print(text);
              if (text.length % 3 == 0) {
                setState(() {
                  checkList.clear();
                  checkList2.clear();
                  recentContactList.clear();
                  contactList.clear();
                  selectedContactList.clear();
                  searchTextStr = text;
                });
                fetchontactsAPI(1, "${searchTextStr}");
              }
              if (text.isEmpty) {
                Timer(Duration(seconds: 1), () {
                  setState(() {
                    checkList.clear();
                    checkList2.clear();
                    recentContactList.clear();
                    contactList = [];
                    selectedContactList.clear();
                    searchTextStr = text;
                    searchTextStr = "";
                    pageNo = 1;
                  });
                  fetchontactsAPI(pageNo, "${searchTextStr}");
                });
              }
            },
          ),
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            height: 100,
            child: SvgPicture.asset(
              "Assets/GreenHeader.svg",
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            "Contact",
            style: TextStyle(
                fontFamily: "Helvetica Neue",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),
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
          actions: <Widget>[
            widget.cashpotId == "createPot"
                ? InkWell(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontFamily: "Helvetica Neue",
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      print("Save Clicked");
                      contactStrMethod();
                    },
                  )
                : InkWell(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontFamily: "Helvetica Neue",
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      print("Add Clicked");
                      //
                      contactStrMethod();
                    },
                  ),
          ],
          //automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchTextCont,
                searchCont,
                Container(
                  height: MediaQuery.of(context).size.height - 240,
                  child: ListView(
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      recentContactList.length != 0
                          ? Container(
                              height: 44,
                              color: AppColor.newSignInColor,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                child: Text(
                                  'Recent',
                                  style: TextStyle(
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(),
                      recentContactList.length != 0
                          ? ListView.builder(
                              // controller: _controller,
                              physics: ScrollPhysics(),
                              //physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: recentContactList.length,
                              itemBuilder: (BuildContext context, int index) {
                                checkList2.add(false);
                                profilePicStr2 = recentContactList[index]
                                        ["image"]
                                    .toString();
                                return Column(
                                  children: [
                                    InkWell(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          // backgroundColor: Colors.grey,
                                          //radius: 20.0,
                                          backgroundImage: profilePicStr2 ==
                                                  "null"
                                              ? AssetImage(
                                                  'Assets/profiledummy.png')
                                              : NetworkImage(
                                                  "${Webservice().imagePath}${profilePicStr2}"),
                                        ),
                                        title: Text(
                                          "${recentContactList[index]["name"].toString()}",
                                          style: TextStyle(
                                            fontFamily: "Helvetica Neue",
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${recentContactList[index]["username"].toString()}",
                                          style: TextStyle(
                                            fontFamily: "Helvetica Neue",
                                          ),
                                        ),
                                        trailing: checkList2[index] == false
                                            ? Icon(
                                                Icons.check_box_outline_blank,
                                                color: AppColor.newSignInColor,
                                                size: 25,
                                              )
                                            : Icon(
                                                Icons.check_box,
                                                color: AppColor.newSignInColor,
                                                size: 25,
                                              ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          checkList2[index] =
                                              !checkList2[index];
                                          if (checkList2[index] == true) {
                                            //Fetch se
                                            selectedContactList.add(
                                                recentContactList[index]
                                                        ["user_id"]
                                                    .toString());
                                            // print("selectedContactList---ADDED--${selectedContactList}");
                                          } else {
                                            selectedContactList.remove(
                                                recentContactList[index]
                                                        ["user_id"]
                                                    .toString());
                                            // print("selectedContactList---Remove--${selectedContactList}");
                                          }
                                        });
                                      },
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black54,
                                    )
                                  ],
                                );
                              },
                            )
                          : Container(),
                      contactList.length != 0
                          ? Container(
                              height: 44,
                              color: AppColor.newSignInColor,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                child: Text(
                                  'Contacts',
                                  style: TextStyle(
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(),
                      contactList.length != 0
                          ? Container(
                              //height: MediaQuery.of(context).size.height-250,
                              child: ListView.builder(
                                // controller: _controller,
                                physics: ScrollPhysics(),
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: contactList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  checkList.add(false);
                                  profilePicStr2 =
                                      contactList[index]["image"].toString();
                                  return Column(
                                    children: [
                                      InkWell(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            // backgroundColor: Colors.grey,
                                            //radius: 20.0,
                                            backgroundImage: profilePicStr2 ==
                                                    "null"
                                                ? AssetImage(
                                                    'Assets/profiledummy.png')
                                                : NetworkImage(
                                                    "${Webservice().imagePath}${profilePicStr2}"),
                                          ),
                                          title: Text(
                                            "${contactList[index]["name"].toString()}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: "Helvetica Neue",
                                            ),
                                          ),
                                          subtitle: Text(
                                            "@${contactList[index]["username"].toString()}",
                                            style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: "Helvetica Neue",
                                            ),
                                          ),
                                          trailing: checkList[index] == false
                                              ? Icon(
                                                  Icons.check_box_outline_blank,
                                                  color:
                                                      AppColor.newSignInColor,
                                                  size: 25,
                                                )
                                              : Icon(
                                                  Icons.check_box,
                                                  color:
                                                      AppColor.newSignInColor,
                                                  size: 25,
                                                ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            checkList[index] =
                                                !checkList[index];
                                            if (checkList[index] == true) {
                                              //Fetch se
                                              selectedContactList.add(
                                                  contactList[index]["user_id"]
                                                      .toString());
                                              // print("selectedContactList---ADDED--${selectedContactList}");
                                            } else {
                                              selectedContactList.remove(
                                                  contactList[index]["user_id"]
                                                      .toString());
                                              // print("selectedContactList---Remove--${selectedContactList}");
                                            }
                                          });
                                        },
                                      ),
                                      Divider(
                                        height: 2,
                                        color: Colors.black54,
                                      )
                                    ],
                                  );
                                },
                              ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
