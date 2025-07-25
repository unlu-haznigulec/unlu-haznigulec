import 'package:design_system/components/search/recent_search_item.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

typedef OnRecentSearchItemTap = void Function(String recentSearchItem);

class RecentSearchesList extends StatelessWidget {
  final List<String> recentSearches;
  final OnRecentSearchItemTap onRecentSearchItemTap;

  const RecentSearchesList({
    Key? key,
    required this.recentSearches,
    required this.onRecentSearchItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentSearches.length,
      itemBuilder: (_, index) => RecentSearchItem(
        searchTermText: recentSearches[index],
        onTap: () => onRecentSearchItemTap(recentSearches[index]),
      ),
      separatorBuilder: (_, __) => const Divider(
        endIndent: Grid.m,
        indent: Grid.m,
        height: 1,
      ),
    );
  }
}
