import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoDataWidget extends StatelessWidget {
  final String message;
  final ThemeMode themeMode;
  final String? iconName;
  const NoDataWidget({
    super.key,
    required this.message,
    this.themeMode = ThemeMode.light,
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName ?? DesignImagesPath.search,
            width: 32,
            package: iconName != null ? null : DesignImagesPath.package,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
        ],
      ),
    );
  }
}
