import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DirectionViopWarrantWidget extends StatelessWidget {
  final String detailSymbolName;
  final String underlyingSymbolName;
  const DirectionViopWarrantWidget({
    super.key,
    required this.detailSymbolName,
    required this.underlyingSymbolName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Grid.l,
        ),
        Text(
          L10n.tr('perform_the_following'),
          style: context.pAppStyle.labelReg14textSecondary,
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: PCustomOutlinedButtonWithIcon(
                fillParentWidth: true,
                text: L10n.tr('symbol_warrants', args: [underlyingSymbolName]),
                textStyle: context.pAppStyle.labelMed14primary,
                iconSource: ImagesPath.arrow_up_right,
                buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                onPressed: () {
                  if (router.routeNames.contains(WarrantRoute.name) || router.routeNames.contains(ViopRoute.name)) {
                    router.popUntilRouteWithName(DashboardRoute.name);
                    router.push(
                      WarrantRoute(
                        underlyingName: underlyingSymbolName,
                        ignoreUnsubList: [detailSymbolName],
                      ),
                    );
                  } else {
                    router.push(
                      WarrantRoute(
                        underlyingName: underlyingSymbolName,
                        ignoreUnsubList: [detailSymbolName],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: Grid.s + Grid.xxs,
            ),
            Expanded(
              child: PCustomOutlinedButtonWithIcon(
                fillParentWidth: true,
                text: L10n.tr('viop_contracts'),
                textStyle: context.pAppStyle.labelMed14primary,
                iconSource: ImagesPath.arrow_up_right,
                buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                onPressed: () {
                  if (router.routeNames.contains(WarrantRoute.name) || router.routeNames.contains(ViopRoute.name)) {
                    router.popUntilRouteWithName(DashboardRoute.name);
                    // viop page dispose süresi için gerekli.
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        router.push(
                          ViopRoute(
                            underlyingName: underlyingSymbolName,
                            ignoreUnsubList: [detailSymbolName],
                            awaitDisposeTime: true,
                          ),
                        );
                      },
                    );
                  } else {
                    router.push(
                      ViopRoute(
                        underlyingName: underlyingSymbolName,
                        ignoreUnsubList: [detailSymbolName],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
