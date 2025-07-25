import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class UsEquityService {
  final ApiClient apiClient;

  UsEquityService(this.apiClient);

  static const String _getLosersGainers =
      '/capradata/api/Subscription/getmarketmovers?numberOfLosersAndGainersInResponse=';
  static const String _getVolumes = '/capradata/api/Subscription/getactivestocksbyvolume?numberOfTopMostActiveStocks=';
  static const String _getPopulers = '/capradata/api/Subscription/getactivestocksbytrade?numberOfTopMostActiveStocks=';
  static const String _getHistoricalBarsData = '/capradata/api/Subscription/gethistoricalbars';
  static const String _getLatestTradeMixed = '/capradata/api/Subscription/getlatesttrademixed';
  static const String _getDividends = '/capradata/api/Subscription/getallcorporateactions';

  Future<ApiResponse> getHistoricalBarsData({
    required String symbols,
    required String timeframe,
    required String currency,
    required String start,
    required String end,
  }) async {
    final String queryParameters = '?symbol=$symbols'
        '&timeFrame=$timeframe'
        '&curruncy=$currency'
        '&startDate=$start'
        '&endDate=$end'
        '&feed=iex';

    return apiClient.get(
      '$_getHistoricalBarsData$queryParameters',
    );
  }

  Future<ApiResponse> getLatestTradeMixed({
    required String symbols,
  }) async {
    return apiClient.get(
      '$_getLatestTradeMixed?symbol=$symbols',
    );
  }

  Future<ApiResponse> getLosersGainers(int? count) async {
    return apiClient.get(
      '$_getLosersGainers${count ?? 50}',
    );
  }

  Future<ApiResponse> getVolumes(int? count) async {
    return apiClient.get(
      '$_getVolumes${count ?? 50}',
    );
  }

  Future<ApiResponse> getPopulers(int? count) async {
    return apiClient.get(
      '$_getPopulers${count ?? 50}',
    );
  }

  Future<ApiResponse> getDividends({
    required List<String> symbols,
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
  }) async {
    final Map<String, dynamic> body = {
      'symbols': symbols,
      'types': types,
      'startDate': startDate,
      'endDate': endDate,
      'sortDirection': sortDirection,
    };

    return apiClient.post(
      _getDividends,
      body: body,
    );
  }

  Future<ApiResponse> getIncomingDividends({
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
    required bool onlyFavorites,
  }) async {
    final Map<String, dynamic> body = {
      'types': types,
      'startDate': startDate,
      'endDate': endDate,
      'sortDirection': sortDirection,
      'onlyFavorites': onlyFavorites,
    };
    return apiClient.post(
      _getDividends,
      body: body,
    );
  }
}
