import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_populer.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_volumes.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class UsVolumePopulerPage extends StatefulWidget {
  final bool isVolume;
  const UsVolumePopulerPage({
    super.key,
    this.isVolume = true,
  });

  @override
  State<UsVolumePopulerPage> createState() => _UsVolumePopulerPageState();
}

class _UsVolumePopulerPageState extends State<UsVolumePopulerPage> {
  late UsEquityBloc _usEquityBloc;
  late Timer _timer;
  @override
  void initState() {
    Utils.setListPageEvent(pageName: 'UsVolumePopulerPage');
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
    if (_usEquityBloc.state.volumes.length <= 5 && widget.isVolume) {
      _usEquityBloc.add(
        GetVolumesEvent(
          number: 100,
        ),
      );
    }

    if (_usEquityBloc.state.populers.length <= 5 && !widget.isVolume) {
      _usEquityBloc.add(
        GetPopulersEvent(
          number: 100,
        ),
      );
    }
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (widget.isVolume) {
        _usEquityBloc.add(
          GetVolumesEvent(
            number: 100,
          ),
        );
      } else {
        _usEquityBloc.add(
          GetPopulersEvent(
            number: 100,
          ),
        );
      }
    });

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
            title: L10n.tr(widget.isVolume ? 'us_equity.all.volume' : 'us_equity.all.populer'),
          ),
          body: ListView(
            children: [
              widget.isVolume ? UsVolumes(list: state.volumes) : UsPopuler(list: state.populers),
            ],
          ),
        );
      },
    );
  }
}
