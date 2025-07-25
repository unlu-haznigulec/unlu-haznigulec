import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

/// Creates a widget that can be expanded or collapsed to show or hide
/// its children.
///
/// The [title] and [children] arguments must not be null.
///
/// The [initiallyExpanded] argument must be non-null but defaults to false.
/// If null, the widget will be collapsed.
///
/// The [titleStyle] argument defaults to the [PTypography.body1] style
/// from the ambient [Theme].
///
/// The [childrenPadding] argument defaults to 16.0 pixels on the left.
///
/// The [childrenColor] argument defaults to the [context.pColorScheme.stroke] color.
///
/// The [disabled] argument defaults to false. If true, the widget will
/// be shown as disabled, regardless of the value of [onExpansionChanged].
///
/// The [optional] argument defaults to false. If true, the widget will
/// be shown as optional.
///
/// The [onExpansionChanged] argument must be non-null but defaults to
/// an empty function. If null, the widget will be shown as disabled.
///
/// The [children] argument must be non-null and must not contain any null
/// values.
class PExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Function(bool)? onExpansionChanged;
  final bool initiallyExpanded;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry childrenPadding;
  final Color? childrenColor;
  final bool disabled;
  final bool optional;

  const PExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    this.onExpansionChanged,
    this.initiallyExpanded = true,
    this.titleStyle,
    this.childrenPadding = const EdgeInsetsDirectional.only(start: Grid.m, end: Grid.l),
    this.childrenColor,
    this.disabled = false,
    this.optional = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: ExpansionTile(
        onExpansionChanged: onExpansionChanged,
        initiallyExpanded: initiallyExpanded,
        collapsedIconColor: disabled ? context.pColorScheme.darkLow : context.pColorScheme.darkHigh,
        backgroundColor: context.pColorScheme.lightHigh,
        collapsedBackgroundColor: context.pColorScheme.lightHigh,
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: const EdgeInsets.symmetric(vertical: Grid.xs, horizontal: Grid.m),
        iconColor: context.pColorScheme.primary,
        title: optional
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: titleStyle ??
                          context.pAppStyle.interRegularBase.copyWith(
                            fontSize: Grid.m,
                            color: context.pColorScheme.darkHigh,
                            height: lineHeight150,
                          ),
                    ),
                    const WidgetSpan(child: SizedBox(width: Grid.xs)),
                    TextSpan(
                      text: 'label',
                      style: context.pAppStyle.labelReg16darkMedium.copyWith(height: lineHeight150),
                    ),
                  ],
                ),
              )
            : Text(
                title,
                style: titleStyle ??
                    context.pAppStyle.interRegularBase.copyWith(
                      fontSize: Grid.m,
                      color: context.pColorScheme.darkHigh,
                      height: lineHeight150,
                    ),
              ),
        children: <Widget>[
          ColoredBox(
            color: childrenColor ?? context.pColorScheme.lightHigh,
            child: Padding(
              padding: childrenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: context.pColorScheme.stroke.shade100,
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  ...children,
                  const SizedBox(
                    height: Grid.s,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
