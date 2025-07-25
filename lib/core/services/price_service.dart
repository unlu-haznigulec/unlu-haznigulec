import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class PriceService {
  static double getPriceStep(
    double value,
    String? symbolTypeName,
    String? marketCode,
    String? subMarketCode,
  ) {
    if (symbolTypeName == null) return 0.01;
    SymbolTypes type = stringToSymbolType(symbolTypeName);
    Map<String, dynamic> steps = getIt<AppInfoBloc>().state.priceSteps;
    if (type == SymbolTypes.future || type == SymbolTypes.option) return steps['VIOP'][subMarketCode] ?? 0.01;
    List priceStepLimit = steps[type.matriks];
    for (Map<String, dynamic> item in priceStepLimit) {
      if (value < item['UpperLimit']!) {
        return item['PriceStep']!;
      }
    }
    return 0.01; // default value if no match found
  }
}
