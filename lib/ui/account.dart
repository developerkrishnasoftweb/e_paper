import 'dart:io';

import 'package:e_paper/constant/global.dart';
import 'package:e_paper/services/services.dart';
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
  bool isLoading = false, isRegistered = false;
  EdgeInsetsGeometry padding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 15);
  File image;

  setRegistered(bool status) {
    setState(() {
      isRegistered = status;
    });
  }

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
        actions: [
          IconButton(
              icon: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ))
                  : Icon(Icons.check_circle_outline),
              onPressed: isLoading ? null : _update)
        ],
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
                onChanged: _isEmailAvailable,
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Mobile",
                controller: mobile,
                onChanged: _isMobileAvailable,
                decoration: InputDecoration(border: border())),
          ],
        ),
      ),
    );
  }

  _update() async {
    if (firstName.text.isNotEmpty &&
        lastName.text.isNotEmpty &&
        email.text.isNotEmpty &&
        mobile.text.isNotEmpty &&
        isRegistered) {}
  }

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
                    ? userdata.profileImage.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                                Urls.assetBaseUrl + userdata.profileImage),
                            fit: BoxFit.cover)
                        : null
                    : null),
        child: image == null && userdata.profileImage == null
            ? Icon(Icons.add_a_photo_outlined)
            : null,
      ),
    );
  }

  _isMobileAvailable(value) async {
    if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value)) {
      setLoading(true);
      await Services.isAvailable(mobile: value).then((value) {
        if (!value.response) {
          showToastMessage(value.message);
          setLoading(false);
        } else {
          showToastMessage(value.message);
          setRegistered(true);
          setLoading(false);
        }
      });
    }
  }

  _isEmailAvailable(value) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      setLoading(true);
      await Services.isAvailable(email: value).then((value) {
        if (!value.response) {
          showToastMessage(value.message);
          setLoading(false);
        } else {
          showToastMessage(value.message);
          setRegistered(true);
          setLoading(false);
        }
      });
    }
  }
}
