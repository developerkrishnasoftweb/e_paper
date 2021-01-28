import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../services/data.dart';
import '../services/urls.dart';

class Services {
  static Data noInternetConnection =
      Data(message: "No internet connection !!!", response: false, data: null);
  static Data somethingWentWrong =
      Data(message: "Something went wrong", response: false, data: null);

  static Future<Data> signIn(body) async {
    String url = Urls.baseUrl + Urls.signIn;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200)
        return Data(
            data: [response.data["data"]],
            message: response.data["message"],
            response: response.data["status"]);
      return null;
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.DEFAULT &&
          e.error.runtimeType == SocketException) {
        return noInternetConnection;
      } else {
        return somethingWentWrong;
      }
    } catch (e) {
      print(e);
      return somethingWentWrong;
    }
  }

  static Future<Data> signUp(body) async {
    String url = Urls.baseUrl + Urls.signUp;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on SocketException catch (_) {
      return noInternetConnection;
    } catch (e) {
      return somethingWentWrong;
    }
  }

  static Future<Data> getFeed() async {
    String url = Urls.baseUrl + Urls.ePaper;
    try {
      dio.Response response = await dio.Dio().get(url);
      if (response.statusCode == 200) {
        return Data(
            response: response.data["status"],
            message: response.data["message"],
            data: [response.data["data"]]);
      }
      return null;
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.DEFAULT &&
          e.error.runtimeType == SocketException) {
        return noInternetConnection;
      } else {
        return somethingWentWrong;
      }
    } catch (e) {
      print(e);
      return somethingWentWrong;
    }
  }

  static Future<Data> getSubscription() async {
    String url = Urls.baseUrl + Urls.getSubscription;
    try {
      dio.Response response = await dio.Dio().get(url);
      if (response.statusCode == 200) {
        return Data(
            response: response.data["status"],
            message: response.data["message"],
            data: [response.data["data"]]);
      }
      return null;
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.DEFAULT &&
          e.error.runtimeType == SocketException) {
        return noInternetConnection;
      } else {
        return somethingWentWrong;
      }
    } catch (e) {
      print(e);
      return somethingWentWrong;
    }
  }

  static Future<String> loadPDF({@required String pdfFile}) async {
    var response = await http.get(Urls.assetBaseUrl + pdfFile);
    var dir = await getTemporaryDirectory();
    File file = new File(dir.path + "/data.pdf");
    var data = await file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }
}
