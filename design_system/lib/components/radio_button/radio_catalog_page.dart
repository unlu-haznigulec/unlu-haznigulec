import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/radio_button/radio_button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

List<Widget> listWidget = List.empty(growable: true);

class RadioCatalogPage extends StatelessWidget {
  const RadioCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Radio Button catalog'),
      body: ListView(
        padding: const EdgeInsets.all(
          Grid.m,
        ),
        children: <Widget>[
          Text(
            'Simple Radio Button Usage:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          _radioButton(),
        ],
      ),
    );
  }

  Column _radioButton() {
    final List<String> sampleList = ['AKBNK, GARAN'];
    final List<Widget> listWidget = List.empty(growable: true);
    for (var i = 0; i < sampleList.length; i++) {
      listWidget.add(
        PRadioButton<int>(
          value: i,
          groupValue: 1,
          leading: sampleList[i],
          onChanged: (value) {},
        ),
      );
    }
    return Column(
      children: listWidget,
    );
  }
}
