import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/list/list_item.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PageHeaderPicker extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback onAction;

  const PageHeaderPicker({
    Key? key,
    required this.icon,
    required this.text,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.pColorScheme.lightHigh,
      height: Grid.xxl,
      child: Row(
        children: [
          Expanded(
            child: PListItem(
              title: text,
              leading: icon,
            ),
          ),
          PTextButton(
            text: 'change',
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}
