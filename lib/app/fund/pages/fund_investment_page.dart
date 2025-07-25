import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/pages/fund_analysis_page.dart';
import 'package:piapiri_v2/app/fund/pages/fund_page.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_widget.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundInvestmentPage extends StatelessWidget {
  final int? tabIndex;
  const FundInvestmentPage({
    super.key,
    this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: Grid.m,
            ),
            const MarketCarouselWidget(),
            const SizedBox(
              height: Grid.s,
            ),
            Expanded(
              child: PMainTabController(
                initialIndex: tabIndex ?? 0,
                tabs: [
                  PTabItem(
                    title: L10n.tr('fund'),
                    page: const FundPage(),
                  ),
                  PTabItem(
                    title: L10n.tr('analiz'),
                    page: const FundAnalysisPage(),
                  ),
                ],
                scrollable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
