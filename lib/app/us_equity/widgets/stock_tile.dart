import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/p_symbol_tile.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class StockTile extends StatelessWidget {
  final USSymbolModel usStockModel;
  final bool? isVolume;

  const StockTile({
    super.key,
    required this.usStockModel,
    this.isVolume = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: PSymbolTile(
        variant: PSymbolVariant.modelPortfolio,
        titleWidget: SymbolIcon(
          key: ValueKey('US_SYMBOL_ICON_${usStockModel.symbol}'),
          size: 30,
          symbolName: usStockModel.symbol.toString(),
          symbolType: SymbolTypes.foreign,
        ),
        title: usStockModel.symbol.toString(),
        subTitle: usStockModel.asset?.name?.toUpperCase() ?? '',
        trailingWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${MoneyUtils().readableMoney(usStockModel.trade?.price ?? 0, pattern: (usStockModel.trade?.price ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####')}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            DiffPercentage(
              percentage: usStockModel.previousDailyBar != null
                  ? ((usStockModel.trade!.price! - usStockModel.previousDailyBar!.close!) /
                          usStockModel.previousDailyBar!.close!) *
                      100
                  : 0,
            ),
          ],
        ),
        onTap: () => {
          if (usStockModel.symbol != null)
            {
              router.push(
                SymbolUsDetailRoute(symbolName: usStockModel.symbol ?? ''),
              ),
            }
        },
      ),
    );
  }
}
