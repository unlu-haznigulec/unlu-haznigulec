import 'package:collection/collection.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class MarketCarouselAlpacaItem extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;
  const MarketCarouselAlpacaItem({
    super.key,
    required this.symbolName,
    required this.symbolType,
  });

  @override
  State<MarketCarouselAlpacaItem> createState() => _MarketCarouselAlpacaItemState();
}

class _MarketCarouselAlpacaItemState extends State<MarketCarouselAlpacaItem> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  late USSymbolModel _usSymbolModel;

  @override
  initState() {
    super.initState();
    _usSymbolModel =
        _usEquityBloc.state.watchingItems.firstWhereOrNull((element) => element.symbol == widget.symbolName) ??
            USSymbolModel(
              symbol: widget.symbolName,
            );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
        bloc: _usEquityBloc,
        listenWhen: (previous, current) {
          USSymbolModel? currenctSymbolModel =
              current.watchingItems.firstWhereOrNull((element) => element.symbol == widget.symbolName);
          USSymbolModel? previousSymbolModel =
              previous.watchingItems.firstWhereOrNull((element) => element.symbol == widget.symbolName);
          return currenctSymbolModel != null && currenctSymbolModel != previousSymbolModel;
        },
        listener: (context, state) {
          setState(() {
            _usSymbolModel = state.watchingItems.firstWhere((element) => element.symbol == widget.symbolName);
          });
        },
        builder: (context, state) {
          double differencePercent =
              (((_usSymbolModel.trade?.price ?? 0) - (_usSymbolModel.previousDailyBar?.close ?? 0)) /
                      (_usSymbolModel.previousDailyBar?.close ?? 1)) *
                  100;
          differencePercent = (differencePercent * 100).roundToDouble() / 100;

          double price = _usSymbolModel.trade?.price ?? 0;
          double priceWidth = (CurrencyEnum.turkishLira.symbol + MoneyUtils().readableMoney(price)).calculateTextWidth(
            textStyle: context.pAppStyle.labelReg12textPrimary.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          );
          double diffPriceWidth = Grid.m +
              Grid.xxs +
              ('%${MoneyUtils().readableMoney(differencePercent)}').calculateTextWidth(
                textStyle: context.pAppStyle.labelReg12textPrimary.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              );
          return IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Grid.xs),
              child: Container(
                padding: const EdgeInsets.all(Grid.xs),
                decoration: BoxDecoration(
                  color: differencePercent == 0
                      ? context.pColorScheme.iconPrimary.withOpacity(.15)
                      : differencePercent > 0
                          ? context.pColorScheme.success.withOpacity(.15)
                          : context.pColorScheme.critical.withOpacity(.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    SymbolIcon(
                      symbolName: widget.symbolName,
                      symbolType: widget.symbolType,
                      size: 28,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: priceWidth > diffPriceWidth ? priceWidth : diffPriceWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.symbolType == SymbolTypes.foreign ? CurrencyEnum.dollar.symbol : CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(price)}',
                            style: context.pAppStyle.labelReg12textPrimary,
                          ),
                          DiffPercentage(
                            percentage: differencePercent,
                            fontSize: Grid.l / 2,
                            iconSize: Grid.m - Grid.xxs,
                            rowMainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: Grid.s,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
