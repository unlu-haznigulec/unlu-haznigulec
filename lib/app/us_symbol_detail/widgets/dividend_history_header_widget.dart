import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class DividendHistoryHeaderWidget extends StatelessWidget {
  final String title1;
  final String title2;
  const DividendHistoryHeaderWidget({
    super.key,
    required this.title1,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title1,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                title2,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
