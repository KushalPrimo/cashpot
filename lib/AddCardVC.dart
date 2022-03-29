import 'package:cashpot/Style/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddCardVC extends StatefulWidget {
  @override
  _AddCardVCState createState() => _AddCardVCState();
}

class _AddCardVCState extends State<AddCardVC> {
  @override
  Widget build(BuildContext context) {
    final PersonalPotHeadCont = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
      child: Text(
        "Add new debit card:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Helvetica Neue",
          fontSize: 18,
          color: AppColor.newSignInColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
    final cardNumCont = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
      child: TextField(
        //  controller: _SsnTF,
        cursorColor: AppColor.themeColor,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Helvetica Neue",
          fontSize: 18,
        ),
        decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: 'Card Number',
            hintStyle: TextStyle(
              color: Colors.black54,
              fontFamily: "Helvetica Neue",
            )),
        keyboardType: TextInputType.number,
        // obscureText: true
      ),
    );
    final secCont = Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            //  controller: _SsnTF,
            cursorColor: AppColor.themeColor,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Exp Date',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            keyboardType: TextInputType.number,
            // obscureText: true
          ),
          TextField(
            //  controller: _SsnTF,
            cursorColor: AppColor.themeColor,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
            decoration: InputDecoration(
//            enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.white),
//            ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Security Code',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Helvetica Neue",
                )),
            keyboardType: TextInputType.number,
            // obscureText: true
          ),
        ],
      ),
    );
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

          title: Text("Add Card",style: TextStyle(fontFamily: "Helvetica Neue",),),
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
        body: ListView(
            children: <Widget>[
              PersonalPotHeadCont,
              cardNumCont,

             // secCont
            ],
        )
    );
  }
}
