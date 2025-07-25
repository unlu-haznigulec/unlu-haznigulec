import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/color_utils.dart';

class DescriptionWidget extends StatelessWidget {
  final String text;
  const DescriptionWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: context.pColorScheme.transparent,
        border: Border.all(
          color: ColorUtils.generalCardShadowColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                Grid.m,
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 14,
                    ),
              ),
            ),
          ),
          const SizedBox(width: Grid.s),
          SizedBox(
            height: 100,
            child: Image.asset(
              ImagesPath.backgroundCircle,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
