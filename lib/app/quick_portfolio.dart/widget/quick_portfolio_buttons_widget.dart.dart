import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//hazır portfoyler butonlar widgetı
class QuickPortfolioButtonsWidget extends StatelessWidget {
  final List<QuickPortfolioAssetModel> symbols;
  final bool? isSpecificList;
  final Function() buyButtonOnPressed;
  final String portfolioKey;
  const QuickPortfolioButtonsWidget({
    super.key,
    required this.symbols,
    this.isSpecificList = false,
    required this.buyButtonOnPressed,
    required this.portfolioKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!isSpecificList!) ...[
            SizedBox(
              height: 23,
              child: PCustomOutlinedButtonWithIcon(
                text: L10n.tr('satin_al'),
                icon: const Icon(
                  Icons.arrow_outward_rounded,
                  size: Grid.m,
                ),
                foregroundColorApllyBorder: false,
                foregroundColor: context.pColorScheme.lightHigh,
                backgroundColor: context.pColorScheme.primary,
                onPressed: buyButtonOnPressed,
              ),
            ),
            const SizedBox(
              width: Grid.xs,
            ),
          ],
          Expanded(
            child: SizedBox(
              height: Grid.l,
              child: ListView.builder(
                itemCount: symbols.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                    right: Grid.xs,
                  ),
                  child: PCustomOutlinedButtonWithIcon(
                    text: symbols[index].code,
                    textStyle: context.pAppStyle.labelReg14textPrimary,
                    iconAlignment: IconAlignment.start,
                    icon: SymbolIcon(
                      symbolName:
                          portfolioKey == 'fon_sepeti' ? symbols[index].founderCode.toString() : symbols[index].code,
                      symbolType: portfolioKey == 'fon_sepeti'
                          ? SymbolTypes.fund
                          : portfolioKey == 'us_sepet'
                              ? SymbolTypes.foreign
                              : SymbolTypes.equity,
                    ),
                    onPressed: () {
                      if (portfolioKey == 'fon_sepeti') {
                        router.push(
                          FundDetailRoute(
                            fundCode: symbols[index].code,
                          ),
                        );
                      } else if (portfolioKey == 'us_sepet') {
                        router.push(
                          SymbolUsDetailRoute(
                            symbolName: symbols[index].code,
                          ),
                        );
                      } else {
                        MarketListModel symbol = MarketListModel(
                          symbolCode: symbols[index].code,
                          updateDate: '',
                        );
                        router.push(
                          SymbolDetailRoute(symbol: symbol),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
