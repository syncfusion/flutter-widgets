import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';

import '../base.dart';
import '../common/callbacks.dart';
import '../interactions/behavior.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import '../utils/zooming_helper.dart';

/// Customizes the zooming options.
///
/// Customize the various zooming actions such as tap zooming, selection
/// zooming, zoom pinch. In selection zooming, you can long-press and drag to
/// select a range on the chart to be zoomed in and also you can customize the
/// selection zooming rectangle using `selectionRectBorderWidth`,
/// `selectionRectBorderColor` and `selectionRectColor` properties.
///
/// Pinch zooming can be performed by moving two fingers over the chart.
/// Default mode is [ZoomMode.xy]. Zooming will be stopped after reaching
/// `maximumZoomLevel`.
///
/// _Note:_ This is only applicable for `SfCartesianChart`.

class ZoomPanBehavior extends ChartBehavior {
  /// Creating an argument constructor of ZoomPanBehavior class.
  ZoomPanBehavior({
    this.enablePinching = false,
    this.enableDoubleTapZooming = false,
    this.enablePanning = false,
    this.enableSelectionZooming = false,
    this.enableMouseWheelZooming = false,
    this.zoomMode = ZoomMode.xy,
    this.maximumZoomLevel = 0.01,
    this.selectionRectBorderWidth = 1,
    this.selectionRectBorderColor,
    this.selectionRectColor,
  });

  /// Enables or disables the pinch zooming.
  ///
  /// Pinching can be performed by moving two fingers over the chart.
  /// You can zoom the chart through pinch gesture in touch enabled devices.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enablePinching: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enablePinching;

  /// Enables or disables the double tap zooming.
  ///
  /// Zooming will enable when you tap double time in plot area.
  /// After reaching the maximum zoom level, zooming will be stopped.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableDoubleTapZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableDoubleTapZooming;

  /// Enables or disables the panning.
  ///
  /// Panning can be performed on a zoomed axis.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enablePanning: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enablePanning;

  /// Enables or disables the selection zooming.
  ///
  /// Selection zooming can be performed by long-press and then dragging.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableSelectionZooming;

  /// Enables or disables the mouseWheelZooming.
  ///
  /// Mouse wheel zooming can be performed by rolling the mouse wheel up or
  /// down. The place where the cursor is hovering gets zoomed in or out
  /// according to the mouse wheel rolling up or down.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableMouseWheelZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableMouseWheelZooming;

  /// By default, both the x and y-axes in the chart can be zoomed.
  ///
  /// It can be changed by setting value to this property.
  ///
  /// Defaults to `ZoomMode.xy`.
  ///
  /// Also refer [ZoomMode].
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     zoomMode: ZoomMode.x
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final ZoomMode zoomMode;

  /// Maximum zoom level.
  ///
  /// Zooming will be stopped after reached this value and ranges from 0 to 1.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     maximumZoomLevel: 0.8
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final double maximumZoomLevel;

  /// Border width of the selection zooming rectangle.
  ///
  /// Used to change the stroke width of the selection rectangle.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectBorderWidth: 2
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final double selectionRectBorderWidth;

  /// Border color of the selection zooming rectangle.
  ///
  /// It used to change the stroke color of the selection rectangle.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectBorderColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final Color? selectionRectBorderColor;

  /// Color of the selection zooming rectangle.
  ///
  /// It used to change the background color of the selection rectangle.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectColor: Colors.yellow
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final Color? selectionRectColor;

  // Holds the previous moved position of panning.
  Offset? _previousMovedPosition;

  // Holds the overall zoom level.
  double _currentZoomLevel = 1.0;

  // Holds the zooming rect start position.
  Offset? _zoomRectStartPosition;

  // Holds the current scale value of pinching.
  double? _previousScale;

  // Holds the value of zooming rect.
  Rect _zoomingRect = Rect.zero;

  // Holds the path of the zooming rect.
  Path? _rectPath;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ZoomPanBehavior &&
        other.enablePinching == enablePinching &&
        other.enableDoubleTapZooming == enableDoubleTapZooming &&
        other.enablePanning == enablePanning &&
        other.enableSelectionZooming == enableSelectionZooming &&
        other.enableMouseWheelZooming == enableMouseWheelZooming &&
        other.zoomMode == zoomMode &&
        other.maximumZoomLevel == maximumZoomLevel &&
        other.selectionRectBorderWidth == selectionRectBorderWidth &&
        other.selectionRectBorderColor == selectionRectBorderColor &&
        other.selectionRectColor == selectionRectColor;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      enablePinching,
      enableDoubleTapZooming,
      enablePanning,
      enableSelectionZooming,
      enableMouseWheelZooming,
      zoomMode,
      maximumZoomLevel,
      selectionRectBorderWidth,
      selectionRectBorderColor,
      selectionRectColor
    ];
    return Object.hashAll(values);
  }

  /// To customize the necessary pointer events in behaviors.
  /// (e.g., CrosshairBehavior, TrackballBehavior, ZoomingBehavior).
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerScrollEvent || event is PointerPanZoomUpdateEvent) {
      _performMouseWheelZooming(event);
    }
  }

  /// Called when pointer tap has contacted the screen double time in behavior.
  @override
  void handleDoubleTap(Offset position) {
    if (enableDoubleTapZooming) {
      _zoomInAndOut(0.25, origin: position);
    }
  }

  /// Called when the pointers in contact with the screen
  /// and initial scale of 1.0.
  @override
  void handleScaleStart(ScaleStartDetails details) {
    if (!enablePinching) {
      return;
    }
    _previousScale = null;
    _updateZoomStartDetails();
  }

  /// Called when the pointers in contact with the screen have indicated
  /// a new scale.
  @override
  void handleScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 1 || !enablePinching) {
      return;
    }
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;

    if (axes == null) {
      return;
    }
    if (details.pointerCount == 2) {
      parent.hideInteractiveTooltip();
      _pinchZoom(axes, parent, details, details.localFocalPoint);
    }
  }

  /// Called when the pointers are no longer in contact with the screen.
  @override
  void handleScaleEnd(ScaleEndDetails details) {
    if (!enablePinching) {
      return;
    }
    _previousScale = null;
    _updateZoomEndDetails();
  }

  void handleHorizontalDragStart(DragStartDetails details) {
    if (!enablePanning) {
      return;
    }
    _previousMovedPosition = null;
    _updateZoomStartDetails();
  }

  void handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (!enablePanning) {
      return;
    }
    _dragUpdate(details.localPosition);
  }

  void handleHorizontalDragEnd(DragEndDetails details) {
    if (!enablePanning) {
      return;
    }
    _previousMovedPosition = null;
    _updateZoomEndDetails();
  }

  void handleVerticalDragStart(DragStartDetails details) {
    if (!enablePanning) {
      return;
    }
    _previousMovedPosition = null;
    _updateZoomStartDetails();
  }

  void handleVerticalDragUpdate(DragUpdateDetails details) {
    if (!enablePanning) {
      return;
    }
    _dragUpdate(details.localPosition);
  }

  void handleVerticalDragEnd(DragEndDetails details) {
    if (!enablePanning) {
      return;
    }
    _previousMovedPosition = null;
    _updateZoomEndDetails();
  }

  /// Called when a long press gesture by a primary button has been
  /// recognized in behavior.
  @override
  void handleLongPressStart(LongPressStartDetails details) {
    if (parentBox == null || !enableSelectionZooming) {
      return;
    }
    final Offset position = parentBox!.globalToLocal(details.globalPosition);
    if (_zoomRectStartPosition != position) {
      _zoomRectStartPosition = position;
    }
  }

  /// Called when moving after the long press gesture by a primary button is
  /// recognized in behavior.
  @override
  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (parentBox == null || !enableSelectionZooming) {
      return;
    }
    final Offset position = parentBox!.globalToLocal(details.globalPosition);
    _doSelectionZooming(details, position.dx, position.dy);
    parentBox!.markNeedsPaint();
  }

  /// Called when the pointer stops contacting the screen after a long-press
  /// by a primary button in behavior.
  @override
  void handleLongPressEnd(LongPressEndDetails details) {
    if (parentBox == null || !enableSelectionZooming) {
      return;
    }
    if (_zoomRectStartPosition != null && _zoomingRect.width != 0) {
      _drawSelectionZoomRect(_zoomingRect);
    }
    _zoomRectStartPosition = null;
    _zoomingRect = Rect.zero;
    parentBox!.markNeedsPaint();
  }

  // Method to perform pan zooming.
  void _pan(
      RenderCartesianAxes axes, RenderBehaviorArea parent, Offset position) {
    double currentZoomPosition;
    double calcZoomPosition;
    if (_previousMovedPosition != null) {
      final Offset translatePosition = _previousMovedPosition! - position;
      axes.visitChildren((RenderObject child) {
        if (child is RenderChartAxis && child.controller.zoomFactor != 1) {
          if (_canZoom(child)) {
            child.zoomingInProgress = true;
            _previousScale ??= _toScaleValue(child.controller.zoomFactor);
            currentZoomPosition = child.controller.zoomPosition;
            calcZoomPosition = _toPanValue(
                child.paintBounds,
                translatePosition,
                child.controller.zoomPosition,
                _previousScale!,
                child.isVertical,
                child.isInversed);
            currentZoomPosition =
                _minMax(calcZoomPosition, 0, 1 - child.controller.zoomFactor);
            if (currentZoomPosition != child.controller.zoomPosition) {
              child.controller.zoomPosition = currentZoomPosition;
            }
            if (parent.onZooming != null) {
              _bindZoomEvent(child, parent.onZooming!);
            }
          }
        }
      });
    }
    _previousMovedPosition = position;
  }

  // Method to perform pinch zooming
  void _pinchZoom(RenderCartesianAxes axes, RenderBehaviorArea parent,
      ScaleUpdateDetails details, Offset location) {
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (_canZoom(child)) {
          child.zoomingInProgress = true;
          final double maxZoomLevel = _toScaleValue(maximumZoomLevel);
          final double origin =
              _calculateOrigin(child, child.paintBounds, location);
          final double currentScale = zoomMode == ZoomMode.xy
              ? details.scale
              : child.isVertical
                  ? details.verticalScale
                  : details.horizontalScale;
          _previousScale ??= _toScaleValue(child.controller.zoomFactor);
          _currentZoomLevel = _previousScale! * currentScale;
          if (_currentZoomLevel > maxZoomLevel) {
            _currentZoomLevel = maxZoomLevel;
          }
          _zoom(parent, child, origin, _currentZoomLevel);
          if (parent.onZooming != null) {
            _bindZoomEvent(child, parent.onZooming!);
          }
        }
      }
    });
  }

  // Method to perform mouse wheel zooming.
  void _performMouseWheelZooming(PointerEvent event) {
    if (enableMouseWheelZooming) {
      int direction = 0;
      if (event is PointerScrollEvent) {
        direction = event.scrollDelta.dy > 0 ? -1 : 1;
      } else if (event is PointerPanZoomUpdateEvent) {
        direction = event.panDelta.dy > 0 ? 1 : -1;
      }

      _zoomInAndOut(0.25 * direction, origin: event.position);
    }
  }

  // Method to find the scale value for current zoom factor.
  double _toScaleValue(double zoomFactor) {
    return max(1 / _minMax(zoomFactor, 0, 1), 1);
  }

  double _toPanValue(Rect bounds, Offset position, double zoomPosition,
      double scale, bool isVertical, bool isInversed) {
    double value = (isVertical
            ? position.dy / bounds.height
            : position.dx / bounds.width) /
        scale;
    if (isVertical && isInversed || !isVertical && !isInversed) {
      value = zoomPosition + value;
    } else {
      value = zoomPosition - value;
    }
    return value;
  }

  // Method to find the chart needs zooming or not.
  bool _canZoom(RenderChartAxis axis) {
    final bool canDirectionalZoom = zoomMode == ZoomMode.xy;

    if ((axis.isVertical && zoomMode == ZoomMode.y) ||
        (!axis.isVertical && zoomMode == ZoomMode.x) ||
        canDirectionalZoom) {
      return true;
    }

    return false;
  }

  // Method to find the origin value based on touch position.
  double _calculateOrigin(
      RenderChartAxis axis, Rect bounds, Offset? manipulation) {
    if (manipulation == null) {
      return 0.5;
    }
    double origin;
    final double plotOffset = axis.plotOffset;

    if (axis.isVertical) {
      origin = axis.isInversed
          ? ((manipulation.dy - plotOffset) / bounds.height)
          : 1 - ((manipulation.dy - plotOffset) / bounds.height);
    } else {
      origin = axis.isInversed
          ? 1.0 - ((manipulation.dx - plotOffset) / bounds.width)
          : (manipulation.dx - plotOffset) / bounds.width;
    }

    return origin;
  }

  // Method to update the zoom values.
  void _zoom(RenderBehaviorArea parent, RenderChartAxis axis,
      double originPoint, double cumulativeZoomLevel) {
    double currentZoomPosition;
    double currentZoomFactor;
    if (cumulativeZoomLevel == 1) {
      currentZoomFactor = 1;
      currentZoomPosition = 0;
    } else {
      currentZoomFactor = _minMax(1 / cumulativeZoomLevel, 0, 1);
      currentZoomPosition = axis.controller.zoomPosition +
          ((axis.controller.zoomFactor - currentZoomFactor) * originPoint);
    }

    if (axis.controller.zoomFactor != currentZoomFactor) {
      axis.controller.zoomFactor = currentZoomFactor;
    }
    if (axis.controller.zoomPosition != currentZoomPosition) {
      axis.controller.zoomPosition =
          _minMax(currentZoomPosition, 0, 1 - axis.controller.zoomFactor);
    }
  }

  double _minMax(double value, double min, double max) {
    return value > max ? max : (value < min ? min : value);
  }

  void _dragUpdate(Offset position) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? axes = parent.cartesianAxes;

    if (axes == null) {
      return;
    }
    _pan(axes, parent, position);
  }

  void _updateZoomStartDetails() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    if (enablePanning || enablePinching) {
      parent.hideInteractiveTooltip();
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    if (parent.onZoomStart != null) {
      axes.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          _bindZoomEvent(child, parent.onZoomStart!);
        }
      });
    }
  }

  void _updateZoomEndDetails() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    if (parent.onZoomEnd != null) {
      axes.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          _bindZoomEvent(child, parent.onZoomEnd!);
        }
      });
    }
  }

  void _zoomInAndOut(double zoomLevel, {Offset? origin}) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }

    final Rect clipRect = parent.paintBounds;
    cartesianAxes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (_canZoom(child)) {
          final double originPoint = _calculateOrigin(child, clipRect, origin);
          child.zoomingInProgress = true;
          if (parent.onZoomStart != null) {
            _bindZoomEvent(child, parent.onZoomStart!);
          }

          final double maxZoomLevel = _toScaleValue(maximumZoomLevel);
          _currentZoomLevel = _toScaleValue(child.controller.zoomFactor);
          _currentZoomLevel = _currentZoomLevel + zoomLevel;
          if (_currentZoomLevel > maxZoomLevel) {
            _currentZoomLevel = maxZoomLevel;
          }

          _zoom(parent, child, originPoint, _currentZoomLevel);

          if (parent.onZoomEnd != null) {
            _bindZoomEvent(child, parent.onZoomEnd!);
          }
        }
      }
    });
  }

  /// Increases the magnification of the plot area.
  void zoomIn() {
    _zoomInAndOut(0.1);
  }

  /// Decreases the magnification of the plot area.
  void zoomOut() {
    _zoomInAndOut(-0.1);
  }

  /// Changes the zoom level using zoom factor.
  ///
  /// Here, you can pass the zoom factor of an axis to magnify the plot
  /// area. The value ranges from 0 to 1.
  void zoomByFactor(double zoomFactor) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    cartesianAxes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (_canZoom(child)) {
          child.controller.zoomFactor = max(zoomFactor, maximumZoomLevel);
          if (parent.onZooming != null) {
            _bindZoomEvent(child, parent.onZooming!);
          }
        }
      }
    });
  }

  /// Zooms the chart for a given rectangle value.
  ///
  /// Here, you can pass the rectangle with the left, right, top, and bottom
  /// values, using which the selection zooming will be performed.
  void zoomByRect(Rect rect) {
    _drawSelectionZoomRect(rect);
  }

  /// Change the zoom level of an appropriate axis.
  ///
  /// Here, you need to pass axis, zoom factor, zoom position of the zoom level
  /// that needs to be modified.
  void zoomToSingleAxis(
      ChartAxis axis, double zoomPosition, double zoomFactor) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderChartAxis? axisDetails = axis.name != null
        ? parent.axisFromName(axis.name)
        : parent.axisFromObject(axis);

    if (axisDetails != null) {
      axisDetails.controller.zoomFactor = max(zoomFactor, maximumZoomLevel);
      axisDetails.controller.zoomPosition = zoomPosition;
    }
    parent.invalidate();
  }

  /// Pans the plot area for given left, right, top, and bottom directions.
  ///
  /// To perform this action, the plot area needs to be in zoomed state.
  void panToDirection(String direction) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    direction = direction.toLowerCase();
    cartesianAxes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        final double currentZoomFactor = child.controller.zoomFactor;
        final double increaseZoomPosition =
            child.controller.zoomPosition + (child.isInversed ? -0.1 : 0.1);
        final double decreaseZoomPosition =
            child.controller.zoomPosition + (child.isInversed ? 0.1 : -0.1);
        if ((child.isVertical && direction == 'bottom') ||
            (!child.isVertical && direction == 'left')) {
          child.controller.zoomPosition =
              _minMax(decreaseZoomPosition, 0, 1 - currentZoomFactor);
        } else if ((child.isVertical && direction == 'top') ||
            (!child.isVertical && direction == 'right')) {
          child.controller.zoomPosition =
              _minMax(increaseZoomPosition, 0, 1 - currentZoomFactor);
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
    });
    parent.invalidate();
  }

  /// Returns the plot area back to its original position after zooming.
  void reset() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }

    cartesianAxes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        child.controller.zoomFactor = 1.0;
        child.controller.zoomPosition = 0.0;
        if (parent.onZoomReset != null) {
          _bindZoomEvent(child, parent.onZoomReset!);
        }
      }
    });
  }

  ZoomPanArgs _bindZoomEvent(
      RenderChartAxis axis, ChartZoomingCallback zoomEventType) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    final ZoomPanArgs zoomPanArgs = ZoomPanArgs(
        axis,
        axis.controller.previousZoomPosition,
        axis.controller.previousZoomFactor);
    zoomPanArgs.currentZoomFactor = axis.controller.zoomFactor;
    zoomPanArgs.currentZoomPosition = axis.controller.zoomPosition;
    if (parent == null) {
      return zoomPanArgs;
    }
    zoomEventType == parent.onZoomStart
        ? parent.onZoomStart!(zoomPanArgs)
        : zoomEventType == parent.onZoomEnd
            ? parent.onZoomEnd!(zoomPanArgs)
            : zoomEventType == parent.onZooming
                ? parent.onZooming!(zoomPanArgs)
                : parent.onZoomReset!(zoomPanArgs);
    return zoomPanArgs;
  }

  void _doSelectionZooming(
      LongPressMoveUpdateDetails details, double currentX, double currentY) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    if (_zoomRectStartPosition != null) {
      final Rect clipRect = parent.paintBounds;
      final Offset startPosition = Offset(
        max(_zoomRectStartPosition!.dx, clipRect.left),
        max(_zoomRectStartPosition!.dy, clipRect.top),
      );
      Offset currentMousePosition =
          startPosition + details.localOffsetFromOrigin;
      final double currentX =
          _minMax(currentMousePosition.dx, clipRect.left, clipRect.right);
      final double currentY =
          _minMax(currentMousePosition.dy, clipRect.top, clipRect.bottom);
      currentMousePosition = Offset(currentX, currentY);
      _rectPath = Path();
      if (zoomMode == ZoomMode.x) {
        _rectPath!.moveTo(startPosition.dx, clipRect.top);
        _rectPath!.lineTo(startPosition.dx, clipRect.bottom);
        _rectPath!.lineTo(currentMousePosition.dx, clipRect.bottom);
        _rectPath!.lineTo(currentMousePosition.dx, clipRect.top);
        _rectPath!.close();
      } else if (zoomMode == ZoomMode.y) {
        _rectPath!.moveTo(clipRect.left, startPosition.dy);
        _rectPath!.lineTo(clipRect.left, currentMousePosition.dy);
        _rectPath!.lineTo(clipRect.right, currentMousePosition.dy);
        _rectPath!.lineTo(clipRect.right, startPosition.dy);
        _rectPath!.close();
      } else {
        _rectPath!.moveTo(startPosition.dx, startPosition.dy);
        _rectPath!.lineTo(startPosition.dx, currentMousePosition.dy);
        _rectPath!.lineTo(currentMousePosition.dx, currentMousePosition.dy);
        _rectPath!.lineTo(currentMousePosition.dx, startPosition.dy);
        _rectPath!.close();
      }
      _zoomingRect = _rectPath!.getBounds();
    }
  }

  void _drawSelectionZoomRect(Rect zoomRect) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        child.zoomingInProgress = true;
        if (parent.onZoomStart != null) {
          _bindZoomEvent(child, parent.onZoomStart!);
        }
        final Rect clipRect = child.paintBounds;
        if (child.isVertical) {
          if (zoomMode != ZoomMode.x) {
            final double zoomRectHeightFromTop =
                zoomRect.height + (zoomRect.top - clipRect.top);
            child.controller.zoomPosition +=
                (1 - (zoomRectHeightFromTop / clipRect.height).abs()) *
                    child.controller.zoomFactor;
            child.controller.zoomFactor *= zoomRect.height / clipRect.height;
            child.controller.zoomFactor =
                max(child.controller.zoomFactor, maximumZoomLevel);
          }
        } else {
          if (zoomMode != ZoomMode.y) {
            final double zoomRectWidthFromLeft = zoomRect.left - clipRect.left;
            child.controller.zoomPosition +=
                (zoomRectWidthFromLeft / clipRect.width).abs() *
                    child.controller.zoomFactor;
            child.controller.zoomFactor *=
                zoomRect.width / child.paintBounds.width;
            child.controller.zoomFactor =
                max(child.controller.zoomFactor, maximumZoomLevel);
          }
        }
        if (parent.onZoomEnd != null) {
          _bindZoomEvent(child, parent.onZoomEnd!);
        }
      }
    });
    zoomRect = Rect.zero;
    _rectPath = Path();
  }

  void _drawTooltipConnector(
      RenderCartesianAxes axes,
      RenderBehaviorArea? parent,
      Offset startPosition,
      Offset endPosition,
      Canvas canvas,
      Rect plotAreaBounds,
      Offset plotAreaOffset) {
    RRect? startTooltipRect, endTooltipRect;
    String startValue, endValue;
    Size startLabelSize, endLabelSize;
    Rect startLabelRect, endLabelRect;
    TextStyle textStyle =
        parent!.chartThemeData!.selectionZoomingTooltipTextStyle!;
    final Paint labelFillPaint = Paint()
      ..color = axes.chartThemeData.crosshairBackgroundColor!
      ..isAntiAlias = true;

    final Paint labelStrokePaint = Paint()
      ..color = axes.chartThemeData.crosshairBackgroundColor!
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (child.interactiveTooltip.enable) {
          textStyle = textStyle.merge(child.interactiveTooltip.textStyle);
          labelFillPaint.color = (child.interactiveTooltip.color ??
              axes.chartThemeData.crosshairBackgroundColor)!;
          labelStrokePaint.color = (child.interactiveTooltip.borderColor ??
              axes.chartThemeData.crosshairBackgroundColor)!;
          labelStrokePaint.strokeWidth = child.interactiveTooltip.borderWidth;
          final Paint connectorLinePaint = Paint()
            ..color = (child.interactiveTooltip.connectorLineColor ??
                axes.chartThemeData.selectionTooltipConnectorLineColor)!
            ..strokeWidth = child.interactiveTooltip.connectorLineWidth
            ..style = PaintingStyle.stroke;

          final Path startLabelPath = Path();
          final Path endLabelPath = Path();
          startValue = tooltipValue(startPosition, child, plotAreaBounds);
          endValue = tooltipValue(endPosition, child, plotAreaBounds);

          if (startValue.isNotEmpty && endValue.isNotEmpty) {
            startLabelSize = measureText(startValue, textStyle);
            endLabelSize = measureText(endValue, textStyle);
            startLabelRect =
                calculateRect(child, startPosition, startLabelSize);
            endLabelRect = calculateRect(child, endPosition, endLabelSize);
            if (child.isVertical &&
                startLabelRect.width != endLabelRect.width) {
              final String axisPosition =
                  child.opposedPosition ? 'right' : 'left';
              (startLabelRect.width > endLabelRect.width)
                  ? endLabelRect =
                      validateRect(startLabelRect, endLabelRect, axisPosition)
                  : startLabelRect =
                      validateRect(endLabelRect, startLabelRect, axisPosition);
            }
            startTooltipRect = calculateTooltipRect(
                canvas,
                labelFillPaint,
                labelStrokePaint,
                startLabelPath,
                startPosition,
                startLabelRect,
                startTooltipRect,
                startValue,
                startLabelSize,
                plotAreaBounds,
                textStyle,
                child,
                plotAreaOffset);
            endTooltipRect = calculateTooltipRect(
                canvas,
                labelFillPaint,
                labelStrokePaint,
                endLabelPath,
                endPosition,
                endLabelRect,
                endTooltipRect,
                endValue,
                endLabelSize,
                plotAreaBounds,
                textStyle,
                child,
                plotAreaOffset);
            drawConnector(canvas, connectorLinePaint, startTooltipRect!,
                endTooltipRect!, startPosition, endPosition, child);
          }
        }
      }
    });
  }

  @override
  void onPaint(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    if (_zoomingRect != Rect.zero && _rectPath != null) {
      Color? fillColor = selectionRectColor;
      if (fillColor != null &&
          fillColor != Colors.transparent &&
          fillColor.opacity == 1) {
        fillColor = fillColor.withOpacity(0.3);
      }
      final Paint fillPaint = Paint()
        ..color =
            (fillColor ?? cartesianAxes.chartThemeData.selectionRectColor)!
        ..style = PaintingStyle.fill;
      context.canvas.drawRect(_zoomingRect, fillPaint);
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..color = (selectionRectBorderColor ??
            cartesianAxes.chartThemeData.selectionRectBorderColor)!
        ..strokeWidth = selectionRectBorderWidth
        ..style = PaintingStyle.stroke;

      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        final List<double> dashArray = <double>[5, 5];
        drawDashes(context.canvas, dashArray, strokePaint, path: _rectPath);
      }

      final Offset plotAreaOffset =
          (parent.parentData! as BoxParentData).offset;
      // Selection zooming tooltip rendering
      _drawTooltipConnector(
          cartesianAxes,
          parent,
          _zoomingRect.topLeft,
          _zoomingRect.bottomRight,
          context.canvas,
          parent.paintBounds,
          plotAreaOffset);
    }
  }
}
