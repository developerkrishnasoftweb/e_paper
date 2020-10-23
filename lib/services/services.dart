import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import '../services/urls.dart';
import '../services/data.dart';

class Services{
  static Future<Data> signIn(body) async{
    String url = Urls.baseUrl + Urls.signIn;
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
  static Future<Data> signUp(body) async{
    String url = Urls.baseUrl + Urls.signUp;
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