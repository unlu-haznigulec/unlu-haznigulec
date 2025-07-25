import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/app_styles.dart';
import 'package:design_system/utils/color_scheme.dart';
import 'package:flutter/material.dart';

class PAppThemes {
  static ThemeData lightTheme = _getThemeData(brightness: Brightness.light);
  static ThemeData darkTheme = _getThemeData(brightness: Brightness.dark);
  static ThemeData _getThemeData({required Brightness brightness}) {
    final pColorScheme = getPColorSchema(brightness: brightness);
    final pAppStyle = PAppStyles(pColorScheme);
    return ThemeData(
      useMaterial3: false,
      brightness: brightness,
      applyElevationOverlayColor: true,
      platform: TargetPlatform.android,
      visualDensity: VisualDensity.standard,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: pColorScheme.primary,
        onPrimary: pColorScheme.darkHigh,
        secondary: pColorScheme.secondary,
        onSecondary: pColorScheme.darkHigh,
        error: pColorScheme.critical,
        onError: pColorScheme.lightHigh,
        surface: pColorScheme.lightHigh,
        onSurface: pColorScheme.darkHigh,
      ),
      primarySwatch: pColorScheme.primary,
      splashColor: pColorScheme.transparent,
      highlightColor: pColorScheme.transparent,
      primaryColor: pColorScheme.primary,
      canvasColor: pColorScheme.lightHigh,
      cardColor: pColorScheme.card,
      dialogBackgroundColor: pColorScheme.lightHigh,
      disabledColor: pColorScheme.line,
      focusColor: pColorScheme.primary,
      hintColor: pColorScheme.line,
      hoverColor: pColorScheme.primary.shade300,
      indicatorColor: pColorScheme.primary,
      primaryColorDark: pColorScheme.primary.shade800,
      primaryColorLight: pColorScheme.primary.shade200,
      scaffoldBackgroundColor: pColorScheme.backgroundColor,
      secondaryHeaderColor: pColorScheme.primary.shade200,
      shadowColor: pColorScheme.shadow,
      unselectedWidgetColor: pColorScheme.unselectedItemColor,
      fontFamily: 'Inter',
      extensions: [
        pColorScheme,
        pAppStyle,
      ],
      dividerTheme: DividerThemeData(
        color: pColorScheme.line,
        space: Grid.xs,
        thickness: 1,
        indent: 0.0,
        endIndent: 0.0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pColorScheme.backgroundColor,
        foregroundColor: pColorScheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: pAppStyle.labelReg18textPrimary,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: pColorScheme.backgroundColor,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: pColorScheme.backgroundColor,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: pColorScheme.primary,
        unselectedItemColor: pColorScheme.iconSecondary,
        selectedIconTheme: IconThemeData(color: pColorScheme.primary),
        unselectedIconTheme: IconThemeData(color: pColorScheme.iconSecondary),
        selectedLabelStyle: pAppStyle.interRegularBase.copyWith(
          color: pColorScheme.primary,
          fontSize: 12,
        ),
        unselectedLabelStyle: pAppStyle.interRegularBase.copyWith(
          color: pColorScheme.iconSecondary,
          fontSize: 12,
        ),
      ),
      cardTheme: CardTheme(
        color: pColorScheme.card,
        shadowColor: pColorScheme.shadow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Grid.s),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStatePropertyAll(pColorScheme.backgroundColor),
        checkColor: WidgetStatePropertyAll(pColorScheme.backgroundColor),
        side: BorderSide(color: pColorScheme.primary),
      ),
      chipTheme: ChipThemeData(
        brightness: brightness,
        backgroundColor: pColorScheme.backgroundColor,
        deleteIconColor: pColorScheme.primary,
        disabledColor: pColorScheme.line,
        labelStyle: TextStyle(color: pColorScheme.textPrimary),
        secondaryLabelStyle: TextStyle(color: pColorScheme.primary),
        secondarySelectedColor: pColorScheme.primary,
        selectedColor: pColorScheme.primary,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: pColorScheme.backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(color: pColorScheme.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Grid.l),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: pColorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.xl),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pColorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.xl),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: pColorScheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.s),
          ),
          side: BorderSide(
            color: pColorScheme.primary,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: pColorScheme.backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Grid.s)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: pColorScheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.s),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: pColorScheme.primary,
        foregroundColor: pColorScheme.backgroundColor,
        shape: CircleBorder(
          side: BorderSide(
            color: pColorScheme.primary,
            width: 2,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Grid.s),
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: pColorScheme.primary,
        textColor: pColorScheme.textPrimary,
        tileColor: pColorScheme.backgroundColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: pColorScheme.backgroundColor,
        indicatorColor: pColorScheme.primary,
        labelTextStyle: WidgetStatePropertyAll(pAppStyle.labelMed16textPrimary),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: pColorScheme.primary,
        circularTrackColor: pColorScheme.line,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStatePropertyAll(pColorScheme.primary),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: pColorScheme.primary,
        inactiveTrackColor: pColorScheme.line,
        thumbColor: pColorScheme.primary,
        overlayColor: pColorScheme.primary,
        valueIndicatorColor: pColorScheme.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: pColorScheme.backgroundColor,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(
          color: pColorScheme.textPrimary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(pColorScheme.primary),
        trackColor: WidgetStatePropertyAll(pColorScheme.line),
      ),
      tabBarTheme: TabBarTheme(
        labelPadding: const EdgeInsets.symmetric(horizontal: Grid.m),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: pColorScheme.primary,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: pAppStyle.interMediumBase.copyWith(
          fontSize: 16,
          color: pColorScheme.primary,
        ),
        unselectedLabelStyle: pAppStyle.interMediumBase.copyWith(
          fontSize: 16,
          color: pColorScheme.primary,
        ),
        labelColor: pColorScheme.primary,
        dividerHeight: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: pAppStyle.interRegularBase.copyWith(
          color: pColorScheme.textPrimary,
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        borderColor: pColorScheme.primary,
        selectedColor: pColorScheme.primary,
        fillColor: pColorScheme.primary,
        splashColor: pColorScheme.primary,
        selectedBorderColor: pColorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(Grid.s),
        ),
      ),
    );
  }

  static PColorScheme getPColorSchema({required Brightness brightness}) {
    return brightness == Brightness.light ? _getPLigtColorSchema() : _getPDarkColorSchema();
  }

  static PColorScheme _getPLigtColorSchema() {
    return PColorScheme(
      primary: const MaterialColor(
        0xFFeb5828,
        <int, Color>{
          50: Color(0xFFFeF4ee),
          100: Color(0xFFFce7d8),
          200: Color(0xFFF9cbaF),
          300: Color(0xFFF4a77d),
          400: Color(0xFFeF7848),
          500: Color(0xFFeb5828),
          600: Color(0xFFdc3c1a),
          700: Color(0xFFb72c17),
          800: Color(0xFF91251b),
          900: Color(0xFF3F0d0b),
        },
      ),
      secondary: const Color(0xFFFCE6DF),
      card: const MaterialColor(
        0xFFF4F5F7,
        <int, Color>{
          50: Color(0xFFF9FAFC),
          100: Color(0xFFF1F2F6),
          200: Color(0xFFE3E4EB),
          300: Color(0xFFD5D6E1),
          400: Color(0xFFC6C7D7),
          500: Color(0xFFF4F5F7),
          600: Color(0xFFD0D1D9),
          700: Color(0xFFB1B2BF),
          800: Color(0xFF9293A5),
          900: Color(0xFF73748B),
        },
      ),
      line: const MaterialColor(
        0xFFE9EAEE,
        <int, Color>{
          50: Color(0xFFF7F8FB),
          100: Color(0xFFEDF0F7),
          200: Color(0xFFD6D9E9),
          300: Color(0xFFBEC2DB),
          400: Color(0xFFB0B4D2),
          500: Color(0xFFE9EAEE),
          600: Color(0xFFD0D3DB),
          700: Color(0xFFB0B4C8),
          800: Color(0xFF9093B5),
          900: Color(0xFF70769E),
        },
      ),
      stroke: const MaterialColor(
        0xFFE7E6EB,
        <int, Color>{
          50: Color(0xFFF9F8FC),
          100: Color(0xFFF1F0F7),
          200: Color(0xFFD7D6E4),
          300: Color(0xFFBEBBDD),
          400: Color(0xFFB1B0D3),
          500: Color(0xFFE7E6EB),
          600: Color(0xFFD1D0D9),
          700: Color(0xFFB3B2C7),
          800: Color(0xFF9697B5),
          900: Color(0xFF7A7A9F),
        },
      ),

      textPrimary: const MaterialColor(
        0xFF35384b,
        <int, Color>{
          50: Color(0xFFF2F3F6),
          100: Color(0xFFe4e5eb),
          200: Color(0xFFc0c3d5),
          300: Color(0xFF8a8Fae),
          400: Color(0xFF53587a),
          500: Color(0xFF35384b),
          600: Color(0xFF2a2c3e),
          700: Color(0xFF222433),
          800: Color(0xFF1e1F2b),
          900: Color(0xFF1c1d26),
        },
      ),
      textSecondary: const MaterialColor(
        0xFF737586,
        <int, Color>{
          50: Color(0xFFF7F7F8),
          100: Color(0xFFeeeeF0),
          200: Color(0xFFd9d9de),
          300: Color(0xFFb7b8c2),
          400: Color(0xFF9092a0),
          500: Color(0xFF737586),
          600: Color(0xFF5c5d6d),
          700: Color(0xFF4b4c59),
          800: Color(0xFF41424b),
          900: Color(0xFF393941),
        },
      ),
      textQuaternary: const MaterialColor(
        0xFFcacad4,
        <int, Color>{
          50: Color(0xFFF8F8F9),
          100: Color(0xFFF2F2F4),
          200: Color(0xFFe6e8eb),
          300: Color(0xFFd5d7de),
          400: Color(0xFFc5c6d1),
          500: Color(0xFFcacad4),
          600: Color(0xFFb0aFbd),
          700: Color(0xFF9796a4),
          800: Color(0xFF78778a),
          900: Color(0xFF646471),
        },
      ),
      textTeritary: const MaterialColor(
        0xFF9c9ca6,
        <int, Color>{
          50: Color(0xFFF6F6F7),
          100: Color(0xFFeFeFF0),
          200: Color(0xFFe1e1e4),
          300: Color(0xFFcecFd3),
          400: Color(0xFFb9b9c0),
          500: Color(0xFF9c9ca6),
          600: Color(0xFF91909b),
          700: Color(0xFF7d7c86),
          800: Color(0xFF66666d),
          900: Color(0xFF55555a),
        },
      ),

      iconPrimary: const MaterialColor(
        0xFF5F6076,
        <int, Color>{
          50: Color(0xFFF6F6F7),
          100: Color(0xFFebebeF),
          200: Color(0xFFd3d4db),
          300: Color(0xFFacadbb),
          400: Color(0xFF7c7c97),
          500: Color(0xFF5F6076),
          600: Color(0xFF515167),
          700: Color(0xFF3e3e4F),
          800: Color(0xFF363642),
          900: Color(0xFF303039),
        },
      ),
      iconSecondary: const MaterialColor(
        0xFF828691,
        <int, Color>{
          50: Color(0xFFF4F4F5),
          100: Color(0xFFebedee),
          200: Color(0xFFdadde0),
          300: Color(0xFFc4c6cb),
          400: Color(0xFFabaeb5),
          500: Color(0xFF828691),
          600: Color(0xFF73757F),
          700: Color(0xFF6b6c73),
          800: Color(0xFF535458),
          900: Color(0xFF454648),
        },
      ),

      critical: const MaterialColor(
        0xFFdb4933,
        <int, Color>{
          50: Color(0xFFFdF3F1),
          100: Color(0xFFFce5e1),
          200: Color(0xFFF9d0c9),
          300: Color(0xFFF5aca1),
          400: Color(0xFFeb7c6c),
          500: Color(0xFFdb4933),
          600: Color(0xFFbd4331),
          700: Color(0xFF963425),
          800: Color(0xFF7c2e23),
          900: Color(0xFF662b23),
        },
      ),
      warning: const MaterialColor(
        0xFFe8a700,
        <int, Color>{
          25: Color(0xFFFFFCF5),
          50: Color(0xFFfffce7),
          100: Color(0xFFfff9c1),
          200: Color(0xFFffef86),
          300: Color(0xFFffdd41),
          400: Color(0xFFffc80d),
          500: Color(0xFFe8a700),
          600: Color(0xFFd18400),
          700: Color(0xFFa65d02),
          800: Color(0xFF89480a),
          900: Color(0xFF743b0f),
        },
      ),
      success: const MaterialColor(
        0xFF00c269,
        <int, Color>{
          50: Color(0xFFeaFFF4),
          100: Color(0xFFcFFFe8),
          200: Color(0xFFa3FFd3),
          300: Color(0xFF5aFFb2),
          400: Color(0xFF08Fd8c),
          500: Color(0xFF00c269),
          600: Color(0xFF00a95c),
          700: Color(0xFF007F46),
          800: Color(0xFF046339),
          900: Color(0xFF055130),
        },
      ),

      assetColors: const [
        Color(0xFFEB5828),
        Color(0xFF4682B4),
        Color(0xFFF1CC12),
        Color(0xFF7B10FE),
        Color(0xFF729EFF),
        Color(0xFFE20A17),
        Color(0xFFFF8C19),
        Color(0xFFCD2F7B),
        Color(0xFFFFAFA5),
        Color(0xFF9B0032),
        Color(0xFFB1C01C),
        Color(0xFFBE4B0A),
        Color(0xFFC8AFF0),
        Color(0xFF78286E),
        Color(0xFF00BCD4),
        Color(0xFFAEAEB6),
      ],
      performanceChartColors: const [
        Color(0xFF4682B4),
        Color(0xFFF1CC12),
        Color(0xFF7B10FE),
        Color(0xFFE20A17),
        Color(0xFFFC8D00),
      ],
      backgroundColor: const Color(0XFFFFFFFF),

      //TODO: Dark Theme için düzenlenecek
      darkHigh: Colors.black87,
      darkMedium: Colors.black.withOpacity(.60),
      darkLow: Colors.black38,
      lightHigh: Colors.white,
      lightMedium: Colors.white.withOpacity(.74),
      lightLow: Colors.white38,
      shadow: const Color(0xFF9C9CA6),
      unselectedItemColor: const Color(0xFF828691),
      risky: const Color(0xFFF1CC12),
      transparent: const Color(0x00000000),
    );
  }

  static PColorScheme _getPDarkColorSchema() {
    return PColorScheme(
      primary: const MaterialColor(
        0xFFEB6C32,
        <int, Color>{
          50: Color(0xFFF9E2C2),
          100: Color(0xFFF5C290),
          200: Color(0xFFF18F5E),
          300: Color(0xFFEE6D3D),
          400: Color(0xFFEB5A22),
          500: Color(0xFFEB6C32),
          600: Color(0xFFDB5A2B),
          700: Color(0xFFCA4F23),
          800: Color(0xFFB6451C),
          900: Color(0xFF9F3A13),
        },
      ),
      secondary: const Color(0XFF0A2C49),
      card: const MaterialColor(
        0xFF0A2538,
        <int, Color>{
          50: Color(0xFFE1E8F0),
          100: Color(0xFFB4C8D9),
          200: Color(0xFF8CA8C1),
          300: Color(0xFF63879A),
          400: Color(0xFF3A6883),
          500: Color(0xFF0A2538),
          600: Color(0xFF08202F),
          700: Color(0xFF061C27),
          800: Color(0xFF04171E),
          900: Color(0xFF02121A),
        },
      ),
      line: const MaterialColor(
        0xFF142E40,
        <int, Color>{
          50: Color(0xFFE0E8EC),
          100: Color(0xFFB1C5CC),
          200: Color(0xFF7D9CA8),
          300: Color(0xFF4A7483),
          400: Color(0xFF2E5D6E),
          500: Color(0xFF142E40),
          600: Color(0xFF0F2838),
          700: Color(0xFF0B2230),
          800: Color(0xFF071C28),
          900: Color(0xFF051822),
        },
      ),
      stroke: const MaterialColor(
        0xFF1B3446,
        <int, Color>{
          50: Color(0xFFE1E7EB),
          100: Color(0xFFB3C7D4),
          200: Color(0xFF7D9FB8),
          300: Color(0xFF46879B),
          400: Color(0xFF276A84),
          500: Color(0xFF1B3446),
          600: Color(0xFF17303F),
          700: Color(0xFF142A37),
          800: Color(0xFF102430),
          900: Color(0xFF0C1F29),
        },
      ),

      textPrimary: const MaterialColor(
        0xFFE7E6EC,
        <int, Color>{
          50: Color(0xFFF9F9FB),
          100: Color(0xFFF1F1F5),
          200: Color(0xFFD9D9E2),
          300: Color(0xFFC0C0D0),
          400: Color(0xFFB1B1C4),
          500: Color(0xFFE7E6EC),
          600: Color(0xFFD1D0D7),
          700: Color(0xFFB4B3BC),
          800: Color(0xFF9797A0),
          900: Color(0xFF7A7A83),
        },
      ),
      textSecondary: const MaterialColor(
        0xFFAEAEB6,
        <int, Color>{
          50: Color(0xFFF1F1F5),
          100: Color(0xFFD1D1DB),
          200: Color(0xFFB2B2C5),
          300: Color(0xFF9292AF),
          400: Color(0xFF7B7B99),
          500: Color(0xFFAEAEB6),
          600: Color(0xFF9C9CA3),
          700: Color(0xFF8A8A90),
          800: Color(0xFF777780),
          900: Color(0xFF646470),
        },
      ),
      textQuaternary: const MaterialColor(
        0xFF5C5E75,
        <int, Color>{
          50: Color(0xFFE0E1E7),
          100: Color(0xFFB3B7C5),
          200: Color(0xFF8E92A3),
          300: Color(0xFF68728A),
          400: Color(0xFF4F5C74),
          500: Color(0xFF5C5E75),
          600: Color(0xFF545661),
          700: Color(0xFF4C4E57),
          800: Color(0xFF43464C),
          900: Color(0xFF383A41),
        },
      ),
      textTeritary: const MaterialColor(
        0xFF868593,
        <int, Color>{
          50: Color(0xFFE0E0E2),
          100: Color(0xFFB3B4B7),
          200: Color(0xFF8F8F91),
          300: Color(0xFF6A6A6C),
          400: Color(0xFF545456),
          500: Color(0xFF868593),
          600: Color(0xFF78787A),
          700: Color(0xFF6B6B6E),
          800: Color(0xFF5E5E61),
          900: Color(0xFF4F4F53),
        },
      ),

      iconPrimary: const MaterialColor(
        0xFFCACAD4,
        <int, Color>{
          50: Color(0xFFF1F1F5),
          100: Color(0xFFD3D4DF),
          200: Color(0xFFB6B7C9),
          300: Color(0xFF999BBA),
          400: Color(0xFF7C7F9D),
          500: Color(0xFFCACAD4),
          600: Color(0xFFB3B4C6),
          700: Color(0xFF9C9FB8),
          800: Color(0xFF8689AA),
          900: Color(0xFF70748C),
        },
      ),
      iconSecondary: const MaterialColor(
        0xFF898896,
        <int, Color>{
          50: Color(0xFFE1E1E1),
          100: Color(0xFFB3B3B3),
          200: Color(0xFF8C8C8C),
          300: Color(0xFF666666),
          400: Color(0xFF4D4D4D),
          500: Color(0xFF898896),
          600: Color(0xFF7A7A7A),
          700: Color(0xFF666666),
          800: Color(0xFF4F4F4F),
          900: Color(0xFF383838),
        },
      ),

      critical: const MaterialColor(
        0xFFEB4949,
        <int, Color>{
          50: Color(0xFFFFE5E5),
          100: Color(0xFFFFB8B8),
          200: Color(0xFFFF8A8A),
          300: Color(0xFFFF5C5C),
          400: Color(0xFFFF3E3E),
          500: Color(0xFFEB4949),
          600: Color(0xFFD44242),
          700: Color(0xFFB83A3A),
          800: Color(0xFF9C3232),
          900: Color(0xFF7A2626),
        },
      ),
      warning: const MaterialColor(
        0xFFe8a700,
        <int, Color>{
          25: Color(0xFFFFFCF5),
          50: Color(0xFFfffce7),
          100: Color(0xFFfff9c1),
          200: Color(0xFFffef86),
          300: Color(0xFFffdd41),
          400: Color(0xFFffc80d),
          500: Color(0xFFe8a700),
          600: Color(0xFFd18400),
          700: Color(0xFFa65d02),
          800: Color(0xFF89480a),
          900: Color(0xFF743b0f),
        },
      ),
      success: const MaterialColor(
        0xFF00C269,
        <int, Color>{
          50: Color(0xFFE0F7EC),
          100: Color(0xFFB3EFD0),
          200: Color(0xFF80E6B3),
          300: Color(0xFF4DDB96),
          400: Color(0xFF26D47F),
          500: Color(0xFF00C269),
          600: Color(0xFF00AE5F),
          700: Color(0xFF009954),
          800: Color(0xFF00854A),
          900: Color(0xFF006438),
        },
      ),

      assetColors: const [
        Color(0xFFEB5828),
        Color(0xFF4682B4),
        Color(0xFFF1CC12),
        Color(0xFF7B10FE),
        Color(0xFF729EFF),
        Color(0xFFE20A17),
        Color(0xFFFF8C19),
        Color(0xFFCD2F7B),
        Color(0xFFFFAFA5),
        Color(0xFF9B0032),
        Color(0xFFB1C01C),
        Color(0xFFBE4B0A),
        Color(0xFFC8AFF0),
        Color(0xFF78286E),
        Color(0xFF00BCD4),
        Color(0xFFAEAEB6),
      ],
      performanceChartColors: const [
        Color(0xFF4682B4),
        Color(0xFFF1CC12),
        Color(0xFF7B10FE),
        Color(0xFFE20A17),
        Color(0xFFFC8D00),
      ],
      backgroundColor: const Color(0XFF001728),

      //TODO: Dark Theme için düzenlenecek
      darkHigh: Colors.black87,
      darkMedium: Colors.black.withOpacity(.60),
      darkLow: Colors.black38,
      lightHigh: Colors.white,
      lightMedium: Colors.white.withOpacity(.74),
      lightLow: Colors.white38,
      shadow: const Color(0xFF9C9CA6),
      unselectedItemColor: const Color(0xFF828691),
      risky: const Color(0xFFF1CC12),
      transparent: const Color(0x00000000),
    );
  }
}
