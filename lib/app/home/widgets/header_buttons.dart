import 'package:design_system/components/button/button.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/avatar/pages/profile_picture.dart';
import 'package:piapiri_v2/app/home/widgets/notification_icon_widget.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

class HeaderButtons extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  const HeaderButtons({
    super.key,
    this.leftPadding = Grid.m,
    this.rightPadding = Grid.m,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Grid.s + Grid.xs,
        left: leftPadding,
        right: rightPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            child: const ProfilePicture(
              size: 36,
              showEditButton: false,
            ),
            onTap: () => router.push(
              const ProfileRoute(),
            ),
          ),
          const Spacer(),
          PIconButton(
            type: PIconButtonType.standard,
            svgPath: ImagesPath.search,
            sizeType: PIconButtonSize.xl,
            onPressed: () => SymbolSearchUtils.goSymbolDetail(),
          ),
          const SizedBox(width: Grid.s),
          PIconButton(
            type: PIconButtonType.standard,
            svgPath: ImagesPath.alarm,
            sizeType: PIconButtonSize.xl,
            onPressed: () {
              router.push(
                MyAlarmsRoute(),
              );
            },
          ),
          const SizedBox(
            width: Grid.s,
          ),
          const NotificationIconWidget()
        ],
      ),
    );
  }
}
