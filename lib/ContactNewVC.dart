import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';

TextEditingController searchTF = TextEditingController();

class ContactNewVC extends StatefulWidget
{
  final String cashpotId;
  const ContactNewVC(this.cashpotId);
  @override
  _ContactNewVCState createState() => _ContactNewVCState();
}

const iOSLocalizedLabels = false;

class _ContactNewVCState extends State<ContactNewVC>
{
  List<Contact> _contacts;
  var contactNameBody = [];
  var contactNumberBody = [];
  bool isCheck = false;
  var ischeckAry = [];
  var ischeckAryRecent = [];
  Map body = {};
  Map bodyForExistingPot = {};
  var backContactAry = [];
  var backRecentContactAry = [];
  var selectedContactsAry = [];
  var selectedRecentContactsAry = [];
  var selectedUserAryforTop = [];
  String ContctStrForPot = "";
  String searchTextStr = "";

  ///Search parts
  var mergeredAry = [];
  var filteredMergedAry = [];
  String checkSearch = "0";
  var firstdataContact = [];

  @override
  void initState()
  {
    // TODO: implement initState
    _askPermissions();
    super.initState();
  }

  Future<void> _askPermissions() async
  {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted)
    {
      _handleInvalidPermissions(permissionStatus);
    } else {
      //print("refreshContacts-------");
      refreshContacts();
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus)
  {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    } else if (permissionStatus == PermissionStatus.granted) {
      refreshContacts();
    }
  }

  Future<void> refreshContacts() async
  {
    // Load without thumbnails initially.
    var contacts = (await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: iOSLocalizedLabels))
        .toList();
    setState(() {
      _contacts = contacts;
    });
    Contact c;
    String numbersStr;
    //  print("_contacts.length---${_contacts.length}");
    //print("c.phones-------${_contacts.length}");
    for (int i = 0; i < _contacts.length; i++) {
      c = _contacts?.elementAt(i);
      /* contactNameBody.add("${c.displayName ?? ""}");
      c.phones.forEach((phone) {
        contactNameBody.add("${c.displayName ?? ""}");
        // debugPrint("Name------${c.displayName}");
        // body['numbers[${i}][${'name'}]'] = "${c.displayName ?? ""}";
        numbersStr = phone.value.toString();
         print("Number-----${numbersStr}");
        String numbf = numbersStr.replaceAll(new RegExp(r"[^\s\w]"), '');
        String trimStr = numbf.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        // print("numbersStr-----${numbersStr}");
        if (numbersStr.startsWith("+") == true) {
          contactNumberBody.add(trimStr);
        } else {
          contactNumberBody.add(trimStr);
        }
      });*/
      c.phones.forEach((phone) {
        contactNameBody.add("${c.displayName ?? ""}");

        numbersStr = phone.value.toString();

        // String trimStr = numbersStr.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        //  String contactNumber = numbersStr.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        String contactNumber1 =
        numbersStr.replaceAll(new RegExp("[()\\s-]+"), "");
        contactNumberBody.add(contactNumber1);
      });
    }
    // contactNameBody.length
    for (int j = 0; j < contactNameBody.length; j++) {
      // for (int j = 0; j < 1; j++) {
      body['numbers[$j][${'name'}]'] = contactNameBody[j];
      body['numbers[$j][${'numbers'}]'] = contactNumberBody[j];
    }
    body['contacts_length'] = (contactNameBody.length - 1).toString();
    // print(body['contacts_length']);
    // body['contacts_length'] = "1";
    // ContactLenghtdialogAlert(context, "Total contact in your phone is ${contactNameBody.length} and the names are ${body}");
    fetchontactsAPI("1", "");
    // log("body contact-------${body}");
    // log("contactNameBody-------${contactNameBody}");
  }
  ///17 Aug New fetch contact
  fetchontactsAPI(String pageno, String searchText) async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
    //print("!!!!!!!! ${body["user_id"]} ${body["login_id"]}  ");
    body["page"] = pageno;
    body["text"] = searchText;
    body["cashpot_id"] = widget.cashpotId.toString() != "createPot" ? widget.cashpotId.toString() : "";
   //  log('data-------vvv------${body}');
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
   // log(basicAuth);
    //print("${Webservice().apiUrl}${Webservice().searchusers}");
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().searchusers}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
   // print("RES=========${response.body}");
    Map resData = json.decode(response.body) as Map;
    //print("------------$resData");
    Utility().onLoading(context, false);
    if (resData["status"] == 1)
    {
      var tempList = resData["data"];
      print("tempList------$tempList");
      final jsonList = tempList.map((item) => jsonEncode(item)).toList();
      print("jsonList------$jsonList");
      final uniqueJsonList = jsonList.toSet().toList();
      print("uniqueList------$uniqueJsonList");
      var result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      print("result------$result");
       // log("API SUCCESS-----------${result}");
      setState(() {
        backRecentContactAry = resData["recent_data"];
        backContactAry = result;
      });
      //  log("backRecentContactAry------${backRecentContactAry.length}");
      //log("backContactAry------${backContactAry.length}");
      setState(()
      {
        backRecentContactAry.forEach((f) {
          f["isChecked"] = false;
          f["isRecent"] = true;
        });
        backContactAry.forEach((f) {
          f["isChecked"] = false;
          f["isRecent"] = false;
        });
        mergeredAry = backContactAry + backRecentContactAry;
        if (checkSearch == "0") {
          firstdataContact = mergeredAry;
        }
      });
      //  log("mergeredAry---------${mergeredAry}");
    }
    else
    {
      // Navigator.pop(context);
      print("ERROR");
      Utility().toast(context, "Something went wrong");
    }
  }
  fetchUsernameAPI(String pageNumber, String searchText) async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["page"] = pageNumber;
    body["text"] = searchText;
    body["cashpot_id"] = widget.cashpotId.toString() != "createPot" ? widget.cashpotId.toString() : "";

    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";

    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().searchusers}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        }).whenComplete(() => Utility().onLoading(context, false));

    Map resData = json.decode(response.body) as Map;
    print("+++++++++$resData");
    if(resData["status"]==1)
      {
        var tempList = resData["data"];
        print("!!!!!!!!!!!$tempList");
        final jsonList = tempList.map((item) => jsonEncode(item)).toList();
        print("@@@@@@$jsonList");

        final uniqueJsonList = jsonList.toSet().toList();

        print("#######$uniqueJsonList");
        var result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
        print("------$result");
        setState(() {
          backRecentContactAry = resData["recent_data"];
          backContactAry = result;
        });
        setState(()
        {
          backRecentContactAry.forEach((f) {
            f["isChecked"] = false;
            f["isRecent"] = true;
          });
          backContactAry.forEach((f) {
            f["isChecked"] = false;
            f["isRecent"] = false;
          });
          mergeredAry = backContactAry + backRecentContactAry;
          if (checkSearch == "0")
          {
            firstdataContact = mergeredAry;
          }
        });
      }
    else
      {
      // Navigator.pop(context);
      print("ERROR");
      Utility().toast(context, "Something went wrong");
    }

  }
  ContactLenghtdialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      // type: AlertType.success,
      title: message,
      style: AlertStyle(
        isCloseButton: false,
      ),
      // desc: message,
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "YES",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            // fetchontactsAPI();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.white,
          child: Text(
            "NO",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  AddSelectedMemInExistingPotAPI() async
  {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bodyForExistingPot["cashpot_id"] = "${widget.cashpotId}";
    bodyForExistingPot["user_id"] =
        "${sharedPreferences.getString("UserID").toString()}";
    bodyForExistingPot["login_id"] =
        "${sharedPreferences.getString("UserID").toString()}";
    bodyForExistingPot["users"] = ContctStrForPot;
    // print('data-----body--------${body}');
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
    if (resData["status"] == 1)
    {
      Utility().toast(context, "Pot invite sent");
      Navigator.of(context).pushNamedAndRemoveUntil('/HomeVC', (Route<dynamic> route) => false);
    } else
      {
      //  print("API FAILURE------");
      Utility().toast(context, "Something went wrong");
    }
  }

  contactStrMethod() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("contactStr", selectedContactsAry.join(","));
    if (widget.cashpotId.toString() != "createPot") {
      setState(() {
        if (selectedContactsAry.length != 0) {
          ContctStrForPot = selectedContactsAry.join(",");
        }
      });
      if (ContctStrForPot != "") {
        AddSelectedMemInExistingPotAPI();
      } else {
        Utility().toast(context, "Please select atleast one contact");
      }
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    searchTF.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
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
            controller: searchTF,
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
            onChanged: (text)
            {
              print(text);
              // setState(() {
              //   if (text == null || text == "") {
              //     filteredMergedAry = [];
              //   } else {
              //     filteredMergedAry = mergeredAry.where((item) => item['name'].toLowerCase().contains(text.toLowerCase()) || item['username'].toLowerCase().contains(text.toLowerCase()) || item['number'].toLowerCase().contains(text.toLowerCase()) || item['email'].toLowerCase().contains(text.toLowerCase())).toList();
              //    // print('filteredMergedAry == ${filteredMergedAry}');
              //   }
              // });

              if (text.length % 3 == 0)
              {
                if(text.startsWith("@"))
                  {
                    //print("Okay");
                    //print("******${text.length}");
                    String stringRequired=text.substring(1,text.length);
                    //print("$stringRequired");
                    body = {};
                    body['contacts_length'] = "0";
                    checkSearch = "1";
                    fetchUsernameAPI("1", "$stringRequired");
                  }
                else if (text.length != 0 || text != "" && !(text.startsWith("@")))
                {
                  setState(()
                  {
                    searchTextStr = text;
                  });
                  body = {};
                  body['contacts_length'] = "0";
                  checkSearch = "1";
                  fetchontactsAPI("1", "$searchTextStr");
                }
                else
                {
                  Timer(Duration(seconds: 1), () {
                    //refreshContacts();
                    setState(()
                    {
                      mergeredAry = firstdataContact;
                     // log("AFTER-----$mergeredAry");
                    });
                  });
                }
              }
///COMMENTED
              // if(text.length == 0)
              //   {
              //     // body={};
              //     Timer(Duration(seconds: 1), (){
              //       //refreshContacts();
              //       setState(() {
              //         mergeredAry = firstdataContact;
              //       });
              //     });
              //
              //
              //   }
            },
          ),
        ),
      ),
    );

    final selectedUsersCont = selectedUserAryforTop.length != 0
        ? Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 15, right: 15),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: selectedUserAryforTop.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Text(
                        "${selectedUserAryforTop[index]}",
                        style: TextStyle(
                          color: AppColor.newSignInColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Helvetica Neue",
                        ),
                      ),
                      index != selectedUserAryforTop.length - 1
                          ? Text(", ")
                          : Text("")
                    ],
                  );
                }),
          )
        : Container(height: 0);
    Container contactText(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        color: AppColor.newSignInColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
          child: Text(
            "Contact",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      );
    }

    ContactListUI() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: mergeredAry.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              // print("mergeredAry[index]-------${mergeredAry.where((element) => element["isRecent"]== false).toList().length}");
              if (mergeredAry[index]["isRecent"] == false) {
                //  print("In the loop");
                String profilePicStr2 = "";
                if (mergeredAry[index]["image"].toString() != "null" &&
                    mergeredAry[index]["image"].toString() != "") {
                  profilePicStr2 = mergeredAry[index]["image"].toString();
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(mergeredAry[index]["name"].toString()),
                  subtitle: mergeredAry[index]["username"].toString() == ""
                      ? Text(mergeredAry[index]["number"].toString())
                      : Text("@${mergeredAry[index]["username"].toString()}"),
                  leading: CircleAvatar(
                    // backgroundColor: Colors.grey,
                    // radius: 22.0,
                    backgroundImage: profilePicStr2 == ""
                        ? AssetImage('Assets/profiledummy.png')
                        : NetworkImage(
                            "${Webservice().imagePath}${profilePicStr2}"),
                  ),
                  trailing: mergeredAry[index]["user_id"].toString() != ""
                      ? Theme(
                          data: ThemeData(
                              unselectedWidgetColor: AppColor.newSignInColor),
                          child: Checkbox(
                              activeColor: AppColor.newSignInColor,
                              value: mergeredAry[index]["isChecked"],
                              onChanged: (value) {
                                setState(() {
                                  setState(() {
                                    mergeredAry[index]["isChecked"] =
                                        !mergeredAry[index]["isChecked"];
                                    if (mergeredAry[index]["isChecked"] ==
                                        true) {
                                      selectedContactsAry.add(mergeredAry[index]
                                              ["user_id"]
                                          .toString());
                                      // setState(() {
                                      //   firstdataContact.add(mergeredAry[index]);
                                      //   log("firstdataContact----$firstdataContact");
                                      // });

                                      selectedUserAryforTop.add(
                                          "${mergeredAry[index]["name"].toString()}");
                                      selectedUserAryforTop = selectedUserAryforTop.toSet().toList();
                                    } else {
                                      selectedContactsAry.remove(
                                          mergeredAry[index]["user_id"]
                                              .toString());

                                      selectedUserAryforTop.remove(
                                          mergeredAry[index]["name"]
                                              .toString());
                                    }
                                  });
                                });
                              }),
                        )
                      : InkWell(
                          child: Text(
                            "Invite",
                            style: TextStyle(
                              color: AppColor.newSignInColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Helvetica Neue",
                            ),
                          ),
                          onTap: () {
                            // print("Invite click----${index}");
                          },
                        ),
                );
              }
              return null;
            }),
      );
    }

    recentText()
    {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        color: AppColor.newSignInColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
          child: Text(
            "Recent",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      );
    }

    SearchResultListUI() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredMergedAry.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              String profilePicStr2 = "";
              if (filteredMergedAry[index]["image"].toString() != "null" &&
                  filteredMergedAry[index]["image"].toString() != "") {
                profilePicStr2 = filteredMergedAry[index]["image"].toString();
              }

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(filteredMergedAry[index]["name"].toString()),
                subtitle: filteredMergedAry[index]["username"].toString() == ""
                    ? Text(filteredMergedAry[index]["number"].toString())
                    : Text(
                        "@${filteredMergedAry[index]["username"].toString()}"),
                leading: CircleAvatar(
                  // backgroundColor: Colors.grey,
                  // radius: 22.0,
                  backgroundImage: profilePicStr2 == ""
                      ? AssetImage('Assets/profiledummy.png')
                      : NetworkImage(
                          "${Webservice().imagePath}${profilePicStr2}"),
                ),
                trailing: filteredMergedAry[index]["user_id"].toString() != ""
                    ? Theme(
                        data: ThemeData(
                            unselectedWidgetColor: AppColor.newSignInColor),
                        child: Checkbox(
                            activeColor: AppColor.newSignInColor,
                            value: filteredMergedAry[index]["isChecked"],
                            onChanged: (value) {
                              setState(() {
                                setState(() {
                                  filteredMergedAry[index]["isChecked"] =
                                      !filteredMergedAry[index]["isChecked"];
                                  mergeredAry[index]["isChecked"] =
                                      !mergeredAry[index]["isChecked"];

                                  if (filteredMergedAry[index]["isChecked"] ==
                                      true) {
                                    selectedContactsAry.add(
                                        filteredMergedAry[index]["user_id"]
                                            .toString());
                                    selectedUserAryforTop.add(
                                        "${filteredMergedAry[index]["name"].toString()}");
                                  } else {
                                    selectedContactsAry.remove(
                                        filteredMergedAry[index]["user_id"]
                                            .toString());
                                    selectedUserAryforTop.remove(
                                        filteredMergedAry[index]["name"]
                                            .toString());
                                  }
                                });
                                // print(
                                //     "selectedContactsAry======Recent=====${selectedContactsAry}");
                                // print(
                                //     "selectedUserAryforTop======Recent=====${selectedUserAryforTop}");
                              });
                            }),
                      )
                    : InkWell(
                        child: Text(
                          "Invite",
                          style: TextStyle(
                            color: AppColor.newSignInColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Helvetica Neue",
                          ),
                        ),
                        onTap: () {
                       //   print("Invite click----${index}");
                        },
                      ),
              );

              return null;
            }),
      );
    }

    NewContactListUI() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            mergeredAry
                        .where((element) => element["isRecent"] == true)
                        .toList()
                        .length !=
                    0
                ? recentText()
                : SizedBox(
                    height: 0,
                  ),
            mergeredAry
                        .where((element) => element["isRecent"] == true)
                        .toList()
                        .length !=
                    0
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: mergeredAry.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      //  print('mergeredAry[index]===== ${mergeredAry[index]}');
                      if (mergeredAry[index]["isRecent"] == true) {
                        String profilePicStr2 = "";
                        if (mergeredAry[index]["image"].toString() != "null" &&
                            mergeredAry[index]["image"].toString() != "") {
                          profilePicStr2 =
                              mergeredAry[index]["image"].toString();
                        }

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(mergeredAry[index]["name"].toString()),
                          subtitle: mergeredAry[index]["username"].toString() ==
                                  ""
                              ? Text(mergeredAry[index]["number"].toString())
                              : Text(
                                  "@${mergeredAry[index]["username"].toString()}"),
                          leading: CircleAvatar(
                            // backgroundColor: Colors.grey,
                            // radius: 22.0,
                            backgroundImage: profilePicStr2 == ""
                                ? AssetImage('Assets/profiledummy.png')
                                : NetworkImage(
                                    "${Webservice().imagePath}${profilePicStr2}"),
                          ),
                          trailing: Theme(
                            data: ThemeData(
                                unselectedWidgetColor: AppColor.newSignInColor),
                            child: Checkbox(
                                activeColor: AppColor.newSignInColor,
                                value: mergeredAry[index]["isChecked"],
                                onChanged: (value) {
                                  setState(() {
                                    mergeredAry[index]["isChecked"] =
                                        !mergeredAry[index]["isChecked"];
                                    if (mergeredAry[index]["isChecked"] ==
                                        true) {
                                      selectedContactsAry.add(mergeredAry[index]
                                              ["user_id"]
                                          .toString());
                                      selectedUserAryforTop.add(
                                          "${mergeredAry[index]["name"].toString()}");
                                    } else {
                                      selectedContactsAry.remove(
                                          mergeredAry[index]["user_id"]
                                              .toString());
                                      selectedUserAryforTop.remove(
                                          mergeredAry[index]["name"]
                                              .toString());
                                    }
                                    //  print("selectedContactsAry======Recent=====${selectedContactsAry}");
                                    //  print("selectedUserAryforTop======Recent=====${selectedUserAryforTop}");
                                  });
                                }),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                    })
                : SizedBox(
                    height: 0,
                  ),
            contactText(context),
            ContactListUI()
          ],
        ),
      );
    }

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

        title: Text("Contacts", style: TextStyle(fontFamily: "Helvetica Neue")),
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
                    searchTF.clear();
                    print("Save Clicked");
                    // contactStrMethod();
                    contactStrMethod();
                    Navigator.of(context).pushNamed('/PreviewPotVC');
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
                    searchTF.clear();
                    print("Add Clicked");
                    //
                    contactStrMethod();
                  },
                ),
        ],
      ),
      body: SafeArea(
        // child: SingleChildScrollView(
        child: Column(
          children: [
            SearchTextCont,
            searchCont,
            selectedUsersCont,
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 10),

                filteredMergedAry.length == 0
                    ? NewContactListUI()
                    : SearchResultListUI()
                // filteredMergedAry.length == 0?
                // backRecentContactAry.length != 0 ?recentText(context):Container(),
                // backRecentContactAry.length != 0?  recentContactListUI():Container(),
                // contactText(context),
                // ContactListUI(),
              ],
            ))
          ],
        ),
        // ),
      ),
    );
  }
}
