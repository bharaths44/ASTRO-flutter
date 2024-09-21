import 'dart:convert';

import 'package:astro/data_upload/bloc/file_upload_bloc.dart';
import 'package:astro/data_upload/model/sales_model.dart';
import 'package:astro/data_upload/widgets/chart_widget.dart';
import 'package:astro/data_upload/widgets/svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              _showSnackBar(context, state.error);
            } else if (state is FileUploadSvgSuccess) {
              _showSnackBar(context, 'File uploaded successfully');
            } else if (state is FetchDataSuccess) {
              _showSnackBar(context, 'Data fetched successfully');
              print('Fetched Data: ${state.data}');
            }
          },
          builder: (context, state) {
            if (state is FileUploadInitial) {
              return _buildInitialButtons(context);
            } else if (state is FileUploadLoading) {
              return const CircularProgressIndicator();
            } else if (state is FileUploadSvgSuccess) {
              return _buildSvgSuccess(context, state.svgFilePath);
            } else if (state is FetchDataSuccess) {
              return _buildFetchDataSuccess(context, state.data);
            } else {
              return _buildInitialButtons(context);
            }
          },
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildInitialButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPickAndUploadButton(context),
        const SizedBox(height: 20),
        _buildUploadAndGetJsonButton(context),
      ],
    );
  }

  Widget _buildPickAndUploadButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<FileUploadBloc>().add(const PickFileEvent(true));
      },
      child: const Text('Pick and Upload File'),
    );
  }

  Widget _buildUploadAndGetJsonButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<FileUploadBloc>().add(const PickFileEvent(false));
      },
      child: const Text('Upload File and Get JSON'),
    );
  }

  Widget _buildSvgSuccess(BuildContext context, String svgFilePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: SvgViewerWidget(svgFilePath: svgFilePath),
        ),
        const SizedBox(height: 20),
        _buildPickAndUploadButton(context),
        const SizedBox(height: 20),
        _buildUploadAndGetJsonButton(context),
      ],
    );
  }

  Widget _buildFetchDataSuccess(BuildContext context, String data) {
    // Parse the JSON data into a SalesData object
    final SalesData salesData = parseSalesData(data);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SalesChart(salesData: salesData), // Use the SalesChart widget
        const SizedBox(height: 20),
        _buildPickAndUploadButton(context),
        const SizedBox(height: 20),
        _buildUploadAndGetJsonButton(context),
      ],
    );
  }

  SalesData parseSalesData(String data) {
    // Parse the JSON string into a SalesData object
    final Map<String, dynamic> jsonData = jsonDecode(data);
    return SalesData.fromJson(jsonData);
  }
}
