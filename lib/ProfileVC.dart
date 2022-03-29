import 'dart:convert';
import 'package:cashpot/ModelClasses/ProfileData.dart';
import 'package:cashpot/uploadImageData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Message.dart';
import 'Style/Color.dart';
import 'Utility.dart';
import 'WebServices.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:io';

TextEditingController _FnameTF = new TextEditingController();
TextEditingController _LnameTF = new TextEditingController();
TextEditingController _UsernameTF = new TextEditingController();
TextEditingController _EmailTF = new TextEditingController();
TextEditingController _PhoneTF = new TextEditingController();

class ProfileVC extends StatefulWidget {
  @override
  _ProfileVCState createState() => _ProfileVCState();
}

class _ProfileVCState extends State<ProfileVC> {
  ProfileData profileData;
  ProfileErrorData profileErrorData;
  UploadImageData uploadImageData;
  var maskedController = MaskedTextController(mask: '(000) 000-0000');

  ///For Phone Number
  _NumberTextInputFormatter _phoneNumberFormatter = _NumberTextInputFormatter(1);
  File _image;
  String profilePicStr = "";

  setdetail() async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      var nameAry = profileData.data.name.toString().split(" ");
     // print("nameAry-----${nameAry}");
      if(nameAry.length == 2){
        _FnameTF.text = nameAry[0].toString();
        _LnameTF.text = nameAry[1].toString();
      }else{
        _FnameTF.text = nameAry[0].toString();
      }
   //   _LnameTF.text = profileData.data.lastName.toString();
      _UsernameTF.text = profileData.data.username.toString();
      _EmailTF.text = profileData.data.email.toString();
      maskedController.text = profileData.data.number.toString();

      _PhoneTF.text =  maskedController.text;
      if(profileData.data.image.toString() != "null"){
        profilePicStr = "${Webservice().imagePath}${profileData.data.image.toString()}";
      }
      sharedPreferences.setString("Fname", profileData.data.name.toString());
      sharedPreferences.setString("UserName", profileData.data.username.toString());

    });
  }
  getProfileAPI() async {
    // Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("UserID").toString(),
      'login_id': sharedPreferences.getString("UserID").toString(),
    };
    //  print('data-------------${data}');
    //  print("${Webservice().apiUrl}${Webservice().getuserinfo}");
    String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
    var response = await http.post(
        "${Webservice().apiUrl}${Webservice().getuserinfo}",
        body: data,
        headers: <String, String>{
          'authorization': basicAuth,
        });
    Map resData = json.decode(response.body) as Map;
    //print("resData-----_${resData}");
    if (resData["status"] == 1) {
      profileData = ProfileData.fromJson(json.decode(response.body));
     print("profileData-------${profileData.data.toJson()}");
      setdetail();
    } else {
      profileErrorData = ProfileErrorData.fromJson(json.decode(response.body));
      //Utility().toast(context, profileErrorData.message.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      getProfileAPI();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getProfileAPI() async {
      // Utility().onLoading(context, true);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        'user_id': sharedPreferences.getString("UserID").toString(),
        'login_id': sharedPreferences.getString("UserID").toString(),
      };
      // print('data-------------${data}');
      //  print("${Webservice().apiUrl}${Webservice().getuserinfo}");
      String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
      var response = await http.post(
          "${Webservice().apiUrl}${Webservice().getuserinfo}",
          body: data,
          headers: <String, String>{
            'authorization': basicAuth,
          });
       // print("RES=========${json.decode(response.body) as Map}");
       Utility().onLoading(context, false);
      Map resData = json.decode(response.body) as Map;
      //print("resData-----_${resData}");
//     print("Running........");
      if (resData["status"] == 1) {
        profileData = ProfileData.fromJson(json.decode(response.body));
        print("profileData-------${profileData.data.toJson()}");
        setdetail();
      } else {
        profileErrorData = ProfileErrorData.fromJson(json.decode(response.body));
        // Utility().toast(context, profileErrorData.message.toString());
      }
    }
    editProfileAPI() async {
       Utility().onLoading(context, true);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      //maskedController
       String numbf = _PhoneTF.text.replaceAll(new RegExp(r"[^\s\w]"), '');
       String trimStr = numbf.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      Map data = {
        'user_id': sharedPreferences.getString("UserID").toString(),
        'login_id': sharedPreferences.getString("UserID").toString(),
        "name" : _FnameTF.text +" "+ _LnameTF.text,
       // "last_name" : _LnameTF.text,
        "number" : trimStr,
        "username" : _UsernameTF.text,
        "email" : _EmailTF.text,
      };
       print('data-------------${data}');
      //  print("${Webservice().apiUrl}${Webservice().getuserinfo}");
      String basicAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
      var response = await http.post(
          "${Webservice().apiUrl}${Webservice().editprofile}",
          body: data,
          headers: <String, String>{
            'authorization': basicAuth,
          });
      //  print("RES=========${json.decode(response.body) as Map}");
      Map resData = json.decode(response.body) as Map;
      print("resData-----_${resData}");
//     print("Running........");
      if (resData["status"] == 1) {
       // profileData = ProfileData.fromJson(json.decode(response.body));
        //print("profileData-------${profileData.data.toJson()}");
        FocusScope.of(context).requestFocus(FocusNode());
        getProfileAPI();
      } else {
       // profileErrorData = ProfileErrorData.fromJson(json.decode(response.body));
         Utility().toast(context, "Something went wrong");
      }
    }

    void _uploadImage() async {
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences = await SharedPreferences.getInstance();
      // open a bytestream
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // get file length
      var length = await _image.length();
      // string to uri
      var uri = Uri.parse("${Webservice().apiUrl}${Webservice().uploadimage}");
      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      // multipart that takes file
      String tokenAuth = "Bearer ${sharedPreferences.getString("AuthToken")}";
      Map<String, String> headers = {"authorization": tokenAuth};
      request.headers.addAll(headers);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(_image.path));

      // add file to multipart
      request.files.add(multipartFile);
      request.fields["login_id"] =
          sharedPreferences.getString("UserID").toString();
      request.fields["user_id"] =
          sharedPreferences.getString("UserID").toString();
      //   request.fields["user_id"] = sharedPreferences.getString("userID");
      // send
      var response = await request.send();
      //print(response.statusCode);
      Utility().onLoading(context, false);
        response.stream.transform(utf8.decoder).listen((value) {
          // print("value-----------${value}");
          uploadImageData = UploadImageData.fromJson(json.decode(value));
          if (uploadImageData.status.toString() == "1") {
            //print("uploadImageData-------${uploadImageData.data.toString()}");
            setState(() {
              profilePicStr = "${uploadImageData.data.toString()}";
              //print("profilePicStr---------${profilePicStr}");
              sharedPreferences.setString("profileImage", profilePicStr);
            });
          } else {
            Utility().toast(context, Message().imageuploadErorMgs);
          }
        });

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        //  print("value----------${value}");
      });
    }

    Future getImage() async {
      var image = await ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 300, maxWidth: 300);
      setState(() {
        _image = image;
        if (_image != null) {
          _uploadImage();
        }
      });
    }

    Future getGallery() async {
      try {
        final imageFile = await ImagePicker.pickImage(
            source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
        setState(() {
          _image = imageFile;
          if (_image != null) {
            _uploadImage();
          }
        });
      } catch (e) {
        print(e);
      }
    }

    actionSheetMethod(BuildContext context) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
            title: const Text(
              'Cashpot',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Helvetica Neue",
                color: Color(0xff00A651),
              ),
            ),
            // message: const Text('Please Select'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text("Open Camera",style: TextStyle( fontFamily: "Helvetica Neue",),),
                onPressed: () {
                  getImage();
                  Navigator.pop(context, 'Camera');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Open Gallery',style: TextStyle( fontFamily: "Helvetica Neue",),),
                onPressed: () {
                  getGallery();
                  Navigator.pop(context, 'Gallery');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Cancel',
                style: TextStyle( fontFamily: "Helvetica Neue",color: Colors.red),
              ),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            )),
      );
    }

    final profilePic = Container(
        child: Material(
      elevation: 4.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink.image(

        image: profilePicStr == ""
            ? AssetImage('Assets/profiledummy.png')
            : NetworkImage(profilePicStr),
        fit: BoxFit.cover,
        width: 120.0,
        height: 120.0,

        child: InkWell(
          onTap: () {
            actionSheetMethod(context);
          },
        ),
      ),
    ));
    final detailsCont = Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 50),
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _FnameTF,
              cursorColor: AppColor.themeColor,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),

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
                    borderSide: BorderSide(width: 3, color: Colors.grey),
                  ),
              hintText: "First name"
              ),
            ),
         SizedBox(
           height: 20,
         ),
         TextField(
           controller: _LnameTF,
           cursorColor: AppColor.themeColor,
           textCapitalization: TextCapitalization.words,
           autocorrect: false,
           inputFormatters: [
             LengthLimitingTextInputFormatter(20),
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
               borderSide: BorderSide(width: 3, color: Colors.grey),
             ),
               hintText: "Last name"

           ),
         ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _UsernameTF,
              cursorColor: AppColor.themeColor,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
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
                  hintText: "username"
                 ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _EmailTF,
              cursorColor: AppColor.themeColor,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
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

              ),
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _PhoneTF,
              cursorColor: AppColor.themeColor,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
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

              hintText: "Phone number"
              ),
              keyboardType: TextInputType.numberWithOptions(
                  signed: true, decimal: true),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "You will receive a SMS to confirm your identity. Msg & data rates may apply.",
                style: TextStyle( fontFamily: "Helvetica Neue",fontSize: 14, color: Colors.black54),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());

        },
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

        title: Text("Edit Profile",style: TextStyle( fontFamily: "Helvetica Neue",),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),
        actions: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    "Save",
                    style: TextStyle( fontFamily: "Helvetica Neue",color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
            onTap: () {
              print("Save Clicked");
             // Utility().toast(context, "Work In-progress.");
              FocusScope.of(context).requestFocus(FocusNode());
             editProfileAPI();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            profilePic,
            detailsCont
          ],
        ),
      ),
    );
  }
}
//For Phone number format.
class MaskedTextController extends TextEditingController {
  MaskedTextController({String text, this.mask, Map<String, RegExp> translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    this.addListener(() {
      var previous = this._lastUpdatedText;
      if (this.beforeChange(previous, this.text)) {
        this.updateText(this.text);
        this.afterChange(previous, this.text);
      } else {
        this.updateText(this._lastUpdatedText);
      }
    });

    this.updateText(this.text);
  }

  String mask;

  Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if(text != null){
      this.text = this._applyMask(this.mask, text);
    }
    else {
      this.text = '';
    }

    this._lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    this.updateText(this.text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    var text = this._lastUpdatedText;
    this.selection = new TextSelection.fromPosition(
        new TextPosition(offset: (text ?? '').length));
  }

  @override
  void set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      this.moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': new RegExp(r'[A-Za-z]'),
      '0': new RegExp(r'[0-9]'),
      '@': new RegExp(r'[A-Za-z0-9]'),
      '*': new RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (this.translator.containsKey(maskChar)) {
        if (this.translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}



///For the Phone Number
class _NumberTextInputFormatter extends TextInputFormatter {
  int _whichNumber;
  _NumberTextInputFormatter(this._whichNumber);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
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