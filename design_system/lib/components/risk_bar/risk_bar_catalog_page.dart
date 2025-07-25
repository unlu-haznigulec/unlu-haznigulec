import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/risk_bar/risk_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class RiskBarCatalogPage extends StatefulWidget {
  const RiskBarCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonCatalogPageCatalogPageState();
}

class _ButtonCatalogPageCatalogPageState extends State<RiskBarCatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Risk Bar Catalog'),
      body: const SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: Grid.xl,
            ),
            RiskBar(
              riskLevel: 1,
            ),
            RiskBar(
              riskLevel: 2,
            ),
            RiskBar(
              riskLevel: 3,
            ),
            RiskBar(
              riskLevel: 4,
            ),
            RiskBar(
              riskLevel: 5,
            ),
            RiskBar(
              riskLevel: 6,
            ),
            RiskBar(
              riskLevel: 7,
            ),
          ],
        ),
      ),
    );
  }
}
