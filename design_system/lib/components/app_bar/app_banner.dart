import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/widgets.dart';

/// A widget that provides a banner that is shown only in debug builds.
///
/// This is useful for providing a visual cues for which builds are being
/// distributed for testing.

class AppBanner extends StatelessWidget {
  final Widget child;
  final BannerLocation location;
  final TextStyle? textStyle;
  final String text;
  final Color? color;
  final bool isVisible;

  const AppBanner({
    super.key,
    required this.child,
    required this.text,
    this.location = BannerLocation.topStart,
    this.textStyle,
    this.color,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return child;
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        color: color ?? context.pColorScheme.primary,
        message: text,
        location: location,
        textStyle: textStyle ??
            context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m - Grid.xxs,
            ),
        child: child,
      ),
    );
  }
}
