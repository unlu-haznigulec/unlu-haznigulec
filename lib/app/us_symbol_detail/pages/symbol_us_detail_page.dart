import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/add_favorite_icon.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/pages/symbol_us_summary_page.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/buy_sell_buttons.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class SymbolUsDetailPage extends StatefulWidget {
  final String symbolName;
  const SymbolUsDetailPage({
    super.key,
    required this.symbolName,
  });

  @override
  State<SymbolUsDetailPage> createState() => _SymbolUsDetailPageState();
}

class _SymbolUsDetailPageState extends State<SymbolUsDetailPage> {
  UsMarketStatus _usMarketStatus = UsMarketStatus.closed;

  late UsEquityBloc _usEquityBloc;
  late TimeBloc _timeBloc;
  late UserModel _userModel;
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;
  late CreateUsOrdersBloc _createUsOrdersBloc;
  USSymbolModel? _symbol;
  final ValueNotifier<bool> _symbolIsTradableNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _symbolIsWhiteListNotifier = ValueNotifier<bool>(false);

  @override
  initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _timeBloc = getIt<TimeBloc>();
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _createUsOrdersBloc = getIt<CreateUsOrdersBloc>();
    _userModel = UserModel.instance;

    if (Utils().canTradeAmericanMarket() && _userModel.alpacaAccountStatus) {
      _createUsOrdersBloc.add(
        GetTradeLimitEvent(),
      );
    }

    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: [
          widget.symbolName,
        ],
      ),
    );

    _usEquityBloc.add(
      GetDividendWeeklyEvent(
        symbols: [
          widget.symbolName,
        ],
      ),
    );

    _usEquityBloc.add(
      GetDividendYearlyEvent(
        symbols: [
          widget.symbolName,
        ],
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _usEquityBloc.add(
      UnsubscribeSymbolEvent(symbolName: [widget.symbolName]),
    );
    _symbolIsTradableNotifier.dispose();
    _symbolIsWhiteListNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(widget.symbolName),
        actions: [
          Row(
            children: [
              /// Sembolu favorilere eklemek icin
              AddFavoriteIcon(
                symbolCode: widget.symbolName,
                symbolType: SymbolTypes.foreign,
              ),
              const SizedBox(width: Grid.s),
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
                      symbolName: _symbol?.asset?.symbol ?? '',
                      underLyingName: '',
                      description: _symbol?.asset?.name ?? '',
                      symbolType: SymbolTypes.foreign,
                    ),
                  );
                },
              ),
              // const SizedBox(width: Grid.s),
              // SvgPicture.asset(
              //   ImagesPath.alarm,
              //   height: 24,
              //   width: 24,
              //   colorFilter: const ColorFilter.mode(
              //     PColor.iconPrimary500,
              //     BlendMode.srcIn,
              //   ),
              // ),
            ],
          ),
        ],
      ),
      body: PBlocBuilder<TimeBloc, TimeState>(
        bloc: _timeBloc,
        builder: (context, timeState) {
          _usMarketStatus = getMarketStatus();

          return PBlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: _usEquityBloc,
            builder: (context, state) {
              USSymbolModel? newSymbol = state.watchingItems.firstWhereOrNull(
                (element) => element.symbol == widget.symbolName,
              );

              // bottomNavigationBar ın yeniden çizilmesi için gereklidir.
              if (_symbol?.symbol != newSymbol?.symbol && _symbol?.asset?.isTradable != newSymbol?.asset?.isTradable) {
                // WidgetsBinding Notifierların tetiklenmesi için gerekli
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    _symbolIsTradableNotifier.value = newSymbol?.asset?.isTradable ?? false;
                    _checkSymbolIsWhiteList(newSymbol?.symbol);
                  },
                );
              }

              // Atama işlemi if bloğunun altında olmalıdır.
              _symbol = newSymbol;

              if (_symbol != null) {
                return SymbolUsSummary(
                  symbol: _symbol!,
                  usMarketStatus: _usMarketStatus,
                );
              }

              return const Center(
                child: PLoading(),
              );
            },
          );
        },
      ),
      //1-) Sembol remote configte yoksa 2-) Sembol tradable ise  3-) Kullanıcı dijitalse ve kurumsal hesap değilse
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _symbolIsTradableNotifier,
        builder: (context, symbolIsTradable, child) => Utils().canTradeAmericanMarket() && symbolIsTradable
            ? ValueListenableBuilder<bool>(
                valueListenable: _symbolIsWhiteListNotifier,
                builder: (context, isWhiteList, child) => isWhiteList
                    ? BuySellButtons(
                        onTapBuy: () => _checkCapraAccount(OrderActionTypeEnum.buy),
                        onTapSell: () => _checkCapraAccount(OrderActionTypeEnum.sell),
                      )
                    : const SizedBox.shrink(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  //remote configten alış ve satışa kapalı symbollerin kontrolünü sağlar
  void _checkSymbolIsWhiteList(String? symbolName) {
    if (symbolName != null && symbolName.isNotEmpty) {
      List<dynamic> marketCarouselJson =
          jsonDecode(remoteConfig.getValue('marketCarousel').asString())['MarketCarousel'] as List;
      List<dynamic> disableTradeSymbols =
          jsonDecode(remoteConfig.getValue('disabledTradeSymbols').asString())['disabled_trade_symbols'] as List;
      if (marketCarouselJson.any((e) => e['Code'] == symbolName) &&
          marketCarouselJson.map((e) => e['Code']).any((code) => disableTradeSymbols.contains(code))) {
        _symbolIsWhiteListNotifier.value = false;
      } else {
        _symbolIsWhiteListNotifier.value = true;
      }
    } else {
      _symbolIsWhiteListNotifier.value = false;
    }
  }

  _checkCapraAccount(OrderActionTypeEnum action) {
    AlpacaAccountStatusEnum? alpacaAccountStatus;
    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(
        succesCallback: (accountSettingStatus) {
          setState(() {
            alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
              (e) => e.value == accountSettingStatus.accountStatus,
            );
          });
          if (alpacaAccountStatus != AlpacaAccountStatusEnum.active) {
            PBottomSheet.showError(
              context,
              content: alpacaAccountStatus == null
                  ? L10n.tr('alpaca_account_not_active')
                  : L10n.tr('portfolio.${alpacaAccountStatus!.descriptionKey}'),
              showFilledButton: true,
              showOutlinedButton: true,
              filledButtonText: alpacaAccountStatus == null ? L10n.tr('get_started') : L10n.tr('go_agreements'),
              outlinedButtonText: L10n.tr('afterwards'),
              onOutlinedButtonPressed: () => router.maybePop(),
              onFilledButtonPressed: () async {
                Navigator.of(context).pop();
                router.push(
                  const GlobalAccountOnboardingRoute(),
                );
              },
            );
          } else {
            _routeCreateOrder(action);
          }
        },
      ),
    );

    // if (_createUsOrdersBloc.state.tradeLimit == 0) {
    //   PBottomSheet.showError(
    //     context,
    //     content: L10n.tr('no_us_tradelimit'),
    //     showFilledButton: true,
    //     showOutlinedButton: true,
    //     filledButtonText: L10n.tr('deposit_now'),
    //     outlinedButtonText: L10n.tr('afterwards'),
    //     onOutlinedButtonPressed: () {
    //       Navigator.of(context).pop();
    //       _routeCreateOrder(action);
    //     },
    //     onFilledButtonPressed: () async {
    //       Navigator.of(context).pop();
    //       router.push(const UsBalanceRoute());
    //     },
    //   );
    //   return;
    // }
  }

  _routeCreateOrder(OrderActionTypeEnum action) {
    router.push(
      CreateUsOrderRoute(
        symbol: widget.symbolName,
        action: action,
      ),
    );
  }
}
