import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AgreementsFormCardTile extends StatelessWidget {
  final String leadingText;
  final String trailingText;

  const AgreementsFormCardTile({
    super.key,
    required this.leadingText,
    required this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.tr(leadingText),
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              const SizedBox(width: Grid.s),
              Expanded(
                child: Text(
                  trailingText,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
