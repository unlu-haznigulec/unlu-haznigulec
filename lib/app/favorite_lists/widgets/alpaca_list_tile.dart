import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_grid_box.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/sorting_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class AlpacaListTile extends StatefulWidget {
  final SlidableController controller;
  final FavoriteListItem favoriteListItem;
  final bool showHeatMap;

  const AlpacaListTile({
    super.key,
    required this.controller,
    required this.favoriteListItem,
    required this.showHeatMap,
  });

  @override
  State<AlpacaListTile> createState() => _MatriksListTileState();
}

class _MatriksListTileState extends State<AlpacaListTile> {
  late UsEquityBloc _usEquityBloc;
  late FavoriteListBloc _favoriteListBloc;
  late USSymbolModel _usSymbolModel;

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _usSymbolModel = _usEquityBloc.state.watchingItems
            .firstWhereOrNull((element) => element.symbol == widget.favoriteListItem.symbol) ??
        USSymbolModel(
          symbol: widget.favoriteListItem.symbol,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listenWhen: (previous, current) {
        USSymbolModel? currenctSymbolModel =
            current.watchingItems.firstWhereOrNull((element) => element.symbol == widget.favoriteListItem.symbol);
        USSymbolModel? previousSymbolModel =
            previous.watchingItems.firstWhereOrNull((element) => element.symbol == widget.favoriteListItem.symbol);
        return currenctSymbolModel != null && currenctSymbolModel != previousSymbolModel;
      },
      listener: (context, state) {
        setState(() {
          _usSymbolModel =
              state.watchingItems.firstWhere((element) => element.symbol == widget.favoriteListItem.symbol);
        });
      },
      builder: (context, state) {
        /// Heatmap gösterilmesi isteniyorsa
        if (widget.showHeatMap) {
          return FavoriteGridBox(
            key: ValueKey(widget.favoriteListItem.symbol),
            symbolName: widget.favoriteListItem.symbol,
            symbolIconName: widget.favoriteListItem.symbol,
            symbolTypes: widget.favoriteListItem.symbolType,
            price: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_usSymbolModel.trade?.price ?? 0)}',
            diffPercentage: (((_usSymbolModel.trade?.price ?? 0) - (_usSymbolModel.previousDailyBar?.close ?? 0)) /
                    (_usSymbolModel.previousDailyBar?.close ?? 1)) *
                100,
            updateDate: _usSymbolModel.trade?.update ?? '-',
            onTapGrid: () => router.push(SymbolUsDetailRoute(symbolName: widget.favoriteListItem.symbol)),
          );
        }

        /// Heatmap gösterilmeyecekse
        return InkWell(
          onTap: () => router.push(
            SymbolUsDetailRoute(
              symbolName: widget.favoriteListItem.symbol,
            ),
          ),
          child: Slidable(
            controller: widget.controller,
            enabled: true,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: .16,
              children: [
                const Spacer(),
                LayoutBuilder(
                  builder: (context, constraints) => SlideOptions(
                    height: constraints.maxHeight,
                    imagePath: ImagesPath.trash,
                    backgroundColor: context.pColorScheme.critical,
                    iconColor: context.pColorScheme.lightHigh,
                    onTap: () {
                      _favoriteListBloc.add(
                        UpdateListEvent(
                          name: _favoriteListBloc.state.selectedList?.name ?? '',
                          favoriteListItems: _favoriteListBloc.state.selectedList?.favoriteListItems
                                  .where(
                                    (element) => element.symbol != widget.favoriteListItem.symbol,
                                  )
                                  .toList() ??
                              [],
                          id: _favoriteListBloc.state.selectedList?.id ?? 0,
                          sortingEnum: _favoriteListBloc.state.selectedList?.sortingEnum ?? SortingEnum.alphabetic,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
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
                          symbolName: widget.favoriteListItem.symbol,
                          symbolType: widget.favoriteListItem.symbolType,
                          size: 28,
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
                                widget.favoriteListItem.symbol,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                              Text(
                                _usSymbolModel.asset?.name ?? '',
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
                            percentage:
                                (((_usSymbolModel.trade?.price ?? 0) - (_usSymbolModel.previousDailyBar?.close ?? 0)) /
                                        (_usSymbolModel.previousDailyBar?.close ?? 1)) *
                                    100,
                            minfontSize: Grid.s + Grid.xxs,
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_usSymbolModel.trade?.price ?? 0)}',
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
      },
    );
  }
}
