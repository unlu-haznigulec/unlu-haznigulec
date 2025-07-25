import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/search_symbol/page/symbol_position_list.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/pre_after_market_price_info.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsSymbolSearchSelected extends StatefulWidget {
  final String? symbolName;
  final Function(MarketListModel marketListModel)? onTapSymbol;
  final Function(PositionModel positionModel)? onTapPosition;
  final bool showPriceInfo;
  final bool showPositonList;
  final bool searchable;
  final List<SymbolSearchFilterEnum>? filterList;
  final SymbolSearchFilterEnum? selectedFilter;
  final String? selectedUnderlying;
  final UsMarketStatus usMarketStatus;
  final LatestTradeMixedModel? latestTradeMixedModel;
  final String pattern;
  final Function(String)? onSelectedPrice;

  const UsSymbolSearchSelected({
    super.key,
    this.symbolName,
    this.onTapSymbol,
    this.onTapPosition,
    this.showPriceInfo = true,
    this.showPositonList = false,
    this.searchable = true,
    this.filterList,
    this.selectedFilter,
    this.selectedUnderlying,
    required this.usMarketStatus,
    this.latestTradeMixedModel,
    this.pattern = '#,##0.00',
    this.onSelectedPrice,
  });

  @override
  State<UsSymbolSearchSelected> createState() => _UsSymbolSearchSelectedState();
}

class _UsSymbolSearchSelectedState extends State<UsSymbolSearchSelected> {
  String? symbolName;
  USSymbolModel? symbolModel;
  late UsEquityBloc _usEquityBloc;
  late SymbolBloc _symbolBloc;
  List<SymbolSearchFilterEnum> _filterList = [];
  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _symbolBloc = getIt<SymbolBloc>();
    if (widget.symbolName != null) {
      symbolName = widget.symbolName;
    }
    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: [symbolName!],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listenWhen: (previous, current) {
        return symbolName != null &&
            current.watchingItems.map((e) => e.symbol).toList().contains(
                  symbolName!,
                );
      },
      listener: (BuildContext context, UsEquityState state) {
        USSymbolModel? newModel = state.watchingItems.firstWhereOrNull(
          (element) => element.symbol == symbolName!,
        );
        if (newModel == null) return;
        setState(() {
          symbolModel = newModel;
        });
      },
      builder: (context, state) {
        _filterList = widget.filterList ?? SymbolSearchFilterEnum.values;
        return Column(
          children: [
            InkWell(
              highlightColor: context.pColorScheme.transparent,
              splashColor: context.pColorScheme.transparent,
              onTap: !widget.searchable
                  ? null
                  : () {
                      if (widget.showPositonList) {
                        PBottomSheet.show(
                          context,
                          title: L10n.tr('position_list'),
                          child: SymbolPositionList(
                            onTapPosition: widget.onTapPosition,
                          ),
                        );
                      } else {
                        _routeSearchPage();
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.only(bottom: Grid.s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (symbolName != null) ...[
                      SymbolIcon(
                        size: 28,
                        symbolName: widget.symbolName ?? '',
                        symbolType: SymbolTypes.foreign,
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                            child: Text(
                              widget.symbolName ?? '',
                              style: context.pAppStyle.labelReg14textPrimary,
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          SizedBox(
                            height: 14,
                            width: MediaQuery.sizeOf(context).width * 0.72,
                            child: Text(
                              symbolModel?.asset?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      Text(
                        L10n.tr('sembol_arama'),
                        style: context.pAppStyle.labelReg14textSecondary,
                      ),
                    const Spacer(),
                    if (widget.searchable)
                      SvgPicture.asset(
                        ImagesPath.search,
                        width: 24,
                        height: 24,
                      ),
                  ],
                ),
              ),
            ),
            PDivider(
              color: context.pColorScheme.line,
              tickness: 1,
            ),
            _bottomInforTile(),
          ],
        );
      },
    );
  }

  _bottomInforTile() {
    if (symbolName != null && widget.showPriceInfo) {
      double? differencePercent = (((symbolModel?.trade?.price ?? 0) - (symbolModel?.previousDailyBar?.close ?? 0)) /
              (symbolModel?.previousDailyBar?.close ?? 1)) *
          100;
      double? preAfterDifferencePercent =
          widget.latestTradeMixedModel?.price != null && symbolModel?.previousDailyBar?.close != null
              ? (((widget.latestTradeMixedModel?.price ?? 0) - (symbolModel?.previousDailyBar?.close ?? 0)) /
                      (symbolModel?.previousDailyBar?.close ?? 1)) *
                  100
              : null;
      return InkWell(
        onTap: () => widget.onSelectedPrice?.call(
          widget.latestTradeMixedModel?.price != null
              ? MoneyUtils().readableMoney(
                  widget.latestTradeMixedModel?.price ?? 0,
                  pattern: widget.pattern,
                )
              : MoneyUtils().readableMoney(
                  symbolModel?.trade?.price ?? 0,
                  pattern: widget.pattern,
                ),
        ),
        child: UsMarketPriceInfo(
          usMarketStatus: widget.usMarketStatus,
          price: MoneyUtils().readableMoney(
            symbolModel?.trade?.price ?? 0,
            pattern: widget.pattern,
          ),
          percentage: differencePercent,
          preAfterPrice: widget.latestTradeMixedModel?.price != null
              ? MoneyUtils().readableMoney(
                  widget.latestTradeMixedModel?.price ?? 0,
                  pattern: widget.pattern,
                )
              : null,
          preAfterPercentage: preAfterDifferencePercent,
        ),
      );
    }
  }

  void _routeSearchPage() {
    router.push(
      SymbolSearchRoute(
        filterList: _filterList,
        selectedFilter: widget.selectedFilter ?? SymbolSearchFilterEnum.all,
        selectedUnderlying: widget.selectedUnderlying,
        onTapSymbol: (symbolModelList) {
          setState(() {
            symbolName = symbolModelList.first.name;
          });
          if (symbolName == null) return;
          SymbolTypes symbolType = stringToSymbolType(symbolModelList.first.typeCode);

          if (symbolType == SymbolTypes.fund) {
            widget.onTapSymbol?.call(
              MarketListModel(
                symbolCode: symbolModelList.first.name,
                type: symbolModelList.first.typeCode,
                updateDate: '',
              ),
            );
          } else if (symbolType == SymbolTypes.foreign) {
            _usEquityBloc.add(
              SubscribeSymbolEvent(
                symbolName: [symbolModelList.first.name],
              ),
            );
            widget.onTapSymbol?.call(
              MarketListModel(
                symbolCode: symbolModelList.first.name,
                type: symbolModelList.first.typeCode,
                updateDate: '',
              ),
            );
          } else {
            _symbolBloc.add(
              SymbolSubOneTopicEvent(
                symbol: symbolModelList.first.name,
                callback: (MarketListModel marketListModel) => widget.onTapSymbol?.call(marketListModel),
              ),
            );
          }
          router.maybePop();
        },
      ),
    );
  }
}
