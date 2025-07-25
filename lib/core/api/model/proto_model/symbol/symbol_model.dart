import 'package:piapiri_v2/core/api/model/proto_model/base_symbol/base_symbol.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class SymbolModel extends BaseSymbol {
  double days7DifPer; // 7 gunluk fark yuzdesi
  double days30DifPer; // 30 gunluk fark yuzdesi
  double week52DifPer; // 52 haftalik fark yuzdesi
  double netProceeds;
  double priceProceeds;
  double marketValue; // Piyasa Degeri
  double marketValueUsd; // Piyasa Degeri USD
  double marValBookVal;
  double equity;
  double capital;
  double circulationShare;
  double circulationSharePer;
  String symbolGroup;
  bool sessionIsOpen;
  double basePrice;
  String symbolType;
  int tradeFraction;
  String stockSymbolCode;
  String period;
  double shiftedNetProceed;
  int direction;
  double beta100;
  double cashNetDividend;
  double dividendYield;
  bool hasSymbolId;
  bool hasSymbolCode;
  bool hasSymbolDesc;
  bool hasUpdateDate;
  bool hasBid;
  bool hasAsk;
  bool hasLow;
  bool hasHigh;
  bool hasLast;
  bool hasDayClose;
  bool hasDailyLow;
  bool hasDailyHigh;
  bool hasQuantity;
  bool hasVolume;
  bool hasMonthHigh;
  bool hasMonthLow;
  bool hasYearHigh;
  bool hasYearLow;
  bool hasPriceMean;
  bool hasLimitUp;
  bool hasLimitDown;
  bool hasNetProceeds;
  bool hasEquity;
  bool hasCapital;
  bool hasCirculationShare;
  bool hasCirculationSharePer;
  bool hasSymbolGroup;
  bool hasDailyVolume;
  bool hasPriceStep;
  bool hasBasePrice;
  bool hasTradeDate;
  bool hasOpen;
  bool hasDailyQuantity;
  bool hasActionType;
  bool hasBrutSwap;
  bool hasLastQuantity;
  bool hasWeekLow;
  bool hasWeekHigh;
  bool hasWeekClose;
  bool hasMonthClose;
  bool hasYearClose;
  bool hasPeriod;
  bool hasShiftedNetProceed;
  bool hasAskSize;
  bool hasBidSize;
  bool hasEqPrice;
  bool hasEqQuantity;
  bool hasEqRemainingBidQuantity;
  bool hasEqRemainingAskQuantity;
  bool hasPrevYearClose;
  bool hasWeekPriceMean;
  bool hasMonthPriceMean;
  bool hasYearPriceMean;
  bool hasBeta100;
  bool hasCashNetDividend;
  bool hasStockStatus;
//  PublishReason publishReason;
  dynamic publishReason;
  double xu030Weight;
  double xu050Weight;
  double xu100Weight;

  // Fark = Last - dayClose
  // %Fark = ((Last - dayClose) / dayclose) * 100)
  // Denge = ?
  // Denge% = ?

  SymbolModel({
    required this.days7DifPer,
    required this.days30DifPer,
    required this.week52DifPer,
    required this.netProceeds,
    required this.priceProceeds,
    required this.marketValue,
    required this.marketValueUsd,
    required this.marValBookVal,
    required this.equity,
    required this.capital,
    required this.circulationShare,
    required this.circulationSharePer,
    required this.symbolGroup,
    required this.sessionIsOpen,
    required this.basePrice,
    required this.symbolType,
    required this.tradeFraction,
    required this.stockSymbolCode,
    required this.period,
    required this.shiftedNetProceed,
    required this.direction,
    required this.beta100,
    required this.cashNetDividend,
    required this.dividendYield,
    required this.hasSymbolId,
    required this.hasSymbolCode,
    required this.hasSymbolDesc,
    required this.hasUpdateDate,
    required this.hasBid,
    required this.hasAsk,
    required this.hasLow,
    required this.hasHigh,
    required this.hasLast,
    required this.hasDayClose,
    required this.hasEqRemainingBidQuantity,
    required this.hasEqQuantity,
    required this.hasDailyVolume,
    required this.hasDailyLow,
    required this.hasDailyHigh,
    required this.hasQuantity,
    required this.hasVolume,
    required this.hasMonthHigh,
    required this.hasMonthLow,
    required this.hasYearHigh,
    required this.hasYearLow,
    required this.hasPriceMean,
    required this.hasLimitUp,
    required this.hasLimitDown,
    required this.hasNetProceeds,
    required this.hasEquity,
    required this.hasCapital,
    required this.hasCirculationShare,
    required this.hasCirculationSharePer,
    required this.hasSymbolGroup,
    required this.hasPriceStep,
    required this.hasBasePrice,
    required this.hasTradeDate,
    required this.hasOpen,
    required this.hasDailyQuantity,
    required this.hasActionType,
    required this.hasBrutSwap,
    required this.hasLastQuantity,
    required this.hasWeekLow,
    required this.hasWeekHigh,
    required this.hasWeekClose,
    required this.hasMonthClose,
    required this.hasYearClose,
    required this.hasPeriod,
    required this.hasShiftedNetProceed,
    required this.hasAskSize,
    required this.hasBidSize,
    required this.hasEqPrice,
    required this.hasEqRemainingAskQuantity,
    required this.hasPrevYearClose,
    required this.hasWeekPriceMean,
    required this.hasMonthPriceMean,
    required this.hasYearPriceMean,
    required this.hasBeta100,
    required this.hasCashNetDividend,
    required this.hasStockStatus,
    required this.publishReason,
    required this.xu030Weight,
    required this.xu050Weight,
    required this.xu100Weight,
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
    required super.incrementalQuantity,
  });

  factory SymbolModel.fromMarketListModel(MarketListModel symbol) {
    return SymbolModel(
      days7DifPer: symbol.days7DifPer,
      days30DifPer: symbol.days30DifPer,
      week52DifPer: symbol.week52DifPer,
      netProceeds: symbol.netProceeds,
      priceProceeds: symbol.priceProceeds,
      marketValue: symbol.marketValue,
      marketValueUsd: symbol.marketValueUsd,
      marValBookVal: symbol.marValBookVal,
      equity: symbol.equity,
      capital: symbol.capital,
      circulationShare: symbol.circulationShare,
      circulationSharePer: symbol.circulationSharePer,
      symbolGroup: symbol.symbolGroup,
      sessionIsOpen: symbol.sessionIsOpen,
      basePrice: symbol.basePrice,
      symbolType: symbol.type,
      tradeFraction: symbol.tradeFraction,
      stockSymbolCode: symbol.stockSymbolCode,
      period: symbol.period,
      shiftedNetProceed: symbol.shiftedNetProceed,
      direction: symbol.direction,
      beta100: symbol.beta100,
      cashNetDividend: symbol.cashNetDividend,
      dividendYield: symbol.dividendYield,
      hasSymbolId: false,
      hasSymbolCode: false,
      hasSymbolDesc: false,
      hasUpdateDate: false,
      hasBid: false,
      hasAsk: false,
      hasLow: false,
      hasHigh: false,
      hasLast: false,
      hasDayClose: false,
      hasEqRemainingBidQuantity: false,
      hasEqQuantity: false,
      hasDailyVolume: false,
      hasDailyLow: false,
      hasDailyHigh: false,
      hasQuantity: false,
      hasVolume: false,
      hasMonthHigh: false,
      hasMonthLow: false,
      hasYearHigh: false,
      hasYearLow: false,
      hasPriceMean: false,
      hasLimitUp: false,
      hasLimitDown: false,
      hasNetProceeds: false,
      hasEquity: false,
      hasCapital: false,
      hasCirculationShare: false,
      hasCirculationSharePer: false,
      hasSymbolGroup: false,
      hasPriceStep: false,
      hasBasePrice: false,
      hasTradeDate: false,
      hasOpen: false,
      hasDailyQuantity: false,
      hasActionType: false,
      hasBrutSwap: false,
      hasLastQuantity: false,
      hasWeekLow: false,
      hasWeekHigh: false,
      hasWeekClose: false,
      hasMonthClose: false,
      hasYearClose: false,
      hasPeriod: false,
      hasShiftedNetProceed: false,
      hasAskSize: false,
      hasBidSize: false,
      hasEqPrice: false,
      hasEqRemainingAskQuantity: false,
      hasPrevYearClose: false,
      hasWeekPriceMean: false,
      hasMonthPriceMean: false,
      hasYearPriceMean: false,
      hasBeta100: false,
      hasCashNetDividend: false,
      hasStockStatus: false,
      publishReason: 'refresh',
      xu030Weight: symbol.xu030Weight,
      xu050Weight: symbol.xu050Weight,
      xu100Weight: symbol.xu100Weight,
      actionType: symbol.actionType,
      symbolCode: symbol.symbolCode,
      symbolDesc: symbol.symbolDesc,
      tradeDate: symbol.tradeDate,
      updateDate: symbol.updateDate,
      openForTrade: symbol.openForTrade,
      ask: symbol.ask,
      bid: symbol.bid,
      dailyHigh: symbol.dailyHigh,
      dailyLow: symbol.dailyLow,
      dailyQuantity: symbol.dailyQuantity,
      dailyVolume: symbol.dailyVolume,
      dayClose: symbol.dayClose,
      difference: symbol.difference,
      differencePercent: symbol.differencePercent,
      eqPrice: symbol.eqPrice,
      eqQuantity: symbol.eqQuantity,
      eqRemainingAskQuantity: symbol.eqRemainingAskQuantity,
      eqRemainingBidQuantity: symbol.eqRemainingBidQuantity,
      high: symbol.high,
      last: symbol.last,
      lastQuantity: symbol.lastQuantity,
      limitDown: symbol.limitDown,
      limitUp: symbol.limitUp,
      low: symbol.low,
      monthClose: symbol.monthClose,
      monthHigh: symbol.monthHigh,
      monthLow: symbol.monthLow,
      monthPriceMean: symbol.monthPriceMean,
      open: symbol.open,
      prevYearClose: symbol.prevYearClose,
      priceMean: symbol.priceMean,
      priceStep: symbol.priceStep,
      quantity: symbol.quantity,
      totalTradeCount: symbol.totalTradeCount,
      volume: symbol.volume,
      weekClose: symbol.weekClose,
      weekHigh: symbol.weekHigh,
      weekLow: symbol.weekLow,
      weekPriceMean: symbol.weekPriceMean,
      yearClose: symbol.yearClose,
      yearHigh: symbol.yearHigh,
      yearLow: symbol.yearLow,
      yearPriceMean: symbol.yearPriceMean,
      askSize: symbol.askSize,
      bidSize: symbol.bidSize,
      brutSwap: symbol.brutSwap,
      fractionCount: symbol.fractionCount,
      stockStatus: symbol.stockStatus,
      symbolId: symbol.symbolId,
      incrementalQuantity: symbol.incrementalQuantity,
    );
  }

  MarketListModel toMarketListModel() {
    return MarketListModel(
      days7DifPer: days7DifPer,
      days30DifPer: days30DifPer,
      week52DifPer: week52DifPer,
      netProceeds: netProceeds,
      priceProceeds: priceProceeds,
      marketValue: marketValue,
      marketValueUsd: marketValueUsd,
      marValBookVal: marValBookVal,
      equity: equity,
      capital: capital,
      circulationShare: circulationShare,
      circulationSharePer: circulationSharePer,
      symbolGroup: symbolGroup,
      sessionIsOpen: sessionIsOpen,
      basePrice: basePrice,
      symbolType: symbolType,
      tradeFraction: tradeFraction,
      stockSymbolCode: stockSymbolCode,
      period: period,
      shiftedNetProceed: shiftedNetProceed,
      direction: direction,
      beta100: beta100,
      cashNetDividend: cashNetDividend,
      dividendYield: dividendYield,
      xu030Weight: xu030Weight,
      xu050Weight: xu050Weight,
      xu100Weight: xu100Weight,
      actionType: actionType,
      symbolCode: symbolCode,
      symbolDesc: symbolDesc,
      tradeDate: tradeDate,
      updateDate: updateDate,
      openForTrade: openForTrade,
      ask: ask,
      bid: bid,
      dailyHigh: dailyHigh,
      dailyLow: dailyLow,
      dailyQuantity: dailyQuantity,
      dailyVolume: dailyVolume,
      dayClose: dayClose,
      difference: difference,
      differencePercent: differencePercent,
      eqPrice: eqPrice,
      eqQuantity: eqQuantity,
      eqRemainingAskQuantity: eqRemainingAskQuantity,
      eqRemainingBidQuantity: eqRemainingBidQuantity,
      high: high,
      last: last,
      lastQuantity: lastQuantity,
      limitDown: limitDown,
      limitUp: limitUp,
      low: low,
      monthClose: monthClose,
      monthHigh: monthHigh,
      monthLow: monthLow,
      monthPriceMean: monthPriceMean,
      open: open,
      prevYearClose: prevYearClose,
      priceMean: priceMean,
      priceStep: priceStep,
      quantity: quantity,
      totalTradeCount: totalTradeCount,
      volume: volume,
      weekClose: weekClose,
      weekHigh: weekHigh,
      weekLow: weekLow,
      weekPriceMean: weekPriceMean,
      yearClose: yearClose,
      yearHigh: yearHigh,
      yearLow: yearLow,
      yearPriceMean: yearPriceMean,
      askSize: askSize,
      bidSize: bidSize,
      brutSwap: brutSwap,
      fractionCount: fractionCount,
      stockStatus: stockStatus,
      symbolId: symbolId,
      incrementalQuantity: incrementalQuantity,
    );
  }
}
