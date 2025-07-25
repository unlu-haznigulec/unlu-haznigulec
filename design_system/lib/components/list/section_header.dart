import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String header;
  final Color? color;

  const SectionHeader({
    Key? key,
    required this.header,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? context.pColorScheme.transparent,
      padding: const EdgeInsets.only(top: Grid.l, bottom: Grid.s),
      child: Row(
        children: <Widget>[
          const SizedBox(width: Grid.m),
          Expanded(
            child: Text(
              header,
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m + Grid.xxs,
                height: lineHeight125,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
