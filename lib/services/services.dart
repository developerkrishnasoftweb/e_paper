import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../services/data.dart';
import '../services/urls.dart';

class Services {
  static Data internetError =
      Data(message: "No internet connection !!!", response: false, data: null);
  static Data dataError =
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
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return dataError;
      }
    } catch (e) {
      return dataError;
    }
  }

  static Future<Data> signUp(body) async {
    String url = Urls.baseUrl + Urls.signUp;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        return Data(
            data: [response.data["data"]],
            message: (response.data["message"].runtimeType == String
                ? response.data["message"]
                : response.data["message"]["email"] != null
                    ? response.data["message"]["email"]
                    : (response.data["message"]["mobile"] != null
                        ? response.data["message"]["mobile"]
                        : response.data["message"])),
            response: response.data["status"]);
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return dataError;
      }
    } catch (e) {
      return dataError;
    }
  }

  static Future<Data> update(body) async {
    String url = Urls.baseUrl + Urls.updateProfile;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      print(response);
      if (response.statusCode == 200) {
        return Data(
            data: [response.data["data"]],
            message: (response.data["message"].runtimeType == String
                ? response.data["message"]
                : response.data["message"]["email"] != null
                ? response.data["message"]["email"]
                : (response.data["message"]["mobile"] != null
                ? response.data["message"]["mobile"]
                : response.data["message"])),
            response: response.data["status"]);
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return dataError;
      }
    } catch (e) {
      return dataError;
    }
  }

  static Future<Data> isAvailable({String mobile, String email}) async {
    String url = Urls.baseUrl + Urls.isAvailable;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: mobile != null
              ? FormData.fromMap({"mobile": mobile})
              : FormData.fromMap({"email": email}));
      if (response.statusCode == 200) {
        return Data(
            message: response.data["message"],
            data: response.data["data"],
            response: response.data["status"]);
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return dataError;
      }
    } catch (e) {
      return dataError;
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
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return dataError;
      }
    } catch (e) {
      return dataError;
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
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return dataError;
      }
    } catch (e) {
      return dataError;
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
