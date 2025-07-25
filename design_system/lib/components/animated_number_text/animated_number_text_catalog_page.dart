import 'dart:async';

import 'package:design_system/components/animated_number_text/animated_number_text.dart';
import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class AnimatedNumberTextCatalogPage extends StatefulWidget {
  const AnimatedNumberTextCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _AnimatedNumberTextCatalogPageState();
}

class _AnimatedNumberTextCatalogPageState extends State<AnimatedNumberTextCatalogPage> {
  late Timer timer;
  int number = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer t) {
        setState(() {
          number += 10;
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Animated number text catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Animated number text widget:',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs,
              height: lineHeight125,
            ),
          ),
          Text(
            '(Configured as the number will increase by 10 every 3 seconds)',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m - Grid.xxs,
              height: lineHeight150,
            ),
          ),
          const SizedBox(height: Grid.s),
          AnimatedNumberText(
            value: number,
            textStyle: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.primary,
              height: lineHeight125,
            ),
          ),
        ],
      ),
    );
  }
}
