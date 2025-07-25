import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/string_utils.dart';

enum PLozengeSize { small, medium }

enum PLozengeVariant { success, warning, critical, info, neutral }

enum PLozengeEmphasis { regular, high }

class PLozenge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color? textColor;
  final IconData icon;
  final Color? iconColor;
  final PLozengeSize size;
  final PLozengeEmphasis emphasis;
  final bool withIcon;
  final double maxWidth;
  final TextOverflow textOverflow;

  const PLozenge.withColor({
    Key? key,
    required this.text,
    required this.backgroundColor,
    PLozengeSize? size,
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.iconColor,
  })  : icon = StreamlineIcons.check_circle_1,
        size = size ?? PLozengeSize.medium,
        emphasis = PLozengeEmphasis.regular,
        withIcon = false,
        maxWidth = 200,
        super(key: key);

  const PLozenge.custom({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.iconColor,
    this.textOverflow = TextOverflow.ellipsis,
  })  : icon = StreamlineIcons.check_circle_1,
        size = PLozengeSize.medium,
        emphasis = PLozengeEmphasis.regular,
        withIcon = false,
        maxWidth = 200,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        height: size == PLozengeSize.small ? 18 : 24,
        padding: const EdgeInsets.symmetric(horizontal: Grid.s),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Grid.xs),
        ),
        child: Center(
          widthFactor: 1,
          child: LayoutBuilder(
            builder: (context, s) {
              final TextSpan span = TextSpan(
                text: text,
                style: size == PLozengeSize.small
                    ? context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.s + Grid.xs)
                    : context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.s + Grid.xs + Grid.xxs),
              );
              final TextPainter tp = TextPainter(
                maxLines: 1,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                text: span,
              );
              tp.layout(maxWidth: s.maxWidth);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...withIcon == true
                      ? [
                          Icon(
                            icon,
                            size: size == PLozengeSize.small ? 12 : 16,
                            color: iconColor ?? context.pColorScheme.iconPrimary,
                          ),
                          const SizedBox(width: Grid.xs),
                        ]
                      : [],
                  Flexible(
                    child: Text(
                      StringUtils.capitalize(text),
                      style: size == PLozengeSize.small
                          ? context.pAppStyle.interRegularBase.copyWith(
                              fontSize: tp.didExceedMaxLines ? 11 : 12,
                              color: textColor ?? context.pColorScheme.textPrimary,
                            )
                          : context.pAppStyle.interRegularBase.copyWith(
                              fontSize: tp.didExceedMaxLines ? 11 : 12,
                              color: textColor ?? context.pColorScheme.textPrimary,
                            ),
                      overflow: textOverflow,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
