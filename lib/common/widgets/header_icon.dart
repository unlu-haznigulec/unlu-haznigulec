import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';

class PHeaderIcon extends StatelessWidget {
  const PHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImagesPath.piapiriCombinedShape,
      width: 25,
      height: 25,
      color: Theme.of(context).hoverColor,
    );
  }
}
