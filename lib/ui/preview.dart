import 'dart:ui';

import 'package:e_paper/constant/colors.dart';
import 'package:e_paper/constant/global.dart';
import 'package:e_paper/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Preview extends StatefulWidget {
  final String pdfFilePath;
  Preview({@required this.pdfFilePath}) : assert(pdfFilePath != null);
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  String _localFile;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0, totalPage = 0;

  @override
  void initState() {
    super.initState();
    checkConnection(scaffoldKey: _scaffoldKey);
    Services.loadPDF(pdfFile: widget.pdfFilePath).then((value) {
      setState(() {
        _localFile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Back",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("$currentPage / $totalPage",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold))),
          )
        ],
        backgroundColor: primaryColor,
      ),
      body: _localFile != null
          ? PDFView(
              filePath: _localFile,
              enableSwipe: true,
              fitEachPage: true,
              fitPolicy: FitPolicy.BOTH,
              pageFling: true,
              onPageChanged: (currentIndex, totalPage) {
                setState(() {
                  currentPage = currentIndex + 1;
                  this.totalPage = totalPage;
                });
              },
              onRender: (totalPage) {
                setState(() {
                  this.totalPage = totalPage;
                });
              },
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
    );
  }
}
