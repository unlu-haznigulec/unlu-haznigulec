import 'package:design_system/utils/app_styles.dart';
import 'package:design_system/utils/app_theme.dart';
import 'package:design_system/utils/color_scheme.dart';
import 'package:flutter/material.dart';

extension PThemeContextExtension on BuildContext {
  ThemeData get pTheme => Theme.of(this);
  PAppStyles get pAppStyle => pTheme.pAppStyle;
  PColorScheme get pColorScheme => pTheme.pColorScheme;
}

extension PThemeExtension on ThemeData {
  PAppStyles get pAppStyle => extension<PAppStyles>() ?? PAppStyles(PAppThemes.getPColorSchema(brightness: brightness));
  PColorScheme get pColorScheme => extension<PColorScheme>() ?? PAppThemes.getPColorSchema(brightness: brightness);
}
