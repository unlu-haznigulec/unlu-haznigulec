import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_event.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_state.dart';
import 'package:piapiri_v2/app/eurobond/widgets/eurobond_list_tile.dart';
import 'package:piapiri_v2/app/eurobond/widgets/shimmer_eurobond_widget.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_widget.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/shimmerize.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EuroBondPage extends StatefulWidget {
  const EuroBondPage({super.key});

  @override
  State<EuroBondPage> createState() => _EuroBondPageState();
}

class _EuroBondPageState extends State<EuroBondPage> {
  late final AppInfoBloc _appInfoBloc;
  late final EuroBondBloc _euroBondBloc;
  late final TimeBloc _timeBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    Utils.setListPageEvent(pageName: 'EurobondPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.eurobondTab.value,
      ],
    );

    _appInfoBloc = getIt<AppInfoBloc>();
    _euroBondBloc = getIt<EuroBondBloc>();
    _timeBloc = getIt<TimeBloc>();
    _authBloc = getIt<AuthBloc>();

    if (_authBloc.state.isLoggedIn) {
      _euroBondBloc.add(
        GetBondListEvent(
          finInstId: '',
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_authBloc.state.isLoggedIn
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: CreateAccountWidget(
              memberMessage: L10n.tr('create_account_eurobond_alert'),
              loginMessage: L10n.tr('login_eurobond_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  activeIndex: 2,
                  marketMenu: MarketMenu.eurobond,
                ),
              ),
            ),
          )
        : PBlocBuilder<AppInfoBloc, AppInfoState>(
            bloc: _appInfoBloc,
            builder: (context, appInfoState) {
              return PBlocBuilder<EuroBondBloc, EuroBondState>(
                bloc: _euroBondBloc,
                builder: (context, euroBondState) {
                  DateTime now = _timeBloc.state.mxTime?.timestamp != null
                      ? DateTime.fromMicrosecondsSinceEpoch(_timeBloc.state.mxTime!.timestamp.toInt())
                          .add(const Duration(hours: 3))
                      : DateTime.now();
                  bool isMarketOpen = euroBondState.bondListModel != null &&
                      now.isAfter(DateTimeUtils.fromString(euroBondState.bondListModel!.transactionStartTime!)) &&
                      now.isBefore(DateTimeUtils.fromString(euroBondState.bondListModel!.transactionEndTime!));

                  if (euroBondState.isLoading || euroBondState.isInitial) {
                    return const Shimmerize(
                      enabled: true,
                      child: ShimmerEurobondWidget(),
                    );
                  }

                  if (euroBondState.bondListModel == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: Grid.m,
                      ),
                      const MarketCarouselWidget(),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              L10n.tr(
                                'eurobond_description_4',
                                args: [
                                  DateTimeUtils.timeFormat(
                                    DateTimeUtils.fromString(
                                      euroBondState.bondListModel!.transactionStartTime!,
                                    ),
                                  ),
                                ],
                              ),
                              style: context.pAppStyle.labelReg14textPrimary,
                            ),
                            const SizedBox(
                              height: Grid.m,
                            ),
                            const PDivider(),
                            const SizedBox(
                              height: Grid.s + Grid.xs,
                            ),
                            if (!isMarketOpen) ...[
                              PInfoWidget(
                                iconPath: ImagesPath.moon,
                                textColor: context.pColorScheme.textSecondary,
                                infoText: L10n.tr(
                                  'eurobond_description_3',
                                  args: [
                                    '${DateTimeUtils.timeFormat(
                                      DateTimeUtils.fromString(
                                        euroBondState.bondListModel!.transactionStartTime!,
                                      ),
                                    )}-${DateTimeUtils.timeFormat(
                                      DateTimeUtils.fromString(
                                        euroBondState.bondListModel!.transactionEndTime!,
                                      ),
                                    )}'
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: Grid.l / 2,
                              ),
                              const PDivider(),
                            ] else ...[
                              euroBondState.bondListModel?.bonds == null && euroBondState.bondListModel!.bonds!.isEmpty
                                  ? Text(
                                      L10n.tr('no_eurobond'),
                                      textAlign: TextAlign.start,
                                      style: context.pAppStyle.labelReg14textSecondary,
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              L10n.tr('eurobond'),
                                              style: context.pAppStyle.labelMed12textSecondary,
                                            ),
                                            Text(
                                              L10n.tr('buying_and_selling_prices'),
                                              style: context.pAppStyle.labelMed12textSecondary,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: Grid.s + Grid.xs,
                                        ),
                                        const PDivider(),
                                        ListView.separated(
                                          itemCount: euroBondState.bondListModel?.bonds?.length ?? 0,
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) => const PDivider(),
                                          itemBuilder: (context, index) {
                                            return EurobondListTile(
                                              bond: euroBondState.bondListModel!.bonds![index],
                                              transactionStartTime:
                                                  euroBondState.bondListModel!.transactionStartTime ?? '',
                                              transactionEndTime: euroBondState.bondListModel!.transactionEndTime ?? '',
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
  }
}
