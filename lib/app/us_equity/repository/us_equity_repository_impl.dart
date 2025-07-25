import 'package:piapiri_v2/app/us_equity/repository/us_equity_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/us_symbol_manager.dart';

class UsEquityRepositoryImpl extends UsEquityRepository {
  @override
  Future<ApiResponse> getLosersGainers({
    int? number,
  }) {
    return getIt<PPApi>().usEquityService.getLosersGainers(
          number,
        );
  }

  @override
  Future<ApiResponse> getPopulers({
    int? number,
  }) {
    return getIt<PPApi>().usEquityService.getPopulers(
          number,
        );
  }

  @override
  Future<ApiResponse> getVolumes({
    int? number,
  }) {
    return getIt<PPApi>().usEquityService.getVolumes(
          number,
        );
  }

  @override
  Future<ApiResponse> getHistoricalBarsData({
    required String symbols,
    required String timeframe,
    required String currency,
    required String start,
    required String end,
  }) {
    return getIt<PPApi>().usEquityService.getHistoricalBarsData(
          symbols: symbols,
          timeframe: timeframe,
          currency: currency,
          start: start,
          end: end,
        );
  }

  @override
  Future<ApiResponse> getLatestTradeMixed({
    required String symbols,
  }) async {
    return getIt<PPApi>().usEquityService.getLatestTradeMixed(
          symbols: symbols,
        );
  }

  @override
  Future<void> subscribeSymbol(List<String> symbolName) {
    return getIt<UsSymbolManager>().subscribeToSymbols(symbolName);
  }

  @override
  void unsubscribeSymbol(List<String> symbolName) {
    getIt<UsSymbolManager>().unsubscribeFromSymbols(symbolName);
  }

  @override
  void stopConnection() {
    getIt<UsSymbolManager>().stopConnection();
  }

  @override
  Future<ApiResponse> getDividends({
    required List<String> symbols,
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
  }) {
    return getIt<PPApi>().usEquityService.getDividends(
          symbols: symbols,
          types: types,
          startDate: startDate,
          endDate: endDate,
          sortDirection: sortDirection,
        );
  }

  @override
  Future<ApiResponse> getIncomingDividends({
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
    required bool onlyFavorites,
  }) {
    return getIt<PPApi>().usEquityService.getIncomingDividends(
          types: types,
          startDate: startDate,
          endDate: endDate,
          sortDirection: sortDirection,
          onlyFavorites: onlyFavorites,
        );
  }
}
