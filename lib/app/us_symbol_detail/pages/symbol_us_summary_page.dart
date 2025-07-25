import 'dart:async';

import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/market_review_list.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/dividend_detail_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/market_info_tile.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/symbol_us_chart.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_brief_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_symbol_info.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class SymbolUsSummary extends StatefulWidget {
  final USSymbolModel symbol;
  final UsMarketStatus? usMarketStatus;

  const SymbolUsSummary({
    super.key,
    required this.symbol,
    this.usMarketStatus = UsMarketStatus.closed,
  });

  @override
  State<SymbolUsSummary> createState() => _SymbolUsSummaryState();
}

class _SymbolUsSummaryState extends State<SymbolUsSummary> {
  Timer? _timer;
  late UsEquityBloc _usEquityBloc;
  late AppInfoBloc _appInfoBloc;
  late UsMarketStatus _marketStatus;

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _appInfoBloc = getIt<AppInfoBloc>();

    _marketStatus = widget.usMarketStatus ?? UsMarketStatus.closed;
    _appInfoBloc.add(
      GetUSClockEvent(onSuccessCallback: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            UsMarketStatus updatedMarketStatus = getMarketStatus();
            if (_marketStatus != updatedMarketStatus) {
              setState(
                () {
                  _marketStatus = updatedMarketStatus;
                  _onStartTimerForTrade();
                },
              );
            }
          },
        );
      }),
    );
    _usEquityBloc.add(
      GetHistoricalBarsDataEvent(
        symbols: widget.symbol.symbol!,
      ),
    );
    _usEquityBloc.add(
      GetLatestTradeMixedEvent(symbols: widget.symbol.symbol!),
    );
    _onStartTimerForTrade();
    super.initState();
  }

  _onStartTimerForTrade() {
    if (_marketStatus == UsMarketStatus.preMarket || _marketStatus == UsMarketStatus.afterMarket) {
      if (_timer?.isActive == true) _timer?.cancel();

      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _usEquityBloc.add(
          GetLatestTradeMixedEvent(symbols: widget.symbol.symbol!),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UsSymbolInfo(
                  key: Key(_marketStatus.toString()),
                  symbol: widget.symbol,
                  usMarketStatus: _marketStatus,
                  latestTrade: state.latestTradeMixed ?? LatestTradeMixedModel(),
                ),
                Row(
                  spacing: Grid.s,
                  children: [
                    Expanded(
                      child: MarketInfoTile(
                        usMarketStatus: _marketStatus,
                      ),
                    ),
                    InkWell(
                      child: SvgPicture.asset(
                        ImagesPath.arrows_diagonal,
                        width: 18,
                        height: 18,
                      ),
                      onTap: () => router.push(
                        TradingviewRoute(
                          symbol: widget.symbol.symbol ?? '',
                          exchangeName: widget.symbol.asset?.exchangeName ?? 'NASDAQ',
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: Grid.l,
                ),
                SymbolUsChart(
                  symbol: widget.symbol.symbol!,
                ),
                const SizedBox(
                  height: Grid.l,
                ),
                if (widget.symbol.currentDailyBar != null && widget.symbol.previousDailyBar != null) ...[
                  UsBrief(
                    data: widget.symbol.currentDailyBar!,
                    previousDailyData: widget.symbol.previousDailyBar!,
                  ),
                ],
                DividendDetailWidget(
                  symbol: widget.symbol.trade?.symbol ?? '',
                ),
                MarketReviewList(
                  symbolName: widget.symbol.symbol ?? '',
                  mainGroup: MarketTypeEnum.marketUs.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
