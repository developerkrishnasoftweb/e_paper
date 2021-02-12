import 'package:e_paper/ui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/colors.dart';
import '../constant/global.dart';
import '../services/urls.dart';
import '../ui/account.dart';
import '../ui/e_paper_plans.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  CustomDrawer({@required this.scaffoldKey});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool accountVisibility = false;
  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "${userdata.firstName} ${userdata.lastName}",
                style: TextStyle(color: primaryColor),
              ),
              accountEmail: Text(
                "${userdata.email}",
                style: TextStyle(color: primaryColor),
              ),
              currentAccountPicture: userdata != null
                  ? userdata.profileImage != null &&
                          userdata.profileImage.isNotEmpty
                      ? Image(
                          image: NetworkImage(
                              Urls.assetBaseUrl + userdata.profileImage),
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget widget,
                              ImageChunkEvent event) {
                            return event != null
                                ? Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : widget;
                          },
                        )
                      : GestureDetector(
                          child: Icon(Icons.add_a_photo_outlined),
                          onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ManageAccount()))
                              .then((value) => homeState.setState(() {})),
                        )
                  : null,
              decoration: BoxDecoration(color: Colors.white),
              onDetailsPressed: () {
                setState(() {
                  accountVisibility = !accountVisibility;
                });
              },
              arrowColor: primaryColor,
            ),
            AnimatedContainer(
                height: accountVisibility ? 55 : 0,
                duration: Duration(milliseconds: 200),
                child: accountVisibility
                    ? _createDrawerItem(
                        text: "Account",
                        icon: Icons.account_circle,
                        onTap: () {
                          widget.scaffoldKey.currentState.openEndDrawer();
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ManageAccount()))
                              .then((value) => homeState.setState(() {}));
                        })
                    : SizedBox()),
            _createDrawerItem(
                text: "Home",
                icon: Icons.home,
                onTap: () {
                  widget.scaffoldKey.currentState.openEndDrawer();
                }),
            _createDrawerItem(
                text: "E-Paper Plans",
                icon: Icons.alternate_email,
                onTap: () {
                  widget.scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EPaperPlans()));
                }),
            Divider(
              color: primaryColor,
            ),
            _createDrawerItem(
                text: "Exit",
                icon: Icons.exit_to_app,
                onTap: () => SystemNavigator.pop()),
          ],
        ),
      ),
    );
  }
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  SizedBox gap = SizedBox(
    width: 10,
  );
  Color color = Colors.black54;
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        gap,
        Text(
          text,
          style: TextStyle(
              color: color, fontSize: 18.0, fontWeight: FontWeight.bold),
        )
      ],
    ),
    onTap: onTap,
  );
}
