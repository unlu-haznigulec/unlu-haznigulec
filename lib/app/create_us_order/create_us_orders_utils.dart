import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class CreateOrdersUtils {
  final CreateUsOrdersBloc createUsOrdersBloc = getIt<CreateUsOrdersBloc>();

  //Komisyon hesaplamasi yapar
  // Adet basina komisyon * adet  minimum komisyondan buyukse hesaplanan komisyonu doner
  // degilse minimum komisyonu doner
  double calculateCommission(double unit) {
    double calculatedCommision = unit * createUsOrdersBloc.state.commissionPerUnit;
    if (calculatedCommision > createUsOrdersBloc.state.minCommission) {
      return calculatedCommision;
    } else {
      return createUsOrdersBloc.state.minCommission;
    }
  }

  String getUnitPattern(bool fractionable, num rawUnit) {
    if (!fractionable) return '#,##0';
    if (rawUnit == 0) return '#,##0.0';
    return MoneyUtils().getPatternByUnitDecimal(rawUnit);
  }

  double? getEquityPrice(USSymbolModel? symbol, LatestTradeMixedModel? latestTradeMixedModel) {
    UsMarketStatus usMarketStatus = getMarketStatus();

    if (usMarketStatus == UsMarketStatus.preMarket || usMarketStatus == UsMarketStatus.afterMarket) {
      if (latestTradeMixedModel?.price != null) return latestTradeMixedModel!.price;
    }
    if (symbol?.trade?.price != null) {
      return symbol!.trade!.price;
    }
    return null;
  }
}
