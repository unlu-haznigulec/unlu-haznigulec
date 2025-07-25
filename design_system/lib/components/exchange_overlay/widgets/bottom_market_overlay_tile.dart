import 'package:design_system/components/exchange_overlay/model/market_overlay_model.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomMarketOverlayTile extends StatelessWidget {
  final BottomMarketOverlayModel model;
  final bool isSelected;
  final void Function()? onTap;
  const BottomMarketOverlayTile({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? context.pColorScheme.secondary : context.pColorScheme.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Grid.xs,
          children: [
            SvgPicture.asset(
              model.assetPath,
              package: DesignImagesPath.package,
              width: Grid.m - Grid.xxs,
              height: Grid.m - Grid.xxs,
            ),
            Text(
              model.label,
              style: TextStyle(
                fontSize: Grid.m - Grid.xxs,
                fontFamily: isSelected ? 'Inter-Medium' : 'Inter-Regular',
                color: isSelected ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
