import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Style/Color.dart';

class NewContactVC extends StatefulWidget {
  final String cashpotId;
  const NewContactVC(this.cashpotId);
  @override
  _NewContactVCState createState() => _NewContactVCState();
}

const iOSLocalizedLabels = false;

class _NewContactVCState extends State<NewContactVC> {
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  List<Contact> _contacts;
  int m = 0;
  int n = 0;
  int l = 10;
  var phoneNumbers = [];
  var phoneName = [];
  var actualArryNumber = [];
  var actualArryName = [];
  var checkBoxAry = [];
  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    } else {
      print("refreshContacts-------");
      refreshContacts();
    }
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
    // print(_contacts);
    Contact c;

    for (int i = 0; i < _contacts.length; i++) {
      c = _contacts?.elementAt(i);

      // print("phone------${c.phones}");
      // bool checkVal = false;
      c.phones.forEach((phone) {
//print(phone.value.toString());
//if (checkVal == false) {
        phoneName.add("${c.displayName ?? ""}");

        phoneNumbers.add(phone.value.toString());
//   checkVal = true;
// }
      });
    }
    // log("NAME------${phoneName}");
    //  log("NUMBER------${phoneNumbers}");
    print("phoneName.length---${phoneName.length}");
    print("phoneNumbers---${phoneNumbers.length}");
    _fetchData(0, 0, 10);
  }

  Future _fetchData(int m, int n, int l) async {
    await new Future.delayed(new Duration(seconds: 1));

    //  Utility().onLoading(context, true);

    for (m = n; m < l; m++) {
      setState(() {
        actualArryName.add("${m} ${phoneName[m]}");
        actualArryNumber.add(phoneNumbers[m]);
        checkBoxAry.add(false);
      });
    }
    print(actualArryName);

    print("l---${l}");
    _isLoading = false;
    // Timer(Duration(seconds: 1), () {
    //   print("Yeah, this line is printed immediately");
    //   Utility().onLoading(context, false);
    // });
    // Utility().toast(context, "Loading more contacts");
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;

        m = m + 10;
        n = m;
        l = l + 10;
        print(m);
        print(n);
        print(l);
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

  @override
  Widget build(BuildContext context) {
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

        //automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: actualArryNumber.length,
        //_isLoading ? _dummy.length + 1 : _dummy.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: AppColor.newSignInColor,
                    size: 45,
                  ),
                  title: Text(actualArryName[index]),
                  subtitle: Text(actualArryNumber[index]),
                  trailing: checkBoxAry[index] == false
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
                onTap: (){
                  setState(() {
                    checkBoxAry[index] = !checkBoxAry[index];
                    if (checkBoxAry[index] == true) {

                      //Fetch se
                    } else {


                    }
                  });

                },
              ),
              Container(
                color: Colors.black,
                height: 1,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          );
        },
      ),
    );
  }
}
