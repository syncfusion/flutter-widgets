import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/circular_data_label.dart';
import '../common/core_legend.dart';
import '../common/core_tooltip.dart';
import '../common/legend.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/renderer_helper.dart';
import 'chart_series.dart';

/// Renders the radial bar series.
///
/// The radial bar chart is used for showing the comparisons among the
/// categories using the circular shapes. To render a radial bar chart, create
/// an instance of RadialBarSeries, and add to the series collection property
/// of [SfCircularChart].
///
/// Provides options to customize the [maximumValue], [trackColor],
/// [trackBorderColor], [trackBorderWidth], [trackOpacity]
/// and [useSeriesColor] of the radial segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=VJxPp7-2nGk}
class RadialBarSeries<T, D> extends CircularSeries<T, D> {
  /// Creating an argument constructor of RadialBarSeries class.
  ///
  const RadialBarSeries({
    super.key,
    super.onCreateRenderer,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.pointColorMapper,
    super.pointShaderMapper,
    super.pointRadiusMapper,
    super.dataLabelMapper,
    super.sortFieldValueMapper,
    this.trackColor = const Color.fromRGBO(234, 236, 239, 1.0),
    this.trackBorderWidth = 0.0,
    this.trackOpacity = 1,
    this.useSeriesColor = false,
    this.trackBorderColor = Colors.transparent,
    this.maximumValue,
    super.dataLabelSettings,
    super.radius = '80%',
    super.innerRadius = '50%',
    super.gap = '1%',
    super.opacity,
    Color strokeColor = Colors.transparent,
    double strokeWidth = 2.0,
    super.enableTooltip = true,
    super.name,
    super.animationDuration,
    super.animationDelay,
    super.selectionBehavior,
    super.sortingOrder,
    super.legendIconType,
    super.cornerStyle = CornerStyle.bothFlat,
    super.initialSelectedDataIndexes,
  }) : super(
          borderColor: strokeColor,
          borderWidth: strokeWidth,
        );

  /// Color of the track.
  ///
  /// Defaults to `const Color.fromRGBO(234, 236, 239, 1.0)`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackColor: Colors.red,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final Color trackColor;

  /// Specifies the maximum value of the radial bar.
  ///
  /// By default, the sum of the data points values will be considered
  /// as maximum value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  maximumValue: 100,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final double? maximumValue;

  /// Border color of the track.
  ///
  /// Defaults to `Colors.Transparent`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final Color trackBorderColor;

  /// Border width of the track.
  ///
  /// Defaults to `0.0`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderWidth: 2,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final double trackBorderWidth;

  /// Opacity of the track.
  ///
  /// Defaults to `1`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackOpacity: 0.2,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final double trackOpacity;

  /// Uses the point color for filling the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///            ],
  ///        )
  ///   );
  /// }
  /// ```
  final bool useSeriesColor;

  @override
  List<ChartDataPointType> get positions =>
      <ChartDataPointType>[ChartDataPointType.y];

  /// Create the Radial bar series renderer.
  @override
  RadialBarSeriesRenderer<T, D> createRenderer() {
    RadialBarSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as RadialBarSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return RadialBarSeriesRenderer<T, D>();
  }

  @override
  RadialBarSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final RadialBarSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as RadialBarSeriesRenderer<T, D>;
    renderer
      ..trackColor = trackColor
      ..maximumValue = maximumValue
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackOpacity = trackOpacity
      ..useSeriesColor = useSeriesColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RadialBarSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..trackColor = trackColor
      ..maximumValue = maximumValue
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackOpacity = trackOpacity
      ..useSeriesColor = useSeriesColor;
  }
}

/// Creates a series renderer for radial bar series.
class RadialBarSeriesRenderer<T, D> extends CircularSeriesRenderer<T, D> {
  /// Calling the default constructor of [RadialBarSeriesRenderer] class.
  RadialBarSeriesRenderer();

  Color get trackColor => _trackColor;
  Color _trackColor = const Color.fromRGBO(234, 236, 239, 1.0);
  set trackColor(Color value) {
    if (_trackColor != value) {
      _trackColor = value;
      markNeedsPaint();
    }
  }

  double? get maximumValue => _maximumValue;
  double? _maximumValue;
  set maximumValue(double? value) {
    if (_maximumValue != value) {
      _maximumValue = value;
      markNeedsLayout();
    }
  }

  Color get trackBorderColor => _trackBorderColor;
  Color _trackBorderColor = Colors.transparent;
  set trackBorderColor(Color value) {
    if (_trackBorderColor != value) {
      _trackBorderColor = value;
      markNeedsPaint();
    }
  }

  double get trackBorderWidth => _trackBorderWidth;
  double _trackBorderWidth = 0.0;
  set trackBorderWidth(double value) {
    if (_trackBorderWidth != value) {
      _trackBorderWidth = value;
      markNeedsPaint();
    }
  }

  double get trackOpacity => _trackOpacity;
  double _trackOpacity = 1;
  set trackOpacity(double value) {
    if (_trackOpacity != value) {
      _trackOpacity = value;
      markNeedsPaint();
    }
  }

  bool get useSeriesColor => _useSeriesColor;
  bool _useSeriesColor = false;
  set useSeriesColor(bool value) {
    if (_useSeriesColor != value) {
      _useSeriesColor = value;
      markNeedsPaint();
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    final num yValue = segment.isVisible ? circularYValues[index] : 0;
    double degree = yValue / (maximumValue ?? (sumOfY != 0 ? sumOfY : 1));
    degree = degree * fullAngle;
    final double pointEndAngle = pointStartAngle + degree;
    final double innerRadius = currentInnerRadius = segment.isVisible
        ? (currentInnerRadius +
            ((index == firstVisibleIndex) ? 0 : ringSize) -
            (trackBorderWidth / 2) / dataCount)
        : currentInnerRadius;
    final double outerRadius = ringSize < segmentGap!
        ? 0
        : innerRadius +
            ringSize -
            segmentGap! -
            (trackBorderWidth / 2) / dataCount;

    segment as RadialBarSegment<T, D>
      ..series = this
      .._degree = degree
      .._startAngle = pointStartAngle
      ..endAngle = pointEndAngle
      .._center = center
      ..innerRadius = innerRadius
      ..outerRadius = outerRadius;
  }

  @override
  RadialBarSegment<T, D> createSegment() => RadialBarSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.radialBarSeries;

  @override
  void customizeSegment(ChartSegment segment) {
    if (segment is RadialBarSegment<T, D>) {
      updateSegmentColor(segment, borderColor, borderWidth);

      if (trackColor != Colors.transparent) {
        if (useSeriesColor) {
          segment.trackFillPaint.color =
              segment.fillPaint.color.withOpacity(trackOpacity);
        } else {
          segment.trackFillPaint.color = trackColor.withOpacity(trackOpacity);
        }
      } else {
        if (useSeriesColor) {
          segment.trackFillPaint.color = segment.fillPaint.color;
        } else {
          segment.trackFillPaint.color = trackColor;
        }
      }

      segment.trackStrokePaint
        ..color = trackBorderColor
        ..strokeWidth = trackBorderWidth;

      updateSegmentGradient(segment);
    }
  }

  @override
  List<LegendItem>? buildLegendItems(int index) {
    final num sumOfY = circularYValues
        .reduce((num value, num element) => value + element.abs());
    const double pointStartAngle = -90;
    final List<LegendItem> legendItems = <LegendItem>[];
    final int segmentsCount = segments.length;
    for (int i = 0; i < dataCount; i++) {
      double degree = circularYValues[i] / (maximumValue ?? sumOfY);
      degree = (degree > 1 ? 1 : degree) * fullAngle;
      final double pointEndAngle = pointStartAngle + degree;

      final ChartLegendItem legendItem = ChartLegendItem(
        text: circularXValues[i].toString(),
        iconType: toLegendShapeMarkerType(legendIconType, this),
        iconColor: effectiveColor(i),
        shader: _legendIconShaders(i),
        series: this,
        seriesIndex: index,
        pointIndex: i,
        startAngle: pointStartAngle,
        endAngle: pointEndAngle,
        degree: degree,
        iconBorderColor: trackColor,
        iconBorderWidth: legendIconBorderWidth(),
        imageProvider: legendIconType == LegendIconType.image
            ? parent?.legend?.image
            : null,
        isToggled: i < segmentsCount && !segmentAt(i).isVisible,
        onTap: handleLegendItemTapped,
        onRender: _handleLegendItemCreated,
      );
      legendItems.add(legendItem);
    }
    return legendItems;
  }

  void _handleLegendItemCreated(ItemRendererDetails details) {
    if (parent != null && parent!.onLegendItemRender != null) {
      final ChartLegendItem item = details.item as ChartLegendItem;
      final LegendIconType iconType = toLegendIconType(details.iconType);
      final LegendRenderArgs args =
          LegendRenderArgs(item.seriesIndex, item.pointIndex)
            ..text = details.text
            ..legendIconType = iconType
            ..color = details.color;
      parent!.onLegendItemRender!(args);
      if (args.legendIconType != iconType) {
        details.iconType = toLegendShapeMarkerType(
            args.legendIconType ?? LegendIconType.seriesType, this);
      }

      details
        ..text = args.text ?? ''
        ..color = args.color ?? Colors.transparent;
    }
  }

  Shader? _legendIconShaders(int pointIndex) {
    if (parent != null && parent!.legend != null) {
      final Rect legendIconBounds = Rect.fromLTWH(
          0.0, 0.0, parent!.legend!.iconWidth, parent!.legend!.iconHeight);
      if (pointShaderMapper != null) {
        return pointShaderMapper!(dataSource![pointIndex], pointIndex,
            palette[pointIndex % palette.length], legendIconBounds);
      } else if (onCreateShader != null) {
        final ChartShaderDetails details =
            ChartShaderDetails(legendIconBounds, legendIconBounds, 'legend');
        return onCreateShader?.call(details);
      }
    }
    return null;
  }

  @override
  Offset dataLabelPosition(CircularDataLabelBoxParentData current, Size size) {
    const int labelPadding = 2;
    final num angle = dataLabelSettings.angle;

    final RadialBarSegment<T, D> segment =
        segments[current.dataPointIndex] as RadialBarSegment<T, D>;
    current.point!
      ..degree = segment._degree
      ..isVisible = segment.isVisible
      ..startAngle = segment._startAngle
      ..endAngle = segment._endAngle
      ..midAngle = (segment._startAngle + segment._endAngle) / 2
      ..innerRadius = segment._innerRadius
      ..outerRadius = segment._outerRadius
      ..center = center
      ..fill = palette[current.dataPointIndex % palette.length];
    final CircularChartPoint point = current.point!;

    Offset labelLocation = calculateOffset(point.startAngle!,
        (point.innerRadius! + point.outerRadius!) / 2, point.center!);
    labelLocation = Offset(
        (labelLocation.dx - size.width - 5) + (angle == 0 ? 0 : size.width / 2),
        (labelLocation.dy - size.height / 2) +
            (angle == 0 ? 0 : size.height / 2));
    if (point.isVisible && (point.y == 0 && !dataLabelSettings.showZeroValue)) {
      point.isVisible = false;
      return labelLocation;
    }
    if (size.width > 0 && size.height > 0) {
      point.labelRect = Rect.fromLTWH(
          labelLocation.dx - labelPadding,
          labelLocation.dy - labelPadding,
          size.width + (2 * labelPadding),
          size.height + (2 * labelPadding));
    } else {
      point.labelRect = Rect.zero;
    }
    return labelLocation;
  }

  @override
  void drawDataLabelWithBackground(
      CircularChartDataLabelPositioned dataLabelPositioned,
      int index,
      Canvas canvas,
      String dataLabel,
      Offset offset,
      int angle,
      TextStyle style,
      Paint fillPaint,
      Paint strokePaint) {
    final TextStyle effectiveTextStyle = parent!.themeData!.textTheme.bodySmall!
        .copyWith(color: Colors.black)
        .merge(parent!.chartThemeData!.dataLabelTextStyle)
        .merge(dataLabelSettings.textStyle);

    final CircularChartPoint point = dataLabelPositioned.point!;
    if (!point.isVisible || !segments[index].isVisible) {
      return;
    }

    final Rect labelRect = point.labelRect;
    canvas.save();
    canvas.translate(labelRect.center.dx, labelRect.center.dy);
    canvas.rotate((angle * pi) / 180);
    canvas.translate(-labelRect.center.dx, -labelRect.center.dy);
    if (dataLabelSettings.borderWidth > 0 &&
        strokePaint.color != Colors.transparent) {
      _drawLabelRect(
          strokePaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabelSettings.borderRadius,
          canvas);
    }

    if (fillPaint.color != Colors.transparent) {
      _drawLabelRect(
          fillPaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabelSettings.borderRadius,
          canvas);
    }
    canvas.restore();

    drawDataLabel(
        canvas, dataLabel, offset, effectiveTextStyle, dataLabelSettings.angle);
  }

  void _drawLabelRect(
          Paint paint, Rect labelRect, double borderRadius, Canvas canvas) =>
      canvas.drawRRect(
          RRect.fromRectAndRadius(labelRect, Radius.circular(borderRadius)),
          paint);
}

class RadialBarSegment<T, D> extends ChartSegment {
  late RadialBarSeriesRenderer<T, D> series;
  late double _degree;
  late double _startAngle;
  late Offset _center;
  Path trackPath = Path();
  Path yValuePath = Path();
  Path shadowPath = Path();
  Path overFilledPath = Path();
  Paint? _shadowPaint;
  Paint? _overFilledPaint;
  double _priorEndAngle = double.nan;
  double _priorInnerRadius = double.nan;
  double _priorOuterRadius = double.nan;

  double get endAngle => _endAngle;
  double _endAngle = double.nan;
  set endAngle(double value) {
    _priorEndAngle = _endAngle;
    _endAngle = value;
  }

  double get innerRadius => _innerRadius;
  double _innerRadius = double.nan;
  set innerRadius(double value) {
    _priorInnerRadius = _innerRadius;
    _innerRadius = value;
  }

  double get outerRadius => _outerRadius;
  double _outerRadius = double.nan;
  set outerRadius(double value) {
    _priorOuterRadius = _outerRadius;
    _outerRadius = value;
  }

  /// Fill paint of the segment track.
  final Paint trackFillPaint = Paint()..isAntiAlias = true;

  /// Stroke paint of the segment track.
  final Paint trackStrokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke;

  @override
  void transformValues() {
    overFilledPath.reset();
    shadowPath.reset();

    double degree = _degree * animationFactor;
    double startAngle = _startAngle;
    double endAngle = _endAngle;
    double innerRadius = _innerRadius;
    double outerRadius = _outerRadius;

    if (!_priorInnerRadius.isNaN && !_priorOuterRadius.isNaN) {
      if (isVisible) {
        innerRadius =
            lerpDouble(_priorInnerRadius, _innerRadius, animationFactor)!;
        outerRadius =
            lerpDouble(_priorOuterRadius, _outerRadius, animationFactor)!;
      } else {
        num sumOfY = series.circularYValues
            .reduce((num value, num element) => value + element.abs());
        sumOfY = sumOfY - series.circularYValues[currentSegmentIndex];
        degree = series.circularYValues[currentSegmentIndex] /
            (series.maximumValue ?? sumOfY);
        degree = degree * fullAngle;
        endAngle = _priorEndAngle;
        innerRadius = _priorInnerRadius +
            ((_priorOuterRadius + _priorInnerRadius) / 2 - _priorInnerRadius) *
                animationFactor;
        outerRadius = _priorOuterRadius -
            (_priorOuterRadius - (_priorOuterRadius + _priorInnerRadius) / 2) *
                animationFactor;
        _innerRadius = innerRadius;
        _outerRadius = outerRadius;
      }
    } else {
      endAngle = startAngle + degree;
    }

    trackPath = calculateArcPath(
        innerRadius, outerRadius, _center, 0, fullAngle, fullAngle,
        isAnimate: true);

    if (_outerRadius > 0 && degree > 0) {
      final num angleDeviation =
          findAngleDeviation(innerRadius, outerRadius, 360);
      final CornerStyle cornerStyle = series.cornerStyle;
      if (cornerStyle == CornerStyle.bothCurve ||
          cornerStyle == CornerStyle.startCurve) {
        startAngle += angleDeviation;
      }

      if (cornerStyle == CornerStyle.bothCurve ||
          cornerStyle == CornerStyle.endCurve) {
        endAngle -= angleDeviation;
      }

      if (degree > 360) {
        yValuePath = calculateRoundedCornerArcPath(
            cornerStyle, innerRadius, outerRadius, _center, 0, fullAngle);
        yValuePath.arcTo(
            Rect.fromCircle(center: _center, radius: outerRadius),
            degreesToRadians(_startAngle),
            degreesToRadians(_endAngle - _startAngle),
            true);
        yValuePath.arcTo(
            Rect.fromCircle(center: _center, radius: innerRadius),
            degreesToRadians(_endAngle),
            degreesToRadians(_startAngle) - degreesToRadians(_endAngle),
            false);
      } else {
        yValuePath = calculateRoundedCornerArcPath(cornerStyle, innerRadius,
            outerRadius, _center, startAngle, endAngle);
      }

      if (degree > 360 && endAngle >= startAngle + 180) {
        _calculateShadowPath(endAngle);
      }
    }
  }

  void _calculateShadowPath(double endAngle) {
    if (_degree > 360) {
      final double actualRadius = (_innerRadius - _outerRadius).abs() / 2;
      final Offset midPoint =
          calculateOffset(endAngle, (_innerRadius + _outerRadius) / 2, _center);
      if (actualRadius > 0) {
        double shadowWidth = actualRadius * 0.2;
        const double sigmaRadius = 3 * 0.57735 + 0.5;
        shadowWidth = shadowWidth < 3 ? 3 : (shadowWidth > 5 ? 5 : shadowWidth);
        _shadowPaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = shadowWidth
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, sigmaRadius);
        _overFilledPaint = Paint()..isAntiAlias = true;
        double newEndAngle = endAngle;
        if (series.cornerStyle == CornerStyle.endCurve ||
            series.cornerStyle == CornerStyle.bothCurve) {
          newEndAngle =
              (newEndAngle > 360 ? newEndAngle : (newEndAngle - 360)) + 11.5;
          shadowPath
            ..reset()
            ..addArc(
                Rect.fromCircle(
                    center: midPoint,
                    radius: actualRadius - (actualRadius * 0.05)),
                degreesToRadians(newEndAngle + 22.5),
                degreesToRadians(118.125));
          overFilledPath = Path()
            ..addArc(Rect.fromCircle(center: midPoint, radius: actualRadius),
                degreesToRadians(newEndAngle - 20), degreesToRadians(225));
        } else if (series.cornerStyle == CornerStyle.bothFlat ||
            series.cornerStyle == CornerStyle.startCurve) {
          _overFilledPaint!
            ..style = PaintingStyle.stroke
            ..strokeWidth = series.borderWidth;

          final Offset shadowStartPoint = calculateOffset(
              newEndAngle, _outerRadius - (_outerRadius * 0.025), _center);
          final Offset shadowEndPoint = calculateOffset(
              newEndAngle, _innerRadius + (_innerRadius * 0.025), _center);

          final Offset overFilledStartPoint =
              calculateOffset(newEndAngle - 2, _outerRadius, _center);
          final Offset overFilledEndPoint =
              calculateOffset(newEndAngle - 2, _innerRadius, _center);

          shadowPath
            ..reset()
            ..moveTo(shadowStartPoint.dx, shadowStartPoint.dy)
            ..lineTo(shadowEndPoint.dx, shadowEndPoint.dy);

          overFilledPath
            ..reset()
            ..moveTo(overFilledStartPoint.dx, overFilledStartPoint.dy)
            ..lineTo(overFilledEndPoint.dx, overFilledEndPoint.dy);
        }
      }
    }
  }

  @override
  Paint getFillPaint() => fillPaint;

  @override
  Paint getStrokePaint() => strokePaint;

  /// Gets the color of the track.
  Paint getTrackerFillPaint() => trackFillPaint;

  /// Gets the border color of the track.
  Paint getTrackerStrokePaint() => trackStrokePaint;

  @override
  void calculateSegmentPoints() {}

  @override
  bool contains(Offset position) {
    return yValuePath.contains(position);
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    final ChartPoint<D> point = ChartPoint<D>(
        x: series.circularXValues[currentSegmentIndex],
        y: series.circularYValues[currentSegmentIndex]);
    final Offset preferredPos = series.localToGlobal(calculateOffset(
        (_startAngle + _endAngle) / 2,
        (_innerRadius + _outerRadius) / 2,
        _center));
    return ChartTooltipInfo<T, D>(
      primaryPosition: preferredPos,
      secondaryPosition: preferredPos,
      text: series.tooltipText(point),
      header: '',
      data: series.dataSource![currentSegmentIndex],
      point: point,
      series: series.widget,
      renderer: series,
      seriesIndex: series.index,
      segmentIndex: currentSegmentIndex,
      pointIndex: currentSegmentIndex,
    );
  }

  @override
  void onPaint(Canvas canvas) {
    Paint paint = getTrackerFillPaint();
    if (paint.color != Colors.transparent) {
      canvas.drawPath(trackPath, paint);
    }

    paint = getTrackerStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      canvas.drawPath(trackPath, paint);
    }

    paint = getFillPaint();
    if (paint.color != Colors.transparent && innerRadius != outerRadius) {
      canvas.drawPath(yValuePath, paint);
    }

    paint = getStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      canvas.drawPath(yValuePath, paint);
    }

    if (_shadowPaint != null &&
        _overFilledPaint != null &&
        _degree > 360 &&
        _endAngle >= _startAngle + 180) {
      canvas.drawPath(shadowPath, _shadowPaint!);
      _overFilledPaint!.color = getFillPaint().color;
      canvas.drawPath(overFilledPath, _overFilledPaint!);
    }
  }

  @override
  void dispose() {
    trackPath.reset();
    yValuePath.reset();
    shadowPath.reset();
    overFilledPath.reset();
    super.dispose();
  }
}
