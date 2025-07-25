import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFundFounderWidget extends StatelessWidget {
  const ShimmerFundFounderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Shimmer.fromColors(
      baseColor: context.pColorScheme.textSecondary.withValues(
        alpha: 0.3,
      ),
      highlightColor: context.pColorScheme.textSecondary.withValues(
        alpha: 0.1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          Grid.m,
        ),
        child: Row(
          spacing: Grid.s,
          children: [
            Column(
              spacing: Grid.xs,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  color: floatingColor,
                ),
                Container(
                  width: 68,
                  height: 10,
                  color: floatingColor,
                ),
              ],
            ),
            Column(
              spacing: Grid.xs,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  color: floatingColor,
                ),
                Container(
                  width: 72,
                  height: 12,
                  color: floatingColor,
                ),
              ],
            ),
            Column(
              spacing: Grid.xs,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  color: floatingColor,
                ),
                Container(
                  width: 68,
                  height: 10,
                  color: floatingColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
