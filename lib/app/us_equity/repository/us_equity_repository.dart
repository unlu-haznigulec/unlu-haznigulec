import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class UsEquityRepository {
  Future<ApiResponse> getLosersGainers({
    int? number,
  });

  Future<ApiResponse> getVolumes({
    int? number,
  });

  Future<ApiResponse> getPopulers({
    int? number,
  });

  Future<ApiResponse> getHistoricalBarsData({
    required String symbols,
    required String timeframe,
    required String currency,
    required String start,
    required String end,
  });

  Future<ApiResponse> getLatestTradeMixed({
    required String symbols,
  });

  Future<void> subscribeSymbol(List<String> symbolName);
  void unsubscribeSymbol(List<String> symbolName);
  void stopConnection();

  Future<ApiResponse> getDividends({
    required List<String> symbols,
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
  });

  Future<ApiResponse> getIncomingDividends({
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
    required bool onlyFavorites,
  });
}
