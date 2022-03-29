import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'NetworkResponse.dart';
import 'package:http/http.dart' as http;

class NetworkClass
{
  NetworkResponse networkResponse;
  Map jsonBody;
  AlertDialog alertDialog;
  bool isShowing = false;
  String filePath = "";
  int requestCode=0;
  List<dynamic> imageList;
  String baseUrl="";
  String endUrl = "";

  NetworkClass(String url, NetworkResponse networkResponse, int requestCode)
  {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.requestCode = requestCode;
  }

  NetworkClass.fromNetworkClass(String url, NetworkResponse networkResponse, int requestCode, Map jsonBody)
  {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.requestCode = requestCode;
    this.jsonBody = jsonBody;
  }

  NetworkClass.multipartNetworkClass(String url, NetworkResponse networkResponse, int requestCode, Map jsonBody, String filePath)
  {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.requestCode = requestCode;
    this.jsonBody = jsonBody;
    this.filePath = filePath;
  }

  NetworkClass.multipartCreatePollNetworkClass(String url, NetworkResponse networkResponse, int requestCode, Map jsonBody, List<dynamic> imageList)
  {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.requestCode = requestCode;
    this.jsonBody = jsonBody;
    this.imageList = imageList;
  }

  void showLoaderDialog(BuildContext context)
  {
    if (alertDialog != null && isShowing)
    {
      isShowing = false;
      Navigator.pop(context);
    }
    alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 2,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple)),
          SizedBox(width: 20,),
          MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Text("Please wait...")
          )
        ],
      ),
    );
    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alertDialog;});
  }

  Future<void> callPostService(BuildContext context, bool showLoader) async
  {
    if (showLoader)
    {
      print("Showing Loader...");
      isShowing = true;
      showLoaderDialog(context);
    }

    print("PostURLLL " + baseUrl + endUrl);
    print("PostParams " + jsonBody.toString());

    final response = await http.post(Uri.parse(baseUrl + endUrl), body: jsonBody);
    print("---------------->>PostResponse " + response.body.toString());
    print("StatusCodePost " + response.statusCode.toString());

    if (response.statusCode == 200)
    {
      if (showLoader)
      {
        if (alertDialog != null && isShowing)
        {
          isShowing = false;
          Navigator.pop(context);
        }
      }
      networkResponse.onResponse(requestCode: requestCode, response: response.body.toString());
    }
    else
    {
      if (alertDialog != null && isShowing)
      {
        isShowing = false;
        Navigator.pop(context);
      }
      networkResponse.onError(requestCode: requestCode, response: response.body.toString());
    }
  }
}