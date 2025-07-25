// Dropdown larda kullanılan seçili olan row'un iconu
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';

class RadioSelectedIcon extends StatelessWidget {
  const RadioSelectedIcon({super.key, required this.isSelected});
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: Grid.xs,
        right: Grid.xs,
        bottom: Grid.xs,
      ),
      decoration: !isSelected
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).unselectedWidgetColor,
              ),
            )
          : null,
      child: isSelected
          ? Image.asset(
              DesignImagesPath.doneOrange,
              width: 15,
              height: 15,
              fit: BoxFit.cover,
            )
          : const SizedBox(),
    );
  }
}
