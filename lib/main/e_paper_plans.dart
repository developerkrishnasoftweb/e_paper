import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:ui';
import 'package:e_paper/static/loader.dart';
import '../signin_signup/signin.dart';
import 'dart:math';

class EPaperPlans extends StatefulWidget {
  @override
  _EPaperPlansState createState() => _EPaperPlansState();
}

class _EPaperPlansState extends State<EPaperPlans> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List plans;

  @override
  Widget build(BuildContext context) {
    void checkConnection() async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
      } on SocketException catch (_) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No internet connection !!!")));
      }
    }
    checkConnection();
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    setState(() {
      plans = [
        {"name" : "abcd"}
      ];
    });
    // Services.getFeed().then((value) {
    //   setState(() {
    //     plans = value.data;
    //   });
    // });
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          title: Text("DASHBOARD",
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
                  child: Text("LOG OUT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onTap: () async {
                    Loader(context: context, text: "Logging out ...");
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.clear().then((value) {
                      if(value){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
                      }
                    });
                  },
                ),
              ),
            )
          ],
          backgroundColor: Colors.indigo,
        ),
        preferredSize: Size.fromHeight(60),
      ),
      body: Container(
        width: size.width,
        height: size.height - (60 + MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: plans != null
                    ? GridView.builder(
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: size.width / 460
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.black12, width: 1.5, style: BorderStyle.solid)
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: size.height * 0.1,
                            width: size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.02),
                              border: Border(bottom: BorderSide(color: Colors.black12, width: 1.5)),
                            ),
                            child: Text("Trial Plan (One Time)",
                              style: GoogleFonts.varelaRound(
                                color: Colors.black45,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              ),
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
                                ]
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Container(
                                        height: 5,
                                        width: 5,
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black45
                                        ),
                                      )
                                    ),
                                    TextSpan(
                                      text: "2 Days plan",
                                      style: GoogleFonts.stylish(
                                        color: Colors.black45,
                                        fontSize: 20.0,
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black45
                                          ),
                                        )
                                    ),
                                    TextSpan(
                                      text: "For Single User",
                                      style: GoogleFonts.stylish(
                                        color: Colors.black45,
                                        fontSize: 20.0,
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black45
                                          ),
                                        )
                                    ),
                                    TextSpan(
                                      text: "All device support",
                                      style: GoogleFonts.stylish(
                                        color: Colors.black45,
                                        fontSize: 20.0,
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black45
                                          ),
                                        )
                                    ),
                                    TextSpan(
                                      text: "Support AgentSupport Agent",
                                      style: GoogleFonts.stylish(
                                        color: Colors.black45,
                                        fontSize: 20.0,
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: Color.fromRGBO(0, 123, 255, 1))
                                ),
                                onPressed: (){},
                                child: Text("Subscribe Now",
                                  style: GoogleFonts.ubuntu(
                                      color: Color.fromRGBO(0, 123, 255, 1),
                                    fontSize: 18
                                  ),
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
                width: size.width,
                height: size.height - (60 + MediaQuery.of(context).padding.top),
                alignment: Alignment.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
