
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class LicensesVC extends StatefulWidget {
  @override
  _LicensesVCState createState() => _LicensesVCState();
}

class _LicensesVCState extends State<LicensesVC> {
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

        title: Text("Licenses",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),

    );
  }
}
