import 'dart:convert';
import 'services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant/colors.dart';
import 'constant/global.dart';
import 'models/config_model.dart';
import 'models/user_model.dart';
import 'signin_signup/signin.dart';
import 'ui/home.dart';
import 'ui/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  bool status = await getCredential();
  await Services.config().then((value) async {
    config = Config.fromJson(await jsonDecode(sharedPreferences.getString(Params.config)));
  });
  if (status) await setUserdata();
  if (status) await Services.getUserData();
  if (status) await Services.checkPlanValidity();
  runApp(MaterialApp(
      title: 'E Paper',
      theme: ThemeData(
          primarySwatch: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Poppins"),
      debugShowCheckedModeBanner: false,
      home: status ? Splash(widget: Home()) : Splash(widget: SignIn())));

  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

Future<void> setUserdata() async {
  List data =
      await jsonDecode(sharedPreferences.getString(Params.userData) ?? "[{}]");
  if (data != null) {
    userdata = Userdata.fromJSON(data[0]);
  }
  return;
}

Future<bool> getCredential() async {
  if (sharedPreferences.getString(Params.userData) != null) {
    return true;
  } else {
    return false;
  }
}
