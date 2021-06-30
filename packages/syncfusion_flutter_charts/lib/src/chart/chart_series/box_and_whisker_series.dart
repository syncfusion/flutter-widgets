part of charts;

/// This class holds the properties of the Box and Whisker series.
///
/// To render a Box and Whisker chart, create an instance of [BoxAndWhiskerSeries], and add it to the `series` collection property of [SfCartesianChart].
/// The Box and Whisker chart represents the hollow rectangle with the lower quartile, upper quartile, maximum and minimum value in the given data.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
///
@immutable
class BoxAndWhiskerSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BoxAndWhiskerSeries class.
  BoxAndWhiskerSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, dynamic> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      this.spacing = 0,
      MarkerSettings? markerSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      bool? enableTooltip,
      double? animationDuration,
      Color? borderColor,
      double? borderWidth,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      List<double>? dashArray,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<Trendline>? trendlines,
      this.boxPlotMode = BoxPlotMode.normal,
      this.showMean = true})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            dashArray: dashArray,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor ?? Colors.black,
            borderWidth: borderWidth ?? 1,
            gradient: gradient,
            borderGradient: borderGradient,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            trendlines: trendlines);

  ///To change the box plot rendering mode.
  ///
  ///The box plot series rendering mode can be changed by
  ///using [BoxPlotMode] property. The below values are applicable for this:
  ///
  ///* `normal` - The quartile values are calculated by splitting the list and
  /// by getting the median values.
  ///* `exclusive` - The quartile values are calculated by using the formula
  /// (N+1) * P (N count, P percentile), and their index value starts
  /// from 1 in the list.
  /// * `inclusive` - The quartile values are calculated by using the formula
  /// (N−1) * P (N count, P percentile), and their index value starts
  /// from 0 in the list.
  ///
  ///Also refer [BoxPlotMode].
  ///
  ///Defaults to `BoxPlotMode.normal`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///                BoxAndWhiskerSeries<SalesData, num>(
  ///                  boxPlotMode: BoxPlotMode.normal
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BoxPlotMode boxPlotMode;

  ///Indication for mean value in box plot.
  ///
  ///If [showMean] property value is set to true, a cross symbol will be
  ///displayed at the mean value, for each data point in box plot. Else,
  ///it will not be displayed.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///                BoxAndWhiskerSeries<SalesData, num>(
  ///                  showMean: true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool showMean;

  ///Spacing between the box plots.
  ///
  ///The value ranges from 0 to 1, where 1 represents 100% and 0 represents 0%
  ///of the available space.
  ///
  ///Spacing affects the width of the box plots. For example, setting 20%
  ///spacing and 100% width renders the box plots with 80% of total width.
  ///
  ///Also refer [CartesianSeries.width].
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///                BoxAndWhiskerSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double spacing;

  /// Create the Box and Whisker series renderer.
  BoxAndWhiskerSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    BoxAndWhiskerSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as BoxAndWhiskerSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BoxAndWhiskerSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BoxAndWhiskerSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.width == width &&
        other.markerSettings == markerSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.gradient == gradient &&
        other.borderGradient == borderGradient &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.boxPlotMode == boxPlotMode &&
        other.showMean == showMean &&
        other.spacing == spacing &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      key,
      onCreateRenderer,
      dataSource,
      xValueMapper,
      yValueMapper,
      sortFieldValueMapper,
      pointColorMapper,
      dataLabelMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      width,
      markerSettings,
      dataLabelSettings,
      trendlines,
      isVisible,
      enableTooltip,
      dashArray,
      animationDuration,
      borderColor,
      borderWidth,
      gradient,
      borderGradient,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      boxPlotMode,
      showMean,
      spacing,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

class _BoxPlotQuartileValues {
  _BoxPlotQuartileValues(
      {this.minimum,
      this.maximum,
      //ignore: unused_element, avoid_unused_constructor_parameters
      List<num>? outliers,
      this.upperQuartile,
      this.lowerQuartile,
      this.average,
      this.median,
      this.mean});
  num? minimum;
  num? maximum;
  List<num>? outliers = <num>[];
  double? upperQuartile;
  double? lowerQuartile;
  num? average;
  num? median;
  num? mean;
}

/// Creates series renderer for Box and Whisker series
class BoxAndWhiskerSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BoxAndWhiskerSeriesRenderer class.
  BoxAndWhiskerSeriesRenderer();

  late num _rectPosition;

  late num _rectCount;

  late BoxAndWhiskerSegment _segment;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  late _BoxPlotQuartileValues _boxPlotQuartileValues;

  /// To find the minimum, maximum, quartile and median value
  /// of a box plot series.
  void _findBoxPlotValues(List<num?> yValues,
      CartesianChartPoint<dynamic> point, BoxPlotMode mode) {
    final int yCount = yValues.length;
    _boxPlotQuartileValues = _BoxPlotQuartileValues();
    _boxPlotQuartileValues.average =
        //ignore: always_specify_types
        (yValues.fold(0, (num x, y) => (x.toDouble()) + y!)) / yCount;
    if (mode == BoxPlotMode.exclusive) {
      _boxPlotQuartileValues.lowerQuartile =
          _getExclusiveQuartileValue(yValues, yCount, 0.25);
      _boxPlotQuartileValues.upperQuartile =
          _getExclusiveQuartileValue(yValues, yCount, 0.75);
      _boxPlotQuartileValues.median =
          _getExclusiveQuartileValue(yValues, yCount, 0.5);
    } else if (mode == BoxPlotMode.inclusive) {
      _boxPlotQuartileValues.lowerQuartile =
          _getInclusiveQuartileValue(yValues, yCount, 0.25);
      _boxPlotQuartileValues.upperQuartile =
          _getInclusiveQuartileValue(yValues, yCount, 0.75);
      _boxPlotQuartileValues.median =
          _getInclusiveQuartileValue(yValues, yCount, 0.5);
    } else {
      _boxPlotQuartileValues.median = _getMedian(yValues);
      _getQuartileValues(yValues, yCount, _boxPlotQuartileValues);
    }
    _getMinMaxOutlier(yValues, yCount, _boxPlotQuartileValues);
    point.minimum = _boxPlotQuartileValues.minimum;
    point.maximum = _boxPlotQuartileValues.maximum;
    point.lowerQuartile = _boxPlotQuartileValues.lowerQuartile;
    point.upperQuartile = _boxPlotQuartileValues.upperQuartile;
    point.median = _boxPlotQuartileValues.median;
    point.outliers = _boxPlotQuartileValues.outliers;
    point.mean = _boxPlotQuartileValues.average;
  }

  /// To find exclusive quartile values.
  double _getExclusiveQuartileValue(
      List<num?> yValues, int count, num percentile) {
    if (count == 0) {
      return 0;
    } else if (count == 1) {
      return yValues[0]!.toDouble();
    }
    num value = 0;
    final num rank = percentile * (count + 1);
    final int integerRank = (rank.abs()).floor();
    final num fractionRank = rank - integerRank;
    if (integerRank == 0) {
      value = yValues[0]!;
    } else if (integerRank > count - 1) {
      value = yValues[count - 1]!;
    } else {
      value =
          fractionRank * (yValues[integerRank]! - yValues[integerRank - 1]!) +
              yValues[integerRank - 1]!;
    }
    return value.toDouble();
  }

  /// To find inclusive quartile values.
  double _getInclusiveQuartileValue(
      List<num?> yValues, int count, num percentile) {
    if (count == 0) {
      return 0;
    } else if (count == 1) {
      return yValues[0]!.toDouble();
    }
    num value = 0;
    final num rank = percentile * (count - 1);
    final int integerRank = (rank.abs()).floor();
    final num fractionRank = rank - integerRank;
    value = fractionRank * (yValues[integerRank + 1]! - yValues[integerRank]!) +
        yValues[integerRank]!;
    return value.toDouble();
  }

  /// To find a midian value of each box plot point.
  double _getMedian(List<num?> values) {
    final int half = (values.length / 2).floor();
    return (values.length % 2 != 0
            ? values[half]!
            : ((values[half - 1]! + values[half]!) / 2.0))
        .toDouble();
  }

  /// To get the quartile values.
  void _getQuartileValues(dynamic yValues, num count,
      _BoxPlotQuartileValues _boxPlotQuartileValues) {
    if (count == 1) {
      _boxPlotQuartileValues.lowerQuartile = yValues[0];
      _boxPlotQuartileValues.upperQuartile = yValues[0];
      return;
    }
    final bool isEvenList = count % 2 == 0;
    final num halfLength = count ~/ 2;
    final List<num?> lowerQuartileArray = yValues.sublist(0, halfLength);
    final List<num?> upperQuartileArray =
        yValues.sublist(isEvenList ? halfLength : halfLength + 1, count);
    _boxPlotQuartileValues.lowerQuartile = _getMedian(lowerQuartileArray);
    _boxPlotQuartileValues.upperQuartile = _getMedian(upperQuartileArray);
  }

  /// To get the outliers values of box plot series.
  void _getMinMaxOutlier(List<num?> yValues, int count,
      _BoxPlotQuartileValues _boxPlotQuartileValues) {
    final double interquartile = _boxPlotQuartileValues.upperQuartile! -
        _boxPlotQuartileValues.lowerQuartile!;
    final num rangeIQR = 1.5 * interquartile;
    for (int i = 0; i < count; i++) {
      if (yValues[i]! < _boxPlotQuartileValues.lowerQuartile! - rangeIQR) {
        _boxPlotQuartileValues.outliers!.add(yValues[i]!);
      } else {
        _boxPlotQuartileValues.minimum = yValues[i];
        break;
      }
    }
    for (int i = count - 1; i >= 0; i--) {
      if (yValues[i]! > _boxPlotQuartileValues.upperQuartile! + rangeIQR) {
        _boxPlotQuartileValues.outliers!.add(yValues[i]!);
      } else {
        _boxPlotQuartileValues.maximum = yValues[i];
        break;
      }
    }
  }

  /// Range box plot _segment is created here
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _segment = createSegment();
    _oldSeriesRenderers = _chartState!._oldSeriesRenderers;
    _isRectSeries = false;
    _segment._seriesIndex = seriesIndex;
    _segment.currentSegmentIndex = pointIndex;
    _segment._seriesRenderer = this;
    _segment._series = _series as XyDataSeries<dynamic, dynamic>;
    _segment.animationFactor = animateFactor;
    _segment._pointColorMapper = currentPoint.pointColorMapper;
    _segment._currentPoint = currentPoint;
    if (_renderingDetails!.widgetNeedUpdate &&
        !_renderingDetails!.isLegendToggled &&
        _oldSeriesRenderers != null &&
        _oldSeriesRenderers!.isNotEmpty &&
        _oldSeriesRenderers!.length - 1 >= _segment._seriesIndex &&
        _oldSeriesRenderers![_segment._seriesIndex]._seriesName ==
            _segment._seriesRenderer._seriesName) {
      _segment._oldSeriesRenderer = _oldSeriesRenderers![_segment._seriesIndex];
      _segment._oldSegmentIndex = _getOldSegmentIndex(_segment);
    }
    _segment.calculateSegmentPoints();
    //stores the points for rendering box and whisker - high, low and rect points
    _segment.points
      ..add(Offset(currentPoint.markerPoint!.x, _segment._maxPoint.y))
      ..add(Offset(currentPoint.markerPoint!.x, _segment._minPoint.y))
      ..add(Offset(_segment._lowerX, _segment._topRectY))
      ..add(Offset(_segment._upperX, _segment._topRectY))
      ..add(Offset(_segment._upperX, _segment._bottomRectY))
      ..add(Offset(_segment._lowerX, _segment._bottomRectY));
    customizeSegment(_segment);
    _segment.strokePaint = _segment.getStrokePaint();
    _segment.fillPaint = _segment.getFillPaint();
    _segments.add(_segment);
    return _segment;
  }

  @override
  BoxAndWhiskerSegment createSegment() => BoxAndWhiskerSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    final BoxAndWhiskerSegment boxSegment = _segment as BoxAndWhiskerSegment;
    boxSegment._color = boxSegment._currentPoint!.pointColorMapper ??
        _segment._seriesRenderer._seriesColor;
    boxSegment._strokeColor = _segment._series.borderColor;
    boxSegment._strokeWidth = _segment._series.borderWidth;
    boxSegment.strokePaint = boxSegment.getStrokePaint();
    boxSegment.fillPaint = boxSegment.getFillPaint();
  }

  /// To draw box plot series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment _segment) {
    if (_segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _segments[_segment.currentSegmentIndex!], _chart);
    }
    _segment.onPaint(canvas);
  }

  ///Draws outlier with different shape and color of the appropriate
  ///data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    canvas.drawPath(seriesRenderer!._markerShapes[index]!, fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
