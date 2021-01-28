import 'dart:ui';

import 'package:e_paper/constant/colors.dart';
import 'package:e_paper/constant/global.dart';
import 'package:e_paper/services/urls.dart';
import 'package:e_paper/static/drawer.dart';
import 'package:e_paper/static/loader.dart';
import 'package:e_paper/ui/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/services.dart';
import '../signin_signup/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<FeedData> feedData = [];
  @override
  void initState() {
    super.initState();
    getFeed();
  }

  getFeed() async {
    await Services.getFeed().then((value) {
      if (value.response) {
        for (int i = 0; i < value.data[0].length; i++) {
          setState(() {
            feedData.add(FeedData(
                id: value.data[0][i]["id"],
                title: value.data[0][i]["title"],
                description: value.data[0][i]["description"],
                pdfFile: value.data[0][i]["pdf_file"],
                createdAt: value.data[0][i]["created_at"],
                previewImage: value.data[0][i]["preview_image"]));
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: value.message.toString(), gravity: ToastGravity.BOTTOM);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        key: _scaffoldKey,
        drawer: drawer(context: context, scaffoldKey: _scaffoldKey),
        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  child: Text(
                    "LOG OUT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    Loader(context: context, text: "Logging out ...");
                    sharedPreferences.clear().then((value) {
                      if (value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                            (route) => false);
                      }
                    });
                  },
                ),
              ),
            )
          ],
          backgroundColor: primaryColor,
        ),
        body: feedData.length > 0
            ? GridView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: size.width /
                        (orientation == Orientation.portrait ? 400 : 500)),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: primaryColor,
                            width: 1.5,
                            style: BorderStyle.solid)),
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            Urls.assetBaseUrl + feedData[index].previewImage,
                            loadingBuilder: (BuildContext context,
                                Widget widget, ImageChunkEvent event) {
                              return event != null
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            primaryColor),
                                      ),
                                    )
                                  : widget;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.calendar_today,
                                size: 15,
                                color: primarySwatch[500],
                              ),
                            ),
                            TextSpan(
                                text: "\t" + feedData[index].createdAt,
                                style: TextStyle(color: primarySwatch[500]))
                          ]),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Vishvasya Vrutantam",
                                style: TextStyle(color: primarySwatch[500])),
                            TextSpan(
                                text: "\t Dt. \t" + feedData[index].createdAt,
                                style: TextStyle(color: primarySwatch[500]))
                          ]),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: orientation == Orientation.portrait ? 50 : 30,
                          width: orientation == Orientation.portrait
                              ? size.width * 0.8
                              : size.width * 0.5,
                          child: FlatButton(
                            child: Text(
                              "Read Now",
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: primaryColor,
                                  style: BorderStyle.solid,
                                )),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Preview(
                                            pdfFile: feedData[index].pdfFile,
                                          )));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: feedData.length,
                controller: ScrollController(keepScrollOffset: true),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              ));
  }
}

class FeedData {
  final String id,
      title,
      description,
      previewImage,
      pdfFile,
      createdAt,
      updatedAt;
  FeedData(
      {this.id,
      this.title,
      this.description,
      this.pdfFile,
      this.previewImage,
      this.createdAt,
      this.updatedAt});
}
