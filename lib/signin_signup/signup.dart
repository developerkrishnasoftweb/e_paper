import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:e_paper/services/services.dart';
import '../static/customtoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/animation.dart';

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
  FToast fToast;

  @override
  void initState() {
    super.initState();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Image(
                image: AssetImage("assets/images/icon.png"),
                height: orientation == Orientation.portrait ? 150 : 100,
                width: orientation == Orientation.portrait ? 150 : 100,
                fit: BoxFit.fill,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: 10),
                child: Text(
                  "Welcome",
                  style: GoogleFonts.andada(
                      color: Colors.black38,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Username",
                      hintStyle: GoogleFonts.asap(
                        fontSize: 17,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.18,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      child: DropdownButton(
                        isExpanded: true,
                        value: "+91",
                        items: <DropdownMenuItem<dynamic>>[
                          DropdownMenuItem(
                            child: Text("+91"),
                            value: "+91",
                          ),
                        ],
                        onChanged: (value) {},
                        underline: SizedBox(
                          height: 0,
                          width: 0,
                        ),
                        style: GoogleFonts.asap(
                          fontSize: 17,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        iconEnabledColor: Colors.black54,
                      ),
                    ),
                    Container(
                      width: size.width * 0.58,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Mobile No",
                            hintStyle: GoogleFonts.asap(
                              fontSize: 17,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0)),
                        onChanged: (value) {
                          setState(() {
                            mobileNo = value;
                          });
                        },
                        keyboardType: TextInputType.phone,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Email",
                      hintStyle: GoogleFonts.asap(
                        fontSize: 17,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Refer Code (Optional)",
                      hintStyle: GoogleFonts.asap(
                        fontSize: 17,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                  onChanged: (value) {
                    setState(() {
                      refCode = value;
                    });
                  },
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5)),
                    hintText: "Password",
                    hintStyle: GoogleFonts.asap(
                      fontSize: 17,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: showPassword,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword
                              ? showPassword = Colors.blue
                              : showPassword = Colors.black54;
                          _showPassword = !_showPassword;
                        });
                      },
                      splashRadius: 20,
                    ),
                  ),
                  obscureText: _showPassword,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Confirm Password",
                      hintStyle: GoogleFonts.asap(
                        fontSize: 17,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                  obscureText: true,
                ),
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.12, vertical: 10),
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
                        style: GoogleFonts.actor(
                          color: Colors.black54,
                        ))
                  ]),
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                padding: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.1),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: FlatButton(
                  color: Colors.black87,
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
                          style: GoogleFonts.lato(
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
                          if(username != "" && username != null) {
                            print(mobileNo);
                            RegExp regExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                            if(regExp.hasMatch(mobileNo)){
                              if(mobileNo != "" && mobileNo != null){
                                RegExp regExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                if(regExp.hasMatch(email)){
                                  if(email != "" && email != null){
                                    if(password != "" && password != null){
                                      if(confirmPassword != "" && confirmPassword != null){
                                        if(password == confirmPassword){
                                          register();
                                        } else {
                                          setState(() {
                                            isPressed = !isPressed;
                                            _isButtonDisabled = !_isButtonDisabled;
                                          });
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Password Doesn't Match."),));
                                        }
                                      } else {
                                        setState(() {
                                          isPressed = !isPressed;
                                          _isButtonDisabled = !_isButtonDisabled;
                                        });
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Password Doesn't Match."),));
                                      }
                                    } else {
                                      setState(() {
                                        isPressed = !isPressed;
                                        _isButtonDisabled = !_isButtonDisabled;
                                      });
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Enter Password."),));
                                    }
                                  } else {
                                    setState(() {
                                      isPressed = !isPressed;
                                      _isButtonDisabled = !_isButtonDisabled;
                                    });
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Enter Email Id."),));
                                  }
                                } else {
                                  setState(() {
                                    isPressed = !isPressed;
                                    _isButtonDisabled = !_isButtonDisabled;
                                  });
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Enter Valid Email Id."),));
                                }
                              } else {
                                setState(() {
                                  isPressed = !isPressed;
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Enter Phone Number."),));
                              }
                            } else {
                              setState(() {
                                isPressed = !isPressed;
                                _isButtonDisabled = !_isButtonDisabled;
                              });
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Enter Valid Phone Number."),));
                            }
                          } else {
                            setState(() {
                              isPressed = !isPressed;
                              _isButtonDisabled = !_isButtonDisabled;
                            });
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Enter Username."),));
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
                        style: GoogleFonts.actor(
                          color: Colors.black54,
                        )),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          child: Text("\tSignIn",
                            style: GoogleFonts.actor(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            )),
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                          },
                        ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    FormData formData = FormData.fromMap({
      "username" : username,
      "email" : email,
      "contact" : mobileNo,
      "refer_code" : refCode,
      "con_password" : confirmPassword,
      "password" : password,
    });
    await Services.signUp(formData).then((value) {
      setState(() {
        isPressed = !isPressed;
        _isButtonDisabled = !_isButtonDisabled;
      });
      if(value.response == "1" || value.response == 1){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
        CustomToast.showToast(fToast: fToast,
          text: value.message,
          color: Colors.white,
          backgroundColor: Colors.black,
          gravity: ToastGravity.CENTER,
          height: 50,
          duration: Duration(seconds: 2),
          width: MediaQuery.of(context).size.width * 0.7
        );
      } else {
        CustomToast.showToast(fToast: fToast,
          text: value.message,
          color: Colors.white,
          backgroundColor: Colors.black,
          gravity: ToastGravity.CENTER,
          height: 50,
          duration: Duration(seconds: 2),
          width: MediaQuery.of(context).size.width * 0.7
        );
      }
    });
  }
}
