import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';

class RadioSelectedButton extends StatelessWidget {
  const RadioSelectedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: Grid.xs,
        right: Grid.xs,
        bottom: Grid.xs,
      ),
      child: Image.asset(
        DesignImagesPath.doneOrange,
        width: 15,
        height: 15,
        fit: BoxFit.cover,
      ),
    );
  }
}
