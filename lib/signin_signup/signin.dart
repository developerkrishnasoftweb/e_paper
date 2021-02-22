import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_paper/services/urls.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/colors.dart';
import '../constant/global.dart';
import '../main.dart';
import '../services/services.dart';
import '../static/input.dart';
import '../ui/home.dart';
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
              top: MediaQuery.of(context).padding.top, bottom: 20),
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
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress),
              input(
                  context: context,
                  text: "Password",
                  obscureText: true,
                  controller: password,
                  style: TextStyle(fontSize: 16),
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: InputDecoration(
                      border: border(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _login),
              Container(
                margin: EdgeInsets.only(
                    top: orientation == Orientation.portrait ? 25 : 15),
                width: size.width - 60,
                height: 60,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                      : Text(
                          "LOGIN TO YOUR ACCOUNT",
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: !showProgress ? _login : null,
                  color: primaryColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                width: size.width * 0.95,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "NOTE : This app is only for reading purpose. To purchase subscription please visit \t",
                      style: TextStyle(color: primaryColor),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                          child: Text(
                            Urls.assetBaseUrl,
                            style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                          onTap: () async {
                            if(await canLaunch(Urls.assetBaseUrl)) {
                              launch(Urls.assetBaseUrl);
                            } else {
                              showToastMessage("Unable to open URL");
                            }
                          },
                        ))
                      ]),
                ),
              ),
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
