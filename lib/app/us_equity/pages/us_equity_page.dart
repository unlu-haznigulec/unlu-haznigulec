import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_gainers.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_losers.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class UsLosersGainersPage extends StatefulWidget {
  final bool isLosers;
  const UsLosersGainersPage({super.key, this.isLosers = true});

  @override
  State<UsLosersGainersPage> createState() => _UsLosersGainersPageState();
}

class _UsLosersGainersPageState extends State<UsLosersGainersPage> {
  late UsEquityBloc _usEquityBloc;
  late Timer _timer;
  @override
  void initState() {
    Utils.setListPageEvent(pageName: 'UsLosersGainersPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.americanStockExchanges.value,
        InsiderEventEnum.equityTab.value,
      ],
    );

    _usEquityBloc = getIt<UsEquityBloc>();
    if (_usEquityBloc.state.losers.length <= 5 || _usEquityBloc.state.gainers.length <= 5) {
      _usEquityBloc.add(
        GetLosersGainersEvent(
          number: 50,
        ),
      );
    }
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        _usEquityBloc.add(
          GetLosersGainersEvent(
            number: 50,
          ),
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel(); // Sayfa kapanmadan önce timer'ı durdur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr(widget.isLosers ? 'us_equity.losers.all' : 'us_equity.gainers.all'),
          ),
          body: ListView(
            children: [
              widget.isLosers ? UsLosers(list: state.losers) : UsGainers(list: state.gainers),
            ],
          ),
        );
      },
    );
  }
}
