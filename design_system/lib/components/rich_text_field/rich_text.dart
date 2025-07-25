import 'package:design_system/components/rich_text_field/rich_text_controller.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class PRichText extends StatelessWidget {
  final PRichTextController _controller;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  PRichText({
    Key? key,
    required String text,
    this.maxLines,
    this.overflow,
    bool interaction = true,
    this.style,
    List<PRichTextPattern>? patterns,
    PRichTextController? controller,
  })  : assert(maxLines == null || maxLines > 0),
        _controller = controller ?? PRichTextController(text: text, interaction: interaction, patterns: patterns),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      text: _controller.buildTextSpan(
        style: style ??
            context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs + Grid.xxs,
              height: lineHeight150,
              color: context.pColorScheme.darkHigh,
            ),
      ),
      overflow: overflow ?? TextOverflow.visible,
    );
  }
}
