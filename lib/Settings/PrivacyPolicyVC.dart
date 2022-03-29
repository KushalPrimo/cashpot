import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utility.dart';
class PrivacyPolicyVC extends StatefulWidget {
  @override
  _PrivacyPolicyVCState createState() => _PrivacyPolicyVCState();
}

class _PrivacyPolicyVCState extends State<PrivacyPolicyVC> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  List<String> hashTags = List<String>();
  void initState() {
    // TODO: implement initState

    String s = "This #is a #tag";
    List<String> splitted = s.split(" ");

    for (var item in splitted) {
      if (item.startsWith("#")) {
        hashTags.add(item);
      }
    }

    print(hashTags);
    super.initState();
  }
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

          title: Text("Privacy Policy",style: TextStyle(fontFamily: "Helvetica Neue",),),

        ),
body:   WebView(
  initialUrl: 'https://www.cashpotapp.com/privacy-policy',
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
