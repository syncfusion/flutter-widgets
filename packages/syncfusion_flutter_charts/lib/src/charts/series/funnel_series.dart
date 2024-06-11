import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/core_legend.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../common/element_widget.dart';
import '../common/funnel_data_label.dart';
import '../common/legend.dart';
import '../interactions/tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders Funnel series.
///
/// The FunnelSeries is the SfFunnelChart Type series.
/// To render a funnel chart, create an instance of FunnelSeries, and add it to
/// the series property of [SfFunnelChart].
///
/// Provides options to customize the [opacity], [borderWidth], [borderColor]
/// and [pointColorMapper] of the funnel segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=t3Dczqj8-10}
class FunnelSeries<T, D> extends ChartSeries<T, D> {
  /// Creating an argument constructor of [FunnelSeries] class.
  const FunnelSeries({
    super.key,
    this.onCreateRenderer,
    this.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.dataSource,
    super.xValueMapper,
    super.emptyPointSettings,
    super.dataLabelSettings,
    this.yValueMapper,
    super.pointColorMapper,
    ChartValueMapper<T, String>? textFieldMapper,
    super.name,
    this.explodeIndex,
    this.neckWidth = '20%',
    this.neckHeight = '20%',
    this.height = '80%',
    this.width = '80%',
    this.gapRatio = 0,
    this.explodeOffset = '10%',
    this.explode = false,
    this.explodeGesture = ActivationMode.singleTap,
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.legendIconType,
    super.animationDuration,
    super.animationDelay,
    super.opacity,
    super.selectionBehavior,
    super.initialSelectedDataIndexes,
  }) : super(
          dataLabelMapper: textFieldMapper,
        );

  /// Maps the field name, which will be considered as y-values.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///             )
  ///         )
  ///     );
  /// }
  /// class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  /// }
  /// ```
  final ChartValueMapper<T, num>? yValueMapper;

  /// Neck height of funnel.
  ///
  /// Defaults to `20%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///                neckHeight: '10%'
  ///            )
  ///        )
  ///    );
  /// }
  /// ```
  final String neckHeight;

  /// Neck width of funnel.
  ///
  /// Defaults to `20%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///                neckWidth: '10%'
  ///            )
  ///        )
  ///    );
  /// }
  /// ```
  final String neckWidth;

  /// Height of the series.
  ///
  /// Defaults to `80%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               height:'50%'
  ///            )
  ///        )
  ///    );
  /// }
  /// ```
  final String height;

  /// Width of the series.
  ///
  /// Defaults to `80%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               width:'50%'
  ///            )
  ///        )
  ///    );
  /// }
  /// ```
  final String width;

  /// Gap ratio between the segments of funnel.
  ///
  /// Ranges from 0 to 1.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               gapRatio: 0.3
  ///            )
  ///        )
  ///    );
  /// }
  /// ```
  final double gapRatio;

  /// Offset of exploded slice.
  ///
  /// The value ranges from 0% to 100%.
  ///
  /// Defaults to `10%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               explodeOffset: '5%')
  ///        )
  ///    );
  /// }
  /// ```
  final String explodeOffset;

  /// Enables or disables the explode of slices on tap.
  ///
  /// Default to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               explode: true)
  ///        )
  ///    );
  /// }
  /// ```
  final bool explode;

  /// Gesture for activating the explode.
  ///
  /// Explode can be activated in `ActivationMode.none`,
  /// `ActivationMode.singleTap`, `ActivationMode.doubleTap`,
  /// and `ActivationMode.longPress`.
  ///
  /// Defaults to `ActivationMode.singleTap`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               explode: true,
  ///               explodeGesture: ActivationMode.singleTap
  ///             )
  ///        )
  ///    );
  /// }
  /// ```
  final ActivationMode explodeGesture;

  final Color borderColor;

  /// Index of the slice to explode it at the initial rendering.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<ChartData, String>(
  ///               explodeIndex: 1,
  ///               explode: true
  ///             )
  ///        )
  ///   );
  /// }
  /// ```
  final num? explodeIndex;

  /// Used to create the renderer for custom series.
  ///
  /// This is applicable only when the custom series is defined in the sample
  /// and for built-in series types, it is not applicable.
  ///
  /// Renderer created in this will hold the series state and
  /// this should be created for each series. [onCreateRenderer] callback
  /// function should return the renderer class and should not return null.
  ///
  /// Series state will be created only once per series and will not be created
  /// again when we update the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<SalesData, num>(
  ///                  onCreateRenderer: (ChartSeries<SalesData, num> series) {
  ///                     return CustomFunnelSeriesRenderer(
  ///                       series as FunnelSeries<SalesData, num>);
  ///                  },
  ///            ),
  ///        )
  ///    );
  /// }
  ///  class CustomFunnelSeriesRenderer extends FunnelSeriesRenderer {
  ///     CustomFunnelSeriesRenderer(this.series);
  ///     final FunnelSeries<SalesData, num> series;
  ///       // custom implementation here...
  ///  }
  /// ```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  /// Triggers when the series renderer is created.
  ///
  /// Using this callback, able to get the [ChartSeriesController] instance,
  /// which is used to access the public methods in the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    FunnelSeriesController _funnelSeriesController;
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<SalesData, num>(
  ///                   onRendererCreated: (FunnelSeriesController controller) {
  ///                       _funnelSeriesController = controller;
  ///                    },
  ///              ),
  ///        )
  ///    );
  /// }
  /// ```
  final FunnelSeriesRendererCreatedCallback<T, D>? onRendererCreated;

  @override
  List<ChartDataPointType> get positions =>
      <ChartDataPointType>[ChartDataPointType.y];

  @override
  Widget? childForSlot(SeriesSlot slot) {
    switch (slot) {
      case SeriesSlot.dataLabel:
        return dataLabelSettings.isVisible
            ? FunnelDataLabelContainer<T, D>(
                series: this,
                dataSource: dataSource!,
                mapper: dataLabelMapper,
                builder: dataLabelSettings.builder,
                settings: dataLabelSettings)
            : null;

      case SeriesSlot.marker:
        return null;

      case SeriesSlot.trendline:
        return null;
    }
  }

  @override
  FunnelSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final FunnelSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as FunnelSeriesRenderer<T, D>;
    renderer
      ..yValueMapper = yValueMapper
      ..neckHeight = neckHeight
      ..neckWidth = neckWidth
      ..height = height
      ..width = width
      ..gapRatio = gapRatio
      ..explodeOffset = explodeOffset
      ..explode = explode
      ..explodeGesture = explodeGesture
      ..dataLabelMapper = dataLabelMapper
      ..explodeIndex = explodeIndex
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..borderColor = borderColor
      ..onCreateRenderer = onCreateRenderer
      ..onRendererCreated = onRendererCreated
      ..widget = this;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, FunnelSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..yValueMapper = yValueMapper
      ..neckHeight = neckHeight
      ..neckWidth = neckWidth
      ..height = height
      ..width = width
      ..gapRatio = gapRatio
      ..explodeOffset = explodeOffset
      ..explode = explode
      ..explodeGesture = explodeGesture
      ..dataLabelMapper = dataLabelMapper
      ..explodeIndex = explodeIndex
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..borderColor = borderColor
      ..onCreateRenderer = onCreateRenderer
      ..onRendererCreated = onRendererCreated
      ..widget = this;
  }

  /// Create the funnel series renderer.
  @override
  FunnelSeriesRenderer<T, D> createRenderer() {
    FunnelSeriesRenderer<T, D>? renderer;
    if (onCreateRenderer != null) {
      renderer = onCreateRenderer!(this) as FunnelSeriesRenderer<T, D>?;
      assert(
          renderer != null,
          'This onCreateRenderer callback function should return value as '
          'extends from ChartSeriesRenderer class and should not be return '
          'value as null');
    }
    return renderer ?? FunnelSeriesRenderer<T, D>();
  }
}

/// Creates series renderer for Funnel series.
class FunnelSeriesRenderer<T, D> extends ChartSeriesRenderer<T, D>
    with RealTimeUpdateMixin<T, D> {
  final List<num> _chaoticYValues = <num>[];
  final List<num> yValues = <num>[];

  FunnelSeriesRendererCreatedCallback<T, D>? onRendererCreated;

  FunnelSeriesController<T, D> get controller => _controller;
  late final FunnelSeriesController<T, D> _controller =
      FunnelSeriesController<T, D>(this);

  ChartValueMapper<T, num>? get yValueMapper => _yValueMapper;
  ChartValueMapper<T, num>? _yValueMapper;
  set yValueMapper(ChartValueMapper<T, num>? value) {
    if (_yValueMapper != value) {
      _yValueMapper = value;
    }
  }

  String get neckHeight => _neckHeight;
  String _neckHeight = '20%';
  set neckHeight(String value) {
    if (_neckHeight != value) {
      _neckHeight = value;
      markNeedsLayout();
    }
  }

  String get neckWidth => _neckWidth;
  String _neckWidth = '20%';
  set neckWidth(String value) {
    if (_neckWidth != value) {
      _neckWidth = value;
      markNeedsLayout();
    }
  }

  String get height => _height;
  String _height = '80%';
  set height(String value) {
    if (_height != value) {
      _height = value;
      markNeedsLayout();
    }
  }

  String get width => _width;
  String _width = '80%';
  set width(String value) {
    if (_width != value) {
      _width = value;
      markNeedsLayout();
    }
  }

  double get gapRatio => _gapRatio;
  double _gapRatio = 0;
  set gapRatio(double value) {
    if (_gapRatio != value) {
      _gapRatio = value;
      assert(_gapRatio >= 0 && _gapRatio <= 1,
          'The gap ratio for the funnel chart must be between 0 and 1.');
      _gapRatio = clampDouble(value, 0, 1);
      markNeedsLayout();
    }
  }

  String get explodeOffset => _explodeOffset;
  String _explodeOffset = '10%';
  set explodeOffset(String value) {
    if (_explodeOffset != value) {
      _explodeOffset = value;
      transformValues();
      markNeedsPaint();
    }
  }

  bool get explode => _explode;
  bool _explode = false;
  set explode(bool value) {
    if (_explode != value) {
      _explode = value;
      _updateExploding();
    }
  }

  ActivationMode get explodeGesture => _explodeGesture;
  ActivationMode _explodeGesture = ActivationMode.singleTap;
  set explodeGesture(ActivationMode value) {
    if (_explodeGesture != value) {
      _explodeGesture = value;
      transformValues();
      markNeedsPaint();
    }
  }

  num? get explodeIndex => _explodeIndex;
  num? _explodeIndex;
  set explodeIndex(num? value) {
    if (_explodeIndex != value) {
      _explodeIndex = value;
      _updateExploding();
    }
  }

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  ChartSeriesRendererFactory<T, D>? get onCreateRenderer => _onCreateRenderer;
  ChartSeriesRendererFactory<T, D>? _onCreateRenderer;
  set onCreateRenderer(ChartSeriesRendererFactory<T, D>? value) {
    if (_onCreateRenderer != value) {
      _onCreateRenderer = value;
    }
  }

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (dataLabelContainer != null) dataLabelContainer!,
    ];
  }

  /// Stores pointer down time to determine whether a long press interaction is handled at pointer up
  DateTime? _pointerHoldingTime;
  double _sumOfY = 0.0;
  Rect _plotAreaBounds = Rect.zero;
  Size _triangleSize = Size.zero;
  Size _neckSize = Size.zero;
  double _coefficient = 0.0;
  double _spacing = 0.0;
  double _y = 0.0;

  Offset dataLabelPosition(ChartElementParentData current, Size size) {
    final int segmentsLastIndex = segments.length - 1;
    final List<Offset> points =
        segments[segmentsLastIndex - current.dataPointIndex].points;
    final Rect region = _calculateSegmentRect(
        segments[segmentsLastIndex - current.dataPointIndex].points,
        segmentsLastIndex - current.dataPointIndex);
    final List<Offset> connectorPoints = segments[0].points;
    final double connectorLength = _calculateConnectorLength(
      connectorPoints,
      dataLabelSettings,
    );

    final Offset insideLabelOffset =
        dataLabelSettings.labelPosition == ChartDataLabelPosition.inside
            ? Offset(region.left + region.width / 2 - size.width / 2,
                region.top + region.height / 2 - size.height / 2)
            : Offset((points[0].dx + points[1].dx) / 2 - size.width / 2,
                (points[0].dy + points[2].dy) / 2 - size.height / 2);
    final double connectorLengthWithXValue =
        insideLabelOffset.dx + connectorLength + size.width / 2;
    final Offset outsideLabelOffset = Offset(
        (connectorLengthWithXValue +
                    size.width +
                    dataLabelSettings.margin.left +
                    dataLabelSettings.margin.right >
                paintBounds.right)
            ? connectorLengthWithXValue -
                (percentToValue(explodeOffset, paintBounds.width)!)
            : connectorLengthWithXValue,
        insideLabelOffset.dy);
    final Offset finalOffset =
        dataLabelSettings.labelPosition == ChartDataLabelPosition.inside
            ? insideLabelOffset
            : outsideLabelOffset;

    return finalOffset;
  }

  bool _isFunnelLabelIntersectOutside(RRect rect, RRect? previousRect) {
    bool isIntersect = false;
    const num padding = 2;
    if (rect == previousRect) {
      return false;
    }
    if (previousRect != null && (rect.bottom + padding) > previousRect.top) {
      isIntersect = true;
    }
    return isIntersect;
  }

  bool _isFunnelLabelIntersectInside(int index, List<Rect> list) {
    final Rect currentRect = list[index];
    Rect nextRect;
    bool isCollide = false;
    if (index != list.length - 1) {
      nextRect = list[index + 1];
      isCollide = currentRect.overlaps(nextRect);
    }
    return isCollide;
  }

  Path _calculateConnectorPath(int index, Offset offset, Size size) {
    final int segmentsLastIndex = segments.length - 1;
    final List<Offset> points = segments[segmentsLastIndex - index].points;
    final double startPoint = (points[1].dx + points[2].dx) / 2;
    final double endPoint = offset.dx;
    final double y = offset.dy + size.height / 2;
    return Path()
      ..moveTo(startPoint, y)
      ..lineTo(endPoint, y);
  }

  RRect _calculateRect(Offset offset, int padding, EdgeInsets margin, Size size,
      ChartDataLabelPosition labelPosition) {
    if (labelPosition == ChartDataLabelPosition.inside) {
      return RRect.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx - padding,
            offset.dy - padding,
            size.width + (2 * padding),
            size.height + (2 * padding),
          ),
          Radius.circular(dataLabelSettings.borderRadius));
    }
    return RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offset.dx,
          offset.dy - margin.top,
          size.width + margin.top + margin.left,
          size.height + margin.bottom + margin.right,
        ),
        Radius.circular(dataLabelSettings.borderRadius));
  }

  Rect _calculateSegmentRect(List<Offset> points, int index) {
    final List<Offset> points = segments[index].points;
    final int bottom =
        points.length > 4 ? points.length - 2 : points.length - 1;
    final double x = (points[0].dx + points[bottom].dx) / 2;
    final double right = (points[1].dx + points[bottom - 1].dx) / 2;
    final Rect region = Rect.fromLTWH(
        x, points[0].dy, right - x, points[bottom].dy - points[0].dy);
    return region;
  }

  double _calculateConnectorLength(
      List<Offset> points, DataLabelSettings settings) {
    final Path segmentPath = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..close();
    final Rect segmentBounds = segmentPath.getBounds();
    final double connectorLength = percentToValue(
            settings.connectorLineSettings.length ?? '0%',
            _plotAreaBounds.width / 2)! +
        (segmentBounds.width / 2);
    return connectorLength;
  }

  bool _findingCollision(Rect rect, List<RRect> regions, [Rect? pathRect]) {
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
      final RRect regionRect = regions[i];
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

  String _getTrimmedText(String? text, Rect rect, Offset labelLocation,
      Rect region, TextStyle style) {
    const int labelPadding = 2;
    const String ellipse = '...';
    String label = text!;
    bool isCollide = _findingCollision(rect, <RRect>[], region);
    while (isCollide) {
      if (label == ellipse) {
        label = '';
        break;
      }
      if (label.length > ellipse.length) {
        label = _addEllipse(label, label.length, ellipse);
      } else {
        label = '';
        break;
      }
      final Size trimTextSize = measureText(label, style);
      final Rect trimRect = Rect.fromLTWH(
          labelLocation.dx - labelPadding,
          labelLocation.dy - labelPadding,
          trimTextSize.width + (2 * labelPadding),
          trimTextSize.height + (2 * labelPadding));
      isCollide = _isLabelsColliding(trimRect, region);
    }
    return label == ellipse ? '' : label;
  }

  String _addEllipse(String text, int maxLength, String ellipse,
      {bool isRtl = false}) {
    if (isRtl) {
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

  bool _isLabelsColliding(Rect rect, Rect? pathRect) {
    bool isCollide = false;
    if (pathRect != null &&
        (pathRect.left > rect.left &&
            pathRect.width > rect.width &&
            pathRect.top < rect.top &&
            pathRect.height > rect.height)) {
      isCollide = false;
    } else if (pathRect != null) {
      isCollide = true;
    }
    return isCollide;
  }

  void drawDataLabelWithBackground(
    int index,
    Canvas canvas,
    String dataLabel,
    Size size,
    Offset offset,
    int angle,
    TextStyle style,
    Paint fillPaint,
    Paint strokePaint,
    Path connectorPath,
    List<RRect> previousRect,
  ) {
    final SfChartThemeData chartThemeData = parent!.chartThemeData!;
    final ThemeData themeData = parent!.themeData!;
    final int segmentsLastIndex = segments.length - 1;
    final int dataPointIndex = segmentsLastIndex - index;
    final ChartSegment segment = segments[dataPointIndex];
    Color surfaceColor = dataLabelSurfaceColor(fillPaint.color, dataPointIndex,
        dataLabelSettings.labelPosition, chartThemeData, themeData, segment);
    TextStyle effectiveTextStyle = saturatedTextStyle(surfaceColor, style);
    final EdgeInsets margin = dataLabelSettings.margin;
    final Radius radius = Radius.circular(dataLabelSettings.borderRadius);
    Offset finalOffset = offset;
    final List<Offset> points = segments[segmentsLastIndex - index].points;
    bool isOverlapRight = false;
    final double startPoint = (points[1].dx + points[2].dx) / 2;
    ChartDataLabelPosition labelPosition = dataLabelSettings.labelPosition;
    const int labelPadding = 2;
    const int connectorPadding = 15;
    final List<Rect> labels = <Rect>[];
    final List<Offset> connectorPoints = segments[0].points;
    final double connectorLength = _calculateConnectorLength(
      connectorPoints,
      dataLabelSettings,
    );
    final Paint connectorPaint = Paint()
      ..color = dataLabelSettings.connectorLineSettings.color ??
          segments[segmentsLastIndex - index].fillPaint.color
      ..strokeWidth = dataLabelSettings.connectorLineSettings.width
      ..style = PaintingStyle.stroke;

    if ((yValues[index] == 0 && !dataLabelSettings.showZeroValue) ||
        yValues[index].isNaN ||
        !segments[segmentsLastIndex - index].isVisible) {
      return;
    }

    for (int i = segmentsLastIndex; i >= 0; i--) {
      final Rect region = _calculateSegmentRect(segmentAt(i).points, i);
      labels.add(Rect.fromLTWH(
          region.left + region.width / 2 - (size.width / 2) - labelPadding,
          region.top + region.height / 2 - (size.height / 2) - labelPadding,
          size.width + (2 * labelPadding),
          size.height + (2 * labelPadding)));
    }

    if (!offset.dx.isNaN && !offset.dy.isNaN) {
      if (dataLabel.isNotEmpty) {
        if (fillPaint.color != Colors.transparent ||
            (strokePaint.color != const Color.fromARGB(0, 25, 5, 5) &&
                strokePaint.strokeWidth > 0)) {
          RRect labelRect =
              _calculateRect(offset, labelPadding, margin, size, labelPosition);
          final Rect region = _calculateSegmentRect(
              segments[segmentsLastIndex - index].points,
              segmentsLastIndex - index);
          final bool isDataLabelCollide = (_findingCollision(
                  labels[index], previousRect, region)) &&
              dataLabelSettings.labelPosition != ChartDataLabelPosition.outside;
          if (isDataLabelCollide) {
            switch (dataLabelSettings.overflowMode) {
              case OverflowMode.trim:
                dataLabel = _getTrimmedText(dataLabel, labels[index],
                    finalOffset, region, effectiveTextStyle);
                final Size trimSize =
                    measureText(dataLabel, effectiveTextStyle);
                finalOffset = Offset(
                    finalOffset.dx + size.width / 2 - trimSize.width / 2,
                    finalOffset.dy + size.height / 2 - trimSize.height / 2);
                labelRect = RRect.fromRectAndRadius(
                    Rect.fromLTWH(
                        finalOffset.dx - labelPadding,
                        finalOffset.dy - labelPadding,
                        trimSize.width + (2 * labelPadding),
                        trimSize.height + (2 * labelPadding)),
                    radius);
                break;
              case OverflowMode.hide:
                dataLabel = '';
                break;
              case OverflowMode.shift:
                break;
              // ignore: no_default_cases
              default:
                break;
            }
          }
          final bool isIntersect = _isFunnelLabelIntersectInside(index, labels);
          if (isIntersect &&
              dataLabelSettings.labelPosition ==
                  ChartDataLabelPosition.inside &&
              dataLabelSettings.color == null &&
              !dataLabelSettings.useSeriesColor) {
            if (style.color == Colors.transparent) {
              surfaceColor = dataLabelSurfaceColor(
                  fillPaint.color,
                  dataPointIndex,
                  ChartDataLabelPosition.outside,
                  chartThemeData,
                  themeData,
                  segment);
              effectiveTextStyle = saturatedTextStyle(surfaceColor, style);
            }
          }
          if ((isIntersect &&
                  labelPosition == ChartDataLabelPosition.inside &&
                  dataLabelSettings.labelIntersectAction ==
                      LabelIntersectAction.hide) ||
              dataLabel == '' ||
              (index == 0 &&
                  (dataLabelSettings.overflowMode == OverflowMode.hide ||
                      dataLabelSettings.overflowMode == OverflowMode.trim))) {
            return;
          } else if (isIntersect &&
              labelPosition == ChartDataLabelPosition.inside &&
              dataLabelSettings.labelIntersectAction ==
                  LabelIntersectAction.none) {
          } else if ((isDataLabelCollide &&
                  dataLabelSettings.overflowMode == OverflowMode.shift) ||
              isIntersect ||
              (dataLabelSettings.labelPosition ==
                  ChartDataLabelPosition.outside)) {
            labelPosition = ChartDataLabelPosition.outside;
            offset =
                dataLabelSettings.labelPosition == ChartDataLabelPosition.inside
                    ? Offset((points[0].dx + points[1].dx) / 2 - size.width / 2,
                        (points[0].dy + points[2].dy) / 2 - size.height / 2)
                    : offset;
            finalOffset = dataLabelSettings.labelPosition ==
                    ChartDataLabelPosition.outside
                ? offset
                : offset + Offset(connectorLength + size.width / 2, 0);
            labelRect = _calculateRect(
                finalOffset, labelPadding, margin, size, labelPosition);
            connectorPath = _calculateConnectorPath(index, finalOffset, size);
            if (_plotAreaBounds.right < labelRect.right) {
              isOverlapRight = true;
              labelRect = RRect.fromRectAndRadius(
                  Rect.fromLTRB(
                      _plotAreaBounds.right - labelRect.width - labelPadding,
                      labelRect.top,
                      _plotAreaBounds.right - labelPadding,
                      labelRect.bottom),
                  radius);
            }
            final RRect previous = previousRect.isEmpty
                ? labelRect
                : previousRect[previousRect.length - 1];
            final bool isIntersectOutside =
                _isFunnelLabelIntersectOutside(labelRect, previous);
            if (!isIntersectOutside && isOverlapRight) {
              finalOffset = Offset(labelRect.left,
                  (labelRect.top + labelRect.height / 2) - size.height / 2);
              connectorPath = _calculateConnectorPath(index, finalOffset, size);
            }
            if (dataLabelSettings.labelIntersectAction ==
                    LabelIntersectAction.hide &&
                isIntersectOutside) {
              return;
            } else if (isIntersectOutside &&
                dataLabelSettings.labelIntersectAction ==
                    LabelIntersectAction.shift) {
              labelRect = RRect.fromRectAndRadius(
                  Rect.fromLTWH(
                      labelRect.left,
                      previous.top - labelPadding - labelRect.height,
                      labelRect.width,
                      labelRect.height),
                  radius);

              connectorPath = Path()
                ..moveTo(startPoint, finalOffset.dy + size.height / 2)
                ..lineTo(labelRect.left - connectorPadding,
                    finalOffset.dy + size.height / 2)
                ..lineTo(labelRect.left, labelRect.top + labelRect.height / 2);
            }
            finalOffset = Offset(labelRect.left + margin.left,
                (labelRect.top + labelRect.height / 2) - size.height / 2);
          }
          previousRect.add(labelRect);
          if (labelRect.top < dataLabelSettings.margin.top) {
            return;
          }
          if (labelPosition == ChartDataLabelPosition.outside) {
            canvas.drawPath(connectorPath, connectorPaint);
          }
          canvas.save();
          canvas.translate(labelRect.center.dx, labelRect.center.dy);
          canvas.rotate((angle * pi) / 180);
          canvas.translate(-labelRect.center.dx, -labelRect.center.dy);
          if (strokePaint.color != Colors.transparent &&
              strokePaint.strokeWidth > 0) {
            canvas.drawRRect(labelRect, strokePaint);
          }
          if (fillPaint.color != Colors.transparent) {
            canvas.drawRRect(labelRect, fillPaint);
          }
          canvas.restore();
        }
      }
    }
    drawDataLabel(canvas, dataLabel, finalOffset, effectiveTextStyle, angle);
  }

  void drawDataLabel(
      Canvas canvas, String text, Offset point, TextStyle style, int angle,
      [bool? isRtl]) {
    final int maxLines = getMaxLinesContent(text);
    final TextSpan span = TextSpan(text: text, style: style);
    final TextPainter tp = TextPainter(
        text: span,
        textDirection: (isRtl ?? false) ? TextDirection.rtl : TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: maxLines);
    tp.layout();
    canvas.save();
    canvas.translate(point.dx + tp.width / 2, point.dy + tp.height / 2);
    Offset labelOffset = Offset.zero;
    canvas.rotate(degreeToRadian(angle));
    labelOffset = Offset(-tp.width / 2, -tp.height / 2);
    tp.paint(canvas, labelOffset);
    canvas.restore();
  }

  @override
  void attach(PipelineOwner owner) {
    onRendererCreated?.call(_controller);
    super.attach(owner);
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    yValues.clear();
    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    markNeedsLegendUpdate();
    populateChartPoints();
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (yLists == null) {
      yLists = <List<num>>[yValues];
      positions = <ChartDataPointType>[ChartDataPointType.y];
    } else {
      yLists.add(yValues);
      positions!.add(ChartDataPointType.y);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }
    super.updateDataPoints(removedIndexes, addedIndexes, replacedIndexes,
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
  }

  @override
  void performLayout() {
    // Need to recalculate the triangle and neck size values based on plot area,
    // and its required to update the segment values in layout.
    // So assigned true here to update the segment values.
    canUpdateOrCreateSegments = true;
    _calculateFunnelValues();
    super.performLayout();

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[yValues]
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  void _calculateFunnelValues() {
    _sumOfY = 0;
    final int segmentsCount = segments.length;
    for (int i = 0; i < dataCount; i++) {
      bool isVisible = true;
      if (i < segmentsCount) {
        isVisible = segmentAt(i).isVisible;
      }
      final num yValue = isVisible ? yValues[i] : 0;
      if (!yValue.isNaN) {
        _sumOfY += yValue.abs();
      }
    }

    _plotAreaBounds = Rect.fromLTWH(0, 0, size.width, size.height);
    _triangleSize = Size(percentToValue(width, _plotAreaBounds.width)!,
        percentToValue(height, _plotAreaBounds.height)!);
    _neckSize = Size(percentToValue(neckWidth, _plotAreaBounds.width)!,
        percentToValue(neckHeight, _plotAreaBounds.height)!);
    _coefficient = 1 / (_sumOfY * (1 + gapRatio / (1 - gapRatio)));
    _spacing = gapRatio / (dataCount - emptyPointIndexes.length - 1);
    _y = 0;
  }

  @override
  @nonVirtual
  Color effectiveColor(int segmentIndex) {
    Color? pointColor;
    if (pointColorMapper != null) {
      pointColor = pointColors[segmentIndex];
    }
    return pointColor ?? palette[segmentIndex % palette.length];
  }

  @override
  void setData(int index, ChartSegment segment) {
    final int i = dataCount - 1 - index;
    super.setData(i, segment);

    num yValue = yValues[i].abs();
    // Handled the empty point here.
    yValue = yValue.isNaN || !segment.isVisible ? 0 : yValue;
    final num segmentHeight = _coefficient * yValue;
    segment as FunnelSegment<T, D>
      ..series = this
      ..y = _y
      .._height = segmentHeight
      .._triangleSize = _triangleSize
      .._neckSize = _neckSize
      .._plotAreaBounds = _plotAreaBounds
      ..isExploded = explode && i == explodeIndex
      ..isEmpty = (emptyPointSettings.mode != EmptyPointMode.drop &&
              emptyPointSettings.mode != EmptyPointMode.gap) &&
          isEmpty(i);

    _y += segmentHeight + _spacing;
  }

  @override
  FunnelSegment<T, D> createSegment() => FunnelSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.funnelSeries;

  /// Changes the series color, border color and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    updateSegmentColor(segment, borderColor, borderWidth);
  }

  @override
  List<LegendItem>? buildLegendItems(int index) {
    final List<LegendItem> legendItems = <LegendItem>[];
    final int segmentsCount = segments.length;
    for (int i = 0; i < dataCount; i++) {
      final int legendIndex = dataCount - 1 - i;
      final ChartLegendItem legendItem = ChartLegendItem(
        text: xRawValues[legendIndex].toString(),
        iconType: toLegendShapeMarkerType(legendIconType, this),
        iconColor: effectiveColor(legendIndex),
        iconBorderWidth: legendIconBorderWidth(),
        series: this,
        seriesIndex: index,
        pointIndex: legendIndex,
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

  @override
  void handleLegendItemTapped(LegendItem item, bool isToggled) {
    super.handleLegendItemTapped(item, isToggled);

    final ChartLegendItem legendItem = item as ChartLegendItem;
    final int toggledIndex = legendItem.pointIndex;
    if (toggledIndex < segments.length) {
      segmentAt(toggledIndex).isVisible = !isToggled;
    }

    canUpdateOrCreateSegments = true;
    legendItem.onToggled?.call();
    markNeedsLayout();
  }

  // TODO(praveen): When we update data points, load time animation occurs.
  // Need to handle this.
  @override
  void onPaint(PaintingContext context, Offset offset) {
    context.canvas.save();
    final Rect clip =
        clipRect(paintBounds, animationFactor, isTransposed: true);
    context.canvas.clipRect(clip);
    paintSegments(context, offset);
    context.canvas.restore();
    paintDataLabels(context, offset);
  }

  void paintDataLabels(PaintingContext context, Offset offset) {
    if (dataLabelContainer != null) {
      context.paintChild(dataLabelContainer!, offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final bool isHit = super.hitTest(result, position: position);
    return explode || isHit;
  }

  @override
  void handlePointerDown(PointerDownEvent details) {
    if (explode && explodeGesture == ActivationMode.singleTap) {
      _pointerHoldingTime = DateTime.now();
    }
    super.handlePointerDown(details);
  }

  @override
  void handlePointerUp(PointerUpEvent details) {
    if (explode &&
        explodeGesture == ActivationMode.singleTap &&
        _pointerHoldingTime != null &&
        DateTime.now().difference(_pointerHoldingTime!).inMilliseconds <
            kLongPressTimeout.inMilliseconds) {
      _handleExploding(details.localPosition);
    }
    super.handlePointerUp(details);
  }

  @override
  void handleDoubleTap(Offset position) {
    final Offset localPosition = globalToLocal(position);
    if (explode && explodeGesture == ActivationMode.doubleTap) {
      _handleExploding(localPosition);
    }
    super.handleDoubleTap(position);
  }

  @override
  void handleLongPressStart(LongPressStartDetails details) {
    if (explode && explodeGesture == ActivationMode.longPress) {
      _handleExploding(details.localPosition);
    }
    super.handleLongPressStart(details);
  }

  void _handleExploding(Offset position) {
    for (final ChartSegment segment in segments) {
      final FunnelSegment<T, D> funnelSegment = segment as FunnelSegment<T, D>;
      if (segment.contains(position)) {
        funnelSegment.isExploded = !funnelSegment.isExploded;
        if (funnelSegment.isExploded) {
          _explodeIndex = segment.currentSegmentIndex;
        } else {
          _explodeIndex = -1;
        }
      } else {
        funnelSegment.isExploded = false;
      }
    }

    forceTransformValues = true;
    markNeedsLayout();
  }

  void _updateExploding() {
    for (final ChartSegment segment in segments) {
      final FunnelSegment<T, D> funnelSegment = segment as FunnelSegment<T, D>;
      if (!explode) {
        funnelSegment.isExploded = false;
      } else {
        if (segment.currentSegmentIndex == explodeIndex) {
          funnelSegment.isExploded = true;
        } else {
          funnelSegment.isExploded = false;
        }
      }
    }

    forceTransformValues = true;
    markNeedsLayout();
  }

  @override
  ChartSegment segmentAt(int segmentPointIndex) {
    return segments.firstWhere((ChartSegment segment) =>
        segment.currentSegmentIndex == segmentPointIndex);
  }

  @override
  int viewportIndex(int index, [List<int>? visibleIndexes]) {
    return index;
  }

  @override
  void dispose() {
    _chaoticYValues.clear();
    yValues.clear();
    super.dispose();
  }
}

class FunnelSegment<T, D> extends ChartSegment {
  late FunnelSeriesRenderer<T, D> series;
  late double y;
  late num _height;
  late Rect _plotAreaBounds;
  late Size _triangleSize;
  late Size _neckSize;
  bool isExploded = false;
  Path path = Path();

  @override
  void transformValues() {
    points.clear();

    double? leftEnd, neckJoiner;
    double rightEnd = 0;
    final double neckSizeWidth = _neckSize.width;
    final double neckSizeHeight = _neckSize.height;
    final double triangleWidth = _triangleSize.width;
    final double triangleHeight = _triangleSize.height;

    final double funnelHeight = triangleHeight - neckSizeHeight;
    final double left = (isExploded
            ? percentToValue(series.explodeOffset, _plotAreaBounds.width)!
            : 0) +
        (_plotAreaBounds.width - triangleWidth) / 2;
    final double topSpace = (_plotAreaBounds.height - triangleHeight) / 2;

    double topY = y * triangleHeight;
    double bottomY = topY + _height * triangleHeight;

    double funnelWidth = neckSizeWidth +
        (triangleWidth - neckSizeWidth) *
            ((funnelHeight - topY) / funnelHeight);
    double topX1 = (triangleWidth / 2) - funnelWidth / 2;
    double topX2 = topX1 + funnelWidth;

    funnelWidth = (bottomY > funnelHeight || triangleHeight == neckSizeHeight)
        ? neckSizeWidth
        : neckSizeWidth +
            (triangleWidth - neckSizeWidth) *
                ((funnelHeight - bottomY) / funnelHeight);
    double bottomX1 = triangleWidth / 2 - funnelWidth / 2;
    double bottomX2 = bottomX1 + funnelWidth;

    if (topY >= funnelHeight) {
      topX1 = bottomX1 = leftEnd = triangleWidth / 2 - neckSizeWidth / 2;
      topX2 = bottomX2 = rightEnd = triangleWidth / 2 + neckSizeWidth / 2;
    } else if (bottomY > funnelHeight) {
      leftEnd = bottomX1 = triangleWidth / 2 - funnelWidth / 2;
      rightEnd = bottomX2 = leftEnd + funnelWidth;
      neckJoiner = funnelHeight;
    }

    topY += topSpace;
    bottomY += topSpace;
    neckJoiner = (neckJoiner != null) ? (neckJoiner + topSpace) : null;

    points
      ..add(Offset(left + topX1, topY))
      ..add(Offset(left + topX2, topY));

    if (neckJoiner != null) {
      points
        ..add(Offset(left + rightEnd, neckJoiner))
        ..add(Offset(left + bottomX2, bottomY))
        ..add(Offset(left + bottomX1, bottomY))
        ..add(Offset(left + ((leftEnd != null) ? leftEnd : 0), neckJoiner));
    } else {
      points
        ..add(Offset(left + bottomX2, bottomY))
        ..add(Offset(left + bottomX1, bottomY));
    }

    path
      ..reset()
      ..moveTo(left + topX1, topY)
      ..lineTo(left + topX2, topY);

    if (neckJoiner != null) {
      path
        ..lineTo(left + rightEnd, neckJoiner)
        ..lineTo(left + bottomX2, bottomY)
        ..lineTo(left + bottomX1, bottomY)
        ..lineTo(left + ((leftEnd != null) ? leftEnd : 0), neckJoiner)
        ..close();
    } else {
      path
        ..lineTo(left + bottomX2, bottomY)
        ..lineTo(left + bottomX1, bottomY)
        ..close();
    }
  }

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => fillPaint;

  /// Get the stroke color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of the segment.
  @override
  void calculateSegmentPoints() {}

  @override
  bool contains(Offset position) {
    return path.contains(position);
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    final ChartPoint<D> point = ChartPoint<D>(
        x: series.xRawValues[currentSegmentIndex],
        y: series.yValues[currentSegmentIndex]);
    final Offset location = path.getBounds().center;
    final TooltipPosition? tooltipPosition =
        series.parent?.tooltipBehavior?.tooltipPosition;
    final Offset preferredPos = tooltipPosition == TooltipPosition.pointer
        ? series.localToGlobal(position ?? location)
        : series.localToGlobal(location);
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

  /// Draw segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    Paint paint = getFillPaint();
    if (paint.color != Colors.transparent) {
      canvas.drawPath(path, paint);
    }

    paint = getStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  void dispose() {
    path.reset();
    super.dispose();
  }
}

/// We can redraw the series with updating or creating new points by using this
/// controller.If we need to access the redrawing methods in this before
/// we must get the ChartSeriesController onRendererCreated event.
class FunnelSeriesController<T, D> {
  /// Creating an argument constructor of FunnelSeriesController class.
  FunnelSeriesController(this.seriesRenderer);

  /// Used to access the series properties.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<SalesData, num>(
  ///                    onRendererCreated:
  ///                      (FunnelSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                       // prints series yAxisName
  ///                      print(_chartSeriesController.seriesRenderer.
  ///                        seriesRendererDetails.series.yAxisName);
  ///                    },
  ///                ),
  ///        )
  ///   );
  ///}
  ///```
  final FunnelSeriesRenderer<T, D> seriesRenderer;

  /// Used to process only the newly added, updated and removed data points in
  /// a series, instead of processing all the data points.
  ///
  /// To re-render the chart with modified data points, setState() will be
  /// called. This will render the process and render the chart from scratch.
  /// Thus, the app’s performance will be degraded on continuous update.
  /// To overcome this problem, [updateDataSource] method can be called by
  /// passing updated data points indexes. Chart will process only that point
  /// and skip various steps like bounds calculation, old data points
  /// processing, etc. Thus, this will improve the app’s performance.
  ///
  /// The following are the arguments of this method.
  /// * addedDataIndexes – `List<int>` type – Indexes of newly added data points
  /// in the existing series.
  /// * removedDataIndexes – `List<int>` type – Indexes of removed data points
  /// in the existing series.
  /// * updatedDataIndexes – `List<int>` type – Indexes of updated data points
  /// in the existing series.
  /// * addedDataIndex – `int` type – Index of newly added data point
  /// in the existing series.
  /// * removedDataIndex – `int` type – Index of removed data point
  /// in the existing series.
  /// * updatedDataIndex – `int` type – Index of updated data point
  /// in the existing series.
  ///
  /// Returns `void`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    FunnelSeriesController _funnelSeriesController;
  ///    return Column(
  ///      children: <Widget>[
  ///      Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<SalesData, num>(
  ///                   dataSource: chartData,
  ///                    onRendererCreated:
  ///                      (FunnelSeriesController controller) {
  ///                       _funnelSeriesController = controller;
  ///                    },
  ///                ),
  ///        )
  ///   ),
  ///   Container(
  ///      child: RaisedButton(
  ///           onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           _funnelSeriesController.updateDataSource(
  ///               addedDataIndexes: <int>[chartData.length -1],
  ///               removedDataIndexes: <int>[0],
  ///           );
  ///      })
  ///   )]
  ///  );
  /// }
  ///```
  void updateDataSource({
    List<int>? addedDataIndexes,
    List<int>? removedDataIndexes,
    List<int>? updatedDataIndexes,
    int addedDataIndex = -1,
    int removedDataIndex = -1,
    int updatedDataIndex = -1,
  }) {
    final RealTimeUpdateMixin<T, D> renderer = seriesRenderer;

    List<int>? effectiveRemovedIndexes;
    List<int>? effectiveAddedIndexes;
    List<int>? effectiveReplacedIndexes;

    if (removedDataIndexes != null) {
      effectiveRemovedIndexes = List<int>.from(removedDataIndexes);
    }

    if (addedDataIndexes != null) {
      effectiveAddedIndexes = List<int>.from(addedDataIndexes);
    }

    if (updatedDataIndexes != null) {
      effectiveReplacedIndexes = List<int>.from(updatedDataIndexes);
    }

    if (removedDataIndex != -1) {
      effectiveRemovedIndexes ??= <int>[];
      effectiveRemovedIndexes.add(removedDataIndex);
    }

    if (addedDataIndex != -1) {
      effectiveAddedIndexes ??= <int>[];
      effectiveAddedIndexes.add(addedDataIndex);
    }

    if (updatedDataIndex != -1) {
      effectiveReplacedIndexes ??= <int>[];
      effectiveReplacedIndexes.add(updatedDataIndex);
    }

    renderer.updateDataPoints(
      effectiveRemovedIndexes,
      effectiveAddedIndexes,
      effectiveReplacedIndexes,
    );
  }

  /// Converts logical pixel value to the data point value.
  ///
  /// The [pixelToPoint] method takes logical pixel value as input and returns
  /// a chart data point.
  ///
  ///```dart
  /// late FunnelSeriesController seriesController;
  /// SfFunnelChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     PointInfo<double> chartPoint =
  ///       seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///   },
  ///     series: FunnelSeries<ChartSampleData, String>(
  ///         dataSource: funnelData,
  ///         onRendererCreated:
  ///           (FunnelSeriesController funnelSeriesController) {
  ///           seriesController = FunnelSeriesController;
  ///         }
  ///     )
  /// );
  /// ```
  PointInfo pixelToPoint(Offset position) {
    int pointIndex = -1;
    final List<ChartSegment> segments = seriesRenderer.segments;
    for (int i = 0; i < segments.length; i++) {
      final FunnelSegment<T, D> segment = segments[i] as FunnelSegment<T, D>;
      if (segment.contains(position)) {
        pointIndex = i;
      }
    }
    final dynamic x = seriesRenderer.xValues[pointIndex];
    final num y = seriesRenderer.yValues[pointIndex];
    return PointInfo(x, y);
  }
}
