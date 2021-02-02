import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;
Userdata userdata;

Future<void> checkConnection({GlobalKey<ScaffoldState> scaffoldKey}) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) ;
  } on SocketException catch (_) {
    scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("No internet connection !!!")));
  }
}

Future<bool> showToastMessage(String msg,
    {Toast toast,
    double fontSize,
    ToastGravity toastGravity,
    Color backgroundColor,
    Color textColor}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: toast,
      fontSize: fontSize,
      gravity: toastGravity,
      backgroundColor: backgroundColor,
      textColor: textColor);
}

void customToast(
    {String text,
    Icon icon,
    Color backgroundColor,
    Color color,
    ToastGravity gravity,
    double height,
    double width,
    EdgeInsets padding,
    Duration duration,
    List<BoxShadow> boxShadow,
    @required FToast fToast}) {
  Widget toast = Container(
    alignment: Alignment.center,
    height: height != null ? height : null,
    width: width != null ? width : null,
    padding: padding != null
        ? padding
        : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.0),
        color: backgroundColor != null ? backgroundColor : Colors.black54,
        boxShadow: boxShadow),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        WidgetSpan(
            child: icon != null ? icon : Container(),
            alignment: PlaceholderAlignment.middle),
        TextSpan(
          text: text != null ? "\t\t" + text : " ",
          style: TextStyle(color: color != null ? color : Colors.white),
        ),
      ]),
    ),
  );
  fToast.showToast(
    child: toast,
    gravity: gravity != null ? gravity : ToastGravity.BOTTOM,
    toastDuration: duration,
  );
}

Future<void> loader(
    {@required BuildContext context, String text, Color color}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(left: 10, right: 15),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    color != null ? color : Colors.blue),
                strokeWidth: 4,
              ),
            ),
            Container(
              child: Text(text != null ? text : "Please wait..."),
            )
          ],
        ),
        scrollable: false,
      );
    },
  );
}

class Params {
  static String id = "id",
      firstName = "first_name",
      lastName = "last_name",
      email = "email",
      mobile = "mobile",
      password = "password",
      profileImage = "profile_image",
      refCode = "referral_code",
      subscriptionId = "subscription_id",
      userData = "userdata",
      userName = "username";
}

class Userdata {
  final String id,
      firstName,
      lastName,
      email,
      mobile,
      password,
      profileImage,
      refCode,
      subscriptionPlanId;
  Userdata(
      {this.id,
      this.mobile,
      this.password,
      this.email,
      this.lastName,
      this.firstName,
      this.profileImage,
      this.refCode,
      this.subscriptionPlanId});
}
