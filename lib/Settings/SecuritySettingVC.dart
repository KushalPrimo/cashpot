import 'package:cashpot/Style/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class SecuritySettingVC extends StatefulWidget {
  @override
  _SecuritySettingVCState createState() => _SecuritySettingVCState();
}

class _SecuritySettingVCState extends State<SecuritySettingVC> {
  bool _switchValue=true;

  @override
  Widget build(BuildContext context) {
    final UiCont = Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text("Use Biometrics",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Required to transfer & add cash",
              style: TextStyle(fontFamily: "Helvetica Neue",),
            ),
            trailing: Switch(
              activeColor: AppColor.newSignInColor,
              activeTrackColor: AppColor.newSignInColor,
              inactiveTrackColor: Colors.black12,
              inactiveThumbColor: AppColor.newSignInColor,
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text("Change Password",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/ChangePasswordVC');
            },
          ),
          Divider(
            height: 1,
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
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
        title: Text("Security",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),
      body: UiCont,
    );
  }
}
