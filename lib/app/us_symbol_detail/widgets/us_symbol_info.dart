import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/price_info_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/latest_trade_mixed_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class UsSymbolInfo extends StatefulWidget {
  final USSymbolModel symbol;
  final LatestTradeMixedModel latestTrade;
  final UsMarketStatus usMarketStatus;

  const UsSymbolInfo({
    super.key,
    required this.symbol,
    required this.usMarketStatus,
    required this.latestTrade,
  });

  @override
  State<UsSymbolInfo> createState() => _UsSymbolInfoState();
}

class _UsSymbolInfoState extends State<UsSymbolInfo> {
  double _differencePercent = 0;
  double _lastestDifferencePercent = 0;
  // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
  // late AdvicesBloc _advicesBloc;

  @override
  void initState() {
    differencePercent();
    // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
    // _advicesBloc = getIt<AdvicesBloc>();
    // if (getIt<AuthBloc>().state.isLoggedIn) {
    //   _advicesBloc.add(
    //     GetAdvicesEvent(
    //       symbolName: widget.symbol.symbol ?? '',
    //       mainGroup: MarketTypeEnum.marketUs.value,
    //     ),
    //   );
    //   _advicesBloc.add(
    //     GetAdviceHistoryEvent(
    //       symbolName: widget.symbol.symbol ?? '',
    //       mainGroup: MarketTypeEnum.marketUs.value,
    //     ),
    //   );
    // }

    super.initState();
  }

  differencePercent() {
    setState(() {
      if (widget.symbol.previousDailyBar != null) {
        _differencePercent = ((widget.symbol.trade!.price! - widget.symbol.previousDailyBar!.close!) /
                widget.symbol.previousDailyBar!.close!) *
            100;

        if (widget.usMarketStatus == UsMarketStatus.closed) {
          _differencePercent = ((widget.symbol.currentDailyBar!.close! - widget.symbol.previousDailyBar!.close!) /
                  widget.symbol.previousDailyBar!.close!) *
              100;
        }
      }

      if ((widget.usMarketStatus == UsMarketStatus.afterMarket || widget.usMarketStatus == UsMarketStatus.preMarket) &&
          widget.latestTrade.price != null) {
        _lastestDifferencePercent = ((widget.latestTrade.price! - widget.symbol.currentDailyBar!.close!) /
                widget.symbol.currentDailyBar!.close!) *
            100;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    differencePercent();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SymbolIcon(
                symbolName: widget.symbol.symbol!,
                symbolType: SymbolTypes.foreign,
                size: 30,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15,
                      child: Text(
                        widget.symbol.trade?.symbol ?? '',
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.symbol.asset?.name?.toUpperCase() ?? '',
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
              ),
              // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
              // PBlocBuilder<AdvicesBloc, AdvicesState>(
              //   bloc: _advicesBloc,
              //   builder: (context, state) {
              //     if (state.advicesState == PageState.loading) {
              //       return const PLoading();
              //     }

              //     Color? iconColor;

              //     if (state.adviceBySymbolNameList.isNotEmpty) {
              //       if (state.adviceBySymbolNameList[0].adviceSideId == 1) {
              //         iconColor = context.pColorScheme.success;
              //       } else {
              //         iconColor = context.pColorScheme.critical;
              //       }
              //     } else if (state.adviceHistoryModel.closedAdvices != null &&
              //         state.adviceHistoryModel.closedAdvices!.isNotEmpty) {
              //       iconColor = context.pColorScheme.iconPrimary;
              //     }

              //     return iconColor == null
              //         ? const SizedBox.shrink()
              //         : InkWell(
              //             onTap: () {
              //               router.push(
              //                 AdvicesRoute(
              //                   symbol: MarketListModel(
              //                     symbolCode: widget.symbol.trade?.symbol ?? '',
              //                     updateDate: DateTime.now().toIso8601String(),
              //                   ),
              //                   advices: state.adviceBySymbolNameList,
              //                   closedAdvices: state.adviceHistoryModel.closedAdvices ?? [],
              //                   isUsOrder: true,
              //                 ),
              //               );
              //             },
              //             child: SvgPicture.asset(
              //               ImagesPath.oneri,
              //               width: 20,
              //               height: 20,
              //               colorFilter: ColorFilter.mode(
              //                 iconColor,
              //                 BlendMode.srcIn,
              //               ),
              //             ),
              //           );
              //   },
              // ),
              // const SizedBox(
              //   width: Grid.s,
              // ),
              // if (_precautionList.isNotEmpty)
              //   InkWell(
              //     splashColor: Colors.transparent,
              //     highlightColor: Colors.transparent,
              //     onTap: () {
              //       PBottomSheet.show(
              //         context,
              //         title: L10n.tr('precautions_list'),
              //         child: PrecautionWidget(
              //           precautionList: _precautionList,
              //         ),
              //       );
              //     },
              //     child: SvgPicture.asset(
              //       ImagesPath.info_triangle,
              //       width: 20,
              //       height: 20,
              //     ),
              //   ),
              // const SizedBox(
              //   width: Grid.s,
              // ),
              // if (stringToSymbolType(widget.symbol.type) == SymbolTypes.equity)
              //   InkWell(
              //     splashColor: Colors.transparent,
              //     highlightColor: Colors.transparent,
              //     onTap: () {
              //       _symbolBloc.add(
              //         SymbolGetInfo(
              //           widget.symbol.symbolCode,
              //           (symbolInfo) => PBottomSheet.show(
              //             context,
              //             title: L10n.tr('hakkinda'),
              //             child: SymbolAbout(
              //               symbolInfo: symbolInfo,
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //     child: SvgPicture.asset(
              //       ImagesPath.info,
              //       width: 20,
              //       height: 20,
              //     ),
              //   ),
            ],
          ),
          const SizedBox(height: Grid.s + Grid.xxs),
          PriceInfoWidget(
            differencePercent: _differencePercent,
            lastestDifferencePercent: _lastestDifferencePercent,
            price: _getPrice(),
            usMarketStatus: widget.usMarketStatus,
            latestTrade: widget.latestTrade,
          ),
        ],
      ),
    );
  }

  String _getPrice() {
    double price = 0.0;

    if (widget.symbol.trade?.price != 0) {
      price = widget.symbol.trade!.price!;
    } else if (widget.symbol.currentDailyBar?.close != 0) {
      price = widget.symbol.currentDailyBar!.close!;
    } else if (widget.symbol.previousDailyBar?.close != 0) {
      price = widget.symbol.previousDailyBar!.close!;
    }

    return MoneyUtils().readableMoney(
      price,
      pattern: price >= 1 ? '#,##0.00' : '#,##0.0000#####',
    );
  }
}
