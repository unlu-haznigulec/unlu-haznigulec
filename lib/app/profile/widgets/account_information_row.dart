import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class AccountInformationRow extends StatelessWidget {
  final String title;
  final String subTitle;

  const AccountInformationRow({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
          const SizedBox(
            height: Grid.xs,
          ),
          Text(
            subTitle,
            textAlign: TextAlign.start,
            style: context.pAppStyle.labelMed16textSecondary,
          ),
          const SizedBox(
            height: Grid.s,
          ),
          const PDivider(),
        ],
      ),
    );
  }
}
