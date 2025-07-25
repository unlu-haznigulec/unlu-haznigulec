import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class SymbolAboutTile extends StatelessWidget {
  final String leading;
  final Widget? afterLeading;
  final String trailing;
  final TextStyle? trailingStyle;
  final TextStyle? leadingStyle;
  final bool ignoreHeight;
  const SymbolAboutTile({
    super.key,
    required this.leading,
    required this.trailing,
    this.trailingStyle,
    this.leadingStyle,
    this.ignoreHeight = false,
    this.afterLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: SizedBox(
        height: ignoreHeight ? null : 22,
        width: MediaQuery.of(context).size.width - (Grid.m * 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              leading,
              style: leadingStyle ?? context.pAppStyle.labelReg16textSecondary,
            ),
            if (afterLeading != null) ...[
              const SizedBox(width: Grid.xxs),
              afterLeading!,
            ],
            const SizedBox(
              width: Grid.m,
            ),
            Expanded(
              child: AutoSizeText(
                trailing,
                textAlign: TextAlign.end,
                style: trailingStyle ?? context.pAppStyle.labelMed16textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
