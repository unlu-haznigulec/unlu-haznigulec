import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/skeleton_card/skeleton_card.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class SkeletonCardCatalogPage extends StatelessWidget {
  const SkeletonCardCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Progress indicator catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Circular and bottom line active:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PSkeletonCard(),
          const SizedBox(height: Grid.l),
          Text('Without Circular and bottom line not active:',
              style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PSkeletonCard(
            isCircularImage: false,
            isBottomLinesActive: false,
          ),
          const SizedBox(height: Grid.l),
          Text('Without leading avatar',
              style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PSkeletonCard(
            haveLeading: false,
          ),
          const SizedBox(height: Grid.l),
        ],
      ),
    );
  }
}
