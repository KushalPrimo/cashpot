import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Style/Color.dart';
class PotDetailVC extends StatefulWidget {
  @override
  _PotDetailVCState createState() => _PotDetailVCState();
}

class _PotDetailVCState extends State<PotDetailVC> {
  @override
  Widget build(BuildContext context) {
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
        title: Text("Pot Detail",
          style: TextStyle(
              fontSize: 22,
              fontFamily: "Helvetica Neue",
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
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
      ),

    );
  }
}
