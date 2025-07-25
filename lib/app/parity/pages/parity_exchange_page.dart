import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_bloc.dart';
import 'package:piapiri_v2/app/parity/pages/emtia_page.dart';
import 'package:piapiri_v2/app/parity/pages/exchange_page.dart';
import 'package:piapiri_v2/app/parity/pages/parity_page.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_widget.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ParityExchangePage extends StatelessWidget {
  const ParityExchangePage({super.key});

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
                scrollable: true,
                initialIndex: getIt<ParityBloc>().state.selectedParity.index,
                tabs: [
                  PTabItem(
                    title: L10n.tr('kur'),
                    page: const ExchangePage(),
                  ),
                  PTabItem(
                    title: L10n.tr('parity'),
                    page: const ParityPage(),
                  ),
                  PTabItem(
                    title: L10n.tr('precious_metals'),
                    page: const EmtiaPage(),
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
