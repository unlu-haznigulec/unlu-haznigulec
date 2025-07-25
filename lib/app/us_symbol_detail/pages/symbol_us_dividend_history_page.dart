import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/model/dividend_model.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/dividend_history_header_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class SymbolUsDividendHistoryPage extends StatefulWidget {
  final List<CashDividendsList> dividendList;
  final String symbol;
  const SymbolUsDividendHistoryPage({
    super.key,
    required this.dividendList,
    required this.symbol,
  });

  @override
  State<SymbolUsDividendHistoryPage> createState() => _SymbolUsDividendHistoryPageState();
}

class _SymbolUsDividendHistoryPageState extends State<SymbolUsDividendHistoryPage> {
  late final UsEquityBloc _usEquityBloc;

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();

    _usEquityBloc.add(
      GetDividendTwoYearEvent(
        symbols: [
          widget.symbol,
        ],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('dividend_history'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m + Grid.xs,
          horizontal: Grid.m,
        ),
        child: PBlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: _usEquityBloc,
            builder: (context, state) {
              if (state.dividendYearlyState == PageState.loading) {
                return const PLoading();
              }

              return state.dividendTwoYearList.isEmpty
                  ? NoDataWidget(
                      message: L10n.tr('no_data'),
                    )
                  : Column(
                      spacing: Grid.s,
                      children: [
                        DividendHistoryHeaderWidget(
                          title1: L10n.tr('tarih'),
                          title2: L10n.tr('dividend_per_share'),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.dividendTwoYearList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String formattedDate = '';
                              if (state.dividendTwoYearList[index].payableDate != null) {
                                DateTime parsedDate = DateTime.parse(
                                    state.dividendTwoYearList[index].payableDate!); // String'i DateTime'a çevirme
                                formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate); // Yeni format
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Grid.s,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  spacing: Grid.s,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        formattedDate,
                                        textAlign: TextAlign.start,
                                        style: context.pAppStyle.labelReg14textPrimary,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '\$${state.dividendTwoYearList[index].rate}',
                                        textAlign: TextAlign.end,
                                        style: context.pAppStyle.labelMed14textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
