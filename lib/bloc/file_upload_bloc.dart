import 'dart:async';
import 'package:astro/bloc/file_upload_event.dart';
import 'package:astro/bloc/file_upload_state.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  var logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  FileUploadBloc() : super(FileUploadInitial()) {
    on<PickFileEvent>(_onPickFileEvent);
    on<UploadFileEvent>(_onUploadFileEvent);
  }

  Future<void> _onPickFileEvent(
      PickFileEvent event, Emitter<FileUploadState> emit) async {
    logger.i('PickFileEvent started');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String filePath = result.files.single.path!;
        logger.i('File picked: $filePath');
        Map<String, dynamic> params = {
          'store_num': 1,
          'item_num': 1,
          'period_type': 'M',
          'num_periods': 3,
        };
        add(UploadFileEvent(filePath, params));
      } else {
        logger.i('File picking cancelled');
      }
    } catch (e) {
      logger.e('Error picking file: $e');
      emit(FileUploadFailure(e.toString()));
    }
  }

  Future<void> _onUploadFileEvent(
      UploadFileEvent event, Emitter<FileUploadState> emit) async {
    logger.i('UploadFileEvent started with file: ${event.filePath}');
    emit(FileUploadLoading());

    // if (cachedResponse != null) {
    //   logger.i('Loading from cache');
    //   logger.i('Type of cached response: ${cachedResponse.runtimeType}');
    //   try {
    //     var jsonResponse = json.decode(cachedResponse);
    //     if (jsonResponse is List) {
    //       List<Map<String, dynamic>> predictions =
    //           List<Map<String, dynamic>>.from(jsonResponse);
    //       emit(FileUploadSuccess(predictions));
    //     } else {
    //       throw Exception('Cached response is not a List');
    //     }
    //   } catch (e) {
    //     logger.e('Error decoding cached response: $e');
    //     emit(FileUploadFailure('Error decoding cached response: $e'));
    //   }
    // }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://astro-ml-server.wonderfulwave-d209090d.eastus.azurecontainerapps.io/predict'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('file', event.filePath));
    event.params.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    logger.i('Sending request with fields: ${request.fields}');
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      logger.i('Response body: $responseBody');

      try {
        // First decode to get the actual JSON string
        var jsonString = json.decode(responseBody);
        logger.i('Type of jsonString: ${jsonString.runtimeType}');

        // Check if the jsonString is a String and decode it again
        if (jsonString is String) {
          var jsonResponse = json.decode(jsonString);
          logger.i('Type of jsonResponse: ${jsonResponse.runtimeType}');

          if (jsonResponse is List) {
            List<Map<String, dynamic>> predictions =
                List<Map<String, dynamic>>.from(jsonResponse);
            logger.i('Decoded response: $predictions');
            // Emit success state with predictions
            emit(FileUploadSuccess(predictions));
          } else {
            throw Exception('Response is not a List');
          }
        } else {
          throw Exception('First level response is not a String');
        }
      } catch (e) {
        logger.e('Error parsing response: $e');
        emit(FileUploadFailure('Error parsing response: $e'));
      }
    } else {
      logger
          .e('Failed to upload file with status code: ${response.statusCode}');
      emit(FileUploadFailure('Failed to upload file'));
    }
  }
}
