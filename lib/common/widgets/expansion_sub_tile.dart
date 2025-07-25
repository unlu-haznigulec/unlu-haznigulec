import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class ExpansionSubTile extends StatelessWidget {
  final String title;
  final String value;
  const ExpansionSubTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.xs,
        ),
        SizedBox(
          height: 22,
          child: Row(
            children: [
              Text(
                title,
                style: context.pAppStyle.labelReg12textSecondary,
              ),
              const Spacer(),
              Text(
                value,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
