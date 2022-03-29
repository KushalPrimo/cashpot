import 'dart:async';
import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'HomeVC.dart';

class SingupPopVC extends StatefulWidget
{
  @override
  _SingupPopVCState createState() => _SingupPopVCState();
}

class _SingupPopVCState extends State<SingupPopVC>
{
  startTime() async
  {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() async
  {
    Navigator.of(context).pushNamedAndRemoveUntil('/HomeVC', (Route<dynamic> route) => false);
  }
  @override
  void initState()
  {
    // TODO: implement initState
    startTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.themeColor,
        body: Center(
          child: Container(

            child: Stack(
              children: <Widget>[
                Container(
                  color: AppColor.newSignInColor,
                  width: MediaQuery.of(context).size.width,
                  height:  MediaQuery.of(context).size.height,
                  child: SvgPicture.asset("Assets/GreenBackground1.svg",
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ) /* add child content here */,
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Grow Your Pot",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: "Helvetica Neue",
                            fontStyle: FontStyle.normal
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        width: 171.9,
                        height: 229.39,
                        child: SvgPicture.asset("Assets/potCash.svg",
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      )
                    ],
                  ),
                )



              ],
            ),
          ),
        ),

    );
  }
}
