import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class LicenseCancelButton extends StatelessWidget {
  final VoidCallback onTap;
  const LicenseCancelButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      child: PCustomOutlinedButtonWithIcon(
        text: L10n.tr('iptal_et'),
        icon: Icon(
          Icons.arrow_outward_rounded,
          size: Grid.m,
          color: context.pColorScheme.critical,
        ),
        foregroundColor: context.pColorScheme.critical,
        foregroundColorApllyBorder: false,
        buttonType: PCustomOutlinedButtonTypes.smallPrimary,
        textStyle: context.pAppStyle.labelMed14textSecondary.copyWith(
          color: context.pColorScheme.critical,
        ),
        onPressed: onTap,
      ),
    );
  }
}
