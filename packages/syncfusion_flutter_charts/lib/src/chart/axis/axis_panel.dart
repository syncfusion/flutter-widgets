part of charts;

class _ChartAxis {
  _ChartAxis(this._chartState) {
    _innerPadding = 5;
    _axisPadding = 10;
    _axisClipRect = const Rect.fromLTRB(0, 0, 0, 0);
    _verticalAxisRenderers = <ChartAxisRenderer>[];
    _horizontalAxisRenderers = <ChartAxisRenderer>[];
    _needsRepaint = true;
  }
  final SfCartesianChartState _chartState;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCartesianChart get _chartWidget => _chartState._chart;
  late ChartAxisRenderer _primaryXAxisRenderer, _primaryYAxisRenderer;
  List<ChartAxisRenderer> _leftAxisRenderers = <ChartAxisRenderer>[];
  List<ChartAxisRenderer> _rightAxisRenderers = <ChartAxisRenderer>[];
  List<ChartAxisRenderer> _topAxisRenderers = <ChartAxisRenderer>[];
  List<ChartAxisRenderer> _bottomAxisRenderers = <ChartAxisRenderer>[];
  late List<_AxisSize> _leftAxesCount;
  late List<_AxisSize> _bottomAxesCount;
  late List<_AxisSize> _topAxesCount;
  late List<_AxisSize> _rightAxesCount;
  double _bottomSize = 0;
  double _topSize = 0;
  double _leftSize = 0;
  double _rightSize = 0;
  double _innerPadding = 0;
  double _axisPadding = 0;
  late Rect _axisClipRect;
  List<ChartAxisRenderer> _verticalAxisRenderers = <ChartAxisRenderer>[];
  List<ChartAxisRenderer> _horizontalAxisRenderers = <ChartAxisRenderer>[];
  //ignore: prefer_final_fields
  List<ChartAxisRenderer> _axisRenderersCollection = <ChartAxisRenderer>[];

  /// Whether to repaint axis or not
  late bool _needsRepaint;

  /// To get the crossAt values of a specific axis
  void _getAxisCrossingValue(ChartAxisRenderer axisRenderer) {
    final ChartAxis axis = axisRenderer._axis;
    if (axis.crossesAt != null) {
      if (axis.associatedAxisName != null) {
        for (int i = 0;
            i < _chartState._chartAxis._axisRenderersCollection.length;
            i++) {
          if (axis.associatedAxisName ==
              _chartState._chartAxis._axisRenderersCollection[i]._name) {
            axisRenderer._crossAxisRenderer =
                _chartState._chartAxis._axisRenderersCollection[i];
            _calculateCrossingValues(
                axisRenderer, axisRenderer._crossAxisRenderer);
          }
        }
      } else {
        axisRenderer._crossAxisRenderer = _chartState._requireInvertedAxis
            ? (axisRenderer._crossAxisRenderer =
                axisRenderer._orientation == AxisOrientation.horizontal
                    ? _chartState._chartAxis._primaryXAxisRenderer
                    : _chartState._chartAxis._primaryYAxisRenderer)
            : (axisRenderer._orientation == AxisOrientation.horizontal
                ? _chartState._chartAxis._primaryYAxisRenderer
                : _chartState._chartAxis._primaryXAxisRenderer);

        _calculateCrossingValues(axisRenderer, axisRenderer._crossAxisRenderer);
      }
    }
  }

  ///To get the axis crossing value
  void _calculateCrossingValues(ChartAxisRenderer currentAxisRenderer,
      ChartAxisRenderer targetAxisRenderer) {
    dynamic value = currentAxisRenderer._axis.crossesAt;
    value = value is String && num.tryParse(value) != null
        ? num.tryParse(value)
        : value;
    if (targetAxisRenderer is DateTimeAxisRenderer) {
      value = value is DateTime ? value.millisecondsSinceEpoch : value;
      targetAxisRenderer._calculateRangeAndInterval(_chartState, 'AxisCross');
    } else if (targetAxisRenderer is CategoryAxisRenderer) {
      value = value is num
          ? value.floor()
          : targetAxisRenderer._labels.indexOf(value);
      targetAxisRenderer._calculateRangeAndInterval(_chartState, 'AxisCross');
    } else if (targetAxisRenderer is DateTimeCategoryAxisRenderer) {
      value = value is num
          ? value.floor()
          : (value is DateTime
              ? targetAxisRenderer._labels
                  .indexOf('${value.microsecondsSinceEpoch}')
              : null);
      targetAxisRenderer._calculateRangeAndInterval(_chartState, 'AxisCross');
    } else if (targetAxisRenderer is LogarithmicAxisRenderer) {
      final LogarithmicAxis _axis = targetAxisRenderer._axis as LogarithmicAxis;
      value = _calculateLogBaseValue(value, _axis.logBase);
      targetAxisRenderer._calculateRangeAndInterval(_chartState, 'AxisCross');
    } else if (targetAxisRenderer is NumericAxisRenderer) {
      targetAxisRenderer._calculateRangeAndInterval(_chartState, 'AxisCross');
    }
    if (value.isNaN == false) {
      currentAxisRenderer._crossValue =
          _updateCrossValue(value, targetAxisRenderer._visibleRange!);
      currentAxisRenderer._crossRange = targetAxisRenderer._visibleRange;
    }
  }

  ///To measure the bounds of each axis
  void _measureAxesBounds() {
    _bottomSize = 0;
    _topSize = 0;
    _leftSize = 0;
    _rightSize = 0;
    _leftAxesCount = <_AxisSize>[];
    _bottomAxesCount = <_AxisSize>[];
    _topAxesCount = <_AxisSize>[];
    _rightAxesCount = <_AxisSize>[];
    _bottomAxisRenderers = <ChartAxisRenderer>[];
    _rightAxisRenderers = <ChartAxisRenderer>[];
    _topAxisRenderers = <ChartAxisRenderer>[];
    _leftAxisRenderers = <ChartAxisRenderer>[];

    if (_verticalAxisRenderers.isNotEmpty) {
      for (int axisIndex = 0;
          axisIndex < _verticalAxisRenderers.length;
          axisIndex++) {
        final dynamic axisRenderer = _verticalAxisRenderers[axisIndex];
        assert(
            !(axisRenderer._axis.interval != null) ||
                (axisRenderer._axis.interval > 0) == true,
            'The vertical axis interval value must be greater than 0.');
        axisRenderer._calculateRangeAndInterval(_chartState);
        _getAxisCrossingValue(axisRenderer);
        _measureAxesSize(axisRenderer);
      }
      _calculateSeriesClipRect();
    }
    if (_horizontalAxisRenderers.isNotEmpty) {
      for (int axisIndex = 0;
          axisIndex < _horizontalAxisRenderers.length;
          axisIndex++) {
        final dynamic axisRenderer = _horizontalAxisRenderers[axisIndex];
        _calculateLabelRotationAngle(axisRenderer);
        assert(
            !(axisRenderer._axis.interval != null) ||
                (axisRenderer._axis.interval > 0) == true,
            'The horizontal axis interval value must be greater than 0.');
        axisRenderer._calculateRangeAndInterval(_chartState);
        _getAxisCrossingValue(axisRenderer);
        _measureAxesSize(axisRenderer);
      }
    }
    _calculateAxesRect();
  }

  ///Calculate the axes total size
  void _measureAxesSize(ChartAxisRenderer axisRenderer) {
    final ChartAxis axis = axisRenderer._axis;
    num titleSize = 0;
    axisRenderer._totalSize = 0;
    if (axis.isVisible) {
      if (axis.title.text != null && axis.title.text!.isNotEmpty) {
        titleSize = measureText(axis.title.text!, axis.title.textStyle).height +
            _axisPadding;
      }
      final Rect rect = _chartState._renderingDetails.chartContainerRect;
      final int axisIndex = _getAxisIndex(axisRenderer);
      final double tickSize =
          (axisIndex == 0 && axis.tickPosition == TickPosition.inside)
              ? 0
              : math.max(
                      axis.majorTickLines.size,
                      axis.minorTicksPerInterval > 0
                          ? axis.minorTickLines.size
                          : 0) +
                  _innerPadding;
      final double labelSize = (axisIndex == 0 &&
              axis.labelPosition == ChartDataLabelPosition.inside)
          ? 0
          : (axis.labelStyle.fontSize == 0
                  ? 0
                  : (axisRenderer._orientation == AxisOrientation.horizontal)
                      ? axisRenderer._maximumLabelSize.height
                      : (axis.labelsExtent != null && axis.labelsExtent! > 0)
                          ? axis.labelsExtent
                          : axisRenderer._maximumLabelSize.width)! +
              _innerPadding;
      axisRenderer._totalSize = titleSize + tickSize + labelSize;
      if (axisRenderer._orientation == AxisOrientation.horizontal) {
        if (!axis.opposedPosition) {
          axisRenderer._totalSize +=
              _bottomAxisRenderers.isNotEmpty && axis.labelStyle.fontSize! > 0
                  ? _axisPadding.toDouble()
                  : 0;
          if (axisRenderer._crossValue != null &&
              axisRenderer._crossRange != null) {
            final num crosPosition = _valueToCoefficient(
                    axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.height;
            axisRenderer._totalSize = crosPosition - axisRenderer._totalSize < 0
                ? (crosPosition - axisRenderer._totalSize).abs()
                : !axis.placeLabelsNearAxisLine
                    ? labelSize
                    : 0;
          }
          _bottomSize += axisRenderer._totalSize;
          _bottomAxesCount
              .add(_AxisSize(axisRenderer, axisRenderer._totalSize));
        } else {
          axisRenderer._totalSize +=
              _topAxisRenderers.isNotEmpty && axis.labelStyle.fontSize! > 0
                  ? _axisPadding.toDouble()
                  : 0;
          if (axisRenderer._crossValue != null &&
              axisRenderer._crossRange != null) {
            final num crosPosition = _valueToCoefficient(
                    axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.height;
            axisRenderer._totalSize = crosPosition + axisRenderer._totalSize >
                    rect.height
                ? ((crosPosition + axisRenderer._totalSize) - rect.height).abs()
                : !axis.placeLabelsNearAxisLine
                    ? labelSize
                    : 0;
          }
          _topSize += axisRenderer._totalSize;
          _topAxesCount.add(_AxisSize(axisRenderer, axisRenderer._totalSize));
        }
      } else if (axisRenderer._orientation == AxisOrientation.vertical) {
        if (!axis.opposedPosition) {
          axisRenderer._totalSize +=
              _leftAxisRenderers.isNotEmpty && axis.labelStyle.fontSize! > 0
                  ? _axisPadding.toDouble()
                  : 0;
          if (axisRenderer._crossValue != null &&
              axisRenderer._crossRange != null) {
            final num crosPosition = _valueToCoefficient(
                    axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.width;
            axisRenderer._totalSize = crosPosition - axisRenderer._totalSize < 0
                ? (crosPosition - axisRenderer._totalSize).abs()
                : !axis.placeLabelsNearAxisLine
                    ? labelSize
                    : 0;
          }
          _leftSize += axisRenderer._totalSize;
          _leftAxesCount.add(_AxisSize(axisRenderer, axisRenderer._totalSize));
        } else {
          axisRenderer._totalSize +=
              _rightAxisRenderers.isNotEmpty && axis.labelStyle.fontSize! > 0
                  ? _axisPadding.toDouble()
                  : 0;
          if (axisRenderer._crossValue != null &&
              axisRenderer._crossRange != null) {
            final num crosPosition = _valueToCoefficient(
                    axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.width;
            axisRenderer._totalSize = crosPosition + axisRenderer._totalSize >
                    rect.width
                ? ((crosPosition + axisRenderer._totalSize) - rect.width).abs()
                : !axis.placeLabelsNearAxisLine
                    ? labelSize
                    : 0;
          }
          _rightSize += axisRenderer._totalSize;
          _rightAxesCount.add(_AxisSize(axisRenderer, axisRenderer._totalSize));
        }
      }
    }
  }

  /// To get the axis index
  int _getAxisIndex(ChartAxisRenderer axisRenderer) {
    int index;
    final ChartAxis axis = axisRenderer._axis;
    if (axisRenderer._orientation == AxisOrientation.horizontal) {
      if (!axis.opposedPosition) {
        _bottomAxisRenderers.add(axisRenderer);
        index = _bottomAxisRenderers.length;
      } else {
        _topAxisRenderers.add(axisRenderer);
        index = _topAxisRenderers.length;
      }
    } else if (axisRenderer._orientation == AxisOrientation.vertical) {
      if (!axis.opposedPosition) {
        _leftAxisRenderers.add(axisRenderer);
        index = _leftAxisRenderers.length;
      } else {
        _rightAxisRenderers.add(axisRenderer);
        index = _rightAxisRenderers.length;
      }
    } else {
      index = 0;
    }
    return index - 1;
  }

  ///To find the axis label rotation angle
  void _calculateLabelRotationAngle(ChartAxisRenderer axisRenderer) {
    int angle = axisRenderer._labelRotation;
    if (angle < -360 || angle > 360) {
      angle %= 360;
    }
    if (angle.isNegative) {
      angle = angle + 360;
    }
    axisRenderer._labelRotation = angle;
  }

  /// Calculate series clip rect size
  void _calculateSeriesClipRect() {
    final Rect containerRect = _chartState._renderingDetails.chartContainerRect;
    final num padding = _chartWidget.title.text.isNotEmpty ? 10 : 0;
    _chartState._chartAxis._axisClipRect = Rect.fromLTWH(
        containerRect.left + _leftSize,
        containerRect.top + _topSize + padding,
        containerRect.width - _leftSize - _rightSize,
        containerRect.height - _topSize - _bottomSize - padding);
  }

  /// To return the crossAt value
  num _updateCrossValue(num value, _VisibleRange range) {
    if (value < range.minimum) {
      value = range.minimum;
    }
    if (value > range.maximum) {
      value = range.maximum;
    }
    return value;
  }

  /// Return the axis offset value for x and y axis
  num? _getPrevAxisOffset(
      List<_AxisSize> axesSize, Rect rect, int currentAxisIndex, String type) {
    num? prevAxisOffsetValue;
    if (currentAxisIndex > 0) {
      for (int i = currentAxisIndex - 1; i >= 0; i--) {
        final ChartAxisRenderer axisRenderer = axesSize[i].axisRenderer;
        final Rect bounds = axisRenderer._bounds;
        if (type == 'Left' &&
            ((axisRenderer._labelOffset != null
                    ? axisRenderer._labelOffset! -
                        axisRenderer._maximumLabelSize.width
                    : bounds.left - bounds.width) <
                rect.left)) {
          prevAxisOffsetValue = axisRenderer._labelOffset != null
              ? axisRenderer._labelOffset! -
                  axisRenderer._maximumLabelSize.width
              : bounds.left - bounds.width;
          break;
        } else if (type == 'Bottom' &&
            ((axisRenderer._labelOffset != null
                    ? axisRenderer._labelOffset! +
                        axisRenderer._maximumLabelSize.height
                    : bounds.top + bounds.height) >
                rect.top + rect.height)) {
          prevAxisOffsetValue = axisRenderer._labelOffset != null
              ? axisRenderer._labelOffset! +
                  axisRenderer._maximumLabelSize.height
              : bounds.top + bounds.height;
          break;
        } else if (type == 'Right' &&
            ((axisRenderer._labelOffset != null
                    ? axisRenderer._labelOffset! +
                        axisRenderer._maximumLabelSize.width
                    : bounds.left + bounds.width) >
                rect.left + rect.width)) {
          prevAxisOffsetValue = axisRenderer._labelOffset != null
              ? axisRenderer._labelOffset! +
                  axisRenderer._maximumLabelSize.width
              : bounds.left + bounds.width;
          break;
        } else if (type == 'Top' &&
            ((axisRenderer._labelOffset != null
                    ? axisRenderer._labelOffset! -
                        axisRenderer._maximumLabelSize.height
                    : bounds.top - bounds.height) <
                rect.top)) {
          prevAxisOffsetValue = axisRenderer._labelOffset != null
              ? axisRenderer._labelOffset! -
                  axisRenderer._maximumLabelSize.height
              : bounds.top - bounds.height;
          break;
        }
      }
    }
    return prevAxisOffsetValue;
  }

  /// Calculate axes bounds based on all axes
  void _calculateAxesRect() {
    _calculateSeriesClipRect();

    /// Calculate the left axes rect
    if (_leftAxesCount.isNotEmpty) {
      _calculateLeftAxesBounds();
    }

    /// Calculate the bottom axes rect
    if (_bottomAxesCount.isNotEmpty) {
      _calculateBottomAxesBounds();
    }

    /// Calculate the right axes rect
    if (_rightAxesCount.isNotEmpty) {
      _calculateRightAxesBounds();
    }

    /// Calculate the top axes rect
    if (_topAxesCount.isNotEmpty) {
      _calculateTopAxesBounds();
    }
  }

  /// Calculate the left axes bounds
  void _calculateLeftAxesBounds() {
    double axisSize, width;
    final int axesLength = _leftAxesCount.length;
    final Rect rect = _chartState._chartAxis._axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      width = _leftAxesCount[axisIndex].size;
      final ChartAxisRenderer axisRenderer =
          _leftAxesCount[axisIndex].axisRenderer;
      final ChartAxis axis = axisRenderer._axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      if (axisRenderer._crossValue != null) {
        axisSize = (_valueToCoefficient(axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.width) +
            rect.left;
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisRenderer._labelOffset = rect.left - 5;
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(_leftAxesCount, rect, axisIndex, 'Left');
        axisSize = prevAxisOffsetValue == null
            ? rect.left
            : (prevAxisOffsetValue -
                    (axis.labelPosition == ChartDataLabelPosition.inside
                        ? (_innerPadding + axisRenderer._maximumLabelSize.width)
                        : 0)) -
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) -
                _axisPadding;
      }
      axisRenderer._bounds = Rect.fromLTWH(axisSize, rect.top + axis.plotOffset,
          width, rect.height - 2 * axis.plotOffset);
    }
  }

  /// Calculate the bottom axes bounds
  void _calculateBottomAxesBounds() {
    double axisSize, height;
    final int axesLength = _bottomAxesCount.length;
    final Rect rect = _chartState._chartAxis._axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      height = _bottomAxesCount[axisIndex].size;
      final ChartAxisRenderer axisRenderer =
          _bottomAxesCount[axisIndex].axisRenderer;
      final ChartAxis axis = axisRenderer._axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      if (axisRenderer._crossValue != null) {
        axisSize = rect.top +
            rect.height -
            (_valueToCoefficient(axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.height);
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisRenderer._labelOffset = rect.top + rect.height + 5;
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(_bottomAxesCount, rect, axisIndex, 'Bottom');
        axisSize = (prevAxisOffsetValue == null)
            ? rect.top + rect.height
            : _axisPadding +
                prevAxisOffsetValue +
                (axis.labelPosition == ChartDataLabelPosition.inside
                    ? (_innerPadding + axisRenderer._maximumLabelSize.height)
                    : 0) +
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0);
      }
      axisRenderer._bounds = Rect.fromLTWH(rect.left + axis.plotOffset,
          axisSize, rect.width - 2 * axis.plotOffset, height);
    }
  }

  /// Calculate the right axes bounds
  void _calculateRightAxesBounds() {
    double axisSize, width;
    final int axesLength = _rightAxesCount.length;
    final Rect rect = _chartState._chartAxis._axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          _rightAxesCount[axisIndex].axisRenderer;
      final ChartAxis axis = axisRenderer._axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      width = _rightAxesCount[axisIndex].size;
      if (axisRenderer._crossValue != null) {
        axisSize = rect.left +
            (_valueToCoefficient(axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.width);
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisRenderer._labelOffset = rect.left + rect.width + 5;
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(_rightAxesCount, rect, axisIndex, 'Right');
        axisSize = (prevAxisOffsetValue == null)
            ? rect.left + rect.width
            : (prevAxisOffsetValue +
                    (axis.labelPosition == ChartDataLabelPosition.inside
                        ? axisRenderer._maximumLabelSize.width + _innerPadding
                        : 0)) +
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) +
                _axisPadding;
      }
      axisRenderer._bounds = Rect.fromLTWH(axisSize, rect.top + axis.plotOffset,
          width, rect.height - 2 * axis.plotOffset);
    }
  }

  /// Calculate the top axes bounds
  void _calculateTopAxesBounds() {
    double axisSize, height;
    final int axesLength = _topAxesCount.length;
    final Rect rect = _chartState._chartAxis._axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          _topAxesCount[axisIndex].axisRenderer;
      final ChartAxis axis = axisRenderer._axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      height = _topAxesCount[axisIndex].size;
      if (axisRenderer._crossValue != null) {
        axisSize = rect.top +
            rect.height -
            (_valueToCoefficient(axisRenderer._crossValue!,
                    axisRenderer._crossAxisRenderer) *
                rect.height);
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisRenderer._labelOffset = rect.top - 5;
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(_topAxesCount, rect, axisIndex, 'Top');
        axisSize = (prevAxisOffsetValue == null)
            ? rect.top
            : prevAxisOffsetValue -
                (axis.labelPosition == ChartDataLabelPosition.inside
                    ? (_axisPadding + axisRenderer._maximumLabelSize.height)
                    : 0) -
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) -
                _axisPadding;
      }
      axisRenderer._bounds = Rect.fromLTWH(rect.left + axis.plotOffset,
          axisSize, rect.width - 2 * axis.plotOffset, height);
    }
  }

  /// Calculate the visible axes
  void _calculateVisibleAxes() {
    _innerPadding = _chartWidget.borderWidth;
    _axisPadding = 5;
    _axisClipRect = const Rect.fromLTRB(0, 0, 0, 0);
    _verticalAxisRenderers = <ChartAxisRenderer>[];
    _horizontalAxisRenderers = <ChartAxisRenderer>[];
    _axisRenderersCollection = <ChartAxisRenderer>[];
    _primaryXAxisRenderer = _getAxisRenderer(_chartWidget.primaryXAxis);
    _primaryYAxisRenderer = _getAxisRenderer(_chartWidget.primaryYAxis);
    _primaryXAxisRenderer._name =
        (_primaryXAxisRenderer._name) ?? 'primaryXAxis';
    _primaryYAxisRenderer._name = _primaryYAxisRenderer._name ?? 'primaryYAxis';

    final List<ChartAxis> _axesCollection = <ChartAxis>[
      _chartWidget.primaryXAxis,
      _chartWidget.primaryYAxis
    ];
    final List<CartesianSeriesRenderer> visibleSeriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderer.isNotEmpty) {
      if (_chartWidget.axes.isNotEmpty) {
        _axesCollection.addAll(_chartWidget.axes);
      }

      for (int axisIndex = 0; axisIndex < _axesCollection.length; axisIndex++) {
        final ChartAxisRenderer axisRenderer = axisIndex == 0
            ? _primaryXAxisRenderer
            : (axisIndex == 1
                ? _primaryYAxisRenderer
                : _getAxisRenderer(_axesCollection[axisIndex]));
        if (axisRenderer is CategoryAxisRenderer) {
          axisRenderer._labels = <String>[];
        } else if (axisRenderer is DateTimeCategoryAxisRenderer) {
          axisRenderer._labels = <String>[];
        }
        axisRenderer._seriesRenderers = <CartesianSeriesRenderer>[];
        axisRenderer._chartState = _chartState;
        for (int seriesIndex = 0;
            seriesIndex < visibleSeriesRenderer.length;
            seriesIndex++) {
          final CartesianSeriesRenderer seriesRenderer =
              visibleSeriesRenderer[seriesIndex];
          final XyDataSeries<dynamic, dynamic> series =
              seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
          if ((axisRenderer._name != null &&
                  axisRenderer._name == series.xAxisName) ||
              (series.xAxisName == null &&
                  axisRenderer._name == _primaryXAxisRenderer._name) ||
              (series.xAxisName != null &&
                  axisRenderer._name != series.xAxisName &&
                  axisRenderer._name ==
                      _chartState._chartAxis._primaryXAxisRenderer._name)) {
            axisRenderer._orientation = _chartState._requireInvertedAxis
                ? AxisOrientation.vertical
                : AxisOrientation.horizontal;
            seriesRenderer._xAxisRenderer = axisRenderer;
            axisRenderer._seriesRenderers.add(seriesRenderer);
          } else if ((axisRenderer._name != null &&
                  axisRenderer._name == series.yAxisName) ||
              (series.yAxisName == null &&
                  axisRenderer._name == _primaryYAxisRenderer._name) ||
              (series.yAxisName != null &&
                  axisRenderer._name != series.yAxisName &&
                  axisRenderer._name ==
                      _chartState._chartAxis._primaryYAxisRenderer._name)) {
            axisRenderer._orientation = _chartState._requireInvertedAxis
                ? AxisOrientation.horizontal
                : AxisOrientation.vertical;
            seriesRenderer._yAxisRenderer = axisRenderer;
            axisRenderer._seriesRenderers.add(seriesRenderer);
          }
        }

        ///Adding unmapped axes which were mapped with the indicators
        if (axisRenderer._orientation == null &&
            _chartWidget.indicators.isNotEmpty) {
          for (int i = 0; i < _chartWidget.indicators.length; i++) {
            if (_chartWidget.indicators[i].isVisible) {
              if (_chartWidget.indicators[i].xAxisName == axisRenderer._name) {
                axisRenderer._orientation = _chartState._requireInvertedAxis
                    ? AxisOrientation.vertical
                    : AxisOrientation.horizontal;
              } else if (_chartWidget.indicators[i].yAxisName ==
                  axisRenderer._name) {
                axisRenderer._orientation = _chartState._requireInvertedAxis
                    ? AxisOrientation.horizontal
                    : AxisOrientation.vertical;
              }
            }
          }
        }
        if (axisRenderer._orientation != null) {
          axisRenderer._orientation == AxisOrientation.vertical
              ? _verticalAxisRenderers.add(axisRenderer)
              : _horizontalAxisRenderers.add(axisRenderer);
        }
        axisRenderer._oldAxis = _chartState._renderingDetails.widgetNeedUpdate
            ? _getOldAxisRenderer(axisRenderer, _chartState._oldAxisRenderers)
                ?._axis
            : null;
        _axisRenderersCollection.add(axisRenderer);
      }
    } else {
      _chartState._chartAxis._primaryXAxisRenderer._orientation =
          _chartState._requireInvertedAxis
              ? AxisOrientation.vertical
              : AxisOrientation.horizontal;
      _chartState._chartAxis._primaryYAxisRenderer._orientation =
          _chartState._requireInvertedAxis
              ? AxisOrientation.horizontal
              : AxisOrientation.vertical;
      _horizontalAxisRenderers.add(_primaryXAxisRenderer);
      _verticalAxisRenderers.add(_primaryYAxisRenderer);
      _axisRenderersCollection.add(_primaryXAxisRenderer);
      _axisRenderersCollection.add(_primaryYAxisRenderer);
    }
  }

  ChartAxisRenderer _getAxisRenderer(ChartAxis axis) {
    switch (axis.runtimeType) {
      case NumericAxis:
        return NumericAxisRenderer(axis as NumericAxis);
      case LogarithmicAxis:
        return LogarithmicAxisRenderer(axis as LogarithmicAxis);
      case CategoryAxis:
        return CategoryAxisRenderer(axis as CategoryAxis);
      case DateTimeAxis:
        return DateTimeAxisRenderer(axis as DateTimeAxis);
      case DateTimeCategoryAxis:
        return DateTimeCategoryAxisRenderer(axis as DateTimeCategoryAxis);
      default:
        return NumericAxisRenderer(axis as NumericAxis);
    }
  }
}
