import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/depth/widgets/realized_transaction_row.dart';
import 'package:piapiri_v2/app/depth/widgets/realized_transactions_title.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/api/client/mqtt_trade_controller.dart';
import 'package:piapiri_v2/core/api/model/proto_model/trade/trade_model.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RealizedTransactionsPage extends StatefulWidget {
  final MarketListModel symbol;
  const RealizedTransactionsPage({
    super.key,
    required this.symbol,
  });

  @override
  State<RealizedTransactionsPage> createState() => _RealizedTransactionsPageState();
}

class _RealizedTransactionsPageState extends State<RealizedTransactionsPage> {
  List<Map<String, dynamic>> elementList = [];
  bool isTradeEnabled = false;
  late AppInfoState _appInfoState;
  late MatriksState _matriksState;
  final ValueNotifier<Trade?> data = ValueNotifier(null);
  bool _isDepthExpanded = true;
  ValueNotifier<int> currentTransactionCount = ValueNotifier<int>(0);

  @override
  void initState() {
    _appInfoState = getIt<AppInfoBloc>().state;
    _matriksState = getIt<MatriksBloc>().state;
    isTradeEnabled = _matriksState.topics['mqtt']['trade'] != null;
    if (isTradeEnabled) {
      _connectToMqtt();
    }
    super.initState();
  }

  _connectToMqtt() async {
    await getIt<MqttTradeController>().initializeAndConnect(
      isRealtime: _matriksState.topics['mqtt']['trade']['S']['qos'] == 'rt',
      onGetData: (trade) {
        data.value = trade;

        if (currentTransactionCount.value < 20) {
          currentTransactionCount.value++;
        }
      },
    );
    await getIt<MqttTradeController>().subscribe(symbol: widget.symbol);
  }

  @override
  void dispose() {
    getIt<MqttTradeController>().disconnect();
    currentTransactionCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
            valueListenable: currentTransactionCount,
            builder: (context, currentTransactionCount, _) {
              return PExpandablePanel(
                initialExpanded: _isDepthExpanded,
                isExpandedChanged: (isExpanded) => setState(() => _isDepthExpanded = isExpanded),
                titleBuilder: (_) => Row(
                  children: [
                    Text(
                      L10n.tr('completed_transactions'),
                      style: context.pAppStyle.labelMed16textPrimary,
                    ),
                    const SizedBox(width: Grid.xs),
                    SvgPicture.asset(
                      _isDepthExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
                      height: 16,
                      width: 16,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Grid.s + Grid.xs,
                    ),
                    const RealizedTransactionsTitle(),
                    const SizedBox(height: Grid.s),
                    PDivider(
                      color: context.pColorScheme.line,
                      tickness: 1,
                    ),
                    !isTradeEnabled
                        ? NoDataWidget(
                            message: L10n.tr('no_trade_license').toString().trim(),
                          )
                        : ValueListenableBuilder(
                            valueListenable: data,
                            builder: (context, tradeData, _) {
                              if (tradeData == null) return const SizedBox.shrink();

                              elementList.insert(0, {
                                'fiyat': tradeData.price.toStringAsFixed(2),
                                'adet': tradeData.quantity.toString(),
                                'alan': tradeData.buyer.isEmpty ? '-' : tradeData.buyer,
                                'satan': tradeData.seller.isEmpty ? '-' : tradeData.seller,
                                'activeBidOrAsk': tradeData.activeBidOrAsk,
                              });

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: elementList.length < 20 ? elementList.length : 20,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return RealizedTransactionRow(
                                    qty: elementList[index]["adet"],
                                    price:
                                        '${MoneyUtils().getCurrency(stringToSymbolType(widget.symbol.type))}${MoneyUtils().readableMoney(num.parse(elementList[index]["fiyat"] ?? 0))}',
                                    buyer: _appInfoState.memberCodeShortNames[elementList[index]["alan"]] ??
                                        elementList[index]["alan"],
                                    seller: _appInfoState.memberCodeShortNames[elementList[index]["satan"]] ??
                                        elementList[index]["satan"],
                                    textColor: elementList[index]["activeBidOrAsk"] == "a"
                                        ? context.pColorScheme.critical
                                        : context.pColorScheme.success,
                                  );
                                },
                              );
                            },
                          ),
                    const SizedBox(
                      height: Grid.m,
                    )
                  ],
                ),
              );
            })
      ],
    );
  }
}
