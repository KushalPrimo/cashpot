import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ContactUsVC extends StatefulWidget {
  @override
  _ContactUsVCState createState() => _ContactUsVCState();
}

class _ContactUsVCState extends State<ContactUsVC> {
  @override

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

        title: Text("Contact Us",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),

    );
  }
}
