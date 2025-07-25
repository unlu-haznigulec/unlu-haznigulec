import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class SymbolBriefInfo extends StatelessWidget {
  final String label;
  final dynamic value;
  final String? imagesPath;
  final Function()? onTap;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? suffixDotColor;
  final Function()? onTapInfo;
  final bool isShowInfo;
  final TextStyle? titleStyle;
  const SymbolBriefInfo({
    super.key,
    required this.label,
    required this.value,
    this.imagesPath,
    this.onTap,
    this.crossAxisAlignment,
    this.suffixDotColor,
    this.onTapInfo,
    this.isShowInfo = false,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.s,
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AutoSizeText(
                    label,
                    maxLines: 1,
                    style: titleStyle ?? context.pAppStyle.labelReg14textSecondary,
                  ),
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  if (isShowInfo)
                    InkWell(
                      onTap: onTapInfo,
                      child: SvgPicture.asset(
                        ImagesPath.info,
                        width: Grid.m - Grid.xxs,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value is Widget)
                    Expanded(child: value)
                  else if (value is String)
                    AutoSizeText(
                      value,
                      maxLines: 1,
                      style: context.pAppStyle.labelMed14textPrimary.copyWith(height: 1),
                    ),
                  if (imagesPath != null) ...[
                    const SizedBox(width: Grid.xs),
                    SvgPicture.asset(
                      imagesPath!,
                      width: 12,
                      height: 12,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                  if (suffixDotColor != null) ...[
                    const SizedBox(width: Grid.xs),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: suffixDotColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
