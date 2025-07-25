import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/add_favorite_icon.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/pages/fund_summary_page.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/buy_sell_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

import '../bloc/fund_event.dart';

@RoutePage()
class FundDetailPage extends StatefulWidget {
  final String fundCode;
  const FundDetailPage({
    super.key,
    required this.fundCode,
  });

  @override
  State<FundDetailPage> createState() => _FundDetailPageState();
}

class _FundDetailPageState extends State<FundDetailPage> {
  late FundBloc _fundBloc;
  late AuthBloc _authBloc;
  @override
  initState() {
    _fundBloc = getIt<FundBloc>();
    _authBloc = getIt<AuthBloc>();
    _fundBloc.add(
      GetDetailEvent(
        fundCode: widget.fundCode,
      ),
    );
    _fundBloc.add(
      GetFundPriceGraphEvent(
        fundCode: widget.fundCode,
      ),
    );
    _fundBloc.add(
      GetFundVolumeHistoryEvent(
        fundCode: widget.fundCode,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _fundBloc.add(FundDetailClearEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(widget.fundCode),
        actions: !_authBloc.state.isLoggedIn
            ? null
            : [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddFavoriteIcon(
                      symbolCode: widget.fundCode,
                      symbolType: SymbolTypes.fund,
                    ),
                    const SizedBox(width: Grid.s),
                    BlocSelector<FundBloc, FundState, PageState>(
                      bloc: _fundBloc,
                      selector: (state) => state.fundDetailPageState,
                      builder: (context, fundDetailPageState) =>
                          fundDetailPageState == PageState.success && _fundBloc.state.fundDetail != null
                              ? InkWrapper(
                                  child: SvgPicture.asset(
                                    ImagesPath.arrows_across,
                                    height: 24,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.iconPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  onTap: () {
                                    router.push(
                                      SymbolCompareRoute(
                                        symbolName: _fundBloc.state.fundDetail!.code,
                                        underLyingName: _fundBloc.state.fundDetail!.institutionCode,
                                        subType: _fundBloc.state.fundDetail!.subType,
                                        description:
                                            '${_fundBloc.state.fundDetail!.code} • ${_fundBloc.state.fundDetail!.founder}',
                                        symbolType: SymbolTypes.fund,
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
      ),
      body: BlocSelector<FundBloc, FundState, PageState>(
        bloc: _fundBloc,
        selector: (state) => state.fundDetailPageState,
        builder: (context, fundDetailPageState) {
          if (fundDetailPageState == PageState.loading) {
            return const PLoading();
          } else if (fundDetailPageState == PageState.success && _fundBloc.state.fundDetail != null) {
            return FundSummaryPage(
              fund: _fundBloc.state.fundDetail!,
            );
          } else {
            return NoDataWidget(message: L10n.tr('no_data'));
          }
        },
      ),
      bottomNavigationBar: BlocSelector<FundBloc, FundState, PageState>(
        bloc: _fundBloc,
        selector: (state) => state.fundDetailPageState,
        builder: (context, fundDetailPageState) {
          if (fundDetailPageState != PageState.success || _fundBloc.state.fundDetail == null) {
            return const SizedBox.shrink();
          }
          bool isBuyEnabled =
              _fundBloc.state.fundDetail!.virtualBranchAllowedBuy ?? _fundBloc.state.fundDetail!.minBuyAmount > 0;
          bool isSellEnabled =
              _fundBloc.state.fundDetail!.virtualBranchAllowedSell ?? _fundBloc.state.fundDetail!.minSellAmount > 0;
          List<FundOrderActionEnum> allowedActions = [];
          if (isBuyEnabled) {
            allowedActions.add(FundOrderActionEnum.buy);
          }
          if (isSellEnabled) {
            allowedActions.add(FundOrderActionEnum.sell);
          }
          return BuySellButtons(
            isBuyEnabled: isBuyEnabled,
            isSellEnabled: isSellEnabled,
            onTapBuy: () {
              router.push(
                FundOrderRoute(
                  fund: _fundBloc.state.fundDetail!,
                  action: FundOrderActionEnum.buy,
                  allowedActions: allowedActions, // Ensure at least buy is always included
                ),
              );
            },
            onTapSell: () {
              router.push(
                FundOrderRoute(
                  fund: _fundBloc.state.fundDetail!,
                  action: FundOrderActionEnum.sell,
                  allowedActions: allowedActions,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
