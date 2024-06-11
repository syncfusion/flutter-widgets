import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/core_legend.dart' as core;
import '../common/core_tooltip.dart';
import '../common/layout_handler.dart';
import '../common/legend.dart';
import '../common/marker.dart';
import '../common/title.dart';
import '../indicators/technical_indicator.dart';
import '../interactions/tooltip.dart';
import '../series/bar_series.dart';
import '../series/chart_series.dart';
import '../series/column_series.dart';
import '../utils/enum.dart';
import 'constants.dart';

// A circular array for dash offsets and lengths.
class _IntervalList<double> {
  _IntervalList(this.dashArray);

  final List<double> dashArray;
  int _index = 0;

  double get next {
    if (_index >= dashArray.length) {
      _index = 0;
    }
    return dashArray[_index++];
  }
}

Widget buildChartWithTitle(
  Widget current,
  ChartTitle title,
  SfChartThemeData chartThemeData,
) {
  if (title.text.isNotEmpty) {
    return ChartLayoutHandler(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            alignment: alignmentFromChartAlignment(title.alignment),
            child: Container(
              decoration: BoxDecoration(
                color: chartThemeData.titleBackgroundColor,
                border: Border.all(
                  color: title.borderWidth == 0
                      ? Colors.transparent
                      : title.borderColor,
                  width: title.borderWidth,
                ),
              ),
              child: Text(
                title.text,
                style: chartThemeData.titleTextStyle,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(1.2),
              ),
            ),
          ),
          Expanded(child: current),
        ],
      ),
    );
  } else {
    return current;
  }
}

Alignment alignmentFromChartAlignment(ChartAlignment alignment) {
  switch (alignment) {
    case ChartAlignment.near:
      return Alignment.centerLeft;

    case ChartAlignment.center:
      return Alignment.center;

    case ChartAlignment.far:
      return Alignment.centerRight;
  }
}

double factorFromValue(String? value) {
  if (value != null && value.isNotEmpty) {
    final double? factor = value.contains('%')
        ? double.tryParse(value.replaceAll(RegExp('%'), ''))! / 100.0
        : double.tryParse(value);
    return factor != null ? clampDouble(factor, 0.0, 1.0) : 0.0;
  }
  return 0.0;
}

Offset rawValueToPixelPoint(dynamic x, num y, RenderChartAxis? xAxis,
    RenderChartAxis? yAxis, bool isTransposed) {
  if (xAxis == null || yAxis == null) {
    return Offset.zero;
  }

  num xValue;

  if (x is int) {
    xValue = x;
  } else {
    if (xAxis is RenderDateTimeAxis) {
      assert(x is DateTime);
      xValue = (x as DateTime).millisecondsSinceEpoch;
    } else if (xAxis is RenderDateTimeCategoryAxis) {
      assert(x is DateTime);
      xValue = xAxis.labels.indexOf((x as DateTime).millisecondsSinceEpoch);
    } else if (xAxis is RenderCategoryAxis) {
      assert(x is String);
      xValue = xAxis.labels.indexOf(x);
    } else {
      xValue = x;
    }
  }

  return Offset(
    _pointToPixelX(xValue, y, xAxis, yAxis, isTransposed),
    _pointToPixelY(xValue, y, xAxis, yAxis, isTransposed),
  );
}

double _pointToPixelX(num x, num y, RenderChartAxis xAxis,
    RenderChartAxis yAxis, bool isTransposed) {
  return isTransposed ? yAxis.pointToPixel(y) : xAxis.pointToPixel(x);
}

double _pointToPixelY(num x, num y, RenderChartAxis xAxis,
    RenderChartAxis yAxis, bool isTransposed) {
  return isTransposed ? xAxis.pointToPixel(x) : yAxis.pointToPixel(y);
}

int findIndex(num target, List<num> values, {int start = 0, int? end}) {
  if (values.isEmpty) {
    return -1;
  }

  end ??= values.length - 1;
  int mid = -1;
  while (start <= end!) {
    mid = start + ((end - start) ~/ 2);
    final num midValue = values[mid];
    if (midValue == target) {
      if (mid == 0 || values[mid - 1] < target) {
        return mid;
      } else {
        end = mid - 1;
      }
    } else if (midValue < target) {
      start = mid + 1;
    } else {
      end = mid - 1;
    }
  }

  return mid;
}

int clampInt(int x, int min, int max) {
  assert(min <= max && !max.isNaN && !min.isNaN);
  if (x < min) {
    return min;
  }
  if (x > max) {
    return max;
  }
  if (x.isNaN) {
    return max;
  }
  return x;
}

Path createPath(List<Offset> points) {
  final Path path = Path();
  bool movePoint = true;
  final int length = points.length;
  for (int i = 0; i < length; i++) {
    final Offset point = points[i];
    if (movePoint && !point.dy.isNaN) {
      path.moveTo(point.dx, point.dy);
      movePoint = false;
    } else {
      if (point.dy.isNaN) {
        movePoint = true;
        continue;
      }
      path.lineTo(point.dx, point.dy);
    }
  }
  return path;
}

void drawDashesFromPoints(
    Canvas canvas, List<Offset> points, List<double>? dashArray, Paint paint) {
  if (points.isEmpty) {
    return;
  }

  final Path path = createPath(points);
  drawDashes(canvas, dashArray, paint, path: path);
}

void drawDashes(Canvas canvas, List<double>? dashArray, Paint paint,
    {Path? path, Offset? start, Offset? end}) {
  if (path == null &&
      (start == null || start.isNaN || end == null || end.isNaN)) {
    return;
  }

  bool even = true;
  if (dashArray != null && !dashArray.every((double value) => value <= 0)) {
    even = false;
    for (int i = 1; i < dashArray.length; i = i + 2) {
      if (dashArray[i] == 0) {
        even = true;
      }
    }
  }

  if (even) {
    if (path == null && start != null && end != null) {
      canvas.drawLine(start, end, paint);
    } else if (path != null) {
      canvas.drawPath(path, paint);
    }
  } else {
    if (path == null && start != null && end != null) {
      path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
    }

    if (path == null) {
      return;
    }

    paint.isAntiAlias = false;
    canvas.drawPath(
        _dashPath(path, dashArray: _IntervalList<double>(dashArray!))!, paint);
  }
}

/// To calculate dash array path for series.
Path? _dashPath(
  Path? source, {
  required _IntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double initialValue = 0.0;
  final Path path = Path();
  for (final PathMetric matric in source.computeMetrics()) {
    double distance = initialValue;
    bool canDraw = true;
    while (distance < matric.length) {
      final double length = dashArray.next;
      if (canDraw) {
        path.addPath(
            matric.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      canDraw = !canDraw;
    }
  }
  return path;
}

Color dataLabelSurfaceColor(
    Color labelColor,
    int dataPointIndex,
    ChartDataLabelPosition labelPosition,
    SfChartThemeData chartThemeData,
    ThemeData themeData,
    ChartSegment segment) {
  switch (labelPosition) {
    case ChartDataLabelPosition.inside:
      return labelColor != Colors.transparent
          ? labelColor
          : segment.fillPaint.color;
    case ChartDataLabelPosition.outside:
      if (labelColor == Colors.transparent) {
        if (chartThemeData.plotAreaBackgroundColor != Colors.transparent) {
          return chartThemeData.plotAreaBackgroundColor!;
        } else if (chartThemeData.backgroundColor != Colors.transparent) {
          return chartThemeData.backgroundColor!;
        }
        return themeData.colorScheme.surface;
      }
      return labelColor;
  }
}

/// To get saturation color.
Color saturatedTextColor(Color color) {
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  return contrast >= 128 ? Colors.black : Colors.white;
}

TextStyle saturatedTextStyle(Color surfaceColor, TextStyle baseTextStyle) {
  if (baseTextStyle.color != Colors.transparent) {
    return baseTextStyle;
  }
  return baseTextStyle.copyWith(color: saturatedTextColor(surfaceColor));
}

Path strokePathFromRRect(RRect? rect, double strokeWidth) {
  final RRect bounds = rect!.deflate(strokeWidth / 2);
  return Path()..addRRect(bounds);
}

Path strokePathFromRect(Rect? rect, double strokeWidth) {
  final Rect bounds = rect!.deflate(strokeWidth / 2);
  return Path()..addRect(bounds);
}

double? percentToValue(String? value, num size) {
  return value != null
      ? value.contains('%')
          ? (size / 100) *
              double.tryParse(value.replaceAll(RegExp('%'), ''))!.abs()
          : double.tryParse(value)?.abs()
      : null;
}

Offset calculateOffset(double degree, double radius, Offset center) {
  final double radian = degreesToRadians(degree);
  return Offset(
      center.dx + cos(radian) * radius, center.dy + sin(radian) * radius);
}

double degreesToRadians(double deg) => deg * (pi / 180);

bool isLies(num start, num end, DoubleRange range) {
  final bool isStartInside = start >= range.minimum && start <= range.maximum;
  final bool isEndInside = end >= range.minimum && end <= range.maximum;
  final bool isRangeInside = range.minimum >= start && range.maximum <= end;
  return isStartInside || isEndInside || isRangeInside;
}

String trimmedText(
    String text, TextStyle labelStyle, num labelsExtent, int labelRotation,
    {bool? isRtl}) {
  String current = text;
  num width = measureText(text, labelStyle, labelRotation).width;
  if (width > labelsExtent) {
    final int textLength = text.length;
    if (isRtl ?? false) {
      for (int i = 0; i < textLength - 1; i++) {
        current = '...${text.substring(i + 1, textLength)}';
        width = measureText(current, labelStyle, labelRotation).width;
        if (width <= labelsExtent) {
          return current == '...' ? '' : current;
        }
      }
    } else {
      for (int i = textLength - 1; i >= 0; --i) {
        current = '${text.substring(0, i)}...';
        width = measureText(current, labelStyle, labelRotation).width;
        if (width <= labelsExtent) {
          return current == '...' ? '' : current;
        }
      }
    }
  }
  return current == '...' ? '' : current;
}

double paddingFromSize(String? padding, double size) {
  if (padding != null && padding.isNotEmpty) {
    if (padding.contains('%')) {
      return (size / 100) * num.tryParse(padding.replaceAll(RegExp('%'), ''))!;
    } else if (padding.contains('px')) {
      return double.parse(padding.replaceAll('px', ''));
    } else {
      return double.parse(padding);
    }
  }
  return 0;
}

Rect clipRect(Rect bounds, double animationFactor,
    {bool isInversed = false, bool isTransposed = false}) {
  double left = bounds.left;
  double top = bounds.top;
  double width = bounds.width;
  double height = bounds.height;
  if (isTransposed) {
    if (isInversed) {
      height = bounds.height * animationFactor;
    } else {
      top = bounds.height * (1 - animationFactor);
    }
  } else {
    if (isInversed) {
      left = bounds.width * (1 - animationFactor);
    } else {
      width = bounds.width * animationFactor;
    }
  }
  return Rect.fromLTWH(left, top, width, height);
}

ShapeMarkerType toShapeMarkerType(DataMarkerType type) {
  switch (type) {
    case DataMarkerType.none:
    case DataMarkerType.circle:
      return ShapeMarkerType.circle;
    case DataMarkerType.rectangle:
      return ShapeMarkerType.rectangle;
    case DataMarkerType.image:
      return ShapeMarkerType.image;
    case DataMarkerType.pentagon:
      return ShapeMarkerType.pentagon;
    case DataMarkerType.verticalLine:
      return ShapeMarkerType.verticalLine;
    case DataMarkerType.horizontalLine:
      return ShapeMarkerType.horizontalLine;
    case DataMarkerType.diamond:
      return ShapeMarkerType.diamond;
    case DataMarkerType.triangle:
      return ShapeMarkerType.triangle;
    case DataMarkerType.invertedTriangle:
      return ShapeMarkerType.invertedTriangle;
  }
}

ShapeMarkerType toLegendShapeMarkerType(
    LegendIconType iconType, core.LegendItemProvider provider) {
  switch (iconType) {
    case LegendIconType.seriesType:
      return provider.effectiveLegendIconType();
    case LegendIconType.circle:
      return ShapeMarkerType.circle;
    case LegendIconType.rectangle:
      return ShapeMarkerType.rectangle;
    case LegendIconType.image:
      return ShapeMarkerType.image;
    case LegendIconType.pentagon:
      return ShapeMarkerType.pentagon;
    case LegendIconType.verticalLine:
      return ShapeMarkerType.verticalLine;
    case LegendIconType.horizontalLine:
      return ShapeMarkerType.horizontalLine;
    case LegendIconType.diamond:
      return ShapeMarkerType.diamond;
    case LegendIconType.triangle:
      return ShapeMarkerType.triangle;
    case LegendIconType.invertedTriangle:
      return ShapeMarkerType.invertedTriangle;
  }
}

LegendIconType toLegendIconType(ShapeMarkerType iconType) {
  switch (iconType) {
    case ShapeMarkerType.circle:
      return LegendIconType.circle;
    case ShapeMarkerType.rectangle:
      return LegendIconType.rectangle;
    case ShapeMarkerType.image:
      return LegendIconType.image;
    case ShapeMarkerType.pentagon:
      return LegendIconType.pentagon;
    case ShapeMarkerType.verticalLine:
      return LegendIconType.verticalLine;
    case ShapeMarkerType.horizontalLine:
      return LegendIconType.horizontalLine;
    case ShapeMarkerType.diamond:
      return LegendIconType.diamond;
    case ShapeMarkerType.triangle:
      return LegendIconType.triangle;
    case ShapeMarkerType.invertedTriangle:
      return LegendIconType.invertedTriangle;
    // ignore: no_default_cases
    default:
      return LegendIconType.seriesType;
  }
}

String decimalLabelValue(num? value, [int? showDigits]) {
  if (value != null && value.toString().split('.').length > 1) {
    final String str = value.toString();
    final List<String> list = str.split('.');
    value = double.parse(value.toStringAsFixed(showDigits ?? 3));
    value = (list[1] == '0' ||
            list[1] == '00' ||
            list[1] == '000' ||
            list[1] == '0000' ||
            list[1] == '00000' ||
            list[1] == '000000' ||
            list[1] == '0000000')
        ? value.round()
        : value;
  }

  return value == null ? '' : value.toString();
}

String formatNumericValue(num value, RenderChartAxis? axis, [int digits = 6]) {
  final String text = value.toString();
  final List<String> splitter = text.split('.');
  String fixedValue = text;
  if (splitter.length > 1) {
    fixedValue = value.toStringAsFixed(digits);
    value = double.parse(fixedValue);
    if (splitter[1] == '0' ||
        splitter[1] == '00' ||
        splitter[1] == '000' ||
        splitter[1] == '0000' ||
        splitter[1] == '00000' ||
        splitter[1] == '000000') {
      value = value.round();
    }
    fixedValue = value.toString();
  }

  NumberFormat? numberFormat;
  String? labelFormat;
  if (axis != null) {
    if (axis is RenderNumericAxis) {
      numberFormat = axis.numberFormat;
      labelFormat = axis.labelFormat;
    } else if (axis is RenderLogarithmicAxis) {
      numberFormat = axis.numberFormat;
      labelFormat = axis.labelFormat;
    }
  }

  String formattedText = fixedValue;
  if (numberFormat != null) {
    formattedText = numberFormat.format(value);
  }

  if (labelFormat != null) {
    formattedText = labelFormat.replaceAll(RegExp('{value}'), formattedText);
  }

  return formattedText;
}

String formatRTLText(String tooltipText) {
  final List<String> textCollection = tooltipText.split('\n');
  String resultantString = '';

  for (final String text in textCollection) {
    if (text.contains(':')) {
      final List<String> secondStringCollection = text.split(':');
      String string = '';
      for (int i = secondStringCollection.length - 1; i >= 0; i--) {
        secondStringCollection[i] = secondStringCollection[i].trim();
        string += (i == secondStringCollection.length - 1
            ? secondStringCollection[i]
            : ' : ${secondStringCollection[i]}');
      }
      resultantString += (resultantString.isEmpty ? '' : '\n') + string;
    } else {
      resultantString += (resultantString.isEmpty ? '' : '\n') + text;
    }
  }

  return resultantString;
}

Widget? buildTooltipWidget(
  BuildContext context,
  TooltipInfo? info,
  Size maxSize,
  TooltipBehavior? tooltipBehavior,
  SfChartThemeData chartThemeData,
  ThemeData themeData,
) {
  Widget? tooltip;
  final TextStyle textStyle = chartThemeData.tooltipTextStyle!;
  if (info is ChartTooltipInfo) {
    if (tooltipBehavior != null) {
      tooltip = tooltipBehavior.builder?.call(
        info.data,
        info.point,
        info.series,
        info.pointIndex,
        info.seriesIndex,
      );

      if (tooltip == null) {
        final bool hasMarker = tooltipBehavior.canShowMarker &&
            info.markerColors.isNotEmpty &&
            info.markerColors.any((Color? color) => color != null);

        final TextStyle textStyle = chartThemeData.tooltipTextStyle!;
        final TextStyle headerStyle =
            textStyle.copyWith(fontWeight: FontWeight.bold);
        final String header = tooltipBehavior.header ?? info.header;
        final Size headerSize = measureText(header, headerStyle);
        final Size textSize = measureText(info.text!, textStyle);

        double headerAlignedSize = max(headerSize.width, textSize.width);
        double dividerWidth = headerAlignedSize;
        if (headerAlignedSize >= maxSize.width) {
          headerAlignedSize = maxSize.width - tooltipInnerPadding.horizontal;
          dividerWidth = headerAlignedSize;
        } else {
          dividerWidth += tooltipBehavior.canShowMarker
              ? tooltipMarkerSize + tooltipMarkerPadding.horizontal
              : 0.0;
        }

        final bool isLtr = Directionality.of(context) == TextDirection.ltr;
        final bool hasHeader = header.isNotEmpty;
        tooltip = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (hasHeader)
                  SizedBox(
                    width: headerAlignedSize,
                    child: Center(child: Text(header, style: headerStyle)),
                  ),
                if (hasHeader)
                  SizedBox(
                    width: dividerWidth,
                    child: Divider(
                      height: 10.0,
                      thickness: 0.5,
                      color: tooltipBehavior.textStyle?.color ??
                          chartThemeData.tooltipSeparatorColor,
                    ),
                  ),
                if (info.text != null && info.text!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (hasMarker)
                        Padding(
                          padding: tooltipItemSpacing,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List<Widget>.generate(
                              info.markerColors.length,
                              (int index) {
                                return Padding(
                                  padding: tooltipMarkerPadding,
                                  child: TooltipMarkerShapeRenderObject(
                                    index: index,
                                    colors: info.markerColors,
                                    themeData: themeData,
                                    image: info.renderer.markerSettings.image,
                                    markerType: info.markerType,
                                    series: info.renderer,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      Text(
                        info.text!,
                        style: textStyle,
                        textAlign: isLtr ? TextAlign.left : TextAlign.right,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );

        tooltip = Padding(
          padding: tooltipInnerPadding,
          child: tooltip,
        );
      }
    }
  } else if (info != null && info.text != null && info.text!.isNotEmpty) {
    // Axis label tooltip.
    tooltip = Padding(
      padding: tooltipInnerPadding,
      child: Text(info.text!, style: textStyle),
    );
  }

  return tooltip;
}

class TooltipMarkerShapeRenderObject<T, D> extends LeafRenderObjectWidget {
  const TooltipMarkerShapeRenderObject({
    super.key,
    required this.index,
    required this.colors,
    required this.themeData,
    required this.image,
    required this.markerType,
    this.series,
  });

  final int index;
  final List<Color?> colors;
  final ThemeData themeData;
  final ImageProvider? image;
  final DataMarkerType markerType;
  final ChartSeriesRenderer<T, D>? series;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTooltipMarkerShape<T, D>(
      index: index,
      colors: colors,
      themeData: themeData,
      image: image,
      markerType: markerType,
    )..series = series;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderTooltipMarkerShape<T, D> renderObject) {
    renderObject
      ..index = index
      ..colors = colors
      ..themeData = themeData
      ..image = image
      ..markerType = markerType
      ..series = series;
  }
}

class RenderTooltipMarkerShape<T, D> extends RenderBox {
  RenderTooltipMarkerShape({
    required int index,
    required List<Color?> colors,
    required ThemeData themeData,
    required ImageProvider? image,
    required DataMarkerType markerType,
  }) {
    _index = index;
    _colors = colors;
    _themeData = themeData;
    _image = image;
    _markerType = markerType;
    _fetchMarkerImage();
  }

  int? get index => _index;
  int? _index;
  set index(int? value) {
    if (_index != value) {
      _index = value;
    }
  }

  List<Color?>? get colors => _colors;
  List<Color?>? _colors;
  set colors(List<Color?>? value) {
    if (_colors != value) {
      _colors = value;
      markNeedsPaint();
    }
  }

  ThemeData? get themeData => _themeData;
  ThemeData? _themeData;
  set themeData(ThemeData? value) {
    if (_themeData != value) {
      _themeData = value;
      markNeedsPaint();
    }
  }

  ImageProvider? get image => _image;
  ImageProvider? _image;
  set image(ImageProvider? value) {
    if (_image != value) {
      _image = value;
      _fetchMarkerImage();
    }
  }

  DataMarkerType get markerType => _markerType;
  DataMarkerType _markerType = DataMarkerType.circle;
  set markerType(DataMarkerType value) {
    if (_markerType != value) {
      _markerType = value;
      markNeedsPaint();
    }
  }

  late ChartSeriesRenderer<T, D>? series;
  Image? _markerImage;

  void _fetchMarkerImage() {
    if (markerType == DataMarkerType.image && image != null) {
      fetchImage(image).then((Image? value) {
        _markerImage = value;
        markNeedsPaint();
      });
    } else {
      _markerImage = null;
    }
  }

  @override
  void performLayout() {
    size = const Size(tooltipMarkerSize, tooltipMarkerSize);
  }

  final Paint strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 1.0;
  final Paint fillPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (index != null) {
      final ColorScheme colorScheme = themeData!.colorScheme;
      strokePaint.color = colorScheme.surface;

      fillPaint.color = colors![index!] ?? colorScheme.onSurface;
      if (series != null) {
        fillPaint.shader = (series as CartesianSeriesRenderer<T, D>)
            .markerShader(offset & size);
      }

      if (markerType == DataMarkerType.image) {
        if (_markerImage != null) {
          paintImage(
              canvas: context.canvas,
              rect: offset & size,
              image: _markerImage!);
        }
      } else {
        _drawTooltipMarker(
          context.canvas,
          fillPaint,
          strokePaint,
          offset,
          size,
          markerType,
        );
      }
    }
  }

  @override
  void dispose() {
    _markerImage = null;
    fillPaint.shader?.dispose();
    super.dispose();
  }
}

void _drawTooltipMarker(
  Canvas canvas,
  Paint fillPaint,
  Paint strokePaint,
  Offset point,
  Size size,
  DataMarkerType type,
) {
  if (type != DataMarkerType.none) {
    paint(
      canvas: canvas,
      rect: point & size,
      shapeType: toShapeMarkerType(type),
      paint: fillPaint,
      borderPaint: strokePaint,
    );
  }
}

/// This method returns image from provider.
Future<Image?> fetchImage(ImageProvider? imageProvider) async {
  if (imageProvider == null) {
    return null;
  }

  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  imageProvider
      .resolve(ImageConfiguration.empty)
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
  }));
  final ImageInfo imageInfo = await completer.future;
  return imageInfo.image;
}

extension ChartSeriesExtension<T, D> on ChartSeriesRenderer<T, D> {
  String tooltipText(ChartPoint<D> point) {
    String result;
    final int digits = parent!.tooltipBehavior!.decimalPlaces;
    final String xValue = point.x.toString();
    final String yValue = decimalLabelValue(point.y, digits);
    final bool isLtr = textDirection == TextDirection.ltr;

    if (parent!.tooltipBehavior!.format != null) {
      final String resultantString = parent!.tooltipBehavior!.format!
          .replaceAll('point.x', xValue)
          .replaceAll('point.y', yValue)
          .replaceAll('series.name', name);
      result = isLtr ? resultantString : formatRTLText(resultantString);
    } else {
      result = isLtr ? '$xValue : $yValue' : '$yValue : $xValue';
    }
    return result;
  }
}

extension CartesianSeriesExtension<T, D> on CartesianSeriesRenderer<T, D> {
  String _formatTooltipLabel(num value, int digits, String text, bool isLtr) {
    return isLtr
        ? '$text : ${formatNumericValue(value, yAxis, digits)}'
        : '${formatNumericValue(value, yAxis, digits)} : $text';
  }

  String _replace(
      String tooltipText, String replacingText, num value, int digits) {
    return tooltipText.replaceAll(
        replacingText, formatNumericValue(value, yAxis, digits));
  }

  String _formatTrackballLabel(num value, int digits, String text, bool isLtr) {
    if (text.isEmpty) {
      return formatNumericValue(value, yAxis, digits);
    }
    return isLtr
        ? '$text: ${formatNumericValue(value, yAxis, digits)}'
        : '${formatNumericValue(value, yAxis, digits)} :$text';
  }

  String tooltipText(CartesianChartPoint<D> point, [int outlierIndex = -1]) {
    if (xAxis == null || point.x == null) {
      return '';
    }

    String text = '';
    if (parent == null || parent!.tooltipBehavior == null) {
      return '';
    }

    final int digits = parent!.tooltipBehavior!.decimalPlaces;
    final bool isLtr = textDirection == TextDirection.ltr;
    final String? tooltipFormat = parent?.tooltipBehavior?.format;
    if (tooltipFormat != null) {
      text = tooltipHeaderText(point, digits);
      String tooltipText = tooltipFormat.replaceAll('point.x', text);

      if (point.y != null) {
        tooltipText = _replace(tooltipText, 'point.y', point.y!, digits);
      }

      if (point.high != null) {
        tooltipText = _replace(tooltipText, 'point.high', point.high!, digits);
      }

      if (point.low != null) {
        tooltipText = _replace(tooltipText, 'point.low', point.low!, digits);
      }

      if (point.open != null) {
        tooltipText = _replace(tooltipText, 'point.open', point.open!, digits);
      }

      if (point.close != null) {
        tooltipText =
            _replace(tooltipText, 'point.close', point.close!, digits);
      }

      if (outlierIndex != -1) {
        if (point.outliers != null && point.outliers!.isNotEmpty) {
          tooltipText = _replace(tooltipText, 'point.outliers',
              point.outliers![outlierIndex], digits);
        }
      } else {
        if (point.minimum != null) {
          tooltipText =
              _replace(tooltipText, 'point.minimum', point.minimum!, digits);
        }

        if (point.maximum != null) {
          tooltipText =
              _replace(tooltipText, 'point.maximum', point.maximum!, digits);
        }

        if (point.lowerQuartile != null) {
          tooltipText = _replace(
              tooltipText, 'point.lowerQuartile', point.lowerQuartile!, digits);
        }

        if (point.upperQuartile != null) {
          tooltipText = _replace(
              tooltipText, 'point.upperQuartile', point.upperQuartile!, digits);
        }

        if (point.mean != null) {
          tooltipText =
              _replace(tooltipText, 'point.mean', point.mean!, digits);
        }

        if (point.median != null) {
          tooltipText =
              _replace(tooltipText, 'point.median', point.median!, digits);
        }
      }

      if (point.cumulative != null) {
        tooltipText = _replace(
            tooltipText, 'point.cumulative', point.cumulative!, digits);
      }

      if (point.bubbleSize != null) {
        tooltipText =
            _replace(tooltipText, 'point.size', point.bubbleSize!, digits);
      }

      tooltipText = tooltipText.replaceAll('series.name', name);
      text = isLtr ? tooltipText : formatRTLText(tooltipText);
    } else {
      text = parent!.tooltipBehavior!.shared
          ? name
          : tooltipHeaderText(point, digits);

      if (point.y != null) {
        text = _formatTooltipLabel(point.y!, digits, text, isLtr);
      }

      if (point.high != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTooltipLabel(point.high!, digits, 'High', isLtr);
      }

      if (point.low != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }

        text += _formatTooltipLabel(point.low!, digits, 'Low', isLtr);
      }

      if (point.open != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTooltipLabel(point.open!, digits, 'Open', isLtr);
      }

      if (point.close != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTooltipLabel(point.close!, digits, 'Close', isLtr);
      }

      if (outlierIndex != -1) {
        if (point.outliers != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTooltipLabel(
              point.outliers![outlierIndex], digits, 'Outliers', isLtr);
        }
      } else {
        if (point.minimum != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTooltipLabel(point.minimum!, digits, 'Minimum', isLtr);
        }

        if (point.maximum != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTooltipLabel(point.maximum!, digits, 'Maximum', isLtr);
        }

        if (point.median != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTooltipLabel(point.median!, digits, 'Median', isLtr);
        }

        if (point.mean != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTooltipLabel(point.mean!, digits, 'Mean', isLtr);
        }

        if (point.lowerQuartile != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text +=
              _formatTooltipLabel(point.lowerQuartile!, digits, 'LQ', isLtr);
        }

        if (point.upperQuartile != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text +=
              _formatTooltipLabel(point.upperQuartile!, digits, 'HQ', isLtr);
        }
      }
    }

    return text;
  }

  String trackballText(CartesianChartPoint<D> point, String seriesName,
      {int outlierIndex = -1}) {
    if (parent == null ||
        parent!.trackballBehavior == null ||
        xAxis == null ||
        point.x == null) {
      return '';
    }

    String text = '';
    final int digits = parent!.trackballBehavior!.tooltipSettings.decimalPlaces;
    if (parent!.trackballBehavior!.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints) {
      text = seriesName;
    }

    final bool isLtr = textDirection == TextDirection.ltr;
    final String? tooltipFormat =
        parent!.trackballBehavior!.tooltipSettings.format;
    if (tooltipFormat != null) {
      text = tooltipHeaderText(point, digits);
      String tooltipText = tooltipFormat.replaceAll('point.x', text);

      if (point.y != null) {
        tooltipText = _replace(tooltipText, 'point.y', point.y!, digits);
      }

      if (point.high != null) {
        tooltipText = _replace(tooltipText, 'point.high', point.high!, digits);
      }

      if (point.low != null) {
        tooltipText = _replace(tooltipText, 'point.low', point.low!, digits);
      }

      if (point.open != null) {
        tooltipText = _replace(tooltipText, 'point.open', point.open!, digits);
      }

      if (point.close != null) {
        tooltipText =
            _replace(tooltipText, 'point.close', point.close!, digits);
      }

      if (outlierIndex != -1) {
        if (point.outliers != null && point.outliers!.isNotEmpty) {
          tooltipText = _replace(tooltipText, 'point.outliers',
              point.outliers![outlierIndex], digits);
        }
      } else {
        if (point.minimum != null) {
          tooltipText =
              _replace(tooltipText, 'point.minimum', point.minimum!, digits);
        }

        if (point.maximum != null) {
          tooltipText =
              _replace(tooltipText, 'point.maximum', point.maximum!, digits);
        }

        if (point.lowerQuartile != null) {
          tooltipText = _replace(
              tooltipText, 'point.lowerQuartile', point.lowerQuartile!, digits);
        }

        if (point.upperQuartile != null) {
          tooltipText = _replace(
              tooltipText, 'point.upperQuartile', point.upperQuartile!, digits);
        }

        if (point.mean != null) {
          tooltipText =
              _replace(tooltipText, 'point.mean', point.mean!, digits);
        }

        if (point.median != null) {
          tooltipText =
              _replace(tooltipText, 'point.median', point.median!, digits);
        }
      }

      if (point.cumulative != null) {
        tooltipText = _replace(
            tooltipText, 'point.cumulative', point.cumulative!, digits);
      }

      if (point.bubbleSize != null) {
        tooltipText =
            _replace(tooltipText, 'point.size', point.bubbleSize!, digits);
      }

      tooltipText = tooltipText.replaceAll('series.name', seriesName);
      text = isLtr ? tooltipText : formatRTLText(tooltipText);
    } else {
      if (point.y != null) {
        text = _formatTrackballLabel(point.y!, digits, text, isLtr);
      }

      if (point.high != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTrackballLabel(point.high!, digits, 'High', isLtr);
      }

      if (point.low != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }

        text += _formatTrackballLabel(point.low!, digits, 'Low', isLtr);
      }

      if (point.open != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTrackballLabel(point.open!, digits, 'Open', isLtr);
      }

      if (point.close != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTrackballLabel(point.close!, digits, 'Close', isLtr);
      }

      if (outlierIndex != -1) {
        if (point.outliers != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(
              point.outliers![outlierIndex], digits, 'Outliers', isLtr);
        }
      } else {
        if (point.minimum != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text +=
              _formatTrackballLabel(point.minimum!, digits, 'Minimum', isLtr);
        }

        if (point.maximum != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text +=
              _formatTrackballLabel(point.maximum!, digits, 'Maximum', isLtr);
        }

        if (point.median != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(point.median!, digits, 'Median', isLtr);
        }

        if (point.mean != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(point.mean!, digits, 'Mean', isLtr);
        }

        if (point.lowerQuartile != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(
              point.lowerQuartile!, digits, 'LowerQuartile', isLtr);
        }

        if (point.upperQuartile != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(
              point.upperQuartile!, digits, 'UpperQuartile', isLtr);
        }
      }
    }

    return text;
  }

  String tooltipHeaderText(CartesianChartPoint<D> point, [int digits = 3]) {
    String text = '';
    if (xAxis is RenderNumericAxis || xAxis is RenderLogarithmicAxis) {
      text = formatNumericValue(point.x! as num, xAxis, digits);
    } else if (xAxis is RenderDateTimeAxis) {
      final RenderDateTimeAxis axis = xAxis! as RenderDateTimeAxis;
      final DateFormat dateFormat =
          axis.dateFormat ?? _dateTimeLabelFormat(xAxis!);
      text = dateFormat.format(point.x! as DateTime);
    } else if (xAxis is RenderDateTimeCategoryAxis) {
      final RenderDateTimeCategoryAxis axis =
          xAxis! as RenderDateTimeCategoryAxis;
      final DateFormat dateFormat =
          axis.dateFormat ?? _dateTimeLabelFormat(xAxis!);
      text = dateFormat.format(point.x! as DateTime);
    } else if (xAxis is RenderCategoryAxis) {
      text = point.x!.toString();
    }

    return text;
  }

  DateFormat _dateTimeLabelFormat(RenderChartAxis axis,
      [int? interval, int? prevInterval]) {
    DateFormat? format;
    final bool notDoubleInterval =
        (axis.interval != null && axis.interval! % 1 == 0) ||
            axis.interval == null;
    DateTimeIntervalType? actualIntervalType;
    num? minimum;
    minimum = axis.visibleRange!.minimum;
    if (axis is RenderDateTimeAxis) {
      actualIntervalType = axis.visibleIntervalType;
    } else if (axis is RenderDateTimeCategoryAxis) {
      actualIntervalType = axis.visibleIntervalType;
    }

    switch (actualIntervalType!) {
      case DateTimeIntervalType.years:
        format = notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();
        break;
      case DateTimeIntervalType.months:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);

        break;
      case DateTimeIntervalType.days:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);
        break;
      case DateTimeIntervalType.hours:
        format = DateFormat.j();
        break;
      case DateTimeIntervalType.minutes:
        format = DateFormat.Hm();
        break;
      case DateTimeIntervalType.seconds:
        format = DateFormat.ms();
        break;
      case DateTimeIntervalType.milliseconds:
        final DateFormat dateFormat = DateFormat('ss.SSS');
        format = dateFormat;
        break;
      case DateTimeIntervalType.auto:
        format ??= DateFormat();
        break;
    }
    return format!;
  }

  DateFormat? _dateTimeFormat(DateTimeIntervalType? actualIntervalType,
      int? interval, int? prevInterval) {
    final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(interval!);
    final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(prevInterval!);
    DateFormat? format;
    final bool isIntervalDecimal = interval % 1 == 0;
    if (actualIntervalType == DateTimeIntervalType.months) {
      format = minimum.year == maximum.year
          ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
          : DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = minimum.month != maximum.month
          ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
          : DateFormat.d();
    }

    return format;
  }

  DateFormat? _firstLabelFormat(DateTimeIntervalType? actualIntervalType) {
    DateFormat? format;

    if (actualIntervalType == DateTimeIntervalType.months) {
      format = DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = DateFormat.MMMd();
    } else if (actualIntervalType == DateTimeIntervalType.minutes) {
      format = DateFormat.Hm();
    }

    return format;
  }

  Offset translateTransform(num x, num y,
      [double translationX = 0, double translationY = 0]) {
    final double posX = pointToPixelX(x, y);
    final double posY = pointToPixelY(x, y);
    return Offset(posX + translationX, posY + translationY);
  }

  ChartMarker markerAt(int pointIndex) {
    if (markerContainer != null) {
      return markerContainer!.markerAt(pointIndex);
    }
    return ChartMarker();
  }

  Shader? markerShader(Rect bounds) {
    if (onCreateShader != null) {
      final ShaderDetails details = ShaderDetails(bounds, 'marker');
      return onCreateShader!(details);
    } else if (gradient != null) {
      return gradient!.createShader(bounds);
    }
    return null;
  }
}

extension IndicatorExtension<T, D> on IndicatorRenderer<T, D> {
  String _replace(
      String tooltipText, String replacingText, num value, int digits) {
    return tooltipText.replaceAll(
        replacingText, formatNumericValue(value, yAxis, digits));
  }

  String _formatTrackballLabel(num value, int digits, String text, bool isLtr) {
    if (text.isEmpty) {
      return formatNumericValue(value, yAxis, digits);
    }
    return isLtr
        ? '$text: ${formatNumericValue(value, yAxis, digits)}'
        : '${formatNumericValue(value, yAxis, digits)} :$text';
  }

  String trackballText(CartesianChartPoint<D> point, String seriesName,
      {int outlierIndex = -1}) {
    if (parent == null ||
        parent!.trackballBehavior == null ||
        xAxis == null ||
        point.x == null) {
      return '';
    }

    String text = '';
    final int digits = parent!.trackballBehavior!.tooltipSettings.decimalPlaces;
    if (parent!.trackballBehavior!.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints) {
      text = '$seriesName ';
    }

    return _behaviorText(
        parent!.trackballBehavior!.tooltipSettings.format,
        text,
        point,
        digits,
        outlierIndex,
        seriesName,
        parent!.textDirection == TextDirection.ltr);
  }

  String _behaviorText(
    String? tooltipFormat,
    String text,
    CartesianChartPoint<D> point,
    int digits,
    int outlierIndex,
    String seriesName,
    bool isLtr,
  ) {
    if (tooltipFormat != null) {
      text = tooltipHeaderText(point, digits);
      String tooltipText = tooltipFormat.replaceAll('point.x', text);

      if (point.y != null) {
        tooltipText = _replace(tooltipText, 'point.y', point.y!, digits);
      }

      if (point.high != null) {
        tooltipText = _replace(tooltipText, 'point.high', point.high!, digits);
      }

      if (point.low != null) {
        tooltipText = _replace(tooltipText, 'point.low', point.low!, digits);
      }

      if (point.open != null) {
        tooltipText = _replace(tooltipText, 'point.open', point.open!, digits);
      }

      if (point.close != null) {
        tooltipText =
            _replace(tooltipText, 'point.close', point.close!, digits);
      }

      if (outlierIndex != -1) {
        if (point.outliers != null && point.outliers!.isNotEmpty) {
          tooltipText = _replace(tooltipText, 'point.outliers',
              point.outliers![outlierIndex], digits);
        }
      } else {
        if (point.minimum != null) {
          tooltipText =
              _replace(tooltipText, 'point.minimum', point.minimum!, digits);
        }

        if (point.maximum != null) {
          tooltipText =
              _replace(tooltipText, 'point.maximum', point.maximum!, digits);
        }

        if (point.lowerQuartile != null) {
          tooltipText = _replace(
              tooltipText, 'point.lowerQuartile', point.lowerQuartile!, digits);
        }

        if (point.upperQuartile != null) {
          tooltipText = _replace(
              tooltipText, 'point.upperQuartile', point.upperQuartile!, digits);
        }

        if (point.mean != null) {
          tooltipText =
              _replace(tooltipText, 'point.mean', point.mean!, digits);
        }

        if (point.median != null) {
          tooltipText =
              _replace(tooltipText, 'point.median', point.median!, digits);
        }
      }

      if (point.cumulative != null) {
        tooltipText = _replace(
            tooltipText, 'point.cumulative', point.cumulative!, digits);
      }

      if (point.bubbleSize != null) {
        tooltipText =
            _replace(tooltipText, 'point.size', point.bubbleSize!, digits);
      }

      tooltipText = tooltipText.replaceAll('series.name', seriesName);
      text = isLtr ? tooltipText : formatRTLText(tooltipText);
    } else {
      if (point.y != null) {
        text = _formatTrackballLabel(point.y!, digits, text, isLtr);
      }

      if (point.high != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTrackballLabel(point.high!, digits, 'High', isLtr);
      }

      if (point.low != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }

        text += _formatTrackballLabel(point.low!, digits, 'Low', isLtr);
      }

      if (point.open != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTrackballLabel(point.open!, digits, 'Open', isLtr);
      }

      if (point.close != null) {
        if (text.isNotEmpty) {
          text += '\n';
        }
        text += _formatTrackballLabel(point.close!, digits, 'Close', isLtr);
      }

      if (outlierIndex != -1) {
        if (point.outliers != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(
              point.outliers![outlierIndex], digits, 'Outliers', isLtr);
        }
      } else {
        if (point.minimum != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text +=
              _formatTrackballLabel(point.minimum!, digits, 'Minimum', isLtr);
        }

        if (point.maximum != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text +=
              _formatTrackballLabel(point.maximum!, digits, 'Maximum', isLtr);
        }

        if (point.median != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(point.median!, digits, 'Median', isLtr);
        }

        if (point.mean != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(point.mean!, digits, 'Mean', isLtr);
        }

        if (point.lowerQuartile != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(
              point.lowerQuartile!, digits, 'LowerQuartile', isLtr);
        }

        if (point.upperQuartile != null) {
          if (text.isNotEmpty) {
            text += '\n';
          }

          text += _formatTrackballLabel(
              point.upperQuartile!, digits, 'UpperQuartile', isLtr);
        }
      }
    }
    return text;
  }

  String tooltipHeaderText(CartesianChartPoint<D> point, [int digits = 3]) {
    String text = '';
    if (xAxis is RenderNumericAxis || xAxis is RenderLogarithmicAxis) {
      text = formatNumericValue(point.x! as num, xAxis, digits);
    } else if (xAxis is RenderDateTimeAxis) {
      final RenderDateTimeAxis axis = xAxis! as RenderDateTimeAxis;
      final DateFormat dateFormat =
          axis.dateFormat ?? _dateTimeLabelFormat(xAxis!);
      text = dateFormat.format(point.x! as DateTime);
    } else if (xAxis is RenderDateTimeCategoryAxis) {
      final RenderDateTimeCategoryAxis axis =
          xAxis! as RenderDateTimeCategoryAxis;
      final DateFormat dateFormat =
          axis.dateFormat ?? _dateTimeLabelFormat(xAxis!);
      text = dateFormat.format(point.x! as DateTime);
    } else if (xAxis is RenderCategoryAxis) {
      text = point.x!.toString();
    }

    return text;
  }

  DateFormat _dateTimeLabelFormat(RenderChartAxis axis,
      [int? interval, int? prevInterval]) {
    DateFormat? format;
    final bool notDoubleInterval =
        (axis.interval != null && axis.interval! % 1 == 0) ||
            axis.interval == null;
    DateTimeIntervalType? actualIntervalType;
    num? minimum;
    minimum = axis.visibleRange!.minimum;
    if (axis is RenderDateTimeAxis) {
      actualIntervalType = axis.visibleIntervalType;
    } else if (axis is RenderDateTimeCategoryAxis) {
      actualIntervalType = axis.visibleIntervalType;
    }

    switch (actualIntervalType!) {
      case DateTimeIntervalType.years:
        format = notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();
        break;
      case DateTimeIntervalType.months:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);

        break;
      case DateTimeIntervalType.days:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);
        break;
      case DateTimeIntervalType.hours:
        format = DateFormat.j();
        break;
      case DateTimeIntervalType.minutes:
        format = DateFormat.Hm();
        break;
      case DateTimeIntervalType.seconds:
        format = DateFormat.ms();
        break;
      case DateTimeIntervalType.milliseconds:
        final DateFormat dateFormat = DateFormat('ss.SSS');
        format = dateFormat;
        break;
      case DateTimeIntervalType.auto:
        format ??= DateFormat();
        break;
    }
    return format!;
  }

  DateFormat? _dateTimeFormat(DateTimeIntervalType? actualIntervalType,
      int? interval, int? prevInterval) {
    final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(interval!);
    final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(prevInterval!);
    DateFormat? format;
    final bool isIntervalDecimal = interval % 1 == 0;
    if (actualIntervalType == DateTimeIntervalType.months) {
      format = minimum.year == maximum.year
          ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
          : DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = minimum.month != maximum.month
          ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
          : DateFormat.d();
    }

    return format;
  }

  DateFormat? _firstLabelFormat(DateTimeIntervalType? actualIntervalType) {
    DateFormat? format;

    if (actualIntervalType == DateTimeIntervalType.months) {
      format = DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = DateFormat.MMMd();
    } else if (actualIntervalType == DateTimeIntervalType.minutes) {
      format = DateFormat.Hm();
    }

    return format;
  }
}

int nextIndexConsideringEmptyPointMode(
    int index, EmptyPointMode mode, List<num> yValues, int dataCount) {
  return mode == EmptyPointMode.drop
      ? _nextValidIndex(index, dataCount, yValues)
      : _nextIndex(index, dataCount);
}

int _nextIndex(int index, int dataCount) {
  return index + 1 < dataCount ? index + 1 : -1;
}

int _nextValidIndex(int index, int dataCount, List<num> yValues) {
  final int lastIndex = dataCount - 1;
  if (index < lastIndex) {
    final num y = yValues[index];
    int nextIndex = index + 1;
    if (y.isNaN) {
      return nextIndex;
    } else {
      while (yValues[nextIndex].isNaN) {
        nextIndex++;
        if (nextIndex > lastIndex) {
          return -1;
        }
      }
      return nextIndex;
    }
  }

  return -1;
}

RRect toRRect(double left, double top, double right, double bottom,
    BorderRadius borderRadius) {
  if (top > bottom) {
    final double temp = top;
    top = bottom;
    bottom = temp;
  }

  if (left > right) {
    final double temp = left;
    left = right;
    right = temp;
  }

  return RRect.fromLTRBAndCorners(
    left,
    top,
    right,
    bottom,
    topLeft: borderRadius.topLeft,
    topRight: borderRadius.topRight,
    bottomLeft: borderRadius.bottomLeft,
    bottomRight: borderRadius.bottomRight,
  );
}

extension OffsetExtension on Offset {
  bool get isNaN => dx.isNaN || dy.isNaN;

  Offset? lerp(Offset b, double t, num visibleMin) {
    final Offset a = this;
    return Offset(_lerpDouble(a.dx, b.dx, t, visibleMin),
        _lerpDouble(a.dy, b.dy, t, visibleMin));
  }
}

double _lerpDouble(num a, double b, double t, num visibleMin) {
  if (a.isNaN && !b.isNaN) {
    a = visibleMin;
  }
  return a * (1.0 - t) + b * t;
}

core.LegendAlignment effectiveLegendAlignment(ChartAlignment? alignment) {
  alignment ??= ChartAlignment.center;
  switch (alignment) {
    case ChartAlignment.near:
      return core.LegendAlignment.near;
    case ChartAlignment.center:
      return core.LegendAlignment.center;
    case ChartAlignment.far:
      return core.LegendAlignment.far;
  }
}

core.LegendOverflowMode effectiveOverflowMode(Legend legend) {
  switch (legend.overflowMode) {
    case LegendItemOverflowMode.wrap:
      return core.LegendOverflowMode.wrapScroll;
    case LegendItemOverflowMode.scroll:
      return core.LegendOverflowMode.scroll;
    case LegendItemOverflowMode.none:
      return core.LegendOverflowMode.none;
  }
}

double percentageToWidthFactor(String? value, core.LegendPosition position) {
  switch (position) {
    case core.LegendPosition.left:
    case core.LegendPosition.right:
      return value == null ? defaultLegendSizeFactor : factorFromValue(value);

    case core.LegendPosition.top:
    case core.LegendPosition.bottom:
      return value == null ? double.nan : factorFromValue(value);
  }
}

double percentageToHeightFactor(String? value, core.LegendPosition position) {
  switch (position) {
    case core.LegendPosition.left:
    case core.LegendPosition.right:
      return value == null ? double.nan : factorFromValue(value);

    case core.LegendPosition.top:
    case core.LegendPosition.bottom:
      return value == null ? defaultLegendSizeFactor : factorFromValue(value);
  }
}

core.LegendScrollbarVisibility effectiveScrollbarVisibility(Legend legend) {
  return legend.shouldAlwaysShowScrollbar
      ? core.LegendScrollbarVisibility.visible
      : core.LegendScrollbarVisibility.auto;
}

core.LegendPosition effectiveLegendPosition(Legend legend) {
  switch (legend.position) {
    case LegendPosition.auto:
      return defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? core.LegendPosition.top
          : core.LegendPosition.right;
    case LegendPosition.bottom:
      return core.LegendPosition.bottom;
    case LegendPosition.left:
      return core.LegendPosition.left;
    case LegendPosition.right:
      return core.LegendPosition.right;
    case LegendPosition.top:
      return core.LegendPosition.top;
  }
}

Axis effectiveLegendOrientation(core.LegendPosition position, Legend legend) {
  switch (legend.orientation) {
    case LegendItemOrientation.horizontal:
      return Axis.horizontal;
    case LegendItemOrientation.vertical:
      return Axis.vertical;
    case LegendItemOrientation.auto:
      return position == core.LegendPosition.top ||
              position == core.LegendPosition.bottom
          ? Axis.horizontal
          : Axis.vertical;
  }
}

Widget? buildLegendTitle(SfChartThemeData? chartThemeData, Legend legend) {
  if (legend.title != null &&
      legend.title!.text != null &&
      legend.title!.text!.isNotEmpty) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(legend.title!.text!,
          style: chartThemeData!.legendTitleTextStyle),
    );
  }
  return null;
}

Widget buildLegendItem(
    BuildContext context, core.LegendItem legendItem, Legend legend) {
  final ChartLegendItem item = legendItem as ChartLegendItem;
  ChartPoint point;
  if (item.series != null) {
    final int length = item.series!.chartPoints.length;
    final int pointIndex = item.pointIndex;
    if (length > 0 && pointIndex > -1 && pointIndex < length) {
      point = item.series!.chartPoints[item.pointIndex];
    } else {
      point = ChartPoint(x: item.text);
    }
  } else {
    point = ChartPoint(x: item.text);
  }

  if (item.series is! CartesianSeriesRenderer &&
      item.series!.segments.isNotEmpty) {
    point.isVisible = item.series!.segmentAt(item.pointIndex).isVisible;
  }

  return legend.legendItemBuilder!(
    item.text,
    item.series?.widget,
    point,
    item.series is CartesianSeriesRenderer ? item.seriesIndex : item.pointIndex,
  );
}

mixin Stacking100SeriesMixin<T, D> {}

bool isValueLinear(int index, num value, List<num> values) {
  final int length = values.length;
  if (length == 0) {
    return true;
  }

  if (index == 0) {
    return length == 1 || value <= values[index + 1];
  }

  if (index == length - 1) {
    return value >= values[index - 1];
  }

  return value >= values[index - 1] && value <= values[index + 1];
}

DateFormat dateTimeAxisLabelFormat(
    RenderDateTimeAxis axis, num current, int previous) {
  return _niceDateFormat(current, previous, axis.visibleRange!.minimum,
      axis.interval, axis.visibleInterval, axis.visibleIntervalType);
}

DateFormat dateTimeCategoryAxisLabelFormat(
    RenderDateTimeCategoryAxis axis, num current, int previous) {
  return _niceDateFormat(current, previous, axis.visibleRange!.minimum,
      axis.interval, axis.visibleInterval, axis.visibleIntervalType);
}

DateFormat _niceDateFormat(num current, int previous, num minimum,
    double? interval, num visibleInterval, DateTimeIntervalType intervalType) {
  final bool notDoubleInterval =
      (interval != null && interval % 1 == 0) || interval == null;
  switch (intervalType) {
    case DateTimeIntervalType.years:
      return notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();

    case DateTimeIntervalType.months:
      return (minimum == current || current == previous)
          ? _firstLabelFormat(intervalType)
          : _normalDateFormat(intervalType, visibleInterval, current, previous);

    case DateTimeIntervalType.days:
      return (minimum == current || current == previous)
          ? _firstLabelFormat(intervalType)
          : _normalDateFormat(intervalType, visibleInterval, current, previous);

    case DateTimeIntervalType.hours:
      return DateFormat.j();

    case DateTimeIntervalType.minutes:
      return DateFormat.Hm();

    case DateTimeIntervalType.seconds:
      return DateFormat.ms();

    case DateTimeIntervalType.milliseconds:
      return DateFormat('ss.SSS');

    case DateTimeIntervalType.auto:
      return DateFormat();
  }
}

DateFormat _firstLabelFormat(DateTimeIntervalType visibleIntervalType) {
  if (visibleIntervalType == DateTimeIntervalType.months) {
    return DateFormat('yyy MMM');
  } else if (visibleIntervalType == DateTimeIntervalType.days) {
    return DateFormat.MMMd();
  } else if (visibleIntervalType == DateTimeIntervalType.minutes) {
    return DateFormat.Hm();
  } else {
    return DateFormat();
  }
}

DateFormat _normalDateFormat(DateTimeIntervalType visibleIntervalType,
    num visibleInterval, num current, int previousLabel) {
  final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(current.toInt());
  final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(previousLabel);
  final bool isIntervalDecimal = visibleInterval % 1 == 0;
  if (visibleIntervalType == DateTimeIntervalType.months) {
    return minimum.year == maximum.year
        ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
        : DateFormat('yyy MMM');
  } else if (visibleIntervalType == DateTimeIntervalType.days) {
    return minimum.month != maximum.month
        ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
        : DateFormat.d();
  } else {
    return DateFormat();
  }
}

String numericAxisLabel(RenderNumericAxis axis, num value, int showDigits) {
  return _labelValue(value, showDigits, axis.numberFormat, axis.labelFormat);
}

String logAxisLabel(RenderLogarithmicAxis axis, num value, int showDigits) {
  return _labelValue(value, showDigits, axis.numberFormat, axis.labelFormat);
}

String _labelValue(num value, int showDigits, NumberFormat? numberFormat,
    String? labelFormat) {
  final List pieces = value.toString().split('.');
  if (pieces.length > 1) {
    value = double.parse(value.toStringAsFixed(showDigits));
    final String decimals = pieces[1];
    final bool isDecimalContainsZero = decimals == '0' ||
        decimals == '00' ||
        decimals == '000' ||
        decimals == '0000' ||
        decimals == '00000' ||
        value % 1 == 0;
    value = isDecimalContainsZero ? value.round() : value;
  }

  String text = value.toString();
  if (numberFormat != null) {
    text = numberFormat.format(value);
  }
  if (labelFormat != null && labelFormat != '') {
    text = labelFormat.replaceAll(RegExp('{value}'), text);
  }
  return text;
}

RRect performLegendToggleAnimation(
  SbsSeriesMixin series,
  RRect segmentRect,
  RRect oldSegmentRect,
  BorderRadius borderRadius,
) {
  final double animationFactor = series.segmentAnimationFactor;
  final bool oldSeriesVisible = series.visibilityBeforeTogglingLegend;

  if (series.parent!.isTransposed) {
    return performTransposedLegendToggleAnimation(series, segmentRect,
        oldSegmentRect, oldSeriesVisible, animationFactor, borderRadius);
  }

  final RenderCartesianChartPlotArea plotArea = series.parent!;
  final CartesianSeriesRenderer firstSeries =
      plotArea.firstChild as CartesianSeriesRenderer;
  final CartesianSeriesRenderer lastSeries =
      plotArea.lastChild as CartesianSeriesRenderer;

  final bool isSingleBarSeries = _isSingleBarSeries(plotArea);
  num right = 0;
  final double height = segmentRect.height;
  double width = segmentRect.width;
  double left = segmentRect.left;
  final double top = segmentRect.top;

  /// Left and right animation handled when toggling the legend.
  if (oldSeriesVisible) {
    final double oldRight = oldSegmentRect.right;
    final double oldLeft = oldSegmentRect.left;
    final double newRight = segmentRect.right;
    final double newLeft = segmentRect.left;

    right = oldRight > newRight
        ? oldRight + (animationFactor * (newRight - oldRight))
        : oldRight - (animationFactor * (oldRight - newRight));
    left = oldLeft > newLeft
        ? oldLeft - (animationFactor * (oldLeft - newLeft))
        : oldLeft + (animationFactor * (newLeft - oldLeft));
    width = right - left;
  } else {
    final bool isInversed = series.xAxis!.isInversed;
    if (series == firstSeries && !isSingleBarSeries) {
      /// Handled the left to right side animation when re-toggling the first series legend.
      if (isInversed) {
        right = segmentRect.right;
        left = right - (segmentRect.width * animationFactor);
        width = right - left;
      } else {
        left = segmentRect.left;
        width = segmentRect.width * animationFactor;
      }
    } else if (series == lastSeries && !isSingleBarSeries) {
      /// Handled the right to left side animation when re-toggling the last series legend.
      if (isInversed) {
        left = segmentRect.left;
        width = segmentRect.width * animationFactor;
      } else {
        right = segmentRect.right;
        left = right - (segmentRect.width * animationFactor);
        width = right - left;
      }
    } else {
      /// Handled width animation when re-toggling middle series legend.
      width = segmentRect.width * animationFactor;
      left = segmentRect.center.dx - width / 2;
    }
  }

  return RRect.fromRectAndCorners(
    Rect.fromLTWH(left, top, width, height),
    topLeft: borderRadius.topLeft,
    topRight: borderRadius.topRight,
    bottomLeft: borderRadius.bottomLeft,
    bottomRight: borderRadius.bottomRight,
  );
}

RRect performTransposedLegendToggleAnimation(
  SbsSeriesMixin series,
  RRect segmentRect,
  RRect oldSegmentRect,
  bool oldSeriesVisible,
  double animationFactor,
  BorderRadius borderRadius,
) {
  final RenderCartesianChartPlotArea plotArea = series.parent!;
  final CartesianSeriesRenderer firstSeries =
      plotArea.firstChild as CartesianSeriesRenderer;
  final CartesianSeriesRenderer lastSeries =
      plotArea.lastChild as CartesianSeriesRenderer;

  final bool isSingleBarSeries = _isSingleBarSeries(plotArea);
  num bottom;
  double height = segmentRect.height;
  double top = segmentRect.top;
  final double width = segmentRect.width;
  final double left = segmentRect.left;

  /// Handled top and bottom animation when toggling the legend.
  if (oldSeriesVisible) {
    final double oldBottom = oldSegmentRect.bottom;
    final double oldTop = oldSegmentRect.top;
    final double newBottom = segmentRect.bottom;
    final double newTop = segmentRect.top;

    bottom = oldBottom > newBottom
        ? oldBottom + (animationFactor * (newBottom - oldBottom))
        : oldBottom - (animationFactor * (oldBottom - newBottom));
    top = oldTop > newTop
        ? oldTop - (animationFactor * (oldTop - newTop))
        : oldTop + (animationFactor * (newTop - oldTop));
    height = bottom - top;
  } else {
    final bool isInversed = series.xAxis!.isInversed;
    if (series == firstSeries && !isSingleBarSeries) {
      /// Handled the bottom to top side animation when re-toggling the first series legend.
      if (isInversed) {
        top = segmentRect.top;
        height = segmentRect.height * animationFactor;
      } else {
        bottom = segmentRect.bottom;
        top = bottom - (segmentRect.height * animationFactor);
        height = bottom - top;
      }
    } else if (series == lastSeries && !isSingleBarSeries) {
      /// Handled the top to bottom side animation when re-toggling the last series legend.
      if (isInversed) {
        bottom = segmentRect.bottom;
        top = bottom - (segmentRect.height * animationFactor);
        height = bottom - top;
      } else {
        top = segmentRect.top;
        height = segmentRect.height * animationFactor;
      }
    } else {
      /// Handled height animation when re-toggling middle series legend.
      height = segmentRect.height * animationFactor;
      top = segmentRect.center.dy - height / 2;
    }
  }

  return RRect.fromRectAndCorners(
    Rect.fromLTWH(left, top, width, height),
    topLeft: borderRadius.topLeft,
    topRight: borderRadius.topRight,
    bottomLeft: borderRadius.bottomLeft,
    bottomRight: borderRadius.bottomRight,
  );
}

bool _isSingleBarSeries(RenderCartesianChartPlotArea plotArea) {
  int count = 0;
  plotArea.visitChildren((child) {
    if (child is SbsSeriesMixin && child.controller.isVisible) {
      count++;
    }
  });
  return count == 1;
}

void animateAllBarSeries(RenderCartesianChartPlotArea plotArea) {
  plotArea.isLegendToggled = true;
  plotArea.visitChildren((child) {
    if (child is CartesianSeriesRenderer) {
      if ((child is ColumnSeriesRenderer || child is BarSeriesRenderer) &&
          child.animationType == AnimationType.none) {
        child.animationType = AnimationType.realtime;
      }
    }
  });
}

int binarySearch(List<num> xValues, double touchValue, int min, int max) {
  int closerIndex = 0;
  double closerDelta = double.maxFinite;
  while (min <= max) {
    final int mid = (min + max) ~/ 2;
    final double xValue = xValues[mid].toDouble();
    final double delta = (touchValue - xValue).abs();
    if (delta < closerDelta) {
      closerDelta = delta;
      closerIndex = mid;
    }

    if (touchValue == xValue) {
      return mid;
    } else if (touchValue < xValue) {
      max = mid - 1;
    } else {
      min = mid + 1;
    }
  }
  return closerIndex;
}

Rect tooltipTouchBounds(Offset center, double width, double height) {
  // The Rect.fromCenter() method divides the width and height by 2.
  // For smooth touch interaction, keep a 10-pixel padding for touch
  // and a 4-pixel padding for mouse on all sides.
  if (isHover) {
    width = width < 8 ? 8 : width;
    height = height < 8 ? 8 : height;
  } else {
    width = width < 20 ? 20 : width;
    height = height < 20 ? 20 : height;
  }

  return Rect.fromCenter(center: center, width: width, height: height);
}
