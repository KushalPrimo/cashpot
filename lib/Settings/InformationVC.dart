import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
class InformationVC extends StatefulWidget {
  @override
  _InformationVCState createState() => _InformationVCState();
}

class _InformationVCState extends State<InformationVC>
{
  _launchURL() async {
    const url = 'https://www.cashpotapp.com/terms-of-service';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchURL2() async {
    const url = 'https://www.cashpotapp.com/privacy-policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context)
  {
    final settingList = Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Privacy Policy",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){
             // _launchURL2();
             Navigator.of(context).pushNamed('/PrivacyPolicyVC');
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text("Terms of Service",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){
            //  _launchURL();
              Navigator.of(context).pushNamed('/UserAgreementVC');
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text("Fees",
              style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black54,
              size: 50,
            ),
            onTap: (){Navigator.of(context).pushNamed('/FeesVC');},
          ),
          Divider(
            height: 1,
          ),
          // ListTile(
          //   title: Text("Licenses",
          //     style: TextStyle(fontFamily: "Helvetica Neue",color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w500),
          //   ),
          //   trailing: Icon(
          //     Icons.navigate_next,
          //     color: Colors.black54,
          //     size: 50,
          //   ),
          //   onTap: (){
          //
          //     Navigator.of(context).pushNamed('/LicensesVC');
          //   },
          // ),
          // Divider(
          //   height: 1,
          // )
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
        title: Text("Information",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),
      body: settingList,
    );
  }
}
