import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'api_services.dart';
import 'dart:io';

class Preview extends StatefulWidget {
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  String _localFile;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No internet connection !!!")));
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
    APIServices.loadPDF().then((value) {
      setState(() {
        _localFile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          title: Text("Back",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.indigo,
        ),
        preferredSize: Size.fromHeight(60),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _localFile != null
                  ? Container(
                      height: size.height - (MediaQuery.of(context).padding.top + 60),
                      width: size.width,
                      child: PDFView(
                        filePath: _localFile,
                        enableSwipe: true,
                        fitEachPage: true,
                        fitPolicy: FitPolicy.BOTH,
                        swipeHorizontal: true,
                      ),
                    )
                  : Container(
                      height: size.height - (MediaQuery.of(context).padding.top + 60),
                      width: size.width,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[200]),),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
