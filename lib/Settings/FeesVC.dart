import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class FeesVC extends StatefulWidget {
  @override
  _FeesVCState createState() => _FeesVCState();
}

class _FeesVCState extends State<FeesVC> {
  @override
  Widget build(BuildContext context) {
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

        title: Text("Fees",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),

    );
  }
}
