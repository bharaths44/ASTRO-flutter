part of 'file_upload_bloc.dart';

sealed class FileUploadState extends Equatable {
  const FileUploadState();

  @override
  List<Object> get props => [];
}

class FileUploadInitial extends FileUploadState {}

class FileUploadLoading extends FileUploadState {}

class FileUploadSuccess extends FileUploadState {
  final List<Map<String, dynamic>> predictions;
  final List<Map<String, dynamic>> actualSales;

  const FileUploadSuccess(this.predictions, this.actualSales);

  @override
  List<Object> get props => [predictions, actualSales];
}

class FileUploadSvgSuccess extends FileUploadState {
  final String svgFilePath;

  const FileUploadSvgSuccess(this.svgFilePath);

  @override
  List<Object> get props => [svgFilePath];
}

class FileUploadFailure extends FileUploadState {
  final String error;

  const FileUploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
