import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/add_favorite_icon.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/app/license/bloc/license_event.dart';
import 'package:piapiri_v2/app/symbol_detail/pages/symbol_data_page.dart';
import 'package:piapiri_v2/app/symbol_detail/pages/symbol_financial_page.dart';
import 'package:piapiri_v2/app/symbol_detail/pages/symbol_summary_page.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/buy_sell_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class SymbolDetailPage extends StatefulWidget {
  final MarketListModel symbol;
  final bool ignoreDispose;
  const SymbolDetailPage({
    super.key,
    required this.symbol,
    this.ignoreDispose = false,
  });

  @override
  State<SymbolDetailPage> createState() => _SymbolDetailPageState();
}

class _SymbolDetailPageState extends State<SymbolDetailPage> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final LicenseBloc _licenseBloc = getIt<LicenseBloc>();
  late MarketListModel _symbol;
  bool isLoading = true;
  List<MarketListModel> symbolsToSubscribe = [];
  @override
  initState() {
    _symbol = widget.symbol;

    _symbolBloc.add(
      GetSymbolDetailEvent(
        symbolName: widget.symbol.symbolCode,
        callback: (symbolModel) {
          _symbol = symbolModel;
          SymbolTypes symbolType = stringToSymbolType(_symbol.type);
          symbolsToSubscribe = [_symbol];
          if (symbolType == SymbolTypes.future ||
              symbolType == SymbolTypes.option ||
              symbolType == SymbolTypes.warrant) {
            symbolsToSubscribe.add(
              MarketListModel(
                symbolCode: _symbol.underlying,
                updateDate: '',
              ),
            );
          }
          _symbolBloc.add(
            SymbolSubTopicsEvent(
              symbols: symbolsToSubscribe,
            ),
          );
          isLoading = false;
          setState(() {});
        },
      ),
    );

    if (_licenseBloc.state.licenseList.isEmpty) {
      _licenseBloc.add(
        GetLicensesEvent(),
      );
    }

    getIt<Analytics>().track(
      AnalyticsEvents.productDetailPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.istanbulStockExchangeTab.value,
        InsiderEventEnum.equityTab.value,
      ],
      properties: {
        'product_id': widget.symbol.symbolCode,
        'name': widget.symbol.symbolCode,
        'image_url': '',
        'price': widget.symbol.bid,
        'currency': 'TRY',
      },
    );

    super.initState();
  }

  @override
  dispose() {
    if (!widget.ignoreDispose) {
      _symbolBloc.add(
        SymbolUnsubsubscribeEvent(
          symbolList: symbolsToSubscribe,
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SymbolTypes symbolType = stringToSymbolType(_symbol.type);
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(_symbol.symbolCode),
        actions: !_authBloc.state.isLoggedIn
            ? null
            : [
                Row(
                  children: [
                    /// Sembolu favorilere eklemek icin
                    AddFavoriteIcon(
                      symbolCode: _symbol.symbolCode,
                      symbolType: symbolType,
                    ),
                    const SizedBox(width: Grid.s),

                    /// Sembol alarmi olusturmak icin
                    InkWrapper(
                      child: SvgPicture.asset(
                        ImagesPath.alarm,
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.iconPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      onTap: () => router.push(
                        CreatePriceNewsAlarmRoute(
                          symbol: SymbolModel.fromMarketListModel(_symbol),
                        ),
                      ),
                    ),
                    const SizedBox(width: Grid.s),
                    if ([
                      SymbolTypes.equity,
                      SymbolTypes.warrant,
                      SymbolTypes.indexType,
                    ].contains(symbolType))
                      InkWrapper(
                        child: SvgPicture.asset(
                          ImagesPath.arrows_across,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.iconPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        onTap: () {
                          router.push(
                            SymbolCompareRoute(
                              symbolName: _symbol.symbolCode,
                              underLyingName: _symbol.underlying,
                              description: _symbol.description,
                              symbolType: symbolType,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
      ),
      body: PMainTabController(
        key: UniqueKey(),
        tabs: [
          PTabItem(
            title: L10n.tr('summary'),
            page: SymbolSummary(
              symbol: _symbol,
              type: symbolType,
            ),
          ),
          if (symbolType == SymbolTypes.equity ||
              symbolType == SymbolTypes.warrant ||
              symbolType == SymbolTypes.future ||
              symbolType == SymbolTypes.option)
            PTabItem(
              title: L10n.tr('data'),
              page: SymbolData(
                symbol: _symbol,
              ),
            ),
          if (symbolType == SymbolTypes.equity)
            PTabItem(
              title: L10n.tr('financial'),
              page: SymbolFinancialPage(
                marketListModel: _symbol,
              ),
            ),
        ],
      ),
      bottomNavigationBar: _symbol.symbolType == SymbolTypes.equity.dbKey ||
              _symbol.symbolType == SymbolTypes.warrant.dbKey ||
              _symbol.symbolType == SymbolTypes.future.dbKey ||
              _symbol.symbolType == SymbolTypes.certificate.dbKey ||
              _symbol.symbolType == SymbolTypes.option.dbKey ||
              _symbol.symbolType == SymbolTypes.right.dbKey ||
              _symbol.symbolType == SymbolTypes.etf.dbKey
          ? BuySellButtons(
              onTapBuy: () {
                symbolType == SymbolTypes.future || symbolType == SymbolTypes.option
                    ? router.push(
                        CreateOptionOrderRoute(
                          symbol: _symbol,
                          action: OrderActionTypeEnum.buy,
                        ),
                      )
                    : router.push(
                        CreateOrderRoute(
                          symbol: _symbol,
                          action: OrderActionTypeEnum.buy,
                        ),
                      );
              },
              onTapSell: () {
                symbolType == SymbolTypes.future || symbolType == SymbolTypes.option
                    ? router.push(
                        CreateOptionOrderRoute(
                          symbol: _symbol,
                          action: OrderActionTypeEnum.sell,
                        ),
                      )
                    : router.push(
                        CreateOrderRoute(
                          symbol: _symbol,
                          action: OrderActionTypeEnum.sell,
                        ),
                      );
              },
            )
          : null,
    );
  }
}
