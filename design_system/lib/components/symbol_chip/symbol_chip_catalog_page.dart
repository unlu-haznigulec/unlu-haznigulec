import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/symbol_chip/symbol_chip.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';

class SymbolChipCatalogPage extends StatelessWidget {
  const SymbolChipCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Symbol Chip catalog'),
      body: SizedBox(
        height: 36,
        child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) => PSymbolChip(
            price: '9.614,10',
            percentage: '%0,04',
            isProfit: (index % 2) == 0,
          ),
        ),
      ),
    );
  }
}
