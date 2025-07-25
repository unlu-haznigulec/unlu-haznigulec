import 'dart:async';
import 'package:collection/collection.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsSymbolDividendCarouselWidget extends StatefulWidget {
  const UsSymbolDividendCarouselWidget({
    required this.symbolList,
    super.key,
  });

  final List<String> symbolList;

  @override
  State<UsSymbolDividendCarouselWidget> createState() => _UsSymbolDividendCarouselWidgetState();
}

class _UsSymbolDividendCarouselWidgetState extends State<UsSymbolDividendCarouselWidget> {
  late final UsEquityBloc _usEquityBloc;

  Timer? _scrollTimer;
  final ScrollController _scrollController = ScrollController();

  List<GlobalObjectKey> _keys = [];
  List<USSymbolModel> _symbolList = [];
  List<USSymbolModel> _watchingItems = [];

  void _onScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 100), _updateSubscriptions);
  }

  void _updateSubscriptions() {
    if (!mounted) return;

    final RenderBox? listViewBox = context.findRenderObject() as RenderBox?;
    if (listViewBox == null) return;

    final double listViewTop = listViewBox.localToGlobal(Offset.zero).dy;
    final double listViewBottom = listViewTop + listViewBox.size.height;

    Set<String> currentlyVisibleSymbols = {};

    for (USSymbolModel item in _symbolList) {
      final key = _keys[_symbolList.indexOf(item)];
      final RenderObject? renderObject = key.currentContext?.findRenderObject();

      if (renderObject is RenderBox) {
        final Offset offset = renderObject.localToGlobal(Offset.zero);
        final double itemTop = offset.dy;
        final double itemBottom = itemTop + renderObject.size.height;

        if (itemBottom > listViewTop && itemTop < listViewBottom) {
          currentlyVisibleSymbols.add(item.symbol!);
        }
      }
    }

    List<String> subscribeList =
        currentlyVisibleSymbols.difference(_watchingItems.map((e) => e.symbol!).toSet()).toList();
    List<String> unsubscribeList =
        _watchingItems.map((e) => e.symbol!).toSet().difference(currentlyVisibleSymbols).toList();
    _susbcribeList(subscribeList, unsubscribeList);
    _watchingItems = _symbolList.where((element) => currentlyVisibleSymbols.contains(element.symbol!)).toList();
  }

  void _susbcribeList(List<String> susbcribe, List<String> unSubscribe) {
    if (unSubscribe.isNotEmpty) {
      _usEquityBloc.add(
        UnsubscribeSymbolEvent(
          symbolName: unSubscribe.map((e) => e).toList(),
        ),
      );
    }

    if (susbcribe.isNotEmpty) {
      _usEquityBloc.add(
        SubscribeSymbolEvent(
          symbolName: susbcribe.map((e) => e).toList(),
        ),
      );
    }
  }

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _symbolList = widget.symbolList
        .map(
          (symbol) => USSymbolModel(
            symbol: symbol,
          ),
        )
        .toList();
    _keys = _symbolList
        .map(
          (e) => GlobalObjectKey(
            'fav_div_${e.symbol!}',
          ),
        )
        .toList();
    _scrollController.addListener(_onScroll);
    int watchItemsLength = 20;
    _watchingItems = _symbolList.length < watchItemsLength ? _symbolList : _symbolList.sublist(0, watchItemsLength);
    _susbcribeList(_watchingItems.map((e) => e.symbol!).toList(), []);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.l,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              L10n.tr('symbol_will_be_dist_divident'),
              style: context.pAppStyle.labelMed18textPrimary,
            ),
          ),
          Container(
            height: 60,
            color: context.pColorScheme.transparent,
            alignment: Alignment.center,
            child: NotificationListener<ScrollNotification>(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: _symbolList.length,
                separatorBuilder: (context, index) => const SizedBox(
                  width: Grid.s,
                ),
                itemBuilder: (context, index) {
                  USSymbolModel usSymbol = state.watchingItems.firstWhereOrNull(
                        (e) => e.symbol == _symbolList[index].symbol,
                      ) ??
                      _symbolList[index];
                  return Container(
                    key: _keys[index],
                    alignment: Alignment.center,
                    color: context.pColorScheme.transparent,
                    child: OutlinedButton(
                      style: context.pAppStyle.oulinedMediumPrimaryStyle.copyWith(
                        fixedSize: const WidgetStatePropertyAll(
                          Size.fromHeight(Grid.l + Grid.s + Grid.xs),
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.only(
                            left: Grid.xs,
                            right: Grid.s + Grid.xs,
                          ),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Grid.m + Grid.xxs,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        router.push(
                          SymbolUsDetailRoute(
                            symbolName: usSymbol.symbol ?? '',
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: Grid.s - Grid.xxs,
                        children: [
                          SymbolIcon(
                            symbolName: usSymbol.symbol ?? '',
                            symbolType: SymbolTypes.foreign,
                            size: 28,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usSymbol.symbol ?? '',
                                style: context.pAppStyle.labelReg12textPrimary,
                              ),
                              Builder(
                                builder: (context) {
                                  double trade = usSymbol.trade?.price ?? 0;
                                  double close = usSymbol.previousDailyBar?.close ?? 0;
                                  return DiffPercentage(
                                    fontSize: Grid.m - Grid.xs,
                                    iconSize: Grid.m - Grid.xxs,
                                    percentage: (trade == 0 || close == 0) ? 0 : (trade - close) / close * 100,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PCustomOutlinedButtonWithIcon(
              text: L10n.tr('show_all_dividends'),
              iconSource: ImagesPath.arrow_up_right,
              buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
              onPressed: () {
                router.push(
                  UsDividendRoute(
                    symbolList: state.allIncomingDividends.isNotEmpty
                        ? state.allIncomingDividends
                        : state.favoriteIncomingDividends,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
        ],
      ),
    );
  }
}
