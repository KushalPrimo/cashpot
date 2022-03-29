import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Style/Color.dart';

class SettingsVC extends StatefulWidget {
  @override
  _SettingsVCState createState() => _SettingsVCState();
}

class _SettingsVCState extends State<SettingsVC>
{
  String nameStr = "";
  String userNameStr = "";
  String profilePicStr = "";

  getUserDeatils() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      nameStr = sharedPreferences.getString("Fname");
      userNameStr = sharedPreferences.getString("UserName");
      if(sharedPreferences.getString("profileImage") != null) {
        profilePicStr = sharedPreferences.getString("profileImage");
      }
    });
  }
  logout() async
  {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for(String key in preferences.getKeys()) {
      if(key != "FCM_token") {
        preferences.remove(key);
      }
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Login2VC', (Route<dynamic> route) => false);
  }

  @override
  void initState()
  {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      getUserDeatils();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UIcont = Container(

        child: ListView(
      children: <Widget>[
        Container(
          height: 80,
          child: Center(
            child: ListTile(
                leading: CircleAvatar(
                 // backgroundColor: Colors.grey,
                    radius: 28.0,
                    backgroundImage: profilePicStr == ""
                        ? AssetImage('Assets/profiledummy.png')
                        : NetworkImage(profilePicStr),

                   // new AssetImage('Assets/profiledummy.jpg')

                ),
                title: Text(
                  "${nameStr}",
                  style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("@${userNameStr}",style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 16, fontWeight: FontWeight.w300),),
                trailing: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Edit Profile',
                          style: TextStyle(
                              fontFamily: "Helvetica Neue",color: AppColor.newSignInColor, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Edit Profile');
                              Navigator.of(context).pushNamed('/ProfileVC');
                            }),
                    ],
                  ),
                )),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        Container(
          height: 75,
          child: Center(
            child: ListTile(
              leading: SvgPicture.asset(
                "Assets/Settings/bankcard.svg",
                fit: BoxFit.fill,
              ),
              title: Text(
                "Payment Options",
                style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black45),
              ),
              onTap: (){
                Navigator.of(context).pushNamed('/PaymentOptionVC');
              },
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        Container(
          height: 75,
          child: Center(
            child: ListTile(
              leading:  SvgPicture.asset(
                "Assets/leftMenu/bellNotiIcon.svg",
                fit: BoxFit.fill,
              ),
              title: Text(
                "Notifications",
                style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black45),
              ),
              onTap: (){
                Navigator.of(context).pushNamed('/NotificationSettingsVC');
              },
            ),

          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        Container(
          height: 75,
          child: Center(
            child: ListTile(
              leading:  SvgPicture.asset(
                "Assets/Settings/locIcon.svg",
                fit: BoxFit.fill,
              ),
              title: Text(
                "Privacy",
                style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black45),
              ),
              onTap: (){
                Navigator.of(context).pushNamed('/PrivacySettingsVC');
              },
            ),

          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        Container(
          height: 75,
          child: Center(
            child: ListTile(
              leading:  SvgPicture.asset(
                "Assets/Settings/thumbIcon.svg",
                fit: BoxFit.fill,
              ),
              title: Text(
                "Security",
                style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black45),
              ),
              onTap: (){
                Navigator.of(context).pushNamed('/SecuritySettingVC');
              },
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        Container(
          height: 75,
          child: Center(
            child: ListTile(
              leading: SvgPicture.asset(
                "Assets/Settings/infoIcons.svg",
                fit: BoxFit.fill,
              ),
              title: Text(
                "Information",
                style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 18, color: Colors.black45),
              ),
              onTap: (){
                Navigator.of(context).pushNamed('/InformationVC');
              },
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        SizedBox(
          height: 150,
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
        Container(
          height: 75,
          child: Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Sign Out of Cashpot',
                      style: TextStyle( fontFamily: "Helvetica Neue",color:  AppColor.newSignInColor, fontSize: 20),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Sign Out of Cashpot');
                          logout();
                         // Navigator.of(context).pushReplacementNamed('/Login2VC');
                        }),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.black54,
        ),
      ],
    ));

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

        title: Text("Settings",style: TextStyle( fontFamily: "Helvetica Neue",),),
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
      body: UIcont,
    );
  }
}
