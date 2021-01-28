import 'dart:convert';

import 'package:e_paper/constant/global.dart';
import 'package:e_paper/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signin_signup/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  bool status = await getCredential();
  if (status) await setUserdata();
  runApp(MaterialApp(
      title: 'E Paper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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

//splash screen
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height - MediaQuery.of(context).padding.top,
      width: size.width,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo.gif",
            height: 150,
            width: 150,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
