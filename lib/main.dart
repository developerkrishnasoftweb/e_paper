import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './constant/colors.dart';
import './constant/global.dart';
import 'ui/home.dart';
import 'ui/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  bool status = await getCredential();
  if (status) await setUserdata();
  runApp(MaterialApp(
      title: 'E Paper',
      theme: ThemeData(
          primarySwatch: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Poppins"),
      debugShowCheckedModeBanner: false,
      home: status ? Home() : Splash()));

  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

Future<void> setUserdata() async {
  List data =
      await jsonDecode(sharedPreferences.getString(Params.userData) ?? "[{}]");
  if (data != null) {
    userdata = Userdata(
        email: data[0][Params.email],
        firstName: data[0][Params.firstName],
        id: data[0][Params.id],
        lastName: data[0][Params.lastName],
        mobile: data[0][Params.mobile],
        password: data[0][Params.password],
        profileImage: data[0][Params.profileImage],
        refCode: data[0][Params.refCode],
        subscriptionPlanId: data[0][Params.subscriptionPlanId]);
  }
  return;
}

Future<bool> getCredential() async {
  if (sharedPreferences.getString("username") != null &&
      sharedPreferences.getString("password") != null &&
      sharedPreferences.getString(Params.userData) != null) {
    return true;
  } else {
    return false;
  }
}
