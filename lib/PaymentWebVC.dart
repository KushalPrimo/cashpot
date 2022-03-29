import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'Utility.dart';
class PaymentWebVC extends StatefulWidget
{
  final String tokenStr;
  const PaymentWebVC(this.tokenStr);

  @override
  _PaymentWebVCState createState() => _PaymentWebVCState();
}

class _PaymentWebVCState extends State<PaymentWebVC>
{
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  //WebView.platform = SurfaceAndroidWebView();

  @override
  void initState()
  {
    // TODO: implement initState
    //112.196.54.37
    print('http://3.130.228.241/cashpot/test.html?token=${widget.tokenStr}');
   // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false, //Solves Issue for Keyboard:)
      appBar: AppBar(
        //backgroundColor: AppColor.themeColor,
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          "Payment",
          style: TextStyle(
              fontFamily: "Helvetica Neue",fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.close,size: 32,),
            tooltip: "Save Todo and Retrun to List",
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/HomeVC', (Route<dynamic> route) => false);

            },
          )
        ],
        //automaticallyImplyLeading: false,
      ),
      body:  WebView(
        initialUrl: 'http://3.130.228.241/cashpot/test.html?token=${widget.tokenStr}',
       javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController)
        {
          _controller.complete(webViewController);
        },
        // TODO(iskakaushik): Remove this when collection literals makes it to stable.

        onPageStarted: (String url)
        {
          Utility().onLoading(context, true);
          // print('Page started loading: $url');
        },
        onPageFinished: (String url)
        {
          //  print('Page finished loading: $url');
          Utility().onLoading(context, false);
        },
        gestureNavigationEnabled: true,
      )
    );
  }
}
