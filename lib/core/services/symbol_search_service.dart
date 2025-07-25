import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class SymbolSearchService {
  final ApiClient api;

  SymbolSearchService(this.api);

  static const String _postCapraGetAllAssets = '/Capra/GetAllAssets';

  Future<ApiResponse> searchUsSymbol(String symbol, int count) async {
    return api.post(
      _postCapraGetAllAssets,
      tokenized: false,
      body: {
        'Status': '',
        'asset_class': '',
        'attributes': '',
        'count': count,
        'Symbol': symbol,
      },
    );
  }
}
