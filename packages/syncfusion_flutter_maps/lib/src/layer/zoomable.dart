import 'dart:async' show Timer;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Matrix4;

/// Signature for when the zoom level or actual rect value changes get
/// indicated.
typedef ZoomableUpdateCallback = void Function(ZoomPanDetails);

/// Signature for when the zooming and panning action has been completed.
typedef ZoomableCompleteCallback = void Function(ZoomPanDetails);

/// Signature for when the zooming and panning action has been flinging.
typedef ZoomableFlingCallback = bool Function(ZoomPanDetails);

/// Signature for when zoom level change callback.
typedef ZoomCallback = void Function(double);

/// Signature for when actual rect change callback.
typedef RectCallback = void Function(Rect);

/// Shows the current action performing in the zoomable widget.
enum ActionType {
  /// Denotes the current action as pinching.
  pinch,

  /// Denotes the current action as panning.
  pan,

  /// Denotes the current action as double tap.
  tap,

  /// Denotes the current action as pinch flinging.
  pinchFling,

  /// Denotes the current action as pan flinging.
  panFling,

  /// Denotes there is no action currently.
  none
}

/// Contains details about the current zooming and panning action.
class ZoomPanDetails {
  /// Creates a [ZoomPanDetails].
  ZoomPanDetails({
    required this.localFocalPoint,
    required this.globalFocalPoint,
    required this.previousZoomLevel,
    required this.newZoomLevel,
    required this.previousRect,
    required this.actualRect,
    required this.scale,
    required this.pinchCenter,
  });

  /// The local focal point of the pointers in contact with the screen.
  final Offset localFocalPoint;

  /// The global focal point of the pointers in contact with the screen.
  final Offset globalFocalPoint;

  /// Provides the last zoom level which has been in zoomable.
  final double previousZoomLevel;

  /// Provides the new zoom level for the current zooming.
  final double newZoomLevel;

  /// Specifies the previous rect of the zoomable.
  final Rect previousRect;

  /// Specifies the new rect for the current zooming.
  final Rect actualRect;

  /// Specifies the current scale based on interaction.
  final double scale;

  /// Specified the center point which we have pinching currently.
  final Offset? pinchCenter;
}

/// A widget which handles the zooming and panning with considering its bounds
/// based on the zoomLevel and child size.
class Zoomable extends StatefulWidget {
  /// Creates a [Zoomable].
  const Zoomable({
    Key? key,
    required this.initialZoomLevel,
    required this.initialRect,
    required this.minZoomLevel,
    required this.maxZoomLevel,
    required this.zoomController,
    this.enableMouseWheelZooming = false,
    this.enablePinching = true,
    this.enablePanning = true,
    this.enableDoubleTapZooming = false,
    this.animationDuration = const Duration(milliseconds: 600),
    this.frictionCoefficient = 0.005,
    required this.onUpdate,
    required this.onComplete,
    required this.onFling,
    this.child,
  })  : assert(minZoomLevel >= 1 && minZoomLevel <= maxZoomLevel),
        assert(initialZoomLevel >= minZoomLevel &&
            initialZoomLevel <= maxZoomLevel),
        assert(frictionCoefficient > 0.0),
        super(key: key);

  /// Specifies the initial zoomLevel of the widget.
  ///
  /// It can't be null and must between the [minZoomLevel] and [maxZoomLevel].
  final double initialZoomLevel;

  /// A rect which is used to translate the controller matrix initially.
  final Rect initialRect;

  /// Specifies the minimum zoomLevel of the widget.
  ///
  /// It can't be null and must be greater than or equal to `1` and lesser than
  /// [maxZoomLevel].
  final double minZoomLevel;

  /// Option to enable mouse wheel in web.
  ///
  /// By default it will be `false`.
  final bool enableMouseWheelZooming;

  /// Specifies the maximum zoomLevel of the widget.
  ///
  /// It can't be null and must be greater than or equal to `1` and
  /// [minZoomLevel].
  final double maxZoomLevel;

  /// Holds the details of the current zoom level and actual rect. These details
  /// can be used in multiple widget which used the same zoomable widget.
  final ZoomableController zoomController;

  /// An animation duration which is used to animate the zoom level and actual
  /// rect property change using the given duration.
  ///
  /// By default it will be `600` milliseconds.
  final Duration animationDuration;

  /// In the inertial translation animation, this value is used as the
  /// coefficient of friction.
  ///
  /// By default it will be `0.005`.
  final double frictionCoefficient;

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

  /// Called when there is a change in the zoom level or actual rect of the
  /// zoomable widget.
  final ZoomableUpdateCallback onUpdate;

  /// Called when the zoom level or actual rect updating has been completed.
  final ZoomableCompleteCallback onComplete;

  /// Called when the zoom level or actual rect updating has been completed.
  final ZoomableFlingCallback onFling;

  /// Specifies the child of the zoomable widget. It didn't get updated based on
  /// the zoomable widget interaction or changes.
  ///
  /// By default it will be `null`.
  final Widget? child;

  @override
  State<Zoomable> createState() => _ZoomableState();
}

class _ZoomableState extends State<Zoomable> with TickerProviderStateMixin {
  late AnimationController _zoomLevelAnimationController;
  late AnimationController _actualRectAnimationController;
  late CurvedAnimation _zoomLevelAnimation;
  late CurvedAnimation _actualRectAnimation;
  late Tween<double> _zoomLevelTween;
  late Tween<Offset> _actualRectTween;
  late Matrix4 _newMatrix;
  late Offset _startLocalPoint;

  Rect? _boundaryRect;
  Timer? _doubleTapTimer;
  Size? _size;
  Offset? _matrixStartPoint;

  double _maximumReachedScaleOnInteraction = 1.0;
  double _lastScaleValueOnInteraction = 1.0;
  double? _scaleStart;
  int _pointerCount = 0;

  bool _isFlingAnimationActive = false;
  bool _doubleTapEnabled = false;

  // The boundary rect is the actual rect in which the edge restriction has
  // been handled using this rect only.
  Rect _getBoundaryRect() {
    final double width =
        widget.initialRect.size.width / _getScale(widget.initialZoomLevel);
    final double height =
        widget.initialRect.size.height / _getScale(widget.initialZoomLevel);
    return Offset.zero & Size(width, height);
  }

  // Returns a new matrix based on the given translation offset.
  Matrix4 _translateMatrix(Matrix4 matrix, Offset translation) {
    if (translation == Offset.zero) {
      return matrix.clone();
    }

    return matrix.clone()..translate(translation.dx, translation.dy);
  }

  // Scales the given matrix with considering the min and max zoomLevel.
  Matrix4 _matrixScale(Matrix4 matrix, double scale) {
    if (scale == 1.0) {
      return matrix.clone();
    }
    assert(scale != 0.0);

    final double currentScale = matrix.getMaxScaleOnAxis();
    final double clampedTotalScale = (currentScale * scale)
        .clamp(_getScale(widget.minZoomLevel), _getScale(widget.maxZoomLevel));
    final double clampedScale = clampedTotalScale / currentScale;
    return matrix.clone()..scale(clampedScale);
  }

  ActionType _getActionTypes(
      double scale, Offset focalPoint, Offset startFocalPoint) {
    // The minimum distance required to start scale or pan gesture.
    const int minScaleDistance = 3;
    final Offset distance = focalPoint - startFocalPoint;
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

  void _handleScaleStart(ScaleStartDetails details) {
    if (!_zoomLevelAnimationController.isAnimating &&
        !_actualRectAnimationController.isAnimating) {
      widget.zoomController.actionType = ActionType.none;
      _maximumReachedScaleOnInteraction = 1.0;
      _lastScaleValueOnInteraction = 1.0;

      _startLocalPoint = details.localFocalPoint;
      _newMatrix = widget.zoomController.controllerMatrix.clone();
      _scaleStart = _newMatrix.getMaxScaleOnAxis();
      _matrixStartPoint = _getActualPointInMatrix(_newMatrix, _startLocalPoint);
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!_zoomLevelAnimationController.isAnimating &&
        !_actualRectAnimationController.isAnimating) {
      final double scale = _newMatrix.getMaxScaleOnAxis();
      final Offset matrixFocalPoint =
          _getActualPointInMatrix(_newMatrix, details.localFocalPoint);

      if (widget.zoomController.actionType == ActionType.none) {
        widget.zoomController.actionType = _getActionTypes(
            details.scale, details.localFocalPoint, _startLocalPoint);
      }

      if (widget.zoomController.actionType == ActionType.none) {
        return;
      }

      _resetDoubleTapTimer();
      switch (widget.zoomController.actionType) {
        case ActionType.pinch:
          _scaleStart ??= _newMatrix.getMaxScaleOnAxis();

          // At scale end, to perform flinging we need to know the direction
          // of the zooming. For that, we have stored the max scale value
          // reached during the scale update.
          if (_lastScaleValueOnInteraction < details.scale) {
            _maximumReachedScaleOnInteraction = details.scale;
          }

          _lastScaleValueOnInteraction = details.scale;
          final double desiredScale = _scaleStart! * details.scale;
          final double newScale = desiredScale / scale;
          _newMatrix = _matrixScale(_newMatrix, newScale);

          final Offset matrixFocalPointScaled =
              _getActualPointInMatrix(_newMatrix, _startLocalPoint);

          _newMatrix = _translateMatrix(
              _newMatrix, matrixFocalPointScaled - _matrixStartPoint!);

          _invokeZoomableUpdate(_newMatrix, details.localFocalPoint,
              details.focalPoint, details.scale, _startLocalPoint);
          break;

        case ActionType.pan:
          assert(_matrixStartPoint != null);

          if (details.scale != 1.0) {
            return;
          }

          final Offset newTranslation = matrixFocalPoint - _matrixStartPoint!;
          _newMatrix = _translateMatrix(_newMatrix, newTranslation);
          _matrixStartPoint =
              _getActualPointInMatrix(_newMatrix, details.localFocalPoint);
          _invokeZoomableUpdate(
              _newMatrix, details.localFocalPoint, details.focalPoint);
          break;
        case ActionType.tap:
        case ActionType.pinchFling:
        case ActionType.panFling:
        case ActionType.none:
          break;
      }
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    // If the scale ended with enough velocity, we have handled the last gesture
    // with fling animation.
    if (widget.zoomController.actionType != ActionType.none &&
        details.velocity.pixelsPerSecond.distance >= kMinFlingVelocity) {
      _resetDoubleTapTimer();
      if (widget.zoomController.actionType == ActionType.pinch &&
          !_actualRectAnimationController.isAnimating) {
        _startFlingAnimationForPinching(details);
      } else if (widget.zoomController.actionType == ActionType.pan &&
          !_zoomLevelAnimationController.isAnimating) {
        _startFlingAnimationForPanning(details);
      }
    } else if (!_doubleTapEnabled) {
      _scaleStart = null;
      widget.zoomController.actionType = ActionType.none;
      _invokeZoomableComplete(_newMatrix);
    }
  }

  // This methods performs fling animation for pinching.
  void _startFlingAnimationForPinching(ScaleEndDetails details) {
    _isFlingAnimationActive = true;
    _newMatrix = widget.zoomController.controllerMatrix.clone();
    _zoomLevelTween.begin = _newMatrix.getMaxScaleOnAxis();
    final double zoomLevel = _getZoomLevel(_newMatrix.getMaxScaleOnAxis());
    final int direction =
        _lastScaleValueOnInteraction >= _maximumReachedScaleOnInteraction
            ? 1
            : -1;
    double newZoomLevel = zoomLevel +
        (direction *
            (details.velocity.pixelsPerSecond.distance / kMaxFlingVelocity) *
            widget.maxZoomLevel);
    newZoomLevel = newZoomLevel.clamp(widget.minZoomLevel, widget.maxZoomLevel);
    widget.zoomController.actionType = ActionType.pinchFling;
    final double scale = _getScale(newZoomLevel) / _zoomLevelTween.begin!;
    Matrix4 matrix = _matrixScale(_newMatrix, scale);
    final Offset matrixFocalPointScaled =
        _getActualPointInMatrix(matrix, _startLocalPoint);
    matrix =
        _translateMatrix(matrix, matrixFocalPointScaled - _matrixStartPoint!);
    if (_invokeZoomableUpdate(matrix, null, null, scale, _startLocalPoint)) {
      _zoomLevelTween.end = _getScale(newZoomLevel);
      _zoomLevelAnimationController.duration =
          _getFlingAnimationDuration(details.velocity.pixelsPerSecond.distance);
      _zoomLevelAnimationController.forward(from: 0.0);
    } else {
      _scaleStart = null;
      widget.zoomController.actionType = ActionType.none;
      _invokeZoomableComplete(_newMatrix);
    }
  }

  // This methods performs fling animation for panning.
  void _startFlingAnimationForPanning(ScaleEndDetails details) {
    _isFlingAnimationActive = true;
    _newMatrix = widget.zoomController.controllerMatrix.clone();
    final Vector3 translationVector = _newMatrix.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    _actualRectTween.begin = translation;
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
    _actualRectTween.end =
        Offset(frictionSimulationX.finalX, frictionSimulationY.finalX);
    widget.zoomController.actionType = ActionType.panFling;
    final Offset newTranslation =
        _actualRectTween.end! - _actualRectTween.begin!;
    final Matrix4 matrix = _translateMatrix(_newMatrix, newTranslation);
    if (_invokeZoomableUpdate(matrix)) {
      _actualRectAnimationController.duration =
          _getFlingAnimationDuration(details.velocity.pixelsPerSecond.distance);
      _actualRectAnimationController.forward(from: 0.0);
    } else {
      _scaleStart = null;
      widget.zoomController.actionType = ActionType.none;
      _invokeZoomableComplete(_newMatrix);
    }
  }

  // Returns the animation duration for the given distance and
  // friction co-efficient.
  Duration _getFlingAnimationDuration(double distance) {
    final int duration =
        (log(10.0 / distance) / log(widget.frictionCoefficient / 100)).round();
    final int durationInMs = duration * 1000;
    return Duration(milliseconds: durationInMs < 350 ? 350 : durationInMs);
  }

  void _handleZoomLevelAnimation() {
    _zoomLevelAnimation.curve =
        _isFlingAnimationActive ? Curves.decelerate : Curves.easeInOut;
    final double scale = _newMatrix.getMaxScaleOnAxis();
    final double desiredScale = _zoomLevelTween.evaluate(_zoomLevelAnimation);
    final double scaleChange = desiredScale / scale;
    _newMatrix = _matrixScale(_newMatrix, scaleChange);
    final Offset matrixFocalPointScaled =
        _getActualPointInMatrix(_newMatrix, _startLocalPoint);
    _newMatrix = _translateMatrix(
        _newMatrix, matrixFocalPointScaled - _matrixStartPoint!);

    if (widget.zoomController.actionType == ActionType.none ||
        widget.zoomController.actionType == ActionType.pinchFling) {
      final double zoomLevel = _getZoomLevel(_newMatrix.getMaxScaleOnAxis());

      final Offset translatedPoint = _getTranslationOffset(_newMatrix);
      final Rect actualRect = translatedPoint &
          Size(_getTotalChildSize(zoomLevel, _boundaryRect!.width / 2),
              _getTotalChildSize(zoomLevel, _boundaryRect!.height / 2));
      widget.zoomController._internalSetValues(zoomLevel, actualRect);
    } else {
      _invokeZoomableUpdate(_newMatrix, _startLocalPoint);
    }
  }

  void _handleActualRectAnimation() {
    _actualRectAnimation.curve =
        _isFlingAnimationActive ? Curves.decelerate : Curves.easeInOut;
    final Vector3 translationVector = _newMatrix.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    final Offset matrixActualPoint =
        _getActualPointInMatrix(_newMatrix, translation);
    final Offset newTranslation =
        _actualRectTween.evaluate(_actualRectAnimation);
    final Offset animationMatrixPoint =
        _getActualPointInMatrix(_newMatrix, newTranslation);
    final Offset matrixTranslationChange =
        animationMatrixPoint - matrixActualPoint;
    _newMatrix = _translateMatrix(_newMatrix, matrixTranslationChange);

    if (widget.zoomController.actionType == ActionType.none ||
        widget.zoomController.actionType == ActionType.panFling) {
      final double zoomLevel = _getZoomLevel(_newMatrix.getMaxScaleOnAxis());
      final Offset translatedPoint = _getTranslationOffset(_newMatrix);
      final Rect actualRect = translatedPoint &
          Size(_getTotalChildSize(zoomLevel, _boundaryRect!.width / 2),
              _getTotalChildSize(zoomLevel, _boundaryRect!.height / 2));
      widget.zoomController._internalSetValues(zoomLevel, actualRect);
    } else {
      _invokeZoomableUpdate(_newMatrix);
    }
  }

  void _handleZoomLevelChange(double zoomLevel) {
    if (widget.enablePinching && zoomLevel != widget.zoomController.zoomLevel) {
      _startLocalPoint = widget.zoomController.parentRect!.center;
      _newMatrix = widget.zoomController.controllerMatrix.clone();
      _matrixStartPoint = _getActualPointInMatrix(_newMatrix, _startLocalPoint);
      zoomLevel = zoomLevel.clamp(widget.minZoomLevel, widget.maxZoomLevel);
      _zoomLevelTween
        ..begin = _newMatrix.getMaxScaleOnAxis()
        ..end = _getScale(zoomLevel);
      _zoomLevelAnimationController.duration = widget.animationDuration;
      _zoomLevelAnimationController.forward(from: 0.0);
    }
  }

  void _handleActualRectChange(Rect actualRect) {
    if (widget.enablePanning &&
        actualRect != widget.zoomController.actualRect) {
      _startLocalPoint = widget.zoomController.parentRect!.center;
      _newMatrix = widget.zoomController.controllerMatrix.clone();
      final Vector3 translationVector = _newMatrix.getTranslation();
      final Offset translation =
          Offset(translationVector.x, translationVector.y);
      _actualRectTween.begin = translation;
      _actualRectTween.end = actualRect.topLeft;
      _actualRectAnimationController.duration = widget.animationDuration;
      _actualRectAnimationController.forward(from: 0.0);
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enableDoubleTapZooming) {
      _doubleTapTimer ??= Timer(kDoubleTapTimeout, _resetDoubleTapTimer);
    }

    if (_zoomLevelAnimationController.isAnimating &&
        widget.zoomController.actionType == ActionType.pinchFling) {
      _zoomLevelAnimationController.stop();
      _handleZoomLevelAnimationEnd();
    }
    if (_actualRectAnimationController.isAnimating &&
        widget.zoomController.actionType == ActionType.panFling) {
      _actualRectAnimationController.stop();
      _handleActualRectAnimationEnd();
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
      final double lastZoomLevel = _getZoomLevel(
          widget.zoomController.controllerMatrix.getMaxScaleOnAxis());
      double newZoomLevel = lastZoomLevel + 1;
      newZoomLevel =
          newZoomLevel.clamp(widget.minZoomLevel, widget.maxZoomLevel);
      if (newZoomLevel != lastZoomLevel) {
        _handleDoubleTap(
            event.localPosition, pow(2, newZoomLevel - 1).toDouble());
      }
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _resetDoubleTapTimer();
  }

  void _resetDoubleTapTimer() {
    _pointerCount = 0;
    if (_doubleTapTimer != null) {
      _doubleTapTimer!.cancel();
      _doubleTapTimer = null;
    }
  }

  void _handleDoubleTap(Offset position, double scale) {
    _doubleTapEnabled = true;
    widget.zoomController.actionType = ActionType.tap;
    _newMatrix = widget.zoomController.controllerMatrix.clone();
    _matrixStartPoint = _getActualPointInMatrix(_newMatrix, position);
    _startLocalPoint = position;
    _zoomLevelTween
      ..begin = _newMatrix.getMaxScaleOnAxis()
      ..end = scale;
    _zoomLevelAnimationController.duration = const Duration(milliseconds: 200);
    _zoomLevelAnimationController.forward(from: 0.0);
  }

  void _handleActualRectAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleActualRectAnimationEnd();
    }
  }

  void _handleZoomLevelAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleZoomLevelAnimationEnd();
    }
  }

  void _handleZoomLevelAnimationEnd() {
    _isFlingAnimationActive = false;
    _doubleTapEnabled = false;
    widget.zoomController.actionType = ActionType.pinch;
    _invokeZoomableUpdate(
        widget.zoomController.controllerMatrix, _startLocalPoint);
    widget.zoomController.actionType = ActionType.none;
    _invokeZoomableComplete(widget.zoomController.controllerMatrix);
  }

  void _handleActualRectAnimationEnd() {
    _isFlingAnimationActive = false;
    widget.zoomController.actionType = ActionType.pan;
    _invokeZoomableUpdate(
        widget.zoomController.controllerMatrix, _startLocalPoint);
    widget.zoomController.actionType = ActionType.none;
    _invokeZoomableComplete(widget.zoomController.controllerMatrix);
  }

  void _handleMouseWheelZooming(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dy == 0.0) {
        return;
      } else if (_actualRectAnimationController.isAnimating) {
        _actualRectAnimationController.stop();
        _handleActualRectAnimationEnd();
      }

      final double scaleChange = exp(-event.scrollDelta.dy / 200);
      _newMatrix = widget.zoomController.controllerMatrix.clone();
      final Offset matrixFocalPoint =
          _getActualPointInMatrix(_newMatrix, event.localPosition);

      _newMatrix = _matrixScale(_newMatrix, scaleChange);

      final Offset matrixFocalPointScaled =
          _getActualPointInMatrix(_newMatrix, event.localPosition);
      _newMatrix = _translateMatrix(
          _newMatrix, matrixFocalPointScaled - matrixFocalPoint);
      widget.zoomController.actionType = ActionType.pinch;
      _invokeZoomableUpdate(_newMatrix, event.localPosition, event.position);
      widget.zoomController.actionType = ActionType.none;
      _invokeZoomableComplete(widget.zoomController.controllerMatrix);
    }
  }

  bool _invokeZoomableUpdate(Matrix4 matrix,
      [Offset? localFocalPoint,
      Offset? globalFocalPoint,
      double scale = 1.0,
      Offset? pinchCenter]) {
    final double zoomLevel = _getZoomLevel(matrix.getMaxScaleOnAxis());
    localFocalPoint ??= widget.zoomController.parentRect!.center;
    if (globalFocalPoint == null) {
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      globalFocalPoint = renderBox.localToGlobal(localFocalPoint);
    }
    final Offset translatedPoint = _getTranslationOffset(matrix);
    final Rect actualRect = translatedPoint &
        Size(_getTotalChildSize(zoomLevel, _boundaryRect!.width / 2),
            _getTotalChildSize(zoomLevel, _boundaryRect!.height / 2));
    final ZoomPanDetails details = ZoomPanDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: widget.zoomController.zoomLevel,
      newZoomLevel: zoomLevel,
      previousRect: widget.zoomController.actualRect,
      actualRect: actualRect,
      scale: scale,
      pinchCenter: pinchCenter,
    );
    if (widget.zoomController.actionType == ActionType.pinchFling ||
        widget.zoomController.actionType == ActionType.panFling) {
      return widget.onFling(details);
    } else {
      widget.onUpdate(details);
    }
    return true;
  }

  void _invokeZoomableComplete(Matrix4 matrix,
      [Offset? localFocalPoint,
      Offset? globalFocalPoint,
      double scale = 1.0,
      Offset? pinchCenter]) {
    final double zoomLevel = _getZoomLevel(matrix.getMaxScaleOnAxis());
    localFocalPoint ??= widget.zoomController.parentRect!.center;
    if (globalFocalPoint == null) {
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      globalFocalPoint = renderBox.localToGlobal(localFocalPoint);
    }
    final Offset translatedPoint = _getTranslationOffset(matrix);
    final Rect actualRect = translatedPoint &
        Size(_getTotalChildSize(zoomLevel, _boundaryRect!.width / 2),
            _getTotalChildSize(zoomLevel, _boundaryRect!.height / 2));
    final ZoomPanDetails details = ZoomPanDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: widget.zoomController.zoomLevel,
      newZoomLevel: zoomLevel,
      previousRect: widget.zoomController.actualRect,
      actualRect: actualRect,
      scale: scale,
      pinchCenter: pinchCenter,
    );
    widget.onComplete(details);
  }

  void _initializeAnimations() {
    _zoomLevelAnimationController =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..addListener(_handleZoomLevelAnimation)
          ..addStatusListener(_handleZoomLevelAnimationStatusChange);
    _actualRectAnimationController =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..addListener(_handleActualRectAnimation)
          ..addStatusListener(_handleActualRectAnimationStatusChange);
    _zoomLevelAnimation = CurvedAnimation(
        parent: _zoomLevelAnimationController, curve: Curves.easeInOut);
    _actualRectAnimation = CurvedAnimation(
        parent: _actualRectAnimationController, curve: Curves.easeInOut);
    _actualRectTween = Tween<Offset>();
    _zoomLevelTween = Tween<double>();
  }

  @override
  void initState() {
    widget.zoomController
      .._onZoomLevelChange = _handleZoomLevelChange
      .._onActualRectChange = _handleActualRectChange;
    _initializeAnimations();
    super.initState();
  }

  @override
  void dispose() {
    _zoomLevelAnimationController
      ..removeListener(_handleZoomLevelAnimation)
      ..removeStatusListener(_handleZoomLevelAnimationStatusChange)
      ..dispose();
    _actualRectAnimationController
      ..removeListener(_handleActualRectAnimation)
      ..removeStatusListener(_handleActualRectAnimationStatusChange)
      ..dispose();
    // Zoom Controller dispose should be handled by the user.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final Size newSize = Size(constraints.maxWidth, constraints.maxHeight);
      if (_size == null || _size != newSize) {
        _size = newSize;
        widget.zoomController
          ..parentRect = Offset.zero & _size!
          .._actualRect = widget.initialRect
          .._zoomLevel = widget.initialZoomLevel;
        _boundaryRect = _getBoundaryRect();
        widget.zoomController.controllerMatrix = Matrix4.identity()
          ..scale(_getScale(widget.initialZoomLevel))
          ..setTranslation(
              Vector3(widget.initialRect.left, widget.initialRect.top, 0.0));
      }

      return Listener(
        onPointerDown: _handlePointerDown,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        onPointerSignal:
            widget.enableMouseWheelZooming ? _handleMouseWheelZooming : null,
        behavior: HitTestBehavior.translucent,
        child: GestureDetector(
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onScaleEnd: _handleScaleEnd,
          behavior: HitTestBehavior.translucent,
          child: widget.child,
        ),
      );
    });
  }
}

// Return the translation from the given Matrix4 as an Offset.
Offset _getTranslationOffset(Matrix4 matrix) {
  final Vector3 nextTranslation = matrix.getTranslation();
  return Offset(nextTranslation.x, nextTranslation.y);
}

double _getTotalChildSize(double zoom, double size) {
  return size * pow(2, zoom).toDouble();
}

double _getZoomLevel(double scale) {
  // The minimum zoom level was set to 1.0. The scale value, however, will be
  // greater or equal to 0.0. We've added 1 to the return value.
  return (log(scale) / log(2)) + 1;
}

double _getScale(double zoomLevel) {
  // To derive the scale value from 0.0, we subtracted 1 from the obtained
  // zoom level.
  return pow(2, zoomLevel - 1).toDouble();
}

/// Return the exact pixel point of the given matrix.
Offset _getActualPointInMatrix(Matrix4 matrix, Offset localPoint) {
  final Matrix4 inverseMatrix = Matrix4.inverted(matrix);
  final Vector3 untransformed =
      inverseMatrix.transform3(Vector3(localPoint.dx, localPoint.dy, 0));
  return Offset(untransformed.x, untransformed.y);
}

/// A controller which handles the zoomLevel, and actual rect
/// commonly across multiple widgets.
class ZoomableController {
  ObserverList<VoidCallback>? _listeners = ObserverList<VoidCallback>();
  late ZoomCallback _onZoomLevelChange;
  late RectCallback _onActualRectChange;

  /// By defaults it will be a identity matrix, which corresponds to no
  /// transformation.
  ///
  /// Holds the zoomable widget matrix4 value which will be same in
  /// multiple widgets.
  Matrix4 controllerMatrix = Matrix4.identity();

  /// Holds the current action type of the widget.
  ActionType actionType = ActionType.none;

  /// Holds the rect of the parent.
  Rect? parentRect;

  /// Holds the current zoomLevel of the zoomable widget.
  double get zoomLevel => _zoomLevel;
  late double _zoomLevel;
  set zoomLevel(double value) {
    assert(value >= 1);
    if (_zoomLevel == value) {
      return;
    }

    if (actionType != ActionType.none) {
      _zoomLevel = value;
      return;
    }
    _onZoomLevelChange(value);
  }

  /// Holds the actualRect of the zoomable widget.
  Rect get actualRect => _actualRect;
  late Rect _actualRect;
  set actualRect(Rect value) {
    if (_actualRect == value) {
      return;
    }
    if (actionType != ActionType.none) {
      _actualRect = value;
      final double newScale = pow(2, _zoomLevel - 1).toDouble();
      controllerMatrix = Matrix4.identity()
        ..scale(newScale)
        ..setTranslation(Vector3(_actualRect.left, _actualRect.top, 0.0));
      notifyListeners();
      return;
    }
    _onActualRectChange(value);
  }

  void _internalSetValues(double zoomLevel, Rect actualRect) {
    _zoomLevel = zoomLevel;
    _actualRect = actualRect;
    final double newScale = pow(2, _zoomLevel - 1).toDouble();
    controllerMatrix = Matrix4.identity()
      ..scale(newScale)
      ..setTranslation(Vector3(_actualRect.left, _actualRect.top, 0.0));
    notifyListeners();
  }

  /// Adds the listeners to the corresponding widget.
  void addListener(VoidCallback listener) {
    _listeners?.add(listener);
  }

  /// Removes the listeners from the corresponding widget.
  void removeListener(VoidCallback listener) {
    _listeners?.remove(listener);
  }

  /// Notifies the active listeners as values has been updated.
  void notifyListeners() {
    for (final VoidCallback listener in _listeners!) {
      listener();
    }
  }

  /// Disposes the active listeners.
  void dispose() {
    _listeners = null;
  }
}
