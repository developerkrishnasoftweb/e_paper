import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';
import '../constant/global.dart';
import '../static/drawer.dart';

class EPaperPlans extends StatefulWidget {
  @override
  _EPaperPlansState createState() => _EPaperPlansState();
}

class _EPaperPlansState extends State<EPaperPlans> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List plans;

  @override
  Widget build(BuildContext context) {
    checkConnection(scaffoldKey: _scaffoldKey);
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    setState(() {
      plans = [
        {"name": "abcd"}
      ];
    });
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Subscription Plans",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
      body: plans != null
          ? GridView.builder(
              padding: EdgeInsets.all(5),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      300 / (orientation == Orientation.portrait ? 360 : 320)),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                          style: BorderStyle.solid)),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.1,
                        width: size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.02),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black12, width: 1.5)),
                        ),
                        child: Text(
                          "Trial Plan (One Time)",
                          style: GoogleFonts.varelaRound(
                              color: Colors.black45,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: RichText(
                          text: TextSpan(
                              text: "\u20B9\t",
                              style: GoogleFonts.varelaRound(
                                color: Colors.black45,
                                fontSize: 50.0,
                              ),
                              children: [
                                TextSpan(
                                  text: (index * 100).toString(),
                                  style: GoogleFonts.varelaRound(
                                    color: Colors.black45,
                                    fontSize: 45.0,
                                  ),
                                )
                              ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45),
                                )),
                            TextSpan(
                              text: "2 Days plan",
                              style: GoogleFonts.stylish(
                                color: Colors.black45,
                                fontSize: 20.0,
                              ),
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45),
                                )),
                            TextSpan(
                              text: "For Single User",
                              style: GoogleFonts.stylish(
                                color: Colors.black45,
                                fontSize: 20.0,
                              ),
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45),
                                )),
                            TextSpan(
                              text: "All device support",
                              style: GoogleFonts.stylish(
                                color: Colors.black45,
                                fontSize: 20.0,
                              ),
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45),
                                )),
                            TextSpan(
                              text: "Support AgentSupport Agent",
                              style: GoogleFonts.stylish(
                                color: Colors.black45,
                                fontSize: 20.0,
                              ),
                            )
                          ]),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  color: Color.fromRGBO(0, 123, 255, 1))),
                          onPressed: () {},
                          child: Text(
                            "Subscribe Now",
                            style: GoogleFonts.ubuntu(
                                color: Color.fromRGBO(0, 123, 255, 1),
                                fontSize: 18),
                          ),
                          splashColor: Color.fromRGBO(0, 123, 255, 0.4),
                          // hoverColor: Color.fromRGBO(0, 123, 255, 0.4 ),
                          // focusColor: Color.fromRGBO(0, 123, 255, 0.4),
                          highlightColor: Color.fromRGBO(0, 123, 255, 0.4),
                        ),
                        height: 60,
                        width: size.width * 0.8,
                      )
                    ],
                  ),
                );
              },
              itemCount: 5,
              controller: ScrollController(keepScrollOffset: true),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            )
          : CircularProgressIndicator(),
    );
  }
}
