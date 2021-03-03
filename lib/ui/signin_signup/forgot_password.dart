import 'package:Vishvasya_Vrutantah/constant/colors.dart';
import 'package:Vishvasya_Vrutantah/constant/global.dart';
import 'package:Vishvasya_Vrutantah/services/services.dart';
import 'package:Vishvasya_Vrutantah/ui/widgets/button.dart';
import 'package:Vishvasya_Vrutantah/ui/widgets/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String username = "", msg = "";
  bool isLoading = false;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void _forgotPassword() async {
    setLoading(true);
    await Services.forgotPassword(username).then((value) {
      if (value.response) {
        setLoading(false);
        showToastMessage(value.message);
      } else {
        setLoading(false);
        showToastMessage(value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                  "Forgot Password!",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(msg,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 10,
            ),
            input(
                context: context,
                style: TextStyle(fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15)),
                text: "Email"),
            button(
                onPressed: !isLoading ? _forgotPassword : null,
                text: isLoading ? null : "SUBMIT",
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
          ],
        ),
      ),
    );
  }
}
