import 'dart:convert';
import 'dart:io';

import 'package:Vishvasya_Vrutantah/models/subscription_info_model.dart';
import 'package:Vishvasya_Vrutantah/ui/e_paper_plans.dart';
import 'package:intl/intl.dart';

import 'widgets/input.dart';
import 'package:dio/dio.dart';
import '../constant/global.dart';
import '../main.dart';
import '../services/services.dart';
import '../services/urls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  TextEditingController firstName, lastName, email, mobile, username;
  bool isLoading = false, error = false, showPassword = true;
  String errorMessage = "";
  EdgeInsetsGeometry padding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 15);
  File image;
  SubscriptionInfo subscriptionInfo;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  setError(bool status) {
    setState(() {
      error = status;
    });
  }

  setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  void initState() {
    super.initState();
    setControllerData();
    getSubscription();
  }

  setControllerData() {
    firstName = TextEditingController(text: userdata.firstName);
    lastName = TextEditingController(text: userdata.lastName);
    email = TextEditingController(text: userdata.email);
    mobile = TextEditingController(text: userdata.mobile);
    username = TextEditingController(text: userdata.username);
  }

  getSubscription() async {
    await Services.checkPlanValidity().then((value) {
      if (value.response) {
        setState(() {
          subscriptionInfo = SubscriptionInfo.fromJson(value.data[0]);
        });
      }
    });
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
                text: "User name",
                controller: username,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15))),
            input(
                context: context,
                width: size.width * 0.9,
                text: "First name",
                controller: firstName,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15))),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Last name",
                controller: lastName,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15))),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Email",
                controller: email,
                onChanged: _isEmailAvailable,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15))),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Mobile",
                controller: mobile,
                onChanged: _isMobileAvailable,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15))),
            input(
                context: context,
                width: size.width * 0.9,
                text: "Password",
                controller: TextEditingController(text: userdata.password),
                onChanged: _isMobileAvailable,
                readOnly: true,
                obscureText: showPassword,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    suffixIconConstraints: BoxConstraints(),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                      splashRadius: 20,
                      icon: Icon(Icons.remove_red_eye,
                          color: showPassword ? Colors.grey : primaryColor),
                    ))),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Active Subscription Plan",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            subscriptionInfo != null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow(
                            "Subscription Plan", subscriptionInfo.planTitle),
                        buildRow(
                            "Starts From",
                            DateFormat.yMMMd().format(DateTime.parse(
                                subscriptionInfo.activatedAt
                                    .split(" ")
                                    .first))),
                        buildRow(
                            "Ends On",
                            DateFormat.yMMMd().format(DateTime.parse(
                                subscriptionInfo.expiredAt.split(" ").first))),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "No active plan found",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _update() async {
    FocusScope.of(context).unfocus();
    if (!error) {
      if (firstName.text.isNotEmpty &&
          lastName.text.isNotEmpty &&
          email.text.isNotEmpty &&
          mobile.text.isNotEmpty &&
          username.text.isNotEmpty) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text)) {
          if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(mobile.text)) {
            setLoading(true);
            FormData formData = FormData.fromMap({
              "id": userdata.id,
              "username": username.text,
              "first_name": firstName.text,
              "last_name": lastName.text,
              "email": email.text,
              "mobile": mobile.text,
              "profile_image": image != null
                  ? await MultipartFile.fromFile(image.path,
                      filename: image.path.split("/").last)
                  : null
            });
            Services.update(formData).then((value) async {
              if (value.response) {
                await sharedPreferences.setString(
                    Params.userData, jsonEncode(value.data));
                await setUserdata();
                showToastMessage(value.message);
                setLoading(false);
                Navigator.pop(context);
              } else {
                showToastMessage(value.message);
                setLoading(false);
              }
            });
          } else {
            showToastMessage("Invalid mobile number");
          }
        } else {
          showToastMessage("Invalid email");
        }
      } else {
        showToastMessage("Fields can't be empty");
      }
    } else {
      showToastMessage(errorMessage);
    }
  }

  Future getImage() async {
    File result = await FilePicker.getFile(type: FileType.image);
    if (result != null)
      setState(() {
        image = result;
      });
  }

  Widget buildRow(String title, String value) {
    return Row(children: [
      Expanded(
          child: Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14))),
      Expanded(
          child: Text(value,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14))),
    ]);
  }

  Widget profileImage() {
    return InkWell(
      onTap: getImage,
      borderRadius: BorderRadius.circular(150),
      child: Container(
        height: 100,
        width: 100,
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
    if (userdata.mobile != value) {
      if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value) &&
          userdata.mobile != value) {
        setLoading(true);
        await Services.isAvailable(mobile: value).then((value) {
          if (value.response) {
            setLoading(false);
            setError(false);
            setErrorMessage("");
          } else {
            setError(true);
            showToastMessage(value.message);
            setLoading(false);
            setErrorMessage(value.message.toString());
          }
        });
      }
    }
  }

  _isEmailAvailable(value) async {
    if (userdata.email != value) {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        setLoading(true);
        await Services.isAvailable(email: value).then((value) {
          if (value.response) {
            setLoading(false);
            setError(false);
            setErrorMessage("");
          } else {
            showToastMessage(value.message);
            setLoading(false);
            setError(true);
            setErrorMessage(value.message.toString());
          }
        });
      }
    }
  }
}
