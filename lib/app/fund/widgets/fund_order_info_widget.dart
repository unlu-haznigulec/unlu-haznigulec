import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/risk_bar/risk_bar.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';

import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundOrderInfoWidget extends StatelessWidget {
  final FundDetailModel fund;

  const FundOrderInfoWidget({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    double performance = (fund.performance1D ?? 0) * 100;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SymbolIcon(
              symbolName: fund.institutionCode,
              symbolType: SymbolTypes.fund,
              size: 30,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund.subType,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  '${fund.code} • ${fund.founder.toCapitalizeCaseTr}',
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () => SymbolSearchUtils.goSymbolDetail(
                filterList: SymbolSearchFilterEnum.values
                    .where(
                      (element) => ![
                        SymbolSearchFilterEnum.crypto,
                        SymbolSearchFilterEnum.parity,
                        SymbolSearchFilterEnum.endeks,
                        SymbolSearchFilterEnum.etf,
                      ].contains(element),
                    )
                    .toList(),
              ),
              child: SvgPicture.asset(
                ImagesPath.search,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Grid.s),
          child: PDivider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  L10n.tr('fiyat'),
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  '₺${MoneyUtils().readableMoney(
                    fund.price ?? 0,
                    pattern: '#,##0.000000',
                  )}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  L10n.tr('risk_level'),
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                fund.riskLevel != null && fund.riskLevel != 0
                    ? RiskBar(riskLevel: fund.riskLevel!)
                    : Text(
                        '-',
                        style: context.pAppStyle.labelMed14textSecondary,
                      ),
              ],
            ),
            Column(
              children: [
                Text(
                  '%${L10n.tr('fark')}',
                  style: context.pAppStyle.labelMed14textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                DiffPercentage(
                  percentage: performance,
                  fontSize: Grid.m - Grid.xxs,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
