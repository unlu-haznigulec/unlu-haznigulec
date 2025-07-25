import 'package:auto_route/auto_route.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_event.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_state.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_filter.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_list_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/delayed_info_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/risk_level_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class WarrantPage extends StatefulWidget {
  final bool showSymbolIcon;
  final String? underlyingName;
  final String? selectedMarketMaker;
  final List<String> ignoreUnsubList;

  const WarrantPage({
    super.key,
    this.showSymbolIcon = true,
    this.underlyingName,
    this.selectedMarketMaker,
    this.ignoreUnsubList = const [],
  });

  @override
  State<WarrantPage> createState() => _WarrantPageState();
}

class _WarrantPageState extends State<WarrantPage> {
  bool showList = true;
  bool showAdd = false;
  final WarrantBloc _warrantBloc = getIt<WarrantBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  late final String _listUniqKey;

  @override
  void initState() {
    Utils.setListPageEvent(pageName: 'WarrantPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.istanbulStockExchangeTab.value,
        InsiderEventEnum.warrantTab.value,
      ],
    );

    _warrantBloc.add(
      InitEvent(
        underlyingAsset: widget.underlyingName,
        selectedMarketMaker: widget.selectedMarketMaker,
      ),
    );

    _listUniqKey = DateTime.now().microsecondsSinceEpoch.toString();
    super.initState();
  }

  @override
  dispose() {
    _warrantBloc.add(
      OnRemoveSelectedEvent(
        removeMaturity: true,
        removeRisk: true,
        removeType: true,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('warrant.all'),
        actions: [
          PIconButton(
            type: PIconButtonType.outlined,
            svgPath: ImagesPath.search,
            sizeType: PIconButtonSize.xl,
            onPressed: () => SymbolSearchUtils.goSymbolDetail(),
          ),
        ],
      ),
      body: PBlocBuilder<WarrantBloc, WarrantState>(
        bloc: _warrantBloc,
        buildWhen: (previous, current) => previous.symbolList != current.symbolList,
        builder: (context, state) {
          if (state.isLoading) return const PLoading();
          return SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_authBloc.state.isLoggedIn)
                  DelayedInfoWidget(
                    delayedSymbols: [SymbolTypes.warrant.matriks],
                    activeIndex: 2,
                    marketMenu: MarketMenu.istanbulStockExchange,
                    marketIndex: 1,
                  ),
                const SizedBox(
                  height: Grid.m,
                ),
                const WarrantFilter(),
                const SizedBox(
                  height: Grid.m,
                ),
                SlidableAutoCloseBehavior(
                  child: Expanded(
                    child: BistSymbolListing(
                      key: ValueKey(
                        'WarrantListing_${_listUniqKey}_${state.symbolList.map((e) => e.symbolCode).join('_')}',
                      ),
                      symbols: state.symbolList,
                      underlyingName: state.selectedUnderlyingAsset,
                      ignoreUnsubList: widget.ignoreUnsubList,
                      emptyListKey: 'warrant_empty_list',
                      columns: [
                        L10n.tr('warrant_and_risk'),
                        L10n.tr('last_change_maturity'),
                      ],
                      outPadding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      columnIcon: InkWell(
                        splashColor: context.pColorScheme.transparent,
                        highlightColor: context.pColorScheme.transparent,
                        child: SvgPicture.asset(
                          ImagesPath.info,
                          height: 12,
                          width: 12,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.textSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        onTap: () {
                          PBottomSheet.show(
                            context,
                            title: L10n.tr('warrant_risk_groups'),
                            child: ListView.separated(
                              itemCount: RiskLevelEnum.values.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final riskLevel = RiskLevelEnum.values[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xs),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              color: riskLevel.color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: Grid.s,
                                          ),
                                          Text(
                                            L10n.tr(riskLevel.text),
                                            style: context.pAppStyle.labelReg16textPrimary,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: Grid.m),
                                        child: Text(
                                          L10n.tr(riskLevel.desc),
                                          style: context.pAppStyle.labelReg12textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const PDivider(),
                            ),
                          );
                        },
                      ),
                      itemBuilder: (symbol, controller) => WarrantListTile(
                        key: ValueKey(
                          'Warrant_${_listUniqKey}_${symbol.marketCode}',
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        controller: controller,
                        symbol: symbol,
                        showSymbolIcon: widget.showSymbolIcon,
                        onTap: () => router.push(
                          SymbolDetailRoute(
                            symbol: symbol,
                            ignoreDispose: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
