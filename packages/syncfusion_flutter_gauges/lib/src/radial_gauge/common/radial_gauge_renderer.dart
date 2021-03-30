import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../annotation/gauge_annotation.dart';
import '../axis/radial_axis.dart';
import '../common/gauge_annotation_renderer.dart';
import '../common/widget_pointer_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../gauge_painter/marker_pointer_painter.dart';
import '../gauge_painter/needle_pointer_painter.dart';
import '../gauge_painter/radial_axis_painter.dart';
import '../gauge_painter/range_painter.dart';
import '../gauge_painter/range_pointer_painter.dart';
import '../pointers/gauge_pointer.dart';
import '../pointers/marker_pointer.dart';
import '../pointers/needle_pointer.dart';
import '../pointers/range_pointer.dart';
import '../pointers/widget_pointer.dart';
import '../range/gauge_range.dart';
import '../renderers/gauge_pointer_renderer.dart';
import '../renderers/gauge_range_renderer.dart';
import '../renderers/marker_pointer_renderer_base.dart';
import '../renderers/needle_pointer_renderer_base.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../renderers/range_pointer_renderer.dart';
import '../renderers/widget_pointer_renderer_base.dart';
import '../utils/enum.dart';

/// Represents the container to render the axis and its element
///
class AxisContainer extends StatelessWidget {
  /// Creates the Axis Container
  const AxisContainer(
      this._gauge, this._gaugeThemeData, this._renderingDetails);

  /// Hold the radial gauge animation details
  final RenderingDetails _renderingDetails;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Specifies the radial gauge
  final SfRadialGauge _gauge;

  /// Method to update the pointer value
  void _updatePointerValue(BuildContext context, DragUpdateDetails details) {
    final RenderBox? renderBox = context.findRenderObject()! as RenderBox;
    final Offset tapPosition = renderBox!.globalToLocal(details.globalPosition);
    for (int i = 0; i < _gauge.axes.length; i++) {
      final List<GaugePointerRenderer>? _pointerRenderers =
          _renderingDetails.gaugePointerRenderers[i];
      if (_gauge.axes[i].pointers != null &&
          _gauge.axes[i].pointers!.isNotEmpty) {
        for (int j = 0; j < _gauge.axes[i].pointers!.length; j++) {
          final GaugePointer pointer = _gauge.axes[i].pointers![j];
          final GaugePointerRenderer pointerRenderer = _pointerRenderers![j];
          if (pointer.enableDragging &&
              pointerRenderer.isDragStarted != null &&
              pointerRenderer.isDragStarted!) {
            pointerRenderer.updateDragValue(
                tapPosition.dx, tapPosition.dy, _renderingDetails);
          }
        }
      }
    }
  }

  /// To initialize the gauge elements
  Widget _getGaugeElements(BuildContext context, BoxConstraints constraints) {
    final List<Widget> gaugeWidgets = <Widget>[];
    _calculateAxisElementPosition(context, constraints);
    _addGaugeElements(constraints, context, gaugeWidgets);
    final bool enableAxisTapping = _getIsAxisTapped();
    final bool enablePointerDragging = _getIsPointerDragging();

    return MouseRegion(
        onHover: enablePointerDragging
            ? (event) => _enableOverlayForMarkerPointer(context, event.position)
            : null,
        onExit: (event) =>
            enablePointerDragging ? (event) => _checkPointerIsDragged() : null,
        child: Listener(
            onPointerUp: enablePointerDragging
                ? (event) => _checkPointerIsDragged()
                : null,
            onPointerCancel: enablePointerDragging
                ? (event) => _checkPointerIsDragged()
                : null,
            child: GestureDetector(
                onVerticalDragStart: enablePointerDragging
                    ? (DragStartDetails details) =>
                        _checkPointerDragging(context, details)
                    : null,
                onVerticalDragUpdate: enablePointerDragging
                    ? (DragUpdateDetails details) =>
                        _updatePointerValue(context, details)
                    : null,
                onVerticalDragEnd: enablePointerDragging
                    ? (DragEndDetails details) => _checkPointerIsDragged()
                    : null,
                onHorizontalDragStart: enablePointerDragging
                    ? (DragStartDetails details) =>
                        _checkPointerDragging(context, details)
                    : null,
                onHorizontalDragUpdate: enablePointerDragging
                    ? (DragUpdateDetails details) =>
                        _updatePointerValue(context, details)
                    : null,
                onHorizontalDragEnd: enablePointerDragging
                    ? (DragEndDetails details) => _checkPointerIsDragged()
                    : null,
                onTapUp: enableAxisTapping
                    ? (TapUpDetails details) =>
                        _checkIsAxisTapped(context, details)
                    : null,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Stack(children: gaugeWidgets),
                ))));
  }

  /// Checks whether the mouse pointer is hovered on marker in web
  void _enableOverlayForMarkerPointer(
      BuildContext context, Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset hoverPosition = renderBox.globalToLocal(globalPosition);
    for (int i = 0; i < _gauge.axes.length; i++) {
      final List<GaugePointerRenderer>? pointerRenderers =
          _renderingDetails.gaugePointerRenderers[i];
      if (_gauge.axes[i].pointers != null &&
          _gauge.axes[i].pointers!.isNotEmpty) {
        for (int j = 0; j < _gauge.axes[i].pointers!.length; j++) {
          final GaugePointer pointer = _gauge.axes[i].pointers![j];
          final GaugePointerRenderer pointerRenderer = pointerRenderers![j];
          if (pointer.enableDragging && pointer is MarkerPointer) {
            pointerRenderer.isHovered = false;
            _renderingDetails.pointerRepaintNotifier.value++;
            Rect pointerRect = pointerRenderer.pointerRect;
            pointerRect = Rect.fromLTRB(
                pointerRect.left - 10,
                pointerRect.top - 10,
                pointerRect.right + 10,
                pointerRect.bottom + 10);
            if (pointerRenderer.pointerRect.contains(hoverPosition) &&
                pointerRenderers.isNotEmpty &&
                !(pointerRenderers.any((element) =>
                    element.isHovered != null && element.isHovered!))) {
              pointerRenderer.isHovered = true;
              _renderingDetails.pointerRepaintNotifier.value++;
              break;
            }
          }
        }
      }
    }
  }

  bool _getIsAxisTapped() {
    for (int i = 0; i < _gauge.axes.length; i++) {
      if (_gauge.axes[i].onAxisTapped != null) {
        return true;
      }
    }
    return false;
  }

  // Checks whether the pointer dragging is enabled
  bool _getIsPointerDragging() {
    for (int i = 0; i < _gauge.axes.length; i++) {
      final RadialAxis currentAxis = _gauge.axes[i];
      if (currentAxis.pointers != null && currentAxis.pointers!.isNotEmpty) {
        for (int j = 0; j < currentAxis.pointers!.length; j++) {
          if (currentAxis.pointers![j].enableDragging) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Method to check whether the axis is tapped
  void _checkIsAxisTapped(BuildContext context, TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    if (_gauge.axes.isNotEmpty) {
      for (int i = 0; i < _gauge.axes.length; i++) {
        final RadialAxis axis = _gauge.axes[i];
        final RadialAxisRendererBase axisRenderer =
            _renderingDetails.axisRenderers[i];
        final Offset offset = renderBox.globalToLocal(details.globalPosition);
        if (axis.onAxisTapped != null &&
            axisRenderer.axisPath.getBounds().contains(offset)) {
          axisRenderer.calculateAngleFromOffset(offset);
        }
      }
    }
  }

  /// Method to check whether the axis pointer is dragging
  void _checkPointerDragging(BuildContext context, DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset tapPosition = renderBox.globalToLocal(details.globalPosition);
    for (int i = 0; i < _gauge.axes.length; i++) {
      final RadialAxisRendererBase axisRenderer =
          _renderingDetails.axisRenderers[i];
      final List<GaugePointerRenderer>? pointerRenderers =
          _renderingDetails.gaugePointerRenderers[i];
      if (_gauge.axes[i].pointers != null &&
          _gauge.axes[i].pointers!.isNotEmpty) {
        for (int j = 0; j < _gauge.axes[i].pointers!.length; j++) {
          final GaugePointer pointer = _gauge.axes[i].pointers![j];
          final GaugePointerRenderer pointerRenderer = pointerRenderers![j];
          pointerRenderer.isHovered = false;
          if (pointer.enableDragging) {
            if (pointer is RangePointer) {
              final RangePointerRenderer renderer =
                  pointerRenderer as RangePointerRenderer;
              final Rect pathRect = Rect.fromLTRB(
                  renderer.arcPath.getBounds().left +
                      axisRenderer.axisCenter.dx -
                      5,
                  renderer.arcPath.getBounds().top +
                      axisRenderer.axisCenter.dy -
                      5,
                  renderer.arcPath.getBounds().right +
                      axisRenderer.axisCenter.dx +
                      5,
                  renderer.arcPath.getBounds().bottom +
                      axisRenderer.axisCenter.dy +
                      5);

              // Checks whether the tapped position is present inside
              // the range pointer path
              if (pathRect.contains(tapPosition)) {
                renderer.isDragStarted = true;
                renderer.createPointerValueChangeStartArgs();
              } else {
                renderer.isDragStarted = false;
              }
            } else {
              Rect pointerRect = pointerRenderer.pointerRect;
              pointerRect = Rect.fromLTRB(
                  pointerRect.left - 25,
                  pointerRect.top - 25,
                  pointerRect.right + 25,
                  pointerRect.bottom + 25);
              if (pointerRenderer.pointerRect.contains(tapPosition)) {
                pointerRenderer.isDragStarted = true;
                pointerRenderer.isHovered = true;
                pointerRenderer.createPointerValueChangeStartArgs();
              } else {
                pointerRenderer.isDragStarted = false;
              }
            }
          }
        }

        final List<GaugePointerRenderer> renderers = (pointerRenderers!.where(
                (element) => element.isHovered != null && element.isHovered!))
            .toList();
        if (renderers.length > 1) {
          for (int i = 0; i < renderers.length; i++) {
            if (i < renderers.length - 1) {
              renderers[i].isHovered = false;
            }
          }
        }
      }
    }
  }

  /// Method to ensure whether the pointer was dragged
  void _checkPointerIsDragged() {
    for (int i = 0; i < _gauge.axes.length; i++) {
      if (_gauge.axes[i].pointers != null &&
          _gauge.axes[i].pointers!.isNotEmpty) {
        final List<GaugePointerRenderer> pointerRenderers =
            _renderingDetails.gaugePointerRenderers[i]!;
        for (int j = 0; j < _gauge.axes[i].pointers!.length; j++) {
          final GaugePointer pointer = _gauge.axes[i].pointers![j];
          final GaugePointerRenderer pointerRenderer = pointerRenderers[j];
          if (pointer.enableDragging) {
            if (pointerRenderer.isDragStarted != null &&
                pointerRenderer.isDragStarted!) {
              pointerRenderer.createPointerValueChangeEndArgs();
              if (pointer is RangePointer) {
                final RangePointerRenderer renderer =
                    pointerRenderer as RangePointerRenderer;
                renderer.animationEndValue = renderer.getSweepAngle();
              } else {
                pointerRenderer.animationEndValue =
                    pointerRenderer.getSweepAngle();
              }
            }
            pointerRenderer.isDragStarted = false;
            pointerRenderer.isHovered = false;
            if (!(pointer is WidgetPointer)) {
              _renderingDetails.pointerRepaintNotifier.value++;
            }
          }
        }
      }
    }
  }

  /// Calculates the axis position
  void _calculateAxisElementPosition(
      BuildContext context, BoxConstraints constraints) {
    if (_gauge.axes.isNotEmpty) {
      for (int i = 0; i < _gauge.axes.length; i++) {
        final RadialAxisRendererBase? axisRenderer =
            _renderingDetails.axisRenderers[i];
        if (axisRenderer != null) {
          axisRenderer.calculateAxisRange(
              constraints, context, _gaugeThemeData, _renderingDetails);
        }
      }
    }
  }

  /// Methods to add the gauge elements
  void _addGaugeElements(BoxConstraints constraints, BuildContext context,
      List<Widget> gaugeWidgets) {
    if (_gauge.axes.isNotEmpty) {
      final _AnimationDurationDetails durationDetails =
          _AnimationDurationDetails();
      _calculateDurationForAnimation(durationDetails);
      for (int i = 0; i < _gauge.axes.length; i++) {
        final RadialAxis axis = _gauge.axes[i];
        final RadialAxisRendererBase axisRenderer =
            _renderingDetails.axisRenderers[i];
        _addAxis(
            axis, constraints, gaugeWidgets, durationDetails, axisRenderer);

        if (axis.ranges != null && axis.ranges!.isNotEmpty) {
          final List<GaugeRangeRenderer> rangeRenderers =
              _renderingDetails.gaugeRangeRenderers[i]!;
          _addRange(axis, constraints, gaugeWidgets, durationDetails,
              axisRenderer, rangeRenderers);
        }

        if (axis.pointers != null && axis.pointers!.isNotEmpty) {
          final List<GaugePointerRenderer> pointerRenderers =
              _renderingDetails.gaugePointerRenderers[i]!;
          for (int j = 0; j < axis.pointers!.length; j++) {
            final GaugePointerRenderer pointerRenderer = pointerRenderers[j];
            if (axis.pointers![j] is NeedlePointer) {
              final NeedlePointer needlePointer =
                  axis.pointers![j] as NeedlePointer;
              _addNeedlePointer(axis, constraints, needlePointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            } else if (axis.pointers![j] is MarkerPointer) {
              final MarkerPointer markerPointer =
                  axis.pointers![j] as MarkerPointer;
              _addMarkerPointer(axis, constraints, markerPointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            } else if (axis.pointers![j] is RangePointer) {
              final RangePointer rangePointer =
                  axis.pointers![j] as RangePointer;
              _addRangePointer(axis, constraints, rangePointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            } else if (axis.pointers![j] is WidgetPointer) {
              final WidgetPointer widgetPointer =
                  axis.pointers![j] as WidgetPointer;
              _addWidgetPointer(axis, constraints, widgetPointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            }
          }
        }

        if (axis.annotations != null && axis.annotations!.isNotEmpty) {
          _addAnnotation(axis, gaugeWidgets, durationDetails, axisRenderer);
        }
      }
    }
  }

  /// Adds the axis
  void _addAxis(
      RadialAxis axis,
      BoxConstraints constraints,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer) {
    Animation<double>? axisAnimation;
    Animation<double>? axisElementAnimation;
    if (_renderingDetails.needsToAnimateAxes &&
        (durationDetails.hasAxisLine || durationDetails.hasAxisElements)) {
      _renderingDetails.animationController!.duration =
          Duration(milliseconds: _gauge.animationDuration.toInt());
      // Includes animation duration for axis line
      if (durationDetails.hasAxisLine) {
        axisAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: _renderingDetails.animationController!,
            curve: Interval(durationDetails.axisLineInterval[0]!,
                durationDetails.axisLineInterval[1]!,
                curve: Curves.easeIn)));
      }
      // Includes animation duration for axis ticks and labels
      if (durationDetails.hasAxisElements) {
        axisElementAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _renderingDetails.animationController!,
                curve: Interval(durationDetails.axisElementsInterval[0]!,
                    durationDetails.axisElementsInterval[1]!,
                    curve: Curves.easeIn)));
      }
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: AxisPainter(
                _gauge,
                axis,
                axisRenderer.needsRepaintAxis,
                _renderingDetails.axisRepaintNotifier,
                axisAnimation,
                axisElementAnimation,
                _gaugeThemeData,
                _renderingDetails,
                axisRenderer),
            size: Size(constraints.maxWidth, constraints.maxHeight)),
      ),
    ));

    if (axisAnimation != null || axisElementAnimation != null) {
      _renderingDetails.animationController!.forward(from: 0.0);
    }
  }

  /// Adds the range pointer
  void _addRangePointer(
      RadialAxis axis,
      BoxConstraints constraints,
      RangePointer rangePointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer,
      GaugePointerRenderer pointerRenderer) {
    final RangePointerRenderer rangePointerRenderer =
        pointerRenderer as RangePointerRenderer;
    rangePointerRenderer.animationEndValue =
        rangePointerRenderer.getSweepAngle();
    Animation<double>? pointerAnimation;
    final List<double?> animationIntervals =
        _getPointerAnimationInterval(durationDetails);
    if (_renderingDetails.needsToAnimatePointers ||
        (rangePointer.enableAnimation &&
            rangePointer.animationDuration > 0 &&
            rangePointerRenderer.needsAnimate != null &&
            rangePointerRenderer.needsAnimate!)) {
      _renderingDetails.animationController!.duration = Duration(
          milliseconds:
              _getPointerAnimationDuration(rangePointer.animationDuration));
      final Curve pointerAnimationType =
          _getCurveAnimation(rangePointer.animationType);
      double endValue = rangePointerRenderer.animationEndValue!;
      final double startValue = rangePointerRenderer.animationStartValue ?? 0;
      _renderingDetails.isOpacityAnimation = startValue == endValue;
      if (_renderingDetails.isOpacityAnimation) {
        endValue = 1;
      }
      pointerAnimation = Tween<double>(begin: startValue, end: endValue)
          .animate(CurvedAnimation(
              parent: _renderingDetails.animationController!,
              curve: Interval(animationIntervals[0]!, animationIntervals[1]!,
                  curve: pointerAnimationType)));
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: RangePointerPainter(
                _gauge,
                axis,
                rangePointer,
                rangePointerRenderer.needsRepaintPointer,
                pointerAnimation,
                _renderingDetails.pointerRepaintNotifier,
                _gaugeThemeData,
                _renderingDetails,
                axisRenderer,
                rangePointerRenderer),
            size: Size(constraints.maxWidth, constraints.maxHeight)),
      ),
    ));
    if (_renderingDetails.needsToAnimatePointers ||
        rangePointerRenderer.getIsPointerAnimationEnabled()) {
      _renderingDetails.animationController!.forward(from: 0.0);
    }
  }

  /// Adds the needle pointer
  void _addNeedlePointer(
      RadialAxis axis,
      BoxConstraints constraints,
      NeedlePointer needlePointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer,
      GaugePointerRenderer pointerRenderer) {
    final NeedlePointerRendererBase needleRenderer =
        pointerRenderer as NeedlePointerRendererBase;
    Animation<double>? pointerAnimation;
    final List<double?> intervals =
        _getPointerAnimationInterval(durationDetails);
    needleRenderer.animationEndValue = needleRenderer.getSweepAngle();
    _renderingDetails.isOpacityAnimation = false;
    if (_renderingDetails.needsToAnimatePointers ||
        (needlePointer.enableAnimation &&
            needlePointer.animationDuration > 0 &&
            needleRenderer.needsAnimate != null &&
            needleRenderer.needsAnimate!)) {
      _renderingDetails.animationController!.duration = Duration(
          milliseconds:
              _getPointerAnimationDuration(needlePointer.animationDuration));

      final double startValue = axis.isInversed ? 1 : 0;
      final double endValue = axis.isInversed ? 0 : 1;
      double actualValue = needleRenderer.animationStartValue ?? startValue;
      actualValue = actualValue == endValue ? startValue : actualValue;
      _renderingDetails.isOpacityAnimation = (_gauge.enableLoadingAnimation &&
          actualValue == needleRenderer.animationEndValue);
      if (_renderingDetails.isOpacityAnimation) {
        needleRenderer.animationEndValue = endValue;
        if (axis.isInversed) {
          needleRenderer.animationEndValue = actualValue;
          actualValue = endValue;
        }
      }

      pointerAnimation = Tween<double>(
              begin: actualValue, end: needleRenderer.animationEndValue)
          .animate(CurvedAnimation(
              parent: _renderingDetails.animationController!,
              curve: Interval(intervals[0]!, intervals[1]!,
                  curve: _getCurveAnimation(needlePointer.animationType))));
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: NeedlePointerPainter(
                _gauge,
                axis,
                needlePointer,
                needleRenderer.needsRepaintPointer,
                pointerAnimation,
                _renderingDetails.pointerRepaintNotifier,
                _gaugeThemeData,
                _renderingDetails,
                axisRenderer,
                needleRenderer),
            size: Size(constraints.maxWidth, constraints.maxHeight)),
      ),
    ));

    if (_renderingDetails.needsToAnimatePointers ||
        needleRenderer.getIsPointerAnimationEnabled()) {
      _renderingDetails.animationController!.forward(from: 0.0);
    }
  }

  /// Adds the marker pointer
  void _addMarkerPointer(
      RadialAxis axis,
      BoxConstraints constraints,
      MarkerPointer markerPointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer,
      GaugePointerRenderer pointerRenderer) {
    final MarkerPointerRendererBase markerRenderer =
        pointerRenderer as MarkerPointerRendererBase;
    Animation<double>? pointerAnimation;
    final List<double?> pointerIntervals =
        _getPointerAnimationInterval(durationDetails);
    markerRenderer.animationEndValue = markerRenderer.getSweepAngle();
    _renderingDetails.isOpacityAnimation = false;
    if (_renderingDetails.needsToAnimatePointers ||
        (markerPointer.enableAnimation &&
            markerPointer.animationDuration > 0 &&
            markerRenderer.needsAnimate != null &&
            markerRenderer.needsAnimate!)) {
      _renderingDetails.animationController!.duration = Duration(
          milliseconds:
              _getPointerAnimationDuration(markerPointer.animationDuration));
      final double startValue = axis.isInversed ? 1 : 0;
      final double endValue = axis.isInversed ? 0 : 1;
      double actualValue = markerRenderer.animationStartValue ?? startValue;
      _renderingDetails.isOpacityAnimation = (_gauge.enableLoadingAnimation &&
          actualValue == markerRenderer.animationEndValue);
      if (_renderingDetails.isOpacityAnimation) {
        markerRenderer.animationEndValue = endValue;
        if (axis.isInversed) {
          markerRenderer.animationEndValue = actualValue;
          actualValue = endValue;
        }
      }

      pointerAnimation = Tween<double>(
              begin: actualValue, end: markerRenderer.animationEndValue)
          .animate(CurvedAnimation(
              parent: _renderingDetails.animationController!,
              curve: Interval(pointerIntervals[0]!, pointerIntervals[1]!,
                  curve: _getCurveAnimation(markerPointer.animationType))));
    }
    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: MarkerPointerPainter(
                _gauge,
                axis,
                markerPointer,
                markerRenderer.needsRepaintPointer,
                pointerAnimation,
                _renderingDetails.pointerRepaintNotifier,
                _gaugeThemeData,
                _renderingDetails,
                axisRenderer,
                markerRenderer),
            size: Size(constraints.maxWidth, constraints.maxHeight)),
      ),
    ));

    if (_renderingDetails.needsToAnimatePointers ||
        markerRenderer.getIsPointerAnimationEnabled()) {
      _renderingDetails.animationController!.forward(from: 0.0);
    }
  }

  /// Adds the widget pointer
  void _addWidgetPointer(
      RadialAxis axis,
      BoxConstraints constraints,
      WidgetPointer widgetPointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer,
      GaugePointerRenderer pointerRenderer) {
    final WidgetPointerRenderer widgetPointerRenderer =
        pointerRenderer as WidgetPointerRenderer;
    double? actualValue;
    final List<double?> pointerIntervals =
        _getPointerAnimationInterval(durationDetails);
    widgetPointerRenderer.animationEndValue =
        widgetPointerRenderer.getSweepAngle();
    _renderingDetails.isOpacityAnimation = false;
    if (_renderingDetails.needsToAnimatePointers ||
        (widgetPointer.enableAnimation &&
            widgetPointer.animationDuration > 0 &&
            widgetPointerRenderer.needsAnimate != null &&
            widgetPointerRenderer.needsAnimate!)) {
      final double startValue = axis.isInversed ? 1 : 0;
      final double endValue = axis.isInversed ? 0 : 1;
      actualValue = widgetPointerRenderer.animationStartValue ?? startValue;
      _renderingDetails.isOpacityAnimation = (_gauge.enableLoadingAnimation &&
          actualValue == widgetPointerRenderer.animationEndValue);
      if (_renderingDetails.isOpacityAnimation) {
        widgetPointerRenderer.animationEndValue = endValue;
        if (axis.isInversed) {
          widgetPointerRenderer.animationEndValue = actualValue;
          actualValue = endValue;
        }
      }
    }
    final GlobalKey<WidgetPointerContainerState> key = GlobalKey();
    gaugeWidgets.add(WidgetPointerContainer(
        key: key,
        widgetPointer: widgetPointer,
        gauge: _gauge,
        axis: axis,
        interval: pointerIntervals,
        duration: _getPointerAnimationDuration(widgetPointer.animationDuration),
        renderingDetails: _renderingDetails,
        axisRenderer: axisRenderer,
        pointerRenderer: widgetPointerRenderer,
        startValue: actualValue,
        endValue: widgetPointerRenderer.animationEndValue,
        curve: _getCurveAnimation(widgetPointer.animationType)));
  }

  /// Adds the axis range
  void _addRange(
      RadialAxis axis,
      BoxConstraints constraints,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer,
      List<GaugeRangeRenderer> rangeRenderers) {
    for (int k = 0; k < axis.ranges!.length; k++) {
      final GaugeRange range = axis.ranges![k];
      final GaugeRangeRenderer rangeRenderer = rangeRenderers[k];
      Animation<double>? rangeAnimation;
      if (_renderingDetails.needsToAnimateRanges) {
        _renderingDetails.animationController!.duration =
            Duration(milliseconds: _gauge.animationDuration.toInt());
        rangeAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _renderingDetails.animationController!,
                curve: Interval(durationDetails.rangesInterval[0]!,
                    durationDetails.rangesInterval[1]!,
                    curve: Curves.easeIn)));
      }

      gaugeWidgets.add(Container(
        child: RepaintBoundary(
          child: CustomPaint(
              painter: RangePainter(
                  _gauge,
                  axis,
                  range,
                  rangeRenderer.needsRepaintRange,
                  rangeAnimation,
                  _renderingDetails.rangeRepaintNotifier,
                  _gaugeThemeData,
                  _renderingDetails,
                  axisRenderer,
                  rangeRenderer),
              size: Size(constraints.maxWidth, constraints.maxHeight)),
        ),
      ));

      if (rangeAnimation != null) {
        _renderingDetails.animationController!.forward(from: 0.0);
      }
    }
  }

  /// Return the animation duration
  int _getPointerAnimationDuration(double duration) {
    if (_renderingDetails.needsToAnimatePointers) {
      return _gauge.animationDuration.toInt();
    } else {
      return duration.toInt();
    }
  }

  /// Returns the animation interval of pointers
  List<double?> _getPointerAnimationInterval(
      _AnimationDurationDetails durationDetails) {
    List<double?> pointerIntervals = List<double?>.filled(2, null);
    if (_renderingDetails.needsToAnimatePointers) {
      pointerIntervals = durationDetails.pointersInterval;
    } else {
      pointerIntervals[0] = 0;
      pointerIntervals[1] = 1;
    }

    return pointerIntervals;
  }

  /// Adds the axis annotation
  void _addAnnotation(
      RadialAxis axis,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRendererBase axisRenderer) {
    for (int j = 0; j < axis.annotations!.length; j++) {
      final GaugeAnnotation annotation = axis.annotations![j];
      gaugeWidgets.add(AnnotationRenderer(
          annotation: annotation,
          gauge: _gauge,
          axis: axis,
          interval: durationDetails.annotationInterval,
          duration: _gauge.animationDuration.toInt(),
          renderingDetails: _renderingDetails,
          axisRenderer: axisRenderer));
    }
  }

  ///calculates the duration for animation
  void _calculateDurationForAnimation(
      _AnimationDurationDetails durationDetails) {
    num totalCount = 5;
    double interval;
    double startValue = 0.05;
    double endValue = 0;
    for (int i = 0; i < _gauge.axes.length; i++) {
      _calculateAxisElements(_gauge.axes[i], durationDetails);
    }

    totalCount = _getElementsCount(totalCount, durationDetails);

    interval = 1 / totalCount;
    endValue = interval;
    if (durationDetails.hasAxisLine) {
      durationDetails.axisLineInterval = List<double?>.filled(2, null);
      durationDetails.axisLineInterval[0] = startValue;
      durationDetails.axisLineInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasAxisElements) {
      durationDetails.axisElementsInterval = List<double?>.filled(2, null);
      durationDetails.axisElementsInterval[0] = startValue;
      durationDetails.axisElementsInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasRanges) {
      durationDetails.rangesInterval = List<double?>.filled(2, null);
      durationDetails.rangesInterval[0] = startValue;
      durationDetails.rangesInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasPointers) {
      durationDetails.pointersInterval = List<double?>.filled(2, null);
      durationDetails.pointersInterval[0] = startValue;
      durationDetails.pointersInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasAnnotations) {
      durationDetails.annotationInterval = List.filled(2, null);
      durationDetails.annotationInterval[0] = startValue;
      durationDetails.annotationInterval[1] = endValue;
    }
  }

  /// Returns the total elements count
  num _getElementsCount(
      num totalCount, _AnimationDurationDetails durationDetails) {
    if (!durationDetails.hasAnnotations) {
      totalCount -= 1;
    }

    if (!durationDetails.hasPointers) {
      totalCount -= 1;
    }

    if (!durationDetails.hasRanges) {
      totalCount -= 1;
    }

    if (!durationDetails.hasAxisElements) {
      totalCount -= 1;
    }

    if (!durationDetails.hasAxisLine) {
      totalCount -= 1;
    }

    return totalCount;
  }

  /// Calculates the  gauge elements
  void _calculateAxisElements(
      RadialAxis axis, _AnimationDurationDetails durationDetails) {
    if (axis.showAxisLine && !durationDetails.hasAxisLine) {
      durationDetails.hasAxisLine = true;
    }

    if ((axis.showTicks || axis.showLabels) &&
        !durationDetails.hasAxisElements) {
      durationDetails.hasAxisElements = true;
    }

    if (axis.ranges != null &&
        axis.ranges!.isNotEmpty &&
        !durationDetails.hasRanges) {
      durationDetails.hasRanges = true;
    }

    if (axis.pointers != null &&
        axis.pointers!.isNotEmpty &&
        !durationDetails.hasPointers) {
      durationDetails.hasPointers = true;
    }

    if (axis.annotations != null &&
        axis.annotations!.isNotEmpty &&
        !durationDetails.hasAnnotations) {
      durationDetails.hasAnnotations = true;
    }
  }

  /// Method returns the curve animation function based on the animation type
  Curve _getCurveAnimation(AnimationType type) {
    Curve curve = Curves.linear;
    switch (type) {
      case AnimationType.bounceOut:
        curve = Curves.bounceOut;
        break;
      case AnimationType.ease:
        curve = Curves.ease;
        break;
      case AnimationType.easeInCirc:
        curve = Curves.easeInCirc;
        break;
      case AnimationType.easeOutBack:
        curve = Curves.easeOutBack;
        break;
      case AnimationType.elasticOut:
        curve = Curves.elasticOut;
        break;
      case AnimationType.linear:
        curve = Curves.linear;
        break;
      case AnimationType.slowMiddle:
        curve = Curves.slowMiddle;
        break;
    }
    return curve;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: _getGaugeElements(context, constraints),
      );
    });
  }
}

/// Holds the load time animation duration details.
class _AnimationDurationDetails {
  /// Specifies the axis line interval for animation
  late List<double?> axisLineInterval;

  /// Specifies the axis element interval for load time animation
  late List<double?> axisElementsInterval;

  /// Specifies the range interval for initial animation
  late List<double?> rangesInterval;

  /// Specifies the pointer interval for load time animation
  late List<double?> pointersInterval;

  /// Specifies the annotation interval for load time animation
  late List<double?> annotationInterval;

  /// Specifies whether the axis line is enabled
  bool hasAxisLine = false;

  /// Specifies whether the axis element is enabled
  bool hasAxisElements = false;

  /// Specifies whether axis range is enabled
  bool hasRanges = false;

  /// Specifies whether the axis pointers is enabled
  bool hasPointers = false;

  /// Specifies whether the annotation is added
  bool hasAnnotations = false;
}

/// Holds the animation and repainter details.
class RenderingDetails {
  /// Holds the pointer repaint notifier
  late ValueNotifier<int> pointerRepaintNotifier;

  /// Holds the range repaint notifier
  late ValueNotifier<int> rangeRepaintNotifier;

  /// Holds the axis repaint notifier
  late ValueNotifier<int> axisRepaintNotifier;

  /// Holds the animation controller
  AnimationController? animationController;

  /// Specifies whether to animate axes
  late bool needsToAnimateAxes;

  /// Specifies whether to animate ranges
  late bool needsToAnimateRanges;

  /// Specifies whether to animate pointers
  late bool needsToAnimatePointers;

  /// Specifies whether to animate annotation
  late bool needsToAnimateAnnotation;

  /// Specifies axis renderer corresponding to the axis
  late List<RadialAxisRendererBase> axisRenderers;

  /// Specifies the gauge pointer renderers
  late Map<int, List<GaugePointerRenderer>> gaugePointerRenderers;

  /// Specifies the gauge range renderers
  late Map<int, List<GaugeRangeRenderer>> gaugeRangeRenderers;

  /// Specifies whether to animate pointer with opacity
  late bool isOpacityAnimation;
}

/// Specifies the offset value of tick
class TickOffset {
  /// Holds the start point
  late Offset startPoint;

  /// Holds the end point
  late Offset endPoint;

  /// Holds the tick value
  late double value;
}

/// Represents the arc data
class ArcData {
  /// Represents the start angle
  late double startAngle;

  /// Represents the end angle
  late double endAngle;

  /// Represents the arc rect
  late Rect arcRect;
}
