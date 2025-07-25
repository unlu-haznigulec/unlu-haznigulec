import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_state.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_market_makers_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantMarketMakersList extends StatelessWidget {
  final double? leftPadding;
  final double? rightPadding;
  const WarrantMarketMakersList({
    this.leftPadding,
    this.rightPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<WarrantBloc, WarrantState>(
      bloc: getIt<WarrantBloc>(),
      builder: (context, state) {
        if (state.marketMakerList.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.l,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: leftPadding ?? 0,
                right: rightPadding ?? 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    L10n.tr(
                      'market_makers',
                    ),
                    style: context.pAppStyle.labelMed18textPrimary,
                  ),
                  PCustomPrimaryTextButton(
                    text: L10n.tr(
                      'see_all',
                    ),
                    onPressed: () {
                      router.push(
                        WarrantMarketMakersRoute(
                          marketMakers: state.marketMakerList,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            SizedBox(
              height: 115,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.marketMakerList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  left: leftPadding ?? 0,
                  right: rightPadding ?? 0,
                ),
                itemBuilder: (context, index) {
                  return WarrantMarketMakersTile(
                    marketMaker: state.marketMakerList[index],
                  );
                },
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        );
      },
    );
  }
}
