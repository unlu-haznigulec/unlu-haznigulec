import 'package:piapiri_v2/app/us_symbol_detail/model/dividend_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class UsEquityState extends PState {
  final List<LoserGainerModel> losers;
  final List<LoserGainerModel> gainers;
  final List<USStockModel> volumes;
  final List<USStockModel> populers;
  final List<USSymbolModel> watchingItems;
  final USSymbolModel? updatedSymbol;
  final List<CurrentDailyBar>? graphData;
  final LatestTradeMixedModel? latestTradeMixed;
  final MapEntry<DateTime, double?>? dividend;
  final List<CashDividendsList> dividendYearlyList;
  final List<CashDividendsList> dividendTwoYearList;
  final PageState dividendWeeklyState;
  final PageState dividendYearlyState;
  final PageState dividendTwoYearState;

  final PageState? favoriteIncomingDividendsState;
  final PageState? allIncomingDividendsState;

  final List<String> favoriteIncomingDividends;
  final List<String> allIncomingDividends;

  final CurrencyEnum currencyType;
  final ChartType chartType;
  final ChartFilter chartFilter;

  const UsEquityState({
    super.type = PageState.initial,
    super.error,
    this.losers = const [],
    this.gainers = const [],
    this.volumes = const [],
    this.populers = const [],
    this.watchingItems = const [],
    this.updatedSymbol,
    this.graphData = const [],
    this.latestTradeMixed,
    this.dividend,
    this.dividendYearlyList = const [],
    this.dividendTwoYearList = const [],
    this.dividendWeeklyState = PageState.initial,
    this.dividendYearlyState = PageState.initial,
    this.dividendTwoYearState = PageState.initial,
    this.favoriteIncomingDividends = const [],
    this.allIncomingDividends = const [],
    this.favoriteIncomingDividendsState = PageState.initial,
    this.allIncomingDividendsState = PageState.initial,
    this.currencyType = CurrencyEnum.dollar,
    this.chartType = ChartType.area,
    this.chartFilter = ChartFilter.oneDay,
  });

  @override
  UsEquityState copyWith({
    PageState? type,
    PBlocError? error,
    List<LoserGainerModel>? losers,
    List<LoserGainerModel>? gainers,
    List<USStockModel>? volumes,
    List<USStockModel>? populers,
    List<USSymbolModel>? watchingItems,
    USSymbolModel? updatedSymbol,
    List<CurrentDailyBar>? graphData,
    LatestTradeMixedModel? latestTradeMixed,
    MapEntry<DateTime, double?>? dividend,
    List<CashDividendsList>? dividendYearlyList,
    List<CashDividendsList>? dividendTwoYearList,
    PageState? dividendWeeklyState,
    PageState? dividendYearlyState,
    PageState? dividendTwoYearState,
    PageState? favoriteIncomingDividendsState = PageState.initial,
    PageState? allIncomingDividendsState = PageState.initial,
    List<String>? favoriteIncomingDividends,
    List<String>? allIncomingDividends,
    CurrencyEnum? currencyType,
    ChartType? chartType,
    ChartFilter? chartFilter,
  }) {
    return UsEquityState(
      type: type ?? this.type,
      error: error ?? this.error,
      losers: losers ?? this.losers,
      gainers: gainers ?? this.gainers,
      volumes: volumes ?? this.volumes,
      populers: populers ?? this.populers,
      watchingItems: watchingItems ?? this.watchingItems,
      updatedSymbol: updatedSymbol ?? this.updatedSymbol,
      graphData: graphData ?? this.graphData,
      latestTradeMixed: latestTradeMixed ?? this.latestTradeMixed,
      dividend: dividend ?? this.dividend,
      dividendYearlyList: dividendYearlyList ?? this.dividendYearlyList,
      dividendTwoYearList: dividendTwoYearList ?? this.dividendTwoYearList,
      dividendWeeklyState: dividendWeeklyState ?? this.dividendWeeklyState,
      dividendYearlyState: dividendYearlyState ?? this.dividendYearlyState,
      dividendTwoYearState: dividendTwoYearState ?? this.dividendTwoYearState,
      favoriteIncomingDividendsState: favoriteIncomingDividendsState ?? this.favoriteIncomingDividendsState,
      allIncomingDividendsState: allIncomingDividendsState ?? this.allIncomingDividendsState,
      favoriteIncomingDividends: favoriteIncomingDividends ?? this.favoriteIncomingDividends,
      allIncomingDividends: allIncomingDividends ?? this.allIncomingDividends,
      currencyType: currencyType ?? this.currencyType,
      chartType: chartType ?? this.chartType,
      chartFilter: chartFilter ?? this.chartFilter,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        losers,
        gainers,
        volumes,
        populers,
        watchingItems,
        updatedSymbol,
        graphData,
        latestTradeMixed,
        dividend,
        dividendYearlyList,
        dividendTwoYearList,
        dividendWeeklyState,
        dividendYearlyState,
        dividendTwoYearState,
        favoriteIncomingDividendsState,
        allIncomingDividendsState,
        favoriteIncomingDividends,
        allIncomingDividends,
        currencyType,
        chartType,
        chartFilter,
      ];
}
