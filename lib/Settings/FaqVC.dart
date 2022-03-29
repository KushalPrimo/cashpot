import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class FaqVC extends StatefulWidget {
  @override
  _FaqVCState createState() => _FaqVCState();
}

class _FaqVCState extends State<FaqVC> {
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

        title: Text("FAQ's",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),

    );
  }
}
