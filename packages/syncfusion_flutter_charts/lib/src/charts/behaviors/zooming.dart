import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../sparkline/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base.dart';
import '../common/callbacks.dart';
import '../common/interactive_tooltip.dart';
import '../interactions/behavior.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';

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

  late bool _isZoomIn, _isZoomOut;
  Path? _rectPath;

  bool? _isPinching = false;
  Offset? _previousMovedPosition;
  Offset? _zoomStartPosition;
  List<PointerEvent> _touchStartPositions = <PointerEvent>[];
  List<PointerEvent> _touchMovePositions = <PointerEvent>[];
  List<_ZoomAxisRange> _zoomAxes = <_ZoomAxisRange>[];

  /// Holds the value of zooming rect.
  Rect _zoomingRect = Rect.zero;

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
      _handlePanZoomUpdate(event);
    }
    if (event is PointerDownEvent) {
      _startPinchZooming(event);
    }
    if (event is PointerMoveEvent) {
      _performPinchZoomUpdate(event);
    }
    if (event is PointerUpEvent) {
      _endPinchZooming(event);
    }
  }

  /// Called when a long press gesture by a primary button has been
  /// recognized in behavior.
  @override
  void handleLongPressStart(LongPressStartDetails details) {
    if (enableSelectionZooming) {
      _longPressStart(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when moving after the long press gesture by a primary button is
  /// recognized in behavior.
  @override
  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (enableSelectionZooming) {
      final Offset position = parentBox!.globalToLocal(details.globalPosition);
      _doSelectionZooming(position.dx, position.dy);
      parentBox!.markNeedsPaint();
    }
  }

  /// Called when the pointer stops contacting the screen after a long-press
  /// by a primary button in behavior.
  @override
  void handleLongPressEnd(LongPressEndDetails details) {
    if (enableSelectionZooming) {
      _longPressEnd();
      parentBox!.markNeedsPaint();
    }
  }

  /// Called when pointer tap has contacted the screen double time in behavior.
  @override
  void handleDoubleTap(Offset position) {
    final RenderBehaviorArea parent = parentBox as RenderBehaviorArea;
    final Offset localPosition = parentBox!.globalToLocal(position);
    if (enableDoubleTapZooming) {
      parent.hideInteractiveTooltip();
      _doubleTap(localPosition, parentBox!.paintBounds);
    }
  }

  /// Called when the pointers in contact with the screen,
  /// and initial scale of 1.0.
  @override
  void handleScaleStart(ScaleStartDetails details) {
    _startPanning();
  }

  /// Called when the pointers in contact with the screen have indicated
  /// a new scale.
  @override
  void handleScaleUpdate(ScaleUpdateDetails details) {
    _performPanning(details);
  }

  /// Called when the pointers are no longer in contact with the screen.
  @override
  void handleScaleEnd(ScaleEndDetails details) {
    _endPanning();
  }

  void _handlePanZoomUpdate(PointerEvent details) {
    if (parentBox!.attached && enableMouseWheelZooming) {
      final Offset localPosition = parentBox!.globalToLocal(details.position);
      final Rect paintBounds = parentBox!.paintBounds;
      _performMouseWheelZooming(
          details, localPosition.dx, localPosition.dy, paintBounds);
    }
  }

  void _performPinchZoomUpdate(PointerMoveEvent event) {
    final RenderBehaviorArea parent = parentBox as RenderBehaviorArea;
    if (parent.performZoomThroughTouch && enablePinching) {
      _zoom(event);
    }
  }

  void _performPanning(ScaleUpdateDetails details) {
    if (enablePanning) {
      _pan(
          parentBox!.globalToLocal(details.focalPoint), parentBox!.paintBounds);
    }
  }

  void _zoom(PointerMoveEvent event) {
    Rect? pinchRect;
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    final Rect clipRect = parent.paintBounds;
    num selectionMin, selectionMax, rangeMin, rangeMax, value, axisTrans;
    double currentFactor, currentPosition, maxZoomFactor, currentZoomFactor;
    int count = 0;
    if (enablePinching && _touchStartPositions.length == 2) {
      _isPinching = true;
      final int pointerID = event.pointer;
      bool addPointer = true;
      for (int i = 0; i < _touchMovePositions.length; i++) {
        if (_touchMovePositions[i].pointer == pointerID) {
          addPointer = false;
        }
      }
      if (_touchMovePositions.length < 2 && addPointer) {
        _touchMovePositions.add(event);
      }
      if (_touchMovePositions.length == 2) {
        if (_touchMovePositions[0].pointer == event.pointer) {
          _touchMovePositions[0] = event;
        }
        if (_touchMovePositions[1].pointer == event.pointer) {
          _touchMovePositions[1] = event;
        }
        Offset touchStart0, touchEnd0, touchStart1, touchEnd1;
        _calculateZoomAxesRange(axes);
        final Rect containerRect = Offset.zero & clipRect.size;
        touchStart0 = _touchStartPositions[0].position - containerRect.topLeft;
        touchEnd0 = _touchMovePositions[0].position - containerRect.topLeft;
        touchStart1 = _touchStartPositions[1].position - containerRect.topLeft;
        touchEnd1 = _touchMovePositions[1].position - containerRect.topLeft;
        final double scaleX = (touchEnd0.dx - touchEnd1.dx).abs() /
            (touchStart0.dx - touchStart1.dx).abs();
        final double scaleY = (touchEnd0.dy - touchEnd1.dy).abs() /
            (touchStart0.dy - touchStart1.dy).abs();
        final double clipX = ((clipRect.left - touchEnd0.dx) / scaleX) +
            min(touchStart0.dx, touchStart1.dx);
        final double clipY = ((clipRect.top - touchEnd0.dy) / scaleY) +
            min(touchStart0.dy, touchStart1.dy);
        pinchRect = Rect.fromLTWH(
            clipX, clipY, clipRect.width / scaleX, clipRect.height / scaleY);
      }
    }
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis && pinchRect != null) {
        child.zoomingInProgress = true;
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          if (!child.isVertical) {
            value = pinchRect.left - clipRect.left;
            axisTrans = clipRect.width / _zoomAxes[count].delta!;
            rangeMin = value / axisTrans + _zoomAxes[count].min!;
            value = pinchRect.left + pinchRect.width - clipRect.left;
            rangeMax = value / axisTrans + _zoomAxes[count].min!;
          } else {
            value = pinchRect.top - clipRect.top;
            axisTrans = clipRect.height / _zoomAxes[count].delta!;
            rangeMin = (value * -1 + clipRect.height) / axisTrans +
                _zoomAxes[count].min!;
            value = pinchRect.top + pinchRect.height - clipRect.top;
            rangeMax = (value * -1 + clipRect.height) / axisTrans +
                _zoomAxes[count].min!;
          }
          selectionMin = min(rangeMin, rangeMax);
          selectionMax = max(rangeMin, rangeMax);
          currentPosition = (selectionMin - _zoomAxes[count].actualMin!) /
              _zoomAxes[count].actualDelta!;
          currentFactor =
              (selectionMax - selectionMin) / _zoomAxes[count].actualDelta!;
          child.controller.zoomPosition =
              currentPosition < 0 ? 0 : currentPosition;
          currentZoomFactor = currentFactor > 1 ? 1 : currentFactor;
          maxZoomFactor = maximumZoomLevel;
          child.controller.zoomFactor = currentZoomFactor < maxZoomFactor
              ? maxZoomFactor
              : currentZoomFactor;
          parent.hideInteractiveTooltip();
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
      count++;
    });
  }

  void _pan(Offset currentPosition, Rect plotAreaBound) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    double currentZoomPosition;
    num currentScale, value;
    if (_previousMovedPosition != null) {
      axes.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          child.zoomingInProgress = true;
          if ((child.isVertical && zoomMode != ZoomMode.x) ||
              (!child.isVertical && zoomMode != ZoomMode.y)) {
            currentZoomPosition = child.controller.zoomPosition;
            currentScale =
                max(1 / _minMax(child.controller.zoomFactor, 0, 1), 1);
            if (child.isVertical) {
              value = (_previousMovedPosition!.dy - currentPosition.dy) /
                  plotAreaBound.height /
                  currentScale;
              currentZoomPosition = _minMax(
                  child.isInversed
                      ? child.controller.zoomPosition + value
                      : child.controller.zoomPosition - value,
                  0,
                  1 - child.controller.zoomFactor);
              if (currentZoomPosition != child.controller.zoomPosition) {
                child.controller.zoomPosition = currentZoomPosition;
                parent.hideInteractiveTooltip();
              }
            } else {
              value = (_previousMovedPosition!.dx - currentPosition.dx) /
                  plotAreaBound.width /
                  currentScale;
              currentZoomPosition = _minMax(
                  child.isInversed
                      ? child.controller.zoomPosition - value
                      : child.controller.zoomPosition + value,
                  0,
                  1 - child.controller.zoomFactor);
              if (currentZoomPosition != child.controller.zoomPosition) {
                child.controller.zoomPosition = currentZoomPosition;
                parent.hideInteractiveTooltip();
              }
            }
          }
          if (parent.onZooming != null) {
            _bindZoomEvent(child, parent.onZooming!);
          }
        }
      });
    }
    _previousMovedPosition = currentPosition;
  }

  void _doubleTap(Offset position, Rect plotAreaBounds) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
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
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          double zoomFactor = child.controller.zoomFactor;
          final double cumulative = max(
              max(1 / _minMax(child.controller.zoomFactor, 0, 1), 1) + (0.25),
              1);
          if (cumulative >= 1) {
            double origin = child.isVertical
                ? 1 - (position.dy / plotAreaBounds.height)
                : position.dx / plotAreaBounds.width;
            origin = origin > 1
                ? 1
                : origin < 0
                    ? 0
                    : origin;
            zoomFactor = cumulative == 1 ? 1 : _minMax(1 / cumulative, 0, 1);
            final double zoomPosition = (cumulative == 1)
                ? 0
                : child.controller.zoomPosition +
                    ((child.controller.zoomFactor - zoomFactor) * origin);
            if (child.controller.zoomPosition != zoomPosition ||
                child.controller.zoomFactor != zoomFactor) {
              zoomFactor = (zoomPosition + zoomFactor) > 1
                  ? (1 - zoomPosition)
                  : zoomFactor;
            }

            child.controller.zoomPosition = zoomPosition;
            child.controller.zoomFactor = zoomFactor;
            parent.hideInteractiveTooltip();
          }
          final double maxZoomFactor = maximumZoomLevel;
          if (zoomFactor < maxZoomFactor) {
            child.controller.zoomFactor = maxZoomFactor;
            child.controller.zoomPosition = 0.0;
            zoomFactor = maxZoomFactor;
          }
        }
        if (parent.onZoomEnd != null) {
          _bindZoomEvent(child, parent.onZoomEnd!);
        }
      }
    });
  }

  /// Below method is for mouse wheel Zooming.
  void _performMouseWheelZooming(
      PointerEvent event, double mouseX, double mouseY, Rect plotAreaBounds) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    double direction = 0.0;
    if (event is PointerScrollEvent) {
      direction = (event.scrollDelta.dy / 120) > 0 ? -1 : 1;
    } else if (event is PointerPanZoomUpdateEvent) {
      direction = event.panDelta.dy == 0
          ? 0
          : (event.panDelta.dy / 120) > 0
              ? 1
              : -1;
    }
    double origin = 0.5;
    double cumulative, zoomFactor, zoomPosition, maxZoomFactor;
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        child.zoomingInProgress = true;
        if (parent.onZoomStart != null) {
          _bindZoomEvent(child, parent.onZoomStart!);
        }
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          cumulative = max(
              max(1 / _minMax(child.controller.zoomFactor, 0, 1), 1) +
                  (0.25 * direction),
              1);
          if (cumulative >= 1) {
            origin = child.isVertical
                ? 1 - (mouseY / plotAreaBounds.height)
                : mouseX / plotAreaBounds.width;
            origin = origin > 1
                ? 1
                : origin < 0
                    ? 0
                    : origin;
            zoomFactor = ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1))
                .toDouble();
            zoomPosition = (cumulative == 1)
                ? 0
                : child.controller.zoomPosition +
                    ((child.controller.zoomFactor - zoomFactor) * origin);
            if (child.controller.zoomPosition != zoomPosition ||
                child.controller.zoomFactor != zoomFactor) {
              zoomFactor = (zoomPosition + zoomFactor) > 1
                  ? (1 - zoomPosition)
                  : zoomFactor;
            }
            child.controller.zoomPosition = zoomPosition < 0
                ? 0
                : zoomPosition > 1
                    ? 1
                    : zoomPosition;
            child.controller.zoomFactor = zoomFactor < 0
                ? 0
                : zoomFactor > 1
                    ? 1
                    : zoomFactor;
            maxZoomFactor = maximumZoomLevel;
            if (zoomFactor < maxZoomFactor) {
              child.controller.zoomFactor = maxZoomFactor;
              zoomFactor = maxZoomFactor;
            }
            parent.hideInteractiveTooltip();
            if (parent.onZoomEnd != null) {
              _bindZoomEvent(child, parent.onZoomEnd!);
            }
            if (child.controller.zoomFactor.toInt() == 1 &&
                child.controller.zoomPosition.toInt() == 0 &&
                parent.onZoomReset != null) {
              _bindZoomEvent(child, parent.onZoomReset!);
            }
          }
        }
      }
    });
  }

  /// Below method for drawing selection rectangle.
  void _doSelectionZooming(double currentX, double currentY) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    if (_isPinching != true && _zoomStartPosition != null) {
      final Offset start = _zoomStartPosition!;
      final Rect clipRect = parent.paintBounds;
      final Offset startPosition = Offset(
          (start.dx < clipRect.left) ? clipRect.left : start.dx,
          (start.dy < clipRect.top) ? clipRect.top : start.dy);
      final Offset currentMousePosition = Offset(
          (currentX > clipRect.right)
              ? clipRect.right
              : ((currentX < clipRect.left) ? clipRect.left : currentX),
          (currentY > clipRect.bottom)
              ? clipRect.bottom
              : ((currentY < clipRect.top) ? clipRect.top : currentY));
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

  /// Increases the magnification of the plot area.
  void zoomIn() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    _isZoomIn = true;
    _isZoomOut = false;
    // TODO(YuvarajG): Need to have variable to notify zooming inprogress
    // _stateProperties.zoomProgress = true;
    bool? needZoom;
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      if ((child.isVertical && zoomMode != ZoomMode.x) ||
          (!child.isVertical && zoomMode != ZoomMode.y)) {
        if (child.controller.zoomFactor <= 1.0 &&
            child.controller.zoomFactor > 0.0) {
          if (child.controller.zoomFactor - 0.1 < 0) {
            needZoom = false;
            break;
          } else {
            _updateZoomFactorAndZoomPosition(child);
            needZoom = true;
          }
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    if (needZoom ?? false) {
      (parentBox as RenderBehaviorArea?)?.invalidate();
    }
  }

  /// Decreases the magnification of the plot area.
  void zoomOut() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    _isZoomIn = false;
    _isZoomOut = true;
    // TODO(YuvarajG): Need to have variable to notify zooming inprogress
    // _stateProperties.zoomProgress = true;
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      if ((child.isVertical && zoomMode != ZoomMode.x) ||
          (!child.isVertical && zoomMode != ZoomMode.y)) {
        if (child.controller.zoomFactor < 1.0 &&
            child.controller.zoomFactor > 0.0) {
          _updateZoomFactorAndZoomPosition(child);
          child.controller.zoomFactor = child.controller.zoomFactor > 1.0
              ? 1.0
              : (child.controller.zoomFactor < 0.0
                  ? 0.0
                  : child.controller.zoomFactor);
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    (parentBox as RenderBehaviorArea?)?.invalidate();
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
    _isZoomIn = false;
    _isZoomOut = true;
    // TODO(YuvarajG): Need to have variable to notify zooming inprogress
    // _stateProperties.zoomProgress = true;
    RenderChartAxis? child = cartesianAxes.firstChild;
    if (zoomFactor.clamp(0.0, 1.0) == zoomFactor) {
      while (child != null) {
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          child.controller.zoomFactor = zoomFactor;
          if (parent.onZooming != null) {
            _bindZoomEvent(child, parent.onZooming!);
          }
        }
        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
      (parentBox as RenderBehaviorArea?)?.invalidate();
    }
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
      axisDetails.controller.zoomFactor = zoomFactor;
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
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      if (child.isVertical) {
        if (direction == 'bottom') {
          child.controller.zoomPosition = (child.controller.zoomPosition > 0 &&
                  child.controller.zoomPosition <= 1.0)
              ? child.controller.zoomPosition - 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition < 0.0
              ? 0.0
              : child.controller.zoomPosition;
        }
        if (direction == 'top') {
          child.controller.zoomPosition = (child.controller.zoomPosition >= 0 &&
                  child.controller.zoomPosition < 1)
              ? child.controller.zoomPosition + 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition > 1.0
              ? 1.0
              : child.controller.zoomPosition;
        }
      } else {
        if (direction == 'left') {
          child.controller.zoomPosition = (child.controller.zoomPosition > 0 &&
                  child.controller.zoomPosition <= 1.0)
              ? child.controller.zoomPosition - 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition < 0.0
              ? 0.0
              : child.controller.zoomPosition;
        }
        if (direction == 'right') {
          child.controller.zoomPosition = (child.controller.zoomPosition >= 0 &&
                  child.controller.zoomPosition < 1)
              ? child.controller.zoomPosition + 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition > 1.0
              ? 1.0
              : child.controller.zoomPosition;
        }
      }
      if (parent.onZooming != null) {
        _bindZoomEvent(child, parent.onZooming!);
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
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
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      child.controller.zoomFactor = 1.0;
      child.controller.zoomPosition = 0.0;
      if (parent.onZoomReset != null) {
        _bindZoomEvent(child, parent.onZoomReset!);
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    parent.invalidate();
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

  /// Below method for zooming selected portion.
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
        if (child.isVertical) {
          if (zoomMode != ZoomMode.x) {
            child.controller.zoomPosition += (1 -
                    ((zoomRect.height +
                                (zoomRect.top - child.paintBounds.top)) /
                            (child.paintBounds.height))
                        .abs()) *
                child.controller.zoomFactor;
            child.controller.zoomFactor *=
                zoomRect.height / child.paintBounds.height;

            child.controller.zoomFactor =
                child.controller.zoomFactor >= maximumZoomLevel
                    ? child.controller.zoomFactor
                    : maximumZoomLevel;
          }
        } else {
          if (zoomMode != ZoomMode.y) {
            child.controller.zoomPosition +=
                ((zoomRect.left - child.paintBounds.left) /
                            (child.paintBounds.width))
                        .abs() *
                    child.controller.zoomFactor;
            child.controller.zoomFactor *=
                zoomRect.width / child.paintBounds.width;
            child.controller.zoomFactor =
                child.controller.zoomFactor >= maximumZoomLevel
                    ? child.controller.zoomFactor
                    : maximumZoomLevel;
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

  double _minMax(double value, double min, double max) {
    return value > max ? max : (value < min ? min : value);
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
      //Selection zooming tooltip rendering
      _drawTooltipConnector(
          cartesianAxes,
          _zoomingRect.topLeft,
          _zoomingRect.bottomRight,
          context.canvas,
          parent.paintBounds,
          plotAreaOffset);
    }
  }

  void _calculateZoomAxesRange(RenderCartesianAxes axes) {
    _ZoomAxisRange range;
    axes.visitChildren((RenderObject child) {
      range = _ZoomAxisRange();
      if (child is RenderChartAxis) {
        if (child.actualRange != null) {
          range.actualMin = child.actualRange!.minimum.toDouble();
          range.actualDelta = child.actualRange!.delta.toDouble();
        }
        range.min = child.visibleRange!.minimum.toDouble();
        range.delta = child.visibleRange!.delta.toDouble();
        _zoomAxes.add(range);
      }
    });
  }

  /// Returns the tooltip label on zooming.
  String _tooltipValue(
      Offset position, RenderChartAxis axis, Rect plotAreaBounds) {
    final num value = axis.isVertical
        ? axis.pixelToPoint(axis.paintBounds, position.dx, position.dy)
        : axis.pixelToPoint(axis.paintBounds, position.dx - plotAreaBounds.left,
            position.dy - plotAreaBounds.top);

    dynamic result = _interactiveTooltipLabel(value, axis);
    if (axis.interactiveTooltip.format != null) {
      final String stringValue =
          axis.interactiveTooltip.format!.replaceAll('{value}', result);
      result = stringValue;
    }
    return result.toString();
  }

  /// Validate the rect by comparing small and large rect.
  Rect _validateRect(Rect largeRect, Rect smallRect, String axisPosition) =>
      Rect.fromLTRB(
          axisPosition == 'left'
              ? (smallRect.left - (largeRect.width - smallRect.width))
              : smallRect.left,
          smallRect.top,
          axisPosition == 'right'
              ? (smallRect.right + (largeRect.width - smallRect.width))
              : smallRect.right,
          smallRect.bottom);

  /// Calculate the interactive tooltip rect, based on the zoomed axis position.
  Rect _calculateRect(RenderChartAxis axis, Offset position, Size labelSize) {
    const double paddingForRect = 10;
    final Rect axisBound =
        (axis.parentData! as BoxParentData).offset & axis.size;
    final double arrowLength = axis.interactiveTooltip.arrowLength;
    double left, top;
    final double width = labelSize.width + paddingForRect;
    final double height = labelSize.height + paddingForRect;

    if (axis.isVertical) {
      top = position.dy - height / 2;
      if (axis.opposedPosition) {
        left = axisBound.left + arrowLength;
      } else {
        left = axisBound.left - width - arrowLength;
      }
    } else {
      left = position.dx - width / 2;
      if (axis.opposedPosition) {
        top = axisBound.top - height - arrowLength;
      } else {
        top = axisBound.top + arrowLength;
      }
    }
    return Rect.fromLTWH(left, top, width, height);
  }

  /// To draw tooltip connector.
  void _drawTooltipConnector(
      RenderCartesianAxes axes,
      Offset startPosition,
      Offset endPosition,
      Canvas canvas,
      Rect plotAreaBounds,
      Offset plotAreaOffset) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
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
          startValue = _tooltipValue(startPosition, child, plotAreaBounds);
          endValue = _tooltipValue(endPosition, child, plotAreaBounds);

          if (startValue.isNotEmpty && endValue.isNotEmpty) {
            startLabelSize = measureText(startValue, textStyle);
            endLabelSize = measureText(endValue, textStyle);
            startLabelRect =
                _calculateRect(child, startPosition, startLabelSize);
            endLabelRect = _calculateRect(child, endPosition, endLabelSize);
            if (child.isVertical &&
                startLabelRect.width != endLabelRect.width) {
              final String axisPosition =
                  child.opposedPosition ? 'right' : 'left';
              (startLabelRect.width > endLabelRect.width)
                  ? endLabelRect =
                      _validateRect(startLabelRect, endLabelRect, axisPosition)
                  : startLabelRect =
                      _validateRect(endLabelRect, startLabelRect, axisPosition);
            }
            startTooltipRect = _drawTooltip(
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
            endTooltipRect = _drawTooltip(
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
            _drawConnector(canvas, connectorLinePaint, startTooltipRect!,
                endTooltipRect!, startPosition, endPosition, child);
          }
        }
      }
    });
  }

  /// To draw connectors.
  void _drawConnector(
      Canvas canvas,
      Paint connectorLinePaint,
      RRect startTooltipRect,
      RRect endTooltipRect,
      Offset startPosition,
      Offset endPosition,
      RenderChartAxis axis) {
    final InteractiveTooltip tooltip = axis.interactiveTooltip;
    if (!axis.isVertical && !axis.opposedPosition) {
      startPosition =
          Offset(startPosition.dx, startTooltipRect.top - tooltip.arrowLength);
      endPosition =
          Offset(endPosition.dx, endTooltipRect.top - tooltip.arrowLength);
    } else if (!axis.isVertical && axis.opposedPosition) {
      startPosition = Offset(
          startPosition.dx, startTooltipRect.bottom + tooltip.arrowLength);
      endPosition =
          Offset(endPosition.dx, endTooltipRect.bottom + tooltip.arrowLength);
    } else if (axis.isVertical && !axis.opposedPosition) {
      startPosition = Offset(
          startTooltipRect.right + tooltip.arrowLength, startPosition.dy);
      endPosition =
          Offset(endTooltipRect.right + tooltip.arrowLength, endPosition.dy);
    } else {
      startPosition =
          Offset(startTooltipRect.left - tooltip.arrowLength, startPosition.dy);
      endPosition =
          Offset(endTooltipRect.left - tooltip.arrowLength, endPosition.dy);
    }
    drawDashedPath(canvas, connectorLinePaint, startPosition, endPosition,
        tooltip.connectorLineDashArray);
  }

  /// To draw tooltip.
  RRect _drawTooltip(
      Canvas canvas,
      Paint fillPaint,
      Paint strokePaint,
      Path path,
      Offset position,
      Rect labelRect,
      RRect? rect,
      String value,
      Size labelSize,
      Rect plotAreaBound,
      TextStyle textStyle,
      RenderChartAxis axis,
      Offset plotAreaOffset) {
    final Offset parentDataOffset = (axis.parentData! as BoxParentData).offset;
    final Offset axisOffset =
        parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
    final Rect axisRect = axisOffset & axis.size;
    labelRect = _validateRectBounds(labelRect, axisRect);
    labelRect = axis.isVertical
        ? _validateRectYPosition(labelRect, plotAreaBound)
        : _validateRectXPosition(labelRect, plotAreaBound);
    path.reset();
    rect = RRect.fromRectAndRadius(
        labelRect, Radius.circular(axis.interactiveTooltip.borderRadius));
    path.addRRect(rect);
    _calculateNeckPositions(
        canvas, fillPaint, strokePaint, path, position, rect, axis);
    drawText(
      canvas,
      value,
      Offset((rect.left + rect.width / 2) - labelSize.width / 2,
          (rect.top + rect.height / 2) - labelSize.height / 2),
      textStyle,
    );
    return rect;
  }

  /// To calculate tooltip neck positions.
  void _calculateNeckPositions(
      Canvas canvas,
      Paint fillPaint,
      Paint strokePaint,
      Path path,
      Offset position,
      RRect rect,
      RenderChartAxis axis) {
    final InteractiveTooltip tooltip = axis.interactiveTooltip;
    double x1, x2, x3, x4, y1, y2, y3, y4;
    if (!axis.isVertical && !axis.opposedPosition) {
      x1 = position.dx;
      y1 = rect.top - tooltip.arrowLength;
      x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
      y2 = rect.top;
      x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
      y3 = rect.top;
      x4 = position.dx;
      y4 = rect.top - tooltip.arrowLength;
    } else if (!axis.isVertical && axis.opposedPosition) {
      x1 = position.dx;
      y1 = rect.bottom + tooltip.arrowLength;
      x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
      y2 = rect.bottom;
      x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
      y3 = rect.bottom;
      x4 = position.dx;
      y4 = rect.bottom + tooltip.arrowLength;
    } else if (axis.isVertical && !axis.opposedPosition) {
      x1 = rect.right;
      y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
      x2 = rect.right;
      y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
      x3 = rect.right + tooltip.arrowLength;
      y3 = position.dy;
      x4 = rect.right + tooltip.arrowLength;
      y4 = position.dy;
    } else {
      x1 = rect.left;
      y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
      x2 = rect.left;
      y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
      x3 = rect.left - tooltip.arrowLength;
      y3 = position.dy;
      x4 = rect.left - tooltip.arrowLength;
      y4 = position.dy;
    }
    _drawTooltipArrowhead(
        canvas, path, fillPaint, strokePaint, x1, y1, x2, y2, x3, y3, x4, y4);
  }

  /// Below method is for zoomIn and zoomOut public methods.
  void _updateZoomFactorAndZoomPosition(RenderChartAxis axis) {
    final Rect axisClipRect = axis.paintBounds;
    double? zoomFactor, zoomPosition;
    final num direction = _isZoomIn
        ? 1
        : _isZoomOut
            ? -1
            : 1;
    final num cumulative = max(
        max(1 / _minMax(axis.controller.zoomFactor, 0, 1), 1) +
            (0.1 * direction),
        1);
    if (cumulative >= 1) {
      num origin = axis.isVertical
          ? 1 -
              ((axisClipRect.top + axisClipRect.height / 2) /
                  axisClipRect.height)
          : (axisClipRect.left + axisClipRect.width / 2) / axisClipRect.width;
      origin = origin > 1
          ? 1
          : origin < 0
              ? 0
              : origin;
      zoomFactor =
          ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1)).toDouble();
      zoomPosition = (cumulative == 1)
          ? 0
          : axis.controller.zoomPosition +
              ((axis.controller.zoomFactor - zoomFactor) * origin);
      if (axis.controller.zoomPosition != zoomPosition ||
          axis.controller.zoomFactor != zoomFactor) {
        zoomFactor =
            (zoomPosition + zoomFactor) > 1 ? (1 - zoomPosition) : zoomFactor;
      }

      axis.controller.zoomPosition = zoomPosition;
      axis.controller.zoomFactor = zoomFactor;
    }
  }

  void _startPinchZooming(PointerEvent event) {
    if (_touchStartPositions.length < 2) {
      _touchStartPositions.add(event);
    }

    if (_touchStartPositions.length == 2) {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent != null &&
          parent.onZoomStart != null &&
          parent.cartesianAxes != null) {
        parent.hideInteractiveTooltip();
        final RenderCartesianAxes axes = parent.cartesianAxes!;

        axes.visitChildren((RenderObject child) {
          if (child is RenderChartAxis) {
            _bindZoomEvent(child, parent.onZoomStart!);
          }
        });
      }
    }
  }

  // ignore: unused_element
  void _endPinchZooming(PointerUpEvent event) {
    if (_touchStartPositions.length == 2 && _touchMovePositions.length == 2) {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent != null && parent.cartesianAxes != null) {
        final RenderCartesianAxes axes = parent.cartesianAxes!;

        axes.visitChildren((RenderObject child) {
          if (child is RenderChartAxis) {
            if (parent.onZoomEnd != null) {
              _bindZoomEvent(child, parent.onZoomEnd!);
            }
          }
        });
      }
    }

    _zoomAxes = <_ZoomAxisRange>[];
    _touchMovePositions = <PointerEvent>[];
    _touchStartPositions = <PointerEvent>[];
    _isPinching = false;
  }

  void _startPanning() {
    _previousMovedPosition = null;
  }

  void _endPanning() {
    _previousMovedPosition = null;
  }

  void _longPressStart(Offset position) {
    if (_zoomStartPosition != position) {
      _zoomStartPosition = position;
    }
  }

  void _longPressEnd() {
    if (_zoomStartPosition != null && _zoomingRect.width != 0) {
      _drawSelectionZoomRect(_zoomingRect);
    }
    _zoomStartPosition = null;
    _zoomingRect = Rect.zero;
  }
}

/// This method will validate whether the tooltip exceeds the screen or not.
Rect _validateRectBounds(Rect tooltipRect, Rect boundary) {
  Rect validatedRect = tooltipRect;
  double difference = 0;

  /// Padding between the corners.
  const double padding = 0.5;

  // Move the tooltip if it's outside of the boundary.
  if (tooltipRect.left < boundary.left) {
    difference = (boundary.left - tooltipRect.left) + padding;
    validatedRect = validatedRect.translate(difference, 0);
  }
  if (tooltipRect.right > boundary.right) {
    difference = (tooltipRect.right - boundary.right) + padding;
    validatedRect = validatedRect.translate(-difference, 0);
  }
  if (tooltipRect.top < boundary.top) {
    difference = (boundary.top - tooltipRect.top) + padding;
    validatedRect = validatedRect.translate(0, difference);
  }

  if (tooltipRect.bottom > boundary.bottom) {
    difference = (tooltipRect.bottom - boundary.bottom) + padding;
    validatedRect = validatedRect.translate(0, -difference);
  }
  return validatedRect;
}

/// Gets the x position of validated rect.
Rect _validateRectYPosition(Rect labelRect, Rect axisClipRect) {
  Rect validatedRect = labelRect;
  if (labelRect.bottom >= axisClipRect.bottom) {
    validatedRect = Rect.fromLTRB(
        labelRect.left,
        labelRect.top - (labelRect.bottom - axisClipRect.bottom),
        labelRect.right,
        axisClipRect.bottom);
  } else if (labelRect.top <= axisClipRect.top) {
    validatedRect = Rect.fromLTRB(labelRect.left, axisClipRect.top,
        labelRect.right, labelRect.bottom + (axisClipRect.top - labelRect.top));
  }
  return validatedRect;
}

/// Gets the x position of validated rect.
Rect _validateRectXPosition(Rect labelRect, Rect axisClipRect) {
  Rect validatedRect = labelRect;
  if (labelRect.right >= axisClipRect.right) {
    validatedRect = Rect.fromLTRB(
        labelRect.left - (labelRect.right - axisClipRect.right),
        labelRect.top,
        axisClipRect.right,
        labelRect.bottom);
  } else if (labelRect.left <= axisClipRect.left) {
    validatedRect = Rect.fromLTRB(
        axisClipRect.left,
        labelRect.top,
        labelRect.right + (axisClipRect.left - labelRect.left),
        labelRect.bottom);
  }
  return validatedRect;
}

/// Draw tooltip arrow head.
void _drawTooltipArrowhead(
    Canvas canvas,
    Path backgroundPath,
    Paint fillPaint,
    Paint strokePaint,
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
    double x4,
    double y4) {
  backgroundPath.moveTo(x1, y1);
  backgroundPath.lineTo(x2, y2);
  backgroundPath.lineTo(x3, y3);
  backgroundPath.lineTo(x4, y4);
  backgroundPath.lineTo(x1, y1);
  fillPaint.isAntiAlias = true;
  canvas.drawPath(backgroundPath, strokePaint);
  canvas.drawPath(backgroundPath, fillPaint);
}

/// To get interactive tooltip label.
dynamic _interactiveTooltipLabel(dynamic value, RenderChartAxis axis) {
  if (axis.visibleLabels.isEmpty) {
    return '';
  }

  final int labelsLength = axis.visibleLabels.length;
  if (axis is RenderCategoryAxis) {
    value = value < 0 ? 0 : value;
    value = axis.labels[(value.round() >= axis.labels.length
            ? (value.round() > axis.labels.length
                ? axis.labels.length - 1
                : value - 1)
            : value.round())
        .round()];
  } else if (axis is RenderDateTimeCategoryAxis) {
    value = value < 0 ? 0 : value;
    value = axis.labels[(value.round() >= axis.labels.length
            ? (value.round() > axis.labels.length
                ? axis.labels.length - 1
                : value - 1)
            : value.round())
        .round()];
  } else if (axis is RenderDateTimeAxis) {
    final num interval = axis.visibleRange!.minimum.ceil();
    final num previousInterval = (axis.visibleLabels.isNotEmpty)
        ? axis.visibleLabels[labelsLength - 1].value
        : interval;
    final DateFormat dateFormat = axis.dateFormat ??
        _dateTimeLabelFormat(axis, interval.toInt(), previousInterval.toInt());
    value =
        dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  } else {
    value = axis is RenderLogarithmicAxis ? pow(10, value) : value;
    value = _labelValue(value, axis, axis.interactiveTooltip.decimalPlaces);
  }
  return value;
}

/// To get the label format of the date-time axis.
DateFormat _dateTimeLabelFormat(RenderChartAxis axis,
    [int? interval, int? prevInterval]) {
  DateFormat? format;
  final bool notDoubleInterval =
      (axis.interval != null && axis.interval! % 1 == 0) ||
          axis.interval == null;
  DateTimeIntervalType? actualIntervalType;
  num? minimum;
  if (axis is RenderDateTimeAxis) {
    actualIntervalType = axis.visibleIntervalType;
    minimum = axis.visibleRange!.minimum;
  } else if (axis is RenderDateTimeCategoryAxis) {
    minimum = axis.visibleRange!.minimum;
    actualIntervalType = axis.visibleIntervalType;
  }
  switch (actualIntervalType) {
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
      break;
    // ignore: no_default_cases
    default:
      break;
  }
  return format!;
}

/// Gets the the actual label value for tooltip and data label etc.
String _labelValue(dynamic value, dynamic axis, [int? showDigits]) {
  if (value.toString().split('.').length > 1) {
    final String str = value.toString();
    final List list = str.split('.');
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
  final dynamic text = axis is NumericAxis && axis.numberFormat != null
      ? axis.numberFormat!.format(value)
      : value;
  return ((axis.labelFormat != null && axis.labelFormat != '')
      ? axis.labelFormat.replaceAll(RegExp('{value}'), text.toString())
      : text.toString()) as String;
}

/// Calculate the dateTime format.
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

/// Returns the first label format for date time values.
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

/// Represents the zoom axis range class.
class _ZoomAxisRange {
  /// Holds the value of actual minimum, actual delta, minimum and delta value.
  double? actualMin, actualDelta, min, delta;
}
