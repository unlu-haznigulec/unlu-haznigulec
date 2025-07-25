import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/date/date.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class DateCatalogPage extends StatelessWidget {
  const DateCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Date catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Simple Date Usage:',
            style: context.pAppStyle.interMediumBase
                .copyWith(
                  fontSize: Grid.m,
                  height: lineHeight125,
                )
                .copyWith(),
          ),
          const SizedBox(height: Grid.m),
          PDate(
            date: DateTime.now().toString(),
          ),
        ],
      ),
    );
  }
}
