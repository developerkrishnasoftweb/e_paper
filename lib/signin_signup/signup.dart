import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:e_paper/constant/colors.dart';
import 'package:e_paper/static/input.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/global.dart';
import '../services/services.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  bool isPressed = false, _isButtonDisabled = false;
  String username, mobileNo, email, refCode, password, confirmPassword;
  Color showPassword = Colors.black54;
  bool _showPassword = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkConnection(scaffoldKey: _scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {},
                splashRadius: 25,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            input(
                context: context,
                style: TextStyle(fontSize: 19),
                decoration: InputDecoration(border: border()),
                text: "First name"),
            input(
                context: context,
                style: TextStyle(fontSize: 19),
                decoration: InputDecoration(border: border()),
                text: "Last name"),
            input(
                context: context,
                style: TextStyle(fontSize: 19),
                decoration: InputDecoration(border: border()),
                text: "Mobile No"),
            input(
                context: context,
                style: TextStyle(fontSize: 19),
                decoration: InputDecoration(border: border()),
                text: "Refer Code (Optional)"),
            input(
                context: context,
                style: TextStyle(fontSize: 19),
                decoration: InputDecoration(border: border()),
                text: "Password"),
            input(
                context: context,
                style: TextStyle(fontSize: 19),
                decoration: InputDecoration(border: border()),
                text: "Confirm Password"),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.lightBlue[300],
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(
                      text: "\tPassword must be at least 6 characters.",
                      style: TextStyle(
                        color: Colors.black54,
                      ))
                ]),
              ),
            ),
            Container(
              height: 60,
              width: size.width - 60,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: FlatButton(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isPressed
                    ? SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                        height: 25,
                        width: 25,
                      )
                    : Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        setState(() {
                          isPressed = !isPressed;
                          _isButtonDisabled = !_isButtonDisabled;
                        });
                        if (username != "" && username != null) {
                          RegExp regExp =
                              new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                          if (regExp.hasMatch(mobileNo)) {
                            if (mobileNo != "" && mobileNo != null) {
                              RegExp regExp = new RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (regExp.hasMatch(email)) {
                                if (email != "" && email != null) {
                                  if (password != "" && password != null) {
                                    if (confirmPassword != "" &&
                                        confirmPassword != null) {
                                      if (password == confirmPassword) {
                                        register();
                                      } else {
                                        setState(() {
                                          isPressed = !isPressed;
                                          _isButtonDisabled =
                                              !_isButtonDisabled;
                                        });
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Password Doesn't Match."),
                                        ));
                                      }
                                    } else {
                                      setState(() {
                                        isPressed = !isPressed;
                                        _isButtonDisabled = !_isButtonDisabled;
                                      });
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Password Doesn't Match."),
                                      ));
                                    }
                                  } else {
                                    setState(() {
                                      isPressed = !isPressed;
                                      _isButtonDisabled = !_isButtonDisabled;
                                    });
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Please Enter Password."),
                                    ));
                                  }
                                } else {
                                  setState(() {
                                    isPressed = !isPressed;
                                    _isButtonDisabled = !_isButtonDisabled;
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Please Enter Email Id."),
                                  ));
                                }
                              } else {
                                setState(() {
                                  isPressed = !isPressed;
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Please Enter Valid Email Id."),
                                ));
                              }
                            } else {
                              setState(() {
                                isPressed = !isPressed;
                                _isButtonDisabled = !_isButtonDisabled;
                              });
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Please Enter Phone Number."),
                              ));
                            }
                          } else {
                            setState(() {
                              isPressed = !isPressed;
                              _isButtonDisabled = !_isButtonDisabled;
                            });
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Please Enter Valid Phone Number."),
                            ));
                          }
                        } else {
                          setState(() {
                            isPressed = !isPressed;
                            _isButtonDisabled = !_isButtonDisabled;
                          });
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Please Enter Username."),
                          ));
                        }
                      },
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Already Registered",
                      style: TextStyle(
                        color: Colors.black54,
                      )),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      child: Text("\tSignIn",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() async {
    FormData formData = FormData.fromMap({
      "username": username,
      "email": email,
      "contact": mobileNo,
      "refer_code": refCode,
      "con_password": confirmPassword,
      "password": password,
    });
    await Services.signUp(formData).then((value) {
      setState(() {
        isPressed = !isPressed;
        _isButtonDisabled = !_isButtonDisabled;
      });
      if (value.response == "1" || value.response == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false);
        showToastMessage(value.message);
      } else {
        showToastMessage(value.message);
      }
    });
  }
}
