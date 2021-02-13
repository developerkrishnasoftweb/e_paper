import 'dart:async';

import 'package:e_paper/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web extends StatefulWidget {
  final String url;
  Web({this.url});
  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Back",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
      ),
      body: WebView(
        initialUrl: widget.url ?? 'https://vishvasya.krishnasoftweb.com/',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        /* navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.google.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }, */
        onPageStarted: (String url) {
        },
        onPageFinished: (String url) {
        },
        gestureNavigationEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
