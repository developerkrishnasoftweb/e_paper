import 'dart:io';

import 'package:flutter/material.dart';
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

class Params {
  static String id = "id",
      firstName = "first_name",
      lastName = "last_name",
      email = "email",
      mobile = "mobile",
      password = "password",
      profileImage = "profile_image",
      refCode = "referral_code",
      subscriptionPlanId = "subscription_plan_id",
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
