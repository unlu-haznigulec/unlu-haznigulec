import 'package:design_system/components/aggrement/aggrement_card.dart';
import 'package:design_system/components/animated_number_text/animated_number_text_catalog_page.dart';
import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/app_bar/app_bar_catalog_page.dart';
import 'package:design_system/components/avatar/avatar_catalog_page.dart';
import 'package:design_system/components/bottom_navigation_bar/bottom_navigation_catalog_page.dart';
import 'package:design_system/components/button/button_catalog_page.dart';
import 'package:design_system/components/chip/chip_catalog_page.dart';
import 'package:design_system/components/date/date_catalog.dart';
import 'package:design_system/components/date_stepper/date_stepper_catalog_page.dart';
import 'package:design_system/components/decorations/shadow/shadow_catalog_page.dart';
import 'package:design_system/components/dialog/dialog_catalog_page.dart';
import 'package:design_system/components/dropdown/dropdown_catalog_page.dart';
import 'package:design_system/components/exchange_overlay/page/market_overlay_catalog_page.dart';
import 'package:design_system/components/expansion_tile/expansion_tile_catalog_page.dart';
import 'package:design_system/components/inapp_viewer/inapp_viewer_catalog_page.dart';
import 'package:design_system/components/list/list_item_catalog_page.dart';
import 'package:design_system/components/picker/picker_catalog_page.dart';
import 'package:design_system/components/profile_card/profile_card_catalog_page.dart';
import 'package:design_system/components/progress_indicator/progress_indicator_catalog_page.dart';
import 'package:design_system/components/radio_button/radio_catalog_page.dart';
import 'package:design_system/components/risk_bar/risk_bar_catalog_page.dart';
import 'package:design_system/components/selection_control/selection_control_catalog_page.dart';
import 'package:design_system/components/sheet/sheet_catalog_page.dart';
import 'package:design_system/components/skeleton_card/skeleton_card_catalog_page.dart';
import 'package:design_system/components/sliding_segment/sliding_segment_catalog_page.dart';
import 'package:design_system/components/snackbar/snack_bar_catalog_page.dart';
import 'package:design_system/components/symbol_chip/symbol_chip_catalog_page.dart';
import 'package:design_system/components/tab_controller/tab_bar_catalog_page.dart';
import 'package:design_system/components/text_field/text_field_catalog_page.dart';
import 'package:design_system/components/video_player/video_player.dart';
import 'package:design_system/foundations/colors/colors_catalog_page.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/foundations/spacing/spacing_catalog_page.dart';
import 'package:design_system/foundations/typography/typography_catalog_page.dart';
import 'package:design_system/simple_page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';

void main() {
  runApp(
    const PWidgetbook(),
  );
}

class PWidgetbook extends StatelessWidget {
  const PWidgetbook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Design System Catalog',
      home: DesignSystemCatalogPage(),
    );
  }
}

class DesignSystemCatalogPage extends StatelessWidget {
  const DesignSystemCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Design system catalog'),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Grid.m),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Wrap(
              spacing: PlatformUtils.isMobile ? width * 0.066 : Grid.m,
              runSpacing: Grid.s,
              children: <Widget>[
                _section('AppBar', const AppBarCatalogPage(), context),
                _section('Progress indicator', const ProgressIndicatorCatalogPage(), context),
                _section('Spacing', const SpacingCatalogPage(), context),
                _section('Typography', const TypographyCatalogPage(), context),
                _section('Chip', const ChipCatalogPage(), context),
                _section('Button', const ButtonCatalogPage(), context),
                _section('Snackbar', const SnackBarCatalogPage(), context),
                _section('Selection control', const SelectionControlCatalogPage(), context),
                _section('Shadow', const ShadowCatalogPage(), context),
                _section('Animated number text', const AnimatedNumberTextCatalogPage(), context),
                _section('Expansion tile', const ExpansionTileCatalogPage(), context),
                _section('Picker', const PickerCatalogPage(), context),
                _section('Profile card', const ProfileCardCatalogPage(), context),
                _section('Colors', const ColorsCatalogPage(), context),
                _section('List Item', const ListItemCatalogPage(), context),
                _section('Avatar', const AvatarCatalogPage(), context),
                _section('Text Field', const TextFieldCatalogPage(), context),
                _section('Tab Bar', const TabBarCatalogPage(), context),
                _section('Bottom Sheet', const SheetCatalogPage(), context),
                _section('Date Stepper', const DateStepperCatalogPage(), context),
                _section('Dialogs', const DialogCatalogPage(), context),
                _section('Skeleton card', const SkeletonCardCatalogPage(), context),
                _section('Dropdwn ', const DropdownCatalogPage(), context),
                _section('Date', const DateCatalogPage(), context),
                _section('Radio Button', const RadioCatalogPage(), context),
                _section('InApp Viewer', const InAppViewerCatalogPage(), context),
                _section('Video Player', const PVideoPlayer(videoUrl: ''), context),
                _section('Aggrement Card', PAggrementCard(onTap: () {}, testText: '01.01.2024'), context),
                _section('Symbol Chip', const SymbolChipCatalogPage(), context),
                _section('Buy Sell Slider', const SlidingSegmentCatalogPage(), context),
                _section('Bottom Naviation Bar', const BottomNavigationCatalogPage(), context),
                _section('Risk Bar', const RiskBarCatalogPage(), context),
                _section('Exchange Overlay', const MarketOverlayCatalogPage(), context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String sectionName, Widget sectionPage, BuildContext context) {
    double? size;
    if (PlatformUtils.isMobile) {
      size = MediaQuery.of(context).size.width / 2.5;
    }
    return SizedBox(
      width: size ?? 150,
      height: size ?? 150,
      child: ElevatedButton(
        child: Text(sectionName),
        onPressed: () {
          SimplePageNavigator.push(sectionPage, context);
        },
      ),
    );
  }
}
