import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 80,
      decoration: BoxDecoration(
        color: floatingColor,
        borderRadius: BorderRadius.circular(
          Grid.m,
        ),
      ),
    );
  }
}
