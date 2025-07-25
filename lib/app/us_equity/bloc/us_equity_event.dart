import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';

abstract class UsEquityEvent extends PEvent {}

class GetLosersGainersEvent extends UsEquityEvent {
  final int? number;
  GetLosersGainersEvent({
    this.number,
  });
}

class GetVolumesEvent extends UsEquityEvent {
  final int? number;
  GetVolumesEvent({
    this.number,
  });
}

class GetPopulersEvent extends UsEquityEvent {
  final int? number;
  GetPopulersEvent({
    this.number,
  });
}

class GetHistoricalBarsDataEvent extends UsEquityEvent {
  final ChartFilter? chartFilter;
  final String symbols;

  GetHistoricalBarsDataEvent({
    this.chartFilter,
    required this.symbols,
  });
}

class SubscribeSymbolEvent extends UsEquityEvent {
  final List<String> symbolName;

  SubscribeSymbolEvent({
    required this.symbolName,
  });
}

class UnsubscribeSymbolEvent extends UsEquityEvent {
  final List<String> symbolName;

  UnsubscribeSymbolEvent({
    required this.symbolName,
  });
}

class GetLatestTradeMixedEvent extends UsEquityEvent {
  final String symbols;
  final Function(LatestTradeMixedModel latestTradeMixedModel)? callback;

  GetLatestTradeMixedEvent({
    required this.symbols,
    this.callback,
  });
}

class StopConnectionEvent extends UsEquityEvent {}

class UpdateUsSymbolEvent extends UsEquityEvent {
  final dynamic data;

  UpdateUsSymbolEvent({
    this.data,
  });
}

class UpdateTradeEvent extends UsEquityEvent {
  final dynamic data;

  UpdateTradeEvent({
    this.data,
  });
}

class UpdateDailyBarEvent extends UsEquityEvent {
  final dynamic data;

  UpdateDailyBarEvent({
    this.data,
  });
}

class GetDividendWeeklyEvent extends UsEquityEvent {
  final List<String> symbols;

  GetDividendWeeklyEvent({
    required this.symbols,
  });
}

class GetDividendYearlyEvent extends UsEquityEvent {
  final List<String> symbols;

  GetDividendYearlyEvent({
    required this.symbols,
  });
}

class GetDividendTwoYearEvent extends UsEquityEvent {
  final List<String> symbols;

  GetDividendTwoYearEvent({
    required this.symbols,
  });
}

class GetUsIncomingDividends extends UsEquityEvent {
  final bool isFavorite;
  final Function()? successCallback;

  GetUsIncomingDividends({
    required this.isFavorite,
    this.successCallback,
  });
}

class SetUsChartCurrentType extends UsEquityEvent {
  SetUsChartCurrentType();
}

class SetUsChartType extends UsEquityEvent {
  final ChartType usChartType;
  SetUsChartType({
    required this.usChartType,
  });
}
