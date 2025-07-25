import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_tile.dart';
import 'package:piapiri_v2/app/alarm/widgets/no_alarms.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NewsAlarms extends StatefulWidget {
  final List<NewsAlarm> newsAlarms;

  const NewsAlarms({
    super.key,
    required this.newsAlarms,
  });

  @override
  State<NewsAlarms> createState() => _NewsAlarmsState();
}

class _NewsAlarmsState extends State<NewsAlarms> {
  late final AlarmBloc _alarmBloc;

  @override
  void initState() {
    _alarmBloc = getIt<AlarmBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.newsAlarms.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.s,
            ),
            child: NoAlarms(
              message: 'no_active_news_alarm_desc',
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
                    fromNewsAlarm: true,
                    isCheckbox: true,
                    onTapSymbol: (symbolModelList) {
                      _alarmBloc.add(
                        SetNewsAlarmEvent(
                          symbolName: symbolModelList[0].name,
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
                  ],
                );
              },
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.newsAlarms.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (BuildContext context, int index) => const PDivider(),
                  itemBuilder: (context, index) {
                    return AlarmTile(
                      height: 64,
                      alarm: widget.newsAlarms[index],
                      symbolType: widget.newsAlarms[index].symbolType,
                      underlyingName: widget.newsAlarms[index].underlyingName,
                      subTitle: widget.newsAlarms[index].description,
                    );
                  },
                ),
              ),
              generalButtonPadding(
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
                          selectedSymbolList: widget.newsAlarms
                              .map(
                                (e) => SymbolModel(
                                  name: e.symbol,
                                  typeCode: e.symbolType,
                                ),
                              )
                              .toList(),
                          fromNewsAlarm: true,
                          filterList: SymbolSearchFilterEnum.values
                              .where(
                                (e) =>
                                    e != SymbolSearchFilterEnum.foreign &&
                                    e != SymbolSearchFilterEnum.fund &&
                                    e != SymbolSearchFilterEnum.etf,
                              )
                              .toList(),
                          isCheckbox: true,
                          onTapSymbol: (symbolModelList) {
                            _alarmBloc.add(
                              SetNewsAlarmEvent(
                                symbolName: symbolModelList[0].name,
                              ),
                            );
                          },
                          onTapDeleteSymbol: (symbolModelList) {
                            List<NewsAlarm> deleteNewAlarmList =
                                widget.newsAlarms.where((e) => e.symbol == symbolModelList[0].name).toList();

                            _alarmBloc.add(
                              RemoveAlarmEvent(
                                id: deleteNewAlarmList[0].id,
                                callback: () {
                                  _alarmBloc.add(
                                    GetAlarmsEvent(),
                                  );
                                },
                              ),
                            );
                          }),
                    );
                    getIt<Analytics>().track(
                      AnalyticsEvents.alarmKurClick,
                      taxonomy: [
                        InsiderEventEnum.controlPanel.value,
                        InsiderEventEnum.homePage.value,
                        InsiderEventEnum.alarmPage.value,
                        InsiderEventEnum.setNewAlarm.value,
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
