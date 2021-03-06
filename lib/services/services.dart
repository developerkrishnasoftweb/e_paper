import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import '../constant/global.dart';
import '../main.dart';
import '../ui/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import '../services/data.dart';
import '../services/urls.dart';

class Services {
  static Data internetError =
      Data(message: "No internet connection", response: false, data: null);
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

  static Future<Data> forgotPassword(String email) async {
    String url = Urls.baseUrl + Urls.forgotPassword;
    try {
      dio.Response response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({'email': email}));
      print(response);
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

  static Future<Data> getUserData() async {
    String url = Urls.baseUrl + Urls.getUser;
    try {
      dio.Response response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"user_id": userdata.id}));
      if (response.statusCode == 200) {
        await sharedPreferences.setString(
            Params.userData, jsonEncode([response.data["data"]]));
        await setUserdata();
        return Data(
            data: [response.data["data"]],
            message: response.data["message"],
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

  static Future<Data> trialPlan({@required String planId}) async {
    String url = Urls.baseUrl + Urls.trialPlan;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"user_id": userdata.id, "plan_id": planId}));
      if (response.statusCode == 200) {
        await getUserData();
        return Data(
            data: [response.data["data"]],
            message: response.data["message"],
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
                        : response.data["message"]["username"] != null
                            ? response.data["message"]["username"]
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
      if (response.statusCode == 200) {
        return Data(
            data: [response.data["data"]],
            message: (response.data["message"].runtimeType == String
                ? response.data["message"]
                : response.data["message"]["email"] != null
                    ? response.data["message"]["email"]
                    : (response.data["message"]["mobile"] != null
                        ? response.data["message"]["mobile"]
                        : response.data["message"]["username"] != null
                            ? response.data["message"]["username"]
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

  static Future<Data> checkPlanValidity() async {
    String url = Urls.baseUrl + Urls.checkPlanValidity;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"subscription_id": userdata.subscriptionId}));
      if (response.statusCode == 200) {
        if (!response.data['status']) {
          if (response.data['data'] != null) {
            if (response.data["data"]['status'] == "n") await getUserData();
          }
        }
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

  static Future<Data> subscribe(body) async {
    String url = Urls.baseUrl + Urls.subscribe;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      print(response.data);
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

  static Future<Data> generateOrderId(body) async {
    String url = Urls.baseUrl + Urls.generateOrderId;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
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

  static Future<Data> logout(String userId) async {
    String url = Urls.baseUrl + Urls.logout;
    try {
      dio.Response response =
          await dio.Dio().post(url, data: dio.FormData.fromMap({"id": userId}));
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

  static Future<void> config() async {
    String url = Urls.baseUrl + Urls.config;
    try {
      dio.Response response = await dio.Dio().get(url);
      if (response.statusCode == 200) {
        await sharedPreferences.setString(
            Params.config, jsonEncode(response.data["data"]));
      }
      return null;
    } catch (e) {
      return null;
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
    var dir = await getTemporaryDirectory();
    var path = dir.path + pdfFile.split("/").last;
    if (await File(path).exists()) return path;
    dio.Response response = await dio.Dio().get(Urls.assetBaseUrl + pdfFile,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        onReceiveProgress: previewState.downloadProgress);
    File file = new File(path);
    await file.writeAsBytes(response.data, flush: true);
    return file.path;
  }
}
