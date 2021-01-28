import 'dart:io';

import 'package:e_paper/constant/global.dart';
import 'package:e_paper/services/urls.dart';
import 'package:e_paper/static/input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  TextEditingController firstName, lastName, email, mobile;
  EdgeInsetsGeometry padding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 15);
  bool isLoading = false;
  File image;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
    setControllerData();
  }

  setControllerData() {
    firstName = TextEditingController(text: userdata.firstName);
    lastName = TextEditingController(text: userdata.lastName);
    email = TextEditingController(text: userdata.email);
    mobile = TextEditingController(text: userdata.mobile);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Account",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            profileImage(),
            input(
                context: context,
                width: size.width * 0.9,
                text: "First name",
                controller: firstName,
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Last name",
                controller: lastName,
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Email",
                controller: email,
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Mobile",
                controller: mobile,
                decoration: InputDecoration(border: border())),
            SizedBox(
              height: 20,
            ),
            Container(
              width: size.width,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                    : Text(
                        "Modify",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                onPressed: !isLoading ? _update : null,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _update() async {}

  Future getImage() async {
    File result = await FilePicker.getFile(type: FileType.image);
    if (result != null)
      setState(() {
        image = result;
      });
  }

  Widget profileImage() {
    return InkWell(
      onTap: getImage,
      borderRadius: BorderRadius.circular(150),
      child: Container(
        height: 150,
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: Colors.grey[300]),
            image: image != null
                ? DecorationImage(image: FileImage(image))
                : userdata.profileImage != null
                    ? DecorationImage(
                        image: NetworkImage(
                            Urls.assetBaseUrl + userdata.profileImage),
                        fit: BoxFit.cover)
                    : null),
        child: image == null && userdata.profileImage == null
            ? Icon(Icons.add_a_photo_outlined)
            : null,
      ),
    );
  }
}
