import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ShimmerParityListWidget extends StatelessWidget {
  const ShimmerParityListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Padding(
      padding: const EdgeInsets.all(
        Grid.m,
      ),
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Divider(),
        ),
        itemBuilder: (context, index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: Grid.xs,
              children: [
                ClipOval(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: floatingColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Grid.xs,
                  children: [
                    Container(
                      width: 40,
                      height: 15,
                      color: floatingColor,
                    ),
                    Container(
                      width: 60,
                      height: 15,
                      color: floatingColor,
                    ),
                  ],
                )
              ],
            ),
            Container(
              width: 60,
              height: 15,
              color: floatingColor,
            ),
            Container(
              width: 60,
              height: 15,
              color: floatingColor,
            ),
          ],
        ),
      ),
    );
  }
}
