import 'dart:async';
import 'package:astro/core/utils/http_upload.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
part 'file_upload_event.dart';
part 'file_upload_state.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  var logger = Logger();

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
          'num_periods': 24,
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
    try {
      final filePath = await uploadFile(event.filePath, event.params);
      emit(FileUploadSvgSuccess(filePath));
    } catch (e) {
      logger.e('Error uploading file: $e');
      emit(FileUploadFailure(e.toString()));
    }
  }
}
