import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class TradingHourRowWidget extends StatelessWidget {
  final String iconPath;
  final String text;

  const TradingHourRowWidget({
    required this.iconPath,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: Grid.m,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Text(
          text,
          style: context.pAppStyle.labelMed14textSecondary,
        ),
      ],
    );
  }
}
