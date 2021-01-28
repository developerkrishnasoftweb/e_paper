import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';
import '../constant/global.dart';
import '../services/urls.dart';
import '../ui/account.dart';
import '../ui/e_paper_plans.dart';
import '../ui/home.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  CustomDrawer({@required this.scaffoldKey});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool accountVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${userdata.firstName} ${userdata.lastName}"),
            accountEmail: Text("${userdata.email}"),
            currentAccountPicture: userdata != null
                ? userdata.profileImage != null &&
                        userdata.profileImage.isNotEmpty
                    ? Image(
                        image: NetworkImage(
                            Urls.assetBaseUrl + userdata.profileImage),
                        fit: BoxFit.fill,
                      )
                    : null
                : null,
            decoration: BoxDecoration(color: primarySwatch[600]),
            onDetailsPressed: () {
              setState(() {
                accountVisibility = !accountVisibility;
              });
            },
            arrowColor: Colors.white,
          ),
          AnimatedContainer(
              height: accountVisibility ? 55 : 0,
              duration: Duration(milliseconds: 200),
              child: accountVisibility
                  ? _createDrawerItem(
                      text: "Account",
                      icon: Icons.account_circle,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageAccount()));
                      })
                  : SizedBox()),
          _createDrawerItem(
              text: "Home",
              icon: Icons.home,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }),
          _createDrawerItem(
              text: "E-Paper Plans",
              icon: Icons.alternate_email,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EPaperPlans()));
              }),
          Divider(),
          _createDrawerItem(
              text: "Exit", icon: Icons.exit_to_app, onTap: () {}),
        ],
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
          style: GoogleFonts.actor(
              color: color, fontSize: 18.0, fontWeight: FontWeight.bold),
        )
      ],
    ),
    onTap: onTap,
  );
}
