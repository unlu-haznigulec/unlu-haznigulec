import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class DataInfoWidget extends StatelessWidget {
  final String title;
  final String data;
  const DataInfoWidget({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: Grid.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).unselectedWidgetColor,
                  fontSize: 14,
                ),
          ),
          Expanded(
            child: AutoSizeText(
              data,
              maxLines: 1,
              minFontSize: 14,
              maxFontSize: 18,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).hoverColor,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
