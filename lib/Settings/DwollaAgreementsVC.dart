import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utility.dart';

class DwollaAgreementsVC extends StatefulWidget
{
  //const DwollaAgreementsVC({Key? key}) : super(key: key);
  @override
  _DwollaAgreementsVCState createState() => _DwollaAgreementsVCState();
}

class _DwollaAgreementsVCState extends State<DwollaAgreementsVC>
{
  final Completer<WebViewController> controller= Completer<WebViewController>();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(height: 100, child: SvgPicture.asset("Assets/GreenHeader.svg", fit: BoxFit.fill)
        ),
        title: Text("Dwolla's Terms of Services", style: TextStyle(fontFamily: "Helvetica Neue")),
      ),
      body: WebView(
        initialUrl: 'https://www.dwolla.com/legal/tos/',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (WebViewController webViewController)=>controller.complete(webViewController),
        onPageStarted: (String url)=>Utility().onLoading(context, true),
        onPageFinished: (String url)=>Utility().onLoading(context, false)
      ),
    );
  }
}
