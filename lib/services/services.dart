import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import '../services/urls.dart';
import '../services/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Services{
  static Future<Data> signIn(body) async{
    String url = Urls.baseUrl + Urls.logIn;
    dio.Response response;
    response = await dio.Dio().post(url, data: body);
    if(response.statusCode == 200){
      Data data = Data();
      final jsonResponse = jsonDecode(response.data);
      data.message = jsonResponse["message"];
      data.response = jsonResponse["status"];
      data.data = jsonResponse["data"];
      return data;
    }
    return null;
  }
  static Future<Data> getFeed() async{
    String url = Urls.baseUrl + Urls.ePaper;
    dio.Response response;
    response = await dio.Dio().get(url);
    if(response.statusCode == 200){
      Data data = Data();
      final jsonResponse = jsonDecode(response.data);
      data.message = jsonResponse["message"];
      data.response = jsonResponse["status"];
      data.data = jsonResponse["data"];
      return data;
    }
    return null;
  }
}