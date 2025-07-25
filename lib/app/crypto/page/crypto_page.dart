import 'package:design_system/components/tab_controller/model/tab_bar_item.dart';
import 'package:design_system/components/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
// import 'package:piapiri_v2/app/crypto/bloc/crypto_bloc.dart';
import 'package:piapiri_v2/app/crypto/page/binance_listing_page.dart';
// import 'package:piapiri_v2/app/crypto/page/bitmex_listing_page.dart';
// import 'package:piapiri_v2/app/crypto/page/btcturk_listing_page.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_widget.dart';
// import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CryptoPage extends StatelessWidget {
  const CryptoPage({super.key});

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
                tabs: [
                  // PTabItem(
                  //   title: L10n.tr('BTCTURK'),
                  //   page: const BtcturkListingPage(),
                  // ),
                  PTabItem(
                    title: L10n.tr('BINANCE'),
                    page: const BinanceListingPage(),
                  ),
                  // PTabItem(
                  //   title: L10n.tr('BitMEX'),
                  //   page: const BitmexListingPage(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
