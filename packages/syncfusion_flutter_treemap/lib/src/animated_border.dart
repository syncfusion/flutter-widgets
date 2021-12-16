import 'package:flutter/material.dart';

/// Ignore scaling for the tile border.
class AnimatedBorder extends RoundedRectangleBorder {
  /// Creates a [AnimatedBorder].
  const AnimatedBorder({
    BorderSide side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.scaleSize,
  }) : super(side: side);

  @override
  final BorderRadiusGeometry borderRadius;

  /// The tile scale value.
  final Size? scaleSize;

  /// ignore scaling for the border inner rect.
  Rect _getRect(Rect rect, double width) {
    if (scaleSize != null) {
      return Rect.fromLTRB(
          rect.left + (width / scaleSize!.width),
          rect.top + (width / scaleSize!.height),
          rect.right - (width / scaleSize!.width),
          rect.bottom - (width / scaleSize!.height));
    }

    return rect;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final double width = side.width;
        Rect? innerRect;
        BorderRadius currentBorderRadius = borderRadius.resolve(textDirection);
        if (scaleSize != null) {
          final double borderWidth = width / scaleSize!.width;
          final double borderHeight = width / scaleSize!.height;
          // We have decreased the border radius based on the scale value.
          // But we need to reduce the border radius by using the current
          // border width.
          currentBorderRadius = BorderRadius.only(
              topRight: Radius.elliptical(
                  currentBorderRadius.topRight.x - borderWidth,
                  currentBorderRadius.topRight.y - borderHeight),
              bottomLeft: Radius.elliptical(
                  currentBorderRadius.bottomLeft.x - borderWidth,
                  currentBorderRadius.bottomLeft.y - borderHeight),
              bottomRight: Radius.elliptical(
                  currentBorderRadius.bottomRight.x - borderWidth,
                  currentBorderRadius.bottomRight.y - borderHeight),
              topLeft: Radius.elliptical(
                  currentBorderRadius.topLeft.x - borderWidth,
                  currentBorderRadius.topLeft.y - borderHeight));
        }

        if (width == 0.0) {
          innerRect = _getRect(rect, width);
          canvas.drawRRect(
              borderRadius.resolve(textDirection).toRRect(innerRect),
              side.toPaint());
        } else {
          final RRect outer = borderRadius.resolve(textDirection).toRRect(rect);
          innerRect = _getRect(
              Rect.fromLTRB(outer.left, outer.top, outer.right, outer.bottom),
              width);
          final RRect inner = scaleSize != null
              ? currentBorderRadius.resolve(textDirection).toRRect(innerRect)
              : outer.deflate(width);
          final Paint paint = Paint()..color = side.color;
          canvas.drawDRRect(outer, inner, paint);
        }
    }
  }
}
