import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';

class BlueBoxDecoration {
  BoxDecoration pBlueBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
        image: AssetImage(
          DesignImagesPath.readyPortfolioBlue,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
