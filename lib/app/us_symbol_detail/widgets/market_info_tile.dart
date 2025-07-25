import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/extended_trading_hours_info_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MarketInfoTile extends StatelessWidget {
  final UsMarketStatus usMarketStatus;
  const MarketInfoTile({
    required this.usMarketStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
        bloc: getIt<UsEquityBloc>(),
        builder: (context, state) {
          return InkWell(
            onTap: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('transaction_hours'),
                child: const ExtendedTradingHoursInfoWidget(),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  usMarketStatus.iconPath,
                  width: Grid.m,
                  height: Grid.m,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                Text(
                  ((UsMarketStatus.afterMarket == usMarketStatus || UsMarketStatus.preMarket == usMarketStatus) &&
                          state.latestTradeMixed?.price == null)
                      ? '${L10n.tr(usMarketStatus.localizationKey)} • ${L10n.tr('us_market_not_traded')}'
                      : UsMarketStatus.closed == usMarketStatus
                          ? '${L10n.tr(usMarketStatus.localizationKey)} • ${L10n.tr('us_market_inactive')}'
                          : '${L10n.tr(usMarketStatus.localizationKey)} • ${L10n.tr('us_market_active')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.pAppStyle.labelReg12textSecondary,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SvgPicture.asset(
                  ImagesPath.info,
                  width: Grid.m,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
