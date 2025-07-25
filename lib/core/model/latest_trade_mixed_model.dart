class LatestTradeMixedModel {
  String? symbol;
  String? timestampUtc;
  double? price;
  int? size;
  int? tradeId;
  String? exchange;
  String? tape;
  String? update;
  List<String>? conditions;
  int? takerSide;

  LatestTradeMixedModel({
    this.symbol,
    this.timestampUtc,
    this.price,
    this.size,
    this.tradeId,
    this.exchange,
    this.tape,
    this.update,
    this.conditions,
    this.takerSide,
  });

  LatestTradeMixedModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    timestampUtc = json['timestampUtc'];
    price = double.parse(json['price'].toString());
    size = json['size'];
    tradeId = json['tradeId'];
    exchange = json['exchange'];
    tape = json['tape'];
    update = json['update'];
    conditions = json['conditions'].cast<String>();
    takerSide = json['takerSide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['timestampUtc'] = timestampUtc;
    data['price'] = price;
    data['size'] = size;
    data['tradeId'] = tradeId;
    data['exchange'] = exchange;
    data['tape'] = tape;
    data['update'] = update;
    data['conditions'] = conditions;
    data['takerSide'] = takerSide;
    return data;
  }
}
