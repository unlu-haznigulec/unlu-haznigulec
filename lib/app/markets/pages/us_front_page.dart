import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/markets/pages/us_analysis_page.dart';
import 'package:piapiri_v2/app/markets/pages/us_equity_front_page.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_widget.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsFrontPage extends StatelessWidget {
  final int? tabIndex;
  const UsFrontPage({
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
                scrollable: false,
                initialIndex: tabIndex ?? 0,
                tabs: [
                  PTabItem(
                    title: L10n.tr('equity'),
                    page: const UsEquityFrontPage(),
                  ),
                  PTabItem(
                    title: L10n.tr('analysis'),
                    page: const UsAnalysisPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
