import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/charts/chart/stacked_bar_chart.dart';
import 'package:design_system/components/charts/model/stacked_bar_model.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_history_card.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

class AdviceHistoryWidget extends StatefulWidget {
  final String mainGroup;
  final bool? canShowAllText;
  const AdviceHistoryWidget({
    super.key,
    required this.mainGroup,
    this.canShowAllText = false,
  });

  @override
  State<AdviceHistoryWidget> createState() => _AdviceHistoryWidgetState();
}

class _AdviceHistoryWidgetState extends State<AdviceHistoryWidget> {
  bool _showAll = false;
  final List<Color> _chartColors = [
    const Color(0xFFeb5828),
    const Color(0xFF4682B4),
  ];

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AdvicesBloc, AdvicesState>(
      bloc: getIt<AdvicesBloc>(),
      builder: (context, state) {
        if (state.advicesState == PageState.loading) {
          return const PLoading();
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  L10n.tr('number_of_closed_trade_suggestions'),
                  style: context.pAppStyle.labelReg14textSecondary,
                ),
                Text(
                  '${state.adviceHistoryModel.closedAdviceCount ?? ''}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            const SizedBox(height: Grid.s + Grid.xs),
            StackedBarChart(
              charDataList: _generateChartModel(
                context,
                [
                  ((state.adviceHistoryModel.closedWithProfit ?? 0)).toDouble(),
                  ((state.adviceHistoryModel.closedWithLoss ?? 0)).toDouble(),
                ],
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: [
                ((state.adviceHistoryModel.closedWithProfit ?? 0)).toDouble(),
                ((state.adviceHistoryModel.closedWithLoss ?? 0)).toDouble(),
              ].length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.m,
                ),
                child: PDivider(),
              ),
              itemBuilder: (context, index) {
                double closedWithProfit =
                    (state.adviceHistoryModel.closedWithProfit ?? 0).toDouble(); // Kar ile Kapatan
                double closedWithLoss = (state.adviceHistoryModel.closedWithLoss ?? 0).toDouble(); // Zarar ile Kapatan

                double total = closedWithProfit + closedWithLoss;

                return Row(
                  children: [
                    Container(
                      height: 30,
                      width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: index ==
                                [
                                      ((state.adviceHistoryModel.closedWithProfit ?? 0)).toDouble(),
                                      ((state.adviceHistoryModel.closedWithLoss ?? 0)).toDouble(),
                                    ].length -
                                    1
                            ? _chartColors.last
                            : _chartColors[index],
                      ),
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10n.tr(
                            index == 0 ? L10n.tr('closed_with_profit') : L10n.tr('closed_with_loss'),
                          ),
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        Text(
                          index == 0
                              ? '%${MoneyUtils().readableMoney((closedWithProfit / total) * 100)}'
                              : '%${MoneyUtils().readableMoney((closedWithLoss / total) * 100)}',
                          style: context.pAppStyle.labelReg14textSecondary,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      index == 0
                          ? '${state.adviceHistoryModel.closedWithProfit ?? '0'} ${L10n.tr('advice')}'
                          : '${state.adviceHistoryModel.closedWithLoss ?? '0'} ${L10n.tr('advice')}',
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              height: Grid.m,
            ),
            const PDivider(),
            const SizedBox(
              height: Grid.s,
            ),
            if (state.adviceHistoryModel.closedAdvices != null && state.adviceHistoryModel.closedAdvices!.isNotEmpty)
              ListView.separated(
                itemCount: _showAll || widget.canShowAllText == false
                    ? state.adviceHistoryModel.closedAdvices!.length
                    : (state.adviceHistoryModel.closedAdvices!.length > 2
                        ? 2
                        : state.adviceHistoryModel.closedAdvices!
                            .length), // Eğer canShowAllText true ise ve item sayısı 2 den büyükse sadece 2 tane listeleyip, Daha Fazla Göster butonunu gösterdiğimiz kontrol.
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.s,
                  ),
                  child: PDivider(),
                ),
                itemBuilder: (context, index) {
                  return AdviceHistoryCard(
                    closedAdvices: state.adviceHistoryModel.closedAdvices![index],
                    symbol: MarketListModel(
                      symbolCode: state.adviceHistoryModel.closedAdvices![index].symbolName,
                      updateDate: '',
                    ),
                    isForeign: widget.mainGroup == MarketTypeEnum.marketUs.value,
                  );
                },
              ),
            const SizedBox(
              height: Grid.m,
            ),
            if (!_showAll &&
                state.adviceHistoryModel.closedAdvices != null &&
                state.adviceHistoryModel.closedAdvices!.length > 2) // Eğer tümü gösterilmiyorsa butonu ekle
              InkWell(
                onTap: () => setState(() {
                  _showAll = true;
                }),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    L10n.tr('show_more_list'),
                    style: context.pAppStyle.labelReg14primary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<StackedBarModel> _generateChartModel(BuildContext context, List<double> data) {
    List<StackedBarModel> chartData = [];

    for (var i = 0; i < data.length; i++) {
      if (data[i].abs() != 0) {
        chartData.add(
          StackedBarModel(
            percent: data[i].abs(),
            color: i == data.length - 1 ? _chartColors.last : _chartColors[i],
          ),
        );
      }
    }

    return chartData;
  }
}
