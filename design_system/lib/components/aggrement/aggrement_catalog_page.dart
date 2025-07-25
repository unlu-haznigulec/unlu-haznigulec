import 'package:design_system/components/aggrement/aggrement_card.dart';
import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class AggrementCatalogPage extends StatelessWidget {
  const AggrementCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Aggrement catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Simple Aggrement Usage:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          PAggrementCard(onTap: () {}, testText: '01.01.2024'),
        ],
      ),
    );
  }
}
