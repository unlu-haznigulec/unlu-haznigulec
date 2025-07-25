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

class LoserGainerTile extends StatelessWidget {
  final USSymbolModel loserGainerModel;

  const LoserGainerTile({
    super.key,
    required this.loserGainerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: PSymbolTile(
        variant: PSymbolVariant.equityTab,
        titleWidget: SymbolIcon(
          size: 30,
          symbolName: loserGainerModel.symbol.toString(),
          symbolType: SymbolTypes.foreign,
        ),
        title: loserGainerModel.symbol.toString(),
        subTitle: loserGainerModel.asset?.name?.toUpperCase() ?? '',
        trailingWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${MoneyUtils().readableMoney(loserGainerModel.trade?.price ?? 0, pattern: (loserGainerModel.trade?.price ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####')}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            DiffPercentage(
              percentage: loserGainerModel.previousDailyBar != null
                  ? ((loserGainerModel.trade!.price! - loserGainerModel.previousDailyBar!.close!) /
                          loserGainerModel.previousDailyBar!.close!) *
                      100
                  : 0,
            ),
          ],
        ),
        onTap: () => {
          {
            router.push(
              SymbolUsDetailRoute(symbolName: loserGainerModel.symbol ?? ''),
            ),
          }
        },
      ),
    );
  }
}
