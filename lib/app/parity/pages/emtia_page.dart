import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_bloc.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_event.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_state.dart';
import 'package:piapiri_v2/app/parity/widgets/parity_list_tile.dart';
import 'package:piapiri_v2/app/parity/widgets/shimmer_parity_list_widget.dart';
import 'package:piapiri_v2/common/widgets/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/parity_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EmtiaPage extends StatefulWidget {
  const EmtiaPage({super.key});

  @override
  State<EmtiaPage> createState() => _EmtiaPageState();
}

class _EmtiaPageState extends State<EmtiaPage> {
  final ParityBloc _parityBloc = getIt<ParityBloc>();
  bool showAdd = false;
  @override
  void initState() {
    _parityBloc.add(
      ParitySetMarketEvent(
        parity: ParityEnum.preciousMetals,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<ParityBloc, ParityState>(
      bloc: _parityBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Shimmerize(
              enabled: true,
              child: ShimmerParityListWidget(),
            ),
          );
        }
        return SlidableAutoCloseBehavior(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Grid.s + Grid.xs,
            ),
            child: BistSymbolListing(
              key: ValueKey('Exchanges_${state.metalsSymbolList.map((e) => e.symbolCode).join('_')}'),
              showTopDivider: false,
              symbols: state.metalsSymbolList,
              outPadding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              columns: [
                L10n.tr('precious_metals'),
                L10n.tr('equity_column_difference'),
                L10n.tr('equity_column_last_price'),
              ],
              columnsSpacingIsEqual: true,
              itemBuilder: (symbol, controller) => ParityListTile(
                key: ValueKey(symbol.symbolCode),
                controller: controller,
                symbol: symbol,
                onTap: () => router.push(
                  SymbolDetailRoute(
                    symbol: symbol,
                    ignoreDispose: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
