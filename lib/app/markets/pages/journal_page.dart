import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/economic_calender/page/economic_calender_page.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_widget.dart';
import 'package:piapiri_v2/app/news/pages/news_tab_page.dart';
import 'package:piapiri_v2/app/review/pages/review_page.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            tabs: [
              PTabItem(
                title: L10n.tr('haberler'),
                page: const NewsTabPage(),
              ),
              PTabItem(
                title: L10n.tr('ekonomik_takvim'),
                page: const EconomicCalendarPage(),
              ),
              PTabItem(
                title: L10n.tr('market_comments'),
                page: const Center(
                  child: ReviewsPage(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
