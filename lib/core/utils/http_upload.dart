import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<http.StreamedResponse> _sendMultipartRequest(
    String url, String filePath, Map<String, dynamic> params) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('file', filePath));
  params.forEach((key, value) {
    request.fields[key] = value.toString();
  });
  return await request.send();
}

Future<String> uploadFile(String filePath, Map<String, dynamic> params) async {
  var response = await _sendMultipartRequest(
      'http://localhost:8000/predict/plot', filePath, params);

  if (response.statusCode == 200) {
    var responseBody = await response.stream.toBytes();
    final directory = await getApplicationDocumentsDirectory();
    final responseFilePath = '${directory.path}/response.svg';
    final file = File(responseFilePath);
    await file.writeAsBytes(responseBody);
    return responseFilePath;
  } else {
    throw Exception(
        'Failed to upload file with status code: ${response.statusCode}');
  }
}

Future<String> fetchData(String filePath, Map<String, dynamic> params) async {
  var response = await _sendMultipartRequest(
      'http://localhost:8000/predict/data', filePath, params);

  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception(
        'Failed to fetch data with status code: ${response.statusCode}');
  }
}