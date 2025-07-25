import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsBrief extends StatelessWidget {
  final double _rowHeight = 54;
  const UsBrief({
    super.key,
    required this.data,
    required this.previousDailyData,
  });
  final CurrentDailyBar data;
  final PreviousDailyBar previousDailyData;

  @override
  Widget build(BuildContext context) {
    final symbolBriefs = {
      L10n.tr('chartOpen'): CurrencyEnum.dollar.symbol +
          MoneyUtils().readableMoney(
            data.open!,
            pattern: data.open! >= 1 ? '#,##0.00' : '#,##0.0000#####',
          ),
      L10n.tr('onceki_kapanis'): CurrencyEnum.dollar.symbol +
          MoneyUtils().readableMoney(
            previousDailyData.close!,
            pattern: data.close! >= 1 ? '#,##0.00' : '#,##0.0000#####',
          ),
      L10n.tr('chartHigh'): CurrencyEnum.dollar.symbol +
          MoneyUtils().readableMoney(
            data.high!,
            pattern: data.high! >= 1 ? '#,##0.00' : '#,##0.0000#####',
          ),
      L10n.tr('chartLow'): CurrencyEnum.dollar.symbol +
          MoneyUtils().readableMoney(
            data.low!,
            pattern: data.low! >= 1 ? '#,##0.00' : '#,##0.0000#####',
          ),
      L10n.tr('number_of_transactions'): MoneyUtils().compactMoney(data.tradeCount!.toDouble()),
      L10n.tr('volume'): MoneyUtils().compactMoney(data.volume!.toDouble()),
    };

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            L10n.tr('piyasa_ozeti'),
            style: context.pAppStyle.labelMed18textPrimary,
          ),
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),
          ..._generateHeaderInfos(symbolBriefs),
        ]);
  }

  List<Widget> _generateHeaderInfos(Map<String, dynamic> symbolBriefs) {
    List<Widget> headerInfos = [];
    final keys = symbolBriefs.keys.toList();
    final values = symbolBriefs.values.toList();

    for (var i = 0; i < keys.length; i += 2) {
      headerInfos.add(
        SizedBox(
          height: _rowHeight,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: keys[i],
                  value: values[i],
                ),
              ),
              if (i + 1 < keys.length)
                Expanded(
                  child: SymbolBriefInfo(
                    label: keys[i + 1],
                    value: values[i + 1],
                  ),
                ),
              if (i + 1 >= keys.length) const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }
}
