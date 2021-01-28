import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_paper/constant/colors.dart';
import 'package:e_paper/constant/global.dart';
import 'package:e_paper/main.dart';
import 'package:e_paper/ui/home.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/services.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  bool showProgress = false;
  Animation animation;
  AnimationController controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username, password;
  FToast fToast;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  setLoading(bool status) {
    setState(() {
      showProgress = status;
    });
  }

  @override
  void initState() {
    checkConnection(scaffoldKey: _scaffoldKey);
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    fToast = FToast();
    fToast.init(context);
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
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Form(
            key: _formKey,
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
                    hintText: "Username",
                    iconData: Icons.person,
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress),
                input(
                    context: context,
                    hintText: "Password",
                    iconData: Icons.lock,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _login),
                Container(
                  margin: EdgeInsets.only(
                      top: orientation == Orientation.portrait ? 25 : 15),
                  width: size.width * 0.8,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
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
                              child: InkWell(
                            child: Text(
                              "www.vishvasyavrutantam.com",
                              style: TextStyle(
                                  color: primaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {},
                          ))
                        ]),
                  ),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "New to Visvasya Vrutantam",
                        style: GoogleFonts.actor(
                          color: Colors.black54,
                        )),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: InkWell(
                        child: Text("\tSignUp",
                            style: GoogleFonts.actor(
                                color: primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      if (username != null && password != null) {
        setLoading(true);
        FormData body =
            FormData.fromMap({'username': username, 'password': password});
        await Services.signIn(body).then((data) async {
          if (data.response) {
            await sharedPreferences.setString(Params.userName, username);
            await sharedPreferences.setString(Params.password, password);
            await sharedPreferences
                .setString(Params.userData, jsonEncode(data.data))
                .then((value) async {
              await setUserdata();
            });
            if (userdata != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
              setLoading(false);
            }
          } else {
            setLoading(false);
            Fluttertoast.showToast(
                msg: data.message, gravity: ToastGravity.BOTTOM);
          }
        });
      } else {
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Please Enter Username and Password",
            gravity: ToastGravity.BOTTOM);
      }
    }
  }
}

Widget input(
    {@required BuildContext context,
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    bool obscureText = false,
    String hintText,
    IconData iconData,
    TextInputType keyboardType,
    TextInputAction textInputAction}) {
  Size size = MediaQuery.of(context).size;
  return Container(
    width: size.width * 0.8,
    height: 60,
    margin: EdgeInsets.only(top: 5),
    child: TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
        ),
        contentPadding:
            EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        prefixIcon: Icon(
          iconData,
          color: primaryColor,
        ),
      ),
      cursorColor: primaryColor,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
    ),
  );
}
