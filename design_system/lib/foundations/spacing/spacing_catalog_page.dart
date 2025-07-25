import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class SpacingCatalogPage extends StatelessWidget {
  const SpacingCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Spacing catalog'),
      body: Padding(
        padding: const EdgeInsets.all(Grid.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'XS (4dp):',
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m),
            ),
            const SizedBox(height: Grid.s),
            Container(width: Grid.xs, height: Grid.s, color: context.pColorScheme.primary),
            const SizedBox(height: Grid.m),
            Text(
              'S (8dp):',
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m),
            ),
            const SizedBox(height: Grid.s),
            Container(width: Grid.s, height: Grid.s, color: context.pColorScheme.primary),
            const SizedBox(height: Grid.m),
            Text(
              'M (16dp):',
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m),
            ),
            const SizedBox(height: Grid.s),
            Container(width: Grid.m, height: Grid.s, color: context.pColorScheme.primary),
            const SizedBox(height: Grid.m),
            Text(
              'L (24dp):',
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m),
            ),
            const SizedBox(height: Grid.s),
            Container(width: Grid.l, height: Grid.s, color: context.pColorScheme.primary),
            const SizedBox(height: Grid.m),
            Text(
              'XL (40dp):',
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m),
            ),
            const SizedBox(height: Grid.s),
            Container(width: Grid.xl, height: Grid.s, color: context.pColorScheme.primary),
            const SizedBox(height: Grid.m),
            Text(
              'XXL (48dp):',
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m),
            ),
            const SizedBox(height: Grid.s),
            Container(width: Grid.xxl, height: Grid.s, color: context.pColorScheme.primary),
          ],
        ),
      ),
    );
  }
}
