import 'signin_signup/signup.dart';
import 'main/e_paper_plans.dart';
import 'main/preview.dart';
import 'main/home.dart';
import 'signin_signup/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  runApp(MyApp());
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E Paper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      routes: {
        "/home" : (BuildContext context) => Home(),
        "/preview" : (BuildContext context) => Preview(),
        "/e_paper_plans" : (BuildContext context) => EPaperPlans(),
        "sign_in" : (BuildContext context) => SignIn(),
        "sign_up" : (BuildContext context) => SignUp(),
      },
    );
  }
}
