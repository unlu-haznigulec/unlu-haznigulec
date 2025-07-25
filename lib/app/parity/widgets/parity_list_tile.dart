import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class ParityListTile extends StatelessWidget {
  final SlidableController controller;
  final MarketListModel symbol;
  final Function()? onTap;
  final bool enableSwiping;
  const ParityListTile({
    super.key,
    required this.controller,
    required this.symbol,
    this.onTap,
    this.enableSwiping = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: onTap,
      child: Slidable(
        controller: controller,
        enabled: enableSwiping,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .32,
          children: [
            const Spacer(),
            LayoutBuilder(
              builder: (context, constraints) => SlideOptions(
                height: constraints.maxHeight,
                imagePath: ImagesPath.alarm,
                backgroundColor: context.pColorScheme.card,
                iconColor: context.pColorScheme.primary,
                onTap: () => router.push(
                  CreatePriceNewsAlarmRoute(
                    symbol: SymbolModel.fromMarketListModel(symbol),
                  ),
                ),
              ),
            ),

            /// Anlik olarak gorebilmemiz icin bloc a sarildi
            PBlocBuilder<FavoriteListBloc, FavoriteListState>(
                bloc: getIt<FavoriteListBloc>(),
                builder: (context, state) {
                  bool isFavourite = FavoriteListUtils().isFavorite(symbol.symbolCode, SymbolTypes.parity);
                  return LayoutBuilder(
                    builder: (context, constraints) => SlideOptions(
                      height: constraints.maxHeight,
                      imagePath: isFavourite ? ImagesPath.star_full : ImagesPath.star,
                      backgroundColor: isFavourite ? context.pColorScheme.secondary : context.pColorScheme.primary,
                      iconColor: isFavourite ? context.pColorScheme.primary : context.pColorScheme.stroke,
                      onTap: () async {
                        await FavoriteListUtils().toggleFavorite(
                          context,
                          symbol.symbolCode,
                          SymbolTypes.parity,
                        );
                        controller.close();
                      },
                    ),
                  );
                }),
          ],
        ),
        child: Container(
          color: context.pColorScheme.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
            vertical: Grid.m - Grid.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SymbolIcon(
                      symbolName: symbol.symbolCode,
                      symbolType: SymbolTypes.parity,
                      size: 30,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            symbol.symbolCode,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          Text(
                            symbol.description.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DiffPercentageAutoSize(
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        percentage: symbol.differencePercent,
                        minfontSize: Grid.s + Grid.xxs,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        MoneyUtils().readableMoney(MoneyUtils().getPrice(symbol, null), pattern: '#,##0.0000'),
                        style: context.pAppStyle.labelMed14textPrimary,
                        maxLines: 1,
                        minFontSize: Grid.s + Grid.xxs,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
