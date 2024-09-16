import 'package:equatable/equatable.dart';

abstract class FileUploadEvent extends Equatable {
  const FileUploadEvent();

  @override
  List<Object> get props => [];
}

class PickFileEvent extends FileUploadEvent {}

class UploadFileEvent extends FileUploadEvent {
  final String filePath;
  final Map<String, dynamic> params;

  const UploadFileEvent(this.filePath, this.params);

  @override
  List<Object> get props => [filePath, params];
}