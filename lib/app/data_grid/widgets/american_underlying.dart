import 'package:collection/collection.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AmericanUnderlying extends StatefulWidget {
  final String underlyingName;
  const AmericanUnderlying({
    super.key,
    required this.underlyingName,
  });

  @override
  State<AmericanUnderlying> createState() => _BistUnderlyingState();
}

class _BistUnderlyingState extends State<AmericanUnderlying> {
  late USSymbolModel underlyingAsset;
  late UsEquityBloc _usEquityBloc;
  @override
  void initState() {
    super.initState();
    _usEquityBloc = getIt<UsEquityBloc>();
    underlyingAsset = USSymbolModel(
      symbol: widget.underlyingName,
    );
    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: [widget.underlyingName],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listenWhen: (previous, current) =>
          previous.type != current.type &&
          (current.type == PageState.updated || current.type == PageState.success) &&
          current.watchingItems.map((e) => e.symbol).toList().contains(
                underlyingAsset.symbol,
              ),
      listener: (context, state) {
        USSymbolModel? newModel =
            state.watchingItems.firstWhereOrNull((element) => element.symbol == underlyingAsset.symbol);
        if (newModel == null) return;
        underlyingAsset = newModel;
        setState(() {});
      },
      builder: (context, state) {
        return SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SymbolIcon(
                symbolName: underlyingAsset.symbol ?? '',
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
                    underlyingAsset.symbol ?? '',
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
                    '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(underlyingAsset.trade?.price ?? 0)}',
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  DiffPercentage(
                    percentage:
                        (((underlyingAsset.trade?.price ?? 0) - (underlyingAsset.previousDailyBar?.close ?? 0)) /
                                (underlyingAsset.previousDailyBar?.close ?? 1)) *
                            100,
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
