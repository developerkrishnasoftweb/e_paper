import 'package:splashscreen/splashscreen.dart';
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
      home: Splash(),
    );
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
    Future.delayed(Duration(milliseconds: 2000), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
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
          Image.asset("assets/images/logo.gif",
            height: 150,
            width: 150,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

