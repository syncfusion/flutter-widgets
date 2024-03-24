import 'dart:math';

import 'package:flutter/material.dart';

import '../axis/datetime_axis.dart';
import '../common/callbacks.dart';
import '../utils/enum.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// This class has the properties of the error bar series.
///
/// To render a error bar chart, create an instance of [ErrorBarSeries],
/// and add it to the series collection property of [SfCartesianChart].
class ErrorBarSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of ErrorBarSeries class.
  const ErrorBarSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    double width = 2.0,
    super.emptyPointSettings,
    super.initialIsVisible,
    super.animationDuration,
    super.opacity,
    super.animationDelay = 1500,
    super.dashArray,
    super.onRendererCreated,
    super.legendItemText,
    super.isVisibleInLegend = false,
    super.legendIconType = LegendIconType.verticalLine,
    this.type = ErrorBarType.fixed,
    this.direction = Direction.both,
    this.mode = RenderingMode.vertical,
    this.verticalErrorValue = 3.0,
    this.horizontalErrorValue = 1.0,
    this.verticalPositiveErrorValue = 3.0,
    this.horizontalPositiveErrorValue = 1.0,
    this.verticalNegativeErrorValue = 3.0,
    this.horizontalNegativeErrorValue = 1.0,
    this.capLength = 10.0,
    this.onRenderDetailsUpdate,
    super.onCreateShader,
  }) : super(borderWidth: width);

  /// Type of the error bar.
  ///
  /// Defaults to `ErrorBarType.fixed`.
  ///
  /// Other values are `ErrorBarType.percentage`,
  /// `ErrorBarType.standardDeviation`,
  /// `ErrorBarType.custom`, `ErrorBarType.standardError`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.fixed,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ErrorBarType? type;

  /// Direction of error bar.
  ///
  /// Defaults to `Direction.both`.
  ///
  /// Also refer [Direction].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         direction: Direction.plus,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Direction? direction;

  /// Mode of error bar.
  ///
  /// Defaults to `RenderingMode.vertical`.
  ///
  /// Other values are `RenderingMode.horizontal` and `RenderingMode.both`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         mode: RenderingMode.both,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final RenderingMode? mode;

  /// Vertical error value in Y direction.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         verticalErrorValue: 2,
  ///         mode: RenderingMode.vertical,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? verticalErrorValue;

  /// Horizontal error value in X direction..
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         horizontalErrorValue:2,
  ///         mode: RenderingMode.horizontal,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? horizontalErrorValue;

  /// Vertical error value in positive Y direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         verticalPositiveErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? verticalPositiveErrorValue;

  /// Horizontal error value in positive X direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         horizontalPositiveErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? horizontalPositiveErrorValue;

  /// Vertical error value in negative Y direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         verticalNegativeErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? verticalNegativeErrorValue;

  /// Horizontal error value in negative X direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         horizontalNegativeErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? horizontalNegativeErrorValue;

  /// Length of the error bar's cap.
  ///
  /// Defaults to `10`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         capLength:20.0,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? capLength;

  /// Callback which gets called on error bar render.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         onRenderDetailsUpdate:
  ///          (ErrorBarRenderDetails errorBarRenderDetails){
  ///           print(errorBarRenderDetails.pointIndex);
  ///           print(errorBarRenderDetails.viewPortPointIndex);
  ///           print(errorBarRenderDetails.calculatedErrorBarValues!.
  ///             horizontalPositiveErrorValue);
  ///           print(errorBarRenderDetails.calculatedErrorBarValues!.
  ///             horizontalNegativeErrorValue);
  ///           print(errorBarRenderDetails.calculatedErrorBarValues!.
  ///             verticalPositiveErrorValue);
  ///           print(errorBarRenderDetails.calculatedErrorBarValues!.
  ///             verticalNegativeErrorValue);
  ///         }
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartErrorBarRenderCallback? onRenderDetailsUpdate;

  /// Create the error bar series renderer.
  @override
  ErrorBarSeriesRenderer<T, D> createRenderer() {
    ErrorBarSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as ErrorBarSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return ErrorBarSeriesRenderer<T, D>();
  }

  @override
  ErrorBarSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final ErrorBarSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as ErrorBarSeriesRenderer<T, D>;
    renderer
      ..type = type
      ..direction = direction
      ..mode = mode
      ..verticalErrorValue = verticalErrorValue
      ..horizontalErrorValue = horizontalErrorValue
      ..verticalPositiveErrorValue = verticalPositiveErrorValue
      ..horizontalPositiveErrorValue = horizontalPositiveErrorValue
      ..verticalNegativeErrorValue = verticalNegativeErrorValue
      ..horizontalNegativeErrorValue = horizontalNegativeErrorValue
      ..capLength = capLength
      ..onRenderDetailsUpdate = onRenderDetailsUpdate;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, ErrorBarSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..type = type
      ..direction = direction
      ..mode = mode
      ..verticalErrorValue = verticalErrorValue
      ..horizontalErrorValue = horizontalErrorValue
      ..verticalPositiveErrorValue = verticalPositiveErrorValue
      ..horizontalPositiveErrorValue = horizontalPositiveErrorValue
      ..verticalNegativeErrorValue = verticalNegativeErrorValue
      ..horizontalNegativeErrorValue = horizontalNegativeErrorValue
      ..capLength = capLength
      ..onRenderDetailsUpdate = onRenderDetailsUpdate;
  }
}

/// Creates series renderer for error bar series.
class ErrorBarSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with ContinuousSeriesMixin<T, D>, SegmentAnimationMixin<T, D> {
  /// Calling the default constructor of ErrorBarSeriesRenderer class.
  ErrorBarSeriesRenderer();

  ErrorBarType? get type => _type;
  ErrorBarType? _type;
  set type(ErrorBarType? value) {
    if (_type != value) {
      _type = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  Direction? get direction => _direction;
  Direction? _direction;
  set direction(Direction? value) {
    if (_direction != value) {
      _direction = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  RenderingMode? get mode => _mode;
  RenderingMode? _mode;
  set mode(RenderingMode? value) {
    if (_mode != value) {
      _mode = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get verticalErrorValue => _verticalErrorValue;
  double? _verticalErrorValue;
  set verticalErrorValue(double? value) {
    if (_verticalErrorValue != value) {
      _verticalErrorValue = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get horizontalErrorValue => _horizontalErrorValue;
  double? _horizontalErrorValue;
  set horizontalErrorValue(double? value) {
    if (_horizontalErrorValue != value) {
      _horizontalErrorValue = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get horizontalPositiveErrorValue => _horizontalPositiveErrorValue;
  double? _horizontalPositiveErrorValue;
  set horizontalPositiveErrorValue(double? value) {
    if (_horizontalPositiveErrorValue != value) {
      _horizontalPositiveErrorValue = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get verticalPositiveErrorValue => _verticalPositiveErrorValue;
  double? _verticalPositiveErrorValue;
  set verticalPositiveErrorValue(double? value) {
    if (_verticalPositiveErrorValue != value) {
      _verticalPositiveErrorValue = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get verticalNegativeErrorValue => _verticalNegativeErrorValue;
  double? _verticalNegativeErrorValue;
  set verticalNegativeErrorValue(double? value) {
    if (_verticalNegativeErrorValue != value) {
      _verticalNegativeErrorValue = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get horizontalNegativeErrorValue => _horizontalNegativeErrorValue;
  double? _horizontalNegativeErrorValue;
  set horizontalNegativeErrorValue(double? value) {
    if (_horizontalNegativeErrorValue != value) {
      _horizontalNegativeErrorValue = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  double? get capLength => _capLength;
  double? _capLength;
  set capLength(double? value) {
    if (_capLength != value) {
      _capLength = value;
      _updateErrorBarValues();
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  ChartErrorBarRenderCallback? get onRenderDetailsUpdate =>
      _onRenderDetailsUpdate;
  ChartErrorBarRenderCallback? _onRenderDetailsUpdate;
  set onRenderDetailsUpdate(ChartErrorBarRenderCallback? value) {
    if (_onRenderDetailsUpdate != value) {
      _onRenderDetailsUpdate = value;
      markNeedsLayout();
    }
  }

  final List<ErrorBarValues> _errorBarValues = <ErrorBarValues>[];
  num _xMin = 0.0;
  num _xMax = 0.0;
  num _yMin = 0.0;
  num _yMax = 0.0;

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    _xMin = xMin;
    _xMax = xMax;
    _yMin = yMin;
    _yMax = yMax;
    _updateErrorBarValues();
    populateChartPoints();
  }

  @override
  void updateDataPoints(List<int>? removedIndexes, List<int>? addedIndexes,
      List<int>? replacedIndexes,
      [List<ChartValueMapper<T, num>>? yPaths,
      List<List<num>>? chaoticYLists,
      List<List<num>>? yLists,
      List<ChartValueMapper<T, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists,
      List<List<Object?>>? fLists]) {
    super.updateDataPoints(removedIndexes, addedIndexes, replacedIndexes,
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    _xMin = xMin;
    _xMax = xMax;
    _yMin = yMin;
    _yMax = yMax;
    _updateErrorBarValues();
  }

  void _updateErrorBarValues() {
    _errorBarValues.clear();
    final AxesRange axesRange = AxesRange(_xMin, _xMax, _yMin, _yMax);
    ErrorBarValues errorBarValues;

    if (type == ErrorBarType.standardDeviation ||
        type == ErrorBarType.standardError) {
      num sumOfX = 0.0;
      num sumOfY = 0.0;
      num? verticalSquareRoot;
      num? horizontalSquareRoot;
      num? verticalMean;
      num? horizontalMean;

      for (int i = 0; i < dataCount; i++) {
        sumOfY += yValues[i];
        sumOfX += xValues[i];
      }

      verticalMean = (mode == RenderingMode.horizontal)
          ? verticalMean
          : sumOfY / dataCount;
      horizontalMean = (mode == RenderingMode.vertical)
          ? horizontalMean
          : sumOfX / dataCount;
      for (int i = 0; i < dataCount; i++) {
        sumOfY = (mode == RenderingMode.horizontal)
            ? sumOfY
            : sumOfY + pow(yValues[i] - verticalMean!, 2);
        sumOfX = (mode == RenderingMode.vertical)
            ? sumOfX
            : sumOfX + pow(xValues[i] - horizontalMean!, 2);
      }

      verticalSquareRoot = sqrt(sumOfY / (dataCount - 1));
      horizontalSquareRoot = sqrt(sumOfX / (dataCount - 1));

      final ErrorBarMean mean = ErrorBarMean(
          verticalSquareRoot: verticalSquareRoot,
          horizontalSquareRoot: horizontalSquareRoot,
          verticalMean: verticalMean,
          horizontalMean: horizontalMean);

      for (int j = 0; j < dataCount; j++) {
        final num xValue = xValues[j];
        final num yValue = yValues[j];
        final ErrorValues errorValues =
            _calculateErrorValues(xValue, yValue, mean: mean);

        errorBarValues = _calculateErrorBarValues(errorValues, xValue, yValue);
        _errorBarValues.add(errorBarValues);
        _findMinMax(errorBarValues, axesRange);
      }
    } else {
      for (int k = 0; k < dataCount; k++) {
        final num xValue = xValues[k];
        final num yValue = yValues[k];
        final ErrorValues errorValues = _calculateErrorValues(
          xValue,
          yValue,
        );
        errorBarValues = _calculateErrorBarValues(
          errorValues,
          xValue,
          yValue,
        );
        _errorBarValues.add(errorBarValues);
        _findMinMax(errorBarValues, axesRange);
      }
    }

    xMin = axesRange.xMinimum;
    xMax = axesRange.xMaximum;
    yMin = axesRange.yMinimum;
    yMax = axesRange.yMaximum;
  }

  void _findMinMax(ErrorBarValues errorBarValues, AxesRange axesRange) {
    if (errorBarValues.horizontalNegativeErrorValue != null) {
      axesRange.xMinimum =
          min(axesRange.xMinimum, errorBarValues.horizontalNegativeErrorValue!);
    }

    if (errorBarValues.horizontalPositiveErrorValue != null) {
      axesRange.xMaximum =
          max(axesRange.xMaximum, errorBarValues.horizontalPositiveErrorValue!);
    }

    if (errorBarValues.verticalNegativeErrorValue != null) {
      axesRange.yMinimum =
          min(axesRange.yMinimum, errorBarValues.verticalNegativeErrorValue!);
    }
    if (errorBarValues.verticalPositiveErrorValue != null) {
      axesRange.yMaximum =
          max(axesRange.yMaximum, errorBarValues.verticalPositiveErrorValue!);
    }
  }

  /// Calculating error values based on error bar type.
  ErrorValues _calculateErrorValues(num actualXValue, num actualYValue,
      {ErrorBarMean? mean}) {
    num errorX = 0.0;
    num errorY = 0.0;
    num customNegativeErrorX = 0.0;
    num customNegativeErrorY = 0.0;
    ErrorValues? errorValues;

    if (type != ErrorBarType.custom) {
      errorY =
          (mode == RenderingMode.horizontal) ? errorY : verticalErrorValue!;
      errorX =
          (mode == RenderingMode.vertical) ? errorX : horizontalErrorValue!;
      errorValues = ErrorValues(errorX: errorX, errorY: errorY);

      if (type == ErrorBarType.standardError) {
        errorValues = _calculateStandardErrorValues(errorValues, mean!);
      } else if (type == ErrorBarType.standardDeviation) {
        errorValues = _calculateStandardDeviationValues(errorValues, mean!);
      } else if (type == ErrorBarType.percentage) {
        errorY = (mode == RenderingMode.horizontal)
            ? errorY
            : (errorY / 100) * actualYValue;
        errorX = (mode == RenderingMode.vertical)
            ? errorX
            : (errorX / 100) * actualXValue;
        errorValues = ErrorValues(errorX: errorX, errorY: errorY);
      }
    } else if (type == ErrorBarType.custom) {
      errorY = (mode == RenderingMode.horizontal)
          ? errorY
          : verticalPositiveErrorValue!;
      customNegativeErrorY = (mode == RenderingMode.horizontal)
          ? customNegativeErrorY
          : verticalNegativeErrorValue!;
      errorX = (mode == RenderingMode.vertical)
          ? errorX
          : horizontalPositiveErrorValue!;
      customNegativeErrorX = (mode == RenderingMode.vertical)
          ? customNegativeErrorX
          : horizontalNegativeErrorValue!;
      errorValues = ErrorValues(
          errorX: errorX,
          errorY: errorY,
          customNegativeX: customNegativeErrorX,
          customNegativeY: customNegativeErrorY);
    }
    return errorValues!;
  }

  /// Calculate the error values of standard error type error bar.
  ErrorValues _calculateStandardErrorValues(
      ErrorValues errorValues, ErrorBarMean mean) {
    final num errorX =
        (errorValues.errorX! * mean.horizontalSquareRoot!) / sqrt(dataCount);
    final num errorY =
        (errorValues.errorY! * mean.verticalSquareRoot!) / sqrt(dataCount);
    return ErrorValues(errorX: errorX, errorY: errorY);
  }

  /// Calculate the error values of standard deviation type error bar.
  ErrorValues _calculateStandardDeviationValues(
      ErrorValues errorValues, ErrorBarMean mean) {
    num errorY = errorValues.errorY!, errorX = errorValues.errorX!;
    errorY = (mode == RenderingMode.horizontal)
        ? errorY
        : errorY * (mean.verticalSquareRoot! + mean.verticalMean!);
    errorX = (mode == RenderingMode.vertical)
        ? errorX
        : errorX * (mean.horizontalSquareRoot! + mean.horizontalMean!);
    return ErrorValues(errorX: errorX, errorY: errorY);
  }

  /// Calculate the error bar values.
  ErrorBarValues _calculateErrorBarValues(
      ErrorValues errorValues, num actualXValue, num actualYValue) {
    final bool isDirectionPlus = direction == Direction.plus;
    final bool isBothDirection = direction == Direction.both;
    final bool isDirectionMinus = direction == Direction.minus;
    final bool isCustomFixedType =
        type == ErrorBarType.fixed || type == ErrorBarType.custom;
    double? verticalPositiveErrorValue,
        horizontalPositiveErrorValue,
        verticalNegativeErrorValue,
        horizontalNegativeErrorValue;

    if (mode == RenderingMode.horizontal || mode == RenderingMode.both) {
      if (isDirectionPlus || isBothDirection) {
        if (xAxis is RenderDateTimeAxis && isCustomFixedType) {
          horizontalPositiveErrorValue = _updateDateTimeHorizontalErrorValue(
              actualXValue, errorValues.errorX!);
        } else {
          horizontalPositiveErrorValue =
              actualXValue + errorValues.errorX! as double;
        }
      }
      if (isDirectionMinus || isBothDirection) {
        if (xAxis is RenderDateTimeAxis && isCustomFixedType) {
          horizontalNegativeErrorValue = _updateDateTimeHorizontalErrorValue(
              actualXValue,
              (type == ErrorBarType.custom)
                  ? -errorValues.customNegativeX!
                  : -errorValues.errorX!);
        } else {
          horizontalNegativeErrorValue = actualXValue -
              ((type == ErrorBarType.custom)
                  ? errorValues.customNegativeX!
                  : errorValues.errorX!) as double;
        }
      }
    }

    if (mode == RenderingMode.vertical || mode == RenderingMode.both) {
      if (isDirectionPlus || isBothDirection) {
        verticalPositiveErrorValue =
            actualYValue + errorValues.errorY! as double;
      }
      if (isDirectionMinus || isBothDirection) {
        verticalNegativeErrorValue = actualYValue -
            ((type == ErrorBarType.custom)
                ? errorValues.customNegativeY!
                : errorValues.errorY!) as double;
      }
    }
    return ErrorBarValues(
        horizontalPositiveErrorValue,
        horizontalNegativeErrorValue,
        verticalPositiveErrorValue,
        verticalNegativeErrorValue);
  }

  /// Calculate the error values for DateTime axis.
  double _updateDateTimeHorizontalErrorValue(num actualXValue, num errorValue) {
    DateTime errorXValue =
        DateTime.fromMillisecondsSinceEpoch(actualXValue.toInt());
    final int errorX = errorValue.toInt();

    final RenderDateTimeAxis dateTimeAxis = xAxis! as RenderDateTimeAxis;
    final DateTimeIntervalType type = dateTimeAxis.intervalType;
    switch (type) {
      case DateTimeIntervalType.years:
        errorXValue = DateTime(
            errorXValue.year + errorX, errorXValue.month, errorXValue.day);
        break;
      case DateTimeIntervalType.months:
        errorXValue = DateTime(
            errorXValue.year, errorXValue.month + errorX, errorXValue.day);
        break;
      case DateTimeIntervalType.days:
        errorXValue = DateTime(
            errorXValue.year, errorXValue.month, errorXValue.day + errorX);
        break;
      case DateTimeIntervalType.hours:
        errorXValue = errorXValue.add(Duration(hours: errorX));
        break;
      case DateTimeIntervalType.minutes:
        errorXValue = errorXValue.add(Duration(minutes: errorX));
        break;
      case DateTimeIntervalType.seconds:
        errorXValue = errorXValue.add(Duration(seconds: errorX));
        break;
      case DateTimeIntervalType.milliseconds:
        errorXValue = errorXValue.add(Duration(milliseconds: errorX));
        break;
      case DateTimeIntervalType.auto:
        errorXValue = errorXValue.add(Duration(milliseconds: errorX));
        break;
    }
    return errorXValue.millisecondsSinceEpoch.toDouble();
  }

  @override
  void createOrUpdateSegments() {
    super.createOrUpdateSegments();

    if (onRenderDetailsUpdate != null) {
      final int length = _errorBarValues.length;
      for (int i = 0; i < length; i++) {
        final ErrorBarValues values = _errorBarValues[i];
        onRenderDetailsUpdate!(ErrorBarRenderDetails(i, i, values));
      }
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as ErrorBarSegment<T, D>
      ..series = this
      ..currentSegmentIndex = 0
      .._xValues = xValues
      .._yValues = yValues
      .._errorBarValues = _errorBarValues;
  }

  /// Creates a segment for a data point in the series.
  @override
  ErrorBarSegment<T, D> createSegment() => ErrorBarSegment<T, D>();

  /// Changes the series color and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    updateSegmentColor(segment, color, borderWidth);
    updateSegmentGradient(segment);
  }

  @override
  void onLoadingAnimationUpdate() {
    super.onLoadingAnimationUpdate();
    transformValues();
  }

  @override
  bool hitTestSelf(Offset position) {
    return false;
  }
}

/// Creates the segments for error bar series.
///
/// This generates the error bar series points and has the
/// [calculateSegmentPoints] override method
/// used to customize the error bar series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series`
/// to render the error bar segment.
class ErrorBarSegment<T, D> extends ChartSegment {
  late ErrorBarSeriesRenderer<T, D> series;
  final double _effectiveAnimationFactor = 0.05;
  late double _capPointValue;
  late double _errorBarMidPointX;
  late double _errorBarMidPointY;

  late List<num> _xValues;
  late List<num> _yValues;
  late List<ErrorBarValues> _errorBarValues;

  final Path _verticalPath = Path();
  final Path _verticalCapPath = Path();
  final Path _horizontalPath = Path();
  final Path _horizontalCapPath = Path();

  final List<Offset> _oldPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldPoints.clear();
        return;
      }

      final int newPointsLength = points.length;
      final int oldPointsLength = _oldPoints.length;
      if (oldPointsLength == newPointsLength) {
        for (int i = 0; i < newPointsLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }
      } else {
        final int minLength = min(oldPointsLength, newPointsLength);
        for (int i = 0; i < minLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }

        if (newPointsLength > oldPointsLength) {
          _oldPoints.addAll(points.sublist(oldPointsLength));
        } else {
          _oldPoints.removeRange(minLength, oldPointsLength);
        }
      }
    } else {
      _oldPoints.clear();
    }
  }

  @override
  void transformValues() {
    if (_xValues.isEmpty || _yValues.isEmpty || _errorBarValues.isEmpty) {
      return;
    }

    _verticalPath.reset();
    _verticalCapPath.reset();
    _horizontalPath.reset();
    _horizontalCapPath.reset();

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    for (int i = 0; i < series.dataCount; i++) {
      double? verticalPositiveX;
      double? verticalPositiveY;
      double? verticalNegativeX;
      double? verticalNegativeY;
      double? horizontalPositiveX;
      double? horizontalPositiveY;
      double? horizontalNegativeX;
      double? horizontalNegativeY;

      final num xValue = _xValues[i];
      final num yValue = _yValues[i];
      final ErrorBarValues errorBarValues = _errorBarValues[i];

      if (animationFactor != 0) {
        final bool isTransposedChart = series.isTransposed;
        _errorBarMidPointX = transformX(xValue, yValue);
        _errorBarMidPointY = transformY(xValue, yValue);
        points.add(Offset(_errorBarMidPointX, _errorBarMidPointY));

        if (errorBarValues.verticalPositiveErrorValue != null) {
          verticalPositiveX =
              transformX(xValue, errorBarValues.verticalPositiveErrorValue!);
          verticalPositiveY =
              transformY(xValue, errorBarValues.verticalPositiveErrorValue!);
          points.add(Offset(verticalPositiveX, verticalPositiveY));
        }

        if (errorBarValues.verticalNegativeErrorValue != null) {
          verticalNegativeX =
              transformX(xValue, errorBarValues.verticalNegativeErrorValue!);
          verticalNegativeY =
              transformY(xValue, errorBarValues.verticalNegativeErrorValue!);
          points.add(Offset(verticalNegativeX, verticalNegativeY));
        }

        if (errorBarValues.horizontalPositiveErrorValue != null) {
          horizontalPositiveX =
              transformX(errorBarValues.horizontalPositiveErrorValue!, yValue);
          horizontalPositiveY =
              transformY(errorBarValues.horizontalPositiveErrorValue!, yValue);
          points.add(Offset(horizontalPositiveX, horizontalPositiveY));
        }

        if (errorBarValues.horizontalNegativeErrorValue != null) {
          horizontalNegativeX =
              transformX(errorBarValues.horizontalNegativeErrorValue!, yValue);
          horizontalNegativeY =
              transformY(errorBarValues.horizontalNegativeErrorValue!, yValue);
          points.add(Offset(horizontalNegativeX, horizontalNegativeY));
        }

        double animatingPoint;
        if (verticalPositiveX != null && verticalPositiveY != null) {
          animatingPoint = isTransposedChart
              ? _errorBarMidPointX +
                  ((verticalPositiveX - _errorBarMidPointX) *
                      _effectiveAnimationFactor)
              : _errorBarMidPointY -
                  ((_errorBarMidPointY - verticalPositiveY) *
                      _effectiveAnimationFactor);

          _capPointValue = animatingPoint -
              ((animatingPoint -
                      (isTransposedChart
                          ? verticalPositiveX
                          : verticalPositiveY)) *
                  animationFactor);

          _calculateVerticalPath(_capPointValue, animationFactor,
              series.capLength!, isTransposedChart);
        }
        if (verticalNegativeX != null && verticalNegativeY != null) {
          animatingPoint = isTransposedChart
              ? _errorBarMidPointX +
                  ((verticalNegativeX - _errorBarMidPointX) *
                      _effectiveAnimationFactor)
              : _errorBarMidPointY +
                  ((verticalNegativeY - _errorBarMidPointY) *
                      _effectiveAnimationFactor);

          _capPointValue = animatingPoint +
              (((isTransposedChart ? verticalNegativeX : verticalNegativeY) -
                      animatingPoint) *
                  animationFactor);

          _calculateVerticalPath(_capPointValue, animationFactor,
              series.capLength!, isTransposedChart);
        }
        if (horizontalPositiveX != null && horizontalPositiveY != null) {
          animatingPoint = isTransposedChart
              ? _errorBarMidPointY -
                  ((_errorBarMidPointY - horizontalPositiveY) *
                      _effectiveAnimationFactor)
              : _errorBarMidPointX +
                  ((horizontalPositiveX - _errorBarMidPointX) *
                      _effectiveAnimationFactor);

          _capPointValue = animatingPoint +
              (((isTransposedChart
                          ? horizontalPositiveY
                          : horizontalPositiveX) -
                      animatingPoint) *
                  animationFactor);

          _calculateHorizontalPath(_capPointValue, animationFactor,
              series.capLength!, isTransposedChart);
        }
        if (horizontalNegativeX != null && horizontalNegativeY != null) {
          animatingPoint = isTransposedChart
              ? _errorBarMidPointY +
                  ((horizontalNegativeY - _errorBarMidPointY) *
                      _effectiveAnimationFactor)
              : _errorBarMidPointX -
                  ((_errorBarMidPointX - horizontalNegativeX) *
                      _effectiveAnimationFactor);

          _capPointValue = animatingPoint -
              ((animatingPoint -
                      (isTransposedChart
                          ? horizontalNegativeY
                          : horizontalNegativeX)) *
                  animationFactor);

          _calculateHorizontalPath(_capPointValue, animationFactor,
              series.capLength!, isTransposedChart);
        }

        if (points.length > _oldPoints.length) {
          _oldPoints.addAll(points.sublist(_oldPoints.length));
        }
      }
    }
  }

  void _calculateVerticalPath(double capPointValue, double animationFactor,
      double capLength, bool isTransposedChart) {
    if (isTransposedChart) {
      _verticalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      _verticalPath.lineTo(capPointValue, _errorBarMidPointY);
      _verticalCapPath.moveTo(
          capPointValue, _errorBarMidPointY - (capLength / 2));
      _verticalCapPath.lineTo(
          capPointValue, _errorBarMidPointY + (capLength / 2));
    } else {
      _verticalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      _verticalPath.lineTo(_errorBarMidPointX, capPointValue);
      _verticalCapPath.moveTo(
          _errorBarMidPointX - (capLength / 2), capPointValue);
      _verticalCapPath.lineTo(
          _errorBarMidPointX + (capLength / 2), capPointValue);
    }
    _verticalPath.close();
    _verticalCapPath.close();
  }

  void _calculateHorizontalPath(double capPointValue, double animationFactor,
      double capLength, bool isTransposedChart) {
    if (isTransposedChart) {
      _horizontalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      _horizontalPath.lineTo(_errorBarMidPointX, capPointValue);
      _horizontalCapPath.moveTo(
          _errorBarMidPointX - (capLength / 2), capPointValue);
      _horizontalCapPath.lineTo(
          _errorBarMidPointX + (capLength / 2), capPointValue);
    } else {
      _horizontalPath.moveTo(capPointValue, _errorBarMidPointY);
      _horizontalPath.lineTo(_errorBarMidPointX, _errorBarMidPointY);

      _horizontalCapPath.moveTo(
        capPointValue,
        _errorBarMidPointY - (capLength / 2),
      );
      _horizontalCapPath.lineTo(
        capPointValue,
        _errorBarMidPointY + (capLength / 2),
      );
    }
    _horizontalPath.close();
    _horizontalCapPath.close();
  }

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => strokePaint;

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Paint paint = getStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      canvas.drawPath(_verticalPath, paint);
      canvas.drawPath(_verticalCapPath, paint);

      canvas.drawPath(_horizontalPath, paint);
      canvas.drawPath(_horizontalCapPath, paint);
    }
  }

  @override
  void dispose() {
    _verticalPath.reset();
    _verticalCapPath.reset();
    _horizontalPath.reset();
    _horizontalCapPath.reset();
    super.dispose();
  }
}

class ErrorValues {
  /// Creates an instance of chart error values.
  ErrorValues({
    this.errorX,
    this.errorY,
    this.customNegativeX,
    this.customNegativeY,
  });

  /// Specifies the value of x.
  num? errorX;

  /// Specifies the value of y.
  num? errorY;

  /// Specifies the value of x in custom type error bar.
  num? customNegativeX;

  /// Specifies the value of y in custom type error bar.
  num? customNegativeY;
}

/// Holds the values related to standard error and standard
/// deviation error bars.
class ErrorBarMean {
  /// Creates an instance of ErrorBarMean.
  ErrorBarMean({
    this.verticalSquareRoot,
    this.horizontalSquareRoot,
    this.verticalMean,
    this.horizontalMean,
  });

  /// Mean's required square root value of all data points in y direction.
  final num? verticalSquareRoot;

  /// Mean's required square root value of all data points in x direction.
  final num? horizontalSquareRoot;

  /// Required mean value of all data points in y direction.
  final num? verticalMean;

  /// Required mean value of all data points in x direction.
  final num? horizontalMean;
}

class AxesRange {
  /// Creates an instance of MinMaxValues.
  AxesRange(
    this.xMinimum,
    this.xMaximum,
    this.yMinimum,
    this.yMaximum,
  );

  /// Holds the x axis minimum value.
  num xMinimum;

  /// Holds the x axis maximum value.
  num xMaximum;

  /// Holds the y axis minimum value.
  num yMinimum;

  /// Holds the y axis maximum value.
  num yMaximum;
}
