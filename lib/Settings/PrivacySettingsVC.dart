import 'package:cashpot/Style/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class PrivacySettingsVC extends StatefulWidget {
  @override
  _PrivacySettingsVCState createState() => _PrivacySettingsVCState();
}

class _PrivacySettingsVCState extends State<PrivacySettingsVC> {
  bool _switchValue1=false;
  bool _switchValue2=false;
  @override
  Widget build(BuildContext context) {
    final cashNotiCont = Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(right: 15, left: 15, top: 15),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Incoming Pot Request",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Contacts Only",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue1,
              onChanged: (value) {
                setState(() {
                  _switchValue1 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Text(
              "Allow All",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Helvetica Neue",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff707070)),

            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue2,
              onChanged: (value) {
                setState(() {
                  _switchValue2 = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),

        ],
      ),
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

          title: Text("Privacy"),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              cashNotiCont,
            ],
          ),
        )
    );
  }
}
