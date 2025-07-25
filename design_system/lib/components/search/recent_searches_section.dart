import 'package:design_system/components/search/recent_searches_header_section.dart';
import 'package:design_system/components/search/recent_searches_list.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/widgets.dart';

class RecentSearchesSection extends StatelessWidget {
  final OnRecentSearchItemTap onRecentSearchItemTap;
  final VoidCallback onClearAllTap;
  final List<String> recentSearches;
  final String sectionHeaderText;
  final String clearAllText;

  const RecentSearchesSection({
    super.key,
    required this.onRecentSearchItemTap,
    required this.onClearAllTap,
    required this.recentSearches,
    required this.sectionHeaderText,
    required this.clearAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (recentSearches.isNotEmpty) ...[
          RecentSearchesHeaderSection(
            onClearAllTap: onClearAllTap,
            sectionHeaderText: sectionHeaderText,
            clearAllText: clearAllText,
          ),
          RecentSearchesList(
            onRecentSearchItemTap: onRecentSearchItemTap,
            recentSearches: recentSearches,
          ),
          const SizedBox(height: Grid.xs),
        ],
      ],
    );
  }
}
