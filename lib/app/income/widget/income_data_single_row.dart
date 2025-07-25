import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class IncomeDataSingleRow extends StatelessWidget {
  final String title;
  final double value;
  const IncomeDataSingleRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            title,
            style: context.pAppStyle.labelReg14textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          '₺${MoneyUtils().compactMoney(value)}'.trim(),
          style: context.pAppStyle.labelMed14textPrimary,
        ),
        const SizedBox(
          width: Grid.m,
        ),
      ],
    );
  }
}
