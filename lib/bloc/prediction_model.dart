class Prediction {
  final String ds;
  final double trend;
  final double yhatLower;
  final double yhatUpper;
  final double trendLower;
  final double trendUpper;
  final double additiveTerms;
  final double additiveTermsLower;
  final double additiveTermsUpper;
  final double weekly;
  final double weeklyLower;
  final double weeklyUpper;
  final double yearly;
  final double yearlyLower;
  final double yearlyUpper;
  final double multiplicativeTerms;
  final double multiplicativeTermsLower;
  final double multiplicativeTermsUpper;
  final double yhat;

  Prediction({
    required this.ds,
    required this.trend,
    required this.yhatLower,
    required this.yhatUpper,
    required this.trendLower,
    required this.trendUpper,
    required this.additiveTerms,
    required this.additiveTermsLower,
    required this.additiveTermsUpper,
    required this.weekly,
    required this.weeklyLower,
    required this.weeklyUpper,
    required this.yearly,
    required this.yearlyLower,
    required this.yearlyUpper,
    required this.multiplicativeTerms,
    required this.multiplicativeTermsLower,
    required this.multiplicativeTermsUpper,
    required this.yhat,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      ds: json['ds'],
      trend: json['trend'],
      yhatLower: json['yhat_lower'],
      yhatUpper: json['yhat_upper'],
      trendLower: json['trend_lower'],
      trendUpper: json['trend_upper'],
      additiveTerms: json['additive_terms'],
      additiveTermsLower: json['additive_terms_lower'],
      additiveTermsUpper: json['additive_terms_upper'],
      weekly: json['weekly'],
      weeklyLower: json['weekly_lower'],
      weeklyUpper: json['weekly_upper'],
      yearly: json['yearly'],
      yearlyLower: json['yearly_lower'],
      yearlyUpper: json['yearly_upper'],
      multiplicativeTerms: json['multiplicative_terms'],
      multiplicativeTermsLower: json['multiplicative_terms_lower'],
      multiplicativeTermsUpper: json['multiplicative_terms_upper'],
      yhat: json['yhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ds': ds,
      'trend': trend,
      'yhat_lower': yhatLower,
      'yhat_upper': yhatUpper,
      'trend_lower': trendLower,
      'trend_upper': trendUpper,
      'additive_terms': additiveTerms,
      'additive_terms_lower': additiveTermsLower,
      'additive_terms_upper': additiveTermsUpper,
      'weekly': weekly,
      'weekly_lower': weeklyLower,
      'weekly_upper': weeklyUpper,
      'yearly': yearly,
      'yearly_lower': yearlyLower,
      'yearly_upper': yearlyUpper,
      'multiplicative_terms': multiplicativeTerms,
      'multiplicative_terms_lower': multiplicativeTermsLower,
      'multiplicative_terms_upper': multiplicativeTermsUpper,
      'yhat': yhat,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'ds': ds,
      'trend': trend,
      'yhat_lower': yhatLower,
      'yhat_upper': yhatUpper,
      'trend_lower': trendLower,
      'trend_upper': trendUpper,
      'additive_terms': additiveTerms,
      'additive_terms_lower': additiveTermsLower,
      'additive_terms_upper': additiveTermsUpper,
      'weekly': weekly,
      'weekly_lower': weeklyLower,
      'weekly_upper': weeklyUpper,
      'yearly': yearly,
      'yearly_lower': yearlyLower,
      'yearly_upper': yearlyUpper,
      'multiplicative_terms': multiplicativeTerms,
      'multiplicative_terms_lower': multiplicativeTermsLower,
      'multiplicative_terms_upper': multiplicativeTermsUpper,
      'yhat': yhat,
    };
  }
}
