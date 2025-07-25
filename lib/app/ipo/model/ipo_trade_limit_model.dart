class IpoTradeLimitModel {
  TradeLimitCalculationDetails? tradeLimitCalculationDetails;
  double? tradeLimit;
  double? realLimit;
  String? token;

  IpoTradeLimitModel({
    this.tradeLimitCalculationDetails,
    this.tradeLimit,
    this.realLimit,
    this.token,
  });

  factory IpoTradeLimitModel.fromJson(Map<String, dynamic> json) {
    return IpoTradeLimitModel(
      tradeLimitCalculationDetails: json['tradeLimitCalculationDetails'] != null
          ? TradeLimitCalculationDetails.fromJson(
              json['tradeLimitCalculationDetails'],
            )
          : null,
      tradeLimit: json['tradeLimit'],
      realLimit: double.parse(json['realLimit'].toString()),
      token: json['token'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.tradeLimitCalculationDetails != null) {
      data['tradeLimitCalculationDetails'] = this.tradeLimitCalculationDetails!.toJson();
    }
    data['tradeLimit'] = this.tradeLimit;
    data['realLimit'] = this.realLimit;
    data['token'] = this.token;
    return data;
  }
}

class TradeLimitCalculationDetails {
  final double cBBALANCE;

  TradeLimitCalculationDetails({
    this.cBBALANCE = 0,
  });

  factory TradeLimitCalculationDetails.fromJson(Map<String, dynamic> json) {
    return TradeLimitCalculationDetails(
      cBBALANCE: json['CBBALANCE'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CBBALANCE'] = this.cBBALANCE;
    return data;
  }
}
