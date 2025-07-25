import 'package:design_system/components/charts/model/stacked_bar_model.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class StackedBarChart extends StatelessWidget {
  final List<StackedBarModel> charDataList;
  final double height;
  final double? width;
  const StackedBarChart({
    super.key,
    required this.charDataList,
    this.width,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    final double chartWidth = width ?? (MediaQuery.of(context).size.width - Grid.m * 2);
    final double totalPercent =
        charDataList.isEmpty ? 100 : charDataList.map((model) => model.percent).reduce((a, b) => a + b);
    return SizedBox(
      height: height,
      width: chartWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Grid.s),
        child: Row(
          children: charDataList.isEmpty
              ? [
                  Container(width: chartWidth, color: context.pColorScheme.assetColors.last),
                ]
              : charDataList.map((StackedBarModel model) {
                  return Container(
                    width: (chartWidth * model.percent) / totalPercent,
                    color: model.color,
                  );
                }).toList(),
        ),
      ),
    );
  }
}
