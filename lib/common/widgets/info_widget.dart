import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class PInfoWidget extends StatelessWidget {
  final String infoText;
  final TextStyle? infoTextStyle;
  final bool isAlignCenter;
  final String? iconPath;
  final Color? textColor;
  final CrossAxisAlignment crossAxisAlignment;

  const PInfoWidget({
    super.key,
    required this.infoText,
    this.infoTextStyle,
    this.isAlignCenter = false,
    this.iconPath,
    this.textColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      spacing: Grid.xs,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: Grid.xxs,
          ),
          child: SvgPicture.asset(
            iconPath ?? ImagesPath.alertCircle,
            width: Grid.m,
            height: Grid.m,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        Expanded(
          child: Text(
            infoText,
            textAlign: isAlignCenter ? TextAlign.center : TextAlign.left,
            style: infoTextStyle ??
                context.pAppStyle.labelReg16textPrimary.copyWith(
                  color: textColor ?? context.pColorScheme.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}
