import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/widgets/components_tile_widget.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

class BottomsheetComponentsWidget extends StatefulWidget {
  final OverallItemModel assets;
  final bool isDefaultParity;
  final double totalUsdOverall;
  final bool isVisible;

  const BottomsheetComponentsWidget({
    super.key,
    required this.assets,
    required this.isDefaultParity,
    required this.totalUsdOverall,
    required this.isVisible,
  });

  @override
  State<BottomsheetComponentsWidget> createState() => _BottomsheetComponentsWidgetState();
}

class _BottomsheetComponentsWidgetState extends State<BottomsheetComponentsWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrollbarVisible = false;

  void _checkIfScrollbarNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final needsScrollbar = _scrollController.position.maxScrollExtent > 0;
      if (_isScrollbarVisible != needsScrollbar && mounted) {
        setState(() {
          _isScrollbarVisible = needsScrollbar;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkIfScrollbarNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfScrollbarNeeded());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfScrollbarNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thumbColor: context.pColorScheme.iconPrimary,
      thickness: 2.0,
      minThumbLength: 83,
      trackRadius: const Radius.circular(Grid.xxs),
      radius: const Radius.circular(Grid.xxs),
      padding: EdgeInsets.only(left: _isScrollbarVisible ? Grid.m - Grid.xxs : 0.0), // Scrollbar varsa sağ padding
      child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: widget.assets.overallSubItems.length,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) => ComponentsTileWidget(
          isVisible: widget.isVisible,
          scrollPadding: _isScrollbarVisible ? Grid.m - Grid.xxs : 0.0,
          instrumentCategory: widget.assets.instrumentCategory,
          overallSubItems: widget.assets.overallSubItems[index],
          isDefaultParity: widget.isDefaultParity,
          totalUsdOverall: widget.totalUsdOverall,
          totalAmount: widget.assets.totalAmount,
          index: index,
          lastIndex: widget.assets.overallSubItems.length - 1,
        ),
      ),
    );
  }
}
