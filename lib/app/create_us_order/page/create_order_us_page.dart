import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/components/switch_tile/switch_tile.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_state.dart';
import 'package:piapiri_v2/app/create_us_order/create_us_orders_utils.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/order_confirmation_bottomsheet.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/us_inputs.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/us_symbol_search_selected.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/cashflow_transaction_widget.dart';
import 'package:piapiri_v2/common/widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/insufficient_limit_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/text_button_selector.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class CreateUsOrderPage extends StatefulWidget {
  final String? symbol;
  final OrderActionTypeEnum? action;
  const CreateUsOrderPage({
    super.key,
    this.symbol,
    this.action,
  });

  @override
  State<CreateUsOrderPage> createState() => _CreateUsOrderPageState();
}

class _CreateUsOrderPageState extends State<CreateUsOrderPage> {
  USSymbolModel? _symbol;
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  final CreateUsOrdersBloc _createUsOrdersBloc = getIt<CreateUsOrdersBloc>();
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  bool _didPriceGet = false;
  final TextEditingController _amountController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _unitController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _priceController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _stopPriceController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final ScrollController _scrollController = ScrollController();
  List<AmericanOrderTypeEnum> _orderTypeList = [];
  double _comission = 0;
  double _estimatedAmount = 0;
  OrderActionTypeEnum _action = OrderActionTypeEnum.buy;
  late AmericanOrderTypeEnum _orderType;
  num? _sellableUnit;
  bool _isQuantitative = true;
  String _pattern = '#,##0.00';
  bool _fractionable = false;
  bool _extendedHours = false;
  UsMarketStatus _usMarketStatus = UsMarketStatus.closed;

  LatestTradeMixedModel? _latestTradeMixedModel;
  bool _isMarket = true;
  bool _isStop = false;

  @override
  initState() {
    _orderTypeList = AmericanOrderTypeEnum.values
        .where((e) => e.actionList.contains(_action) && e != AmericanOrderTypeEnum.trailStop)
        .toList();
    _orderType = _appSettingsBloc.state.orderSettings.usDefaultOrderType;
    if (widget.action != null) {
      _action = widget.action!;
    }
    _symbol = USSymbolModel(symbol: widget.symbol!);
    _usMarketStatus = getMarketStatus();
    if (_usMarketStatus == UsMarketStatus.preMarket || _usMarketStatus == UsMarketStatus.afterMarket) {
      _usEquityBloc.add(
        GetLatestTradeMixedEvent(
          symbols: widget.symbol ?? '',
          callback: (latestTradeMixedModel) {
            setState(() {
              _latestTradeMixedModel = latestTradeMixedModel;
            });
          },
        ),
      );
    }
    if (_symbol != null) {
      _usEquityBloc.add(
        SubscribeSymbolEvent(
          symbolName: [widget.symbol!],
        ),
      );
      _getLimit();
      _getBalance();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('buy_sell'),
        actions: [
          /// Emir iletim ayarlarina yonelndirir
          InkWrapper(
            child: SvgPicture.asset(
              ImagesPath.preference,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.iconPrimary,
                BlendMode.srcIn,
              ),
            ),
            onTap: () async {
              ///guncel emir iletim ayarlarini cektikten sonra sayafdaki degerleri gunceller
              await router.push(const UsSettingsRoute());
              if (_orderTypeList.contains(_appSettingsBloc.state.orderSettings.usDefaultOrderType)) {
                _orderType = _appSettingsBloc.state.orderSettings.usDefaultOrderType;
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: PBlocBuilder<CreateUsOrdersBloc, CreateUsOrdersState>(
        bloc: _createUsOrdersBloc,
        builder: (context, ordersState) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        Grid.m,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          UsSymbolSearchSelected(
                            key: ValueKey('SELECTED_SYMBOL_${_symbol?.asset?.symbol}'),
                            filterList: [
                              ...SymbolSearchFilterEnum.values.where(
                                (element) => ![
                                  SymbolSearchFilterEnum.crypto,
                                  SymbolSearchFilterEnum.parity,
                                  SymbolSearchFilterEnum.endeks,
                                  SymbolSearchFilterEnum.etf,
                                ].contains(element),
                              ),
                            ],
                            symbolName: _symbol!.symbol,
                            showPositonList: _action != OrderActionTypeEnum.buy,
                            usMarketStatus: _usMarketStatus,
                            latestTradeMixedModel: _latestTradeMixedModel,
                            pattern: _pattern,
                            onTapSymbol: (marketListModel) {
                              SymbolSearchUtils.goCreateSymbol(
                                  marketListModel, _action, SymbolTypes.foreign, CreateUsOrderRoute.name);
                              _symbol = USSymbolModel(symbol: marketListModel.symbolCode);
                              _didPriceGet = false;
                              List<PositionModel> positionList = _symbolSearchBloc.state.positionList;
                              PositionModel? positionModel = positionList.firstWhereOrNull(
                                (element) => element.symbolName == _symbol!.asset?.symbol,
                              );
                              if (positionModel != null) {
                                _sellableUnit = positionModel.qty.toInt();
                              } else {
                                _sellableUnit = 0;
                              }
                              setState(() {});
                            },
                            onTapPosition: (positionModel) {
                              MarketListModel marketListModel = MarketListModel(
                                symbolCode: positionModel.symbolName,
                                description: positionModel.description,
                                underlying: positionModel.underlyingName,
                                type: positionModel.symbolType.dbKey,
                                updateDate: '',
                              );
                              SymbolSearchUtils.goCreateSymbol(
                                  marketListModel, _action, SymbolTypes.foreign, CreateUsOrderRoute.name);
                              _symbol = USSymbolModel(symbol: marketListModel.symbolCode);
                              _didPriceGet = false;
                              _sellableUnit = positionModel.qty;

                              setState(() {});
                            },
                            onSelectedPrice: (price) => setState(() {
                              _priceController.text = price;
                              _stopPriceController.text = price;
                              if (_isQuantitative) {
                                _estimatedAmount = MoneyUtils().fromReadableMoney(_priceController.text) *
                                    MoneyUtils()
                                        .fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text);
                                _amountController.text = MoneyUtils().readableMoney(
                                  _estimatedAmount,
                                );
                              } else {
                                num buyableUnit = _getBuyableUnit(_estimatedAmount, _fractionable);
                                _unitController.text = MoneyUtils().readableMoney(buyableUnit,
                                    pattern: CreateOrdersUtils().getUnitPattern(_fractionable, buyableUnit));
                              }
                            }),
                          ),
                          const SizedBox(
                            height: Grid.l,
                          ),
                          PBlocConsumer<UsEquityBloc, UsEquityState>(
                            bloc: _usEquityBloc,
                            listenWhen: (previous, current) {
                              return _symbol != null &&
                                  !_didPriceGet &&
                                  current.watchingItems.map((e) => e.symbol).toList().contains(
                                        _symbol!.symbol,
                                      );
                            },
                            listener: (BuildContext context, UsEquityState state) {
                              USSymbolModel? newModel =
                                  state.watchingItems.firstWhereOrNull((element) => element.symbol == _symbol!.symbol);
                              if (newModel == null) return;
                              setState(() {
                                _symbol = newModel;
                                setOrderTyeList();
                                _fractionable = (_symbol?.asset?.fractionable ?? false) &&
                                    (_orderType == AmericanOrderTypeEnum.market ||
                                        _orderType == AmericanOrderTypeEnum.limit);

                                if (!_didPriceGet) {
                                  _pattern = '#,##0.${'0' * (_symbol!.quote?.decimalCount ?? 2)}';
                                  _setTextFields();
                                  _didPriceGet = true;
                                }
                              });
                            },
                            builder: (context, symbolState) {
                              _isMarket = _orderType == AmericanOrderTypeEnum.market ||
                                  _orderType == AmericanOrderTypeEnum.stop;
                              _isStop = _orderType == AmericanOrderTypeEnum.stop ||
                                  _orderType == AmericanOrderTypeEnum.stopLimit;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width - Grid.m * 2,
                                    child: SlidingSegment(
                                      initialSelectedSegment: _action == OrderActionTypeEnum.buy ? 0 : 1,
                                      backgroundColor: context.pColorScheme.card,
                                      selectedTextColor: context.pColorScheme.lightHigh,
                                      unSelectedTextColor: context.pColorScheme.textSecondary,
                                      segmentList: OrderActionTypeEnum.values
                                          .where((e) => e != OrderActionTypeEnum.shortSell)
                                          .map((e) => PSlidingSegmentItem(
                                                segmentTitle: StringUtils.capitalize(L10n.tr(e.localizationKey1)),
                                                segmentColor: e.color,
                                              ))
                                          .toList(),
                                      onValueChanged: (index) {
                                        if (index == 0) {
                                          _action = OrderActionTypeEnum.buy;
                                        }
                                        if (index == 1) {
                                          _action = OrderActionTypeEnum.sell;
                                        }
                                        if (_action == OrderActionTypeEnum.sell &&
                                            !_orderType.actionList.contains(_action)) {
                                          _orderType = AmericanOrderTypeEnum.market;
                                        }
                                        setOrderTyeList();
                                        _unitController.text = MoneyUtils().readableMoney(0,
                                            pattern: CreateOrdersUtils().getUnitPattern(_fractionable, 0));
                                        _amountController.text = MoneyUtils().readableMoney(0);
                                        _estimatedAmount = 0;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Grid.l,
                                  ),
                                  Row(
                                    children: [
                                      TextButtonSelector(
                                        selectedItem: L10n.tr(_orderType.localizationKey),
                                        selectedTextStyle: context.pAppStyle.labelMed14primary,
                                        onSelect: () {
                                          PBottomSheet.show(
                                            context,
                                            titlePadding: const EdgeInsets.only(
                                              top: Grid.m,
                                            ),
                                            title: L10n.tr('emir_tipi'),
                                            child: ListView.separated(
                                              itemCount: _orderTypeList.length,
                                              shrinkWrap: true,
                                              separatorBuilder: (context, index) => const PDivider(),
                                              itemBuilder: (context, index) {
                                                return BottomsheetSelectTile(
                                                  title: L10n.tr(_orderTypeList[index].localizationKey),
                                                  subTitle: L10n.tr(_orderTypeList[index].descLocalizationKey),
                                                  isSelected: _orderType == _orderTypeList[index],
                                                  value: _orderTypeList[index],
                                                  onTap: (_, value) {
                                                    _orderType = value;

                                                    if (_orderType == AmericanOrderTypeEnum.market ||
                                                        _orderType == AmericanOrderTypeEnum.stop) {
                                                      _isQuantitative = false;
                                                    }

                                                    _isStop = _orderType == AmericanOrderTypeEnum.stop ||
                                                        _orderType == AmericanOrderTypeEnum.stopLimit;
                                                    _isMarket = _orderType == AmericanOrderTypeEnum.market ||
                                                        _orderType == AmericanOrderTypeEnum.stop;

                                                    _fractionable = (_symbol?.asset?.fractionable ?? false) &&
                                                        (_orderType == AmericanOrderTypeEnum.market ||
                                                            _orderType == AmericanOrderTypeEnum.limit);

                                                    _unitController.text = '0';
                                                    _amountController.text = MoneyUtils().readableMoney(0);
                                                    _estimatedAmount = 0;
                                                    _priceController.text = MoneyUtils().readableMoney(0);
                                                    _stopPriceController.text = MoneyUtils().readableMoney(0);
                                                    setState(() {});
                                                    router.maybePop();
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${L10n.tr('validity_period')}: ',
                                        style: context.pAppStyle.labelReg14textPrimary,
                                      ),
                                      Text(
                                        L10n.tr('daily'),
                                        style: context.pAppStyle.labelMed14textPrimary,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Grid.s,
                                  ),
                                  UsInputs(
                                    action: _action,
                                    orderType: _orderType,
                                    scrollController: _scrollController,
                                    tradeLimit: ordersState.tradeLimit,
                                    sellableUnit: _sellableUnit,
                                    buyableUnit: _getBuyableUnit(
                                      ordersState.tradeLimit - ordersState.minCommission,
                                      _fractionable,
                                    ),
                                    isQuantitative: _isQuantitative,
                                    fractionable: _fractionable,
                                    stopPriceController: _stopPriceController,
                                    priceController: _priceController,
                                    unitController: _unitController,
                                    amountController: _amountController,
                                    pattern: _pattern,
                                    onSegmentChanged: (isQuantitative) {
                                      setState(() {
                                        _isQuantitative = isQuantitative;
                                      });
                                    },
                                    onStopPriceChanged: (price) {
                                      setState(() {});
                                    },
                                    onPriceChanged: (price) {
                                      if (_isQuantitative) {
                                        double unit = MoneyUtils().fromReadableMoney(_unitController.text);
                                        _estimatedAmount = unit * price;
                                        _amountController.text = MoneyUtils().readableMoney(
                                          _estimatedAmount,
                                        );
                                      } else {
                                        double rawUnit = (_estimatedAmount / price);
                                        int unitDecimal = getUnitDecimal(rawUnit);
                                        _unitController.text = _fractionable
                                            ? MoneyUtils().readableMoney((rawUnit * unitDecimal).floor() / unitDecimal,
                                                pattern: CreateOrdersUtils().getUnitPattern(
                                                    _fractionable, (rawUnit * unitDecimal).floor() / unitDecimal))
                                            : MoneyUtils().readableMoney(rawUnit.floor(),
                                                pattern:
                                                    CreateOrdersUtils().getUnitPattern(_fractionable, rawUnit.floor()));
                                      }
                                      setState(() {});
                                    },
                                    onUnitChanged: (unit) {
                                      _comission = CreateOrdersUtils().calculateCommission(unit.toDouble());
                                      double price = _isMarket
                                          ? _symbol!.trade!.price!
                                          : MoneyUtils().fromReadableMoney(_priceController.text);
                                      _estimatedAmount = price * unit;
                                      _amountController.text = MoneyUtils().readableMoney(
                                        _estimatedAmount,
                                      );
                                      setState(() {});
                                    },
                                    onAmountChanged: (amount) {
                                      double price = _isMarket
                                          ? _symbol!.trade!.price!
                                          : MoneyUtils().fromReadableMoney(_priceController.text);
                                      double rawUnit = (amount / price);
                                      int unitDecimal = getUnitDecimal(rawUnit);
                                      _unitController.text = _fractionable
                                          ? MoneyUtils().readableMoney((rawUnit * unitDecimal).floor() / unitDecimal,
                                              pattern: CreateOrdersUtils().getUnitPattern(
                                                  _fractionable, (rawUnit * unitDecimal).floor() / unitDecimal))
                                          : MoneyUtils().readableMoney(rawUnit.floor(),
                                              pattern:
                                                  CreateOrdersUtils().getUnitPattern(_fractionable, rawUnit.floor()));
                                      _comission = CreateOrdersUtils().calculateCommission(rawUnit);
                                      _estimatedAmount = MoneyUtils().fromReadableMoney(_unitController.text) * price;
                                      _amountController.text = MoneyUtils().readableMoney(_estimatedAmount);
                                      setState(() {});
                                    },
                                  ),

                                  const SizedBox(
                                    height: Grid.l,
                                  ),

                                  /// Tutar gosterilen alan yetersiz limitte hata verir
                                  ConsistentEquivalence(
                                    title: _isQuantitative
                                        ? L10n.tr('estimated_amount')
                                        : L10n.tr('estimated_number_shares'),
                                    titleValue: _isQuantitative
                                        ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_estimatedAmount)}'
                                        : _unitController.text,
                                    subTitle: !_isQuantitative
                                        ? _action == OrderActionTypeEnum.sell
                                            ? '${L10n.tr('satilabilir_adet')}:'
                                            : '${L10n.tr('alinabilir_adet')}:~'
                                        : null,
                                    subTitleValue: _action == OrderActionTypeEnum.sell
                                        ? MoneyUtils().readableMoney(_sellableUnit ?? 0,
                                            pattern: MoneyUtils().getPatternByUnitDecimal(_sellableUnit ?? 0))
                                        : '${_getBuyableUnit(
                                            ordersState.tradeLimit - ordersState.minCommission,
                                            _fractionable,
                                          )}',
                                    onTapSubtitle: (value) {
                                      _unitController.text = MoneyUtils().readableMoney(
                                        value,
                                        pattern: MoneyUtils().getPatternByUnitDecimal(value),
                                      );
                                      _comission = CreateOrdersUtils().calculateCommission(value.toDouble());
                                      double price = _isMarket
                                          ? _symbol!.trade!.price!
                                          : MoneyUtils().fromReadableMoney(_priceController.text);
                                      _estimatedAmount = price * value;
                                      _amountController.text = MoneyUtils().readableMoney(
                                        _estimatedAmount,
                                      );
                                      setState(() {});
                                    },
                                    errorMessage: getConsistentEquivalenceError(ordersState.tradeLimit),
                                  ),
                                  if (_estimatedAmount != 0 &&
                                      _estimatedAmount + _comission > ordersState.tradeLimit &&
                                      _action == OrderActionTypeEnum.buy) ...[
                                    const SizedBox(
                                      height: Grid.s,
                                    ),
                                    InsufficientLimitWidget(
                                      text: L10n.tr('deposit_usd_continue'),
                                      onTap: () {
                                        router.push(const UsBalanceRoute());
                                      },
                                    ),
                                  ],
                                  const SizedBox(
                                    height: Grid.m,
                                  ),
                                  CashflowTransactionWidget(
                                    isUs: true,
                                    limitText: L10n.tr('american_stock_exchanges_collateral'),
                                    limitValue: ordersState.tradeLimit,
                                  ),
                                  const SizedBox(
                                    height: Grid.m,
                                  ),
                                  if (_orderType == AmericanOrderTypeEnum.limit &&
                                      _usMarketStatus != UsMarketStatus.open) ...[
                                    const SizedBox(
                                      height: Grid.m,
                                    ),
                                    PSwitchRow(
                                      text: L10n.tr('extended_hours_desc'),
                                      textStyle: context.pAppStyle.labelReg14textPrimary,
                                      value: _extendedHours,
                                      onChanged: (value) {
                                        setState(() {
                                          _extendedHours = value;
                                        });
                                      },
                                    ),
                                  ],
                                  const SizedBox(
                                    height: Grid.l,
                                  ),
                                  if (_fractionable) ...[
                                    PInfoWidget(
                                      infoText: L10n.tr('fractionable_order_info'),
                                      textColor: context.pColorScheme.textPrimary,
                                    ),
                                    const SizedBox(
                                      height: Grid.s + Grid.xs,
                                    ),
                                  ],
                                  if (_usMarketStatus == UsMarketStatus.closed) ...[
                                    PInfoWidget(
                                      infoText: L10n.tr('us_close_market_info'),
                                      textColor: context.pColorScheme.textPrimary,
                                    ),
                                    const SizedBox(
                                      height: Grid.xxl + Grid.m,
                                    ),
                                  ] else if ((_usMarketStatus == UsMarketStatus.preMarket ||
                                          _usMarketStatus == UsMarketStatus.afterMarket) &&
                                      _orderType != AmericanOrderTypeEnum.limit) ...[
                                    PInfoWidget(
                                      infoText: L10n.tr('us_close_market_info2'),
                                      textColor: context.pColorScheme.textPrimary,
                                    ),
                                    const SizedBox(
                                      height: Grid.xxl + Grid.m,
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          KeyboardUtils.customViewInsetsBottom(),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ordersState.isLoading,
                  child: const PLoading(
                    isFullScreen: true,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: ordersState.isLoading
                ? const SizedBox.shrink()
                : generalButtonPadding(
                    context: context,
                    child: PButton(
                      fillParentWidth: true,
                      text: '${_symbol?.symbol} ${L10n.tr(_action.localizationKey1)}',
                      onPressed: _getButtonDisability(ordersState.tradeLimit, _fractionable)
                          ? null
                          : () => _orderApproveSheet(),
                      variant: _action == OrderActionTypeEnum.buy
                          ? PButtonVariant.success
                          : _action == OrderActionTypeEnum.sell
                              ? PButtonVariant.error
                              : PButtonVariant.brand,
                    ),
                  ),
          );
        },
      ),
    );
  }

  String? getConsistentEquivalenceError(double tradeLimit) {
    if (_action == OrderActionTypeEnum.buy && _estimatedAmount != 0 && _estimatedAmount + _comission > tradeLimit) {
      return L10n.tr('insufficiant_trade_limit',
          args: ['${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_estimatedAmount + _comission)}']);
    }
    if (_action == OrderActionTypeEnum.sell &&
        _sellableUnit != null &&
        MoneyUtils().fromReadableMoney(_unitController.text) > _sellableUnit! &&
        !_isQuantitative) {
      return L10n.tr('insufficient_transaction_unit');
    }
    return null;
  }

  void _orderApproveSheet() {
    if (_estimatedAmount < 1) {
      PBottomSheet.showError(
        context,
        content: L10n.tr('us_order_min_one_dollar_error'),
      );
      return;
    }
    double unit = MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text);
    double comission = CreateOrdersUtils().calculateCommission(unit);

    // İşlem Onay İsteği Kontrolü
    if (_appSettingsBloc.state.orderSettings.transactionApprovalRequest) {
      PBottomSheet.show(
        context,
        title: L10n.tr('order_confirmation'),
        titlePadding: const EdgeInsets.only(
          top: Grid.m,
        ),
        child: OrderConfirmationBottomsheet(
          symbolName: _symbol!.symbol!,
          unit: _unitController.text,
          amount: MoneyUtils().readableMoney(_estimatedAmount),
          price: _priceController.text,
          stopPrice: _stopPriceController.text,
          action: _action,
          orderType: _orderType,
          usMarketStatus: _usMarketStatus,
          showQuantity: _isQuantitative,
          pattern: _pattern,
          commission: comission,
          onPressedApprove: () {
            _createOrder(comission);
          },
        ),
      );

      return;
    } else {
      _createOrder(comission);
    }
  }

  bool _getButtonDisability(double tradeLimit, bool fractionable) {
    num qty = MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text);

    if (_symbol == null) return true;

    if (!_isQuantitative &&
        MoneyUtils().fromReadableMoney(_amountController.text.isEmpty ? '0' : _amountController.text) == 0) return true;
    if (_isQuantitative && qty == 0) return true;
    if (_isStop &&
        (_stopPriceController.text.isEmpty || MoneyUtils().fromReadableMoney(_stopPriceController.text) == 0)) {
      return true;
    }
    if (!_isMarket && (_priceController.text.isEmpty || MoneyUtils().fromReadableMoney(_priceController.text) == 0)) {
      return true;
    }
    if (_action == OrderActionTypeEnum.buy) {
      num currentBuyableUnit = _getBuyableUnit(
        tradeLimit - _comission,
        fractionable,
      );
      if (currentBuyableUnit == 0) return true;
      if (qty > currentBuyableUnit) return true;
      if (_estimatedAmount + _comission > tradeLimit) return true;
    } else if (_action == OrderActionTypeEnum.sell) {
      if (_sellableUnit == null) return true;
      if (_sellableUnit == 0) return true;
      if (qty > _sellableUnit!) return true;
    }
    return false;
  }

  num _getBuyableUnit(double tradeLimit, bool fractionable) {
    if (tradeLimit <= 0) {
      tradeLimit = 0;
    }

    if (_isMarket && (_symbol!.trade == null || _symbol!.trade!.price == 0)) {
      return 0;
    }
    if (!_isMarket && (_priceController.text.isEmpty || MoneyUtils().fromReadableMoney(_priceController.text) == 0)) {
      return 0;
    }

    double price = _isMarket ? _symbol!.trade!.price! : MoneyUtils().fromReadableMoney(_priceController.text);
    double rawUnit = (tradeLimit / price);

    if (fractionable) {
      int unitDecimal = getUnitDecimal(rawUnit);
      return ((rawUnit * unitDecimal).floor() / unitDecimal);
    } else {
      return rawUnit.floor();
    }
  }

  void _createOrder(double comission) {
    _createUsOrdersBloc.add(
      CreateOrderEvent(
        symbolName: _symbol!.symbol!,
        extendedHours: _orderType == AmericanOrderTypeEnum.limit && _usMarketStatus != UsMarketStatus.open
            ? _extendedHours
            : false,
        quantity:
            !_fractionable || _isQuantitative ? MoneyUtils().fromReadableMoney(_unitController.text).toString() : null,
        amount: !_isQuantitative && _fractionable ? MoneyUtils().fromReadableMoney(_amountController.text) : null,
        limitPrice: !_isMarket ? MoneyUtils().fromReadableMoney(_priceController.text) : null,
        stopPrice: _isStop ? MoneyUtils().fromReadableMoney(_stopPriceController.text) : null,
        equityPrice: _isMarket ? CreateOrdersUtils().getEquityPrice(_symbol, _latestTradeMixedModel) : null,
        orderActionType: _action,
        orderType: AmericanOrderTypeEnum.values.firstWhere(
          (element) => element.localizationKey == _orderType.localizationKey,
        ),
        callback: (isSuccess, message) {
          if (isSuccess) {
            router.popUntilRouteWithName(CreateUsOrderRoute.name);
            router.replace(
              OrderResultRoute(
                isSuccess: isSuccess,
                message: L10n.tr('success_order'),
              ),
            );
          } else {
            router.push(
              OrderResultRoute(
                isSuccess: isSuccess,
                message: L10n.tr(message ?? ''),
                onButtonPressed: () => router.maybePop(),
              ),
            );
          }
        },
      ),
    );
  }

  void _getLimit() {
    _createUsOrdersBloc.add(
      GetTradeLimitEvent(
        callback: (limit) {
          _sellableUnit = _sellableUnit == 0 ? 0 : _sellableUnit;
          setState(() {});
        },
      ),
    );
  }

  // hissenin elde olan adetini ceker
  void _getBalance() {
    List<AccountModel> accountList =
        UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.turkishLira).toList();
    _symbolSearchBloc.add(
      GetPostitionListEvent(
        accountId: accountList
            .firstWhere(
              (element) =>
                  element.accountId.split('-').last == _appSettingsBloc.state.orderSettings.equityDefaultAccount,
              orElse: () => accountList.first,
            )
            .accountId,
        callback: (positionList) {
          PositionModel? positionModel = positionList.firstWhereOrNull(
            (element) => element.symbolName == _symbol!.asset?.symbol,
          );
          if (positionModel != null) {
            _sellableUnit = positionModel.qty;
          } else {
            _sellableUnit = 0;
          }
          setState(() {});
        },
      ),
    );
  }

  void _setTextFields() {
    _estimatedAmount =
        (_isMarket ? _symbol?.trade?.price ?? 0 : MoneyUtils().fromReadableMoney(_priceController.text)) *
            MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text);
    _amountController.text = MoneyUtils().readableMoney(_estimatedAmount);
  }

  int getUnitDecimal(double rawUnit) {
    int unitDecimal = MoneyUtils().countDecimalPlaces(rawUnit);
    return int.parse('1${'0' * unitDecimal}');
  }

  void setOrderTyeList() {
    if (_action == OrderActionTypeEnum.sell) {
      _orderTypeList = [
        AmericanOrderTypeEnum.market,
        AmericanOrderTypeEnum.limit,
      ];
      if (_isStop) {
        _orderType = AmericanOrderTypeEnum.market;
        _isMarket = true;
      }
      return;
    }

    if ((_symbol?.asset?.fractionable ?? false) == false) {
      _orderTypeList = [
        AmericanOrderTypeEnum.limit,
        AmericanOrderTypeEnum.stopLimit,
      ];
      if (_isMarket) {
        _orderType = AmericanOrderTypeEnum.limit;
        _isMarket = false;
      }
    } else {
      _orderTypeList = [
        AmericanOrderTypeEnum.market,
        AmericanOrderTypeEnum.limit,
        AmericanOrderTypeEnum.stop,
        AmericanOrderTypeEnum.stopLimit,
      ];
      if (_isMarket) {
        _isQuantitative = false;
      }
    }
  }
}
