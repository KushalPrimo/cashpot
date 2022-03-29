import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cashpot/ModelClasses/UserNumberData.dart';
import 'package:cashpot/Utility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Style/Color.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'WebServices.dart';

class ContactVC extends StatefulWidget
{
  final String cashpotId;
  const ContactVC(this.cashpotId);

  @override
  _ContactVCState createState() => _ContactVCState();
}

const iOSLocalizedLabels = false;

class _ContactVCState extends State<ContactVC>
{
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  UserNumberData userNumberData;

  UserNumberDataErr userNumberDataErr;
  var isCheckedVal = [];

  Map selectedContactAry = {};
  List checkList = new List();
  List checkListForIndex = new List();
  List<Contact> _contacts;
  Iterable<Item> phones = [];
  Map newContact = {};
  Map body = {};
  Map bodyForExistingPot = {};
  List contactAry = [];
  String ContctStrForPot = "";

  var newdataFetched = [];
  var newdataFetchedPersistanceData = [];
  var newRegisteredData = [];
  var newRegisteredDataPersistanceData = [];
  bool checkSearch = false;
  int m = 0;
  int n = 0;
  int l = 10;
  var contactNameBody = [];
  var contactNumberBody = [];
  List filteredNames = new List();

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted)
    {
      _handleInvalidPermissions(permissionStatus);
    }
    else
      {
        print("refreshContacts-------");
        refreshContacts();
      }
  }

  Future<PermissionStatus> _getContactPermission() async
  {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted && permission != PermissionStatus.disabled)
    {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ?? PermissionStatus.unknown;
    }
    else
        return permission;
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
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

  postUsersNumberAPI() async {
    // Utility().onLoading(context, true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (widget.cashpotId.toString() != "createPot") {
      body["cashpot_id"] = "${widget.cashpotId}";
    }
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
   // log('data-----body--------${body}');
    Utility().toast(context, "Loading contacts...");


    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().postUsersNumbers}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
          // "Content-Type": "application/json"
        });
    print("RES========= API");
    // Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    // print("resData-----_${resData}");
    if (resData["status"] == 1) {
      //  Utility().toast(context, "Contacts uploaded to the server successfully");
      setState(() {
        userNumberData = UserNumberData.fromJson(json.decode(response.body));
        var temp = userNumberData.toJson();

        newdataFetched.addAll(temp["non_registered_user"]);
        newdataFetchedPersistanceData = newdataFetched;
        newRegisteredData.addAll(temp["registered_user"]);
        newRegisteredDataPersistanceData.addAll(temp["registered_user"]);
        body.clear();
          log("temp---data-from backend--${temp}");
        // print("newdataFetched----length---${temp}");
      });

      // log("API SUCCESS-----userNumberData--${userNumberData.toJson()}");

    } else {
      //  print("API FAILURE------");
      Utility().toast(context, "API FAILURE------");

      userNumberDataErr =
          UserNumberDataErr.fromJson(json.decode(response.body));
      Utility().toast(context, userNumberDataErr.message.toString());
      body = {};
    }
  }

  AddmemberDataaNumberAPI() async {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (widget.cashpotId.toString() != "createPot") {
      body["cashpot_id"] = "${widget.cashpotId}";
    }
    body["user_id"] = "${sharedPreferences.getString("UserID").toString()}";
    body["login_id"] = "${sharedPreferences.getString("UserID").toString()}";
    // print('data-----body--------${body}');
    // print('data-----body--------${body}');
    // print("${Webservice().apiUrl}${Webservice().postUsersNumbers}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().cashpotregisterednumbers}",
        body: body,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    //  print("RES=========${json.decode(response.body).toString()}");
    // Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;
    //  print("resData-----_${resData}");
    if (resData["status"] == 1) {
      setState(() {
        userNumberData = UserNumberData.fromJson(json.decode(response.body));
        var temp = userNumberData.toJson();

        newdataFetched.addAll(temp["non_registered_user"]);
        newRegisteredData.addAll(temp["registered_user"]);
        body.clear();
         // log("newRegisteredData---data---${newRegisteredData}");
        // print("newdataFetched----length---${newRegisteredData.length}");
      });

      // print("API SUCCESS-------${userNumberData.toJson()}");

    } else {
      //  print("API FAILURE------");
      userNumberDataErr =
          UserNumberDataErr.fromJson(json.decode(response.body));
      Utility().toast(context, userNumberDataErr.message.toString());
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
    if (resData["status"] == 1) {
      Utility().toast(context, "Pot invite sent successfully");
      Navigator.of(context).pushNamedAndRemoveUntil('/HomeVC', (Route<dynamic> route) => false);
    } else {
      //  print("API FAILURE------");

      Utility().toast(context, "Something went wrong");
    }
  }
//2jun
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
            _fetchData(0, 0, 5);

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

  Future<void> refreshContacts() async {
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
    var value = 0;
    print("_contacts.length---${_contacts.length}");
    //print("c.phones-------${_contacts.length}");
    ContactLenghtdialogAlert(context, "Phone have  ${ _contacts.length} contacts. Uploading only 5 contacts to the server for debugging test.");
    for (int i = 0; i < _contacts.length; i++) {
      c = _contacts?.elementAt(i);
      //  contactNameBody.add("${c.displayName ?? ""}");
      c.phones.forEach((phone) {
        value++;
        contactNameBody.add("${c.displayName ?? ""}");
        // debugPrint("Name------${c.displayName}");
        // body['numbers[${i}][${'name'}]'] = "${c.displayName ?? ""}";

        numbersStr = phone.value.toString();
        //  print("Number-----${numbersStr}");
        String numbf = numbersStr.replaceAll(new RegExp(r"[^\s\w]"), '');
        String trimStr = numbf.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        // print("numbersStr-----${numbersStr}");
        if (numbersStr.startsWith("+") == true) {
          contactNumberBody.add(trimStr);
        } else {
          contactNumberBody.add(trimStr);
        }
      });

      isCheckedVal.add(0);
      checkListForIndex.add(value);
      checkList.add(false);
    }
    log("contactNumberBody-------${contactNumberBody.length}");
    log("contactNameBody-------${contactNameBody.length}");

  //  _fetchData(0, 0, 5);
    //   var distinctIds = contactNameBody;
    //   var distinctIdsNumber = contactNumberBody;
    // //  PhonedialogAlert(context, "Cashpot fetched ${distinctIdsNumber.length.toString()} contacts from your phone");
    // int k = 0;
    // int l = 100;
    // int j = 0;
    // int h = 0;
    // int m = contactNameBody.length%100;
    // int contactBodylength = (contactNameBody.length/200).toInt();//int.parse("${}");
    // print("contactBodylength----${contactBodylength}");
    //for(k = 0; k <= contactBodylength; k++){
    //   int indes = 0;
    //   //j
    //   for(h = j ; h < l ; h++){
    //    //
    //     body['numbers[${indes}][${'name'}]'] = contactNameBody[h];
    //     body['numbers[${indes}][${'number'}]'] = contactNumberBody[h];
    //     indes ++;
    //   }

    // log("Value--body-------${(body)}");
    //  indes = 0;
    //  print("Value--length-------${(body.length/2).toInt()}");
    //  log("new body=======${body}");
    //26May
    //     if(widget.cashpotId !="createPot"){
    //       ///For pagination
    //       await AddmemberDataaNumberAPI();
    //       await Future.delayed(Duration(seconds: 3));
    //     }else{
    //  // print("c.phones-------${c.phones.length}");
    //  // await postUsersNumberAPI();
    //   await Future.delayed(Duration(seconds: 3));
    //      }

    //   if(h + 100 <= distinctIds.length){
    //   print("GOES TO IF");
    //   j=j+100;
    //   l=l+100;
    // }else{
    //   print("GOES TO ELSE");
    //   j = j+100;
    //   l = l+m;
    // }
    //  }
  }

  Future _fetchData(int m, int n, int l) async {
    await new Future.delayed(new Duration(seconds: 1));
    int indes = 0;
    for (m = n; m < l; m++) {
      setState(() {
        body['numbers[${indes}][${'name'}]'] = contactNameBody[m];
        body['numbers[${indes}][${'number'}]'] = contactNumberBody[m];
      });
      indes++;
    }

    // print("llllll--------${ l}");
    // print("GET BODY-----${body}");
    //   if(m + 10 <= contactNumberBody.length){
    //   print("GOES TO IF");
    //   n = n+10;
    //   l=l+10;
    // }
    //   else{
    //   print("GOES TO ELSE");
    //   n = n+10;
    //   l = l+m;
    // }

    if (widget.cashpotId != "createPot") {
      ///For pagination
      await AddmemberDataaNumberAPI();
    } else {
      await postUsersNumberAPI();
    }
  }

  void updateContact() async {
    Contact ninja = _contacts
        .toList()
        .firstWhere((contact) => contact.familyName.startsWith("Ninja"));
    ninja.avatar = null;
    await ContactsService.updateContact(ninja);

    //  refreshContacts();
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
        if (l + 10 < contactNumberBody.length) {
          m = m + 10;
          n = m;
          l = l + 10;
        } else {
          m = m + 10;
          n = m;
          l = l + (contactNumberBody.length - l);
        }
      });
      _fetchData(m, n, l); //HIT METHOD
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(_onScroll);
    _askPermissions();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  contactStrMethod() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("contactStr", contactAry.join(","));
    if (widget.cashpotId.toString() != "createPot") {
      setState(() {
        if (contactAry.length != 0) {
          ContctStrForPot = contactAry.join(",");
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
  Widget build(BuildContext context) {
    final SearchTextCont = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15),
      child: Text(
        "Must invite at least one member to create a pot",
        textScaleFactor: 1.0,
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
    final searchCont = Container(
      //color: Colors.brown,
      margin: EdgeInsets.all(15),
      child: Card(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: TextField(
            // controller: _NameTF,
            cursorColor: Colors.black,
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
              hintStyle: new TextStyle(color: Colors.grey[800]),
              hintText: "Name, @Username, Phone, Email",
              fillColor: Colors.white,
            ),
            textAlign: TextAlign.center,
            onChanged: (text) {
              print(text);
              if (text.isNotEmpty) {
                List tempList = new List();
                for (int i = 0; i < newdataFetched.length; i++) {
                  if (newdataFetched[i]['name']
                      .toLowerCase()
                      .contains(text.toLowerCase()) || newdataFetched[i]['number']
                      .toLowerCase()
                      .contains(text.toLowerCase())) {
                    tempList.add(newdataFetched[i]);
                  }
                }
                List tempListt = new List();
                for (int i = 0; i < newRegisteredData.length; i++) {
                  if (newRegisteredData[i]['name']
                      .toLowerCase()
                      .contains(text.toLowerCase()) || newRegisteredData[i]['number']
                      .toLowerCase()
                      .contains(text.toLowerCase()) || newRegisteredData[i]['username']
                      .toLowerCase()
                      .contains(text.toLowerCase())) {
                    tempListt.add(newRegisteredData[i]);

                  }
                }
                setState(() {
                  newdataFetched = tempList;
                  newRegisteredData = tempListt;
                });
               // print(newdataFetched);
              //  print(newRegisteredData);
              } else {
                setState(() {
                  newdataFetched = newdataFetchedPersistanceData;
                  newRegisteredData = newRegisteredDataPersistanceData;
                });
              }
            },
          ),
        ),
      ),
    );
    final RecentHeadCont = Container(
      height: 50,
      color: AppColor.newSignInColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, top: 15),
      child: Text(
        "Recent",
        textScaleFactor: 1.0,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        //textAlign: TextAlign.center,
      ),
    );
    final ContactHeadCont = Container(
      height: 50,
      color: AppColor.newSignInColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, top: 15),
      child: Text(
        "Contact",
        textScaleFactor: 1.0,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        //textAlign: TextAlign.center,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColor.themeColor,
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          "Add Members",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    print("Save Clicked");
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
      body: Column(
        children: <Widget>[
          SearchTextCont,
          searchCont,
          RecentHeadCont,
          Flexible(
            flex: 1,
            child: Container(
              child: newRegisteredData != null
                  ? newRegisteredData.length != 0
                      ? ListView.builder(
                          controller: _controller,
                          itemCount: newRegisteredData.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            Contact c = _contacts?.elementAt(index);
                            return Container(
                              height: 75,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        checkList[index] = !checkList[index];
                                        // print("checkList[index]-----${c.toMap()["phones"][1]}");
                                        if (checkList[index] == true) {
                                          contactAry.add(
                                              newRegisteredData[index]
                                                      ["user_id"]
                                                  .toString());

                                          // print("contactAry--------${contactAry}");
                                        } else {
                                          contactAry.removeAt(index);
                                          if (contactAry.length == 1) {
                                            contactAry.removeLast();
                                          }
//                                      print(
//                                          "contactAry----remove----${contactAry}");
                                        }
                                      });
                                      //   Utility().toast(context, "Work In-progress");
                                    },
                                    leading: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                      size: 45,
                                    ),
                                    title:
                                        Text(newRegisteredData[index]["name"]),
                                    subtitle: Text(
                                        "@${newRegisteredData[index]["username"]}"),
                                    trailing: checkList[index] == false
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
                                  Divider(
                                    height: 2,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text("No Recent Contacts"),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          ContactHeadCont,
          Flexible(
            flex: 1,
            child: Container(
              child: newdataFetched.length != 0
                  ? ListView.builder(
                      controller: _controller,
                      itemCount: newdataFetched.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        //  Contact c = _contacts?.elementAt(index);
                        return Container(
                          height: 75,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(
                                    Icons.account_circle,
                                    color: Colors.grey,
                                    size: 45,
                                  ),
                                  title: Text(
                                      newdataFetched[index]["name"].toString()),
                                  trailing: RichText(
                                    text: TextSpan(
                                      //text: 'Hello ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: newdataFetched[index]["is_invited"].toString()=="0"?'Invite   ':'Invited  ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: AppColor.newSignInColor,
                                                fontWeight: FontWeight.w600),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap =
                                                  () => print('Invite Clicked')
                                            //  Utility().toast(context, "Work In-Progress.")
                                            ),
                                      ],
                                    ),
                                  )),
                              Divider(
                                height: 2,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
    // );
  }
}
