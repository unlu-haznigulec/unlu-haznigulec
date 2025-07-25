import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/widgets/list_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/widgets/loser_gainer_tile.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class UsDividendPage extends StatefulWidget {
  const UsDividendPage({
    required this.symbolList,
    super.key,
  });

  final List<String> symbolList;
  @override
  State<UsDividendPage> createState() => _UsDividendPageState();
}

class _UsDividendPageState extends State<UsDividendPage> {
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

  void _initialize() {
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
            'us_div_${e.symbol!}',
          ),
        )
        .toList();
    _scrollController.addListener(_onScroll);
    int watchItemsLength = 20;
    _watchingItems = _symbolList.length < watchItemsLength ? _symbolList : _symbolList.sublist(0, watchItemsLength);
    _susbcribeList(_watchingItems.map((e) => e.symbol!).toList(), []);
  }

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _initialize();
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
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('symbol_will_be_dist_divident'),
      ),
      body: PBlocBuilder<UsEquityBloc, UsEquityState>(
        bloc: _usEquityBloc,
        builder: (context, state) {
          if (state.allIncomingDividendsState == PageState.loading) {
            return Container(
              color: context.pColorScheme.transparent,
              alignment: Alignment.center,
              child: const PLoading(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ListTitleWidget(
                  leadingTitle: 'usEquityStats.symbol',
                  trailingTitle: 'usEquityStats.priceAndChange',
                  hasTopDivider: true,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      bottom: Grid.l,
                    ),
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: _symbolList.length,
                    separatorBuilder: (context, index) => const PDivider(),
                    itemBuilder: (context, index) {
                      USSymbolModel usSymbol = state.watchingItems.firstWhereOrNull(
                            (e) => e.symbol == _symbolList[index].symbol,
                          ) ??
                          _symbolList[index];
                      return LoserGainerTile(
                        key: _keys[index],
                        loserGainerModel: usSymbol,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
