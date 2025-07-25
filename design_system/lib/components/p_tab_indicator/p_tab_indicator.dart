/// Reference:
/// https://github.com/westdabestdb/md2_tab_indicator
///
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:p_core/route/page_navigator.dart';

enum PTabIndicatorSize {
  tiny,
  normal,
  full,
}

class PTabIndicator extends Decoration {
  final double indicatorHeight;
  final Color? indicatorColor;
  final PTabIndicatorSize indicatorSize;

  const PTabIndicator({
    this.indicatorHeight = 2,
    this.indicatorColor,
    this.indicatorSize = PTabIndicatorSize.normal,
  });

  @override
  PTabIndicatorPainter createBoxPainter([VoidCallback? onChanged]) {
    return PTabIndicatorPainter(this, onChanged);
  }
}

class PTabIndicatorPainter extends BoxPainter {
  final PTabIndicator decoration;

  PTabIndicatorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    Rect rect;

    switch (decoration.indicatorSize) {
      case PTabIndicatorSize.tiny:
        rect = Offset(
              offset.dx + configuration.size!.width / 2 - 8,
              configuration.size!.height - decoration.indicatorHeight,
            ) &
            Size(16, decoration.indicatorHeight);
      case PTabIndicatorSize.normal:
        rect = Offset(offset.dx + 6, configuration.size!.height - decoration.indicatorHeight) &
            Size(configuration.size!.width - 12, decoration.indicatorHeight);
      case PTabIndicatorSize.full:
        rect = Offset(offset.dx, configuration.size!.height - decoration.indicatorHeight) &
            Size(configuration.size!.width, decoration.indicatorHeight);
    }

    final Paint paint = Paint()
      ..color = decoration.indicatorColor ?? PageNavigator.globalContext?.pColorScheme.primary ?? Colors.transparent
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(8),
        topLeft: const Radius.circular(8),
      ),
      paint,
    );
  }
}
