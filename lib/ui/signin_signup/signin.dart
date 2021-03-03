import 'dart:convert';

import 'package:Vishvasya_Vrutantah/ui/signin_signup/forgot_password.dart';
import 'package:Vishvasya_Vrutantah/ui/widgets/button.dart';

import '../../ui/widgets/input.dart';

import '../../constant/colors.dart';
import '../../constant/global.dart';
import '../../services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../home.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  final String username;

  SignIn({this.username});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  bool showProgress = false;
  Animation animation;
  TextEditingController username, password;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  setLoading(bool status) {
    setState(() {
      showProgress = status;
    });
  }

  @override
  void initState() {
    super.initState();
    username = TextEditingController(text: widget.username);
    password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 20,
              left: 20,
              right: 20),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.gif",
                height: orientation == Orientation.portrait ? 150 : 100,
                width: orientation == Orientation.portrait ? 150 : 100,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 20,
              ),
              input(
                  context: context,
                  text: "Username",
                  controller: username,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      border: border(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress),
              input(
                  context: context,
                  text: "Password",
                  obscureText: true,
                  controller: password,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      border: border(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _login),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword())),
                    child: Text("Forgot Password?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              button(
                  onPressed: !showProgress ? _login : null,
                  text: showProgress ? null : "LOGIN TO YOUR ACCOUNT",
                  child: showProgress
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                          height: 25,
                          width: 25,
                        )
                      : null),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "New to Visvasya Vrutantah",
                      style: TextStyle(
                        color: Colors.black54,
                      )),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      child: Text("\tSignUp",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  _login() async {
    FocusScope.of(context).unfocus();
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      setLoading(true);
      FormData body = FormData.fromMap(
          {'username': username.text, 'password': password.text});
      await Services.signIn(body).then((data) async {
        if (data.response) {
          await sharedPreferences
              .setString(Params.userData, jsonEncode(data.data))
              .then((value) async {
            await setUserdata();
          });
          if (userdata != null) {
            showToastMessage(data.message);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
            setLoading(false);
          }
        } else {
          setLoading(false);
          showToastMessage(data.message);
        }
      });
    } else {
      showToastMessage("Please enter username and password");
    }
  }
}
