import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../series/chart_series.dart';
import '../series/radial_bar_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'chart_point.dart';
import 'circular_data_label.dart';
import 'connector_line.dart';
import 'data_label.dart';

/// Decides to increase the angle or not.
bool isIncreaseAngle = false;

/// To store the points which render at left and positioned outside.
List<CircularChartPoint> leftPoints = <CircularChartPoint>[];

/// To store the points which render at right and positioned outside.
List<CircularChartPoint> rightPoints = <CircularChartPoint>[];

List<Rect> renderDataLabelRegions = <Rect>[];

/// For checking whether elements collide.
bool findingCollision(Rect rect, List<Rect> regions, [Rect? pathRect]) {
  bool isCollide = false;
  if (pathRect != null &&
      (pathRect.left < rect.left &&
          pathRect.width > rect.width &&
          pathRect.top < rect.top &&
          pathRect.height > rect.height)) {
    isCollide = false;
  } else if (pathRect != null) {
    isCollide = true;
  }
  for (int i = 0; i < regions.length; i++) {
    final Rect regionRect = regions[i];
    if ((rect.left < regionRect.left + regionRect.width &&
            rect.left + rect.width > regionRect.left) &&
        (rect.top < regionRect.top + regionRect.height &&
            rect.top + rect.height > regionRect.top)) {
      isCollide = true;
      break;
    }
  }
  return isCollide;
}

/// Method to get a text when the text overlap with another segment/slice.
String segmentOverflowTrimmedText(
    CircularSeriesRenderer seriesRenderer,
    String text,
    Size size,
    CircularChartPoint point,
    Rect labelRect,
    Offset centerLocation,
    Offset labelLocation,
    OverflowMode action,
    TextStyle dataLabelStyle) {
  bool isTextWithinRegion;
  const String ellipse = '...';
  const int minCharacterLength = 3;
  // To reduce the additional padding around label rect.
  // ignore: prefer_const_declarations
  final double labelPadding = kIsWeb ? 4 : 2;

  final bool labelLeftEnd = _isInsideSegment(
      point.labelRect.centerLeft - Offset(labelPadding, 0),
      centerLocation,
      point.outerRadius!,
      point.startAngle!,
      point.endAngle!);

  final bool labelRightEnd = _isInsideSegment(
      point.labelRect.centerRight - Offset(labelPadding, 0),
      centerLocation,
      point.outerRadius!,
      point.startAngle!,
      point.endAngle!);

  if (labelLeftEnd && labelRightEnd) {
    return text;
  } else {
    isTextWithinRegion = false;
    while (!isTextWithinRegion) {
      if (action == OverflowMode.trim) {
        if (text == '') {
          break;
        }
        if (text.length > minCharacterLength) {
          text = addEllipse(text, text.length, ellipse, isRtl: false);
        } else {
          text = '';
          break;
        }
        if (text == ellipse) {
          text = '';
          break;
        }
        const num labelPadding = 0;
        final Size trimSize = measureText(text, dataLabelStyle);
        Offset trimmedLabelLocation = calculateOffset(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        trimmedLabelLocation = Offset(
            (trimmedLabelLocation.dx - trimSize.width - 5) +
                (seriesRenderer.dataLabelSettings.angle == 0
                    ? 0
                    : trimSize.width / 2),
            (trimmedLabelLocation.dy - trimSize.height / 2) +
                (seriesRenderer.dataLabelSettings.angle == 0
                    ? 0
                    : trimSize.height / 2));
        final Rect trimmedLabelRect = Rect.fromLTWH(
            trimmedLabelLocation.dx - labelPadding,
            trimmedLabelLocation.dy - labelPadding,
            trimSize.width + (2 * labelPadding),
            trimSize.height + (2 * labelPadding));

        final bool trimmedLeftEnd = _isInsideSegment(
            trimmedLabelRect.centerLeft,
            centerLocation,
            point.outerRadius!,
            point.startAngle!,
            point.endAngle!);

        final bool trimmedRightEnd = _isInsideSegment(
            trimmedLabelRect.centerRight,
            centerLocation,
            point.outerRadius!,
            point.startAngle!,
            point.endAngle!);
        if (trimmedLeftEnd && trimmedRightEnd) {
          isTextWithinRegion = true;
          point.labelRect = trimmedLabelRect;
        }
      } else {
        text = '';
        isTextWithinRegion = true;
        break;
      }
    }
  }
  return text;
}

/// Add the ellipse with trimmed text.
String addEllipse(String text, int maxLength, String ellipse, {bool? isRtl}) {
  if (isRtl ?? false) {
    if (text.contains(ellipse)) {
      text = text.replaceAll(ellipse, '');
      text = text.substring(1, text.length);
    } else {
      text = text.substring(ellipse.length, text.length);
    }
    return ellipse + text;
  } else {
    maxLength--;
    final int length = maxLength - ellipse.length;
    final String trimText = text.substring(0, length);
    return trimText + ellipse;
  }
}

/// Method to check if a label is inside the point region based
/// on the angle for pie and doughnut series.
bool _isInsideSegment(
    Offset point, Offset center, num radius, num start, num end) {
  final Offset labelOffset = point - center;
  final double labelRadius = labelOffset.distance;

  if (labelRadius < radius) {
    final num originAngle = atan2(-labelOffset.dy, labelOffset.dx) * 180 / pi;
    num labelAngle = 360 - originAngle;

    if (labelAngle > 270) {
      labelAngle -= 360;
    }
    labelAngle = labelAngle.round();

    return labelAngle >= start && labelAngle <= end;
  } else {
    return false;
  }
}

/// Method for setting color to data label.
Color findThemeColor(CircularSeriesRenderer seriesRenderer,
    CircularChartPoint point, DataLabelSettings dataLabelSettings) {
  // TODO(Lavanya): Recheck here.
  final Color dataLabelBackgroundColor =
      seriesRenderer.parent!.themeData!.colorScheme.surface;
  if (dataLabelSettings.color != null) {
    return dataLabelSettings.color!;
  } else {
    return (dataLabelSettings.useSeriesColor
        ? point.fill
        : (seriesRenderer.parent!.backgroundColor ?? dataLabelBackgroundColor));
  }
}

/// To render outside positioned data labels.
void renderOutsideDataLabel(
    CircularChartPoint point,
    Size textSize,
    int pointIndex,
    CircularSeriesRenderer seriesRenderer,
    int seriesIndex,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  final DataLabelSettings settings = seriesRenderer.dataLabelSettings;
  const String defaultConnectorLineLength = '10%';
  final EdgeInsets margin = settings.margin;
  final ConnectorLineSettings connector = settings.connectorLineSettings;
  connectorPath = Path();
  final num connectorLength = percentToValue(
      connector.length ?? defaultConnectorLineLength, point.outerRadius!)!;
  final Offset startPoint = calculateOffset(
      point.midAngle!, point.outerRadius!.toDouble(), point.center!);
  final Offset endPoint = calculateOffset(point.midAngle!,
      (point.outerRadius! + connectorLength).toDouble(), point.center!);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }

  rect = getDataLabelRect(
      point.dataLabelPosition,
      connector.type,
      margin,
      connectorPath,
      endPoint,
      textSize,
      // To avoid the extra padding added to the exact template size.
      settings.builder != null &&
              settings.labelIntersectAction == LabelIntersectAction.shift
          ? seriesRenderer.dataLabelSettings
          : null);

  point.connectorPath = connectorPath;
  point.labelRect = rect!;
  labelLocation = Offset(rect.left + margin.left,
      rect.top + rect.height / 2 - textSize.height / 2);
  point.labelLocation = labelLocation;

  final Rect containerRect = seriesRenderer.paintBounds;

  if (seriesRenderer.dataLabelSettings.builder == null) {
    if (seriesRenderer.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.hide) {
      if (!findingCollision(rect, renderDataLabelRegions) &&
          (rect.left > containerRect.left &&
              rect.left + rect.width <
                  containerRect.left + containerRect.width) &&
          rect.top > containerRect.top &&
          rect.top + rect.height < containerRect.top + containerRect.height) {
        // TODO(Lavanya): drawLabel method add renderDataLabelRegions.
        if (seriesRenderer.dataLabelSettings.labelIntersectAction !=
            LabelIntersectAction.shift) {
          renderDataLabelRegions.add(rect);
        }
      } else {
        point.isVisible = false;
      }
    } else if (seriesRenderer.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.shift) {
      renderDataLabelRegions.add(rect);
    } else {
      // TODO(Lavanya): drawLabel method add renderDataLabelRegions.
      if (seriesRenderer.dataLabelSettings.labelIntersectAction !=
          LabelIntersectAction.shift) {
        renderDataLabelRegions.add(rect);
      }
    }
  } else {
    if (seriesRenderer.dataLabelSettings.labelIntersectAction !=
        LabelIntersectAction.shift) {
      if ((!findingCollision(rect, renderDataLabelRegions) &&
              (rect.left > containerRect.left &&
                  rect.left + rect.width <
                      containerRect.left + containerRect.width) &&
              rect.top > containerRect.top &&
              rect.top + rect.height <
                  containerRect.top + containerRect.height) ||
          settings.labelIntersectAction == LabelIntersectAction.none) {
        point.connectorPath = connectorPath;
        point.labelRect = rect;
        point.labelLocation = labelLocation;
      } else {
        point.isVisible = false;
      }
    }
  }
}

/// To return data label rect calculation method based on position.
Rect? getDataLabelRect(Position position, ConnectorType connectorType,
    EdgeInsets margin, Path connectorPath, Offset endPoint, Size textSize,
    [DataLabelSettings? dataLabelSettings]) {
  Rect? rect;
  const int lineLength = 10;
  switch (position) {
    case Position.right:
      connectorType == ConnectorType.line
          ? connectorPath.lineTo(endPoint.dx + lineLength, endPoint.dy)
          : connectorPath.quadraticBezierTo(
              endPoint.dx, endPoint.dy, endPoint.dx + lineLength, endPoint.dy);
      rect = dataLabelSettings != null && dataLabelSettings.builder != null
          ? Rect.fromLTWH(
              endPoint.dx, endPoint.dy, textSize.width, textSize.height)
          : Rect.fromLTWH(
              endPoint.dx + lineLength,
              endPoint.dy - (textSize.height / 2) - margin.top,
              textSize.width + margin.left + margin.right,
              textSize.height + margin.top + margin.bottom);
      break;
    case Position.left:
      connectorType == ConnectorType.line
          ? connectorPath.lineTo(endPoint.dx - lineLength, endPoint.dy)
          : connectorPath.quadraticBezierTo(
              endPoint.dx, endPoint.dy, endPoint.dx - lineLength, endPoint.dy);
      rect = dataLabelSettings != null && dataLabelSettings.builder != null
          ? Rect.fromLTWH(
              endPoint.dx, endPoint.dy, textSize.width, textSize.height)
          : Rect.fromLTWH(
              endPoint.dx -
                  lineLength -
                  margin.right -
                  textSize.width -
                  margin.left,
              endPoint.dy - ((textSize.height / 2) + margin.top),
              textSize.width + margin.left + margin.right,
              textSize.height + margin.top + margin.bottom);
      break;
  }
  return rect;
}

void shiftCircularDataLabels(CircularSeriesRenderer seriesRenderer,
    LinkedList<CircularChartDataLabelPositioned> labels) {
  final List<CircularChartPoint> points = <CircularChartPoint>[];

  if (seriesRenderer is RadialBarSeriesRenderer) {
    return;
  }

  if (seriesRenderer.dataLabelSettings.labelIntersectAction ==
      LabelIntersectAction.shift) {
    const int labelPadding = 2;
    final DataLabelSettings dataLabelSettings =
        seriesRenderer.dataLabelSettings;
    if (dataLabelSettings.builder == null) {
      leftPoints = <CircularChartPoint>[];
      rightPoints = <CircularChartPoint>[];

      for (int i = 0; i < labels.length; i++) {
        final CircularChartPoint point = labels.elementAt(i).point!;
        points.add(point);
        if (point.isVisible) {
          point.newAngle = point.midAngle;
          if (point.dataLabelPosition == Position.left &&
              point.renderPosition == ChartDataLabelPosition.outside) {
            leftPoints.add(point);
          } else if (point.dataLabelPosition == Position.right &&
              point.renderPosition == ChartDataLabelPosition.outside) {
            rightPoints.add(point);
          }
        }
      }
      leftPoints.sort((CircularChartPoint a, CircularChartPoint b) =>
          a.newAngle!.compareTo(b.newAngle!));
      if (leftPoints.isNotEmpty) {
        _arrangeLeftSidePoints(seriesRenderer);
      }
      isIncreaseAngle = false;
      if (rightPoints.isNotEmpty) {
        _arrangeRightSidePoints(seriesRenderer);
      }
    }

    for (int pointIndex = 0; pointIndex < labels.length; pointIndex++) {
      final CircularChartDataLabelPositioned dataLabelPositioned =
          labels.elementAt(pointIndex);
      final CircularChartPoint point = dataLabelPositioned.point!;
      if (point.isVisible) {
        final EdgeInsets margin = seriesRenderer.dataLabelSettings.margin;
        Rect rect = point.labelRect;
        Offset labelLocation;
        final Size textSize = dataLabelPositioned.size;

        labelLocation = Offset(
            rect.left +
                (point.renderPosition == ChartDataLabelPosition.inside
                    ? labelPadding
                    : margin.left),
            rect.top + rect.height / 2 - textSize.height / 2);
        const String defaultConnectorLineLength = '10%';
        point.trimmedText = point.text;
        Path shiftedConnectorPath = Path();
        final num connectorLength = percentToValue(
            seriesRenderer.dataLabelSettings.connectorLineSettings.length ??
                defaultConnectorLineLength,
            point.outerRadius!)!;
        final Offset startPoint = calculateOffset(
            (point.startAngle! + point.endAngle!) / 2,
            point.outerRadius!.toDouble(),
            point.center!);
        final Offset endPoint = calculateOffset(point.newAngle!.toDouble(),
            (point.outerRadius! + connectorLength).toDouble(), point.center!);
        shiftedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
        if (seriesRenderer.dataLabelSettings.connectorLineSettings.type ==
            ConnectorType.line) {
          shiftedConnectorPath.lineTo(endPoint.dx, endPoint.dy);
        }
        getDataLabelRect(
            point.dataLabelPosition,
            seriesRenderer.dataLabelSettings.connectorLineSettings.type,
            margin,
            shiftedConnectorPath,
            endPoint,
            textSize);
        final Offset midAngle = getPerpendicularDistance(
            Offset(startPoint.dx, startPoint.dy), point);
        if (seriesRenderer.dataLabelSettings.connectorLineSettings.type ==
                ConnectorType.curve &&
            (point.isLabelUpdated) == 1) {
          const int spacing = 10;
          shiftedConnectorPath = Path();
          shiftedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
          shiftedConnectorPath.quadraticBezierTo(
              midAngle.dx,
              midAngle.dy,
              endPoint.dx -
                  (point.dataLabelPosition == Position.left
                      ? spacing
                      : -spacing),
              endPoint.dy);
        }

        // TODO(Lavanya): Recheck connector line here.
        point.connectorPath =
            point.renderPosition == ChartDataLabelPosition.outside
                ? shiftedConnectorPath
                : null;

        // TODO(Lavanya): Recheck here.
        final Rect containerRect = seriesRenderer.paintBounds;
        if (containerRect.left > rect.left) {
          labelLocation = Offset(containerRect.left,
              rect.top + rect.height / 2 - textSize.height / 2);
        }

        final DataLabelText details =
            labels.elementAt(pointIndex).child as DataLabelText;
        if (point.labelRect.left < containerRect.left &&
            point.renderPosition == ChartDataLabelPosition.outside) {
          point.trimmedText = getTrimmedText(point.trimmedText!,
              point.labelRect.right - containerRect.left, details.textStyle,
              isRtl: false); // TODO(Lavanya): Recheck here.
        }
        if (point.labelRect.right > containerRect.right &&
            point.renderPosition == ChartDataLabelPosition.outside) {
          point.trimmedText = getTrimmedText(point.trimmedText!,
              containerRect.right - point.labelRect.left, details.textStyle,
              isRtl: false);
        }

        if (point.text != point.trimmedText) {
          details.text = point.trimmedText!;
          point.dataLabelSize = measureText(details.text, details.textStyle);
          rect = getDataLabelRect(
              point.dataLabelPosition,
              seriesRenderer.dataLabelSettings.connectorLineSettings.type,
              margin,
              shiftedConnectorPath,
              endPoint,
              point.dataLabelSize,
              // To avoid the extra padding added to the exact template size.
              null)!;
        } else {
          point.trimmedText = null;
        }
        point.labelLocation = labelLocation;
        dataLabelPositioned.offset = labelLocation;

        // TODO(Lavanya): Recheck here.
        if (point.trimmedText != '' &&
            !isOverlapWithPrevious(point, points, pointIndex) &&
            rect != Rect.zero) {
          point.isVisible = true;
          point.labelRect = rect;
        } else {
          point.isVisible = false;
        }
      }
    }
  }
}

/// Left side points alignment calculation.
void _arrangeLeftSidePoints(CircularSeriesRenderer seriesRenderer) {
  CircularChartPoint previousPoint;
  CircularChartPoint currentPoint;
  bool angleChanged = false;
  bool startFresh = false;
  for (int i = 1; i < leftPoints.length; i++) {
    currentPoint = leftPoints[i];
    previousPoint = leftPoints[i - 1];
    if (isOverlapWithPrevious(currentPoint, leftPoints, i) &&
            currentPoint.isVisible ||
        !(currentPoint.newAngle! < 270)) {
      angleChanged = true;
      if (startFresh) {
        isIncreaseAngle = false;
      }
      if (!isIncreaseAngle) {
        for (int k = i; k > 0; k--) {
          _decreaseAngle(
              leftPoints[k], leftPoints[k - 1], seriesRenderer, false);
          for (int index = 1; index < leftPoints.length; index++) {
            if ((leftPoints[index].isLabelUpdated) != null &&
                leftPoints[index].newAngle! - 10 < 100) {
              isIncreaseAngle = true;
            }
          }
        }
      } else {
        for (int k = i; k < leftPoints.length; k++) {
          _increaseAngle(
              leftPoints[k - 1], leftPoints[k], seriesRenderer, false);
        }
      }
    } else {
      if (angleChanged &&
          // ignore: unnecessary_null_comparison
          previousPoint != null &&
          (previousPoint.isLabelUpdated) == 1) {
        startFresh = true;
      }
    }
  }
}

/// Right side points alignments calculation.
void _arrangeRightSidePoints(CircularSeriesRenderer seriesRenderer) {
  bool startFresh = false;
  bool angleChanged = false;
  num checkAngle;
  CircularChartPoint currentPoint;
  final CircularChartPoint? lastPoint =
      rightPoints.length > 1 ? rightPoints[rightPoints.length - 1] : null;
  CircularChartPoint nextPoint;
  if (lastPoint != null) {
    if (lastPoint.newAngle! > 360) {
      lastPoint.newAngle = lastPoint.newAngle! - 360;
      // TODO(Lavanya): Recheck here.
      // PointHelper.setNewAngle(
      //     lastPoint, PointHelper.getNewAngle(lastPoint)! - 360);
    }
    if (lastPoint.newAngle! > 90 && lastPoint.newAngle! < 270) {
      isIncreaseAngle = true;
      _changeLabelAngle(lastPoint, 89, seriesRenderer);
    }
  }
  for (int i = rightPoints.length - 2; i >= 0; i--) {
    currentPoint = rightPoints[i];
    nextPoint = rightPoints[i + 1];
    if (isOverlapWithNext(currentPoint, rightPoints, i) &&
            currentPoint.isVisible ||
        !(currentPoint.newAngle! <= 90 || currentPoint.newAngle! >= 270)) {
      checkAngle = lastPoint!.newAngle! + 1;
      angleChanged = true;
      // If last's point change angle in beyond the limit,
      //stop the increasing angle and do decrease the angle.
      if (startFresh) {
        isIncreaseAngle = false;
      } else if (checkAngle > 90 &&
          checkAngle < 270 &&
          (nextPoint.isLabelUpdated) == 1) {
        isIncreaseAngle = true;
      }
      if (!isIncreaseAngle) {
        for (int k = i + 1; k < rightPoints.length; k++) {
          _increaseAngle(
              rightPoints[k - 1], rightPoints[k], seriesRenderer, true);
        }
      } else {
        for (int k = i + 1; k > 0; k--) {
          _decreaseAngle(
              rightPoints[k], rightPoints[k - 1], seriesRenderer, true);
        }
      }
    } else {
      //If a point did not overlapped with previous points,
      //increase the angle always for right side points.
      if (angleChanged &&
          // ignore: unnecessary_null_comparison
          nextPoint != null &&
          (nextPoint.isLabelUpdated) == 1) {
        startFresh = true;
      }
    }
  }
}

/// Decrease the angle of the label if it intersects with labels.
void _decreaseAngle(
    CircularChartPoint currentPoint,
    CircularChartPoint previousPoint,
    CircularSeriesRenderer seriesRenderer,
    bool isRightSide) {
  int count = 1;
  if (isRightSide) {
    while (isOverlap(currentPoint.labelRect, previousPoint.labelRect) ||
        (seriesRenderer.pointRadii.isNotEmpty &&
            (!((previousPoint.labelRect.height + previousPoint.labelRect.top) <
                currentPoint.labelRect.top)))) {
      int newAngle = previousPoint.newAngle!.toInt() - count;
      if (newAngle < 0) {
        newAngle = 360 + newAngle;
      }
      if (newAngle <= 270 && newAngle >= 90) {
        newAngle = 270;
        isIncreaseAngle = true;
        break;
      }
      _changeLabelAngle(previousPoint, newAngle, seriesRenderer);
      count++;
    }
  } else {
    if (currentPoint.newAngle! > 270) {
      _changeLabelAngle(currentPoint, 270, seriesRenderer);
      previousPoint.newAngle = 270;
      //PointHelper.setNewAngle(previousPoint, 270);
    }
    while (isOverlap(currentPoint.labelRect, previousPoint.labelRect) ||
        (seriesRenderer.pointRadii.isNotEmpty &&
            ((currentPoint.labelRect.top + currentPoint.labelRect.height) >
                previousPoint.labelRect.bottom))) {
      int newAngle = previousPoint.newAngle!.toInt() - count;
      if (!(newAngle <= 270 && newAngle >= 90)) {
        newAngle = 270;
        isIncreaseAngle = true;
        break;
      }
      _changeLabelAngle(previousPoint, newAngle, seriesRenderer);
      if (isOverlap(currentPoint.labelRect, previousPoint.labelRect) &&
          // ignore: unnecessary_null_comparison
          leftPoints.indexOf(previousPoint) == null &&
          (newAngle - 1 < 90 && newAngle - 1 > 270)) {
        _changeLabelAngle(
            currentPoint, currentPoint.newAngle! + 1, seriesRenderer);
        _arrangeLeftSidePoints(seriesRenderer);
        break;
      }
      count++;
    }
  }
}

/// Increase the angle of the label if it intersects labels.
void _increaseAngle(
    CircularChartPoint currentPoint,
    CircularChartPoint nextPoint,
    CircularSeriesRenderer seriesRenderer,
    bool isRightSide) {
  int count = 1;
  if (isRightSide) {
    while (isOverlap(currentPoint.labelRect, nextPoint.labelRect) ||
        (seriesRenderer.pointRadii.isNotEmpty &&
            (!((currentPoint.labelRect.top + currentPoint.labelRect.height) <
                nextPoint.labelRect.top)))) {
      int newAngle = nextPoint.newAngle!.toInt() + count;
      if (newAngle < 270 && newAngle > 90) {
        newAngle = 90;
        isIncreaseAngle = true;
        break;
      }
      _changeLabelAngle(nextPoint, newAngle, seriesRenderer);
      if (isOverlap(currentPoint.labelRect, nextPoint.labelRect) &&
          (newAngle + 1 > 90 && newAngle + 1 < 270) &&
          rightPoints.indexOf(nextPoint) == rightPoints.length - 1) {
        _changeLabelAngle(
            currentPoint, currentPoint.newAngle! - 1, seriesRenderer);
        _arrangeRightSidePoints(seriesRenderer);
        break;
      }
      count++;
    }
  } else {
    while (isOverlap(currentPoint.labelRect, nextPoint.labelRect) ||
        (seriesRenderer.pointRadii.isNotEmpty &&
            (currentPoint.labelRect.top <
                (nextPoint.labelRect.top + nextPoint.labelRect.height)))) {
      int newAngle = nextPoint.newAngle!.toInt() + count;
      if (!(newAngle < 270 && newAngle > 90)) {
        newAngle = 270;
        isIncreaseAngle = false;
        break;
      }
      _changeLabelAngle(nextPoint, newAngle, seriesRenderer);
      count++;
    }
  }
}

/// Change the label angle based on the given new angle.
void _changeLabelAngle(CircularChartPoint currentPoint, num newAngle,
    CircularSeriesRenderer seriesRenderer) {
// TODO(Lavanya): Code cleanup for seriesRenderer field.

  const String defaultConnectorLineLength = '10%';
  final DataLabelSettings dataLabelSettings = seriesRenderer.dataLabelSettings;
  final RenderChartPlotArea parent = seriesRenderer.parent!;
  final TextStyle dataLabelStyle = parent.themeData!.textTheme.bodySmall!
    ..merge(parent.chartThemeData!.dataLabelTextStyle)
    ..merge(dataLabelSettings.textStyle);
  // Builder check for change the angle based on the template size.
  final Size textSize = dataLabelSettings.builder != null
      ? currentPoint.dataLabelSize
      : measureText(currentPoint.text!, dataLabelStyle);
  final Path angleChangedConnectorPath = Path();
  final num connectorLength = percentToValue(
      dataLabelSettings.connectorLineSettings.length ??
          defaultConnectorLineLength,
      currentPoint.outerRadius!)!;
  final Offset startPoint = calculateOffset(newAngle.toDouble(),
      currentPoint.outerRadius!.toDouble(), currentPoint.center!);
  final Offset endPoint = calculateOffset(
      newAngle.toDouble(),
      currentPoint.outerRadius!.toDouble() + connectorLength,
      currentPoint.center!);
  angleChangedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (dataLabelSettings.connectorLineSettings.type == ConnectorType.line) {
    angleChangedConnectorPath.lineTo(endPoint.dx, endPoint.dy);
  }

  // TODO(Lavanya): Recheck label rect position here.
  currentPoint.labelRect = getDataLabelRect(
      currentPoint.dataLabelPosition,
      seriesRenderer.dataLabelSettings.connectorLineSettings.type,
      dataLabelSettings.margin,
      angleChangedConnectorPath,
      endPoint,
      textSize)!;

  // TODO(Lavanya): Recheck connector line here.
  currentPoint.connectorPath = angleChangedConnectorPath;
  currentPoint.isLabelUpdated = 1;
  currentPoint.newAngle = newAngle;
}

/// To find the labels are intersect.
bool isOverlap(Rect currentRect, Rect rect) {
  return currentRect.left < rect.left + rect.width &&
      currentRect.left + currentRect.width > rect.left &&
      currentRect.top < (rect.top + rect.height) &&
      (currentRect.height + currentRect.top) > rect.top;
}

/// To find the current point overlapped with previous points.
bool isOverlapWithPrevious(CircularChartPoint currentPoint,
    List<CircularChartPoint> points, int currentPointIndex) {
  for (int i = 0; i < currentPointIndex; i++) {
    if (i != points.indexOf(currentPoint) &&
        points[i].isVisible &&
        isOverlap(currentPoint.labelRect, points[i].labelRect)) {
      return true;
    }
  }
  return false;
}

/// To find the current point overlapped with next points.
bool isOverlapWithNext(
    CircularChartPoint point, List<CircularChartPoint> points, int pointIndex) {
  for (int i = pointIndex; i < points.length; i++) {
    if (i != points.indexOf(point) &&
        points[i].isVisible &&
        // ignore: unnecessary_null_comparison
        (points[i].labelRect != null && point.labelRect != null) &&
        isOverlap(point.labelRect, points[i].labelRect)) {
      return true;
    }
  }
  return false;
}

/// Calculate the connected line path for shifted data label.
Offset getPerpendicularDistance(Offset startPoint, CircularChartPoint point) {
  Offset increasedLocation;
  const num add = 10;
  final num height = add + 10 * sin(point.midAngle! * pi / 360);
  if (point.midAngle! > 270 && point.midAngle! < 360) {
    increasedLocation = Offset(
        startPoint.dx + height * (cos((360 - point.midAngle!) * pi / 180)),
        startPoint.dy - height * (sin((360 - point.midAngle!) * pi / 180)));
  } else if (point.midAngle! > 0 && point.midAngle! < 90) {
    increasedLocation = Offset(
        startPoint.dx + height * (cos(point.midAngle! * pi / 180)),
        startPoint.dy + height * (sin(point.midAngle! * pi / 180)));
  } else if (point.midAngle! > 0 && point.midAngle! < 90) {
    increasedLocation = Offset(
        startPoint.dx - height * (cos((point.midAngle! - 90) * pi / 180)),
        startPoint.dy + height * (sin((point.midAngle! - 90) * pi / 180)));
  } else {
    increasedLocation = Offset(
        startPoint.dx - height * (cos((point.midAngle! - 180) * pi / 180)),
        startPoint.dy - height * (sin((point.midAngle! - 180) * pi / 180)));
  }
  return increasedLocation;
}

/// To trim the text by given width.
String getTrimmedText(String text, num labelsExtent, TextStyle labelStyle,
    {bool? isRtl}) {
  String label = text;

  num size = measureText(label, labelStyle).width;
  if (size > labelsExtent) {
    final int textLength = text.length;
    if (isRtl ?? false) {
      for (int i = 0; i < textLength - 1; i++) {
        label = '...${text.substring(i + 1, textLength)}';
        size = measureText(label, labelStyle).width;
        if (size <= labelsExtent) {
          return label == '...' ? '' : label;
        }
      }
    } else {
      for (int i = textLength - 1; i >= 0; --i) {
        label = '${text.substring(0, i)}...';
        size = measureText(label, labelStyle).width;
        if (size <= labelsExtent) {
          return label == '...' ? '' : label;
        }
      }
    }
  }
  return label == '...' ? '' : label;
}

/// To shift the data label template in the circular chart.
void shiftCircularDataLabelTemplate(CircularSeriesRenderer seriesRenderer,
    List<CircularDataLabelBoxParentData> widgets) {
  if (seriesRenderer is RadialBarSeriesRenderer) {
    return;
  }

  leftPoints = <CircularChartPoint>[];
  rightPoints = <CircularChartPoint>[];
  final List<CircularChartPoint> points = <CircularChartPoint>[];
  final List<Rect> renderDataLabelRegions = <Rect>[];
  const int labelPadding = 2;
  final List<CircularDataLabelBoxParentData> templates = widgets;

  for (int i = 0; i < templates.length; i++) {
    final CircularChartPoint point = templates[i].point!;

    if (point.newAngle == null && point.isVisible) {
      // For the data label position is inside.
      if (seriesRenderer.dataLabelSettings.labelPosition ==
          ChartDataLabelPosition.inside) {
        Offset labelLocation = calculateOffset(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        // TODO(Lavanya): Recheck here.
        // labelLocation = Offset(labelLocation.dx - (rectSize[i].width / 2),
        //     labelLocation.dy - (rectSize[i].height / 2));
        labelLocation = Offset(labelLocation.dx - (point.labelRect.width / 2),
            labelLocation.dy - (point.labelRect.height / 2));
        final Rect rect = Rect.fromLTWH(
            labelLocation.dx - labelPadding,
            labelLocation.dy - labelPadding,
            point.labelRect.width + (2 * labelPadding),
            point.labelRect.height + (2 * labelPadding));
        // If collide with label when the position is inside calculate the outside rect value of that perticular label.
        if (findingCollision(rect, renderDataLabelRegions)) {
          _renderOutsideDataLabelTemplate(point, seriesRenderer,
              point.labelRect.size, renderDataLabelRegions);
        } else {
          point.renderPosition = ChartDataLabelPosition.inside;
          point.labelRect = rect;
          // Stored the region of template rect to compare with next label.
          renderDataLabelRegions.add(rect);
        }
      } else if (seriesRenderer.dataLabelSettings.labelPosition ==
          ChartDataLabelPosition.outside) {
        _renderOutsideDataLabelTemplate(point, seriesRenderer,
            point.labelRect.size, renderDataLabelRegions);
      }
    }
  }

  for (int i = 0; i < templates.length; i++) {
    final CircularChartPoint point = templates[i].point!;
    points.add(point);
    if (point.isVisible) {
      point.newAngle = point.midAngle;
      if (point.dataLabelPosition == Position.left &&
          point.renderPosition == ChartDataLabelPosition.outside) {
        leftPoints.add(point);
      } else if (point.dataLabelPosition == Position.right &&
          point.renderPosition == ChartDataLabelPosition.outside) {
        rightPoints.add(point);
      }
    }
  }
  leftPoints.sort((CircularChartPoint a, CircularChartPoint b) =>
      a.newAngle!.compareTo(b.newAngle!));
  if (leftPoints.isNotEmpty) {
    _arrangeLeftSidePoints(seriesRenderer);
  }
  isIncreaseAngle = false;
  if (rightPoints.isNotEmpty) {
    _arrangeRightSidePoints(seriesRenderer);
  }
  int pointIndex = 0;

  // Iterate the template for avoid the hidden data points and get the visible points.
  while (pointIndex < templates.length) {
    final CircularDataLabelBoxParentData child = templates[pointIndex];

    final CircularChartPoint point = child.point!;
    if (point.isVisible) {
      final EdgeInsets margin = seriesRenderer.dataLabelSettings.margin;
      final Rect rect = point.labelRect;
      Offset labelLocation = point.labelLocation;
      final Size templateSize = point.labelRect.size;
      labelLocation = Offset(
          rect.left +
              (point.renderPosition == ChartDataLabelPosition.inside
                  ? labelPadding
                  : margin.left),
          rect.top + margin.top);
      const String defaultConnectorLineLength = '10%';
      final Path shiftedConnectorPath = Path();
      final num connectorLength = percentToValue(
          seriesRenderer.dataLabelSettings.connectorLineSettings.length ??
              defaultConnectorLineLength,
          point.outerRadius!)!;
      final Offset startPoint = calculateOffset(
          (point.startAngle! + point.endAngle!) / 2,
          point.outerRadius!.toDouble(),
          point.center!);
      final Offset endPoint = calculateOffset(point.newAngle!.toDouble(),
          (point.outerRadius! + connectorLength).toDouble(), point.center!);
      shiftedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
      if (seriesRenderer.dataLabelSettings.connectorLineSettings.type ==
          ConnectorType.line) {
        shiftedConnectorPath.lineTo(endPoint.dx, endPoint.dy);
      }

      getDataLabelRect(
          point.dataLabelPosition,
          seriesRenderer.dataLabelSettings.connectorLineSettings.type,
          margin,
          shiftedConnectorPath,
          endPoint,
          templateSize)!;

      point.connectorPath =
          point.renderPosition == ChartDataLabelPosition.outside
              ? shiftedConnectorPath
              : null;

      final Rect containerRect = seriesRenderer.paintBounds;

      if (isTemplateWithinBounds(containerRect, rect) &&
          !isOverlapWithPrevious(point, points, pointIndex) &&
          rect != Rect.zero) {
        point.isVisible = true;
        point.labelRect = rect;
        point.labelLocation = labelLocation;
        child.offset = labelLocation;
      } else {
        point.isVisible = false;
      }
    }
    pointIndex++;
  }
}

/// To check template is within bounds.
bool isTemplateWithinBounds(Rect bounds, Rect templateRect) =>
    templateRect.left >= bounds.left &&
    templateRect.left + templateRect.width <= bounds.left + bounds.width &&
    templateRect.top >= bounds.top &&
    templateRect.top + templateRect.height <= bounds.top + bounds.height;

// Calculate the data label rectangle value when the data label template
// position is outside and it consider the outer radius.
void _renderOutsideDataLabelTemplate(
    CircularChartPoint point,
    CircularSeriesRenderer seriesRenderer,
    Size templateSize,
    List<Rect> renderDataLabelRegion) {
  Path connectorPath;
  const String defaultConnectorLineLength = '10%';
  final EdgeInsets margin = seriesRenderer.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer.dataLabelSettings.connectorLineSettings;
  connectorPath = Path();
  final num connectorLength = percentToValue(
      connector.length ?? defaultConnectorLineLength, point.outerRadius!)!;
  final Offset startPoint = calculateOffset(
      point.midAngle!, point.outerRadius!.toDouble(), point.center!);
  final Offset endPoint = calculateOffset(point.midAngle!,
      (point.outerRadius! + connectorLength).toDouble(), point.center!);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  point.dataLabelSize = templateSize;
  final Rect rect = getDataLabelRect(point.dataLabelPosition, connector.type,
      margin, connectorPath, endPoint, templateSize)!;
  point.connectorPath = connectorPath;
  point.labelRect = rect;
  point.renderPosition = ChartDataLabelPosition.outside;
  renderDataLabelRegions.add(rect);
}
