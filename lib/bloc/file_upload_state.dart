
abstract class FileUploadState {}

class FileUploadInitial extends FileUploadState {}

class FileUploadLoading extends FileUploadState {}

class FileUploadFailure extends FileUploadState {
  final String error;

  FileUploadFailure(this.error);
}

class FileUploadSuccess extends FileUploadState {
  final List<Map<String, dynamic>> predictions;

   FileUploadSuccess(this.predictions);

  List<Object> get props => [predictions];
}