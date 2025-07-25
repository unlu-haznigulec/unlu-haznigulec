import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoDemandedDetailRow extends StatelessWidget {
  final IpoDemandModel? demandedIpo;
  const IpoDemandedDetailRow({
    super.key,
    required this.demandedIpo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(children: [
        _rowWidget(
          context,
          L10n.tr('durum'),
          L10n.tr('PENDINGNEW'),
          valueColor: context.pColorScheme.primary,
        ),
        _rowWidget(
          context,
          L10n.tr('symbol'),
          demandedIpo?.name ?? '',
          valueWidget: InkWell(
            splashColor: context.pColorScheme.transparent,
            highlightColor: context.pColorScheme.transparent,
            onTap: () {
              MarketListModel selectedItem = MarketListModel(
                symbolCode: demandedIpo?.name ?? '',
                updateDate: '',
              );

              router.push(
                SymbolDetailRoute(
                  symbol: selectedItem,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  ImagesPath.arrow_up_right,
                  width: 14,
                  height: 14,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  demandedIpo?.name ?? '',
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
          ),
        ),
        _rowWidget(
          context,
          L10n.tr('islem_turu'),
          L10n.tr('participation_ipo'),
          valueColor: context.pColorScheme.primary,
        ),
        _rowWidget(
          context,
          L10n.tr('ipo_price'),
          '₺${MoneyUtils().readableMoney(demandedIpo?.offerPrice ?? 0)}',
        ),
        _rowWidget(
          context,
          L10n.tr('adet'),
          '${demandedIpo?.unitsDemanded ?? ''}',
        ),
        _rowWidget(
          context,
          L10n.tr('tutar'),
          MoneyUtils().readableMoney(
            demandedIpo?.amountDemanded ?? 0,
          ),
        ),
        _rowWidget(
          context,
          L10n.tr('payment_type'),
          _detailValue(demandedIpo?.detail ?? ''),
        ),
        _rowWidget(
          context,
          L10n.tr('hesap'),
          demandedIpo?.accountExtId ?? '',
        ),
        _rowWidget(
          context,
          L10n.tr('order_date'),
          DateTime.parse(demandedIpo?.demandDate ?? DateTime.now().toString()).formatDayMonthYearTimeWithComma(),
        ),
        _rowWidget(
          context,
          L10n.tr('ipo_order_no'),
          '${demandedIpo?.ipoDemandExtId ?? ''}',
        ),
        _rowWidget(
          context,
          L10n.tr('ipo_minimum_lot'),
          '${demandedIpo?.minimumDemand ?? ''}',
        ),
      ]),
    );
  }

  String _detailValue(key) {
    switch (key) {
      case 'Cash':
      case 'Nakit':
        return L10n.tr('ipo_cash');
      case 'Fon Blokajı':
      case 'Fund Blockage':
        return L10n.tr('ipo_fund_blockage');
      case 'Hisse Blokajı':
      case 'Equity Blockage':
        return L10n.tr('ipo_equity_blockage');
      default:
        return L10n.tr('ipo_cash');
    }
  }

  Widget _rowWidget(
    BuildContext context,
    String title,
    String value, {
    Color? valueColor,
    Widget? valueWidget,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: valueWidget ??
                  Text(
                    value,
                    textAlign: TextAlign.right,
                    style: context.pAppStyle.interMediumBase.copyWith(
                      color: valueColor ?? context.pColorScheme.textPrimary,
                      fontSize: Grid.m - Grid.xxs,
                    ),
                  ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s,
          ),
          child: PDivider(),
        )
      ],
    );
  }
}
