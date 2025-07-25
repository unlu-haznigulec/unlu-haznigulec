import 'dart:developer';

import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:design_system/components/bottom_navigation_bar/floating_action_button.dart';
import 'package:design_system/components/exchange_overlay/model/market_overlay_model.dart';
import 'package:design_system/components/exchange_overlay/widgets/darken_backgorund.dart';
import 'package:design_system/components/exchange_overlay/widgets/market_overlay.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketOverlayCatalogPage extends StatefulWidget {
  const MarketOverlayCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonCatalogPageCatalogPageState();
}

class _ButtonCatalogPageCatalogPageState extends State<MarketOverlayCatalogPage> {
  List<MarketOverlayModel> list = [];
  bool _isOverlayVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: PAppBarCoreWidget(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleWidget: MarketOverlay(
          marketShowCaseKeys: const [],
          list: [
            TopMarketOverlayModel(
              label: 'Borsa Istanbul',
              index: 0,
              assetPath: DesignImagesPath.bist,
            ),
            TopMarketOverlayModel(
              label: 'Amerikan Borsaları',
              index: 1,
              assetPath: DesignImagesPath.yurt_disi,
            ),
            TopMarketOverlayModel(
              label: 'Yatırım Fon  ',
              index: 2,
              assetPath: DesignImagesPath.fon,
            ),
            TopMarketOverlayModel(
              label: 'Halka Arz',
              index: 3,
              assetPath: DesignImagesPath.halka_arz,
            ),
            TopMarketOverlayModel(
              label: 'Eurobond',
              index: 4,
              assetPath: DesignImagesPath.eurobond,
            ),
            TopMarketOverlayModel(
              label: 'Kur / Parite',
              index: 5,
              assetPath: DesignImagesPath.kur,
            ),
            TopMarketOverlayModel(
              label: 'Kripto',
              index: 6,
              assetPath: DesignImagesPath.kripto,
            ),
            BottomMarketOverlayModel(
              label: 'Favorilerim',
              index: 7,
              assetPath: DesignImagesPath.pinned,
            ),
            BottomMarketOverlayModel(
              label: 'Gundem',
              index: 8,
              assetPath: DesignImagesPath.news,
            ),
          ],
          onSelected: (index) {
            log('Selected index: $index');
          },
          onOverlayVisibilityChanged: (bool isOverlayVisible) {
            setState(() {
              _isOverlayVisible = isOverlayVisible;
            });
          },
        ),
      ),
      body: DarkenBackgorund(
        isDarken: _isOverlayVisible,
        child: Column(
          children: [
            const SizedBox(
              height: 160,
            ),
            Text('Content' * 100),
            Container(
              height: 100,
              color: Colors.red,
            ),
          ],
        ),
      ),
      floatingActionButton: PFloatingAction(
        isOverlayVisible: _isOverlayVisible,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: DarkenBackgorund(
        isDarken: _isOverlayVisible,
        child: PBottomNavigationBar(
          currentIndex: 0,
          navigationItems: [
            getBottomNavigationBarItem(
              'Anasayfa',
              DesignImagesPath.home,
            ),
            getBottomNavigationBarItem(
              'Emirler',
              DesignImagesPath.arrow_refresh,
            ),
            getBottomNavigationBarItem(
              'Piyasalar',
              DesignImagesPath.graph_line,
            ),
            getBottomNavigationBarItem(
              'Portföy',
              DesignImagesPath.pie_chart,
            ),
          ],
          onTap: (index) {
            setState(() {
              //selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem getBottomNavigationBarItem(String label, String icon) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        icon,
        package: DesignImagesPath.package,
      ),
      activeIcon: SvgPicture.asset(
        icon,
        package: DesignImagesPath.package,
        colorFilter: ColorFilter.mode(
          context.pColorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
