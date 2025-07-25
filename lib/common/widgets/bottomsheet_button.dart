import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class BottomsheetButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isSelected;
  final double outlinedHeight;
  const BottomsheetButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isSelected = false,
    this.outlinedHeight = 23,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: outlinedHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? context.pColorScheme.secondary : null,
          side: BorderSide(
            color: isSelected ? context.pColorScheme.secondary : context.pColorScheme.stroke,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.m),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.s + Grid.xs,
            vertical: Grid.xs,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.pAppStyle.interMediumBase.copyWith(
                color: isSelected ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                fontSize: Grid.m - Grid.xxs,
              ),
            ),
            const SizedBox(width: Grid.xs),
            SvgPicture.asset(
              ImagesPath.chevron_down,
              height: 15,
              width: 15,
              colorFilter: ColorFilter.mode(
                isSelected ? context.pColorScheme.primary : context.pColorScheme.textSecondary,
                BlendMode.srcIn,
              ),
            )
          ],
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}
