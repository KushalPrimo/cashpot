import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class NotificationSettingsVC extends StatefulWidget {
  @override
  _NotificationSettingsVCState createState() => _NotificationSettingsVCState();
}

class _NotificationSettingsVCState extends State<NotificationSettingsVC> {

  @override
  Widget build(BuildContext context) {
    final settingList = Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Push Notifications",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/PushNotificationSettingsVC');
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text("Email Notifications",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/EmailNotificationSettingsVC');
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text("Text Notifications",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/TestNotificationSettingsVC');
            },
          ),
          Divider(
            height: 1,
          )
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
        title: Text("Notifications"),

      ),
body: settingList,
    );
  }
}
