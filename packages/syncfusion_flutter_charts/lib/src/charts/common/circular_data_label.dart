import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'callbacks.dart';
import 'chart_point.dart';
import 'circular_data_label_helper.dart';
import 'core_tooltip.dart';
import 'data_label.dart';
import 'element_widget.dart';

// ignore: must_be_immutable
class CircularChartDataLabelPositioned
    extends ParentDataWidget<CircularDataLabelBoxParentData>
    with LinkedListEntry<CircularChartDataLabelPositioned> {
  CircularChartDataLabelPositioned({
    super.key,
    required this.x,
    required this.y,
    required this.dataPointIndex,
    required this.position,
    required this.point,
    required super.child,
  });

  final num x;
  final num y;
  final int dataPointIndex;
  final ChartDataPointType position;

  Offset offset = Offset.zero;
  Size size = Size.zero;
  CircularChartPoint? point;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is CircularDataLabelBoxParentData);
    final CircularDataLabelBoxParentData parentData =
        renderObject.parentData! as CircularDataLabelBoxParentData;
    bool needsLayout = false;

    if (parentData.x != x) {
      parentData.x = x;
      needsLayout = true;
    }

    if (parentData.y != y) {
      parentData.y = y;
      needsLayout = true;
    }

    if (parentData.dataPointIndex != dataPointIndex) {
      parentData.dataPointIndex = dataPointIndex;
      needsLayout = true;
    }

    if (parentData.position != position) {
      parentData.position = position;
      needsLayout = true;
    }

    if (parentData.point != point) {
      parentData.point = point;
      needsLayout = true;
    }

    if (needsLayout) {
      final RenderObject? targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CircularDataLabelStack;
}

class CircularDataLabelContainer<T, D> extends StatefulWidget {
  const CircularDataLabelContainer({
    super.key,
    required this.series,
    required this.dataSource,
    this.mapper,
    this.builder,
    required this.settings,
  });

  final ChartWidgetBuilder<T, D>? builder;
  final List<T> dataSource;
  final ChartValueMapper<T, String>? mapper;
  final ChartSeries<T, D> series;
  final DataLabelSettings settings;

  @override
  State<CircularDataLabelContainer<T, D>> createState() =>
      _CircularDataLabelContainerState<T, D>();
}

typedef _ChartDataLabelWidgetBuilder<T, D> = Widget Function(
    T data,
    ChartPoint<D> point,
    ChartSeries<T, D> series,
    int pointIndex,
    int seriesIndex,
    ChartDataPointType position);

class _CircularDataLabelContainerState<T, D>
    extends State<CircularDataLabelContainer<T, D>>
    with ChartElementParentDataMixin<T, D> {
  List<CircularChartDataLabelPositioned>? _builderChildren;
  LinkedList<CircularChartDataLabelPositioned>? _textChildren;

  @override
  CircularSeriesRenderer<T, D>? get renderer =>
      super.renderer as CircularSeriesRenderer<T, D>?;

  Widget _dataLabelFromBuilder(
      T data,
      ChartPoint<D> point,
      ChartSeries<T, D> series,
      int pointIndex,
      int seriesIndex,
      ChartDataPointType position) {
    return widget.builder!(data, point, series, pointIndex, seriesIndex);
  }

  Widget _dataLabelFromMapper(
      T data,
      ChartPoint<D> point,
      ChartSeries<T, D> series,
      int pointIndex,
      int seriesIndex,
      ChartDataPointType position) {
    String text = widget.mapper!(data, pointIndex) ?? '';

    if (renderer!.groupTo != null) {
      text = renderer!.groupingDataLabelValues[pointIndex].toString();
    }

    return _buildDataLabelText(text, pointIndex);
  }

  Widget _defaultDataLabel(
    T data,
    ChartPoint<D> point,
    ChartSeries<T, D> series,
    int pointIndex,
    int seriesIndex,
    ChartDataPointType position,
  ) {
    // TODO(VijayakumarM): What happen when y is nan?
    final num value = point[position];
    final String formattedText = decimalLabelValue(value);
    return _buildDataLabelText(formattedText, pointIndex, isYText: true);
  }

  Color _dataPointColor(int dataPointIndex) {
    final DataLabelSettings settings = widget.settings;
    if (settings.color != null) {
      return settings.color!.withOpacity(settings.opacity);
    } else if (settings.useSeriesColor) {
      return renderer!.segments[dataPointIndex].fillPaint.color
          .withOpacity(settings.opacity);
    }
    return Colors.transparent;
  }

  DataLabelText _buildDataLabelText(String text, int pointIndex,
      {bool isYText = false}) {
    final RenderChartPlotArea parent = renderer!.parent!;
    final TextStyle dataLabelTextStyle = parent.themeData!.textTheme.bodySmall!
        .copyWith(color: Colors.transparent)
        .merge(parent.chartThemeData!.dataLabelTextStyle)
        .merge(widget.settings.textStyle);

    if (xRawValues != null &&
        xRawValues!.isNotEmpty &&
        xRawValues!.length - 1 == pointIndex) {
      if (renderer!.groupTo != null &&
          text != 'Others' &&
          xRawValues![pointIndex].toString() == 'Others') {
        text = isYText ? 'Others : $text' : 'Others';
      }
    }

    return DataLabelText(
      text: text,
      textStyle: dataLabelTextStyle,
      color: _dataPointColor(pointIndex),
    );
  }

  void _addToList(CircularChartDataLabelPositioned child) {
    _builderChildren!.add(child);
  }

  void _addToLinkedList(CircularChartDataLabelPositioned child) {
    _textChildren!.add(child);
  }

  void _buildDataLabels(_ChartDataLabelWidgetBuilder<T, D> callback,
      Function(CircularChartDataLabelPositioned) add) {
    const List<ChartDataPointType> positions = ChartDataPointType.values;
    final int yLength = yLists?.length ?? 0;
    final int posAdj = _positionIndex(yLength);
    List<Object?>? actualXValues;
    if (xRawValues != null && xRawValues!.isNotEmpty) {
      actualXValues = xRawValues;
    } else {
      actualXValues = xValues;
    }

    if (actualXValues == null || renderer!.segments.isEmpty) {
      return;
    }

    final bool hasSortedIndexes = renderer!.sortingOrder != SortingOrder.none &&
        sortedIndexes != null &&
        sortedIndexes!.isNotEmpty;

    for (int i = 0; i < renderer!.dataCount; i++) {
      _obtainLabel(i, actualXValues, yLength, positions, posAdj, callback, add,
          hasSortedIndexes);
    }
  }

  int _positionIndex(int yListsLength) {
    // TODO(VijayakumarM): Add comment.
    return yListsLength == 1 ? 0 : 1;
  }

  void _obtainLabel(
    int index,
    List<Object?> rawXValues,
    int yLength,
    List<ChartDataPointType> positions,
    int posAdj,
    _ChartDataLabelWidgetBuilder<T, D> callback,
    Function(CircularChartDataLabelPositioned) add,
    bool hasSortedIndexes,
  ) {
    final int pointIndex = hasSortedIndexes ? sortedIndexes![index] : index;
    final num x = xValues![index];
    final CircularChartPoint<D> point =
        CircularChartPoint<D>(x: rawXValues[index] as D?);
    point.color = _dataPointColor(index);
    for (int j = 0; j < yLength; j++) {
      final List<num> yValues = yLists![j];
      point.y = yValues[index];

      // TODO(Lavanya): Recheck here.
      // final ChartDataPointType position = positions[j + posAdj];
      // point[position] = yValues[index];
    }

    for (int k = 0; k < yLength; k++) {
      final ChartDataPointType position = positions[k + posAdj];
      final CircularChartDataLabelPositioned child =
          CircularChartDataLabelPositioned(
        x: x,
        y: point[position],
        dataPointIndex: index,
        position: position,
        point: point,
        child: callback(
          widget.dataSource[pointIndex],
          point,
          widget.series,
          pointIndex,
          renderer!.index,
          position,
        ),
      );

      add(child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChartElementLayoutBuilder<T, D>(
      state: this,
      builder: (BuildContext context, BoxConstraints constraints) {
        _ChartDataLabelWidgetBuilder<T, D> callback;
        _builderChildren?.clear();
        _textChildren?.clear();
        if (renderer != null &&
            renderer!.initialIsVisible &&
            yLists != null &&
            yLists!.isNotEmpty) {
          if (widget.builder != null) {
            callback = _dataLabelFromBuilder;
          } else {
            callback = widget.mapper != null
                ? _dataLabelFromMapper
                : _defaultDataLabel;
          }
          void Function(CircularChartDataLabelPositioned child) add;
          if (widget.builder != null) {
            _builderChildren = <CircularChartDataLabelPositioned>[];
            add = _addToList;
          } else {
            _textChildren = LinkedList<CircularChartDataLabelPositioned>();
            add = _addToLinkedList;
          }

          if (xValues != null && xValues!.isNotEmpty) {
            _buildDataLabels(callback, add);
          }
        }

        return ChartFadeTransition(
          opacity: animation!,
          child: CircularDataLabelStack<T, D>(
            series: renderer,
            settings: widget.settings,
            labels: _textChildren,
            children: _builderChildren ?? <CircularChartDataLabelPositioned>[],
          ),
        );
      },
    );
  }
}

class CircularDataLabelBoxParentData extends ChartElementParentData {
  CircularChartPoint? point;
}

class CircularDataLabelStack<T, D> extends ChartElementStack {
  const CircularDataLabelStack({
    super.key,
    required this.series,
    required this.labels,
    required this.settings,
    super.children,
  });

  final CircularSeriesRenderer<T, D>? series;
  final LinkedList<CircularChartDataLabelPositioned>? labels;
  final DataLabelSettings settings;

  @override
  RenderCircularDataLabelStack<T, D> createRenderObject(BuildContext context) {
    return RenderCircularDataLabelStack<T, D>()
      ..series = series
      ..labels = labels
      ..settings = settings;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCircularDataLabelStack<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..series = series
      ..labels = labels
      ..settings = settings;
  }
}

class RenderCircularDataLabelStack<T, D> extends RenderChartElementStack {
  late CircularSeriesRenderer<T, D>? series;
  late LinkedList<CircularChartDataLabelPositioned>? labels;
  late DataLabelSettings settings;
  bool hasTrimmedDataLabel = false;

  List<CircularDataLabelBoxParentData> widgets =
      <CircularDataLabelBoxParentData>[];

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return false;
  }

  @override
  bool hitTestSelf(Offset position) {
    return (series?.parent?.onDataLabelTapped != null || hasTrimmedDataLabel) &&
        _findSelectedDataLabelIndex(position) != -1;
  }

  int _findSelectedDataLabelIndex(Offset localPosition) {
    if (series?.parent?.onDataLabelTapped == null && !hasTrimmedDataLabel) {
      return -1;
    }

    if (childCount > 0) {
      RenderBox? child = lastChild;
      while (child != null) {
        final ChartElementParentData childParentData =
            child.parentData! as ChartElementParentData;
        if ((childParentData.offset & child.size).contains(localPosition)) {
          return childParentData.dataPointIndex;
        }
        child = childParentData.previousSibling;
      }
    } else if (labels != null) {
      for (int i = labels!.length - 1; i > -1; i--) {
        final CircularChartDataLabelPositioned label = labels!.elementAt(i);
        final Rect rect = Rect.fromLTWH(
          label.offset.dx,
          label.offset.dy,
          label.size.width + settings.margin.horizontal,
          label.size.height + settings.margin.vertical,
        );
        if (rect.contains(localPosition)) {
          return label.dataPointIndex;
        }
      }
    }
    return -1;
  }

  @override
  void handleTapUp(Offset localPosition) {
    if (series?.parent?.onDataLabelTapped != null) {
      final int selectedIndex = _findSelectedDataLabelIndex(localPosition);
      if (selectedIndex == -1) {
        return;
      }

      final String text = childCount > 0
          ? ''
          : (labels!.elementAt(selectedIndex).child as DataLabelText).text;
      series!.parent!.onDataLabelTapped!(DataLabelTapDetails(
        series!.index,
        series!.viewportIndex(selectedIndex),
        text,
        settings,
        selectedIndex,
      ));
    } else if (hasTrimmedDataLabel) {
      final int selectedIndex = _findSelectedDataLabelIndex(localPosition);
      if (selectedIndex == -1) {
        return;
      }
      final CircularChartPoint point = labels!.elementAt(selectedIndex).point!;
      if (point.isVisible &&
          point.trimmedText != null &&
          point.text != point.trimmedText) {
        _showTooltipForTrimmedDataLabel(point, selectedIndex);
      }
    }
  }

  @override
  void handlePointerHover(Offset localPosition) {
    if (hasTrimmedDataLabel) {
      final int selectedIndex = _findSelectedDataLabelIndex(localPosition);
      if (selectedIndex == -1) {
        return;
      }
      final CircularChartPoint point = labels!.elementAt(selectedIndex).point!;
      if (point.isVisible &&
          point.trimmedText != null &&
          point.text != point.trimmedText) {
        _showTooltipForTrimmedDataLabel(point, selectedIndex);
      }
    }
  }

  void _showTooltipForTrimmedDataLabel(
      CircularChartPoint point, int pointIndex) {
    final RenderCircularChartPlotArea plotArea =
        series!.parent! as RenderCircularChartPlotArea;

    plotArea.behaviorArea?.showTooltip(TooltipInfo(
      primaryPosition: localToGlobal(point.labelRect.topCenter),
      secondaryPosition: localToGlobal(point.labelRect.topCenter),
      text: point.text,
      surfaceBounds: Rect.fromPoints(
        plotArea.localToGlobal(paintBounds.topLeft),
        plotArea.localToGlobal(paintBounds.bottomRight),
      ),
    ));
  }

  @override
  void setupParentData(RenderObject child) {
    if (child is! CircularDataLabelBoxParentData) {
      child.parentData = CircularDataLabelBoxParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {
    renderDataLabelRegions.clear();

    if (series == null) {
      return;
    }

    if (childCount > 0) {
      RenderBox? child = firstChild;
      widgets.clear();
      while (child != null) {
        final CircularDataLabelBoxParentData currentChildData =
            child.parentData! as CircularDataLabelBoxParentData;
        widgets.add(currentChildData);
        final RenderBox? nextSibling = currentChildData.nextSibling;

        child.layout(constraints, parentUsesSize: true);
        currentChildData.offset =
            series!.dataLabelPosition(currentChildData, child.size);
        // TODO(Lavanya): Need to handle the offset value for the
        // shift data label.
        currentChildData.offset +=
            _invokeDataLabelRender(currentChildData.dataPointIndex);
        child = nextSibling;
      }

      if (series!.dataLabelSettings.labelIntersectAction ==
          LabelIntersectAction.shift) {
        shiftCircularDataLabelTemplate(series!, widgets);
      }
    } else if (labels != null) {
      for (final CircularChartDataLabelPositioned currentLabel in labels!) {
        final CircularDataLabelBoxParentData currentLabelData =
            CircularDataLabelBoxParentData()
              ..x = currentLabel.x
              ..y = currentLabel.y
              ..dataPointIndex = currentLabel.dataPointIndex
              ..position = currentLabel.position
              ..point = currentLabel.point;

        final DataLabelText details = currentLabel.child as DataLabelText;
        currentLabel.offset =
            _invokeDataLabelRender(currentLabel.dataPointIndex, details);
        currentLabel.point!.text = details.text;
        currentLabel.size = measureText(details.text, details.textStyle);
        currentLabel.offset +=
            series!.dataLabelPosition(currentLabelData, currentLabel.size);
        hasTrimmedDataLabel = currentLabel.point!.trimmedText != null;

        if (currentLabel.point!.text != details.text) {
          details.text = currentLabel.point!.text!;
          currentLabel.size = measureText(details.text, details.textStyle);
        }
      }
      if (series!.dataLabelSettings.labelIntersectAction ==
          LabelIntersectAction.shift) {
        shiftCircularDataLabels(series!, labels!);
        hasTrimmedDataLabel =
            labels!.any((element) => element.point!.trimmedText != null);
      }
    }
  }

  Offset _invokeDataLabelRender(int pointIndex, [DataLabelText? details]) {
    if (series!.parent?.onDataLabelRender != null) {
      final DataLabelRenderArgs dataLabelArgs = DataLabelRenderArgs(
        seriesRenderer: series,
        dataPoints: series!.chartPoints,
        viewportPointIndex: pointIndex,
        pointIndex: pointIndex,
      )..offset = settings.offset;
      if (details != null) {
        dataLabelArgs
          ..text = details.text
          ..textStyle = details.textStyle
          ..color = details.color;
      }

      series!.parent!.onDataLabelRender!(dataLabelArgs);
      if (details != null) {
        details
          ..text = dataLabelArgs.text ?? ''
          ..textStyle = details.textStyle.merge(dataLabelArgs.textStyle)
          ..color = dataLabelArgs.color;
      }

      return dataLabelArgs.offset;
    }

    return Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas
      ..save()
      ..clipRect(paintBounds);
    if (childCount > 0) {
      RenderBox? child = firstChild;
      while (child != null) {
        final CircularDataLabelBoxParentData childParentData =
            child.parentData! as CircularDataLabelBoxParentData;
        final CircularChartPoint point = childParentData.point!;
        if (point.isVisible) {
          if (point.connectorPath != null) {
            series!.drawConnectorLine(point.connectorPath!, context.canvas,
                childParentData.dataPointIndex);
          }
          context.paintChild(child, childParentData.offset + offset);
        }
        child = childParentData.nextSibling;
      }
    } else if (labels != null) {
      final Paint fillPaint = Paint();
      final Paint strokePaint = Paint()
        ..color = settings.borderColor
        ..strokeWidth = settings.borderWidth
        ..style = PaintingStyle.stroke;
      for (final CircularChartDataLabelPositioned label in labels!) {
        final DataLabelText details = label.child as DataLabelText;
        fillPaint.color = details.color;
        series!.drawDataLabelWithBackground(
          label,
          label.dataPointIndex,
          context.canvas,
          details.text,
          label.offset,
          settings.angle,
          details.textStyle,
          fillPaint,
          strokePaint,
        );
      }
    }
    context.canvas.restore();
  }
}
