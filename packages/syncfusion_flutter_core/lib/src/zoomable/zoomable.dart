import 'dart:async' show Timer;
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Matrix4;

/// Signature for when the zoom level or actual rect value changes get
/// indicated.
typedef ZoomableUpdateCallback = bool Function(ZoomableDetails);

/// Signature for when the zooming and panning action has been completed.
typedef ZoomableCompleteCallback = void Function(ZoomableDetails);

/// Signature for when zoom level change callback.
typedef ScaleCallback = void Function(double);

/// Signature for when actual rect change callback.
typedef TranslationCallback = void Function(Rect);

/// Specifies the current zoom pan action type.
enum ActionType {
  /// Denotes the current action as pinching.
  pinch,

  /// Denotes the current action as panning.
  pan,

  /// Denotes the current action as double tap.
  tap,

  /// Denotes the current action as flinging.
  fling,

  /// Denotes there is no action currently.
  none
}

/// Contains details about the current zooming and panning action.
class ZoomableDetails {
  /// Creates a [ZoomableDetails].
  ZoomableDetails({
    required this.localFocalPoint,
    required this.globalFocalPoint,
    required this.previousZoomLevel,
    required this.zoomLevel,
    required this.previousAbsoluteBounds,
    required this.absoluteBounds,
    required this.scale,
    required this.scaleFocalPoint,
  });

  /// The local focal point of the pointers in contact with the screen.
  final Offset localFocalPoint;

  /// The global focal point of the pointers in contact with the screen.
  final Offset globalFocalPoint;

  /// Provides the last zoom level which has been in zoomable.
  final double previousZoomLevel;

  /// Provides the new zoom level for the current zooming.
  final double zoomLevel;

  /// Specifies the previous rect of the zoomable.
  final Rect previousAbsoluteBounds;

  /// Specifies the new rect for the current zooming.
  final Rect absoluteBounds;

  /// Specifies the current scale based on interaction.
  final double scale;

  /// Specified the center point which we have pinching currently.
  final Offset? scaleFocalPoint;
}

/// A widget which handles the zooming and panning with considering its bounds
/// based on the zoomLevel and child size.
class Zoomable extends StatefulWidget {
  /// Creates a [Zoomable].
  const Zoomable({
    Key? key,
    required this.controller,
    required this.boundary,
    this.minZoomLevel = 1.0,
    this.maxZoomLevel = 15.0,
    this.enablePinching = true,
    this.enablePanning = true,
    this.enableDoubleTapZooming = true,
    this.frictionCoefficient = 0.005,
    this.animationDuration = const Duration(milliseconds: 600),
    this.onWillUpdate,
    this.onComplete,
    this.child,
  })  : assert(minZoomLevel >= 1 && minZoomLevel <= maxZoomLevel),
        assert(frictionCoefficient > 0.0),
        super(key: key);

  /// Holds the details of the current zoom level and actual rect. These details
  /// can be used in multiple widget which used the same zoomable widget.
  final ZoomableController controller;

  /// A rect which is used to translate the controller matrix initially.
  final Rect boundary;

  /// Specifies the minimum zoomLevel of the widget.
  ///
  /// It can't be null and must be greater than or equal to `1` and lesser than
  /// [maxZoomLevel].
  final double minZoomLevel;

  /// Specifies the maximum zoomLevel of the widget.
  ///
  /// It can't be null and must be greater than or equal to `1` and
  /// [minZoomLevel].
  final double maxZoomLevel;

  /// Option to enable pinch zooming support.
  ///
  /// By default it will be `true`.
  final bool enablePinching;

  /// Option to enable panning support.
  ///
  /// By default it will be `true`.
  final bool enablePanning;

  /// Option to enable double tap zooming support.
  ///
  /// By default it will be `true`.
  final bool enableDoubleTapZooming;

  /// In the inertial translation animation, this value is used as the
  /// coefficient of friction.
  ///
  /// By default it will be `0.005`.
  final double frictionCoefficient;

  /// An animation duration which is used to animate the zoom level and actual
  /// rect property change using the given duration.
  ///
  /// By default it will be `600` milliseconds.
  final Duration animationDuration;

  /// Called when there is a change in the zoom level or actual rect of the
  /// zoomable widget.
  final ZoomableUpdateCallback? onWillUpdate;

  /// Called when the zoom level or actual rect updating has been completed.
  final ZoomableCompleteCallback? onComplete;

  /// Specifies the child of the zoomable widget. It didn't get updated based on
  /// the zoomable widget interaction or changes.
  ///
  /// By default it will be `null`.
  final Widget? child;

  /// Returns a scale value for given zoom level.
  static double getScale(double zoomLevel) {
    return pow(2, zoomLevel - 1).toDouble();
  }

  /// Returns a zoom level for given scale value.
  static double getZoomLevel(double scale) {
    return (log(scale) / log(2)) + 1;
  }

  @override
  // ignore: library_private_types_in_public_api
  _ZoomableState createState() => _ZoomableState();
}

class _ZoomableState extends State<Zoomable> with TickerProviderStateMixin {
  late AnimationController _zoomLevelController;
  late AnimationController _translationController;
  late CurvedAnimation _zoomLevelAnimation;
  late CurvedAnimation _translationAnimation;
  late Tween<double> _zoomLevelTween;
  late Tween<Offset> _translationTween;
  late Offset _scaleFocalPoint;

  Timer? _doubleTapTimer;
  Offset? _referenceFocalPoint;

  double _maxAttainedScale = 1.0;
  double _currentScale = 1.0;
  double? _referenceScale;
  int _pointerCount = 0;
  bool _doubleTapEnabled = false;

  Offset _getCurrentTranslation(Matrix4 matrix) {
    final Vector3 translation = matrix.getTranslation();
    return Offset(translation.x, translation.y);
  }

  Size _getAbsoluteChildSize(double zoomLevel) {
    return Size((widget.boundary.width / 2) * pow(2, zoomLevel).toDouble(),
        (widget.boundary.height / 2) * pow(2, zoomLevel).toDouble());
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enableDoubleTapZooming) {
      _doubleTapTimer ??= Timer(kDoubleTapTimeout, _resetDoubleTapTimer);
    }

    if (_zoomLevelController.isAnimating &&
        widget.controller._action == ActionType.fling) {
      _zoomLevelController.stop();
      _handleZoomLevelAnimationEnd();
    }

    if (_translationController.isAnimating &&
        widget.controller._action == ActionType.fling) {
      _translationController.stop();
      _handleActualRectAnimationEnd();
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (!_zoomLevelController.isAnimating &&
        !_translationController.isAnimating) {
      // Scale gesture is handling both scale and pan actions so we can't
      // predict whether the current action is scale or pan in scale start.
      widget.controller._action = ActionType.none;
      _maxAttainedScale = 1.0;
      _currentScale = 1.0;

      _scaleFocalPoint = details.localFocalPoint;
      _referenceScale = widget.controller.matrix.getMaxScaleOnAxis();
      _referenceFocalPoint =
          _getPointOnChild(widget.controller.matrix, _scaleFocalPoint);
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!_zoomLevelController.isAnimating &&
        !_translationController.isAnimating) {
      if (widget.controller._action == ActionType.none) {
        widget.controller._action = _getActionTypes(
            details.scale, details.localFocalPoint - _scaleFocalPoint);
      }

      if (widget.controller._action == ActionType.none) {
        return;
      }

      _resetDoubleTapTimer();
      final Matrix4 matrix = widget.controller.matrix.clone();
      switch (widget.controller._action) {
        case ActionType.pinch:
          final double prevScale = matrix.getMaxScaleOnAxis();
          _referenceScale ??= prevScale;
          // At scale end, to perform fling we need to know the direction
          // of the zooming. For that, we have stored the max scale value
          // reached during the scale update.
          if (_currentScale < details.scale) {
            _maxAttainedScale = details.scale;
          }

          _currentScale = details.scale;
          double newScale = (_referenceScale! * details.scale) / prevScale;
          newScale = (newScale * prevScale).clamp(
              Zoomable.getScale(widget.minZoomLevel),
              Zoomable.getScale(widget.maxZoomLevel));
          final Size childSize =
              _getAbsoluteChildSize(Zoomable.getZoomLevel(newScale));
          newScale /= prevScale;
          if (newScale == 1.0) {
            return;
          }

          final Size viewportSize =
              (context.findRenderObject()! as RenderBox).size;
          Offset pinchCenter = details.localFocalPoint;
          if (childSize.width < viewportSize.width) {
            pinchCenter = Offset(viewportSize.width / 2, pinchCenter.dy);
          }
          if (childSize.height < viewportSize.height) {
            pinchCenter = Offset(pinchCenter.dx, viewportSize.height / 2);
          }

          _scale(newScale, pinchCenter, matrix);
          _invokeOnWillUpdate(matrix, details.localFocalPoint,
              details.focalPoint, details.scale, _scaleFocalPoint);
          break;

        case ActionType.pan:
          if (details.scale != 1.0 || widget.controller.zoomLevel == 1.0) {
            return;
          }

          _translate(
              matrix,
              _getPointOnChild(matrix, details.localFocalPoint) -
                  _referenceFocalPoint!);
          _referenceFocalPoint =
              _getPointOnChild(matrix, details.localFocalPoint);
          _invokeOnWillUpdate(
              matrix, details.localFocalPoint, details.focalPoint);
          break;

        case ActionType.tap:
        case ActionType.fling:
        case ActionType.none:
          break;
      }
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_doubleTapTimer != null && _doubleTapTimer!.isActive) {
      _pointerCount++;
    }

    // We have performed the double tap event in the pointer up because in the
    // gesture detector when there is both double tap and scale events, it
    // recognize the specific event with a delay. So to avoid that delay, we
    // have used the pointer events.
    if (_pointerCount == 2) {
      _resetDoubleTapTimer();
      // By default, we have increased the zoom level by 1 while double tapping.
      final double prevZoomLevel =
          Zoomable.getZoomLevel(widget.controller.matrix.getMaxScaleOnAxis());
      double newZoomLevel = prevZoomLevel + 1;
      newZoomLevel =
          newZoomLevel.clamp(widget.minZoomLevel, widget.maxZoomLevel);
      if (newZoomLevel != prevZoomLevel) {
        _handleDoubleTap(
            event.localPosition, pow(2, newZoomLevel - 1).toDouble());
      }
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dy == 0.0) {
        return;
      } else if (_translationController.isAnimating) {
        _translationController.stop();
        _handleActualRectAnimationEnd();
      }

      final double newScale = exp(-event.scrollDelta.dy / 200);
      final Size childSize = _getAbsoluteChildSize(Zoomable.getZoomLevel(
          newScale * widget.controller.matrix.getMaxScaleOnAxis()));
      final Size viewportSize = (context.findRenderObject()! as RenderBox).size;
      Offset pinchCenter = event.localPosition;
      if (childSize.width < viewportSize.width) {
        pinchCenter = Offset(viewportSize.width / 2, pinchCenter.dy);
      }
      if (childSize.height < viewportSize.height) {
        pinchCenter = Offset(pinchCenter.dx, viewportSize.height / 2);
      }
      final Matrix4 matrix = _scale(newScale, pinchCenter);
      widget.controller._action = ActionType.pinch;
      _invokeOnWillUpdate(matrix, event.localPosition, event.position);
      widget.controller._action = ActionType.none;
      _invokeOnComplete();
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (widget.controller._action != ActionType.none &&
        details.velocity.pixelsPerSecond.distance >= kMinFlingVelocity) {
      _resetDoubleTapTimer();
      if (widget.controller._action == ActionType.pinch &&
          !_translationController.isAnimating) {
        _startPinchFlingAnimation(details);
      } else if (widget.controller._action == ActionType.pan &&
          !_zoomLevelController.isAnimating) {
        _startPanFlingAnimation(details);
      }
    } else if (!_doubleTapEnabled) {
      _referenceScale = null;
      widget.controller._action = ActionType.none;
      _invokeOnComplete();
    }
  }

  void _handleDoubleTap(Offset position, double scale) {
    _doubleTapEnabled = true;
    widget.controller._action = ActionType.tap;
    _referenceFocalPoint = _getPointOnChild(widget.controller.matrix, position);
    _scaleFocalPoint = position;
    _zoomLevelTween
      ..begin = widget.controller.matrix.getMaxScaleOnAxis()
      ..end = scale;
    _zoomLevelController
      ..duration = const Duration(milliseconds: 200)
      ..forward(from: 0.0);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _resetDoubleTapTimer();
  }

  Offset _getPointOnChild(Matrix4 matrix, Offset viewportPoint) {
    final Matrix4 invertedMatrix = Matrix4.inverted(matrix);
    final Vector3 untransformed = invertedMatrix
        .transform3(Vector3(viewportPoint.dx, viewportPoint.dy, 0));
    return Offset(untransformed.x, untransformed.y);
  }

  ActionType _getActionTypes(double scale, Offset distance) {
    const int minScaleDistance = 3;
    if (scale == 1) {
      return widget.enablePanning &&
              (distance.dx.abs() > minScaleDistance ||
                  distance.dy.abs() > minScaleDistance)
          ? ActionType.pan
          : ActionType.none;
    }

    return widget.enablePinching &&
            (distance.dx.abs() > minScaleDistance ||
                distance.dy.abs() > minScaleDistance)
        ? ActionType.pinch
        : ActionType.none;
  }

  Matrix4 _scale(double newScale, Offset position, [Matrix4? matrix]) {
    matrix ??= widget.controller.matrix.clone();
    final Offset referenceFocalPoint = _getPointOnChild(matrix, position);
    matrix.scale(newScale);
    final Offset scaledReferenceFocalPoint = _getPointOnChild(matrix, position);
    final Offset translation = scaledReferenceFocalPoint - referenceFocalPoint;
    matrix.translate(translation.dx, translation.dy);
    // Calling _translate() to validate the child's viewport edges
    // and correct them.
    _translate(matrix, Offset.zero);
    return matrix;
  }

  void _translate(Matrix4 matrix, Offset translation) {
    final Size childSize = _getAbsoluteChildSize(
        Zoomable.getZoomLevel(matrix.getMaxScaleOnAxis()));
    final Rect viewport =
        Offset.zero & (context.findRenderObject()! as RenderBox).size;
    final bool widthExceeds = childSize.width > viewport.width;
    final bool heightExceeds = childSize.height > viewport.height;
    if (widthExceeds) {
      matrix.translate(translation.dx);
    }
    if (heightExceeds) {
      matrix.translate(0.0, translation.dy);
    }

    final Offset effectiveViewportTopLeft =
        _getPointOnChild(matrix, viewport.topLeft);
    final Offset effectiveViewportBottomRight =
        _getPointOnChild(matrix, viewport.bottomRight);
    Offset correctedTranslation = Offset.zero;

    if (widthExceeds) {
      double exceed = effectiveViewportTopLeft.dx - widget.boundary.left;
      if (exceed < 0.0) {
        correctedTranslation = Offset(correctedTranslation.dx + exceed, 0.0);
      } else {
        exceed = effectiveViewportBottomRight.dx - widget.boundary.right;
        if (exceed > 0.0) {
          correctedTranslation = Offset(correctedTranslation.dx + exceed, 0.0);
        }
      }
    }

    if (heightExceeds) {
      double exceed = effectiveViewportTopLeft.dy - widget.boundary.top;
      if (exceed < 0.0) {
        correctedTranslation =
            Offset(correctedTranslation.dx, correctedTranslation.dy + exceed);
      } else {
        exceed = effectiveViewportBottomRight.dy - widget.boundary.bottom;
        if (exceed > 0.0) {
          correctedTranslation =
              Offset(correctedTranslation.dx, correctedTranslation.dy + exceed);
        }
      }
    }

    if (correctedTranslation != Offset.zero) {
      matrix.translate(correctedTranslation.dx, correctedTranslation.dy);
    }
  }

  void _invokeOnWillUpdate(Matrix4 matrix,
      [Offset? localFocalPoint,
      Offset? globalFocalPoint,
      double scale = 1.0,
      Offset? pinchCenter]) {
    final double zoomLevel = Zoomable.getZoomLevel(matrix.getMaxScaleOnAxis());
    if (localFocalPoint == null) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      localFocalPoint = box.size.center(Offset.zero);
    }
    if (globalFocalPoint == null) {
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      globalFocalPoint = renderBox.localToGlobal(localFocalPoint);
    }

    final Rect bounds = _getPointOnChild(matrix, widget.boundary.topLeft) &
        _getAbsoluteChildSize(zoomLevel);
    final ZoomableDetails details = ZoomableDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: widget.controller.zoomLevel,
      zoomLevel: zoomLevel,
      previousAbsoluteBounds: widget.controller.absoluteBounds,
      absoluteBounds: bounds,
      scale: scale,
      scaleFocalPoint: pinchCenter,
    );

    if (_onWillUpdate(details)) {
      widget.controller
        ..zoomLevel = zoomLevel
        .._matrix = matrix
        ..absoluteBounds = bounds;
    }
  }

  bool _onWillUpdate(ZoomableDetails details) {
    return widget.onWillUpdate?.call(details) ?? true;
  }

  void _invokeOnComplete(
      [Offset? localFocalPoint,
      Offset? globalFocalPoint,
      double scale = 1.0,
      Offset? pinchCenter]) {
    final double zoomLevel =
        Zoomable.getZoomLevel(widget.controller.matrix.getMaxScaleOnAxis());
    if (localFocalPoint == null) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      localFocalPoint = box.size.center(Offset.zero);
    }
    if (globalFocalPoint == null) {
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      globalFocalPoint = renderBox.localToGlobal(localFocalPoint);
    }

    final Offset translation = _getCurrentTranslation(widget.controller.matrix);
    final Rect actualRect = translation & _getAbsoluteChildSize(zoomLevel);
    final ZoomableDetails details = ZoomableDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: widget.controller.zoomLevel,
      zoomLevel: zoomLevel,
      previousAbsoluteBounds: widget.controller.absoluteBounds,
      absoluteBounds: actualRect,
      scale: scale,
      scaleFocalPoint: pinchCenter,
    );
    widget.onComplete?.call(details);
  }

  void _resetDoubleTapTimer() {
    _pointerCount = 0;
    if (_doubleTapTimer != null) {
      _doubleTapTimer!.cancel();
      _doubleTapTimer = null;
    }
  }

  // Returns the animation duration for the given distance and
  // friction co-efficient.
  Duration _getFlingAnimationDuration(double distance) {
    final int duration =
        (log(10.0 / distance) / log(widget.frictionCoefficient / 100)).round();
    final int durationInMs = duration * 1000;
    return Duration(milliseconds: durationInMs < 300 ? 300 : durationInMs);
  }

  // This methods performs fling animation for pinching.
  void _startPinchFlingAnimation(ScaleEndDetails details) {
    final double zoomLevel =
        Zoomable.getZoomLevel(widget.controller.matrix.getMaxScaleOnAxis());
    final int direction = _currentScale >= _maxAttainedScale ? 1 : -1;
    double newZoomLevel = zoomLevel +
        (direction *
            (details.velocity.pixelsPerSecond.distance / kMaxFlingVelocity) *
            widget.maxZoomLevel);
    newZoomLevel = newZoomLevel.clamp(widget.minZoomLevel, widget.maxZoomLevel);
    _zoomLevelTween
      ..begin = widget.controller.matrix.getMaxScaleOnAxis()
      ..end = Zoomable.getScale(newZoomLevel);
    widget.controller._action = ActionType.fling;
    _zoomLevelController
      ..duration =
          _getFlingAnimationDuration(details.velocity.pixelsPerSecond.distance)
      ..forward(from: 0.0);
  }

  void _handleZoomLevelAnimation() {
    _zoomLevelAnimation.curve = widget.controller._action == ActionType.fling
        ? Curves.decelerate
        : Curves.easeInOut;
    final double newScale = _zoomLevelTween.evaluate(_zoomLevelAnimation);
    final Size childSize =
        _getAbsoluteChildSize(Zoomable.getZoomLevel(newScale));

    final Size viewportSize = (context.findRenderObject()! as RenderBox).size;
    Offset pinchCenter = _scaleFocalPoint;
    if (childSize.width <= viewportSize.width &&
        viewportSize.height <= viewportSize.height) {
      pinchCenter = viewportSize.center(Offset.zero);
    }
    final Matrix4 matrix = _scale(
        newScale / widget.controller.matrix.getMaxScaleOnAxis(), pinchCenter);

    if (widget.controller._action == ActionType.none ||
        widget.controller._action == ActionType.fling) {
      final double zoomLevel =
          Zoomable.getZoomLevel(matrix.getMaxScaleOnAxis());
      final Offset translation = _getCurrentTranslation(matrix);
      final Rect actualRect = translation & _getAbsoluteChildSize(zoomLevel);
      widget.controller._internalSetValues(matrix, zoomLevel, actualRect);
    } else {
      _invokeOnWillUpdate(matrix, _scaleFocalPoint);
    }
  }

  void _handleZoomLevelChange(double zoomLevel) {
    if (widget.enablePinching && zoomLevel != widget.controller.zoomLevel) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      _scaleFocalPoint = box.size.center(Offset.zero);
      _referenceFocalPoint =
          _getPointOnChild(widget.controller.matrix, _scaleFocalPoint);
      zoomLevel = zoomLevel.clamp(widget.minZoomLevel, widget.maxZoomLevel);
      _zoomLevelTween
        ..begin = widget.controller.matrix.getMaxScaleOnAxis()
        ..end = Zoomable.getScale(zoomLevel);
      _zoomLevelController
        ..duration = widget.animationDuration
        ..forward(from: 0.0);
    }
  }

  void _handleZoomLevelAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleZoomLevelAnimationEnd();
    }
  }

  void _handleZoomLevelAnimationEnd() {
    _doubleTapEnabled = false;
    widget.controller._action = ActionType.pinch;
    _invokeOnWillUpdate(widget.controller.matrix, _scaleFocalPoint);
    widget.controller._action = ActionType.none;
    _invokeOnComplete();
  }

  // This methods performs fling animation for panning.
  void _startPanFlingAnimation(ScaleEndDetails details) {
    final Offset translation = _getCurrentTranslation(widget.controller.matrix);
    final FrictionSimulation frictionSimulationX = FrictionSimulation(
      widget.frictionCoefficient,
      translation.dx,
      details.velocity.pixelsPerSecond.dx,
    );
    final FrictionSimulation frictionSimulationY = FrictionSimulation(
      widget.frictionCoefficient,
      translation.dy,
      details.velocity.pixelsPerSecond.dy,
    );
    _translationTween
      ..begin = translation
      ..end = Offset(frictionSimulationX.finalX, frictionSimulationY.finalX);
    widget.controller._action = ActionType.fling;
    _translationController
      ..duration =
          _getFlingAnimationDuration(details.velocity.pixelsPerSecond.distance)
      ..forward(from: 0.0);
  }

  void _handleTranslationAnimation() {
    _translationAnimation.curve = widget.controller._action == ActionType.fling
        ? Curves.decelerate
        : Curves.easeInOut;
    final Matrix4 matrix = widget.controller.matrix.clone();
    final Offset prevTranslation = _getCurrentTranslation(matrix);
    final Offset newTranslation =
        _translationTween.evaluate(_translationAnimation);
    final Offset translation = _getPointOnChild(matrix, newTranslation) -
        _getPointOnChild(matrix, prevTranslation);
    _translate(matrix, translation);

    if (widget.controller._action == ActionType.none ||
        widget.controller._action == ActionType.fling) {
      final double zoomLevel =
          Zoomable.getZoomLevel(matrix.getMaxScaleOnAxis());
      final Rect bounds = _getPointOnChild(matrix, widget.boundary.topLeft) &
          _getAbsoluteChildSize(zoomLevel);
      widget.controller._internalSetValues(matrix, zoomLevel, bounds);
    } else {
      _invokeOnWillUpdate(matrix);
    }
  }

  void _handleAbsoluteBoundsChange(Rect actualRect) {
    if (widget.enablePanning &&
        actualRect != widget.controller.absoluteBounds) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      _scaleFocalPoint = box.size.center(Offset.zero);
      _translationTween
        ..begin = _getCurrentTranslation(widget.controller.matrix)
        ..end = actualRect.topLeft;
      _translationController
        ..duration = widget.animationDuration
        ..forward(from: 0.0);
    }
  }

  void _handleTranslationAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleActualRectAnimationEnd();
    }
  }

  void _handleActualRectAnimationEnd() {
    widget.controller._action = ActionType.pan;
    _invokeOnWillUpdate(widget.controller.matrix, _scaleFocalPoint);
    widget.controller._action = ActionType.none;
    _invokeOnComplete();
  }

  @override
  void initState() {
    _zoomLevelController =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..addListener(_handleZoomLevelAnimation)
          ..addStatusListener(_handleZoomLevelAnimationStatusChange);
    _translationController =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..addListener(_handleTranslationAnimation)
          ..addStatusListener(_handleTranslationAnimationStatusChange);

    _zoomLevelAnimation =
        CurvedAnimation(parent: _zoomLevelController, curve: Curves.easeInOut);
    _translationAnimation = CurvedAnimation(
        parent: _translationController, curve: Curves.easeInOut);

    _translationTween = Tween<Offset>();
    _zoomLevelTween = Tween<double>();

    final double initialZoomLevel =
        Zoomable.getZoomLevel(widget.controller.matrix.getMaxScaleOnAxis())
            .clamp(widget.minZoomLevel, widget.maxZoomLevel);
    widget.controller
      .._zoomLevel = initialZoomLevel
      .._absoluteBounds = widget.boundary
      .._onZoomLevelChange = _handleZoomLevelChange
      .._onAbsoluteBoundsChange = _handleAbsoluteBoundsChange;
    super.initState();
  }

  @override
  void dispose() {
    _zoomLevelController
      ..removeListener(_handleZoomLevelAnimation)
      ..removeStatusListener(_handleZoomLevelAnimationStatusChange)
      ..dispose();
    _translationController
      ..removeListener(_handleTranslationAnimation)
      ..removeStatusListener(_handleTranslationAnimationStatusChange)
      ..dispose();
    // Zoom Controller dispose should be handled by the user.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      onPointerSignal: _handlePointerSignal,
      behavior: HitTestBehavior.translucent,
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}

/// A controller which handles the zoomLevel, and actual rect
/// commonly across multiple widgets.
class ZoomableController extends ChangeNotifier {
  /// Creates a [ZoomableController].
  ZoomableController({Matrix4? matrix})
      : _matrix = matrix ?? Matrix4.identity();

  // ignore: unused_field
  ScaleCallback? _onZoomLevelChange;
  // ignore: unused_field
  TranslationCallback? _onAbsoluteBoundsChange;

  /// By defaults it will be a identity matrix, which corresponds to no
  /// transformation.
  ///
  /// Holds the zoomable widget matrix4 value which will be same in
  /// multiple widgets.
  Matrix4 get matrix => _matrix;
  Matrix4 _matrix = Matrix4.identity();

  /// Holds the current action type of the widget.
  ActionType get action => _action;
  ActionType _action = ActionType.none;

  /// Holds the current zoomLevel of the zoomable widget.
  double get zoomLevel => _zoomLevel;
  double _zoomLevel = 1.0;
  set zoomLevel(double value) {
    assert(value >= 1);
    if (_zoomLevel == value) {
      return;
    }
    // Handles interaction.
    // if (action != ActionType.none) {
    _zoomLevel = value;
    //   return;
    // }
    // Handles programmatic updates.
    // _onZoomLevelChange?.call(value);
  }

  /// Holds the absoluteBounds of the zoomable widget.
  Rect get absoluteBounds => _absoluteBounds;
  Rect _absoluteBounds = Rect.zero;
  set absoluteBounds(Rect value) {
    if (_absoluteBounds == value) {
      return;
    }
    // Handles interaction.
    // if (action != ActionType.none) {
    _absoluteBounds = value;
    // _matrix = Matrix4.identity()
    //   ..scale(pow(2, _zoomLevel - 1).toDouble())
    //   ..setTranslation(
    //       Vector3(_absoluteBounds.left, _absoluteBounds.top, 0.0));
    notifyListeners();
    // return;
    // }
    // Handles programmatic updates.
    // _onAbsoluteBoundsChange?.call(value);
  }

  void _internalSetValues(Matrix4 matrix, double zoomLevel, Rect actualRect) {
    _zoomLevel = zoomLevel;
    _absoluteBounds = actualRect;
    _matrix = matrix.clone();
    notifyListeners();
  }
}
