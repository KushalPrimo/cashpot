import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'CodeVerifyVC.dart';
import 'Message.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';

class PhoneVerifyVC extends StatefulWidget
{
  @override
  _PhoneVerifyVCState createState() => _PhoneVerifyVCState();
}
TextEditingController _PhoneNumberTF = new TextEditingController();
class _PhoneVerifyVCState extends State<PhoneVerifyVC>
{
  var rndnumber = "";
  String dropdownValue = '+91';
 // var maskedController = MaskedTextController(mask: '(000) 000-0000');
///For Phone Number
  _NumberTextInputFormatter _phoneNumberFormatter =
  _NumberTextInputFormatter(1);
  final assetLogo = Container(
    child: Center(
      child: SvgPicture.asset("Assets/Clogo01.svg",
        fit: BoxFit.fill,
      )
    ),
  );
  //For OTP dialogbox
  dialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      // type: AlertType.success,
      title: "Dummy OTP",
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
          onPressed: ()
          {
            Navigator.of(context, rootNavigator: true).pop();
           // Navigator.of(context).pushNamed('/CodeVerifyVC');
            //maskedController
            String numbf = _PhoneNumberTF.text.replaceAll(new RegExp(r"[^\s\w]"), '');
            String trimStr = numbf.replaceAll(new RegExp(r"\s+\b|\b\s"), "");

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CodeVerifyVC(
                    "$rndnumber",
                    "${trimStr}",
                  "${trimStr}",

                    ))
            );
          },
          width: 120,
        ),
      ],
    ).show();
  }

  OtpAPI() async
  {

    Utility().onLoading(context, true);

    //maskedController

    String numbf = _PhoneNumberTF.text.replaceAll(new RegExp(r"[^\s\w]"), '');
    String trimStr = numbf.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    Map data = {
      'number': "$dropdownValue$trimStr",
      "num_without_code": trimStr
    };
      print("data---sent------$data");
    var response = await http.post("${Webservice().apiUrl}${Webservice().verifyNumber}", body: data);
    //  print("RES=========${json.decode(response.body) as Map}");
    Utility().onLoading(context, false);
    Map resData = json.decode(response.body) as Map;

     print("Running........$resData");
    if (resData["status"] == 1)
    {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CodeVerifyVC("${resData["otp"].toString()}", "$dropdownValue$trimStr", "$trimStr")));
      _PhoneNumberTF.text = "";
     // Navigator.of(context).pushReplacementNamed('/HomeVC');
    }
    else
    {
      Utility().toast(context,"${resData["msg"].toString()}");
    }
  }
  phoneValidation()
  {
    //maskedController
    if(_PhoneNumberTF.text.isEmpty)
    {
      Utility().toast(context, Message().PhoneErr);
    }
    else if(_PhoneNumberTF.text.length < 10)
    {

      Utility().toast(context, Message().PhoneErrMsg);
    }else
    {
      OtpAPI();
    }
  }
  @override
  Widget build(BuildContext context)
  {
    final formUI = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0,top: 15),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            //color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                   // color: Colors.green,
                     // height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey,width: 3),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0,)
                        ),
                      ),
                    child:DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['+91', '+1', ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle( fontFamily: "Helvetica Neue",),),
                        );
                      }).toList(),
                    )
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    //color: Colors.red,
                    child: TextField(
                      controller: _PhoneNumberTF,//maskedController,
                      cursorColor: AppColor.themeColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        // Fit the validating format.
                        _phoneNumberFormatter,
                      ],
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Helvetica Neue",
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(31.0)),
                            borderSide: BorderSide(width: 3,color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(31.0)),
                            borderSide: BorderSide(width: 3,color: Colors.grey),
                          ),
                          hintText: 'Enter Phone Number',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: "Helvetica Neue",
                          )

                      ),
                      //maxLength: 10,
                      keyboardType: TextInputType.number,
                      // keyboardType: TextInputType.numberWithOptions(
                      //     signed: true, decimal: true),
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 150,
          ),
          RaisedButton(
            color: AppColor.newSignInColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColor.newSignInColor)
            ),
            child: Text("                  Send Code                  ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w500
              ),
            ),
            onPressed: (){
              phoneValidation();
            },
          ),
          SizedBox(height: 30),
          Text(
            "We send a one time SMS to confirm your identity Carrier rates will apply",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black54,
              fontFamily: "Helvetica Neue",
              fontSize: 14,

            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
      //  backgroundColor: AppColor.themeColor,
        flexibleSpace:
        Container(
          height: 100,
          child: SvgPicture.asset("Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),

        title: Text(
          "Verify Phone",
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
            _PhoneNumberTF.text = "";
            Navigator.pop(context);

          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            assetLogo,
            SizedBox(
              height: 100,
            ),
            formUI
          ],
        ),
      ),
    );
  }
}
//For Phone number format.
// class MaskedTextController extends TextEditingController {
//   MaskedTextController({String text, this.mask, Map<String, RegExp> translator})
//       : super(text: text) {
//     this.translator = translator ?? MaskedTextController.getDefaultTranslator();
//
//     this.addListener(() {
//       var previous = this._lastUpdatedText;
//       if (this.beforeChange(previous, this.text)) {
//         this.updateText(this.text);
//         this.afterChange(previous, this.text);
//       } else {
//         this.updateText(this._lastUpdatedText);
//       }
//     });
//
//     this.updateText(this.text);
//   }
//
//   String mask;
//
//   Map<String, RegExp> translator;
//
//   Function afterChange = (String previous, String next) {};
//   Function beforeChange = (String previous, String next) {
//     return true;
//   };
//
//   String _lastUpdatedText = '';
//
//   void updateText(String text) {
//     if(text != null){
//       this.text = this._applyMask(this.mask, text);
//     }
//     else {
//       this.text = '';
//     }
//
//     this._lastUpdatedText = this.text;
//   }
//
//   void updateMask(String mask, {bool moveCursorToEnd = true}) {
//     this.mask = mask;
//     this.updateText(this.text);
//
//     if (moveCursorToEnd) {
//       this.moveCursorToEnd();
//     }
//   }
//
//   void moveCursorToEnd() {
//     var text = this._lastUpdatedText;
//     this.selection = new TextSelection.fromPosition(
//         new TextPosition(offset: (text ?? '').length));
//   }
//
//   @override
//   void set text(String newText) {
//     if (super.text != newText) {
//       super.text = newText;
//       this.moveCursorToEnd();
//     }
//   }
//
//   static Map<String, RegExp> getDefaultTranslator() {
//     return {
//       'A': new RegExp(r'[A-Za-z]'),
//       '0': new RegExp(r'[0-9]'),
//       '@': new RegExp(r'[A-Za-z0-9]'),
//       '*': new RegExp(r'.*')
//     };
//   }
//
//   String _applyMask(String mask, String value) {
//     String result = '';
//
//     var maskCharIndex = 0;
//     var valueCharIndex = 0;
//
//     while (true) {
//       // if mask is ended, break.
//       if (maskCharIndex == mask.length) {
//         break;
//       }
//
//       // if value is ended, break.
//       if (valueCharIndex == value.length) {
//         break;
//       }
//
//       var maskChar = mask[maskCharIndex];
//       var valueChar = value[valueCharIndex];
//
//       // value equals mask, just set
//       if (maskChar == valueChar) {
//         result += maskChar;
//         valueCharIndex += 1;
//         maskCharIndex += 1;
//         continue;
//       }
//
//       // apply translator if match
//       if (this.translator.containsKey(maskChar)) {
//         if (this.translator[maskChar].hasMatch(valueChar)) {
//           result += valueChar;
//           maskCharIndex += 1;
//         }
//
//         valueCharIndex += 1;
//         continue;
//       }
//
//       // not masked value, fixed char on mask
//       result += maskChar;
//       maskCharIndex += 1;
//       continue;
//     }
//
//     return result;
//   }
// }


//NEW

///For the Phone Number
class _NumberTextInputFormatter extends TextInputFormatter
{
  int _whichNumber;
  _NumberTextInputFormatter(this._whichNumber);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue,)
  {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    switch (_whichNumber) {
      case 1:
        {
          if (newTextLength >= 1 ) {
            newText.write('(');
            if (newValue.selection.end >= 1) selectionIndex++;
          }
          if (newTextLength >= 4 ) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
            if (newValue.selection.end >= 3) selectionIndex += 2;
          }
          if (newTextLength >= 7 ) {
            newText.write(
                newValue.text.substring(3, usedSubstringIndex = 6) + '-');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          if (newTextLength >= 11 ) {
            newText.write(
                newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
            if (newValue.selection.end >= 10) selectionIndex++;
          }
          break;
        }
      case 91:
        {
          if (newTextLength >= 5) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 5) + ' ');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          break;
        }
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}