import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/trading_hour_row_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ExtendedTradingHoursInfoWidget extends StatelessWidget {
  const ExtendedTradingHoursInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          L10n.tr('transaction_hours_desc'),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: PDivider(),
        ),
        TradingHourRowWidget(
          iconPath: ImagesPath.yellowCloud,
          text: L10n.tr('pre_market'),
        ),
        const SizedBox(height: Grid.m),
        TradingHourRowWidget(
          iconPath: ImagesPath.sun,
          text: L10n.tr('open_market'),
        ),
        const SizedBox(height: Grid.m),
        TradingHourRowWidget(
          iconPath: ImagesPath.cloud,
          text: L10n.tr('post_market'),
        ),
        const SizedBox(height: Grid.m),
        TradingHourRowWidget(
          iconPath: ImagesPath.moon,
          text: L10n.tr('close_market'),
        ),
        const SizedBox(height: Grid.m),
      ],
    );
  }
}
