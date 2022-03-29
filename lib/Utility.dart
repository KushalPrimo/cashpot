import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import 'Style/Color.dart';

class Utility
{
  dialogAlert(BuildContext context, String message)
  {
    //AppColors appColors=AppColors();
    Alert(
      context: context,
      title: "Confirmation",
      style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false,
          //backgroundColor: appColors.PRIMARY_COLOR,
          titleStyle: TextStyle(color: Colors.black),
          descStyle: TextStyle(color: Colors.black)),
      desc: message,
      buttons: [
        DialogButton(
          color: Colors.purple,
          child: Text(
            "OK",
            style: TextStyle(
              //color: appColors.secondaryColor,
              //fontFamily: "Helvetica Neue",
              fontSize: 18,
            ),
          ),
          onPressed: ()
          {
            Navigator.of(context, rootNavigator: true).pop();
            //Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }
  toast(BuildContext context, String message)
  {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: AppColor.newSignInColor);
    //   backgroundColor: Color(0xff4725a3));
  }
  errorToast(BuildContext context, String message,Color toastClor)
  {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: toastClor);
    //   backgroundColor: Color(0xff4725a3));
  }
  errorToastForRequest(BuildContext context, String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.red);
    //   backgroundColor: Color(0xff4725a3));
  }
//For custom loading
  void onLoading(BuildContext context, bool iSloading)
  {
    if (iSloading == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new CircularProgressIndicator(),
                  SizedBox(width: 20.0,),
                  new Text("Please wait..."),
                ],
              ),
            ),
          );
        },
      );
    }else{
      // Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    }

  }
}