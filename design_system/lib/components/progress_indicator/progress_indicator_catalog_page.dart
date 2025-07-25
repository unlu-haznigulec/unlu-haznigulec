import 'dart:async';

import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/progress_indicator/progress_indicator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorCatalogPage extends StatefulWidget {
  const ProgressIndicatorCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProgressIndicatorCatalogPageState();
}

class _ProgressIndicatorCatalogPageState extends State<ProgressIndicatorCatalogPage> {
  late double _value;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _value = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) => setState(() => _value += 0.01));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Progress indicator catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Indeterminate Circular Progress Indicator:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PCircularProgressIndicator(),
          const SizedBox(height: Grid.l),
          Text('Indeterminate Linear Progress Indicator:',
              style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PLinearProgressIndicator(),
          const SizedBox(height: Grid.xl),
          Text(
            'Width Limited Indeterminate Linear Progress Indicator:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const Column(children: <Widget>[PLinearProgressIndicator(width: Grid.xxl * 3)]),
          const SizedBox(height: Grid.xl),
          Text(
            'Determinate Circular Progress Indicator:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          PCircularProgressIndicator(value: _value),
          const SizedBox(height: Grid.l),
          Text('Determinate Linear Progress Indicator:',
              style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          PLinearProgressIndicator(value: _value),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }
}
