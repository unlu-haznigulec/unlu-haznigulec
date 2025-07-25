import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class RecentSearchesHeaderSection extends StatelessWidget {
  final VoidCallback onClearAllTap;
  final String sectionHeaderText;
  final String clearAllText;

  const RecentSearchesHeaderSection({
    Key? key,
    required this.onClearAllTap,
    required this.sectionHeaderText,
    required this.clearAllText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Grid.m),
      color: context.pColorScheme.lightHigh,
      child: Row(
        children: <Widget>[
          Text(
            sectionHeaderText,
            style: context.pAppStyle.labelMed18darkHigh.copyWith(
              height: lineHeight125,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onClearAllTap,
            child: Text(
              clearAllText,
              style: context.pAppStyle.labelMed18primary.copyWith(
                height: lineHeight125,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
