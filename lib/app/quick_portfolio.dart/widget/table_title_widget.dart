import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class TableTitleWidget extends StatelessWidget {
  final String primaryColumnTitle;
  final String? secondaryColumnTitle;
  final String tertiaryColumnTitle;
  final Function()? onTap;
  final Function()? onTertiaryTap;
  final bool? hasSorting;
  final bool? hasTertiarySorting;
  final bool showTopDivider;

  const TableTitleWidget({
    super.key,
    required this.primaryColumnTitle,
    this.secondaryColumnTitle,
    required this.tertiaryColumnTitle,
    this.onTap,
    this.onTertiaryTap,
    this.hasSorting = false,
    this.hasTertiarySorting = false,
    this.showTopDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTopDivider) const PDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xs),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Text(
                      primaryColumnTitle,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    if (hasSorting!)
                      InkWell(
                        splashColor: context.pColorScheme.transparent,
                        highlightColor: context.pColorScheme.transparent,
                        onTap: onTap,
                        child: SvgPicture.asset(
                          ImagesPath.arrows_down_up,
                          width: 14,
                        ),
                      )
                  ],
                ),
              ),
              if (secondaryColumnTitle != null)
                Expanded(
                  flex: 3,
                  child: Text(
                    '$secondaryColumnTitle ',
                    textAlign: TextAlign.center,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ),
              Expanded(
                flex: 3,
                child: (hasTertiarySorting ?? false)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            tertiaryColumnTitle,
                            textAlign: TextAlign.right,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                          const SizedBox(
                            width: Grid.s,
                          ),
                          InkWell(
                            onTap: onTertiaryTap,
                            child: SvgPicture.asset(
                              ImagesPath.arrows_down_up,
                              width: 14,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        tertiaryColumnTitle,
                        textAlign: TextAlign.right,
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
