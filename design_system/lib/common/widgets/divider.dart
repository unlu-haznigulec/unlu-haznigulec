import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';

class PDivider extends StatelessWidget {
  final Color? color;
  final double? tickness;
  final EdgeInsetsGeometry padding;

  const PDivider({
    super.key,
    this.color,
    this.tickness,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Divider(
        height: 0,
        thickness: tickness ?? 1,
        color: color ?? context.pColorScheme.line,
      ),
    );
  }
}
