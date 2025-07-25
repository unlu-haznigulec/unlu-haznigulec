import 'package:flutter/material.dart';

/// Draws a rounded rectangle around an [InputDecorator]'s container.
///
/// When the input decorator's label is floating, for example because its
/// input child has the focus, the label appears in a gap in the border outline.
///
/// The input decorator's "container" is the optionally filled area above the
/// decorator's helper, error, and counter.
///
/// See also:
///
///  * [UnderlineInputBorder], the default [InputDecorator] border which
///    draws a horizontal line at the bottom of the input decorator's container.
///  * [InputDecoration], which is used to configure an [InputDecorator].
class PInputBorder extends InputBorder {
  /// Creates a rounded rectangle outline border for an [InputDecorator].
  ///
  /// If the [borderSide] parameter is [BorderSide.none], it will not draw a
  /// border. However, it will still define a shape (which you can see if
  /// [InputDecoration.filled] is true).
  ///
  /// If an application does not specify a [borderSide] parameter of
  /// value [BorderSide.none], the input decorator substitutes its own, using
  /// [copyWith], based on the current theme and [InputDecorator.isFocused].
  ///
  /// The [borderRadius] parameter defaults to a value where all four
  /// corners have a circular radius of 4.0. The [borderRadius] parameter
  /// must not be null and the corner radii must be circular, i.e. their
  /// [Radius.x] and [Radius.y] values must be the same.
  ///
  /// See also:
  ///
  // ignore: deprecated_member_use
  ///  * [InputDecoration.hasFloatingPlaceholder], which should be set to false
  ///    when the [borderSide] is [BorderSide.none]. If let as true, the label
  ///    will extend beyond the container as if the border were still being
  ///    drawn.
  const PInputBorder({
    BorderSide borderSide = const BorderSide(),
    this.borderRadius = BorderRadius.zero,
    this.gapPadding = 4.0,
  })  : assert(gapPadding >= 0.0),
        super(borderSide: borderSide);

  // The label text's gap can extend into the corners (even both the top left
  // and the top right corner). To avoid the more complicated problem of finding
  // how far the gap penetrates into an elliptical corner, just require them
  // to be circular.
  //
  // This can't be checked by the constructor because const constructor.
  static bool _cornersAreCircular(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topLeft.y &&
        borderRadius.bottomLeft.x == borderRadius.bottomLeft.y &&
        borderRadius.topRight.x == borderRadius.topRight.y &&
        borderRadius.bottomRight.x == borderRadius.bottomRight.y;
  }

  /// Horizontal padding on either side of the border's
  /// [InputDecoration.labelText] width gap.
  ///
  /// This value is used by the [paint] method to compute the actual gap width.
  final double gapPadding;

  /// The radii of the border's rounded rectangle corners.
  ///
  /// The corner radii must be circular, i.e. their [Radius.x] and [Radius.y]
  /// values must be the same.
  final BorderRadius borderRadius;

  @override
  bool get isOutline => false; // BAYZAT CHANGE

  @override
  PInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) {
    return PInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  PInputBorder scale(double t) {
    return PInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      gapPadding: gapPadding * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is PInputBorder) {
      final PInputBorder outline = a;
      return PInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is PInputBorder) {
      final PInputBorder outline = b;
      return PInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(borderSide.width),
      );
  }

  @override
  Path getOuterPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  /// Draw a rounded rectangle around [rect] using [borderRadius].
  ///
  /// The [borderSide] defines the line's color and weight.
  ///
  /// The top side of the rounded rectangle may be interrupted by a single gap
  /// if [gapExtent] is non-null. In that case the gap begins at
  /// `gapStart - gapPadding` (assuming that the [textDirection] is [TextDirection.ltr]).
  /// The gap's width is `(gapPadding + gapExtent + gapPadding) * gapPercentage`.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);
    assert(_cornersAreCircular(borderRadius));

    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
    // ignore: dead_code
    if (true || gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      // BAYZAT CHANGE
      canvas.drawRRect(center, paint);
    }
    // else {
    //   final double extent = lerpDouble(0.0, gapExtent + gapPadding * 2.0, gapPercentage)!;
    //   switch (textDirection) {
    //     case TextDirection.rtl:
    //       final Path path = _gapBorderPath(canvas, center, math.max(0.0, gapStart + gapPadding - extent), extent);
    //       canvas.drawPath(path, paint);
    //       break;
    //     case TextDirection.ltr:
    //       final Path path = _gapBorderPath(canvas, center, math.max(0.0, gapStart - gapPadding), extent);
    //       canvas.drawPath(path, paint);
    //       break;
    // TODO(selcukguvel): Setting default behavior as TextDirection.ltr to remove unhandled null case warning, needs to be checked
    //     default:
    //       final Path path = _gapBorderPath(canvas, center, math.max(0.0, gapStart - gapPadding), extent);
    //       canvas.drawPath(path, paint);
    //   }
    // }
  }

  // TODO(selcukguvel): Used by paint()'s else condition statements, needs to be uncommented after enabling `else` there
  // Path _gapBorderPath(Canvas canvas, RRect center, double start, double extent) {
  //   // When the corner radii on any side add up to be greater than the
  //   // given height, each radius has to be scaled to not exceed the
  //   // size of the width/height of the RRect.
  //   final RRect scaledRRect = center.scaleRadii();
  //
  //   final Rect tlCorner = Rect.fromLTWH(
  //     scaledRRect.left,
  //     scaledRRect.top,
  //     scaledRRect.tlRadiusX * 2.0,
  //     scaledRRect.tlRadiusY * 2.0,
  //   );
  //   final Rect trCorner = Rect.fromLTWH(
  //     scaledRRect.right - scaledRRect.trRadiusX * 2.0,
  //     scaledRRect.top,
  //     scaledRRect.trRadiusX * 2.0,
  //     scaledRRect.trRadiusY * 2.0,
  //   );
  //   final Rect brCorner = Rect.fromLTWH(
  //     scaledRRect.right - scaledRRect.brRadiusX * 2.0,
  //     scaledRRect.bottom - scaledRRect.brRadiusY * 2.0,
  //     scaledRRect.brRadiusX * 2.0,
  //     scaledRRect.brRadiusY * 2.0,
  //   );
  //   final Rect blCorner = Rect.fromLTWH(
  //     scaledRRect.left,
  //     scaledRRect.bottom - scaledRRect.blRadiusY * 2.0,
  //     scaledRRect.blRadiusX * 2.0,
  //     scaledRRect.blRadiusX * 2.0,
  //   );
  //
  //   const double cornerArcSweep = math.pi / 2.0;
  //   final double tlCornerArcSweep =
  //       start < scaledRRect.tlRadiusX ? math.asin((start / scaledRRect.tlRadiusX).clamp(-1.0, 1.0)) : math.pi / 2.0;
  //
  //   final Path path = Path()
  //     ..addArc(tlCorner, math.pi, tlCornerArcSweep)
  //     ..moveTo(scaledRRect.left + scaledRRect.tlRadiusX, scaledRRect.top);
  //
  //   if (start > scaledRRect.tlRadiusX) {
  //     path.lineTo(scaledRRect.left + start, scaledRRect.top);
  //   }
  //
  //   const double trCornerArcStart = (3 * math.pi) / 2.0;
  //   const double trCornerArcSweep = cornerArcSweep;
  //   if (start + extent < scaledRRect.width - scaledRRect.trRadiusX) {
  //     path
  //       ..relativeMoveTo(extent, 0.0)
  //       ..lineTo(scaledRRect.right - scaledRRect.trRadiusX, scaledRRect.top)
  //       ..addArc(trCorner, trCornerArcStart, trCornerArcSweep);
  //   } else if (start + extent < scaledRRect.width) {
  //     final double dx = scaledRRect.width - (start + extent);
  //     final double sweep = math.acos(dx / scaledRRect.trRadiusX);
  //     path.addArc(trCorner, trCornerArcStart + sweep, trCornerArcSweep - sweep);
  //   }
  //
  //   return path
  //     ..moveTo(scaledRRect.right, scaledRRect.top + scaledRRect.trRadiusY)
  //     ..lineTo(scaledRRect.right, scaledRRect.bottom - scaledRRect.brRadiusY)
  //     ..addArc(brCorner, 0.0, cornerArcSweep)
  //     ..lineTo(scaledRRect.left + scaledRRect.blRadiusX, scaledRRect.bottom)
  //     ..addArc(blCorner, math.pi / 2.0, cornerArcSweep)
  //     ..lineTo(scaledRRect.left, scaledRRect.top + scaledRRect.tlRadiusY);
  // }

  @override
  bool operator ==(Object other) {
    // ignore: always_put_control_body_on_new_line
    if (identical(this, other)) return true;
    // ignore: always_put_control_body_on_new_line
    if (other.runtimeType != runtimeType) return false;
    return other is PInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius &&
        other.gapPadding == gapPadding;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius, gapPadding);
}
