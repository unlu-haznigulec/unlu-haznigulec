import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';

import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';

class PriceInfoWidget extends StatelessWidget {
  final double differencePercent;
  final double lastestDifferencePercent;
  final String price;
  final UsMarketStatus usMarketStatus;
  final LatestTradeMixedModel latestTrade;

  const PriceInfoWidget({
    super.key,
    required this.differencePercent,
    required this.lastestDifferencePercent,
    required this.price,
    required this.usMarketStatus,
    required this.latestTrade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceRow(
          context,
          price: price,
          differencePercent: differencePercent,
          textStyle: context.pAppStyle.labelMed26textPrimary,
          iconSize: Grid.m + Grid.xs,
        ),
        if ((usMarketStatus == UsMarketStatus.afterMarket || usMarketStatus == UsMarketStatus.preMarket) &&
            latestTrade.price != null) ...[
          const SizedBox(height: Grid.s),
          _buildPriceRow(
            context,
            price: MoneyUtils().readableMoney(
              latestTrade.price!,
              pattern: latestTrade.price! >= 1 ? '#,##0.00' : '#,##0.0000#####',
            ),
            differencePercent: lastestDifferencePercent,
            textStyle: context.pAppStyle.labelMed14textPrimary,
            iconSize: Grid.s + Grid.s,
            prefixIcon: SvgPicture.asset(
              usMarketStatus == UsMarketStatus.preMarket ? ImagesPath.yellowCloud : ImagesPath.cloud,
              width: Grid.m + Grid.xxs,
              height: Grid.m + Grid.xxs,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String price,
    required double differencePercent,
    required TextStyle textStyle,
    required double iconSize,
    Widget? prefixIcon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon,
          const SizedBox(width: Grid.xxs),
        ],
        Text(
          '${MoneyUtils().getCurrency(SymbolTypes.foreign)}$price',
          style: textStyle,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        DiffPercentage(
          percentage: differencePercent,
        ),
      ],
    );
  }
}
