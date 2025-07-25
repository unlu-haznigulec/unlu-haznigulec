import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:device_orientation/device_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/symbol_chart/page/trading_view_android_page.dart';
import 'package:piapiri_v2/app/symbol_chart/page/trading_view_ios_widget.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

@RoutePage()
class TradingviewPage extends StatefulWidget {
  final String symbol;
  final Function? onBack;
  final DeviceOrientation? orientation;
  final String exchangeName;

  const TradingviewPage({
    super.key,
    required this.symbol,
    this.onBack,
    this.orientation,
    this.exchangeName = 'BIST',
  });

  @override
  State<TradingviewPage> createState() => _TradingviewPageState();
}

class _TradingviewPageState extends State<TradingviewPage> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  StreamSubscription<DeviceOrientation>? subscription;
  int quarterTurns = 0;

  @override
  void initState() {
    super.initState();
    if (widget.orientation != null) {
      quarterTurns = _decideQuarterTurns(widget.orientation!);
    }
    subscription = deviceOrientation$.listen((orientation) {
      setState(() {
        quarterTurns = _decideQuarterTurns(orientation);
      });
    });
  }

  @override
  void dispose() {
    _isLoading.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Scaffold(
        body: Padding(
          padding: _getPadding(),
          child: Stack(
            children: [
              SizedBox(
                width: _checkIsLandscape() ? MediaQuery.sizeOf(context).height : MediaQuery.sizeOf(context).width,
                height: _checkIsLandscape() ? MediaQuery.sizeOf(context).width : MediaQuery.sizeOf(context).height,
                child: PlatformUtils.isIos
                    ? TradingviewiOSWidget(
                        symbol: widget.symbol,
                        exchangeName: widget.exchangeName,
                      )
                    : TradingviewAndroidWidget(
                        symbol: widget.symbol,
                        exchangeName: widget.exchangeName,
                      ),
              ),
              Positioned(
                right: Grid.l,
                top: Grid.xxl,
                child: InkWell(
                  onTap: () {
                    widget.onBack?.call();
                    router.maybePop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Grid.s),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.pColorScheme.primary,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: context.pColorScheme.lightHigh,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkIsLandscape() {
    return quarterTurns.isOdd;
  }

  EdgeInsets _getPadding() {
    return _checkIsLandscape()
        ? const EdgeInsets.fromLTRB(kBottomNavigationBarHeight, 0, kToolbarHeight, 0)
        : const EdgeInsets.fromLTRB(0, kBottomNavigationBarHeight, 0, kToolbarHeight);
  }

  int _decideQuarterTurns(DeviceOrientation orientation) {
    switch (orientation) {
      case DeviceOrientation.portraitUp:
      case DeviceOrientation.portraitDown:
        return 0;
      case DeviceOrientation.landscapeRight:
        return 1;
      case DeviceOrientation.landscapeLeft:
        return 3;
    }
  }
}
