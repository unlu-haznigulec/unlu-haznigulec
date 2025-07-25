import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_sub_tab_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/brokerage_distribution/page/brokerage_distribution_page.dart';
import 'package:piapiri_v2/app/depth/pages/depth_tab.dart';
import 'package:piapiri_v2/app/stage_analysis/page/stage_analysis_page.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolData extends StatelessWidget {
  final MarketListModel symbol;
  const SymbolData({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return PSubTabController(
      tabList: [
        PTabItem(
          title: L10n.tr('derinlik'),
          page: DepthTab(
            symbol: symbol,
          ),
        ),
        PTabItem(
          title: L10n.tr('kademe_analizi'),
          page: StageAnalysisPage(symbol: symbol),
        ),
        PTabItem(
          title: L10n.tr('brokerage_distribution'),
          page: BrokerageDistributionPage(
            marketListModel: symbol,
          ),
        ),
      ],
    );
  }
}
