import 'package:design_system/components/rich_text_field/rich_text.dart';
import 'package:design_system/components/rich_text_field/rich_text_controller.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class ExpandableRichText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  final Function(bool)? onExpand;
  final List<PRichTextPattern>? patterns;
  final TextStyle? style;
  final bool ignoreReadMore;

  const ExpandableRichText({
    Key? key,
    required this.text,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.onExpand,
    this.patterns,
    this.style,
    this.ignoreReadMore = false,
  }) : super(key: key);

  @override
  ExpandableRichTextState createState() => ExpandableRichTextState();
}

class ExpandableRichTextState extends State<ExpandableRichText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PRichText(
          text: widget.text,
          style: widget.style ??
              context.pAppStyle.interRegularBase.copyWith(
                fontSize: Grid.s + Grid.xs + Grid.xxs,
                color: context.pColorScheme.darkMedium,
                height: lineHeight150,
              ),
          maxLines: _expanded ? 1000 : widget.maxLines,
          overflow: widget.overflow,
          patterns: widget.patterns,
        ),
        LayoutBuilder(
          builder: (_, BoxConstraints size) {
            return _didExceedMaxLines(
              widget.text,
              maxLines: widget.maxLines,
              width: size.maxWidth,
            )
                ? InkWell(
                    onTap: !widget.ignoreReadMore
                        ? () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                            widget.onExpand?.call(_expanded);
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Grid.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expanded ? 'see less' : 'read more',
                            style: context.pAppStyle.labelMed16primary,
                          ),
                          const SizedBox(width: Grid.s),
                          Icon(
                            _expanded ? StreamlineIcons.arrow_button_up : StreamlineIcons.arrow_button_down,
                            size: 12,
                            color: context.pColorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  bool _didExceedMaxLines(
    String text, {
    int maxLines = 2,
    double width = 0.0,
  }) {
    final TextPainter tp = TextPainter(
      maxLines: maxLines,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: widget.style ??
            context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs + Grid.xxs,
              color: context.pColorScheme.darkMedium,
              height: lineHeight150,
            ),
      ),
    );

    tp.layout(maxWidth: width);

    return tp.didExceedMaxLines;
  }
}
