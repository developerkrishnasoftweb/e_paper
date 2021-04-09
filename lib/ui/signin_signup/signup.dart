import 'dart:ui';

import 'package:Vishvasya_Vrutantah/ui/widgets/button.dart';

import '../../ui/widgets/input.dart';

import '../../constant/colors.dart';
import '../../constant/global.dart';
import '../../services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      confirmPassword = "",
      username = "";
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
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                text: "Username"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
                text: "First name"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
                text: "Last name"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                text: "Email"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    mobileNo = value;
                  });
                },
                keyboardType: TextInputType.phone,
                text: "Mobile No"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    refCode = value;
                  });
                },
                text: "Refer Code (Optional)"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
                text: "Password"),
            input(
                style: inputTextStyle,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
                obscureText: true,
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
                      text: "\tPassword must be at least of 6 characters.",
                      style: TextStyle(
                        color: Colors.black54,
                      ))
                ]),
              ),
            ),
            button(
                onPressed: isLoading ? null : _signUp,
                text: isLoading ? null : "REGISTER",
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: isLoading
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
            Container(
              width: size.width,
              padding: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Have an account",
                      style: TextStyle(
                        color: Colors.black54,
                      )),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      child: Text("\tSignIn?",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.pop(context);
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
    FocusScope.of(context).unfocus();
    if (username.isNotEmpty &&
        firstName.isNotEmpty &&
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
