import 'package:piapiri_v2/core/api/model/proto_model/base_symbol/base_symbol.dart';

class Derivative extends BaseSymbol {
  double strikePrice;
  String maturity;
  String underlying;
  //Enum optionClass;
  double sevenDaysDifPer;
  double thirtyDaysDifPer;
  double fiftytwoWeekDifPer;
  double settlement;
  double settlementPerDif;
  int openInterest;
  double theoricalPrice;
  double theoricelPDifPer;
  double openInterestChange;
  double preSettlement;
  double rate;
  String marketMaker;
  double marketMakerAsk;
  double marketMakerBid;
  String riskLevel;
  double marketMakerAskClose;
  double marketMakerBidClose;
  //Enum publishReason;
  double initialMargin;

  Derivative({
    required this.strikePrice,
    required this.maturity,
    required this.underlying,
    //required this.optionClass,
    required this.sevenDaysDifPer,
    required this.thirtyDaysDifPer,
    required this.fiftytwoWeekDifPer,
    required this.settlement,
    required this.settlementPerDif,
    required this.openInterest,
    required this.theoricalPrice,
    required this.theoricelPDifPer,
    required this.openInterestChange,
    required this.preSettlement,
    required this.rate,
    required this.marketMaker,
    required this.marketMakerAsk,
    required this.marketMakerBid,
    required this.riskLevel,
    required this.marketMakerAskClose,
    required this.marketMakerBidClose,
    //required this.publishReason,
    required this.initialMargin,
    required super.actionType,
    required super.symbolCode,
    required super.symbolDesc,
    required super.tradeDate,
    required super.updateDate,
    required super.openForTrade,
    required super.ask,
    required super.bid,
    required super.dailyHigh,
    required super.dailyLow,
    required super.dailyQuantity,
    required super.dailyVolume,
    required super.dayClose,
    required super.difference,
    required super.differencePercent,
    required super.eqPrice,
    required super.eqQuantity,
    required super.eqRemainingAskQuantity,
    required super.eqRemainingBidQuantity,
    required super.high,
    required super.incrementalQuantity,
    required super.last,
    required super.lastQuantity,
    required super.limitDown,
    required super.limitUp,
    required super.low,
    required super.monthClose,
    required super.monthHigh,
    required super.monthLow,
    required super.monthPriceMean,
    required super.open,
    required super.prevYearClose,
    required super.priceMean,
    required super.priceStep,
    required super.quantity,
    required super.totalTradeCount,
    required super.volume,
    required super.weekClose,
    required super.weekHigh,
    required super.weekLow,
    required super.weekPriceMean,
    required super.yearClose,
    required super.yearHigh,
    required super.yearLow,
    required super.yearPriceMean,
    required super.askSize,
    required super.bidSize,
    required super.brutSwap,
    required super.fractionCount,
    required super.stockStatus,
    required super.symbolId,
  });
}
