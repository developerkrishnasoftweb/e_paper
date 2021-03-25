import 'package:fluttertoast/fluttertoast.dart';

import '../services/services.dart';
import 'package:flutter/material.dart';

import '../models/feed_model.dart';
import '../constant/colors.dart';
import '../constant/global.dart';
import '../services/urls.dart';
import 'widgets/drawer.dart';
import 'e_paper_plans.dart';
import 'preview.dart';
import 'signin_signup/signin.dart';

_HomeState homeState;

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    homeState = _HomeState();
    return homeState;
  }
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<FeedData> feedData = [];
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    getFeed();
  }

  getFeed() async {
    await Services.getFeed().then((value) {
      if (value.response) {
        if(value.data[0].length == 0) {
          setState(() {
            feedData = null;
          });
          return;
        }
        for (int i = 0; i < value.data[0].length; i++) {
          setState(() {
            feedData.add(FeedData.fromJson(value.data[0][i]));
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: value.message.toString(), gravity: ToastGravity.BOTTOM);
      }
    });
  }

  _logout() async {
    loader(context: context, text: "Logging out ...");
    String email = userdata.email;
    userdata = null;
    sharedPreferences.clear().then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SignIn(
                      username: email,
                    )),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: CustomDrawer(
              scaffoldKey: _scaffoldKey,
            ),
            appBar: AppBar(
              elevation: 0,
              title: Text(
                "Home",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
                        onTap: _logout),
                  ),
                )
              ],
              backgroundColor: primaryColor,
            ),
            body: feedData != null ? feedData.length > 0
                ? GridView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 1 : 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: size.width /
                            (orientation == Orientation.portrait ? 400 : 500)),
                    itemBuilder: (BuildContext context, int index) {
                      return buildCards(
                          context: context, feedData: feedData[index]);
                    },
                    itemCount: feedData.length,
                    controller: ScrollController(keepScrollOffset: true),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                  )
                : Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(primaryColor),),
                  ) : Center(
              child: Text(
                "News paper not found :(",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )),
        onWillPop: _exit);
  }

  Future<bool> _exit() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToastMessage("Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}

Widget buildCards(
    {@required BuildContext context, @required FeedData feedData}) {
  Size size = MediaQuery.of(context).size;
  Orientation orientation = MediaQuery.of(context).orientation;
  _readPaper() {
    if (userdata.subscriptionId != null &&
        userdata.subscriptionId != "" &&
        userdata.subscriptionId != "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Preview(pdfFilePath: feedData.pdfFile)));
    } else {
      showDialog(
          builder: (context) => AlertDialog(
            title: Text(
              "Vishvasya Vrutantam",
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Text("You have to become prime member to read newspaper"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.black),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EPaperPlans()));
                  },
                  child: Text("Become Prime Member")),
            ],
          ), context: context,
          barrierDismissible: true);
    }
  }

  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: primaryColor, width: 1.5, style: BorderStyle.solid)),
    padding: EdgeInsets.all(5.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            width: orientation == Orientation.portrait
                ? size.width * 0.8
                : size.width * 0.3,
            image: feedData.previewImage != null
                ? NetworkImage(Urls.assetBaseUrl + feedData.previewImage)
                : AssetImage("assets/images/icon.png"),
            fit: BoxFit.fill,
            loadingBuilder:
                (BuildContext context, Widget widget, ImageChunkEvent event) {
              return event != null
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor),
                      ),
                    )
                  : widget;
            },
          ),
        ),
        SizedBox(
          height: 2,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            WidgetSpan(
                child: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: primarySwatch[500],
                ),
                alignment: PlaceholderAlignment.middle),
            TextSpan(
                text: "\t" + feedData.publishedAt.split(" ").first,
                style: TextStyle(
                    color: primarySwatch[500],
                    fontSize: 17,
                    fontWeight: FontWeight.bold))
          ]),
        ),
        SizedBox(
          height: 2,
        ),
        Text("Vishvasya Vrutantah",
            style: TextStyle(
                color: primarySwatch[500],
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        SizedBox(
          height: 5,
        ),
        Container(
          height: orientation == Orientation.portrait ? 50 : 40,
          width: orientation == Orientation.portrait
              ? size.width * 0.8
              : size.width * 0.3 > 100
                  ? size.width * 0.3
                  : 100,
          child: FlatButton(
            child: Text(
              "Read Now",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: primaryColor,
                  style: BorderStyle.solid,
                )),
            onPressed: _readPaper,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}
