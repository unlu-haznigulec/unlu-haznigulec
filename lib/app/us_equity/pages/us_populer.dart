import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/shimmer_fund_list.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/widgets/list_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/widgets/stock_tile.dart';
import 'package:piapiri_v2/common/widgets/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

class UsPopuler extends StatefulWidget {
  final List<USStockModel> list;
  final int? count;

  const UsPopuler({
    super.key,
    required this.list,
    this.count,
  });

  @override
  State<UsPopuler> createState() => _UsPopulerState();
}

class _UsPopulerState extends State<UsPopuler> {
  late UsEquityBloc _usEquityBloc;
  List<USSymbolModel> _sortedList = [];

  List<String> get _symbolsToSubscribe {
    return widget.list
        .where((stock) => !_usEquityBloc.state.watchingItems.any((watchingItem) => watchingItem.symbol == stock.symbol))
        .map((e) => e.symbol ?? '')
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _usEquityBloc = getIt<UsEquityBloc>();

    if (_symbolsToSubscribe.isNotEmpty) {
      _usEquityBloc.add(
        SubscribeSymbolEvent(
          symbolName: _symbolsToSubscribe,
        ),
      );
    } else {
      // Eğer initState içinde subscribe olmadıysa, sayfa çizildikten sonra tekrar dene
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_symbolsToSubscribe.isNotEmpty) {
          _usEquityBloc.add(
            SubscribeSymbolEvent(
              symbolName: _symbolsToSubscribe,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      builder: (context, state) {
        if (_symbolsToSubscribe.isNotEmpty) {
          _usEquityBloc.add(
            SubscribeSymbolEvent(
              symbolName: _symbolsToSubscribe,
            ),
          );
        }
        //subscribe olmuş sembol listesi tradeCount göre sıralama
        _sortedList = widget.list
            .map((stock) => state.watchingItems.firstWhereOrNull(
                  (element) => element.symbol == stock.symbol,
                ))
            .whereType<USSymbolModel>()
            .toList()
          ..sort((a, b) => (b.currentDailyBar?.tradeCount ?? 0).compareTo(a.currentDailyBar?.tradeCount ?? 0));

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Column(
            children: [
              ListTitleWidget(
                leadingTitle: 'usEquityStats.symbol',
                trailingTitle: 'usEquityStats.priceAndChange',
                hasTopDivider: widget.count == null,
              ),
              state.isLoading || state.populers.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Grid.s,
                      ),
                      child: Shimmerize(
                        enabled: true,
                        child: ShimmerFundList(),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: widget.count != null ? _sortedList.take(widget.count!).length : _sortedList.length,
                      itemBuilder: (context, index) {
                        final symbol = _sortedList[index];
                        return StockTile(
                          usStockModel: symbol,
                        );
                      },
                      separatorBuilder: (context, index) => const PDivider(),
                    ),
            ],
          ),
        );
      },
    );
  }
}
