import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/date_stepper/date_stepper.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class DateStepperCatalogPage extends StatelessWidget {
  const DateStepperCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Date stepper catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Simple DateStepper Usage:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PDateStepper(
            topText: 'Sept 21, 2022',
            bottomText: 'Oct 8, 2022',
          ),
        ],
      ),
    );
  }
}
