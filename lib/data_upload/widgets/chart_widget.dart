import 'package:astro/data_upload/model/sales_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class SalesChart extends StatelessWidget {
  final SalesData salesData;

  const SalesChart({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: const DateTimeAxis(),
        series: <CartesianSeries>[
          LineSeries<ActualSales, DateTime>(
            dataSource: salesData.actualSales!,
            xValueMapper: (ActualSales sales, _) => DateTime.parse(sales.ds!),
            yValueMapper: (ActualSales sales, _) => sales.salesTrend,
            color: Colors.blue,
            name: 'Actual Sales',
          ),
          LineSeries<Forecast, DateTime>(
            dataSource: salesData.forecast!,
            xValueMapper: (Forecast forecast, _) =>
                DateTime.parse(forecast.ds!),
            yValueMapper: (Forecast forecast, _) => forecast.yhatTrend,
            color: Colors.orange,
            name: 'Forecast',
          ),
        ],
      ),
    );
  }
}
