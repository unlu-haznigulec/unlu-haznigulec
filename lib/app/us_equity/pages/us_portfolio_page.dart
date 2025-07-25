import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_portfolio_detail_tile.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Amerikan borsaları -> Analiz -> Portfoy kart detay
@RoutePage()
class UsPortfolioPage extends StatefulWidget {
  final List<QuickPortfolioAssetModel> usPortfoio;
  final String title;
  final String description;
  final String suitable;
  const UsPortfolioPage({
    super.key,
    required this.usPortfoio,
    required this.title,
    required this.description,
    required this.suitable,
  });

  @override
  State<UsPortfolioPage> createState() => _UsPortfolioPageState();
}

class _UsPortfolioPageState extends State<UsPortfolioPage> {
  late UsEquityBloc _usEquityBloc;
  late QuickPortfolioBloc _quickPortfolioBloc;

  List<String> get _symbolsToSubscribe {
    return widget.usPortfoio
        .where((portfolioItem) =>
            !_usEquityBloc.state.watchingItems.any((watchingItem) => watchingItem.symbol == portfolioItem.code))
        .map((e) => e.code)
        .toList();
  }

  @override
  initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    if (_symbolsToSubscribe.isNotEmpty) {
      _usEquityBloc.add(
        SubscribeSymbolEvent(
          symbolName: _symbolsToSubscribe,
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_symbolsToSubscribe.isNotEmpty) {
      _usEquityBloc.add(
        UnsubscribeSymbolEvent(
          symbolName: _symbolsToSubscribe,
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        if (widget.usPortfoio.isEmpty) {
          return const PLoading();
        }
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

            return Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(
                  color: Colors.transparent,
                ),
              ),
              child: Scaffold(
                appBar: PInnerAppBar(
                  title: widget.title,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(Grid.m),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.description,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const SizedBox(height: Grid.m),
                        Text(
                          L10n.tr('whoIsItSuitableFor'),
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                        const SizedBox(height: Grid.s),
                        Text(
                          widget.suitable,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const SizedBox(height: Grid.s + Grid.xs),
                        TableTitleWidget(
                          primaryColumnTitle: L10n.tr('equity'),
                          secondaryColumnTitle: '%${L10n.tr('yuzde')}',
                          tertiaryColumnTitle: L10n.tr('daily_profit'),
                        ),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.usPortfoio.length,
                          separatorBuilder: (context, index) => const PDivider(),
                          itemBuilder: (context, index) {
                            USSymbolModel? symbol = state.watchingItems.firstWhereOrNull(
                              (element) => element.symbol == widget.usPortfoio[index].code,
                            );
                            if (_symbolsToSubscribe.isNotEmpty || symbol == null) {
                              return const PLoading();
                            }
                            return UsPortfolioDetailTile(
                              item: QuickPortfolioAssetModel(
                                id: 0,
                                amount: 0.0,
                                type: SymbolTypes.foreign.name,
                                targetPrice: 0.0,
                                code: widget.usPortfoio[index].code,
                                name: widget.usPortfoio[index].name,
                                founderCode: widget.usPortfoio[index].code,
                                ratio: double.parse(widget.usPortfoio[index].ratio.toString()),
                                subType: widget.usPortfoio[index].subType,
                                founderName: widget.usPortfoio[index].name,
                              ),
                              symbol: symbol,
                            );
                          },
                        ),
                        const SizedBox(
                          height: Grid.xxl,
                        ),
                      ],
                    ),
                  ),
                ),
                bottomSheet: generalButtonPadding(
                  context: context,
                  child: PButton(
                    text: L10n.tr('satin_al'),
                    fillParentWidth: true,
                    sizeType: PButtonSize.medium,
                    onPressed: () {
                      router.push(
                        UsPortfolioOrderRoute(
                          title: widget.title,
                          portfolioList: widget.usPortfoio,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
