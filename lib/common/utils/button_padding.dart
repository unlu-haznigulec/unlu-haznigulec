import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

Container generalButtonPadding({
  Widget? child,
  required BuildContext context,
  double? leftPadding,
  double? rightPadding,
  double? bottomPadding,
}) {
  return Container(
    color: context.pColorScheme.backgroundColor,
    padding: EdgeInsets.only(
      left: leftPadding ?? Grid.m,
      right: rightPadding ?? Grid.m,
      bottom: MediaQuery.paddingOf(context).bottom + (bottomPadding ?? Grid.xs),
    ),
    child: child,
  );
}
