import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utility.dart';
class UserAgreementVC extends StatefulWidget {
  @override
  _UserAgreementVCState createState() => _UserAgreementVCState();
}

class _UserAgreementVCState extends State<UserAgreementVC>
{
  final Completer<WebViewController> _controller = Completer<WebViewController>();
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

        title: Text("Terms of Service",style: TextStyle(fontFamily: "Helvetica Neue",),),

      ),
body:  WebView(
  initialUrl: 'https://www.cashpotapp.com/terms-of-service',
  javascriptMode: JavascriptMode.unrestricted,
  onWebViewCreated: (WebViewController webViewController) {
    _controller.complete(webViewController);
  },
  // TODO(iskakaushik): Remove this when collection literals makes it to stable.

  onPageStarted: (String url) {
    Utility().onLoading(context, true);
    print('Page started loading');
  },
  onPageFinished: (String url) {
    print('Page finished loading');
    Utility().onLoading(context, false);
  },
  gestureNavigationEnabled: true,
),
    );
  }
}
