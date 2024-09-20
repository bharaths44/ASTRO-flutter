import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> uploadFile(String filePath, Map<String, dynamic> params) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://localhost:8000/predict/plot'),
  );

  request.files.add(await http.MultipartFile.fromPath('file', filePath));
  params.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  var response = await request.send();
  if (response.statusCode == 200) {
    var responseBody = await response.stream.toBytes();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/response.svg';
    final file = File(filePath);
    await file.writeAsBytes(responseBody);
    return filePath;
  } else {
    throw Exception(
        'Failed to upload file with status code: ${response.statusCode}');
  }
}
