import 'package:dio/dio.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/animation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../static/customtoast.dart';
import '../services/services.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  bool isPlaying = false, showProgress = false;
  Animation animation;
  AnimationController controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username, password;
  FToast fToast;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getCredential().then((value) {
      if(value){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }
    });
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    fToast = FToast();
    fToast.init(context);
  }
  Future<bool> getCredential() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString("username") != null && pref.getString("password") != null){
      return true;
    } else {
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    void checkConnection() async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
      } on SocketException catch (_) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No internet connection !!!")));
        setState(() {
          showProgress = false;
        });
      }
    }
    checkConnection();
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
                Image(
                  image: AssetImage("assets/images/icon.png"),
                  height: orientation == Orientation.portrait ? 150 : 100,
                  width: orientation == Orientation.portrait ? 150 : 100,
                  fit: BoxFit.fill,
                ),
                Container(
                  width: size.width * 0.8,
                  height: 60,
                  margin: EdgeInsets.only(top: orientation == Orientation.portrait ? 20 : 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60), borderSide: BorderSide(color: Colors.black38,),),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60), borderSide: BorderSide(color: Colors.green,),),
                      hintText: "Username",
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                      prefixIcon: Icon(Icons.person, color: Colors.black38,),
                    ),
                    cursorColor: Colors.black,
                    onChanged: (value){
                      setState(() {
                        username = value;
                      });
                    },
                    validator: (value){
                      if(value.length <= 0)
                        return null;
                      return null;
                    },
                  ),
                ),
                Container(
                  width: size.width * 0.8,
                  height: 60,
                  margin: EdgeInsets.only(top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60), borderSide: BorderSide(color: Colors.black38,),),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60), borderSide: BorderSide(color: Colors.green,),),
                      hintText: "Password",
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                      prefixIcon: Icon(Icons.lock, color: Colors.black38,),
                    ),
                    cursorColor: Colors.black,
                    onChanged: (value){
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: orientation == Orientation.portrait ? 25 : 15),
                  width: size.width * 0.7,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: showProgress
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green          ),
                            ),
                            height: 25,
                            width: 25,
                          )
                        : Text("LOGIN TO YOUR ACCOUNT",
                        style: TextStyle(
                            color: Colors.white
                        ),
                    ),
                    onPressed: !showProgress ? () async{
                      if(_formKey.currentState.validate()){
                        if(username != null && password != null){
                          setState(() {
                            showProgress = !showProgress;
                          });
                          FormData body = FormData.fromMap({
                            'username' : username,
                            'password' : password
                          });
                          await Services.signIn(body).then((data) async {
                            if(data.response == 1){
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              await pref.setString("username", username);
                              await pref.setString("password", password);
                              getCredential().then((value) {
                                if(value){
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                                }
                              });
                            } else {
                              setState(() {
                                showProgress = false;
                              });
                              CustomToast.showToast(fToast: fToast,
                                text: data.message,
                                icon: Icon(Icons.sentiment_very_dissatisfied, color: Colors.white,),
                                color: Colors.white,
                                backgroundColor: Colors.black,
                                gravity: ToastGravity.CENTER,
                                height: 50,
                                duration: Duration(seconds: 2),
                              );
                            }
                          });
                        } else {
                          setState(() {
                            showProgress = false;
                          });
                          CustomToast.showToast(fToast: fToast,
                            text: "Please enter username and password",
                            icon: Icon(Icons.cancel, color: Colors.white,),
                            color: Colors.white,
                            backgroundColor: Colors.black,
                            gravity: ToastGravity.CENTER,
                            height: 50,
                            duration: Duration(seconds: 2),
                          );
                        }
                      }
                    } : null,
                    color: Colors.green,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  width: size.width * 0.95,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "NOTE : This app is only for reading purpose. To purchase subscription please visit \t",
                        style: TextStyle(
                            color: Colors.blue
                        ),
                        children: [
                          WidgetSpan(
                              child: InkWell(
                                child: Text("www.vishvasyavrutantam.com",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                                onTap: (){

                                },
                              )
                          )
                        ]
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: RichText(
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
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              )),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
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
      ),
    );
  }
}
