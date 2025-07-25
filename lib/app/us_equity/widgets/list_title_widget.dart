import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ListTitleWidget extends StatelessWidget {
  final String leadingTitle;
  final String trailingTitle;
  final bool? hasTopDivider;
  const ListTitleWidget({
    super.key,
    required this.leadingTitle,
    required this.trailingTitle,
    this.hasTopDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasTopDivider!) ...[
          const SizedBox(
            height: Grid.m,
          ),
          const Divider(),
        ],
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        Row(
          children: [
            Text(
              L10n.tr(leadingTitle),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const Spacer(),
            Text(
              L10n.tr(trailingTitle),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
          ],
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        const Divider(),
      ],
    );
  }
}
