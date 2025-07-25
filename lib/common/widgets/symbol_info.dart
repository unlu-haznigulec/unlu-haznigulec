import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/precaution_widget.dart';
import 'package:piapiri_v2/common/widgets/symbol_about.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/precaution_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

class SymbolInfo extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;
  const SymbolInfo({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<SymbolInfo> createState() => _SymbolInfoState();
}

class _SymbolInfoState extends State<SymbolInfo> {
  late SymbolBloc _symbolBloc;
  late AdvicesBloc _advicesBloc;
  late AuthBloc _authBloc;
  final List<PrecautionModel> _precautionList = [];
  late String _description;
  @override
  void initState() {
    super.initState();
    _symbolBloc = getIt<SymbolBloc>();
    _authBloc = getIt<AuthBloc>();
    _advicesBloc = getIt<AdvicesBloc>();

    if (_authBloc.state.isLoggedIn) {
      _advicesBloc.add(
        GetAdvicesEvent(
          symbolName: widget.symbol.symbolCode,
          mainGroup: MarketTypeEnum.marketBist.value,
        ),
      );
      _advicesBloc.add(
        GetAdviceHistoryEvent(
          symbolName: widget.symbol.symbolCode,
          mainGroup: MarketTypeEnum.marketBist.value,
        ),
      );
    }

    _precautionList.addAll(
      getIt<AppInfoBloc>()
          .state
          .precautionList
          .where(
            (element) => element.operationCode == widget.symbol.symbolCode,
          )
          .toList(),
    );
    _description = _setDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: SizedBox(
        height: 69,
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SymbolIcon(
                    symbolName: widget.type == SymbolTypes.future ||
                            widget.type == SymbolTypes.option ||
                            widget.type == SymbolTypes.warrant
                        ? widget.symbol.underlying
                        : widget.symbol.symbolCode,
                    symbolType: stringToSymbolType(widget.symbol.type),
                    size: 28,
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                        child: Text(
                          widget.symbol.symbolCode,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      if (_description.isNotEmpty)
                        SizedBox(
                          height: 14,
                          child: Text(
                            _setDescription(),
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.type == SymbolTypes.warrant) ...[
                    InkWell(
                      onTap: () {
                        router.push(
                          WarrantCalculateRoute(
                            symbol: widget.symbol,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            L10n.tr('calculater'),
                            style: context.pAppStyle.labelReg14iconPrimary,
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          SvgPicture.asset(
                            ImagesPath.calculator,
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.iconPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_authBloc.state.isLoggedIn)
                    PBlocBuilder<AdvicesBloc, AdvicesState>(
                      bloc: _advicesBloc,
                      builder: (context, state) {
                        if (state.advicesState == PageState.loading) {
                          return const PLoading();
                        }
                        Color? iconColor;
                        if (state.adviceBySymbolNameList.isNotEmpty) {
                          if (state.adviceBySymbolNameList[0].adviceSideId == 1) {
                            iconColor = context.pColorScheme.success;
                          } else {
                            iconColor = context.pColorScheme.critical;
                          }
                        } else if (state.adviceHistoryModel.closedAdvices != null &&
                            state.adviceHistoryModel.closedAdvices!.isNotEmpty) {
                          iconColor = context.pColorScheme.iconPrimary;
                        }
                        return iconColor == null
                            ? const SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  router.push(
                                    AdvicesRoute(
                                      symbol: widget.symbol,
                                      advices: state.adviceBySymbolNameList,
                                      closedAdvices: state.adviceHistoryModel.closedAdvices ?? [],
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  ImagesPath.oneri,
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    iconColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              );
                      },
                    ),
                  if (_precautionList.isNotEmpty) ...[
                    const SizedBox(
                      width: Grid.s,
                    ),
                    InkWell(
                      onTap: () {
                        PBottomSheet.show(
                          context,
                          title: L10n.tr('precautions_list'),
                          titlePadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          child: PrecautionWidget(
                            precautionList: _precautionList,
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        ImagesPath.info_triangle,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                  if (stringToSymbolType(widget.symbol.type) == SymbolTypes.equity) ...[
                    const SizedBox(
                      width: Grid.s,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _symbolBloc.add(
                          SymbolGetInfo(
                            widget.symbol.symbolCode,
                            (symbolInfo) => PBottomSheet.show(
                              context,
                              title: L10n.tr('hakkinda'),
                              titlePadding: const EdgeInsets.only(
                                top: Grid.m,
                              ),
                              child: SymbolAbout(
                                symbolInfo: symbolInfo,
                              ),
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        ImagesPath.info,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(
              height: Grid.s + Grid.xxs,
            ),
            PBlocBuilder<SymbolBloc, SymbolState>(
              bloc: _symbolBloc,
              buildWhen: (previous, current) =>
                  current.isUpdated && current.updatedSymbol.symbolCode == widget.symbol.symbolCode,
              builder: (context, state) {
                MarketListModel symbol = state.watchingItems.firstWhere(
                  (element) => element.symbolCode == widget.symbol.symbolCode,
                  orElse: () => widget.symbol,
                );
                symbol = SymbolDetailUtils().fetchWithSubscribedSymbol(symbol, widget.symbol);

                return SizedBox(
                  height: 29,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${MoneyUtils().getCurrency(stringToSymbolType(symbol.type))}${MoneyUtils().readableMoney(MoneyUtils().getPrice(
                              symbol,
                              null,
                            ), pattern: MoneyUtils().getPricePattern(
                              stringToSymbolType(symbol.type),
                              symbol.subMarketCode,
                            ))}',
                        style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            color: context.pColorScheme.textPrimary,
                            height: 1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      DiffPercentage(
                        percentage: symbol.differencePercent,
                        iconSize: Grid.m + Grid.xs,
                        fontSize: Grid.m,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _setDescription() {
    switch (widget.type) {
      case SymbolTypes.future:
        return '${widget.symbol.underlying} • ${L10n.tr('futures')}'.toCapitalizeCaseTr;
      case SymbolTypes.option:
        return '${widget.symbol.underlying} • ${L10n.tr('options_market')}'.toUpperCase();
      case SymbolTypes.warrant:
        return L10n.tr('call_warrant', args: [widget.symbol.underlying]).toUpperCase();
      default:
        return widget.symbol.description.toUpperCase();
    }
  }
}
