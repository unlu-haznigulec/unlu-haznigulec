import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BrokerageNoLicence extends StatelessWidget {
  const BrokerageNoLicence({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.tr('what_is_brokerage_distribution'),
          style: context.pAppStyle.labelSemiBold14textPrimary,
        ),
        const SizedBox(height: Grid.m),
        Text(
          L10n.tr('what_is_brokerage_distribution_content'),
          style: context.pAppStyle.labelReg14textSecondary,
        ),
        const SizedBox(height: Grid.l),
        PDivider(
          color: context.pColorScheme.line,
          tickness: 1,
        ),
        const SizedBox(height: Grid.l),
        Text(
          L10n.tr('you_dont_have_brokerage_license'),
          style: context.pAppStyle.labelReg14textSecondary,
        ),
        const SizedBox(height: Grid.s),
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          child: Row(
            children: [
              Text(
                L10n.tr('add_brokerage_license'),
                style: context.pAppStyle.labelReg16primary,
              ),
              const SizedBox(width: Grid.xs),
              SvgPicture.asset(
                ImagesPath.arrow_up_right,
                height: 14,
                width: 14,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          onTap: () {
            router.push(const LicensesRoute());
          },
        )
      ],
    );
  }
}
