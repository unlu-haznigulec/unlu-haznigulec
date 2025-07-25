import 'package:auto_route/auto_route.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_chart/utils/symbol_chart_utils.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/symbol_compare_chart.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/symbol_compare_list.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class SymbolComparePage extends StatefulWidget {
  final String symbolName;
  final String underLyingName;
  final String? subType;
  final String description;
  final SymbolTypes symbolType;
  const SymbolComparePage({
    super.key,
    required this.symbolName,
    required this.underLyingName,
    this.subType,
    required this.description,
    required this.symbolType,
  });

  @override
  State<SymbolComparePage> createState() => _SymbolComparePageState();
}

class _SymbolComparePageState extends State<SymbolComparePage> {
  final int _maxSelectedCount = 5;
  late SymbolChartBloc _symbolChartBloc;
  late FundBloc _fundBloc;
  final List<ChartFilter> _chartFilterList = ChartFilter.values
      .where(
        (e) => e != ChartFilter.oneMinute && e != ChartFilter.oneHour && e != ChartFilter.oneDay,
      )
      .toList();
  @override
  initState() {
    super.initState();
    _symbolChartBloc = getIt<SymbolChartBloc>();
    _fundBloc = getIt<FundBloc>();
    _symbolChartBloc.add(
      GetPerformanceEvent(
        performanceFilter: ChartFilter.oneWeek,
        chartPerformanceModels: [
          ChartPerformanceModel(
            symbolName: widget.symbolName,
            underlyingName: widget.underLyingName,
            subType: widget.subType,
            description: widget.description,
            symbolType: widget.symbolType,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('symbol_compare'),
      ),
      body: PBlocBuilder<SymbolChartBloc, SymbolChartState>(
          bloc: _symbolChartBloc,
          builder: (context, state) {
            if (state.isLoading) return const PLoading();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Grid.m,
                    ),
                    // Sembol karsilastirma chart widget
                    Builder(
                      builder: (context) {
                        // Fonlarda perice üzerinden hesaplama yapıldığı için ilk değer her zaman 0 geliyor.
                        List<ChartPerformanceModel> performanceData = state.performanceData;
                        if (widget.symbolType != SymbolTypes.fund && performanceData.isNotEmpty) {
                          for (var element in performanceData) {
                            if (element.data?.isNotEmpty == true) {
                              element.data!.insert(
                                0,
                                ChartPerformanceData(
                                  element.data?.first.date!.subtract(const Duration(days: 1)),
                                  0,
                                ),
                              );
                            }
                          }
                        }
                        return SymbolCompareChart(
                          performanceData: performanceData,
                          selectedPerformanceFilter: state.selectedPerformanceFilter,
                        );
                      },
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    // Tarih secimi yapilan widget
                    SizedBox(
                      height: 30,
                      child: SlidingSegment(
                        initialSelectedSegment: _chartFilterList.indexOf(
                          state.selectedPerformanceFilter,
                        ),
                        slidingSegmentWidth: MediaQuery.sizeOf(context).width - (Grid.xl - Grid.xs),
                        backgroundColor: context.pColorScheme.card,
                        slidingSegmentRadius: Grid.m,
                        dividerColor: context.pColorScheme.transparent,
                        selectedTextStyle: context.pAppStyle.labelMed14textPrimary,
                        unSelectedTextStyle: context.pAppStyle.labelMed14textTeritary,
                        segmentList: _chartFilterList
                            .map(
                              (e) => PSlidingSegmentItem(
                                segmentTitle: L10n.tr(
                                  e.performanceLocalizationKey,
                                ),
                                segmentColor: context.pColorScheme.backgroundColor,
                              ),
                            )
                            .toList(),
                        onValueChanged: (int value) {
                          _symbolChartBloc.add(
                            GetPerformanceEvent(
                              chartPerformanceModels: state.performanceData,
                              performanceFilter: _chartFilterList[value],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: Grid.l,
                    ),
                    Text(
                      L10n.tr('asset_performance'),
                      style: context.pAppStyle.labelMed18textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(L10n.tr('symbol'), style: context.pAppStyle.labelMed12textPrimary),
                        Text(
                          L10n.tr(
                            SymbolChartUtils().performanceChartDuration(
                              state.selectedPerformanceFilter,
                            ),
                          ),
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    const PDivider(),
                    // Sembol karsilastirma list widget
                    SymbolCompareList(
                      performanceData: state.performanceData,
                    ),
                    if (state.performanceData.length < 5) ...{
                      PCustomPrimaryTextButton(
                        margin: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        text: L10n.tr('sembol_ekle'),
                        iconSource: ImagesPath.plus,
                        onPressed: () async {
                          SymbolSearchFilterEnum selectedFilter = state.performanceData.isNotEmpty
                              ? SymbolSearchFilterEnum.values
                                      .where(
                                        (e) =>
                                            e.dbKeys?[0].toLowerCase() ==
                                            state.performanceData.first.symbolType.dbKey.toLowerCase(),
                                      )
                                      .firstOrNull ??
                                  SymbolSearchFilterEnum.all
                              : SymbolSearchFilterEnum.all;
                          List<List<SymbolModel>>? result = await router.push(
                            SymbolSearchRoute(
                              isCheckbox: true,
                              maxSelectedCount: _maxSelectedCount,
                              selectedFilter: selectedFilter,
                              fromPerformanceCompare: true,
                              appBarTitle: L10n.tr('add_symbol'),
                              selectedSymbolList: state.performanceData
                                  .map(
                                    (e) => SymbolModel(
                                      name: e.symbolName,
                                      typeCode: e.symbolType.dbKey,
                                    ),
                                  )
                                  .toList(),
                              filterList: const [
                                SymbolSearchFilterEnum.equity,
                                SymbolSearchFilterEnum.warrant,
                                SymbolSearchFilterEnum.endeks,
                                SymbolSearchFilterEnum.foreign,
                                SymbolSearchFilterEnum.fund,
                              ],
                              onTapSymbol: (List<SymbolModel> symbolList) async {
                                SymbolModel symbol = symbolList.first;
                                SymbolTypes symbolType = stringToSymbolType(
                                  symbol.typeCode,
                                );
                                if (symbolType == SymbolTypes.fund) {
                                  _fundBloc.add(
                                    GetDetailEvent(
                                      fundCode: symbol.name,
                                      callBack: (fundDetail) {
                                        _symbolChartBloc.add(
                                          AddPerformanceEvent(
                                            chartPerformance: ChartPerformanceModel(
                                              symbolName: symbol.name,
                                              underlyingName: fundDetail.institutionCode,
                                              subType: fundDetail.subType,
                                              description: '${fundDetail.code} • ${fundDetail.founder}',
                                              symbolType: stringToSymbolType(
                                                symbol.typeCode,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  SymbolModel symbol = symbolList.first;
                                  _symbolChartBloc.add(
                                    AddPerformanceEvent(
                                      chartPerformance: ChartPerformanceModel(
                                        symbolName: symbol.name,
                                        underlyingName: symbol.underlyingName,
                                        description: symbol.description,
                                        symbolType: stringToSymbolType(
                                          symbol.typeCode,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              onTapDeleteSymbol: (List<SymbolModel> symbolList) {
                                SymbolModel symbol = symbolList.first;
                                getIt<SymbolChartBloc>().add(
                                  RemovePerformanceEvent(
                                    symbolName: symbol.name,
                                  ),
                                );
                              },
                            ),
                          );
                          await Future.delayed(const Duration(milliseconds: 250)).then(
                            (_) {
                              if (result?.first.isNotEmpty == true) {
                                List<String> missingSymbols = [];
                                for (var symbol in result!.first) {
                                  if (!_symbolChartBloc.state.performanceData.any(
                                      (e) => e.symbolName == symbol.name && e.symbolType.dbKey == symbol.typeCode)) {
                                    missingSymbols.add('"${symbol.name}"');
                                  }
                                }
                                if (context.mounted && missingSymbols.isNotEmpty) {
                                  PBottomSheet.showError(
                                    context,
                                    content: L10n.tr(
                                      'selected_unsuccess_message',
                                      args: [
                                        missingSymbols.join(', '),
                                      ],
                                    ),
                                    showFilledButton: true,
                                    filledButtonText: L10n.tr('tamam'),
                                    onFilledButtonPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              }
                            },
                          );
                        },
                      )
                    }
                  ],
                ),
              ),
            );
          }),
    );
  }
}
