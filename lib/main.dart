import 'package:astro/bloc/file_upload_bloc.dart';
import 'package:astro/bloc/file_upload_event.dart';
import 'package:astro/bloc/file_upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => FileUploadBloc(),
        child: FileUploadPage(),
      ),
    );
  }
}

class FileUploadPage extends StatelessWidget {
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
            } else if (state is FileUploadSuccess) {
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
            } else if (state is FileUploadSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChartWidget(predictions: state.predictions),
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

class LineChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> predictions;

  const LineChartWidget({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    final spots = predictions.map((prediction) {
      final date = DateTime.parse(prediction['ds']);
      final yhat = prediction['yhat'].toDouble();
      return FlSpot(date.millisecondsSinceEpoch.toDouble(), yhat);
    }).toList();

    final minX = spots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    final maxX = spots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: const LineTouchTooltipData(),
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {},
          handleBuiltInTouches: true,
        ),
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text(DateFormat('MM-dd').format(date));
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
