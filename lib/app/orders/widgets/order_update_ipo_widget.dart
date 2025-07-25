import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/p_symbol_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderUpdateIpoWidget extends StatefulWidget {
  final TransactionModel selectedOrder;
  const OrderUpdateIpoWidget({
    super.key,
    required this.selectedOrder,
  });

  @override
  State<OrderUpdateIpoWidget> createState() => _OrderUpdateIpoWidgetState();
}

class _OrderUpdateIpoWidgetState extends State<OrderUpdateIpoWidget> {
  final TextEditingController _orderUnitTC = TextEditingController();
  double _amount = 0;
  final FocusNode _focusNodeUnit = FocusNode(canRequestFocus: false);
  late final SymbolBloc _symbolBloc;
  late final OrdersBloc _ordersBloc;
  MarketListModel? subscribedSymbol;
  double? _tradeLimit;

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _ordersBloc = getIt<OrdersBloc>();

    _subscribeSymbol(
      widget.selectedOrder.symbol ?? '',
    );

    super.initState();
  }

  _subscribeSymbol(String? symbolName) {
    _symbolBloc.add(
      SymbolSelectItemTemporarily(
        symbol: MarketListModel(
          symbolCode: symbolName ?? widget.selectedOrder.asset ?? '',
          updateDate: '',
          type: widget.selectedOrder.symbolType?.name ?? SymbolTypes.equity.name,
          basePrice: widget.selectedOrder.price ?? 0,
        ),
      ),
    );

    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: symbolName ?? '',
        symbolType: widget.selectedOrder.equityGroupCode == 'V' ? SymbolTypes.warrant : SymbolTypes.equity,
        callback: (symbol) {
          setState(() {
            subscribedSymbol = symbol;
          });
          if (symbol.type == SymbolTypes.option.name || symbol.type == SymbolTypes.future.name) {
            _ordersBloc.add(
              GetCollateralInfoEvent(
                callback: (limit) {
                  setState(() {
                    _tradeLimit = limit?.usableColl;
                  });
                },
              ),
            );
          } else {
            _ordersBloc.add(
              GetTradeLimitEvent(
                symbolName: symbolName ?? '',
                callback: (limit) {
                  setState(() {
                    _tradeLimit = limit;
                  });
                },
              ),
            );
          }

          _symbolBloc.add(
            SymbolSelectItemTemporarily(
              symbol: symbol,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PSymbolTile(
          variant: PSymbolVariant.equityTab,
          symbolName: widget.selectedOrder.symbol,
          symbolType: stringToSymbolType(widget.selectedOrder.symbol ?? ''),
          title: widget.selectedOrder.symbol,
        ),
        const SizedBox(
          height: Grid.s,
        ),
        const PDivider(),
        const SizedBox(
          height: Grid.s,
        ),
        Row(
          children: [
            Text(
              '${L10n.tr('ipo_price')}: ',
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              width: Grid.xs,
            ),
            Text(
              '₺${widget.selectedOrder.orderPrice ?? 0}',
              style: context.pAppStyle.labelMed14textPrimary,
            )
          ],
        ),
        const SizedBox(
          height: Grid.l,
        ),
        PBlocBuilder<SymbolBloc, SymbolState>(
            bloc: _symbolBloc,
            builder: (context, state) {
              return Column(
                children: [
                  PValueTextfieldWidget(
                    controller: _orderUnitTC,
                    title: L10n.tr('adet'),
                    subTitle: Text(
                      '${L10n.tr('alinabilir_adet')}: ${state.tempSelectedItem == null ? '' : MoneyUtils().readableMoney(
                            (_tradeLimit ?? 0 / state.tempSelectedItem!.last).floorToDouble(),
                            pattern: '###,###.###',
                          ).toString()}',
                      style: context.pAppStyle.labelReg12textSecondary,
                    ),
                    onFocusChange: (value) {
                      if (!value) {}
                    },
                    focusNode: _focusNodeUnit,
                    onChanged: (deger) {
                      setState(() {
                        _orderUnitTC.text = deger.toString();

                        _amount = int.parse(deger) * (widget.selectedOrder.orderPrice ?? 0);
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _orderUnitTC.text = value;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  const SizedBox(
                    height: Grid.s,
                  ),
                  ConsistentEquivalence(
                    title: L10n.tr('estimated_amount'),
                    titleValue: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: POutlinedButton(
                          text: L10n.tr('vazgec'),
                          fillParentWidth: true,
                          sizeType: PButtonSize.medium,
                          onPressed: () {
                            router.maybePop();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Expanded(
                        child: PButton(
                          text: L10n.tr('onayla'),
                          fillParentWidth: true,
                          onPressed: () async {
                            if (_orderUnitTC.text.isEmpty || _orderUnitTC.text == '0') {
                              return PBottomSheet.show(
                                context,
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        ImagesPath.alertCircle,
                                        width: 52,
                                        height: 52,
                                        colorFilter: ColorFilter.mode(
                                          context.pColorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Grid.s,
                                      ),
                                      Text(
                                        L10n.tr('please_enter_unit'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (int.parse(_orderUnitTC.text) >
                                (_tradeLimit ?? 0 / state.tempSelectedItem!.last)) {
                              return PBottomSheet.show(
                                context,
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        ImagesPath.alertCircle,
                                        width: 52,
                                        height: 52,
                                        colorFilter: ColorFilter.mode(
                                          context.pColorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Grid.s,
                                      ),
                                      Text(
                                        L10n.tr(
                                          'max_unit_warning',
                                          args: [
                                            MoneyUtils()
                                                .readableMoney(
                                                  _tradeLimit ?? 0 / state.tempSelectedItem!.last,
                                                  pattern: '###,###.###',
                                                )
                                                .toString()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              _ordersBloc.add(
                                ReplaceOrderEvent(
                                  transactionId: widget.selectedOrder.transactionId.toString(),
                                  oldPrice: widget.selectedOrder.orderPrice ?? widget.selectedOrder.price ?? 0,
                                  oldUnit: widget.selectedOrder.remainingUnit?.toInt() ??
                                      widget.selectedOrder.orderUnit?.toInt() ??
                                      widget.selectedOrder.units?.toInt() ??
                                      0,
                                  newPrice: MoneyUtils().fromReadableMoney(
                                    widget.selectedOrder.orderPrice.toString(),
                                  ),
                                  newUnit: _stringToUnit(),
                                  periodicTransactionId: widget.selectedOrder.periodicTransactionId,
                                  timeInForce: double.parse(widget.selectedOrder.validity ?? '0.0').toInt().toString(),
                                  errorCallback: (errorMessage) async {
                                    return PBottomSheet.show(
                                      context,
                                      child: SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Column(
                                          children: [
                                            SvgPicture.asset(
                                              ImagesPath.alertCircle,
                                              width: 52,
                                              height: 52,
                                              colorFilter: ColorFilter.mode(
                                                context.pColorScheme.primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: Grid.s,
                                            ),
                                            Text(
                                              L10n.tr(
                                                errorMessage,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  successCallback: (successMessage) async {
                                    _ordersBloc.add(
                                      RefreshOrdersEvent(
                                        account: _ordersBloc.state.selectedAccount,
                                        symbolType: _ordersBloc.state.selectedSymbolType,
                                        orderStatus: OrderStatusEnum.pending,
                                        refreshData: true,
                                        isLoading: true,
                                      ),
                                    );

                                    router.push(
                                      InfoRoute(
                                        variant: InfoVariant.success,
                                        message: L10n.tr('order_update_success'),
                                        buttonText: L10n.tr('emirlerime_don'),
                                        onTapButton: () {
                                          router.popUntilRoot();
                                        },
                                      ),
                                    );
                                    await router.maybePop();
                                  },
                                ),
                              );

                              await router.maybePop();
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              );
            }),
      ],
    );
  }

  int _stringToUnit() {
    return _orderUnitTC.text.isEmpty ? 1 : int.parse(_orderUnitTC.text.replaceAll(',', '').replaceAll('.', ''));
  }
}
