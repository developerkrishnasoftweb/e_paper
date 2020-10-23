import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
class APIServices{
  static final url = "http://infolab.stanford.edu/pub/papers/google.pdf#toolbar=0&navpanes=0&scrollbar=0";
  static Future<String> loadPDF() async {
    var response = await http.get(url);
    var dir = await getTemporaryDirectory();
    File file = new File(dir.path + "/data.pdf");
    var data = await file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }
}