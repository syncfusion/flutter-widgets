import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../../sparkline/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../common/interactive_tooltip.dart';
import 'helper.dart';

/// Returns the tooltip label on zooming.
String tooltipValue(
    Offset position, RenderChartAxis axis, Rect plotAreaBounds) {
  final num value = axis.isVertical
      ? axis.pixelToPoint(axis.paintBounds, position.dx, position.dy)
      : axis.pixelToPoint(axis.paintBounds, position.dx - plotAreaBounds.left,
          position.dy - plotAreaBounds.top);

  dynamic result = interactiveTooltipLabel(value, axis);
  if (axis.interactiveTooltip.format != null) {
    final String stringValue =
        axis.interactiveTooltip.format!.replaceAll('{value}', result);
    result = stringValue;
  }
  return result.toString();
}

/// To get interactive tooltip label.
dynamic interactiveTooltipLabel(dynamic value, RenderChartAxis axis) {
  if (axis is RenderCategoryAxis) {
    final num index = value < 0 ? 0 : value;
    final List<String?> labels = axis.labels;
    final int labelsLength = labels.length;
    return labels[(index.round() >= labelsLength
                ? (index.round() > labelsLength ? labelsLength - 1 : index - 1)
                : index)
            .round()]
        .toString();
  } else if (axis is RenderDateTimeCategoryAxis) {
    final num index = value < 0 ? 0 : value;
    final List<int> labels = axis.labels;
    final int labelsLength = labels.length;
    final int milliseconds = labels[(index.round() >= labelsLength
            ? (index.round() > labelsLength ? labelsLength - 1 : index - 1)
            : index)
        .round()];
    final num interval = axis.visibleRange!.minimum.ceil();
    final num previousInterval =
        labels.isNotEmpty ? labels[labelsLength - 1] : interval;
    final DateFormat dateFormat = axis.dateFormat ??
        dateTimeCategoryAxisLabelFormat(
            axis, interval.toInt(), previousInterval.toInt());
    return dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt()));
  } else if (axis is RenderDateTimeAxis) {
    final num interval = axis.visibleRange!.minimum.ceil();
    final List<AxisLabel> visibleLabels = axis.visibleLabels;
    final num previousInterval = visibleLabels.isNotEmpty
        ? visibleLabels[visibleLabels.length - 1].value
        : interval;
    final DateFormat dateFormat = axis.dateFormat ??
        dateTimeAxisLabelFormat(
            axis, interval.toInt(), previousInterval.toInt());
    return dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  } else if (axis is RenderLogarithmicAxis) {
    return logAxisLabel(
        axis, axis.toPow(value), axis.interactiveTooltip.decimalPlaces);
  } else if (axis is RenderNumericAxis) {
    return numericAxisLabel(axis, value, axis.interactiveTooltip.decimalPlaces);
  } else {
    return '';
  }
}

/// Validate the rect by comparing small and large rect.
Rect validateRect(
        Rect largeRect, Rect smallRect, String axisPosition) =>
    Rect.fromLTRB(
        axisPosition == 'left'
            ? (smallRect.left - (largeRect.width - smallRect.width))
            : smallRect.left,
        smallRect.top,
        axisPosition == 'right'
            ? (smallRect.right + (largeRect.width - smallRect.width))
            : smallRect.right,
        smallRect.bottom);

/// Calculate the interactive tooltip rect, based on the zoomed axis position.
Rect calculateRect(RenderChartAxis axis, Offset position, Size labelSize) {
  const double paddingForRect = 10;
  final Rect axisBound = (axis.parentData! as BoxParentData).offset & axis.size;
  final double arrowLength = axis.interactiveTooltip.arrowLength;
  double left, top;
  final double width = labelSize.width + paddingForRect;
  final double height = labelSize.height + paddingForRect;

  if (axis.isVertical) {
    top = position.dy - height / 2;
    if (axis.opposedPosition) {
      left = axisBound.left + arrowLength;
    } else {
      left = axisBound.left - width - arrowLength;
    }
  } else {
    left = position.dx - width / 2;
    if (axis.opposedPosition) {
      top = axisBound.top - height - arrowLength;
    } else {
      top = axisBound.top + arrowLength;
    }
  }
  return Rect.fromLTWH(left, top, width, height);
}

/// To draw connectors.
void drawConnector(
    Canvas canvas,
    Paint connectorLinePaint,
    RRect startTooltipRect,
    RRect endTooltipRect,
    Offset startPosition,
    Offset endPosition,
    RenderChartAxis axis) {
  final InteractiveTooltip tooltip = axis.interactiveTooltip;
  if (!axis.isVertical && !axis.opposedPosition) {
    startPosition =
        Offset(startPosition.dx, startTooltipRect.top - tooltip.arrowLength);
    endPosition =
        Offset(endPosition.dx, endTooltipRect.top - tooltip.arrowLength);
  } else if (!axis.isVertical && axis.opposedPosition) {
    startPosition =
        Offset(startPosition.dx, startTooltipRect.bottom + tooltip.arrowLength);
    endPosition =
        Offset(endPosition.dx, endTooltipRect.bottom + tooltip.arrowLength);
  } else if (axis.isVertical && !axis.opposedPosition) {
    startPosition =
        Offset(startTooltipRect.right + tooltip.arrowLength, startPosition.dy);
    endPosition =
        Offset(endTooltipRect.right + tooltip.arrowLength, endPosition.dy);
  } else {
    startPosition =
        Offset(startTooltipRect.left - tooltip.arrowLength, startPosition.dy);
    endPosition =
        Offset(endTooltipRect.left - tooltip.arrowLength, endPosition.dy);
  }
  drawDashedPath(canvas, connectorLinePaint, startPosition, endPosition,
      tooltip.connectorLineDashArray);
}

/// To draw tooltip.
RRect calculateTooltipRect(
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint,
    Path path,
    Offset position,
    Rect labelRect,
    RRect? rect,
    String value,
    Size labelSize,
    Rect plotAreaBound,
    TextStyle textStyle,
    RenderChartAxis axis,
    Offset plotAreaOffset) {
  final Offset parentDataOffset = (axis.parentData! as BoxParentData).offset;
  final Offset axisOffset =
      parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
  final Rect axisRect = axisOffset & axis.size;
  labelRect = validateRectBounds(labelRect, axisRect);
  labelRect = axis.isVertical
      ? validateRectYPosition(labelRect, plotAreaBound)
      : validateRectXPosition(labelRect, plotAreaBound);
  path.reset();
  rect = RRect.fromRectAndRadius(
      labelRect, Radius.circular(axis.interactiveTooltip.borderRadius));
  path.addRRect(rect);
  calculateNeckPositions(
      canvas, fillPaint, strokePaint, path, position, rect, axis);
  drawText(
    canvas,
    value,
    Offset((rect.left + rect.width / 2) - labelSize.width / 2,
        (rect.top + rect.height / 2) - labelSize.height / 2),
    textStyle,
  );
  return rect;
}

/// To calculate tooltip neck positions.
void calculateNeckPositions(Canvas canvas, Paint fillPaint, Paint strokePaint,
    Path path, Offset position, RRect rect, RenderChartAxis axis) {
  final InteractiveTooltip tooltip = axis.interactiveTooltip;
  double x1, x2, x3, x4, y1, y2, y3, y4;
  if (!axis.isVertical && !axis.opposedPosition) {
    x1 = position.dx;
    y1 = rect.top - tooltip.arrowLength;
    x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
    y2 = rect.top;
    x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
    y3 = rect.top;
    x4 = position.dx;
    y4 = rect.top - tooltip.arrowLength;
  } else if (!axis.isVertical && axis.opposedPosition) {
    x1 = position.dx;
    y1 = rect.bottom + tooltip.arrowLength;
    x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
    y2 = rect.bottom;
    x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
    y3 = rect.bottom;
    x4 = position.dx;
    y4 = rect.bottom + tooltip.arrowLength;
  } else if (axis.isVertical && !axis.opposedPosition) {
    x1 = rect.right;
    y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
    x2 = rect.right;
    y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
    x3 = rect.right + tooltip.arrowLength;
    y3 = position.dy;
    x4 = rect.right + tooltip.arrowLength;
    y4 = position.dy;
  } else {
    x1 = rect.left;
    y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
    x2 = rect.left;
    y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
    x3 = rect.left - tooltip.arrowLength;
    y3 = position.dy;
    x4 = rect.left - tooltip.arrowLength;
    y4 = position.dy;
  }
  drawTooltipArrowhead(
      canvas, path, fillPaint, strokePaint, x1, y1, x2, y2, x3, y3, x4, y4);
}

/// This method will validate whether the tooltip exceeds the screen or not.
Rect validateRectBounds(Rect tooltipRect, Rect boundary) {
  Rect validatedRect = tooltipRect;
  double difference = 0;

  /// Padding between the corners.
  const double padding = 0.5;

  // Move the tooltip if it's outside of the boundary.
  if (tooltipRect.left < boundary.left) {
    difference = (boundary.left - tooltipRect.left) + padding;
    validatedRect = validatedRect.translate(difference, 0);
  }
  if (tooltipRect.right > boundary.right) {
    difference = (tooltipRect.right - boundary.right) + padding;
    validatedRect = validatedRect.translate(-difference, 0);
  }
  if (tooltipRect.top < boundary.top) {
    difference = (boundary.top - tooltipRect.top) + padding;
    validatedRect = validatedRect.translate(0, difference);
  }

  if (tooltipRect.bottom > boundary.bottom) {
    difference = (tooltipRect.bottom - boundary.bottom) + padding;
    validatedRect = validatedRect.translate(0, -difference);
  }
  return validatedRect;
}

/// Gets the x position of validated rect.
Rect validateRectYPosition(Rect labelRect, Rect axisClipRect) {
  Rect validatedRect = labelRect;
  if (labelRect.bottom >= axisClipRect.bottom) {
    validatedRect = Rect.fromLTRB(
        labelRect.left,
        labelRect.top - (labelRect.bottom - axisClipRect.bottom),
        labelRect.right,
        axisClipRect.bottom);
  } else if (labelRect.top <= axisClipRect.top) {
    validatedRect = Rect.fromLTRB(labelRect.left, axisClipRect.top,
        labelRect.right, labelRect.bottom + (axisClipRect.top - labelRect.top));
  }
  return validatedRect;
}

/// Gets the x position of validated rect.
Rect validateRectXPosition(Rect labelRect, Rect axisClipRect) {
  Rect validatedRect = labelRect;
  if (labelRect.right >= axisClipRect.right) {
    validatedRect = Rect.fromLTRB(
        labelRect.left - (labelRect.right - axisClipRect.right),
        labelRect.top,
        axisClipRect.right,
        labelRect.bottom);
  } else if (labelRect.left <= axisClipRect.left) {
    validatedRect = Rect.fromLTRB(
        axisClipRect.left,
        labelRect.top,
        labelRect.right + (axisClipRect.left - labelRect.left),
        labelRect.bottom);
  }
  return validatedRect;
}

/// Draw tooltip arrow head.
void drawTooltipArrowhead(
    Canvas canvas,
    Path backgroundPath,
    Paint fillPaint,
    Paint strokePaint,
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
    double x4,
    double y4) {
  backgroundPath.moveTo(x1, y1);
  backgroundPath.lineTo(x2, y2);
  backgroundPath.lineTo(x3, y3);
  backgroundPath.lineTo(x4, y4);
  backgroundPath.lineTo(x1, y1);
  fillPaint.isAntiAlias = true;
  canvas.drawPath(backgroundPath, strokePaint);
  canvas.drawPath(backgroundPath, fillPaint);
}
