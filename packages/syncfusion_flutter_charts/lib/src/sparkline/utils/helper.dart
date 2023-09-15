import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../marker.dart';
import 'enum.dart';

/// Methods to get the saturation color.
Color getSaturationColor(Color color) {
  Color saturationColor;
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  saturationColor = contrast >= 128 ? Colors.black : Colors.white;
  return saturationColor;
}

/// Measure the text and return the text size.
Size getTextSize(String textValue, TextStyle textStyle) {
  Size size;
  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    text: TextSpan(
        text: textValue,
        style: TextStyle(
            color: textStyle.color,
            fontSize: textStyle.fontSize,
            fontFamily: textStyle.fontFamily,
            fontStyle: textStyle.fontStyle,
            fontWeight: textStyle.fontWeight)),
  );
  textPainter.layout();
  size = Size(textPainter.width, textPainter.height);
  return size;
}

/// Draw the data label.
void drawText(Canvas canvas, String dataLabel, Offset point, TextStyle style) {
  final num maxLines = getMaxLinesContent(dataLabel);
  final TextSpan span = TextSpan(text: dataLabel, style: style);
  final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: maxLines.toInt());
  tp.layout();
  canvas.save();
  canvas.translate(point.dx, point.dy);
  const Offset labelOffset = Offset.zero;
  tp.paint(canvas, labelOffset);
  canvas.restore();
}

/// Draw the dashed line.
void drawDashedPath(
    Canvas canvas, Paint paint, Offset moveToPoint, Offset lineToPoint,
    [List<double>? dashArray]) {
  bool even = false;
  final Path path = Path();
  path.moveTo(moveToPoint.dx, moveToPoint.dy);
  path.lineTo(lineToPoint.dx, lineToPoint.dy);

  if (dashArray != null) {
    for (int i = 1; i < dashArray.length; i = i + 2) {
      if (dashArray[i] == 0) {
        even = true;
      }
    }
    if (even == false) {
      canvas.drawPath(
          _dashPath(
            path,
            dashArray: DashArrayIntervalList<double>(dashArray),
          )!,
          paint);
    }
  } else {
    canvas.drawPath(path, paint);
  }
}

/// To calculate dash array path for series.
Path? _dashPath(
  Path? source, {
  @required DashArrayIntervalList<double>? dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  double distance, length;
  bool draw;
  for (final PathMetric measurePath in source.computeMetrics()) {
    distance = intialValue;
    draw = true;
    while (distance < measurePath.length) {
      length = dashArray!.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

/// Returns the Rectangle marker type.
Path drawRectangle(Path path, double x, double y, double size) {
  path.addRect(
      Rect.fromLTRB(x - size / 2, y - size / 2, x + size / 2, y + size / 2));
  return path;
}

/// Returns the circle marker type.
Path drawCircle(Path path, double x, double y, double size) {
  path.addArc(
      Rect.fromLTRB(x - size / 2, y - size / 2, x + size / 2, y + size / 2),
      0.0,
      2 * math.pi);
  return path;
}

/// Returns the Inverted Triangle shape marker.
Path drawInvertedTriangle(Path path, double x, double y, double size) {
  path.moveTo(x + size / 2, y - size / 2);

  path.lineTo(x, y + size / 2);
  path.lineTo(x - size / 2, y - size / 2);
  path.lineTo(x + size / 2, y - size / 2);
  path.close();
  return path;
}

/// Returns the Diamond shape marker.
Path drawDiamond(Path path, double x, double y, double size) {
  path.moveTo(x - size / 2, y);
  path.lineTo(x, y + size / 2);
  path.lineTo(x + size / 2, y);
  path.lineTo(x, y - size / 2);
  path.lineTo(x - size / 2, y);
  path.close();
  return path;
}

/// Returns the Triangle shape marker.
Path drawTriangle(Path path, double x, double y, double size) {
  path.moveTo(x - size / 2, y + size / 2);
  path.lineTo(x + size / 2, y + size / 2);
  path.lineTo(x, y - size / 2);
  path.lineTo(x - size / 2, y + size / 2);
  path.close();
  return path;
}

/// Method to find the sorted spark chart points.
List<SparkChartPoint> sortSparkChartPoints(List<SparkChartPoint> dataPoints) {
  final List<SparkChartPoint> sortedPoints =
      List<SparkChartPoint>.from(dataPoints);
  sortedPoints.sort((SparkChartPoint firstPoint, SparkChartPoint secondPoint) {
    firstPoint.x.compareTo(secondPoint.x);
    if (firstPoint.x < secondPoint.x == true) {
      return -1;
    } else if (firstPoint.x > secondPoint.x == true) {
      return 1;
    } else {
      return 0;
    }
  });

  return sortedPoints;
}

/// Method to find the sorted visible points.
List<Offset> sortScreenCoordiantePoints(List<Offset> coordinatePoints) {
  coordinatePoints.sort((Offset firstPoint, Offset secondPoint) {
    firstPoint.dx.compareTo(secondPoint.dx);
    if (firstPoint.dx < secondPoint.dx) {
      return -1;
    } else if (firstPoint.dx > secondPoint.dx) {
      return 1;
    } else {
      return 0;
    }
  });

  return coordinatePoints;
}

/// Converts the provided data point to visible point for rendering.
Offset transformToCoordinatePoint(
    double minX,
    double maxX,
    double minY,
    double maxY,
    double diffX,
    double diffY,
    Size size,
    double x,
    double y,
    int dataLength) {
  final double visibleYPoint = (minY != maxY && dataLength != 1)
      ? (size.height * (1 - ((y - minY) / diffY))).roundToDouble()
      : 0;
  final double visibleXPoint = (minX != maxX)
      ? (size.width * ((x - minX) / diffX)).roundToDouble()
      : size.width / 2;
  return Offset(visibleXPoint, visibleYPoint);
}

/// Calculates and return the spark chart layout size.
Size getLayoutSize(BoxConstraints constraints, BuildContext context) {
  const double minHeight = 270;
  const double minWidth = 480;
  double height = constraints.maxHeight;
  double width = constraints.maxWidth;
  final double deviceWidth = MediaQuery.of(context).size.width;
  final double deviceHeight = MediaQuery.of(context).size.height;
  if (height == double.infinity) {
    height = width != double.infinity ? (width / 16) * 9 : minHeight;
  }

  if (width == double.infinity) {
    width = height != double.infinity ? (height / 9) * 16 : minWidth;
  }

  if (width > deviceWidth) {
    width = deviceWidth;
  }

  if (height > deviceHeight) {
    height = deviceHeight;
  }
  return Size(width, height);
}

/// Represents the circular interval list.
class DashArrayIntervalList<T> {
  /// Creates the circular interval list.
  DashArrayIntervalList(this._values);

  /// Specifies the list of value.
  final List<T> _values;

  /// Specifies the index value.
  int _index = 0;

  /// Returns the value.
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}

/// Represents the spark chart point.
class SparkChartPoint {
  /// Creates the spark chart point.
  SparkChartPoint({this.x, this.y = 0});

  /// Specifies the x point.
  dynamic x;

  /// Specifies the y point.
  num y;

  /// Specifes the pixel location of  data label.
  Offset? dataLabelOffset;

  /// Specifies the x label.
  String? labelX;

  /// Specifies the y label.
  String? labelY;

  /// Specifies the actual x value.
  dynamic actualX;

  /// Specifies the color of that particular segment in bar series.
  Color? color;
}

/// Represents the spark chart data details.
class SparkChartDataDetails {
  /// Creates the spark chart container box.
  SparkChartDataDetails(
      {this.data, this.dataCount, this.xValueMapper, this.yValueMapper});

  /// Speficies the list of spark chart data.
  final List<num>? data;

  /// Specifies the spark chart data count.
  final int? dataCount;

  /// Specifies the x-value mapper.
  final SparkChartIndexedValueMapper<dynamic>? xValueMapper;

  /// Specifies the y-value mapper.
  final SparkChartIndexedValueMapper<num>? yValueMapper;
}

/// Represents the spark chart container.
class SparkChartContainer extends SingleChildRenderObjectWidget {
  /// Creates the spark chart container.
  const SparkChartContainer({Widget? child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SparKChartContainerBox(context);
  }
}

/// Represents the spark chart container box.
class _SparKChartContainerBox extends RenderShiftedBox {
  _SparKChartContainerBox(this.context) : super(null);

  final BuildContext context;

  @override
  void performLayout() {
    size = getLayoutSize(constraints, context);

    child!.layout(
      BoxConstraints(
        maxHeight: size.height,
        maxWidth: size.width,
      ),
    ); // True- Parent widget recomputes again respect to
    // every build of child widget,
    // False- Parent widget not rebuild respect to child widget build
  }

  @override
  // ignore: unnecessary_overrides
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}

/// To draw the respective shapes for marker.
Path getMarkerShapes(
    SparkChartMarkerShape markerShape, Offset position, double size) {
  final Path path = Path();
  switch (markerShape) {
    case SparkChartMarkerShape.circle:
      {
        drawCircle(path, position.dx, position.dy, size);
      }
      break;
    case SparkChartMarkerShape.square:
      {
        drawRectangle(path, position.dx, position.dy, size);
      }
      break;

    case SparkChartMarkerShape.invertedTriangle:
      {
        drawInvertedTriangle(path, position.dx, position.dy, size);
      }
      break;

    case SparkChartMarkerShape.diamond:
      {
        drawDiamond(path, position.dx, position.dy, size);
      }
      break;
    case SparkChartMarkerShape.triangle:
      {
        drawTriangle(path, position.dx, position.dy, size);
      }
      break;
  }

  return path;
}

/// To render the marker for line and area series.
void renderMarker(
    Canvas canvas,
    Offset offset,
    SparkChartMarker marker,
    List<Offset> coordinatePoints,
    List<SparkChartPoint> dataPoints,
    Color color,
    String type,
    num highPoint,
    num lowPoint,
    double axisCrossesAt,
    SfChartThemeData themeData,
    Color? lowPointColor,
    Color? highPointColor,
    Color? negativePointColor,
    Color? firstPointColor,
    Color? lastPointColor) {
  final Paint fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint strokePaint = Paint()
    ..color = marker.borderColor ?? color
    ..style = PaintingStyle.stroke
    ..strokeWidth = marker.borderWidth;
  final SparkChartMarkerShape markerShape = marker.shape;
  final double markerSize = marker.size;
  final SparkChartMarkerDisplayMode markerDisplayMode = marker.displayMode;
  final Color themeBasedColor =
      themeData.brightness == Brightness.light ? Colors.white : Colors.black;
  Path markerPath;
  final Offset lastMarkerOffset = Offset(
      offset.dx +
          coordinatePoints[type == 'Line'
                  ? coordinatePoints.length - 1
                  : coordinatePoints.length - 2]
              .dx,
      offset.dy +
          coordinatePoints[type == 'Line'
                  ? coordinatePoints.length - 1
                  : coordinatePoints.length - 2]
              .dy);

  final Offset firstMarkerOffset = Offset(
      offset.dx + coordinatePoints[type == 'Line' ? 0 : 1].dx,
      offset.dy + coordinatePoints[type == 'Line' ? 0 : 1].dy);

  switch (markerDisplayMode) {
    case SparkChartMarkerDisplayMode.all:
      {
        final int length = type == 'Line'
            ? coordinatePoints.length
            : coordinatePoints.length - 1;
        int i = type == 'Line' ? 0 : 1;
        for (i = i; i < length; i++) {
          fillPaint.color = marker.color ?? themeBasedColor;
          if (i == (type == 'Line' ? 0 : 1)) {
            firstPointColor != null
                ? fillPaint.color = firstPointColor
                : fillPaint.color = fillPaint.color;
          } else if (i ==
              (type == 'Line'
                  ? coordinatePoints.length - 1
                  : coordinatePoints.length - 2)) {
            lastPointColor != null
                ? fillPaint.color = lastPointColor
                : fillPaint.color = fillPaint.color;
          } else if (highPoint == coordinatePoints[i].dy) {
            lowPointColor != null
                ? fillPaint.color = lowPointColor
                : fillPaint.color = fillPaint.color;
          } else if (lowPoint == coordinatePoints[i].dy) {
            highPointColor != null
                ? fillPaint.color = highPointColor
                : fillPaint.color = fillPaint.color;
          } else if (negativePointColor != null &&
              dataPoints[i].y < axisCrossesAt) {
            fillPaint.color = negativePointColor;
          }

          markerPath = getMarkerShapes(
              markerShape,
              Offset(offset.dx + coordinatePoints[i].dx,
                  offset.dy + coordinatePoints[i].dy),
              markerSize);
          canvas.drawPath(markerPath, fillPaint);
          canvas.drawPath(markerPath, strokePaint);
        }
      }
      break;
    case SparkChartMarkerDisplayMode.first:
      {
        fillPaint.color = marker.color ?? themeBasedColor;
        firstPointColor != null
            ? fillPaint.color = firstPointColor
            : fillPaint.color = fillPaint.color;
        if (negativePointColor != null &&
            dataPoints[type == 'Line' ? 0 : 1].y < 0) {
          fillPaint.color = negativePointColor;
        }
        markerPath =
            getMarkerShapes(markerShape, firstMarkerOffset, markerSize);
        canvas.drawPath(markerPath, fillPaint);
        canvas.drawPath(markerPath, strokePaint);
      }
      break;

    case SparkChartMarkerDisplayMode.last:
      {
        fillPaint.color = marker.color ?? themeBasedColor;
        lastPointColor != null
            ? fillPaint.color = lastPointColor
            : fillPaint.color = fillPaint.color;
        if (negativePointColor != null &&
            dataPoints[type == 'Line'
                        ? coordinatePoints.length - 1
                        : coordinatePoints.length - 2]
                    .y <
                0) {
          fillPaint.color = negativePointColor;
        }
        markerPath = getMarkerShapes(markerShape, lastMarkerOffset, markerSize);
        canvas.drawPath(markerPath, fillPaint);
        canvas.drawPath(markerPath, strokePaint);
      }
      break;

    case SparkChartMarkerDisplayMode.low:
      {
        fillPaint.color = marker.color ?? themeBasedColor;
        lowPointColor != null
            ? fillPaint.color = lowPointColor
            : fillPaint.color = fillPaint.color;

        final int length = type == 'Line'
            ? coordinatePoints.length
            : coordinatePoints.length - 1;
        final int index = type == 'Line' ? 0 : 1;

        for (int j = index; j < length; j++) {
          if (negativePointColor != null &&
              highPoint == coordinatePoints[j].dy &&
              dataPoints[j].y < 0) {
            fillPaint.color = negativePointColor;
          }
          if (highPoint == coordinatePoints[j].dy) {
            markerPath = getMarkerShapes(
                markerShape,
                Offset(offset.dx + coordinatePoints[j].dx,
                    offset.dy + coordinatePoints[j].dy),
                markerSize);
            canvas.drawPath(markerPath, fillPaint);
            canvas.drawPath(markerPath, strokePaint);
          }
        }
      }
      break;

    case SparkChartMarkerDisplayMode.high:
      {
        fillPaint.color = marker.color ?? themeBasedColor;
        highPointColor != null
            ? fillPaint.color = highPointColor
            : fillPaint.color = fillPaint.color;

        final int length = type == 'Line'
            ? coordinatePoints.length
            : coordinatePoints.length - 1;
        final int index = type == 'Line' ? 0 : 1;
        for (int j = index; j < length; j++) {
          if (negativePointColor != null &&
              lowPoint == coordinatePoints[j].dy &&
              dataPoints[j].y < 0) {
            fillPaint.color = negativePointColor;
          }
          if (lowPoint == coordinatePoints[j].dy) {
            markerPath = getMarkerShapes(
                markerShape,
                Offset(offset.dx + coordinatePoints[j].dx,
                    offset.dy + coordinatePoints[j].dy),
                markerSize);
            canvas.drawPath(markerPath, fillPaint);
            canvas.drawPath(markerPath, strokePaint);
          }
        }
      }
      break;

    case SparkChartMarkerDisplayMode.none:
      break;
  }
}

Color _getDataLabelSaturationColor(
    Offset dataLabelOffset,
    Offset coordinateOffset,
    SfChartThemeData theme,
    Offset offset,
    Color seriesColor,
    String type,
    [Rect? segment,
    num? yValue]) {
  Color color;

  if (type == 'Area') {
    dataLabelOffset.dy >= (offset.dy + coordinateOffset.dy)
        ? color = seriesColor
        : color = theme.brightness == Brightness.light
            ? const Color.fromRGBO(255, 255, 255, 1)
            : Colors.black;
  } else if (type == 'Line') {
    color = theme.brightness == Brightness.light
        ? const Color.fromRGBO(255, 255, 255, 1)
        : Colors.black;
  } else {
    yValue! > 0
        ? dataLabelOffset.dy > (segment!.top + offset.dy)
            ? color = seriesColor
            : color = theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black
        : dataLabelOffset.dy < (segment!.top + offset.dy)
            ? color = seriesColor
            : color = theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;
  }

  color = getSaturationColor(color);

  return color;
}

TextStyle _getTextStyle(
    TextStyle labelStyle,
    Offset dataLabelOffset,
    Offset coordinateOffset,
    Offset offset,
    SfChartThemeData theme,
    Color seriesColor,
    String type,
    [Rect? segment,
    num? yValue]) {
  final TextStyle font = labelStyle;
  final Color fontColor = font.color ??
      _getDataLabelSaturationColor(dataLabelOffset, coordinateOffset, theme,
          offset, seriesColor, type, segment, yValue);

  final TextStyle textStyle = TextStyle(
      color: fontColor,
      fontFamily: font.fontFamily,
      fontSize: font.fontSize,
      fontStyle: font.fontStyle,
      fontWeight: font.fontWeight,
      inherit: font.inherit,
      backgroundColor: font.backgroundColor,
      letterSpacing: font.letterSpacing,
      wordSpacing: font.wordSpacing,
      textBaseline: font.textBaseline,
      height: font.height,
      locale: font.locale,
      foreground: font.foreground,
      background: font.background,
      shadows: font.shadows,
      fontFeatures: font.fontFeatures,
      decoration: font.decoration,
      decorationColor: font.decorationColor,
      decorationStyle: font.decorationStyle,
      decorationThickness: font.decorationThickness,
      debugLabel: font.debugLabel,
      fontFamilyFallback: font.fontFamilyFallback);

  return textStyle;
}

/// To render the data label.
void renderDataLabel(
    Canvas canvas,
    List<String> dataLabels,
    List<SparkChartPoint> dataPoints,
    List<Offset> coordinatePoints,
    TextStyle labelStyle,
    SparkChartLabelDisplayMode labelDisplayMode,
    String type,
    SfChartThemeData theme,
    Offset offset,
    Color seriesColor,
    num highPoint,
    num lowPoint,
    [List<Rect>? segments]) {
  TextStyle textStyle;

  switch (labelDisplayMode) {
    case SparkChartLabelDisplayMode.all:
      {
        for (int i = type == 'Area' ? 1 : 0;
            type == 'Area' ? i < dataPoints.length - 1 : i < dataPoints.length;
            i++) {
          textStyle = _getTextStyle(
              labelStyle,
              dataPoints[i].dataLabelOffset!,
              coordinatePoints[i],
              offset,
              theme,
              type == 'Bar' ? dataPoints[i].color! : seriesColor,
              type,
              type == 'Bar' ? segments![i] : null,
              dataPoints[i].y);
          drawText(
              canvas, dataLabels[i], dataPoints[i].dataLabelOffset!, textStyle);
        }
      }

      break;

    case SparkChartLabelDisplayMode.first:
      {
        textStyle = _getTextStyle(
            labelStyle,
            dataPoints[type == 'Area' ? 1 : 0].dataLabelOffset!,
            coordinatePoints[type == 'Area' ? 1 : 0],
            offset,
            theme,
            type == 'Bar' ? dataPoints[0].color! : seriesColor,
            type,
            type == 'Bar' ? segments![0] : null,
            dataPoints[0].y);
        drawText(canvas, dataLabels[type == 'Area' ? 1 : 0],
            dataPoints[type == 'Area' ? 1 : 0].dataLabelOffset!, textStyle);
      }
      break;

    case SparkChartLabelDisplayMode.last:
      {
        textStyle = _getTextStyle(
            labelStyle,
            dataPoints[type == 'Area'
                    ? dataPoints.length - 2
                    : dataPoints.length - 1]
                .dataLabelOffset!,
            coordinatePoints[
                type == 'Area' ? dataPoints.length - 2 : dataPoints.length - 1],
            offset,
            theme,
            type == 'Bar'
                ? dataPoints[dataPoints.length - 1].color!
                : seriesColor,
            type,
            type == 'Bar' ? segments![dataPoints.length - 1] : null,
            dataPoints[dataPoints.length - 1].y);

        drawText(
            canvas,
            dataLabels[
                type == 'Area' ? dataPoints.length - 2 : dataPoints.length - 1],
            dataPoints[type == 'Area'
                    ? dataPoints.length - 2
                    : dataPoints.length - 1]
                .dataLabelOffset!,
            textStyle);
      }

      break;

    case SparkChartLabelDisplayMode.low:
      {
        final int length = type == 'Area'
            ? coordinatePoints.length - 1
            : coordinatePoints.length;
        final int index = type == 'Area' ? 1 : 0;
        for (int j = index; j < length; j++) {
          if (highPoint == coordinatePoints[j].dy) {
            textStyle = _getTextStyle(
                labelStyle,
                dataPoints[j].dataLabelOffset!,
                coordinatePoints[j],
                offset,
                theme,
                type == 'Bar' ? dataPoints[j].color! : seriesColor,
                type,
                type == 'Bar' ? segments![j] : null,
                dataPoints[j].y);
            drawText(canvas, dataLabels[j], dataPoints[j].dataLabelOffset!,
                textStyle);
          }
        }
      }

      break;

    case SparkChartLabelDisplayMode.high:
      {
        final int length = type == 'Area'
            ? coordinatePoints.length - 1
            : coordinatePoints.length;
        final int index = type == 'Area' ? 1 : 0;

        for (int j = index; j < length; j++) {
          if (lowPoint == coordinatePoints[j].dy) {
            textStyle = _getTextStyle(
                labelStyle,
                dataPoints[j].dataLabelOffset!,
                coordinatePoints[j],
                offset,
                theme,
                type == 'Bar' ? dataPoints[j].color! : seriesColor,
                type,
                type == 'Bar' ? segments![j] : null,
                dataPoints[j].y);
            drawText(canvas, dataLabels[j], dataPoints[j].dataLabelOffset!,
                textStyle);
          }
        }
      }

      break;

    case SparkChartLabelDisplayMode.none:
      break;
  }
}
