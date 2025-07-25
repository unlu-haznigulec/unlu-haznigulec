import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class RadioUnselectedButton extends StatelessWidget {
  const RadioUnselectedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.only(
        top: Grid.xs,
        right: Grid.xs,
        bottom: Grid.xs,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
    );
  }
}
