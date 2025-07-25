import 'package:flutter/material.dart';

class ListSwitcher extends StatelessWidget {
  final bool showList;
  final Function() onToggleList;

  const ListSwitcher({
    super.key,
    required this.showList,
    required this.onToggleList,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        showList ? Icons.grid_view_outlined : Icons.menu,
      ),
      highlightColor: Colors.white,
      onPressed: onToggleList,
      color: Theme.of(context).dividerColor.withOpacity(
            0.2,
          ),
    );
  }
}
