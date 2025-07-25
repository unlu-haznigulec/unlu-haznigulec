import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PSymbolChip extends StatelessWidget {
  final String price;
  final String percentage;
  final bool isProfit;
  const PSymbolChip({
    super.key,
    required this.price,
    required this.percentage,
    required this.isProfit,
  });

  @override
  Widget build(BuildContext context) {
    final Color trendColor = isProfit ? context.pColorScheme.success : context.pColorScheme.primary;
    final IconData trendingIcon = isProfit ? Icons.trending_up : Icons.trending_down;
    return Container(
      height: 36,
      padding: const EdgeInsets.all(
        Grid.xxs,
      ),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(
          0.15,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.abc,
            size: 28,
          ),
          const SizedBox(
            width: Grid.xxs,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: Grid.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  price,
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelReg12textPrimary,
                ),
                Row(
                  children: [
                    Icon(
                      trendingIcon,
                      size: Grid.m,
                      color: trendColor,
                    ),
                    const SizedBox(
                      width: Grid.xxs,
                    ),
                    Text(
                      percentage,
                      textAlign: TextAlign.right,
                      style: context.pAppStyle.labelReg12textPrimary.copyWith(color: trendColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
