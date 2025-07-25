import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:design_system/components/bottom_navigation_bar/floating_action_button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigationCatalogPage extends StatefulWidget {
  const BottomNavigationCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonCatalogPageCatalogPageState();
}

class _ButtonCatalogPageCatalogPageState extends State<BottomNavigationCatalogPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Navigation Bar Catalog'),
      floatingActionButton: const PFloatingAction(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: PBottomNavigationBar(
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
            selectedIndex = index;
          });
        },
      ),
      body: Container(
        width: 500,
        height: 620,
        color: Colors.red.withOpacity(.2),
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
