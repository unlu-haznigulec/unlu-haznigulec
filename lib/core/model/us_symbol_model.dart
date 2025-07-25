class USSymbolModel {
  String? symbol;
  Asset? asset;
  Quote? quote;
  Trade? trade;
  CurrentDailyBar? currentDailyBar;
  PreviousDailyBar? previousDailyBar;
  Trade? extendedMarketTrade;

  USSymbolModel({
    this.symbol,
    this.asset,
    this.quote,
    this.trade,
    this.currentDailyBar,
    this.previousDailyBar,
    this.extendedMarketTrade,
  });

  USSymbolModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    asset = json['asset'] != null ? Asset.fromJson(json['asset']) : null;
    quote = json['quote'] != null ? Quote.fromJson(json['quote']) : null;
    trade = json['trade'] != null ? Trade.fromJson(json['trade']) : null;
    currentDailyBar = json['currentDailyBar'] != null ? CurrentDailyBar.fromJson(json['currentDailyBar']) : null;
    previousDailyBar = json['previousDailyBar'] != null ? PreviousDailyBar.fromJson(json['previousDailyBar']) : null;
    extendedMarketTrade = json['extendedMarketTrade'] != null ? Trade.fromJson(json['extendedMarketTrade']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    if (asset != null) {
      data['asset'] = asset!.toJson();
    }
    if (quote != null) {
      data['quote'] = quote!.toJson();
    }
    if (trade != null) {
      data['trade'] = trade!.toJson();
    }
    if (currentDailyBar != null) {
      data['currentDailyBar'] = currentDailyBar!.toJson();
    }
    if (previousDailyBar != null) {
      data['previousDailyBar'] = previousDailyBar!.toJson();
    }
    if (extendedMarketTrade != null) {
      data['extendedMarketTrade'] = extendedMarketTrade!.toJson();
    }
    return data;
  }

  USSymbolModel copyWith({
    String? symbol,
    Asset? asset,
    Trade? trade,
    Quote? quote,
    CurrentDailyBar? currentDailyBar,
    PreviousDailyBar? previousDailyBar,
    Trade? extendedMarketTrade,
  }) {
    return USSymbolModel(
      symbol: symbol ?? this.symbol,
      asset: asset ?? this.asset,
      trade: trade ?? this.trade,
      quote: quote ?? this.quote,
      currentDailyBar: currentDailyBar ?? this.currentDailyBar,
      previousDailyBar: previousDailyBar ?? this.previousDailyBar,
      extendedMarketTrade: extendedMarketTrade ?? this.extendedMarketTrade,
    );
  }
}

class Asset {
  String? assetId;
  int? assetClass;
  int? exchange;
  String? symbol;
  String? name;
  int? status;
  bool? isTradable;
  bool? marginable;
  bool? shortable;
  bool? easyToBorrow;
  bool? fractionable;
  String? exchangeName;

  Asset({
    this.assetId,
    this.assetClass,
    this.exchange,
    this.symbol,
    this.name,
    this.status,
    this.isTradable,
    this.marginable,
    this.shortable,
    this.easyToBorrow,
    this.fractionable,
    this.exchangeName,
  });

  Asset.fromJson(Map<String, dynamic> json) {
    assetId = json['assetId'];
    assetClass = json['class'];
    exchange = json['exchange'];
    symbol = json['symbol'];
    name = json['name'];
    status = json['status'];
    isTradable = json['isTradable'];
    marginable = json['marginable'];
    shortable = json['shortable'];
    easyToBorrow = json['easyToBorrow'];
    fractionable = json['fractionable'];
    exchangeName = json['exchangeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assetId'] = assetId;
    data['class'] = assetClass;
    data['exchange'] = exchange;
    data['symbol'] = symbol;
    data['name'] = name;
    data['status'] = status;
    data['isTradable'] = isTradable;
    data['marginable'] = marginable;
    data['shortable'] = shortable;
    data['easyToBorrow'] = easyToBorrow;
    data['fractionable'] = fractionable;
    data['exchangeName'] = exchangeName;

    return data;
  }
}

class Quote {
  String? symbol;
  String? timestampUtc;
  String? bidExchange;
  String? askExchange;
  double? bidPrice;
  double? askPrice;
  int? bidSize;
  int? askSize;
  String? tape;
  List<String>? conditions;
  int? decimalCount;

  Quote({
    this.symbol,
    this.timestampUtc,
    this.bidExchange,
    this.askExchange,
    this.bidPrice,
    this.askPrice,
    this.bidSize,
    this.askSize,
    this.tape,
    this.conditions,
    this.decimalCount = 2,
  });

  Quote.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    timestampUtc = json['timestampUtc'];
    bidExchange = json['bidExchange'];
    askExchange = json['askExchange'];
    bidPrice = double.parse(json['bidPrice'].toString());
    askPrice = double.parse(json['askPrice'].toString());
    bidSize = json['bidSize'];
    askSize = json['askSize'];
    tape = json['tape'];
    conditions = json['conditions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['timestampUtc'] = timestampUtc;
    data['bidExchange'] = bidExchange;
    data['askExchange'] = askExchange;
    data['bidPrice'] = bidPrice;
    data['askPrice'] = askPrice;
    data['bidSize'] = bidSize;
    data['askSize'] = askSize;
    data['tape'] = tape;
    data['conditions'] = conditions;
    return data;
  }
}

class Trade {
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

  Trade({
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

  Trade.fromJson(Map<String, dynamic> json) {
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

class CurrentDailyBar {
  String? symbol;
  String? timeUtc;
  double? open;
  double? high;
  double? low;
  double? close;
  int? volume;
  double? vwap;
  int? tradeCount;

  CurrentDailyBar({
    this.symbol,
    this.timeUtc,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.vwap,
    this.tradeCount,
  });

  CurrentDailyBar.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    timeUtc = json['timeUtc'];
    open = double.parse(json['open'].toString());
    high = double.parse(json['high'].toString());
    low = double.parse(json['low'].toString());
    close = double.parse(json['close'].toString());
    volume = json['volume'];
    vwap = double.parse(json['vwap'].toString());
    tradeCount = json['tradeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['timeUtc'] = timeUtc;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['volume'] = volume;
    data['vwap'] = vwap;
    data['tradeCount'] = tradeCount;
    return data;
  }
}

class PreviousDailyBar {
  String? symbol;
  String? timeUtc;
  double? open;
  double? high;
  double? low;
  double? close;
  int? volume;
  double? vwap;
  int? tradeCount;

  PreviousDailyBar({
    this.symbol,
    this.timeUtc,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.vwap,
    this.tradeCount,
  });

  PreviousDailyBar.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'] ?? '';
    timeUtc = json['timeUtc'];
    open = double.parse(json['open'].toString());
    high = double.parse(json['high'].toString());
    low = double.parse(json['low'].toString());
    close = double.parse(json['close'].toString());
    volume = json['volume'];
    vwap = double.parse(json['vwap'].toString());
    tradeCount = json['tradeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['timeUtc'] = timeUtc;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['volume'] = volume;
    data['vwap'] = vwap;
    data['tradeCount'] = tradeCount;
    return data;
  }
}

class LoserGainerModel {
  String symbol = '';
  double? price;
  double? change;
  double? percentChange;

  LoserGainerModel({
    required this.symbol,
    this.price,
    this.change,
    this.percentChange,
  });

  LoserGainerModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    price = double.parse(json['price'].toString());
    change = double.parse(json['change'].toString());
    percentChange = double.parse(json['percentChange'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['price'] = price;
    data['change'] = change;
    data['percentChange'] = percentChange;
    return data;
  }
}

class USStockModel {
  String? symbol;
  int? volume;
  int? tradeCount;

  USStockModel({
    this.symbol,
    this.volume,
    this.tradeCount,
  });

  USStockModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'] ?? '';
    volume = json['volume'];
    tradeCount = json['tradeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['volume'] = volume;
    data['tradeCount'] = tradeCount;
    return data;
  }
}
