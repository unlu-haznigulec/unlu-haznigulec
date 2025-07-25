import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/inapp_viewer/inapp_viewer.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class InAppViewerCatalogPage extends StatelessWidget {
  const InAppViewerCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'InApp Viewer catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Simple InApp Viewer Usage:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PInappViewer(
            url: 'url',
          ),
        ],
      ),
    );
  }
}
