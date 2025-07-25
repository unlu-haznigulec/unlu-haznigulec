import 'package:piapiri_v2/core/model/chart_model.dart';

class SymbolChartConstants {
  Map<ChartFilter, Duration> filterData = {
    ChartFilter.oneMinute: const Duration(
      minutes: 1,
    ),
    ChartFilter.oneHour: const Duration(
      minutes: 60,
    ),
    ChartFilter.oneDay: const Duration(
      days: 1,
    ),
    ChartFilter.oneWeek: const Duration(
      days: 7,
    ),
    ChartFilter.oneMonth: const Duration(
      days: 30,
    ),
    ChartFilter.oneYear: const Duration(
      days: 365,
    ),
  };
}
