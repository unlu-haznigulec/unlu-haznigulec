import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class UsSpecificListDetailPage extends StatefulWidget {
  final SpecificListModel specificListItem;
  const UsSpecificListDetailPage({
    super.key,
    required this.specificListItem,
  });

  @override
  State<UsSpecificListDetailPage> createState() => _UsSpecificListDetailPageState();
}

class _UsSpecificListDetailPageState extends State<UsSpecificListDetailPage> {
  late UsEquityBloc _usEquityBloc;

  @override
  initState() {
    Utils.setListPageEvent(
      pageName: 'UsSpecificListDetailPage',
    );
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.americanStockExchanges.value,
        InsiderEventEnum.analysisTab.value,
      ],
    );

    _usEquityBloc = getIt<UsEquityBloc>();

    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: widget.specificListItem.symbolNames,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _usEquityBloc.add(
      UnsubscribeSymbolEvent(
        symbolName: widget.specificListItem.symbolNames,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const PLoading();
        }
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr(widget.specificListItem.listName),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.specificListItem.description,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs + Grid.s,
                ),
                TableTitleWidget(
                  primaryColumnTitle: '${L10n.tr('equity')} (${widget.specificListItem.symbolNames.length})',
                  secondaryColumnTitle: L10n.tr('gunluk_degisim'),
                  tertiaryColumnTitle: L10n.tr('price'),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.specificListItem.symbolNames.length,
                    separatorBuilder: (context, index) => const PDivider(),
                    itemBuilder: (context, index) {
                      final symbolName = widget.specificListItem.symbolNames[index];
                      final USSymbolModel? watchingItem = state.watchingItems.firstWhereOrNull(
                        (element) => element.symbol == widget.specificListItem.symbolNames[index],
                      );

                      double? differencePercent = watchingItem != null
                          ? ((watchingItem.trade!.price! - watchingItem.previousDailyBar!.close!) /
                                  watchingItem.previousDailyBar!.close!) *
                              100
                          : 0;

                      return watchingItem == null
                          ? const PLoading()
                          : SymbolListTile(
                              symbolName: symbolName,
                              symbolType: SymbolTypes.foreign,
                              leadingText: symbolName,
                              subLeadingText: watchingItem.asset?.name != null ? watchingItem.asset!.name : null,
                              infoText: '%${MoneyUtils().readableMoney(differencePercent)}',
                              profit: differencePercent,
                              trailingText: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                watchingItem.trade?.price ?? 0,
                              )}',
                              onTap: () {
                                router.push(
                                  SymbolUsDetailRoute(
                                    symbolName: symbolName,
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
