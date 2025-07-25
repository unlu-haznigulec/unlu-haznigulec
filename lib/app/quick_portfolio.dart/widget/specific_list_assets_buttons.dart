import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class SpecificListAssetsButtons extends StatefulWidget {
  final SpecificListModel specificList;

  const SpecificListAssetsButtons({
    super.key,
    required this.specificList,
  });

  @override
  State<SpecificListAssetsButtons> createState() => _SpecificListAssetsButtonsState();
}

class _SpecificListAssetsButtonsState extends State<SpecificListAssetsButtons> {
  List<String> fundFounderCode = [];
  List<MarketListModel> symbolDetails = [];
  late SpecificListModel _specificList;

  @override
  void initState() {
    _specificList = widget.specificList;
    if ((_specificList.tab == BistType.equityBist.type ||
            _specificList.symbolType == SpecialListSymbolTypeEnum.equity.type ||
            _specificList.tab == BistType.warrantBist.type ||
            _specificList.symbolType == SpecialListSymbolTypeEnum.warrant.type ||
            _specificList.tab == BistType.viopBist.type ||
            _specificList.symbolType == SpecialListSymbolTypeEnum.viop.type) &&
        _specificList.mainGroup != MarketTypeEnum.marketUs.value &&
        _specificList.mainGroup != MarketTypeEnum.marketFund.value) {
      getIt<QuickPortfolioBloc>().add(
        GetDetailsOfSymbolsEvent(
            codes: _specificList.symbolNames,
            callback: (details) {
              if (mounted) {
                setState(() {
                  symbolDetails = details;
                  _specificList.symbolNames = widget.specificList.symbolNames
                      .where((symbol) => details.any((detail) => detail.symbolCode == symbol))
                      .toList();
                });
              }
            }),
      );
    }
    if (_specificList.mainGroup == BistType.fundBist.type ||
        _specificList.symbolType == SpecialListSymbolTypeEnum.fund.type ||
        (_specificList.symbolType != null &&
            _specificList.symbolType!.isEmpty &&
            _specificList.mainGroup != MarketTypeEnum.marketUs.value)) {
      getIt<QuickPortfolioBloc>().add(
        GetFundFounderCodeEvent(
            codes: _specificList.symbolNames,
            callback: (founderCode) {
              if (mounted) {
                setState(() {
                  fundFounderCode = founderCode;
                });
              }
            }),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: getIt<QuickPortfolioBloc>(),
      builder: (context, state) {
        if (state.isLoading ||
            (symbolDetails.isEmpty &&
                (_specificList.tab == BistType.equityBist.type ||
                    _specificList.symbolType == SpecialListSymbolTypeEnum.equity.type ||
                    _specificList.tab == BistType.warrantBist.type ||
                    _specificList.symbolType == SpecialListSymbolTypeEnum.warrant.type ||
                    _specificList.tab == BistType.viopBist.type ||
                    _specificList.symbolType == SpecialListSymbolTypeEnum.viop.type))) {
          return const SizedBox();
        }
        if (fundFounderCode.isEmpty &&
            (_specificList.mainGroup == BistType.fundBist.type ||
                _specificList.symbolType == SpecialListSymbolTypeEnum.fund.type ||
                (_specificList.symbolType != null &&
                    _specificList.symbolType!.isEmpty &&
                    _specificList.mainGroup != MarketTypeEnum.marketUs.value))) {
          return const SizedBox();
        }
        return SizedBox(
          height: Grid.l,
          child: ListView.builder(
            itemCount: _specificList.symbolNames.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: Grid.xs,
                ),
                child: PCustomOutlinedButtonWithIcon(
                  text: _specificList.symbolNames[index],
                  icon: SymbolIcon(
                    key: Key(
                        'id:${_specificList.id}_market:${_specificList.mainGroup}_tab:${_specificList.tab}_${_specificList.symbolNames[index]}'),
                    symbolName: _specificList.tab == BistType.equityBist.type ||
                            _specificList.symbolType == SpecialListSymbolTypeEnum.equity.type
                        ? symbolDetails[index].symbolCode
                        : _specificList.tab == BistType.warrantBist.type ||
                                _specificList.symbolType == SpecialListSymbolTypeEnum.warrant.type ||
                                _specificList.tab == BistType.viopBist.type ||
                                _specificList.symbolType == SpecialListSymbolTypeEnum.viop.type
                            ? symbolDetails[index].underlying
                            : _specificList.mainGroup == BistType.fundBist.type ||
                                    _specificList.symbolType == SpecialListSymbolTypeEnum.fund.type ||
                                    (_specificList.symbolType != null &&
                                        _specificList.symbolType!.isEmpty &&
                                        _specificList.mainGroup != MarketTypeEnum.marketUs.value &&
                                        _specificList.symbolType != SpecialListSymbolTypeEnum.foreign.type)
                                ? fundFounderCode[index]
                                : _specificList.symbolNames[index],
                    symbolType: _specificList.tab == BistType.equityBist.type ||
                            _specificList.symbolType == SpecialListSymbolTypeEnum.equity.type
                        ? SymbolTypes.equity
                        : _specificList.tab == BistType.viopBist.type ||
                                _specificList.symbolType == SpecialListSymbolTypeEnum.viop.type
                            ? SymbolTypes.future
                            : _specificList.tab == BistType.warrantBist.type ||
                                    _specificList.symbolType == SpecialListSymbolTypeEnum.warrant.type
                                ? SymbolTypes.warrant
                                : _specificList.mainGroup == BistType.fundBist.type ||
                                        _specificList.symbolType == SpecialListSymbolTypeEnum.fund.type ||
                                        (_specificList.symbolType != null &&
                                            _specificList.symbolType!.isEmpty &&
                                            _specificList.mainGroup != MarketTypeEnum.marketUs.value &&
                                            _specificList.symbolType != SpecialListSymbolTypeEnum.foreign.type)
                                    ? SymbolTypes.fund
                                    : SymbolTypes.foreign,
                  ),
                  iconAlignment: IconAlignment.start,
                  buttonType: PCustomOutlinedButtonTypes.smallSecondary,
                  onPressed: () {
                    if (_specificList.mainGroup == MarketTypeEnum.marketUs.value ||
                        _specificList.symbolType == SpecialListSymbolTypeEnum.foreign.type) {
                      router.push(
                        SymbolUsDetailRoute(symbolName: _specificList.symbolNames[index]),
                      );
                    } else if (_specificList.mainGroup == MarketTypeEnum.marketFund.value ||
                        _specificList.symbolType == SpecialListSymbolTypeEnum.fund.type ||
                        (_specificList.symbolType != null &&
                            _specificList.symbolType!.isEmpty &&
                            _specificList.mainGroup != MarketTypeEnum.marketBist.value)) {
                      router.push(
                        FundDetailRoute(
                          fundCode: _specificList.symbolNames[index],
                        ),
                      );
                    } else {
                      MarketListModel symbol = MarketListModel(
                        symbolCode: _specificList.symbolNames[index],
                        updateDate: '',
                      );
                      router.push(
                        SymbolDetailRoute(symbol: symbol),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
