import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/symbol_chart/utils/symbol_chart_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';

import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SymbolChart extends StatelessWidget {
  final String symbolName;
  final ChartType chartType;
  final bool isFailed;
  final bool isLoading;
  final ChartFilter selectedFilter;
  final CurrencyEnum chartCurrency;
  final List<ChartData> chartData;

  const SymbolChart({
    super.key,
    required this.symbolName,
    this.chartType = ChartType.area,
    this.isFailed = false,
    this.isLoading = false,
    this.selectedFilter = ChartFilter.oneDay,
    this.chartCurrency = CurrencyEnum.turkishLira,
    this.chartData = const [],
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormatXAxis = SymbolChartUtils().handleXAxisTypeForSFCartesianChart(selectedFilter);
    return SizedBox(
      height: 230.0,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0, // Grafiğin etrafındaki çerçeve çizgisini kaldırır
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          zoomMode: ZoomMode.x,
          enablePanning: true,
        ),
        crosshairBehavior: CrosshairBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: false,
          lineDashArray: const [5, 5],
          lineType: CrosshairLineType.both,
          lineColor: context.pColorScheme.primary,
          lineWidth: 0.5,
        ),
        trackballBehavior: TrackballBehavior(
          lineColor: Colors.transparent,
          enable: true,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: false,
          markerSettings: TrackballMarkerSettings(
            height: 14,
            width: 14,
            markerVisibility: TrackballVisibilityMode.visible,
            borderColor: context.pColorScheme.backgroundColor,
            borderWidth: 6,
            color: context.pColorScheme.primary,
          ),
          tooltipSettings: InteractiveTooltip(
            color: context.pColorScheme.backgroundColor,
            borderColor: context.pColorScheme.primary,
          ),
          builder: (context, trackballDetails) {
            if (trackballDetails.pointIndex == null) return const SizedBox();
            ChartData data = chartData[trackballDetails.pointIndex!];
            return Container(
              decoration: BoxDecoration(
                color: context.pColorScheme.backgroundColor,
                borderRadius: BorderRadius.circular(Grid.s),
                border: Border.all(
                  color: context.pColorScheme.primary,
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.s,
                vertical: Grid.s,
              ),
              child: Column(
                spacing: Grid.xs,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.date != null ? DateTimeUtils.dateFormat(data.date!) : '',
                    style: context.pAppStyle.labelMed12textPrimary,
                  ),
                  if (chartType != ChartType.area)
                    Text(
                      '${L10n.tr('chartOpen')}: ${data.close == null ? '-' : '${chartCurrency.symbol}${MoneyUtils().readableMoney(data.open ?? 0)}'}',
                      style: context.pAppStyle.labelMed12textPrimary,
                    ),
                  Text(
                    '${L10n.tr('chartClose')}: ${data.close == null ? '-' : '${chartCurrency.symbol}${MoneyUtils().readableMoney(data.close ?? 0)}'}',
                    style: context.pAppStyle.labelMed12textPrimary,
                  ),
                  if (chartType != ChartType.area)
                    Text(
                      '${L10n.tr('chartHigh')}: ${data.close == null ? '-' : '${chartCurrency.symbol}${MoneyUtils().readableMoney(data.high ?? 0)}'}',
                      style: context.pAppStyle.labelMed12textPrimary,
                    ),
                  if (chartType != ChartType.area)
                    Text(
                      '${L10n.tr('chartLow')}: ${data.close == null ? '-' : '${chartCurrency.symbol}${MoneyUtils().readableMoney(data.low ?? 0)}'}',
                      style: context.pAppStyle.labelMed12textPrimary,
                    ),
                ],
              ),
            );
          },
        ),
        primaryXAxis: DateTimeCategoryAxis(
          dateFormat: dateFormatXAxis,
          labelAlignment: LabelAlignment.start,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0), // Y eksenindeki grid çizgilerini kaldırır
          axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
          labelStyle: context.pAppStyle.labelLig12textTeritary,
          interactiveTooltip: InteractiveTooltip(
            color: context.pColorScheme.backgroundColor,
            borderColor: context.pColorScheme.primary,
            textStyle: context.pAppStyle.labelMed12textPrimary,
          ),
          majorTickLines: MajorTickLines(
            color: context.pColorScheme.transparent,
          ),
        ),
        primaryYAxis: NumericAxis(
          anchorRangeToVisiblePoints: true,
          enableAutoIntervalOnZooming: true,
          rangePadding: ChartRangePadding.round,
          axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
          majorGridLines: MajorGridLines(
            color: context.pColorScheme.textQuaternary,
            dashArray: const [1, 16],
            width: 1,
          ),
          interactiveTooltip: InteractiveTooltip(
            color: context.pColorScheme.backgroundColor,
            borderColor: context.pColorScheme.primary,
            textStyle: context.pAppStyle.labelMed12textPrimary,
          ),
          labelStyle: context.pAppStyle.labelLig12textTeritary,
        ),
        series: <CartesianSeries>[
          if (chartType == ChartType.area)
            AreaSeries<ChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 0,
              xValueMapper: (ChartData sales, _) => sales.date,
              yValueMapper: (ChartData sales, _) => sales.close,
              borderWidth: 2,
              borderColor: context.pColorScheme.primary,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.pColorScheme.primary.withOpacity(.2),
                  context.pColorScheme.primary.withOpacity(.05),
                ],
              ),
            ),
          if (chartType == ChartType.ohlc)
            HiloOpenCloseSeries<ChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 0,
              bearColor: context.pColorScheme.critical,
              bullColor: context.pColorScheme.success,
              xValueMapper: (ChartData sales, _) => sales.date,
              lowValueMapper: (ChartData sales, _) => sales.low,
              highValueMapper: (ChartData sales, _) => sales.high,
              openValueMapper: (ChartData sales, _) => sales.open,
              closeValueMapper: (ChartData sales, _) => sales.close,
            ),
          if (chartType == ChartType.candle)
            CandleSeries<ChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 0,
              bearColor: context.pColorScheme.critical,
              bullColor: context.pColorScheme.success,
              enableSolidCandles: true,
              xValueMapper: (ChartData data, _) => data.date,
              openValueMapper: (ChartData data, _) => data.open,
              highValueMapper: (ChartData data, _) => data.high,
              lowValueMapper: (ChartData data, _) => data.low,
              closeValueMapper: (ChartData data, _) => data.close,
              onRendererCreated: (ChartSeriesController controller) {},
            ),
        ],
      ),
    );
  }
}
