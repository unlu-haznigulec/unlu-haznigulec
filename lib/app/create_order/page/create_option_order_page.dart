import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_event.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_state.dart';
import 'package:piapiri_v2/app/create_order/widgets/order_detail.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_selected.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/order_validator.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/cashflow_transaction_widget.dart';
import 'package:piapiri_v2/common/widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/date_select_row.dart';
import 'package:piapiri_v2/common/widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/insufficient_limit_widget.dart';
import 'package:piapiri_v2/common/widgets/p_amount_textfield.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/p_price_textfield.dart';
import 'package:piapiri_v2/common/widgets/p_quantity_textfield.dart';
import 'package:piapiri_v2/common/widgets/text_button_selector.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class CreateOptionOrderPage extends StatefulWidget {
  final MarketListModel? symbol;
  final OrderActionTypeEnum? action;
  const CreateOptionOrderPage({
    super.key,
    this.symbol,
    this.action,
  });

  @override
  State<CreateOptionOrderPage> createState() => _CreateOptionOrderPageState();
}

class _CreateOptionOrderPageState extends State<CreateOptionOrderPage> {
  MarketListModel? _symbol;
  final CreateOrdersBloc _createOrdersBloc = getIt<CreateOrdersBloc>();
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  bool _didPriceGet = false;
  final TextEditingController _unitController = TextEditingController(text: '0');
  final TextEditingController _amountController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _priceController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final FocusNode _priceFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late GlobalKey _priceKey;
  late GlobalKey _qtyKey;
  late GlobalKey _amountKey;
  OrderActionTypeEnum _action = OrderActionTypeEnum.buy;
  late OptionOrderValidityEnum _orderValidity;
  late OptionOrderTypeEnum _orderType;
  int? _sellableUnit;
  int _multiplier = 1;
  late DateTime _validityDate;
  late String _accountId;
  bool _isQuantitative = true;
  double _tradeLimit = 0;
  late String pattern;
  late int maxDigitAfterSeparator;
  final AuthBloc _authBloc = getIt<AuthBloc>();

  @override
  initState() {
    _priceKey = GlobalKey(debugLabel: 'optionPrice');
    _qtyKey = GlobalKey(debugLabel: 'optionQTY');
    _amountKey = GlobalKey(debugLabel: 'optionAmount');
    _symbol = widget.symbol;

    if (_authBloc.state.isLoggedIn) {
      pattern = MoneyUtils().getPricePattern(stringToSymbolType(_symbol!.type), _symbol!.subMarketCode);
      maxDigitAfterSeparator = _symbol!.subMarketCode == 'CRF' ? 4 : 2;
      _accountId = '${UserModel.instance.customerId}-${_appSettingsBloc.state.orderSettings.viopDefaultAccount}';
      _orderType = _appSettingsBloc.state.orderSettings.viopDefaultOrderType;
      _orderValidity = _appSettingsBloc.state.orderSettings.viopDefaultValidity;
      _validityDate = Utils().checkStopLossDate(DateTime.now().add(const Duration(days: 1)));
      if (widget.action != null) {
        _action = widget.action!;
      }
      if (_symbol != null) {
        _symbolBloc.add(
          SymbolSubOneTopicEvent(
            symbol: _symbol!.symbolCode,
            callback: (p0) {
              setState(() {
                _symbol = p0;
                if (MoneyUtils().getPrice(_symbol!, _action) != 0) {
                  _setTextFields();
                  _didPriceGet = true;
                }
              });
            },
          ),
        );
      }
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
        actions: !_authBloc.state.isLoggedIn
            ? null
            : [
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
                    await router.push(const ViopSettingsRoute());
                    _accountId =
                        '${UserModel.instance.customerId}-${_appSettingsBloc.state.orderSettings.viopDefaultAccount}';
                    _orderType = _appSettingsBloc.state.orderSettings.viopDefaultOrderType;
                    _orderValidity = _appSettingsBloc.state.orderSettings.viopDefaultValidity;
                    _setTextFields();
                    setState(() {});
                  },
                ),
              ],
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_order_alert'),
              loginMessage: L10n.tr('login_order_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      CreateOptionOrderRoute(
                        symbol: widget.symbol,
                        action: widget.action,
                      ),
                    );
                  },
                ),
              ),
            )
          : PBlocBuilder<CreateOrdersBloc, CreateOrdersState>(
              bloc: _createOrdersBloc,
              builder: (context, ordersState) {
                return Scaffold(
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Grid.m,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SymbolSearchSelected(
                                  key: ValueKey('SELECTED_SYMBOL_${_symbol?.symbolCode}'),
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
                                  accountId: _accountId.split('-').last,
                                  symbolModel: _symbol != null ? SymbolModel.fromMarketListModel(_symbol!) : null,
                                  showPositonList: _action != OrderActionTypeEnum.buy,
                                  showSearchPositon: true,
                                  onTapSymbol: (marketListModel) {
                                    SymbolSearchUtils.goCreateSymbol(
                                        marketListModel, _action, SymbolTypes.future, CreateOptionOrderRoute.name);
                                    _symbol = marketListModel;
                                    _didPriceGet = MoneyUtils().getPrice(_symbol!, _action) != 0;
                                    if (_didPriceGet) {
                                      _setTextFields();
                                    }
                                    List<PositionModel> positionList = _symbolSearchBloc.state.positionList;
                                    PositionModel? positionModel = positionList.firstWhereOrNull(
                                      (element) => element.symbolName == _symbol!.symbolCode,
                                    );
                                    if (positionModel != null) {
                                      _sellableUnit = positionModel.qty.toInt();
                                    } else {
                                      _sellableUnit = 0;
                                    }
                                    setState(() {});
                                  },
                                  onTapPosition: (positionModel) {
                                    _symbol = MarketListModel(
                                      symbolCode: positionModel.symbolName,
                                      description: positionModel.description,
                                      underlying: positionModel.underlyingName,
                                      type: positionModel.symbolType.dbKey,
                                      updateDate: '',
                                    );
                                    SymbolSearchUtils.goCreateSymbol(
                                        _symbol!, _action, SymbolTypes.future, CreateOptionOrderRoute.name);
                                    _didPriceGet = false;
                                    _sellableUnit = positionModel.qty.toInt();
                                    setState(() {});
                                  },
                                  onSelectedPrice: (price) => setState(() {
                                    _priceController.text = price;
                                  }),
                                ),
                                const SizedBox(
                                  height: Grid.l,
                                ),
                                PBlocConsumer<SymbolBloc, SymbolState>(
                                  bloc: _symbolBloc,
                                  listenWhen: (previous, current) {
                                    return _symbol != null &&
                                        !_didPriceGet &&
                                        current.watchingItems.any((e) => e.symbolCode == _symbol!.symbolCode);
                                  },
                                  listener: (BuildContext context, SymbolState state) {
                                    MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
                                      (element) => element.symbolCode == _symbol!.symbolCode,
                                    );
                                    if (newModel == null) return;
                                    setState(() {
                                      _symbol = SymbolDetailUtils().fetchWithSubscribedSymbol(newModel, widget.symbol);
                                      // Fiyat cekilmedi ise fiyati cekmeye calisir
                                      if (!_didPriceGet) {
                                        _didPriceGet = newModel.limitUp != 0;
                                        // eger fiyat geldi ise textfieldlara set eder
                                        if (_didPriceGet) {
                                          _setTextFields();
                                        }
                                      }
                                    });
                                  },
                                  builder: (context, symbolState) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 35,
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
                                              _unitController.text = '0';
                                              _amountController.text = MoneyUtils().readableMoney(0);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Grid.l,
                                        ),
                                        TextButtonSelector(
                                          selectedItem: L10n.tr(_orderType.localizationKey),
                                          selectedTextStyle: context.pAppStyle.labelMed14primary,
                                          onSelect: () {
                                            PBottomSheet.show(
                                              context,
                                              title: L10n.tr('emir_tipi'),
                                              titlePadding: const EdgeInsets.only(
                                                top: Grid.m,
                                              ),
                                              child: ListView.separated(
                                                itemCount: OptionOrderTypeEnum.values.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return BottomsheetSelectTile(
                                                    title: L10n.tr(OptionOrderTypeEnum.values[index].localizationKey),
                                                    subTitle: L10n.tr(OptionOrderTypeEnum.values[index].descriptionKey),
                                                    isSelected: _orderType == OptionOrderTypeEnum.values[index],
                                                    value: OptionOrderTypeEnum.values[index],
                                                    onTap: (_, value) {
                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        _orderType = value;
                                                        _setTextFields();
                                                      });
                                                    },
                                                  );
                                                },
                                                separatorBuilder: (context, index) => const PDivider(),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: Grid.s,
                                        ),
                                        SizedBox(
                                          height: 35,
                                          child: SlidingSegment(
                                            backgroundColor: context.pColorScheme.card,
                                            segmentList: [
                                              PSlidingSegmentItem(
                                                segmentTitle: L10n.tr('adet'),
                                                segmentColor: context.pColorScheme.secondary,
                                              ),
                                              PSlidingSegmentItem(
                                                segmentTitle: L10n.tr('tutar'),
                                                segmentColor: context.pColorScheme.secondary,
                                              ),
                                            ],
                                            onValueChanged: (p0) {
                                              setState(() {
                                                _isQuantitative = p0 == 0;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Grid.s,
                                        ),
                                        if (_orderType != OptionOrderTypeEnum.marketToLimit) ...[
                                          PPriceTextfield(
                                            key: _priceKey,
                                            title: _orderType == OptionOrderTypeEnum.limit
                                                ? L10n.tr('limit_price')
                                                : L10n.tr('fiyat'),
                                            controller: _priceController,
                                            action: _action,
                                            focusNode: _priceFocusNode,
                                            maxDigitAfterSeparator: maxDigitAfterSeparator,
                                            onTapPrice: () => KeyboardUtils().scrollOnFocus(
                                              context,
                                              _priceKey,
                                              _scrollController,
                                            ),
                                            onPriceChanged: (price) {
                                              double amount = MoneyUtils().fromReadableMoney(_priceController.text) *
                                                  _multiplier *
                                                  MoneyUtils().fromReadableMoney(
                                                      _unitController.text.isEmpty ? '0' : _unitController.text);
                                              _amountController.text = MoneyUtils().readableMoney(amount);
                                              setState(() {});
                                            },
                                            marketListModel: _symbol ?? widget.symbol,
                                          ),
                                          const SizedBox(
                                            height: Grid.s,
                                          ),
                                        ],
                                        _isQuantitative
                                            ? PQuantityTextfield(
                                                key: _qtyKey,
                                                controller: _unitController,
                                                action: _action,
                                                subtitle: _action == OrderActionTypeEnum.sell
                                                    ? '${L10n.tr('current_unit')}: ${(_sellableUnit ?? 0).toInt()}'
                                                    : null,
                                                ignoreLimit: _action == OrderActionTypeEnum.buy,
                                                autoFocus: false,
                                                onTapQuantity: () => KeyboardUtils().scrollOnFocus(
                                                  context,
                                                  _qtyKey,
                                                  _scrollController,
                                                ),
                                                onTapSubtitle: () {
                                                  double price = _orderType == OptionOrderTypeEnum.marketToLimit
                                                      ? MoneyUtils().getPrice(
                                                          _symbol!,
                                                          _action,
                                                        )
                                                      : MoneyUtils().fromReadableMoney(_priceController.text);
                                                  price = _multiplier * price;
                                                  _unitController.text = MoneyUtils().readableMoney(
                                                    (_sellableUnit ?? 0),
                                                    pattern: '#,##0',
                                                  );
                                                  _amountController.text = MoneyUtils().readableMoney(
                                                    price * (_sellableUnit ?? 0),
                                                  );
                                                  setState(() {});
                                                },
                                                onUnitChanged: (unit) {
                                                  double price = _orderType == OptionOrderTypeEnum.marketToLimit
                                                      ? MoneyUtils().getPrice(
                                                          _symbol!,
                                                          _action,
                                                        )
                                                      : MoneyUtils().fromReadableMoney(_priceController.text);
                                                  price = _multiplier * price;
                                                  _amountController.text = MoneyUtils().readableMoney(
                                                    price * unit,
                                                  );
                                                  setState(() {});
                                                },
                                              )
                                            : PAmountTextfield(
                                                key: _amountKey,
                                                controller: _amountController,
                                                action: _action,
                                                isError: MoneyUtils().fromReadableMoney(_amountController.text) != 0 &&
                                                    _tradeLimit == 0 &&
                                                    _action == OrderActionTypeEnum.buy,
                                                errorText: L10n.tr('insufficient_collateral_limit'),
                                                onTapAmount: () => KeyboardUtils().scrollOnFocus(
                                                  context,
                                                  _amountKey,
                                                  _scrollController,
                                                ),
                                                onAmountChanged: (amount) {
                                                  double price = _orderType == OptionOrderTypeEnum.marketToLimit
                                                      ? MoneyUtils().getPrice(
                                                          _symbol!,
                                                          _action,
                                                        )
                                                      : MoneyUtils().fromReadableMoney(_priceController.text);
                                                  price = _multiplier * price;
                                                  int rawUnit = (amount / price).floor();
                                                  _unitController.text = rawUnit.toString();
                                                  _amountController.text = MoneyUtils().readableMoney(
                                                    price * rawUnit,
                                                  );
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
                                              ? '${CurrencyEnum.turkishLira.symbol}${_amountController.text}'
                                              : _unitController.text,
                                          subTitle: _action == OrderActionTypeEnum.sell && !_isQuantitative
                                              ? '${L10n.tr('current_unit')}:'
                                              : null,
                                          onTapSubtitle: (value) {
                                            double price = _orderType == OptionOrderTypeEnum.marketToLimit
                                                ? MoneyUtils().getPrice(
                                                    _symbol!,
                                                    _action,
                                                  )
                                                : MoneyUtils().fromReadableMoney(_priceController.text);
                                            price = _multiplier * price;
                                            _unitController.text = MoneyUtils().readableMoney(
                                              value,
                                              pattern: '#,##0',
                                            );
                                            _amountController.text = MoneyUtils().readableMoney(
                                              price * value,
                                            );
                                            setState(() {});
                                          },
                                          subTitleValue: _action == OrderActionTypeEnum.sell && !_isQuantitative
                                              ? '${(_sellableUnit ?? 0).toInt()}'
                                              : null,
                                          errorMessage: getConsistentEquivalenceError(),
                                        ),
                                        if (MoneyUtils().fromReadableMoney(_amountController.text) != 0 &&
                                            MoneyUtils().fromReadableMoney(_amountController.text) > _tradeLimit &&
                                            _action == OrderActionTypeEnum.buy) ...[
                                          const SizedBox(
                                            height: Grid.s,
                                          ),

                                          /// yetersiz limitte bakiye yuklemeye godneridgimiz widget
                                          InsufficientLimitWidget(
                                            text: L10n.tr('deposit_tl_continue'),
                                            onTap: () {
                                              router.push(DepositMoneyAccountRoute());
                                            },
                                          ),
                                        ],
                                        const SizedBox(
                                          height: Grid.l,
                                        ),
                                        CashflowTransactionWidget(
                                          limitText: L10n.tr('usable_collateral'),
                                          limitValue: _tradeLimit,
                                        ),

                                        const SizedBox(
                                          height: Grid.l,
                                        ),
                                        TextButtonSelector(
                                          selectedItem: L10n.tr(_orderValidity.localizationKey),
                                          selectedColor: context.pColorScheme.primary,
                                          onSelect: () {
                                            PBottomSheet.show(
                                              context,
                                              title: L10n.tr('validity_period'),
                                              titlePadding: const EdgeInsets.only(
                                                top: Grid.m,
                                              ),
                                              child: ListView.separated(
                                                itemCount: OptionOrderValidityEnum.values.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return BottomsheetSelectTile(
                                                    title:
                                                        L10n.tr(OptionOrderValidityEnum.values[index].localizationKey),
                                                    subTitle: L10n.tr(
                                                      'viop_order_validity_desc_${OptionOrderValidityEnum.values[index].localizationKey}',
                                                    ),
                                                    isSelected: _orderValidity == OptionOrderValidityEnum.values[index],
                                                    value: OptionOrderValidityEnum.values[index],
                                                    onTap: (_, value) {
                                                      setState(() {
                                                        _orderValidity = value;
                                                      });
                                                      router.maybePop();
                                                    },
                                                  );
                                                },
                                                separatorBuilder: (context, index) => const PDivider(),
                                              ),
                                            );
                                          },
                                        ),
                                        if (_orderValidity == OptionOrderValidityEnum.byDate) ...[
                                          const SizedBox(
                                            height: Grid.s,
                                          ),
                                          DateSelectRow(
                                            leading: L10n.tr('gecerlilik_tarihi'),
                                            trailing: DateTimeUtils.dateFormat(_validityDate),
                                            selectedDate: _validityDate,
                                            minimumDate:
                                                Utils().checkStopLossDate(DateTime.now().add(const Duration(days: 1))),
                                            onDateSelected: (DateTime value) {
                                              _validityDate = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                        const SizedBox(
                                          height: Grid.xxl + Grid.m,
                                        ),
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
                            text: '${_symbol?.symbolCode} ${L10n.tr(_action.localizationKey1)}',
                            onPressed: _getButtonDisability()
                                ? null
                                : () => _appSettingsBloc
                                        .state.orderSettings.transactionApprovalRequest // İşlem Onay İsteği Kontrolü
                                    ? _orderApproveSheet()
                                    : _createOrder(),
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

  void _getLimit() {
    _createOrdersBloc.add(
      GetCollateralInfoEvent(
        accountId: _accountId.split('-').last,
        callback: (colletralInfo) {
          _tradeLimit = colletralInfo?.usableColl ?? 0;
          setState(() {});
        },
      ),
    );
    _createOrdersBloc.add(
      GetMultiplierEvent(
        asset: _symbol!.symbolCode,
        callback: (int multiplier) {
          setState(() {
            _multiplier = multiplier;
          });
        },
      ),
    );
  }

  // hissenin elde olan adetini ceker
  void _getBalance() {
    _symbolSearchBloc.add(
      GetPostitionListEvent(
        accountId: _accountId.split('-')[1],
        callback: (positionList) {
          PositionModel? positionModel = positionList.firstWhereOrNull(
            (element) => element.symbolName == _symbol!.symbolCode,
          );
          if (positionModel != null) {
            _sellableUnit = positionModel.qty.toInt();
          } else {
            _sellableUnit = 0;
          }
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              setState(() {});
            },
          );
        },
      ),
    );
  }

  String? getConsistentEquivalenceError() {
    if (_action == OrderActionTypeEnum.buy &&
        MoneyUtils().fromReadableMoney(_amountController.text) != 0 &&
        _tradeLimit == 0 &&
        _isQuantitative) {
      return L10n.tr('insufficient_collateral_limit');
    }
    return null;
  }

  bool _getButtonDisability() {
    SymbolTypes? symbolType = stringToSymbolType(_symbol!.type);
    double currentPrice = MoneyUtils().fromReadableMoney(_priceController.text);
    int unit = MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text).toInt();
    if (_symbol == null) return true;

    double newPrice = OrderValidator.priceValidator(
      context,
      symbolName: _symbol!.symbolCode,
      price: currentPrice,
      limitUp: _symbol!.limitUp,
      limitDown: _symbol!.limitDown,
      type: symbolType,
      showPopup: false,
    );
    if (newPrice != currentPrice) return true;
    if (currentPrice == 0) return true;
    if (unit == 0) return true;
    if (_action == OrderActionTypeEnum.buy && _tradeLimit == 0) return true;
    return false;
  }

  void _orderApproveSheet() {
    PBottomSheet.show(
      context,
      title: L10n.tr('order_confirmation'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: Grid.l,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: _orderType == OptionOrderTypeEnum.marketToLimit
                      ? L10n.tr(
                          'order_send_span_market',
                          args: [_unitController.text, _symbol!.symbolCode],
                        )
                      : L10n.tr(
                          'order_send_span_3',
                          args: [
                            '${MoneyUtils().getCurrency(stringToSymbolType(_symbol!.type))}${_priceController.text}',
                            _unitController.text,
                            _symbol!.symbolCode
                          ],
                        ),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
                TextSpan(
                  text: '${L10n.tr('viop')} ${L10n.tr(_action.localizationKey2).toUpperCase()} ',
                  style: context.pAppStyle.interMediumBase.copyWith(
                    color: _action.color,
                    fontSize: Grid.m,
                  ),
                ),
                TextSpan(
                  text: L10n.tr('order_send_span_2'),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          TextButton(
            onPressed: () async {
              await PBottomSheet.show(
                context,
                title: L10n.tr('emir_detay'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                child: OrderDetail(
                  symbolCode: _symbol!.symbolCode,
                  symbolType: stringToSymbolType(_symbol!.type),
                  action: _action,
                  orderType: _orderType == OptionOrderTypeEnum.limit
                      ? OrderTypeEnum.limit.localizationKey
                      : OrderTypeEnum.marketToLimit.localizationKey,
                  price: MoneyUtils().fromReadableMoney(_priceController.text),
                  unit: MoneyUtils().fromReadableMoney(_unitController.text),
                  amount: MoneyUtils().fromReadableMoney(_amountController.text),
                  validityLocalizationKey: _orderValidity.localizationKey,
                  accountExtId: '${UserModel.instance.customerId} - ${UserModel.instance.accountId}',
                  orderDate: DateTime.now(),
                  validityDate: _orderValidity == OptionOrderValidityEnum.byDate ? _validityDate : null,
                  onPressedApprove: () {
                    router.maybePop();
                    _createOrder();
                  },
                ),
              );
            },
            child: Text(
              L10n.tr('show_order_detail'),
              style: context.pAppStyle.labelReg16primary,
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
          OrderApprovementButtons(
            onPressedApprove: () {
              router.maybePop();
              _createOrder();
            },
          ),
          const SizedBox(
            height: Grid.l,
          ),
        ],
      ),
    );
  }

  void _createOrder() {
    _createOrdersBloc.add(
      CreateOptionOrderEvent(
        symbol: _symbol!,
        accountId: UserModel.instance.accountId,
        units: MoneyUtils().fromReadableMoney(_unitController.text).toInt(),
        price: MoneyUtils().fromReadableMoney(_priceController.text),
        orderAction: _action,
        optionOrderType: _orderType,
        orderValidity: _orderValidity,
        validityDate: _orderValidity == OptionOrderValidityEnum.byDate ? _validityDate : null,
        callback: (bool isSuccess, String message) {
          if (isSuccess) {
            router.popUntilRouteWithName(CreateOptionOrderRoute.name);
            router.replace(
              OrderResultRoute(
                isSuccess: true,
                message: L10n.tr(message),
              ),
            );
          } else {
            router.push(
              OrderResultRoute(
                isSuccess: false,
                message: message,
              ),
            );
          }
        },
      ),
    );
  }

  void _setTextFields() {
    double price = _orderType == OptionOrderTypeEnum.marketToLimit
        ? MoneyUtils().getPrice(
            _symbol!,
            _action,
          )
        : MoneyUtils().fromReadableMoney(_priceController.text);
    _priceController.text = MoneyUtils().readableMoney(
        price == 0
            ? MoneyUtils().getPrice(
                _symbol!,
                _action,
              )
            : price,
        pattern: pattern);
    price = _multiplier * price;
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
    _amountController.text = MoneyUtils().readableMoney(
      price * unit,
    );
  }
}
