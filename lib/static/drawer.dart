import 'package:e_paper/constant/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ui/e_paper_plans.dart';
import '../ui/home.dart';

Widget drawer(
    {@required BuildContext context,
    @required GlobalKey<ScaffoldState> scaffoldKey}) {
  return Drawer(
    child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("${userdata.firstName} ${userdata.lastName}"),
          accountEmail: Text("${userdata.email}"),
          currentAccountPicture: Image(
            image: AssetImage("assets/images/icon.png"),
            fit: BoxFit.fill,
          ),
          decoration: BoxDecoration(color: Colors.indigoAccent[100]),
        ),
        _createDrawerItem(
            text: "Home",
            icon: Icons.home,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            style: GoogleFonts.actor(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        _createDrawerItem(
            text: "E-Paper Plans",
            icon: Icons.alternate_email,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EPaperPlans()));
            },
            style: GoogleFonts.actor(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        Divider(),
        _createDrawerItem(
            text: "Exit",
            icon: Icons.exit_to_app,
            onTap: () {},
            style: GoogleFonts.actor(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap, TextStyle style}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: style,
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}
