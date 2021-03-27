import 'dart:ui';

import '../constant/colors.dart';
import '../services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

_PreviewState previewState;
class Preview extends StatefulWidget {
  final String pdfFilePath;
  Preview({@required this.pdfFilePath}) : assert(pdfFilePath != null);
  @override
  _PreviewState createState() {
    previewState = _PreviewState();
    return previewState;
  }
}

class _PreviewState extends State<Preview> {
  String _localFile;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0, totalPage = 0;
  double downloadStatus = 0;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }
  loadPdf () async {
    await Services.loadPDF(pdfFile: widget.pdfFilePath).then((value) {
      setState(() {
        _localFile = value;
      });
    });
  }
  downloadProgress (received, total) {
    setState(() {
      downloadStatus = received / total;
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      value: downloadStatus,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  Text((downloadStatus * 100).toStringAsFixed(0) + "%", style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.center)
                ],
              ),
            ),
    );
  }
}
