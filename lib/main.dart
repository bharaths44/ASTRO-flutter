import 'package:astro/bloc/file_upload_bloc.dart';
import 'package:astro/chart_widget.dart';
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

class FileUploadPage extends StatelessWidget {
  const FileUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Upload')),
      body: Center(
        child: BlocConsumer<FileUploadBloc, FileUploadState>(
          listener: (context, state) {
            if (state is FileUploadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is FileUploadSvgSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File uploaded successfully')),
              );
            }
          },
          builder: (context, state) {
            if (state is FileUploadInitial) {
              return ElevatedButton(
                onPressed: () {
                  context.read<FileUploadBloc>().add(PickFileEvent());
                },
                child: const Text('Pick and Upload File'),
              );
            } else if (state is FileUploadLoading) {
              return const CircularProgressIndicator();
            } else if (state is FileUploadSvgSuccess) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300, // Define a fixed height for the SVG viewer
                    child: SvgViewerWidget(svgFilePath: state.svgFilePath),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FileUploadBloc>().add(PickFileEvent());
                    },
                    child: const Text('Upload Another File'),
                  ),
                ],
              );
            } else {
              return ElevatedButton(
                onPressed: () {
                  context.read<FileUploadBloc>().add(PickFileEvent());
                },
                child: const Text('Pick and Upload File'),
              );
            }
          },
        ),
      ),
    );
  }
}
