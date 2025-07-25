import 'package:piapiri_v2/app/search_symbol/repository/symbol_search_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class SymbolSearchRepositoryImpl extends SymbolSearchRepository {
  DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Future<List<SymbolModel>> searchSymbol({
    required String symbolName,
    required String exchangeCode,
    required bool isFund,
    required List<String>? filterDbKeys,
  }) async {
    late List<Map<String, dynamic>> symbols;
    if (isFund) {
      symbols = await dbHelper.fundSearchSymbol(symbolName);
    } else {
      symbols = exchangeCode == '0'
          ? await dbHelper.searchSymbol(symbolName, false, filterDbKeys)
          : await dbHelper.searchSymbolByExchangeCode(
              symbolName,
              exchangeCode,
              false,
              filterDbKeys,
            );
    }
    return symbols
        .map<SymbolModel>(
          (e) => SymbolModel.fromMap(e),
        )
        .toList();
  }

  @override
  Future<List<SymbolModel>> searchUsSymbol({
    required String symbolName,
    required int count,
  }) async {
    
    ApiResponse response = await getIt<PPApi>().symbolSearchService.searchUsSymbol(symbolName, count);
    if (response.success) {
      return response.data['assetsItems'].map<SymbolModel>((e) => SymbolModel.fromUsMap(e)).toList();
    }
    return [];
  }

  @override
  Future<List<SymbolModel>> getOldSearches() async {
    List<dynamic> searchList = await getIt<LocalStorage>().read(LocalKeys.symbolSearchCache) ?? [];
    return searchList.map((e) => SymbolModel.fromMap(e)).toList();
  }

  @override
  void setOldSearches({
    required List<SymbolModel> symbolModelList,
  }) {
    getIt<LocalStorage>().write(LocalKeys.symbolSearchCache, symbolModelList.map((e) => e.toMap()).toList());
  }

  @override
  Future<List<Map<String, dynamic>>> getExchangeList() async {
    return await dbHelper.getExchangeList();
  }

  @override
  Future<List<String>> getUnderlyingList(SymbolSearchFilterEnum filter, String? maturity) async {
    List<Map<String, dynamic>> underlyingList = await dbHelper.getViopUnderlyingList(filter, maturity);
    return underlyingList.map((e) => e['UnderlyingName'].toString()).toSet().toList();
  }

  @override
  Future<List<String>> getMaturityListByUnderlying(SymbolSearchFilterEnum filter, String? underlying) async {
    dynamic maturitys = await dbHelper.getMaturityByUnderlying(filter, underlying);
    List<String> dateList = List<String>.from(maturitys.map((e) => e['MaturityDate'])).toList();
    return DateTimeUtils.getViopMaturity(dateList);
  }

  @override
  Future<List<SymbolModel>> getViopByFilters({
    required String filter,
    required String? underlyingName,
    required String? maturityDate,
    required String? transactionType,
  }) async {
    List<Map<String, dynamic>> symbols =
        await dbHelper.getViopByFilters(
      filter,
      underlyingName,
      maturityDate,
      transactionType,
      null,
    );
    List<SymbolModel> symbolModelList = symbols.map((e) => SymbolModel.fromMap(e)).toList();
    symbolModelList.sort((a, b) => a.name.compareTo(b.name));
    return symbolModelList;
  }

  @override
  Future<ApiResponse> getPositionList({
    required String selectedAccount,
  }) {
    return getIt<PPApi>().ordersService.getPositionList(
          selectedAccount: '${UserModel.instance.customerId}-${selectedAccount}',
        );
  }

  @override
  Future<ApiResponse> getViopPositionList() {
    return getIt<PPApi>().assetsService.getAccountOverallWithsummary(
      accountId: ''
        );
  }

  @override
  Future<ApiResponse> getUsPositionList() {
    return getIt<PPApi>().usCreateOrderService.getPositionList();
  }

  @override
  Future<Map<String, dynamic>> getSymbolsDetail({
    required List<Map<String, String>> symbolNames,
  }) async {
    List<Map<String, dynamic>> selectedListItem = await dbHelper.getDetailsOfPosition(symbolNames);
    Map<String, dynamic> mappedListItems = {
      for (var item in selectedListItem)
        item['BistCode']!: {
          'Name': item['Name']!,
          'Description': item['Description']!,
          'UnderlyingName': item['UnderlyingName'] ?? '',
          'TypeCode': item['TypeCode']
        }
    };

    return mappedListItems;
  }

}
