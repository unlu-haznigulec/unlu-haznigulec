import 'package:auto_route/auto_route.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/p_symbol_tile.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/warrant_dropdown_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class WarrantMarketMakersPage extends StatelessWidget {
  final List<WarrantDropdownModel> marketMakers;
  const WarrantMarketMakersPage({
    super.key,
    required this.marketMakers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('market_makers'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: marketMakers.length,
            separatorBuilder: (context, index) => const PDivider(),
            itemBuilder: (context, index) => Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 60,
                  child: PSymbolTile(
                    variant: PSymbolVariant.marketMakers,
                    symbolName: marketMakers[index].key,
                    symbolType: SymbolTypes.fund,
                    title: marketMakers[index].name.toString(),
                    trailingWidget: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: Grid.m,
                      color: context.pColorScheme.iconPrimary,
                    ),
                    onTap: () {
                      router.push(
                        WarrantRoute(
                          underlyingName: marketMakers[index].key == 'GRM' ? 'EURUSD' : 'XU030',
                          selectedMarketMaker: marketMakers[index].key,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
