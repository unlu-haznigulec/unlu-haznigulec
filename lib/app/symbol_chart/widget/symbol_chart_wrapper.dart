import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_chart/widget/symbol_chart.dart';
import 'package:piapiri_v2/app/symbol_chart/widget/symbol_chart_options.dart';
import 'package:piapiri_v2/common/widgets/chart_loading_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';

class SymbolChartWrapper extends StatefulWidget {
  final String symbolName;
  final bool hasCurrencySwitch;

  const SymbolChartWrapper({
    super.key,
    required this.symbolName,
    this.hasCurrencySwitch = true,
  });

  @override
  State<SymbolChartWrapper> createState() => _SymbolChartWrapperState();
}

class _SymbolChartWrapperState extends State<SymbolChartWrapper> {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final List<ChartFilter> _chartFilterList = ChartFilter.values
      .where(
        (element) => element != ChartFilter.sixMonth && element != ChartFilter.fiveYear,
      )
      .toList();

  @override
  void initState() {
    _symbolChartBloc.add(
      GetDataEvent(
        symbolName: widget.symbolName,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PBlocBuilder<SymbolChartBloc, SymbolChartState>(
          bloc: _symbolChartBloc,
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(
                  height: Grid.m,
                ),
                if (state.isLoading || state.isFailed || (!state.isLoading && state.chartData.isEmpty))
                  ChartLoadingWidget(
                    isFailed: state.isFailed || (!state.isLoading && state.chartData.isEmpty),
                  )
                else ...[
                  SymbolChart(
                    symbolName: widget.symbolName,
                    chartType: state.chartType,
                    isFailed: state.isFailed,
                    chartData: state.chartData,
                    isLoading: state.isLoading,
                    chartCurrency: state.chartCurrency,
                    selectedFilter: state.selectedFilter,
                  ),
                ],
                const SizedBox(
                  height: Grid.s,
                ),

                /// Burada Chart periodu, Currency ve chart type seçimleri yapılıyor
                SymbolChartOptions(
                  hasCurrencySwitch: widget.hasCurrencySwitch,
                  selectedCurrencyEnum: state.chartCurrency,
                  chartFilter: state.selectedFilter,
                  chartFilterList: _chartFilterList,
                  selectedType: state.chartType,
                  onFilterChanged: (index) {
                    _symbolChartBloc.add(
                      GetDataEvent(
                        symbolName: widget.symbolName,
                        filter: _chartFilterList[index],
                      ),
                    );
                  },
                  onCurrencyChanged: (currencyEnum) {
                    Navigator.pop(context);
                    if (currencyEnum != _symbolChartBloc.state.chartCurrency) {
                      _symbolChartBloc.add(
                        SymbolChangeChartCurrencyEvent(),
                      );
                      _symbolChartBloc.add(
                        GetDataEvent(
                          symbolName: widget.symbolName,
                        ),
                      );
                    }
                  },
                  onTypeChanged: (chartType) {
                    Navigator.pop(context);
                    if (chartType != state.chartType) {
                      _symbolChartBloc.add(
                        SetChartTypeEvent(
                          chartType: chartType,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(
                  height: Grid.l,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
