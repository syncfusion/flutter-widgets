part of charts;

class _SelectionRenderer {
  _SelectionRenderer();
  int? pointIndex;
  int? seriesIndex;
  late int cartesianSeriesIndex;
  int? cartesianPointIndex;
  late bool isSelection;
  ChartSegment? selectedSegment, currentSegment;
  final List<ChartSegment> defaultselectedSegments = <ChartSegment>[];
  final List<ChartSegment> defaultunselectedSegments = <ChartSegment>[];
  bool isSelected = false;
  late dynamic chart;
  late dynamic _chartState;
  dynamic seriesRenderer;
  late Color fillColor, strokeColor;
  late double fillOpacity, strokeOpacity, strokeWidth;
  SelectionArgs? selectionArgs;
  late List<ChartSegment> selectedSegments;
  List<ChartSegment>? unselectedSegments;
  SelectionType? selectionType;
  int? viewportIndex;
  bool selected = false;
  bool _isInteraction = false;

  ////Selects or deselects the specified data point in the series.
  ///
  ///The following are the arguments to be passed.
  ///* `pointIndex` - index of the data point that needs to be selected.
  ///* `seriesIndex` - index of the series in which the data point is selected.
  ///
  ///Where the `pointIndex` is a required argument and `seriesIndex` is an optional argument. By default, `0` will
  /// be considered as the series index. Thus it will take effect on the first series if no value is specified.
  ///
  ///For Circular, Pyramid and Funnel charts, seriesIndex should always be `0`, as it has only one series.
  ///
  ///If the specified data point is already selected, it will be deselected, else it will be selected.
  /// Selection type and multi-selection functionality is also applicable for this, but it is based on
  /// the API values specified in [ChartSelectionBehavior].
  ///
  ///_Note:_  Even though, the [enable] property in [ChartSelectionBehavior] is set to false, this method
  /// will work.

  void selectDataPoints(int? pointIndex, [int? seriesIndex]) {
    if (chart is SfCartesianChart) {
      if (_validIndex(pointIndex, seriesIndex, chart)) {
        bool select = false;
        final List<CartesianSeriesRenderer> seriesRenderList =
            _chartState._chartSeries.visibleSeriesRenderers;
        final CartesianSeriesRenderer seriesRender =
            seriesRenderList[seriesIndex!];
        selected = pointIndex != null;
        viewportIndex = _getVisibleDataPointIndex(pointIndex, seriesRender);
        final String seriesType = seriesRenderer._seriesType;
        final SelectionBehaviorRenderer selectionBehaviorRenderer =
            seriesRenderer._selectionBehaviorRenderer;
        selectionBehaviorRenderer._selectionRenderer!._isInteraction = true;
        if (_isLineTypeSeries(seriesType) ||
            seriesType.contains('hilo') ||
            seriesType == 'candle' ||
            seriesType.contains('boxandwhisker')) {
          if (seriesRenderer._isSelectionEnable = true) {
            selectionBehaviorRenderer._selectionRenderer!.cartesianPointIndex =
                pointIndex;
            selectionBehaviorRenderer._selectionRenderer!.cartesianSeriesIndex =
                seriesIndex;
            select = selectionBehaviorRenderer._selectionRenderer!
                .isCartesianSelection(
                    chart, seriesRender, pointIndex, seriesIndex);
          }
        } else {
          _chartState._renderDatalabelRegions = <Rect>[];
          if (seriesType.contains('area') || seriesType == 'fastline') {
            selectionBehaviorRenderer._selectionRenderer!.seriesIndex =
                seriesIndex;
          } else {
            selectionBehaviorRenderer._selectionRenderer!.seriesIndex =
                seriesIndex;
            selectionBehaviorRenderer._selectionRenderer!.pointIndex =
                pointIndex;
          }
          select = selectionBehaviorRenderer._selectionRenderer!
              .isCartesianSelection(
                  chart, seriesRender, pointIndex, seriesIndex);
        }
        if (select) {
          for (final CartesianSeriesRenderer _seriesRenderer
              in _chartState._chartSeries.visibleSeriesRenderers) {
            ValueNotifier<int>(_seriesRenderer._repaintNotifier.value++);
          }
        }
        selectionType = null;
      }
    } else if (chart is SfCircularChart) {
      if (_validIndex(pointIndex!, seriesIndex!, chart)) {
        _chartState._chartSeries._seriesPointSelection(
            null, chart.selectionGesture, pointIndex, seriesIndex);
      }
    } else if (chart is SfFunnelChart) {
      if (pointIndex! < chart.series.dataSource.length) {
        seriesRenderer._chartState!._chartSeries
            ._seriesPointSelection(pointIndex, chart.selectionGesture);
      }
    } else {
      if (pointIndex! < chart.series.dataSource.length) {
        seriesRenderer._chartState!._chartSeries
            ._seriesPointSelection(pointIndex, chart.selectionGesture);
      }
    }
  }

  /// selection for selected dataPoint index
  void selectedDataPointIndex(
      CartesianSeriesRenderer seriesRenderer, List<int> selectedData) {
    for (int data = 0; data < selectedData.length; data++) {
      final int selectedItem = selectedData[data];
      if (chart.onSelectionChanged != null) {}
      for (int j = 0; j < seriesRenderer._segments.length; j++) {
        currentSegment = seriesRenderer._segments[j];
        currentSegment!.currentSegmentIndex == selectedItem
            ? selectedSegments.add(seriesRenderer._segments[j])
            : unselectedSegments!.add(seriesRenderer._segments[j]);
      }
    }
    _selectedSegmentsColors(selectedSegments);
    _unselectedSegmentsColors(unselectedSegments!);
  }

  ///Paint method for default fill color settings
  Paint getDefaultFillColor(List<CartesianChartPoint<dynamic>>? points,
      int? point, ChartSegment segment) {
    final String seriesType = seriesRenderer._seriesType;
    final Paint selectedFillPaint = Paint();
    if (seriesRenderer._series is CartesianSeries) {
      seriesRenderer._seriesType == 'line' ||
              seriesType == 'spline' ||
              seriesType == 'stepline' ||
              seriesType == 'fastline' ||
              seriesType == 'stackedline' ||
              seriesType == 'stackedline100' ||
              seriesType.contains('hilo')
          ? selectedFillPaint.color = segment._defaultStrokeColor!.color
          : selectedFillPaint.color = segment._defaultFillColor!.color;
      if (segment._defaultFillColor?.shader != null) {
        selectedFillPaint.shader = segment._defaultFillColor!.shader;
      }
    }

    if (seriesRenderer._seriesType == 'candle') {
      if (segment is CandleSegment && segment._isSolid) {
        selectedFillPaint.style = PaintingStyle.fill;
        selectedFillPaint.strokeWidth = seriesRenderer._series.borderWidth;
      } else {
        selectedFillPaint.style = PaintingStyle.stroke;
        selectedFillPaint.strokeWidth = seriesRenderer._series.borderWidth;
      }
    } else {
      selectedFillPaint.style = PaintingStyle.fill;
    }
    return selectedFillPaint;
  }

  ///Paint method for default stroke color settings
  Paint getDefaultStrokeColor(List<CartesianChartPoint<dynamic>>? points,
      int? point, ChartSegment segment) {
    final Paint selectedStrokePaint = Paint();
    if (seriesRenderer._series is CartesianSeries) {
      selectedStrokePaint.color = segment._defaultStrokeColor!.color;
      selectedStrokePaint.strokeWidth =
          segment._defaultStrokeColor!.strokeWidth;
    }
    selectedStrokePaint.style = PaintingStyle.stroke;
    return selectedStrokePaint;
  }

  /// Paint method with selected fill color values
  Paint getFillColor(bool isSelection, ChartSegment segment) {
    final dynamic selectionBehavior = seriesRenderer._selectionBehavior;
    final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
    assert(
        ((selectionBehavior.selectedOpacity != null) == false) ||
            selectionBehavior.selectedOpacity >= 0 == true &&
                selectionBehavior.selectedOpacity <= 1 == true,
        'The selected opacity of selection settings should between 0 and 1.');
    assert(
        ((selectionBehavior.unselectedOpacity != null) == false) ||
            selectionBehavior.unselectedOpacity >= 0 == true &&
                selectionBehavior.unselectedOpacity <= 1 == true,
        'The unselected opacity of selection settings should between 0 and 1.');
    final ChartSelectionCallback? chartEventSelection =
        chart.onSelectionChanged;
    if (isSelection) {
      if (series is CartesianSeries) {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs!.selectedColor != null
            ? selectionArgs!.selectedColor
            : _chartState._selectionArgs != null &&
                    _chartState._selectionArgs!.selectedColor != null
                ? _chartState._selectionArgs!.selectedColor
                : selectionBehavior.selectedColor ??
                    segment._defaultFillColor!.color;
      }
      fillOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.selectedColor != null
          ? selectionArgs!.selectedColor!.opacity
          : _chartState._selectionArgs != null &&
                  _chartState._selectionArgs!.selectedColor != null
              ? _chartState._selectionArgs!.selectedColor.opacity
              : selectionBehavior.selectedOpacity ?? series.opacity;
    } else {
      if (series is CartesianSeries) {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs!.unselectedColor != null
            ? selectionArgs!.unselectedColor
            : _chartState._selectionArgs != null &&
                    _chartState._selectionArgs!.unselectedColor != null
                ? _chartState._selectionArgs!.unselectedColor
                : selectionBehavior.unselectedColor ??
                    segment._defaultFillColor!.color;
      }
      fillOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.unselectedColor != null
          ? selectionArgs!.unselectedColor!.opacity
          : _chartState._selectionArgs != null &&
                  _chartState._selectionArgs!.unselectedColor != null
              ? _chartState._selectionArgs!.unselectedColor.opacity
              : selectionBehavior.unselectedOpacity ?? series.opacity;
    }
    final Paint selectedFillPaint = Paint();
    selectedFillPaint.color = fillColor.withOpacity(fillOpacity);
    if (seriesRenderer._seriesType == 'candle') {
      if (segment is CandleSegment && segment._isSolid) {
        selectedFillPaint.style = PaintingStyle.fill;
        selectedFillPaint.strokeWidth = series.borderWidth;
      } else {
        selectedFillPaint.style = PaintingStyle.stroke;
        selectedFillPaint.strokeWidth = series.borderWidth;
      }
    } else {
      selectedFillPaint.style = PaintingStyle.fill;
    }
    return selectedFillPaint;
  }

  /// Paint method with selected stroke color values
  Paint getStrokeColor(bool isSelection, ChartSegment segment,
      [CartesianChartPoint<dynamic>? point]) {
    final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
    final String seriesType = seriesRenderer._seriesType;
    final dynamic selectionBehavior = seriesRenderer._selectionBehavior;
    final ChartSelectionCallback? chartEventSelection =
        chart.onSelectionChanged;
    if (isSelection) {
      if (series is CartesianSeries) {
        seriesType == 'line' ||
                seriesType == 'spline' ||
                seriesType == 'stepline' ||
                seriesType == 'fastline' ||
                seriesType == 'stackedline' ||
                seriesType == 'stackedline100' ||
                seriesType.contains('hilo') ||
                seriesType == 'candle' ||
                seriesType == 'boxandwhisker'
            ? strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.selectedColor != null
                ? selectionArgs!.selectedColor
                : _chartState._selectionArgs != null &&
                        _chartState._selectionArgs!.selectedColor != null
                    ? _chartState._selectionArgs!.selectedColor
                    : selectionBehavior.selectedColor ??
                        segment._defaultFillColor!.color
            : strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.selectedBorderColor != null
                ? selectionArgs!.selectedBorderColor
                : _chartState._selectionArgs != null &&
                        _chartState._selectionArgs!.selectedBorderColor != null
                    ? _chartState._selectionArgs!.selectedBorderColor
                    : selectionBehavior.selectedBorderColor ??
                        series.borderColor;
      }

      strokeOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.selectedBorderColor != null
          ? selectionArgs!.selectedBorderColor!.opacity
          : _chartState._selectionArgs != null &&
                  _chartState._selectionArgs!.selectedBorderColor != null
              ? _chartState._selectionArgs!.selectedBorderColor.opacity
              : selectionBehavior.selectedOpacity ?? series.opacity;

      strokeWidth = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.selectedBorderWidth != null
          ? selectionArgs!.selectedBorderWidth
          : _chartState._selectionArgs != null &&
                  _chartState._selectionArgs!.selectedBorderWidth != null
              ? _chartState._selectionArgs!.selectedBorderWidth
              : selectionBehavior.selectedBorderWidth ?? series.borderWidth;
    } else {
      if (series is CartesianSeries) {
        segment is LineSegment ||
                segment is SplineSegment ||
                segment is StepLineSegment ||
                segment is FastLineSegment ||
                segment is StackedLineSegment ||
                segment is HiloSegment ||
                segment is HiloOpenCloseSegment ||
                segment is CandleSegment ||
                segment is BoxAndWhiskerSegment
            ? strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.unselectedColor != null
                ? selectionArgs!.unselectedColor
                : _chartState._selectionArgs != null &&
                        _chartState._selectionArgs!.unselectedColor != null
                    ? _chartState._selectionArgs!.unselectedColor
                    : selectionBehavior.unselectedColor ??
                        segment._defaultFillColor!.color
            : strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.unselectedBorderColor != null
                ? selectionArgs!.unselectedBorderColor
                : _chartState._selectionArgs != null &&
                        _chartState._selectionArgs!.unselectedBorderColor !=
                            null
                    ? _chartState._selectionArgs!.unselectedBorderColor
                    : selectionBehavior.unselectedBorderColor ??
                        series.borderColor;
      }
      strokeOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.unselectedColor != null
          ? selectionArgs!.unselectedColor!.opacity
          : _chartState._selectionArgs != null &&
                  _chartState._selectionArgs!.unselectedColor != null
              ? _chartState._selectionArgs!.unselectedColor.opacity
              : selectionBehavior.unselectedOpacity ?? series.opacity;
      strokeWidth = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.unselectedBorderWidth != null
          ? selectionArgs!.unselectedBorderWidth
          : _chartState._selectionArgs != null &&
                  _chartState._selectionArgs!.unselectedBorderWidth != null
              ? _chartState._selectionArgs!.unselectedBorderWidth
              : selectionBehavior.unselectedBorderWidth ?? series.borderWidth;
    }
    final Paint selectedStrokePaint = Paint();
    selectedStrokePaint.color = strokeColor;
    selectedStrokePaint.strokeWidth = strokeWidth;
    selectedStrokePaint.color.withOpacity(series.opacity);
    selectedStrokePaint.style = PaintingStyle.stroke;
    return selectedStrokePaint;
  }

  /// Give selected color for selected segments
  void _selectedSegmentsColors(List<ChartSegment> selectedSegments) {
    for (int i = 0; i < selectedSegments.length; i++) {
      seriesRenderer = _chartState._chartSeries
          .visibleSeriesRenderers[selectedSegments[i]._seriesIndex];
      if (seriesRenderer._seriesType.contains('area') == false &&
          seriesRenderer._seriesType != 'fastline') {
        final ChartSegment currentSegment =
            seriesRenderer._segments[selectedSegments[i].currentSegmentIndex];
        final Paint fillPaint = getFillColor(true, currentSegment);
        currentSegment.fillPaint = seriesRenderer._selectionBehaviorRenderer
            .getSelectedItemFill(fillPaint, selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex, selectedSegments);
        final Paint strokePaint = getStrokeColor(true, currentSegment);
        currentSegment.strokePaint = seriesRenderer._selectionBehaviorRenderer
            .getSelectedItemBorder(
                strokePaint,
                selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getFillColor(true, currentSegment);
        currentSegment.fillPaint = seriesRenderer._selectionBehaviorRenderer
            .getSelectedItemFill(fillPaint, selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex, selectedSegments);
        final Paint strokePaint = getStrokeColor(true, currentSegment);
        currentSegment.strokePaint = seriesRenderer._selectionBehaviorRenderer
            .getSelectedItemBorder(
                strokePaint,
                selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
      }
    }
  }

  /// Give unselected color for unselected segments
  void _unselectedSegmentsColors(List<ChartSegment> unselectedSegments) {
    for (int i = 0; i < unselectedSegments.length; i++) {
      seriesRenderer = _chartState._chartSeries
          .visibleSeriesRenderers[unselectedSegments[i]._seriesIndex];
      if (seriesRenderer._seriesType.contains('area') == false &&
          seriesRenderer._seriesType != 'fastline') {
        final ChartSegment currentSegment =
            seriesRenderer._segments[unselectedSegments[i].currentSegmentIndex];
        final Paint fillPaint = getFillColor(false, currentSegment);
        currentSegment.fillPaint = seriesRenderer._selectionBehaviorRenderer
            .getUnselectedItemFill(
                fillPaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
        final Paint strokePaint = getStrokeColor(false, currentSegment);
        currentSegment.strokePaint = seriesRenderer._selectionBehaviorRenderer
            .getUnselectedItemBorder(
                strokePaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getFillColor(false, currentSegment);
        currentSegment.fillPaint = seriesRenderer._selectionBehaviorRenderer
            .getUnselectedItemFill(
                fillPaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
        final Paint strokePaint = getStrokeColor(false, currentSegment);
        currentSegment.strokePaint = seriesRenderer._selectionBehaviorRenderer
            .getUnselectedItemBorder(
                strokePaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
      }
    }
  }

  /// change color and removing unselected segments from list
  void changeColorAndPopUnselectedSegments(
      List<ChartSegment> unselectedSegments) {
    int k = unselectedSegments.length - 1;
    while (unselectedSegments.isNotEmpty) {
      seriesRenderer = _chartState._chartSeries
          .visibleSeriesRenderers[unselectedSegments[k]._seriesIndex];
      if (seriesRenderer._seriesType.contains('area') == false &&
          seriesRenderer._seriesType != 'fastline') {
        if (unselectedSegments[k].currentSegmentIndex! <
            seriesRenderer._segments.length) {
          final ChartSegment currentSegment = seriesRenderer
              ._segments[unselectedSegments[k].currentSegmentIndex];
          final Paint fillPaint =
              getDefaultFillColor(null, null, currentSegment);
          currentSegment.fillPaint = fillPaint;
          final Paint strokePaint =
              getDefaultStrokeColor(null, null, currentSegment);
          currentSegment.strokePaint = strokePaint;
        }
        unselectedSegments.remove(unselectedSegments[k]);
        k--;
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        unselectedSegments.remove(unselectedSegments[0]);
        k--;
      }
    }
  }

  /// change color and remove selected segments from list
  bool changeColorAndPopSelectedSegments(
      List<ChartSegment> selectedSegments, bool isSamePointSelect) {
    int j = selectedSegments.length - 1;
    while (selectedSegments.isNotEmpty) {
      seriesRenderer = _chartState._chartSeries
          .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
      if (seriesRenderer._seriesType.contains('area') == false &&
          seriesRenderer._seriesType != 'fastline') {
        if (selectedSegments[j].currentSegmentIndex! <
            seriesRenderer._segments.length) {
          final ChartSegment currentSegment =
              seriesRenderer._segments[selectedSegments[j].currentSegmentIndex];
          final Paint fillPaint =
              getDefaultFillColor(null, null, currentSegment);
          currentSegment.fillPaint = fillPaint;
          final Paint strokePaint =
              getDefaultStrokeColor(null, null, currentSegment);
          currentSegment.strokePaint = strokePaint;
          if (seriesRenderer._seriesType == 'line' ||
              seriesRenderer._seriesType == 'spline' ||
              seriesRenderer._seriesType == 'stepline' ||
              seriesRenderer._seriesType == 'stackedline' ||
              seriesRenderer._seriesType == 'stackedline100' ||
              seriesRenderer._seriesType.contains('hilo') == true ||
              seriesRenderer._seriesType == 'candle' ||
              seriesRenderer._seriesType.contains('boxandwhisker') == true) {
            if (selectedSegments[j]._currentPoint!.overallDataPointIndex ==
                    cartesianPointIndex &&
                selectedSegments[j]._seriesIndex == cartesianSeriesIndex) {
              isSamePointSelect = true;
            }
          } else {
            if ((currentSegment._currentPoint!.overallDataPointIndex ==
                        pointIndex ||
                    selectedSegments[j]._currentPoint!.overallDataPointIndex ==
                        pointIndex) &&
                currentSegment._oldSegmentIndex ==
                    selectedSegments[j]._oldSegmentIndex &&
                selectedSegments[j]._seriesIndex == seriesIndex) {
              isSamePointSelect = true;
            }
          }
        }
        selectedSegments.remove(selectedSegments[j]);
        j--;
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        if (selectedSegments[0]._seriesIndex == seriesIndex) {
          isSamePointSelect = true;
        }
        selectedSegments.remove(selectedSegments[0]);
        j--;
      }
    }
    return isSamePointSelect;
  }

  bool _isSamePointSelected(List<ChartSegment> selectedSegments) {
    bool isSamePointSelected = false;
    for (int j = 0;
        j < selectedSegments.length && selectedSegments.isNotEmpty;
        j++) {
      seriesRenderer = _chartState._chartSeries
          .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
      if (seriesRenderer._seriesType.contains('area') == false &&
          seriesRenderer._seriesType != 'fastline') {
        if (selectedSegments[j].currentSegmentIndex! <
            seriesRenderer._segments.length) {
          final ChartSegment currentSegment =
              seriesRenderer._segments[selectedSegments[j].currentSegmentIndex];
          if (((seriesRenderer._seriesType.indexOf('line') >= 0) == true ||
                  seriesRenderer._seriesType.contains('hilo') == true ||
                  seriesRenderer._seriesType == 'candle' ||
                  seriesRenderer._seriesType.contains('boxandwhisker') ==
                      true) &&
              selectedSegments[j]._currentPoint!.overallDataPointIndex ==
                  cartesianPointIndex &&
              selectedSegments[j]._seriesIndex == cartesianSeriesIndex) {
            isSamePointSelected = true;
          } else {
            if ((currentSegment._currentPoint!.overallDataPointIndex ==
                        pointIndex ||
                    selectedSegments[j]._currentPoint!.overallDataPointIndex ==
                        pointIndex) &&
                currentSegment._oldSegmentIndex ==
                    selectedSegments[j]._oldSegmentIndex &&
                selectedSegments[j]._seriesIndex == seriesIndex) {
              isSamePointSelected = true;
            }
          }
        }
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        if (selectedSegments[0]._seriesIndex == seriesIndex) {
          isSamePointSelected = true;
        }
      }
    }
    return isSamePointSelected;
  }

  ChartSegment? getTappedSegment() {
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          _chartState._chartSeries.visibleSeriesRenderers[i];
      for (int k = 0; k < seriesRenderer._segments.length; k++) {
        if (!seriesRenderer._seriesType.contains('area') &&
            seriesRenderer._seriesType != 'fastline') {
          currentSegment = seriesRenderer._segments[k];
          if (seriesRenderer._seriesType == 'line' ||
              seriesRenderer._seriesType == 'spline' ||
              seriesRenderer._seriesType == 'stepline' ||
              seriesRenderer._seriesType == 'stackedline' ||
              seriesRenderer._seriesType == 'stackedline100' ||
              seriesRenderer._seriesType.contains('hilo') ||
              seriesRenderer._seriesType == 'candle' ||
              seriesRenderer._seriesType.contains('boxandwhisker')) {
            if (currentSegment!.currentSegmentIndex == cartesianPointIndex &&
                currentSegment!._seriesIndex == cartesianSeriesIndex) {
              selectedSegment = seriesRenderer._segments[k];
            }
          } else {
            if (currentSegment!._currentPoint!.overallDataPointIndex ==
                    pointIndex &&
                currentSegment!._seriesIndex == seriesIndex) {
              selectedSegment = seriesRenderer._segments[k];
            }
          }
        } else {
          currentSegment = seriesRenderer._segments[0];
          if (currentSegment!._seriesIndex == seriesIndex) {
            selectedSegment = seriesRenderer._segments[0];
            break;
          }
        }
      }
    }
    return selectedSegment;
  }

  bool checkPosition() {
    outerLoop:
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          _chartState._chartSeries.visibleSeriesRenderers[i];
      for (int k = 0; k < seriesRenderer._segments.length; k++) {
        currentSegment = seriesRenderer._segments[k];
        if ((currentSegment!._currentPoint!.overallDataPointIndex ==
                pointIndex) &&
            currentSegment!._seriesIndex == seriesIndex) {
          isSelected = true;
          break outerLoop;
        } else {
          isSelected = false;
        }
      }
    }
    return isSelected;
  }

  /// To ensure selection for cartesian chart type
  bool isCartesianSelection(SfCartesianChart chartAssign,
      CartesianSeriesRenderer seriesAssign, int? pointIndex, int? seriesIndex) {
    chart = chartAssign;
    seriesRenderer = seriesAssign;

    if (chart.onSelectionChanged != null &&
        selected &&
        (!(seriesRenderer._selectionBehavior.toggleSelection == false &&
            _isSamePointSelected(selectedSegments)))) {
      chart.onSelectionChanged(getSelectionEventArgs(seriesRenderer._series,
          seriesIndex!, viewportIndex!, seriesRenderer));
      selected = false;
    }

    /// Maintained the event arguments on zooming, device orientation change.
    if (selectionArgs != null) {
      _chartState._selectionArgs = selectionArgs;
    }

    /// For point mode
    if ((selectionType ?? chart.selectionType) == SelectionType.point) {
      if (!(seriesRenderer._selectionBehavior.toggleSelection == false &&
          _isSamePointSelected(selectedSegments))) {
        bool isSamePointSelect = false;

        /// UnSelecting the last selected segment
        if (selectedSegments.length == 1) {
          changeColorAndPopUnselectedSegments(unselectedSegments!);
        }

        /// Executes when multiSelection is enabled
        bool multiSelect = false;
        if (chart.enableMultiSelection == true) {
          if (selectedSegments.isNotEmpty) {
            for (int i =
                    _chartState._chartSeries.visibleSeriesRenderers.length - 1;
                i >= 0;
                i--) {
              final CartesianSeriesRenderer seriesRenderer =
                  _chartState._chartSeries.visibleSeriesRenderers[i];

              /// To identify the tapped segment
              for (int k = 0; k < seriesRenderer._segments.length; k++) {
                currentSegment = seriesRenderer._segments[k];
                if ((currentSegment!._currentPoint!.overallDataPointIndex ==
                        pointIndex) &&
                    currentSegment!._seriesIndex == seriesIndex) {
                  selectedSegment = seriesRenderer._segments[k];
                  break;
                }
              }
            }

            /// To identify that tapped segment in any one of the selected segment
            if (selectedSegment != null) {
              for (int k = 0; k < selectedSegments.length; k++) {
                if ((selectedSegment!.currentSegmentIndex ==
                            selectedSegments[k].currentSegmentIndex ||
                        selectedSegment!._currentPoint!.overallDataPointIndex ==
                            selectedSegments[k]
                                ._currentPoint!
                                .overallDataPointIndex) &&
                    selectedSegment!._seriesIndex ==
                        selectedSegments[k]._seriesIndex) {
                  multiSelect = true;
                  break;
                }
              }
            }

            /// Executes when tapped again in one of the selected segments
            if (multiSelect) {
              for (int j = selectedSegments.length - 1; j >= 0; j--) {
                seriesRenderer = _chartState._chartSeries
                    .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
                final ChartSegment currentSegment = seriesRenderer
                    ._segments[selectedSegments[j].currentSegmentIndex];

                /// Applying default settings when last selected segment becomes unselected
                if (((selectedSegment!.currentSegmentIndex ==
                                selectedSegments[j].currentSegmentIndex ||
                            selectedSegment!
                                    ._currentPoint!.overallDataPointIndex ==
                                selectedSegments[j]
                                    ._currentPoint!
                                    .overallDataPointIndex) &&
                        selectedSegment!._seriesIndex ==
                            selectedSegments[j]._seriesIndex) &&
                    (selectedSegments.length == 1)) {
                  final Paint fillPaint =
                      getDefaultFillColor(null, null, currentSegment);
                  final Paint strokePaint =
                      getDefaultStrokeColor(null, null, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;

                  if ((currentSegment._currentPoint!.overallDataPointIndex ==
                              pointIndex ||
                          selectedSegments[j]
                                  ._currentPoint!
                                  .overallDataPointIndex ==
                              pointIndex) &&
                      selectedSegments[j]._seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }
                  selectedSegments.remove(selectedSegments[j]);
                }

                /// Applying unselected color for unselected segments in multiSelect option
                else if ((selectedSegment!
                            ._currentPoint!.overallDataPointIndex ==
                        selectedSegments[j]
                            ._currentPoint!
                            .overallDataPointIndex) &&
                    selectedSegment!._seriesIndex ==
                        selectedSegments[j]._seriesIndex) {
                  final Paint fillPaint = getFillColor(false, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  final Paint strokePaint =
                      getStrokeColor(false, currentSegment);
                  currentSegment.strokePaint = strokePaint;

                  if ((currentSegment._currentPoint!.overallDataPointIndex ==
                              pointIndex ||
                          selectedSegments[j]
                                  ._currentPoint!
                                  .overallDataPointIndex ==
                              pointIndex) &&
                      selectedSegments[j]._seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }
                  unselectedSegments!.add(selectedSegments[j]);
                  selectedSegments.remove(selectedSegments[j]);
                }
              }
            }
          }
        } else {
          unselectedSegments?.clear();
          isSamePointSelect = changeColorAndPopSelectedSegments(
              selectedSegments, isSamePointSelect);
        }

        /// To check that the selection setting is enable or not
        if (seriesRenderer._isSelectionEnable == true) {
          if (!isSamePointSelect) {
            seriesRenderer._seriesType == 'column' ||
                    seriesRenderer._seriesType == 'bar' ||
                    seriesRenderer._seriesType == 'scatter' ||
                    seriesRenderer._seriesType == 'bubble' ||
                    seriesRenderer._seriesType.contains('stackedcolumn') ==
                        true ||
                    seriesRenderer._seriesType.contains('stackedbar') == true ||
                    seriesRenderer._seriesType == 'rangecolumn' ||
                    seriesRenderer._seriesType == 'waterfall'
                ? isSelected = checkPosition()
                : isSelected = true;
            unselectedSegments?.clear();
            for (int i =
                    _chartState._chartSeries.visibleSeriesRenderers.length - 1;
                i >= 0;
                i--) {
              final CartesianSeriesRenderer seriesRenderer =
                  _chartState._chartSeries.visibleSeriesRenderers[i];
              if (isSelected) {
                for (int j = 0; j < seriesRenderer._segments.length; j++) {
                  currentSegment = seriesRenderer._segments[j];
                  if (currentSegment!.currentSegmentIndex == null ||
                      pointIndex == null) {
                    break;
                  }
                  (seriesRenderer._seriesType.contains('area')
                              ? currentSegment!.currentSegmentIndex ==
                                  pointIndex
                              : currentSegment!
                                      ._currentPoint!.overallDataPointIndex ==
                                  pointIndex) &&
                          currentSegment!._seriesIndex == seriesIndex
                      ? selectedSegments.add(seriesRenderer._segments[j])
                      : unselectedSegments!.add(seriesRenderer._segments[j]);
                }

                /// Giving color to unselected segments
                _unselectedSegmentsColors(unselectedSegments!);

                /// Giving Color to selected segments
                _selectedSegmentsColors(selectedSegments);
              }
            }
          } else {
            isSelected = true;
          }
        }
      }
    }

    ///For Series Mode
    else if ((selectionType ?? chart.selectionType) == SelectionType.series) {
      if (!(seriesRenderer._selectionBehavior.toggleSelection == false &&
          _isSamePointSelected(selectedSegments))) {
        bool isSamePointSelect = false;

        for (int i = 0;
            i < _chartState._chartSeries.visibleSeriesRenderers.length;
            i++) {
          final CartesianSeriesRenderer seriesRenderer =
              _chartState._chartSeries.visibleSeriesRenderers[i];
          for (int k = 0; k < seriesRenderer._segments.length; k++) {
            currentSegment = seriesRenderer._segments[k];
            final ChartSegment compareSegment = seriesRenderer._segments[k];
            if (currentSegment!.currentSegmentIndex !=
                    compareSegment.currentSegmentIndex &&
                currentSegment!._seriesIndex != compareSegment._seriesIndex) {
              isSelected = false;
            }
          }
        }

        /// Executes only when final selected segment became unselected
        if (selectedSegments.length == seriesRenderer._segments.length) {
          changeColorAndPopUnselectedSegments(unselectedSegments!);
        }

        /// Executes when multiSelect option is enabled
        bool multiSelect = false;
        if (chart.enableMultiSelection == true) {
          if (selectedSegments.isNotEmpty) {
            selectedSegment = getTappedSegment();

            /// To identify that tapped again in any one of the selected segments
            if (selectedSegment != null) {
              for (int k = 0; k < selectedSegments.length; k++) {
                if (seriesIndex == selectedSegments[k]._seriesIndex) {
                  multiSelect = true;
                  break;
                }
              }
            }

            /// Executes when tapped again in one of the selected segments
            if (multiSelect) {
              ChartSegment currentSegment;
              for (int j = selectedSegments.length - 1; j >= 0; j--) {
                seriesRenderer = _chartState._chartSeries
                    .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];

                currentSegment =
                    (seriesRenderer._seriesType.contains('area') == false &&
                            seriesRenderer._seriesType != 'fastline')
                        ? seriesRenderer
                            ._segments[selectedSegments[j].currentSegmentIndex]
                        : seriesRenderer._segments[0];

                /// Applying series fill when all last selected segment becomes unselected
                if (seriesRenderer._seriesType.contains('area') == false &&
                    seriesRenderer._seriesType != 'fastline') {
                  if ((selectedSegment!._seriesIndex ==
                          selectedSegments[j]._seriesIndex) &&
                      (selectedSegments.length <=
                          seriesRenderer._segments.length)) {
                    final Paint fillPaint =
                        getDefaultFillColor(null, null, currentSegment);
                    final Paint strokePaint =
                        getDefaultStrokeColor(null, null, currentSegment);
                    currentSegment.fillPaint = fillPaint;
                    currentSegment.strokePaint = strokePaint;
                    if (selectedSegments[j]
                                ._currentPoint!
                                .overallDataPointIndex ==
                            pointIndex &&
                        selectedSegments[j]._seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    selectedSegments.remove(selectedSegments[j]);
                  }

                  /// Applying unselected color for unselected segments in multiSelect option
                  else if (selectedSegment!._seriesIndex ==
                      selectedSegments[j]._seriesIndex) {
                    final Paint fillPaint = getFillColor(false, currentSegment);
                    final Paint strokePaint =
                        getStrokeColor(false, currentSegment);
                    currentSegment.fillPaint = fillPaint;
                    currentSegment.strokePaint = strokePaint;
                    if (selectedSegments[j]
                                ._currentPoint!
                                .overallDataPointIndex ==
                            pointIndex &&
                        selectedSegments[j]._seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    unselectedSegments!.add(selectedSegments[j]);
                    selectedSegments.remove(selectedSegments[j]);
                  }
                } else {
                  if ((selectedSegment!._seriesIndex ==
                          selectedSegments[j]._seriesIndex) &&
                      (selectedSegments.length <=
                          seriesRenderer._segments.length)) {
                    final Paint fillPaint =
                        getDefaultFillColor(null, null, currentSegment);
                    final Paint strokePaint =
                        getDefaultStrokeColor(null, null, currentSegment);
                    currentSegment.fillPaint = fillPaint;
                    currentSegment.strokePaint = strokePaint;
                    if (selectedSegments[j]._seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    selectedSegments.remove(selectedSegments[j]);
                  }

                  /// Applying unselected color for unselected segments in multiSelect option
                  else if (selectedSegment!._seriesIndex ==
                      selectedSegments[j]._seriesIndex) {
                    final Paint fillPaint = getFillColor(false, currentSegment);
                    final Paint strokePaint =
                        getStrokeColor(false, currentSegment);
                    currentSegment.fillPaint = fillPaint;
                    currentSegment.strokePaint = strokePaint;
                    if (selectedSegments[j]._seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    unselectedSegments!.add(selectedSegments[j]);
                    selectedSegments.remove(selectedSegments[j]);
                  }
                }
              }
            }
          }
        } else {
          ///Executes when multiSelect is not enable
          unselectedSegments?.clear();
          isSamePointSelect = changeColorAndPopSelectedSegments(
              selectedSegments, isSamePointSelect);
        }

        /// To identify the Tapped segment
        if (seriesRenderer._isSelectionEnable == true) {
          if (!isSamePointSelect) {
            seriesRenderer._seriesType == 'column' ||
                    seriesRenderer._seriesType == 'bar' ||
                    seriesRenderer._seriesType == 'scatter' ||
                    seriesRenderer._seriesType == 'bubble' ||
                    seriesRenderer._seriesType.contains('stackedcolumn') ==
                        true ||
                    seriesRenderer._seriesType.contains('stackedbar') == true ||
                    seriesRenderer._seriesType == 'rangecolumn' ||
                    seriesRenderer._seriesType == 'waterfall'
                ? isSelected = checkPosition()
                : isSelected = true;
            selectedSegment = getTappedSegment();
            if (isSelected) {
              /// To Push the Selected and Unselected segment
              for (int i = 0;
                  i < _chartState._chartSeries.visibleSeriesRenderers.length;
                  i++) {
                final CartesianSeriesRenderer seriesRenderer =
                    _chartState._chartSeries.visibleSeriesRenderers[i];
                if (!seriesRenderer._seriesType.contains('area') &&
                    seriesRenderer._seriesType != 'fastline') {
                  if (seriesIndex != null) {
                    for (int k = 0; k < seriesRenderer._segments.length; k++) {
                      currentSegment = seriesRenderer._segments[k];
                      currentSegment!._seriesIndex == seriesIndex
                          ? selectedSegments.add(seriesRenderer._segments[k])
                          : unselectedSegments!
                              .add(seriesRenderer._segments[k]);
                    }
                  }
                } else {
                  currentSegment = seriesRenderer._segments[0];
                  currentSegment!._seriesIndex == seriesIndex
                      ? selectedSegments.add(seriesRenderer._segments[0])
                      : unselectedSegments!.add(seriesRenderer._segments[0]);
                }

                /// Give Color to the Unselected segment
                _unselectedSegmentsColors(unselectedSegments!);

                /// Give Color to the Selected segment
                _selectedSegmentsColors(selectedSegments);
              }
            }
          } else {
            isSelected = true;
          }
        }
      }
    }

    /// For Cluster Mode
    else if ((selectionType ?? chart.selectionType) == SelectionType.cluster) {
      if (!(seriesRenderer._selectionBehavior.toggleSelection == false &&
          _isSamePointSelected(selectedSegments))) {
        bool isSamePointSelect = false;

        /// Executes only when last selected segment became unselected
        if (selectedSegments.length ==
            _chartState._chartSeries.visibleSeriesRenderers.length) {
          changeColorAndPopUnselectedSegments(unselectedSegments!);
        }

        /// Executes when multiSelect option is enabled
        bool multiSelect = false;
        if (chart.enableMultiSelection == true) {
          if (selectedSegments.isNotEmpty) {
            selectedSegment = getTappedSegment();

            /// To identify that tapped again in any one of the selected segment
            if (selectedSegment != null) {
              for (int k = 0; k < selectedSegments.length; k++) {
                if (selectedSegment!.currentSegmentIndex ==
                    selectedSegments[k].currentSegmentIndex) {
                  multiSelect = true;
                  break;
                }
              }
            }

            /// Executes when tapped again in one of the selected segment
            if (multiSelect) {
              for (int j = selectedSegments.length - 1; j >= 0; j--) {
                seriesRenderer = _chartState._chartSeries
                    .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
                final ChartSegment currentSegment = seriesRenderer
                    ._segments[selectedSegments[j].currentSegmentIndex];

                /// Applying default settings when last selected segment becomes unselected
                if ((selectedSegment!.currentSegmentIndex ==
                        selectedSegments[j].currentSegmentIndex) &&
                    (selectedSegments.length <=
                        _chartState
                            ._chartSeries.visibleSeriesRenderers.length)) {
                  final Paint fillPaint =
                      getDefaultFillColor(null, null, currentSegment);
                  final Paint strokePaint =
                      getDefaultStrokeColor(null, null, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;

                  if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                      selectedSegments[j]._seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }
                  // if(isSamePointSelect == false && )
                  selectedSegments.remove(selectedSegments[j]);
                }

                /// Applying unselected color for unselected segment in multiSelect option
                else if (selectedSegment!.currentSegmentIndex ==
                    selectedSegments[j].currentSegmentIndex) {
                  final Paint fillPaint = getFillColor(false, currentSegment);
                  final Paint strokePaint =
                      getStrokeColor(false, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;

                  if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                      selectedSegments[j]._seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }

                  unselectedSegments!.add(selectedSegments[j]);
                  selectedSegments.remove(selectedSegments[j]);
                }
              }
            }
          }
        } else {
          unselectedSegments?.clear();

          ///Executes when multiSelect is not enable
          isSamePointSelect = changeColorAndPopSelectedSegments(
              selectedSegments, isSamePointSelect);
        }

        /// To identify the Tapped segment
        if (seriesRenderer._isSelectionEnable == true) {
          if (!isSamePointSelect) {
            final bool isSegmentSeries = seriesRenderer._seriesType ==
                    'column' ||
                seriesRenderer._seriesType == 'bar' ||
                seriesRenderer._seriesType == 'scatter' ||
                seriesRenderer._seriesType == 'bubble' ||
                seriesRenderer._seriesType.contains('stackedcolumn') == true ||
                seriesRenderer._seriesType.contains('stackedbar') == true ||
                seriesRenderer._seriesType == 'rangecolumn' ||
                seriesRenderer._seriesType == 'waterfall';
            selectedSegment = getTappedSegment();
            isSegmentSeries ? isSelected = checkPosition() : isSelected = true;
            if (isSelected) {
              /// To Push the Selected and Unselected segments
              for (int i = 0;
                  i < _chartState._chartSeries.visibleSeriesRenderers.length;
                  i++) {
                final CartesianSeriesRenderer seriesRenderer =
                    _chartState._chartSeries.visibleSeriesRenderers[i];
                if (currentSegment!.currentSegmentIndex == null ||
                    pointIndex == null) {
                  break;
                }
                for (int k = 0; k < seriesRenderer._segments.length; k++) {
                  currentSegment = seriesRenderer._segments[k];

                  if (isSegmentSeries) {
                    currentSegment!._currentPoint!.xValue ==
                            selectedSegment!._currentPoint!.xValue
                        ? selectedSegments.add(seriesRenderer._segments[k])
                        : unselectedSegments!.add(seriesRenderer._segments[k]);
                  } else {
                    currentSegment!.currentSegmentIndex ==
                            selectedSegment!.currentSegmentIndex
                        ? selectedSegments.add(seriesRenderer._segments[k])
                        : unselectedSegments!.add(seriesRenderer._segments[k]);
                  }
                }
              }

              /// Giving color to unselected segments
              _unselectedSegmentsColors(unselectedSegments!);

              /// Giving Color to selected segments
              _selectedSegmentsColors(selectedSegments);
            }
          } else {
            isSelected = true;
          }
        }
      }
    }
    return isSelected;
  }

// To get point index and series index
  void getPointAndSeriesIndex(SfCartesianChart chart, Offset position,
      CartesianSeriesRenderer seriesRenderer) {
    final SelectionBehaviorRenderer? selectionBehaviorRenderer =
        seriesRenderer._selectionBehaviorRenderer;
    if (selectionBehaviorRenderer == null) {
      return;
    }
    ChartSegment currentSegment;
    ChartSegment? selectedSegment;
    for (int k = 0; k < seriesRenderer._segments.length; k++) {
      currentSegment = seriesRenderer._segments[k];
      if (currentSegment._segmentRect!.contains(position)) {
        selected = true;
        selectedSegment = seriesRenderer._segments[k];
        viewportIndex = selectedSegment._currentPoint?.visiblePointIndex;
      }
    }
    if (selectedSegment == null) {
      selectionBehaviorRenderer._selectionRenderer!.pointIndex = null;
      selectionBehaviorRenderer._selectionRenderer!.seriesIndex = null;
    } else {
      selectionBehaviorRenderer._selectionRenderer!.pointIndex =
          selectedSegment._currentPoint?.overallDataPointIndex;
      selectionBehaviorRenderer._selectionRenderer!.seriesIndex =
          selectedSegment._seriesIndex;
    }
  }

// To check that touch point is lies in segment
  bool isLineIntersect(
      CartesianChartPoint<dynamic> segmentStartPoint,
      CartesianChartPoint<dynamic> segmentEndPoint,
      CartesianChartPoint<dynamic> touchStartPoint,
      CartesianChartPoint<dynamic> touchEndPoint) {
    final int topPos =
        getPointDirection(segmentStartPoint, segmentEndPoint, touchStartPoint);
    final int botPos =
        getPointDirection(segmentStartPoint, segmentEndPoint, touchEndPoint);
    final int leftPos =
        getPointDirection(touchStartPoint, touchEndPoint, segmentStartPoint);
    final int rightPos =
        getPointDirection(touchStartPoint, touchEndPoint, segmentEndPoint);

    return topPos != botPos && leftPos != rightPos;
  }

  /// To get the segment points direction
  static int getPointDirection(
      CartesianChartPoint<dynamic> point1,
      CartesianChartPoint<dynamic> point2,
      CartesianChartPoint<dynamic> point3) {
    final int value = (((point2.y - point1.y) * (point3.x - point2.x)) -
            ((point2.x - point1.x) * (point3.y - point2.y)))
        .toInt();

    if (value == 0) {
      return 0;
    }

    return (value > 0) ? 1 : 2;
  }

  /// To identify that series contains a given point
  bool _isSeriesContainsPoint(
      CartesianSeriesRenderer seriesRenderer, Offset position) {
    int? dataPointIndex;
    ChartSegment? startSegment;
    ChartSegment? endSegment;
    final List<CartesianChartPoint<dynamic>>? nearestDataPoints =
        _getNearestChartPoints(
            position.dx,
            position.dy,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            seriesRenderer);
    if (nearestDataPoints == null) {
      return false;
    }
    for (final CartesianChartPoint<dynamic> dataPoint in nearestDataPoints) {
      dataPointIndex = seriesRenderer
          ._dataPoints[seriesRenderer._dataPoints.indexOf(dataPoint)]
          .visiblePointIndex;
    }

    if (dataPointIndex != null && seriesRenderer._segments.isNotEmpty) {
      if (seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType == 'candle' ||
          seriesRenderer._seriesType.contains('boxandwhisker')) {
        startSegment = seriesRenderer._segments[dataPointIndex];
      } else {
        if (dataPointIndex == 0 &&
            dataPointIndex < seriesRenderer._segments.length) {
          startSegment = seriesRenderer._segments[dataPointIndex];
        } else if (dataPointIndex == seriesRenderer._dataPoints.length - 1 &&
            dataPointIndex - 1 < seriesRenderer._segments.length) {
          startSegment = seriesRenderer._segments[dataPointIndex - 1];
        } else {
          if (dataPointIndex - 1 < seriesRenderer._segments.length) {
            startSegment = seriesRenderer._segments[dataPointIndex - 1];
          }

          if (dataPointIndex < seriesRenderer._segments.length) {
            endSegment = seriesRenderer._segments[dataPointIndex];
          }
        }
      }
      // ignore: unnecessary_null_comparison
      if (startSegment != null) {
        cartesianSeriesIndex = startSegment._seriesIndex;
        cartesianPointIndex = startSegment.currentSegmentIndex;
        if (_isSegmentIntersect(startSegment, position.dx, position.dy)) {
          return true;
        }
      } else if (endSegment != null) {
        cartesianSeriesIndex = endSegment._seriesIndex;
        cartesianPointIndex = endSegment.currentSegmentIndex;
        return _isSegmentIntersect(endSegment, position.dx, position.dy);
      }
    }
    return false;
  }

  /// To identify the cartesian point index
  int? getCartesianPointIndex(Offset position) {
    final List<CartesianChartPoint<dynamic>> firstNearestDataPoints =
        <CartesianChartPoint<dynamic>>[];
    int previousIndex, nextIndex;
    int? dataPointIndex,
        previousDataPointIndex,
        nextDataPointIndex,
        nearestDataPointIndex;
    final List<CartesianChartPoint<dynamic>>? nearestDataPoints =
        _getNearestChartPoints(
            position.dx,
            position.dy,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            seriesRenderer);

    for (final CartesianChartPoint<dynamic> dataPoint in nearestDataPoints!) {
      dataPointIndex = dataPoint.overallDataPointIndex;
      viewportIndex = dataPoint.visiblePointIndex;
      previousIndex = seriesRenderer._dataPoints.indexOf(dataPoint) - 1;
      previousIndex < 0
          ? previousDataPointIndex = dataPointIndex
          : previousDataPointIndex = previousIndex;
      nextIndex = seriesRenderer._dataPoints.indexOf(dataPoint) + 1;
      nextIndex > seriesRenderer._dataPoints.length - 1
          ? nextDataPointIndex = dataPointIndex
          : nextDataPointIndex = nextIndex;
    }

    firstNearestDataPoints
        .add(seriesRenderer._dataPoints[previousDataPointIndex]);
    firstNearestDataPoints.add(seriesRenderer._dataPoints[nextDataPointIndex]);
    final List<CartesianChartPoint<dynamic>>? firstNearestPoints =
        _getNearestChartPoints(
            position.dx,
            position.dy,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            seriesRenderer,
            firstNearestDataPoints);

    for (final CartesianChartPoint<dynamic> dataPoint in firstNearestPoints!) {
      if (seriesRenderer._seriesType.contains('hilo') == true ||
          seriesRenderer._seriesType == 'candle' ||
          seriesRenderer._seriesType.contains('boxandwhisker') == true) {
        nearestDataPointIndex = dataPointIndex;
      } else {
        if (dataPointIndex! < dataPoint.overallDataPointIndex!) {
          nearestDataPointIndex = dataPointIndex;
        } else if (dataPointIndex == dataPoint.overallDataPointIndex) {
          dataPoint.overallDataPointIndex! - 1 < 0
              ? nearestDataPointIndex = dataPoint.overallDataPointIndex
              : nearestDataPointIndex = dataPoint.overallDataPointIndex! - 1;
        } else {
          nearestDataPointIndex = dataPoint.overallDataPointIndex;
        }
      }
    }
    seriesRenderer._selectionBehaviorRenderer._selectionRenderer
        .cartesianPointIndex = nearestDataPointIndex;
    return nearestDataPointIndex;
  }

  /// To know the segment is intersect with touch point
  bool _isSegmentIntersect(
      ChartSegment segment, double touchX1, double touchY1) {
    dynamic currentSegment;
    num x1, x2, y1, y2;
    if (segment is LineSegment ||
        segment is SplineSegment ||
        segment is StepLineSegment ||
        segment is StackedLineSegment ||
        segment is HiloSegment ||
        segment is HiloOpenCloseSegment ||
        segment is CandleSegment ||
        segment is BoxAndWhiskerSegment ||
        segment is StackedLine100Segment) {
      currentSegment = segment;
    }
    x1 = currentSegment is HiloSegment ||
            currentSegment is HiloOpenCloseSegment ||
            currentSegment is CandleSegment ||
            currentSegment is BoxAndWhiskerSegment
        ? currentSegment._x
        : currentSegment._x1;
    if (currentSegment is HiloSegment ||
        currentSegment is HiloOpenCloseSegment ||
        currentSegment is CandleSegment ||
        currentSegment is BoxAndWhiskerSegment) {
      x2 = currentSegment._x;
      if (currentSegment is BoxAndWhiskerSegment) {
        y1 = currentSegment._min;
        y2 = currentSegment._max;
      } else {
        y1 = currentSegment._low;
        y2 = currentSegment._high;
      }
    } else {
      y1 = currentSegment is StackedLineSegment ||
              currentSegment is StackedLine100Segment
          ? currentSegment._currentCummulativeValue
          : currentSegment._y1;
      x2 = currentSegment._x2;
      y2 = currentSegment is StackedLineSegment ||
              currentSegment is StackedLine100Segment
          ? currentSegment._nextCummulativeValue
          : currentSegment._y2;
    }

    final CartesianChartPoint<dynamic> leftPoint =
        CartesianChartPoint<dynamic>(touchX1 - 20, touchY1 - 20);
    final CartesianChartPoint<dynamic> rightPoint =
        CartesianChartPoint<dynamic>(touchX1 + 20, touchY1 + 20);
    final CartesianChartPoint<dynamic> topPoint =
        CartesianChartPoint<dynamic>(touchX1 + 20, touchY1 - 20);
    final CartesianChartPoint<dynamic> bottomPoint =
        CartesianChartPoint<dynamic>(touchX1 - 20, touchY1 + 20);

    final CartesianChartPoint<dynamic> startSegment =
        CartesianChartPoint<dynamic>(x1, y1);
    final CartesianChartPoint<dynamic> endSegment =
        CartesianChartPoint<dynamic>(x2, y2);

    if (isLineIntersect(startSegment, endSegment, leftPoint, rightPoint) ||
        isLineIntersect(startSegment, endSegment, topPoint, bottomPoint)) {
      return true;
    }

    if (seriesRenderer._seriesType == 'stepline') {
      final num x3 = currentSegment._x3;
      final num y3 = currentSegment._y3;
      final num x2 = currentSegment._x2;
      final num y2 = currentSegment._y2;
      final CartesianChartPoint<dynamic> endSegment =
          CartesianChartPoint<dynamic>(x2, y2);
      final CartesianChartPoint<dynamic> midSegment =
          CartesianChartPoint<dynamic>(x3, y3);
      if (isLineIntersect(endSegment, midSegment, leftPoint, rightPoint) ||
          isLineIntersect(endSegment, midSegment, topPoint, bottomPoint)) {
        return true;
      }
    }
    return false;
  }

  /// To get the index of the selected segment
  void getSelectedSeriesIndex(SfCartesianChart chart, Offset position,
      CartesianSeriesRenderer seriesRenderer) {
    Rect? currentSegment;
    int? seriesIndex;
    SelectionBehaviorRenderer? selectionBehaviorRenderer;
    CartesianChartPoint<dynamic> point;
    outerLoop:
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          _chartState._chartSeries.visibleSeriesRenderers[i];
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer!;
      for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
        point = seriesRenderer._dataPoints[j];
        currentSegment = point.region;
        if (currentSegment != null && currentSegment.contains(position)) {
          seriesIndex = i;
          break outerLoop;
        }
      }
    }
    if (selectionBehaviorRenderer == null) {
      return;
    }
    selectionBehaviorRenderer._selectionRenderer!.seriesIndex = seriesIndex;
  }

  /// To do selection for cartesian type chart.
  void performSelection(Offset position) {
    bool select = false;
    bool isSelect = false;
    _isInteraction = true;
    int? cartesianPointIndex;
    if (seriesRenderer._seriesType == 'line' ||
        seriesRenderer._seriesType == 'spline' ||
        seriesRenderer._seriesType == 'stepline' ||
        seriesRenderer._seriesType == 'stackedline' ||
        seriesRenderer._seriesType.contains('hilo') == true ||
        seriesRenderer._seriesType == 'candle' ||
        seriesRenderer._seriesType.contains('boxandwhisker') == true ||
        seriesRenderer._seriesType == 'stackedline100') {
      isSelect = seriesRenderer._isSelectionEnable == true &&
          _isSeriesContainsPoint(seriesRenderer, position);
      if (isSelect) {
        cartesianPointIndex = getCartesianPointIndex(position);
        selected = cartesianPointIndex != null;
        select = seriesRenderer._selectionBehaviorRenderer._selectionRenderer
            .isCartesianSelection(chart, seriesRenderer, cartesianPointIndex,
                cartesianSeriesIndex);
      }
    } else {
      _chartState._renderDatalabelRegions = <Rect>[];
      (seriesRenderer._seriesType.contains('area') == true ||
              seriesRenderer._seriesType == 'fastline')
          ? getSelectedSeriesIndex(chart, position, seriesRenderer)
          : getPointAndSeriesIndex(chart, position, seriesRenderer);

      select = seriesRenderer._selectionBehaviorRenderer._selectionRenderer
          .isCartesianSelection(chart, seriesRenderer, pointIndex, seriesIndex);
    }

    if (select) {
      for (final CartesianSeriesRenderer _seriesRenderer
          in _chartState._chartSeries.visibleSeriesRenderers) {
        ValueNotifier<int>(_seriesRenderer._repaintNotifier.value++);
      }
    }
  }

  // ignore: unused_element
  void _checkWithSelectionState(
      ChartSegment currentSegment, SfCartesianChart chart) {
    bool isSelected = false;
    if (selectedSegments.isNotEmpty) {
      for (int i = 0; i < selectedSegments.length; i++) {
        if (selectedSegments[i]._seriesIndex == currentSegment._seriesIndex &&
            (_isInteraction || currentSegment._oldSegmentIndex != -1) &&
            (seriesRenderer._seriesType.contains('area') == true
                ? selectedSegments[i].currentSegmentIndex ==
                    currentSegment.currentSegmentIndex
                : selectedSegments[i]._currentPoint!.overallDataPointIndex ==
                    (_isInteraction
                        ? currentSegment._currentPoint!.overallDataPointIndex
                        : (currentSegment._oldSegmentIndex ??
                            currentSegment
                                ._currentPoint!.overallDataPointIndex)))) {
          _selectedSegmentsColors(<ChartSegment>[currentSegment]);
          isSelected = true;
          break;
        }
      }
    }

    if (!isSelected && unselectedSegments!.isNotEmpty) {
      for (int i = 0; i < unselectedSegments!.length; i++) {
        if (unselectedSegments![i]._seriesIndex ==
                currentSegment._seriesIndex &&
            (currentSegment._oldSegmentIndex == -1 ||
                    currentSegment._oldSegmentIndex !=
                        currentSegment.currentSegmentIndex ||
                    seriesRenderer._seriesType.contains('area') == true
                ? unselectedSegments![i].currentSegmentIndex ==
                    currentSegment.currentSegmentIndex
                : unselectedSegments![i]._currentPoint?.overallDataPointIndex ==
                    currentSegment._currentPoint?.overallDataPointIndex)) {
          _unselectedSegmentsColors(<ChartSegment>[currentSegment]);
          isSelected = true;
          break;
        }
      }
    }
  }

  SelectionArgs getSelectionEventArgs(CartesianSeries<dynamic, dynamic> series,
      int seriesIndex, int pointIndex, CartesianSeriesRenderer seriesRender) {
    // ignore: unnecessary_null_comparison
    if (series != null) {
      selectionArgs = SelectionArgs(
          seriesRenderer: seriesRenderer,
          seriesIndex: seriesIndex,
          viewportPointIndex: pointIndex,
          pointIndex: seriesRender
              ._visibleDataPoints![pointIndex].overallDataPointIndex!);
    }
    return selectionArgs!;
  }
}
