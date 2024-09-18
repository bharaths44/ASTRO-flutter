import 'dart:async';
import 'dart:io';
import 'package:astro/bloc/file_upload_event.dart';
import 'package:astro/bloc/file_upload_state.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  var logger = Logger();

  FileUploadBloc() : super(FileUploadInitial()) {
    on<PickFileEvent>(_onPickFileEvent);
    on<UploadFileEvent>(_onUploadFileEvent);
    on<ResetFileUploadEvent>(_onResetFileUploadEvent);
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
          'num_periods': 6,
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
    emit(FileUploadLoading());
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/predict'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('file', event.filePath));
    event.params.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Log the fields to verify they are being added correctly
    logger.i('Request fields: ${request.fields}');

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.toBytes();
      logger.i('Response received');

      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/response.svg';
        final file = File(filePath);
        await file.writeAsBytes(responseBody);
        emit(FileUploadSvgSuccess(filePath));
      } catch (e) {
        logger.e('Error saving SVG file: $e');
        emit(FileUploadFailure('Error saving SVG file: $e'));
      }
    } else {
      logger
          .e('Failed to upload file with status code: ${response.statusCode}');
      emit(const FileUploadFailure('Failed to upload file'));
    }
  }

  void _onResetFileUploadEvent(
      ResetFileUploadEvent event, Emitter<FileUploadState> emit) {
    emit(FileUploadInitial());
  }
}
