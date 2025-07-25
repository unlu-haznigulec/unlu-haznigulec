import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/alarm/enum/price_alarm_filter.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_tile.dart';
import 'package:piapiri_v2/app/alarm/widgets/no_alarms.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PriceAlarms extends StatefulWidget {
  final List<PriceAlarm> priceAlarms;

  const PriceAlarms({
    super.key,
    required this.priceAlarms,
  });

  @override
  State<PriceAlarms> createState() => _PriceAlarmsState();
}

class _PriceAlarmsState extends State<PriceAlarms> {
  PriceAlarmFilter _selectedFilter = PriceAlarmFilter.pending;

  @override
  Widget build(BuildContext context) {
    return widget.priceAlarms.isEmpty
        ? NoAlarms(
            message: 'no_active_price_alarm_desc',
            onPressed: () {
              router.push(
                SymbolSearchRoute(
                  appBarTitle: L10n.tr('alarm_kur'),
                  filterList: SymbolSearchFilterEnum.values
                      .where(
                        (e) =>
                            e != SymbolSearchFilterEnum.foreign &&
                            e != SymbolSearchFilterEnum.fund &&
                            e != SymbolSearchFilterEnum.etf,
                      )
                      .toList(),
                  onTapSymbol: (symbolModelList) {
                    router.push(
                      CreatePriceNewsAlarmRoute(
                        symbol: symbolModelList[0],
                      ),
                    );
                  },
                ),
              );

              getIt<Analytics>().track(
                AnalyticsEvents.alarmKurClick,
                taxonomy: [
                  InsiderEventEnum.controlPanel.value,
                  InsiderEventEnum.homePage.value,
                  InsiderEventEnum.alarmPage.value,
                  InsiderEventEnum.priceAlarm.value,
                ],
              );
            },
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Grid.s,
                  bottom: Grid.xs,
                  left: Grid.m,
                ),
                child: PCustomOutlinedButtonWithIcon(
                  text: L10n.tr(_selectedFilter.name),
                  iconSource: ImagesPath.chevron_down,
                  onPressed: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('alarm_price'),
                      child: Column(
                        children: PriceAlarmFilter.values.map((filter) {
                          return FilterCategoryButton(
                            title: L10n.tr(
                              filter.name,
                            ),
                            isSelected: _selectedFilter == filter,
                            hasDivider: filter != PriceAlarmFilter.values.last,
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;

                                router.maybePop();
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              const PDivider(
                padding: EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.s + Grid.xs,
                  horizontal: Grid.m,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${L10n.tr('asset')} (${_selectedFilter == PriceAlarmFilter.pending ? widget.priceAlarms.where((e) => e.isActive).toList().length : widget.priceAlarms.where((e) => !e.isActive).toList().length})',
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    ),
                    Text(
                      L10n.tr('current_price'),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    const SizedBox(
                      width: 42,
                    ),
                    Text(
                      L10n.tr('alarm_price'),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
              ),
              const PDivider(
                padding: EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
              ),
              _selectedFilter == PriceAlarmFilter.pending
                  ? _pendingList(
                      widget.priceAlarms.where((e) => e.isActive).toList(),
                    )
                  : _completedList(
                      widget.priceAlarms.where((e) => !e.isActive).toList(),
                    ),
              _selectedFilter == PriceAlarmFilter.pending && !widget.priceAlarms.any((e) => e.isActive) ||
                      _selectedFilter == PriceAlarmFilter.completed && widget.priceAlarms.any((e) => e.isActive)
                  ? const SizedBox.shrink()
                  : generalButtonPadding(
                      context: context,
                      leftPadding: 0,
                      rightPadding: 0,
                      child: PButton(
                        text: L10n.tr('yeni_alarm_kur'),
                        fillParentWidth: true,
                        onPressed: () {
                          router.push(
                            SymbolSearchRoute(
                              appBarTitle: L10n.tr('yeni_alarm_kur'),
                              filterList: SymbolSearchFilterEnum.values
                                  .where(
                                    (e) =>
                                        e != SymbolSearchFilterEnum.foreign &&
                                        e != SymbolSearchFilterEnum.fund &&
                                        e != SymbolSearchFilterEnum.etf,
                                  )
                                  .toList(),
                              onTapSymbol: (symbolModelList) {
                                router.push(
                                  CreatePriceNewsAlarmRoute(
                                    symbol: symbolModelList[0],
                                  ),
                                );
                              },
                            ),
                          );
                          getIt<Analytics>().track(
                            AnalyticsEvents.alarmKurClick,
                            taxonomy: [
                              InsiderEventEnum.controlPanel.value,
                              InsiderEventEnum.homePage.value,
                              InsiderEventEnum.alarmPage.value,
                              InsiderEventEnum.priceAlarm.value,
                              InsiderEventEnum.setNewAlarm.value,
                            ],
                          );
                        },
                      ),
                    ),
            ],
          );
  }

  Widget _pendingList(
    List<PriceAlarm> alarmList,
  ) {
    return Expanded(
      child: alarmList.isEmpty
          ? NoAlarms(
              message: 'no_active_price_alarm_desc',
              onPressed: () {
                router.push(
                  SymbolSearchRoute(
                    appBarTitle: L10n.tr('alarm_kur'),
                    filterList: SymbolSearchFilterEnum.values
                        .where(
                          (e) =>
                              e != SymbolSearchFilterEnum.foreign &&
                              e != SymbolSearchFilterEnum.fund &&
                              e != SymbolSearchFilterEnum.etf,
                        )
                        .toList(),
                    onTapSymbol: (symbolModelList) {
                      router.push(
                        CreatePriceNewsAlarmRoute(
                          symbol: symbolModelList[0],
                        ),
                      );
                    },
                  ),
                );

                getIt<Analytics>().track(
                  AnalyticsEvents.alarmKurClick,
                  taxonomy: [
                    InsiderEventEnum.controlPanel.value,
                    InsiderEventEnum.homePage.value,
                    InsiderEventEnum.alarmPage.value,
                    InsiderEventEnum.priceAlarm.value,
                  ],
                );
              },
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: alarmList.length,
              padding: EdgeInsets.zero,
              separatorBuilder: (BuildContext context, int index) => const PDivider(),
              itemBuilder: (context, index) {
                return AlarmTile(
                  height: 48,
                  alarm: alarmList[index],
                  fromPriceAlarm: true,
                  symbolType: alarmList[index].symbolType,
                  underlyingName: alarmList[index].underlyingName,
                  hasDivider: alarmList[index] != alarmList.last,
                  description: alarmList[index].description,
                );
              },
            ),
    );
  }

  Widget _completedList(
    List<PriceAlarm> alarmList,
  ) {
    return Expanded(
      child: alarmList.isEmpty
          ? NoAlarms(
              message: 'no_active_price_alarm_desc',
              onPressed: () {
                router.push(
                  SymbolSearchRoute(
                    appBarTitle: L10n.tr('alarm_kur'),
                    filterList: SymbolSearchFilterEnum.values
                        .where(
                          (e) =>
                              e != SymbolSearchFilterEnum.foreign &&
                              e != SymbolSearchFilterEnum.fund &&
                              e != SymbolSearchFilterEnum.etf,
                        )
                        .toList(),
                    onTapSymbol: (symbolModelList) {
                      router.push(
                        CreatePriceNewsAlarmRoute(
                          symbol: symbolModelList[0],
                        ),
                      );
                    },
                  ),
                );

                getIt<Analytics>().track(
                  AnalyticsEvents.alarmKurClick,
                  taxonomy: [
                    InsiderEventEnum.controlPanel.value,
                    InsiderEventEnum.homePage.value,
                    InsiderEventEnum.alarmPage.value,
                    InsiderEventEnum.priceAlarm.value,
                  ],
                );
              },
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: alarmList.length,
              separatorBuilder: (BuildContext context, int index) => const PDivider(),
              itemBuilder: (context, index) {
                return AlarmTile(
                  height: 48,
                  alarm: alarmList[index],
                  fromPriceAlarm: true,
                  symbolType: alarmList[index].symbolType,
                  underlyingName: alarmList[index].underlyingName,
                  description: alarmList[index].description,
                );
              },
            ),
    );
  }
}
