abstract class BaseAlarm {
  final String id;
  final String symbol;
  final bool isActive;

  BaseAlarm({
    required this.id,
    required this.symbol,
    required this.isActive,
  });
}

class NewsAlarm extends BaseAlarm {
  final List<dynamic> sources;
  final String expireDate;
  String symbolType;
  String underlyingName;
  String description;

  NewsAlarm({
    required super.id,
    required super.symbol,
    required super.isActive,
    required this.sources,
    required this.expireDate,
    this.symbolType = 'EQUITY',
    this.underlyingName = '',
    this.description = '',
  });

  factory NewsAlarm.fromJson(dynamic json) {
    String condition = (json['rule']['when'][0] as Map).keys.first;
    List<dynamic> alarmCondition = json['rule']['when'][0][condition] as List;
    return NewsAlarm(
      id: json['rule']['rule_id'],
      symbol: alarmCondition.last.toString(),
      sources: [
        condition,
      ],
      expireDate: json['rule']['expireDate'].toString(),
      isActive: json['active'],
    );
  }
}

class PriceAlarm extends BaseAlarm {
  final double price;
  final String condition;
  final String expireDate;
  String symbolType;
  String underlyingName;
  String description;

  PriceAlarm({
    required super.id,
    required super.symbol,
    required super.isActive,
    required this.price,
    required this.condition,
    required this.expireDate,
    this.symbolType = 'EQUITY',
    this.underlyingName = '',
    this.description = '',
  });

  factory PriceAlarm.fromJson(dynamic json) {
    String condition = (json['rule']['when'][0] as Map).keys.first;
    List<dynamic> alarmCondition = json['rule']['when'][0][condition] as List;
    return PriceAlarm(
      id: json['rule']['rule_id'],
      symbol: alarmCondition.first.toString().split('.').first,
      price: double.parse(alarmCondition.last.toString()),
      condition: condition == 'ge' ? '>' : '<',
      expireDate: json['rule']['expireDate'].toString(),
      isActive: json['active'],
    );
  }
}
