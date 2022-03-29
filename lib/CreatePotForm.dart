import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ContactNewClientVC.dart';
import 'ContactNewVC.dart';
import 'ContactVC.dart';
import 'Message.dart';
import 'NewContactVC.dart';
import 'Style/Color.dart';
import 'Utility.dart';
TextEditingController _PotName = new TextEditingController();
TextEditingController _GoalAmount = new TextEditingController();
TextEditingController _AmntPerPerson = new TextEditingController();
TextEditingController _EndDate = new TextEditingController();

class CreatePotForm extends StatefulWidget {
  @override
  _CreatePotFormState createState() => _CreatePotFormState();
}

class _CreatePotFormState extends State<CreatePotForm> {
  bool checkBoxVal = false;
String checkBoxValStr = "0";
  DateTime selectedDate = DateTime.now();
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String EnteredGoalAmnt = "";
  String EnteredAmntPerPerson = "";

  formValidation() async {
    FocusScope.of(context).requestFocus(FocusNode());
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (_PotName.text.isEmpty) {
      Utility().toast(context, Message().potNameMsg);
    }
    else if (_PotName.text.length < 3 || _PotName.text.length > 18) {
      //Do Here
      Utility().toast(context, Message().PotnameCharMsg);
    }
    //_GoalAmount.text.isNotEmpty
    //_AmntPerPerson.text.isNotEmpty
    else if(EnteredGoalAmnt != "" && EnteredAmntPerPerson != ""){
     // _GoalAmount.text
      //_AmntPerPerson.text
      if(int.parse(EnteredGoalAmnt) < int.parse(EnteredAmntPerPerson)){
        Utility().toast(context, "Goal amount should not less than amount per person");
      }
      else {
        //DO HERE Call
        sharedPreferences.setString("PotName", _PotName.text.toString());
        sharedPreferences.setString("GoalAmount", EnteredGoalAmnt);//_GoalAmount.text.toString()
        sharedPreferences.setString("AmntPerPerson", EnteredAmntPerPerson);//_AmntPerPerson.text.toString()
        sharedPreferences.setString("EndDate", _EndDate.text.toString());
        sharedPreferences.setString("isShown", checkBoxValStr);

     //   Navigator.of(context).pushNamed('/ContactVC');
       // Navigator.of(context).pushNamed('/ContactNewClientVC');
        ///16Aug
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ContactNewClientVC(
        //         "createPot"
        //     ))
        // );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContactNewVC(
                "createPot"
            ))
        );

        //  LoginAPI();
      }
    }
    else {
      //DO HERE Call API
      sharedPreferences.setString("PotName", _PotName.text.toString());
      sharedPreferences.setString("GoalAmount", EnteredGoalAmnt); //_GoalAmount.text.toString()
      sharedPreferences.setString("AmntPerPerson", EnteredAmntPerPerson); //_AmntPerPerson.text.toString()
      sharedPreferences.setString("EndDate", _EndDate.text.toString());
      sharedPreferences.setString("isShown", checkBoxValStr);
      print("dhcbeh");
      ///16Aug
     // Navigator.of(context).pushNamed('/ContactVC');
     //  Navigator.of(context).push(MaterialPageRoute(
     //      builder: (context) => ContactNewClientVC(
     //        "createPot"
     //      ))
     //  );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ContactNewVC(
              "createPot"
          ))
      );
    }
  }
clearTFData(){

  _PotName.text = "";
  _GoalAmount.text = "";
  EnteredGoalAmnt = "";
  _AmntPerPerson.text = "";
  EnteredAmntPerPerson = "";
  _EndDate.text = "";
}
  final assetLogo = Container(
    child: Center(
      child: SvgPicture.asset("Assets/Clogo01.svg",
        fit: BoxFit.fill,
      )
    ),
  );

  dialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      // type: AlertType.success,
      title: "Cashpot",
      desc: message,
      buttons: [
        DialogButton(
          color: AppColor.themeColor,
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

          },
          width: 120,
        ),
      ],
    ).show();
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xff0A5C2F),
                onSurface: Color(0xff0A5C2F),

            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
          ),
          child: child,
        );
      },
      //initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var outputFormat = DateFormat('MM-dd-yyyy');
        var outputDate = outputFormat.format(selectedDate);
      //  print("Selected date------${outputDate}");
        _EndDate.text = outputDate;
      });
  }
  @override
  void initState() {
    // TODO: implement initState
    clearTFData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final formUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          TextField(
             controller: _PotName,
            cursorColor: AppColor.themeColor,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            inputFormatters: [
              LengthLimitingTextInputFormatter(18),
            ],
            decoration: new InputDecoration(
                // prefixIcon: Icon(Icons.person_outline),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 1, color: AppColor.themeColor),
                ),
                filled: true,
                hintStyle: new TextStyle(fontFamily: "Helvetica Neue",color: Colors.grey[800]),
                hintText: "Pot Name",
                fillColor: Colors.white70),

          ),
          SizedBox(
            height: 15,
          ),
          TextField(
             controller: _GoalAmount,
            cursorColor: AppColor.themeColor,
            inputFormatters: [
             // FilteringTextInputFormatter.digitsOnly
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            decoration: new InputDecoration(
                // prefixIcon: Icon(Icons.person_outline),

                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 1, color: AppColor.themeColor),
                ),
                filled: true,
                hintStyle: new TextStyle(fontFamily: "Helvetica Neue",color: Colors.grey[800]),
                hintText: "Goal Amount (Optional)",
                fillColor: Colors.white70),
           // keyboardType: TextInputType.number,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              onChanged: (string) {
    string = '\$${_formatNumber(string.replaceAll(',', ''))}';
    _GoalAmount.value = TextEditingValue(
    text: string,
    selection: TextSelection.collapsed(offset: string.length),
    );
    },
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
             controller: _AmntPerPerson,
            cursorColor: AppColor.themeColor,
              inputFormatters: [
               // FilteringTextInputFormatter.digitsOnly
                WhitelistingTextInputFormatter.digitsOnly,
              ],
            decoration: new InputDecoration(
                // prefixIcon: Icon(Icons.person_outline),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 1, color: AppColor.themeColor),
                ),
                filled: true,
                hintStyle: new TextStyle(fontFamily: "Helvetica Neue",color: Colors.grey[800]),
                hintText: "Amount Per Person (Optional)",
                fillColor: Colors.white70),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            onChanged: (string) {
              string = '\$${_formatNumber(string.replaceAll(',', ''))}';
              _AmntPerPerson.value = TextEditingValue(
                text: string,
                selection: TextSelection.collapsed(offset: string.length),
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
             controller: _EndDate,
            cursorColor: AppColor.themeColor,
            decoration: new InputDecoration(
                // prefixIcon: Icon(Icons.person_outline),

                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),

                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 1, color: AppColor.themeColor),
                ),
                filled: true,
                hintStyle: new TextStyle(fontFamily: "Helvetica Neue",color: Colors.grey[800]),
                hintText: "End Date (Optional)",
                fillColor: Colors.white70),
            readOnly: true,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate(context);
            },
          ),
          SizedBox(
            height: 25,
          ),
          Divider(
            height: 1,
            color: Colors.black,
          ),
          ///Commented by client
          // SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   children: <Widget>[
          //     Container(
          //       child: IconButton(
          //         icon: checkBoxVal == false
          //             ? Icon(
          //                 Icons.check_box_outline_blank,
          //                 color: AppColor.newSignInColor,
          //                 size: 25,
          //               )
          //             : Icon(
          //                 Icons.check_box,
          //                 color: AppColor.newSignInColor,
          //                 size: 25,
          //               ),
          //         onPressed: () {
          //           if (checkBoxVal == false) {
          //             setState(() {
          //               checkBoxValStr = "0";
          //               checkBoxVal = true;
          //
          //             });
          //           } else {
          //             setState(() {
          //               checkBoxValStr = "1";
          //               checkBoxVal = false;
          //             });
          //           }
          //         },
          //       ),
          //     ),
          //     Text(
          //       "Do not show members amount added",
          //       style: TextStyle(
          //         color: AppColor.homeTextColor,
          //         fontSize: 14,
          //         fontFamily: "Helvetica Neue",
          //         fontWeight: FontWeight.w400,
          //       ),
          //     )
          //   ],
          // ),
          SizedBox(
            height: 25,
          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)),
            child: Text(
              "                  Next                  ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              EnteredGoalAmnt =
                  _GoalAmount.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
              EnteredAmntPerPerson =
                  _AmntPerPerson.text.replaceAll(new RegExp(r'[^\w\s]+'), '');
        //  print(EnteredGoalAmnt);
       //   print(EnteredAmntPerPerson);

            formValidation();


            // Navigator.of(context).pushNamed('/NewContactVC');
            },
          )
        ],//
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
        title:  SvgPicture.asset("Assets/appName.svg",fit: BoxFit.cover),
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            assetLogo,
            formUI
          ],
        ),
      ),
    );
  }
}
