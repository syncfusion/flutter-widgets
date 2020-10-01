part of maps;

/// Base class for map icon shapes.
class _MapIconShape {
  const _MapIconShape();

  /// Returns the size based on the value passed to it.
  Size getPreferredSize(Size iconSize, SfMapsThemeData themeData) {
    return iconSize;
  }

  /// Paints the shapes based on the value passed to it.
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SfMapsThemeData themeData,
    Size iconSize,
    Color color,
    Color strokeColor,
    double strokeWidth,
    MapIconType iconType,
  }) {
    iconSize = getPreferredSize(iconSize, themeData);
    final double halfIconWidth = iconSize.width / 2;
    final double halfIconHeight = iconSize.height / 2;
    final bool hasStroke = strokeWidth != null &&
        strokeWidth > 0 &&
        strokeColor != null &&
        strokeColor != Colors.transparent;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = color;
    Path path;

    switch (iconType) {
      case MapIconType.circle:
        final Rect rect = Rect.fromLTWH(
            offset.dx, offset.dy, iconSize.width, iconSize.height);
        context.canvas.drawOval(rect, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawOval(rect, paint);
        }
        break;
      case MapIconType.square:
        final Rect rect = Rect.fromLTWH(
            offset.dx, offset.dy, iconSize.width, iconSize.height);
        context.canvas.drawRect(rect, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawRect(rect, paint);
        }
        break;
      case MapIconType.triangle:
        path = Path()
          ..moveTo(offset.dx + halfIconWidth, offset.dy)
          ..lineTo(offset.dx + iconSize.width, offset.dy + iconSize.height)
          ..lineTo(offset.dx, offset.dy + iconSize.height)
          ..close();
        context.canvas.drawPath(path, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawPath(path, paint);
        }
        break;
      case MapIconType.diamond:
        path = Path()
          ..moveTo(offset.dx + halfIconWidth, offset.dy)
          ..lineTo(offset.dx + iconSize.width, offset.dy + halfIconHeight)
          ..lineTo(offset.dx + halfIconWidth, offset.dy + iconSize.height)
          ..lineTo(offset.dx, offset.dy + halfIconHeight)
          ..close();
        context.canvas.drawPath(path, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawPath(path, paint);
        }
        break;
    }
  }
}

/// Base class for map tooltip shapes.
class _TooltipShape {
  const _TooltipShape();

  static const bool showTooltipNose = true;
  static const double marginSpace = 6.0;

  /// Paints the tooltip shapes based on the value passed to it.
  void paint(
      PaintingContext context,
      Offset offset,
      Offset center,
      TextPainter labelPainter,
      Paint paint,
      RenderProxyBox parentBox,
      Animation<double> tooltipAnimation,
      SfMapsThemeData themeData,
      MapTooltipSettings tooltipSettings) {
    const double tooltipTriangleHeight = 7;
    const double tooltipTriangleWidth = 12.0;
    const double textPadding = 14.0;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;
    const double elevation = 0.0;

    Path path = Path();
    double tooltipWidth;
    double tooltipHeight;
    if (parentBox.child != null) {
      tooltipWidth = parentBox.child.size.width;
      tooltipHeight = parentBox.child.size.height;
    } else {
      tooltipWidth = labelPainter.width + textPadding;
      tooltipHeight = labelPainter.height + textPadding;
    }

    final double halfTooltipWidth = tooltipWidth / 2;
    final double halfTooltipHeight = tooltipHeight / 2;

    final double tooltipStartPoint = tooltipTriangleHeight + tooltipHeight / 2;
    final double tooltipTriangleOffsetY =
        tooltipStartPoint - tooltipTriangleHeight;

    final double endGlobal = parentBox.size.width - marginSpace;
    double rightLineWidth = center.dx + halfTooltipWidth > endGlobal
        ? endGlobal - center.dx
        : halfTooltipWidth;
    final double leftLineWidth = center.dx - halfTooltipWidth < marginSpace
        ? center.dx - marginSpace
        : tooltipWidth - rightLineWidth;
    rightLineWidth = leftLineWidth < halfTooltipWidth
        ? halfTooltipWidth - leftLineWidth + rightLineWidth
        : rightLineWidth;

    double moveNosePoint = leftLineWidth < tooltipWidth * 0.2
        ? tooltipWidth * 0.2 - leftLineWidth
        : 0.0;
    moveNosePoint = rightLineWidth < tooltipWidth * 0.2
        ? -(tooltipWidth * 0.2 - rightLineWidth)
        : moveNosePoint;

    double shiftText = leftLineWidth > rightLineWidth
        ? -(halfTooltipWidth - rightLineWidth)
        : 0.0;
    shiftText = leftLineWidth < rightLineWidth
        ? (halfTooltipWidth - leftLineWidth)
        : shiftText;

    rightLineWidth = rightLineWidth + elevation;
    path = _getTooltipPath(
        path,
        tooltipTriangleHeight,
        halfTooltipHeight,
        halfTooltipTriangleWidth,
        tooltipTriangleOffsetY,
        moveNosePoint,
        rightLineWidth,
        leftLineWidth,
        themeData,
        tooltipHeight);

    context.canvas.save();
    context.canvas.translate(
        center.dx, center.dy - tooltipTriangleHeight - halfTooltipHeight);
    context.canvas.scale(tooltipAnimation.value);

    if (parentBox.child == null || parentBox.child != null && showTooltipNose) {
      context.canvas.drawPath(path, paint);
      final Color strokeColor =
          tooltipSettings.strokeColor ?? themeData.tooltipStrokeColor;
      if (strokeColor != null && strokeColor != Colors.transparent) {
        paint
          ..color = strokeColor
          ..strokeWidth =
              tooltipSettings.strokeWidth ?? themeData.tooltipStrokeWidth
          ..style = PaintingStyle.stroke;
        context.canvas.drawPath(path, paint);
      }
    }

    if (parentBox.child == null) {
      final double labelOffsetY =
          tooltipTriangleHeight + halfTooltipHeight + labelPainter.height / 2;
      labelPainter.paint(
          context.canvas,
          Offset(-labelPainter.width / 2 + shiftText,
              tooltipStartPoint - labelOffsetY));
    } else {
      context.canvas.clipPath(path);
      context.paintChild(parentBox.child,
          offset - _getShiftPosition(offset, center, parentBox));
    }

    context.canvas.restore();
  }

  Path _getTooltipPath(
      Path path,
      double tooltipTriangleHeight,
      double halfTooltipHeight,
      double halfTooltipTriangleWidth,
      double tooltipTriangleOffsetY,
      double moveNosePoint,
      double rightLineWidth,
      double leftLineWidth,
      SfMapsThemeData themeData,
      double tooltipHeight) {
    final BorderRadius borderRadius = themeData.tooltipBorderRadius;
    path.reset();

    if (showTooltipNose) {
      path.moveTo(0, tooltipTriangleHeight + halfTooltipHeight);
    } else {
      path.moveTo(
          halfTooltipTriangleWidth + moveNosePoint, tooltipTriangleOffsetY);
    }

    //    /
    path.lineTo(
        halfTooltipTriangleWidth + moveNosePoint, tooltipTriangleOffsetY);
    //      ___
    //     /
    path.lineTo(
        rightLineWidth - borderRadius.bottomRight.x, tooltipTriangleOffsetY);
    //      ___|
    //     /
    path.quadraticBezierTo(rightLineWidth, tooltipTriangleOffsetY,
        rightLineWidth, tooltipTriangleOffsetY - borderRadius.bottomRight.y);
    path.lineTo(rightLineWidth,
        tooltipTriangleOffsetY - tooltipHeight + borderRadius.topRight.y);
    //  _______
    //      ___|
    //     /
    path.quadraticBezierTo(
        rightLineWidth,
        tooltipTriangleOffsetY - tooltipHeight,
        rightLineWidth - borderRadius.topRight.x,
        tooltipTriangleOffsetY - tooltipHeight);
    path.lineTo(-leftLineWidth + borderRadius.topLeft.x,
        tooltipTriangleOffsetY - tooltipHeight);
    //  _______
    // |    ___|
    //     /
    path.quadraticBezierTo(
        -leftLineWidth,
        tooltipTriangleOffsetY - tooltipHeight,
        -leftLineWidth,
        tooltipTriangleOffsetY - tooltipHeight + borderRadius.topLeft.y);
    path.lineTo(
        -leftLineWidth, tooltipTriangleOffsetY - borderRadius.bottomLeft.y);
    //  ________
    // |___  ___|
    //      /
    path.quadraticBezierTo(-leftLineWidth, tooltipTriangleOffsetY,
        -leftLineWidth + borderRadius.bottomLeft.x, tooltipTriangleOffsetY);
    path.lineTo(
        -halfTooltipTriangleWidth + moveNosePoint, tooltipTriangleOffsetY);
    //  ________
    // |___  ___|
    //     \/
    path.close();

    return path;
  }

  Offset _getShiftPosition(
      Offset offset, Offset center, RenderProxyBox parent) {
    final Size childSize = parent.child.size;
    final double halfChildWidth = childSize.width / 2;
    final double halfChildHeight = childSize.height / 2;

    // Shifting the position of the tooltip to the left side, if its right
    // edge goes out of the map's right edge.
    if (center.dx + halfChildWidth + marginSpace > parent.size.width) {
      return Offset(
          childSize.width + center.dx - parent.size.width + marginSpace,
          halfChildHeight);
    }
    // Shifting the position of the tooltip to the right side, if its left
    // edge goes out of the map's left edge.
    else if (center.dx - halfChildWidth - marginSpace < offset.dx) {
      return Offset(center.dx - marginSpace, halfChildHeight);
    }

    return Offset(halfChildWidth, halfChildHeight);
  }
}
