import 'dart:ui';

import 'package:dio/dio.dart';
import '../constant/colors.dart';
import '../static/input.dart';
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
  bool isLoading = false;
  String firstName = "",
      lastName = "",
      mobileNo = "",
      email = "",
      refCode = "",
      password = "",
      confirmPassword = "", username = "";
  Color showPassword = Colors.black54;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle inputTextStyle = TextStyle(fontSize: 16);
  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
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
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Username"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "First name"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Last name"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Email"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    mobileNo = value;
                  });
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Mobile No"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    refCode = value;
                  });
                },
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Refer Code (Optional)"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Password"),
            input(
                context: context,
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
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
                  child: isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
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
                  onPressed: isLoading ? null : _signUp),
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

  void _signUp() async {
    if (username.isNotEmpty && firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        mobileNo.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        email.isNotEmpty) {
      if (password == confirmPassword) {
        if (password.length >= 6) {
          if (RegExp(
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
              .hasMatch(email)) {
            if (RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(mobileNo)) {
              setLoading(true);
              FormData formData = FormData.fromMap({
                "username": username,
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "mobile": mobileNo,
                "refer_code": refCode,
                "password": password,
              });
              await Services.signUp(formData).then((value) {
                if (value.response) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignIn(
                                username: email,
                              )),
                      (route) => false);
                  showToastMessage(value.message);
                  setLoading(false);
                } else {
                  setLoading(false);
                  showToastMessage(value.message);
                }
              });
              setLoading(false);
            } else {
              showToastMessage("Invalid mobile number");
            }
          } else {
            showToastMessage("Invalid email");
          }
        } else {
          showToastMessage("Password must be of six character");
        }
      } else {
        showToastMessage("Password doesn't match");
      }
    } else {
      showToastMessage("Fields can't be empty");
    }
  }
}
