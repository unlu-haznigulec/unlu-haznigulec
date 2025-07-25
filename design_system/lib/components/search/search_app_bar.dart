import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchFieldController;
  final ValueChanged<String> onSearchTermSubmitted;
  final FocusNode? focusNode;
  final bool isAutoFocusEnabled;
  final String? searchBarHint;

  const SearchAppBar({
    Key? key,
    required this.searchFieldController,
    required this.onSearchTermSubmitted,
    this.focusNode,
    this.isAutoFocusEnabled = true,
    this.searchBarHint,
  }) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _searchFieldController;
  late String _currentSearchText;

  @override
  void initState() {
    _searchFieldController = widget.searchFieldController;
    _currentSearchText = _searchFieldController.text;
    _searchFieldController.addListener(_searchControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _searchFieldController.removeListener(_searchControllerListener);
    super.dispose();
  }

  void _searchControllerListener() {
    if (_currentSearchText != _searchFieldController.text) {
      setState(() {
        _currentSearchText = _searchFieldController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PSearchAppBar(
      titleSpacing: Grid.s,
      autoFocus: widget.isAutoFocusEnabled,
      searchBarHint: widget.searchBarHint,
      searchBarHintStyle: context.pAppStyle.interRegularBase.copyWith(
        fontSize: Grid.m,
        color: context.pColorScheme.darkLow,
        height: lineHeight150,
      ),
      searchBarIconColor: context.pColorScheme.primary,
      searchBarBorderRadius: Grid.xs,
      searchBarBackgroundColor: context.pColorScheme.lightHigh,
      controller: widget.searchFieldController,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSearchTermSubmitted,
      onClear: () => setState(() => widget.searchFieldController.clear()),
    );
  }
}
