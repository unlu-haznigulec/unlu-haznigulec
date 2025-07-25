import 'package:collection/collection.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BistUnderlying extends StatefulWidget {
  final String underlyingName;
  const BistUnderlying({
    super.key,
    required this.underlyingName,
  });

  @override
  State<BistUnderlying> createState() => _BistUnderlyingState();
}

class _BistUnderlyingState extends State<BistUnderlying> {
  late MarketListModel underlyingAsset;
  late SymbolBloc _symbolBloc;
  @override
  void initState() {
    super.initState();
    _symbolBloc = getIt<SymbolBloc>();
    underlyingAsset = MarketListModel(
      symbolCode: widget.underlyingName,
      updateDate: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) =>
          previous.type != current.type &&
          (current.type == PageState.updated || current.type == PageState.success) &&
          current.updatedSymbol.symbolCode == widget.underlyingName,
      listener: (context, state) {
        MarketListModel? marketListModel = state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == widget.underlyingName,
        );
        if (marketListModel == null) return;
        underlyingAsset = marketListModel;
        setState(() {});
      },
      builder: (BuildContext context, SymbolState state) {
        return SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SymbolIcon(
                symbolName: underlyingAsset.symbolCode,
                symbolType: SymbolTypes.equity,
                size: 28,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    underlyingAsset.symbolCode,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    L10n.tr('underlying_asset'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(MoneyUtils().getPrice(underlyingAsset, null))}',
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  DiffPercentage(
                    percentage: underlyingAsset.differencePercent,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
