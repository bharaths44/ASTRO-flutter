class SalesData {
  List<ActualSales>? actualSales;
  List<Forecast>? forecast;

  SalesData({this.actualSales, this.forecast});

  SalesData.fromJson(Map<String, dynamic> json) {
    if (json['actual_sales'] != null) {
      actualSales = <ActualSales>[];
      json['actual_sales'].forEach((v) {
        actualSales!.add(ActualSales.fromJson(v));
      });
    }
    if (json['forecast'] != null) {
      forecast = <Forecast>[];
      json['forecast'].forEach((v) {
        forecast!.add(Forecast.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (actualSales != null) {
      data['actual_sales'] = actualSales!.map((v) => v.toJson()).toList();
    }
    if (forecast != null) {
      data['forecast'] = forecast!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActualSales {
  String? ds;
  double? salesTrend;

  ActualSales({this.ds, this.salesTrend});

  ActualSales.fromJson(Map<String, dynamic> json) {
    ds = json['ds'];
    salesTrend = json['sales_trend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ds'] = ds;
    data['sales_trend'] = salesTrend;
    return data;
  }
}

class Forecast {
  String? ds;
  double? yhatTrend;
  double? yhatUpperTrend;
  double? yhatLowerTrend;

  Forecast({this.ds, this.yhatTrend, this.yhatUpperTrend, this.yhatLowerTrend});

  Forecast.fromJson(Map<String, dynamic> json) {
    ds = json['ds'];
    yhatTrend = json['yhat_trend'];
    yhatUpperTrend = json['yhat_upper_trend'];
    yhatLowerTrend = json['yhat_lower_trend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ds'] = ds;
    data['yhat_trend'] = yhatTrend;
    data['yhat_upper_trend'] = yhatUpperTrend;
    data['yhat_lower_trend'] = yhatLowerTrend;
    return data;
  }
}
