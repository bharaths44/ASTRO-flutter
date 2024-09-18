import 'package:astro/data_upload/bloc/file_upload_bloc.dart';
import 'package:astro/data_upload/data_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => FileUploadBloc(),
        child: const FileUploadPage(),
      ),
    );
  }
}