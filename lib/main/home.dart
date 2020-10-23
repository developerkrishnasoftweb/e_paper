import 'dart:ui';
import 'package:e_paper/static/loader.dart';
import '../services/services.dart';
import '../signin_signup/signin.dart';
import '../main/preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List feedData;
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
    Services.getFeed().then((value) {
      setState(() {
        feedData = value.data;
      });
    });
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
                child: feedData != null
                ? GridView.builder(
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: size.width / (orientation == Orientation.portrait ? 400 : 500)
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.indigoAccent, width: 1.5, style: BorderStyle.solid)
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            height: orientation == Orientation.portrait ? 200 : 150,
                            width: orientation == Orientation.portrait ? size.width * 0.9 : size.width * 0.5,
                            image: NetworkImage("http://newspaper.nirvanacreators.com/upload/" + feedData[index]["image"]),
                            fit: BoxFit.fill,
                          ),
                          Container(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.calendar_today, size: 15, color: Colors.black54,),),
                                    TextSpan(
                                        text: "\t" + feedData[index]["date"],
                                        style: TextStyle(
                                            color: Colors.black54
                                        )
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Vishvasya Vrutantam",
                                        style: TextStyle(
                                            color: Colors.black54
                                        )
                                    ),
                                    TextSpan(
                                        text: "\t Dt. \t" + feedData[index]["date"],
                                        style: TextStyle(
                                            color: Colors.black54
                                        )
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            height: orientation == Orientation.portrait ? 50 : 30,
                            width: orientation == Orientation.portrait ? size.width * 0.9 : size.width * 0.5,
                            child: FlatButton(
                              child: Text("Read Now",
                                style: TextStyle(
                                  color: Colors.indigoAccent,
                                ),
                              ),
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.indigoAccent, style: BorderStyle.solid,)
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Preview()));
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: feedData.length,
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
