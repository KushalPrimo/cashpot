import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';

class LoginVC extends StatefulWidget {
  @override
  _LoginVCState createState() => _LoginVCState();
}

class _LoginVCState extends State<LoginVC> {
  final logoCont = Container(
    child: Center(
      child: Image.asset(
        "Assets/loginlogo.png",
        fit: BoxFit.fill,
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {
    final itemsCont = Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,

          ),
          FlatButton(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              child: Image.asset(
                "Assets/fb.png",
                fit: BoxFit.fill,
              ),
              onPressed: () {}),
          SizedBox(
            height: 15,
          ),
          FlatButton(
              padding: EdgeInsets.zero,
              child: Image.asset(
                "Assets/twitter.png",
                fit: BoxFit.fill,
              ),
              onPressed: () {}),
          SizedBox(
            height: 15,
          ),
          Text(
            "Or",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.w400,
                color: Colors.white
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FlatButton(
              padding: EdgeInsets.zero,
              child: Image.asset(
                "Assets/email.png",
                fit: BoxFit.fill,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/EmailSignupVC');

              })
        ],
      ),
    );
    return Scaffold(
        backgroundColor: AppColor.themeColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 130,
            ),
            logoCont,

            itemsCont

          ],
        ));
  }
}
