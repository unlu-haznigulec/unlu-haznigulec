import 'package:design_system/components/list/list_item.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class RecentSearchItem extends StatelessWidget {
  final VoidCallback onTap;
  final String searchTermText;

  const RecentSearchItem({
    Key? key,
    required this.onTap,
    required this.searchTermText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PListItem(
      onTap: onTap,
      leading: Icon(Icons.access_time_filled, color: context.pColorScheme.darkMedium),
      title: searchTermText,
      titleStyle: context.pAppStyle.interRegularBase.copyWith(
        fontSize: Grid.m + Grid.xxs,
        color: context.pColorScheme.darkHigh,
        height: lineHeight150,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 24,
        color: context.pColorScheme.iconPrimary.shade700,
        textDirection: Directionality.of(context),
      ),
    );
  }
}
