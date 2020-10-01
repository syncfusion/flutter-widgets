import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdfviewer_callback_details.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3, Matrix4;

/// A material design PdfContainer performs scroll, pan and zoom interactions for its list of image(PDF page).
@immutable
class PdfContainer extends StatefulWidget {
  /// Creates a instance of PdfContainer.
  PdfContainer({
    Key key,
    this.enableDoubleTapZooming = true,
    this.onZoomLevelChanged,
    this.pdfController,
    this.panEnabled = true,
    this.scaleEnabled = true,
    @required this.scrollController,
    @required this.itemBuilder,
  })  : assert(itemBuilder != null),
        assert(scrollController != null),
        assert(panEnabled != null),
        assert(scaleEnabled != null),
        assert(enableDoubleTapZooming != null),
        super(key: key);

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final ScrollController scrollController;

  /// Builder to render the images inside a [SingleChildScrollView]
  final IndexedWidgetBuilder itemBuilder;

  /// If true, panning is enabled.
  final bool panEnabled;

  /// If true, scaling is enabled.
  final bool scaleEnabled;

  /// If true, double tap zooming is enabled.
  final bool enableDoubleTapZooming;

  /// Called when the zoom level changes in [SfPdfViewer].
  ///
  /// Called in the following scenarios where the zoom level changes
  /// 1. When pinch zoom is performed.
  /// 2. When double tap zooming is performed.
  /// 3. When [zoomLevel] property is changed.
  ///
  /// The [oldZoomLevel] and [newZoomLevel] values in the [PdfZoomDetails] will
  /// be updated
  /// when the zoom level changes.
  ///
  /// See also: [PdfZoomDetails].
  final PdfZoomLevelChangedCallback onZoomLevelChanged;

  /// It controls the PdfViewer
  final PdfViewerController pdfController;

  /// Returns the closest point to the given point on the given line segment.
  static Vector3 getNearestPointOnLine(Vector3 point, Vector3 l1, Vector3 l2) {
    final double lengthSquared = math.pow(l2.x - l1.x, 2.0).toDouble() +
        math.pow(l2.y - l1.y, 2.0).toDouble();

    /// In this case, l1 == l2.
    if (lengthSquared == 0) {
      return l1;
    }

    /// Calculate how far down the line segment the closest point is and return
    /// the point.
    final Vector3 l1P = point - l1;
    final Vector3 l1L2 = l2 - l1;
    final double fraction =
        (l1P.dot(l1L2) / lengthSquared).clamp(0.0, 1.0).toDouble();
    return l1 + l1L2 * fraction;
  }

  /// Given a quad, return its axis aligned bounding box.
  static Quad getAxisAlignedBoundingBox(Quad quad) {
    final double minX = math.min(
      quad.point0.x,
      math.min(
        quad.point1.x,
        math.min(
          quad.point2.x,
          quad.point3.x,
        ),
      ),
    );
    final double minY = math.min(
      quad.point0.y,
      math.min(
        quad.point1.y,
        math.min(
          quad.point2.y,
          quad.point3.y,
        ),
      ),
    );
    final double maxX = math.max(
      quad.point0.x,
      math.max(
        quad.point1.x,
        math.max(
          quad.point2.x,
          quad.point3.x,
        ),
      ),
    );
    final double maxY = math.max(
      quad.point0.y,
      math.max(
        quad.point1.y,
        math.max(
          quad.point2.y,
          quad.point3.y,
        ),
      ),
    );
    return Quad.points(
      Vector3(minX, minY, 0),
      Vector3(maxX, minY, 0),
      Vector3(maxX, maxY, 0),
      Vector3(minX, maxY, 0),
    );
  }

  /// Returns true iff the point is inside the rectangle given by the Quad,
  /// inclusively.
  static bool pointIsInside(Vector3 point, Quad quad) {
    final Vector3 aM = point - quad.point0;
    final Vector3 aB = quad.point1 - quad.point0;
    final Vector3 aD = quad.point3 - quad.point0;

    final double aMAB = aM.dot(aB);
    final double aBAB = aB.dot(aB);
    final double aMAD = aM.dot(aD);
    final double aDAD = aD.dot(aD);

    return 0 <= aMAB && aMAB <= aBAB && 0 <= aMAD && aMAD <= aDAD;
  }

  /// Get the point inside (inclusively) the given Quad that is nearest to the
  /// given Vector3.
  static Vector3 getNearestPointInside(Vector3 point, Quad quad) {
    // If the point is inside the axis aligned bounding box, then it's ok where
    // it is.
    if (pointIsInside(point, quad)) {
      return point;
    }

    // Otherwise, return the nearest point on the quad.
    final List<Vector3> closestPoints = <Vector3>[
      PdfContainer.getNearestPointOnLine(point, quad.point0, quad.point1),
      PdfContainer.getNearestPointOnLine(point, quad.point1, quad.point2),
      PdfContainer.getNearestPointOnLine(point, quad.point2, quad.point3),
      PdfContainer.getNearestPointOnLine(point, quad.point3, quad.point0),
    ];
    double minDistance = double.infinity;
    Vector3 closestOverall;
    for (final Vector3 closePoint in closestPoints) {
      final double distance = math.sqrt(
        math.pow(point.x - closePoint.x, 2) +
            math.pow(point.y - closePoint.y, 2),
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestOverall = closePoint;
      }
    }
    return closestOverall;
  }

  @override
  PdfContainerState createState() => PdfContainerState();
}

/// State for a [PdfContainer]
class PdfContainerState extends State<PdfContainer>
    with TickerProviderStateMixin {
  final bool _alignPanAxis = false;
  final double _minScale = 1.0, _maxScale = 3.0;
  double _scale = 1.0;
  double _previousScale = 1.0;
  final EdgeInsets _boundaryMargin = EdgeInsets.zero;
  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();
  Animation<Offset> _animation;
  AnimationController _animationController;
  PdfViewerController _pdfController;
  Offset _tapPosition = Offset.zero, _previousOffset = Offset.zero;
  Offset _origin;
  Axis _panAxis; // Used with alignPanAxis.
  Offset _referenceFocalPoint; // Point where the current gesture began.
  double _scaleStart; // Scale value at start of scaling gesture.
  _GestureType _gestureType;
  bool _isPositionHandlerAttached = false;
  // Scale Matrix
  Matrix4 _viewMatrix;

  /// Gets the Scale matrix
  Matrix4 get viewMatrix => _viewMatrix;

  /// Sets the Scale matrix
  set viewMatrix(value) {
    if (value != _viewMatrix) {
      setState(() {
        _viewMatrix = value;
      });
    }
  }

  // Used as the coefficient of friction in the inertial translation animation.
  // This value was eyeballed to give a feel similar to Google Photos.
  static const double _kDrag = 0.0000135;

  // The Rect representing the child's parent.
  Rect get _viewport {
    assert(_parentKey.currentContext != null);
    final RenderBox parentRenderBox =
        // ignore: avoid_as
        _parentKey.currentContext.findRenderObject() as RenderBox;
    return Offset.zero & parentRenderBox.size;
  }

  // Return a new matrix representing the given matrix after applying the given
  // translation.
  Matrix4 _matrixTranslate(Matrix4 matrix, Offset translation) {
    if (translation == Offset.zero) {
      return matrix.clone();
    }

    final Offset alignedTranslation = _alignPanAxis && _panAxis != null
        ? _alignAxis(translation, _panAxis)
        : translation;

    final Matrix4 nextMatrix = matrix.clone()
      ..translate(
        alignedTranslation.dx,
        alignedTranslation.dy,
      );

    // Transform the viewport to determine where its four corners will be after
    // the child has been transformed.
    final Quad nextViewport = _transformViewport(nextMatrix, _viewport);

    final RenderBox childRenderBox =
        // ignore: avoid_as
        _childKey.currentContext.findRenderObject() as RenderBox;
    final Size childSize = childRenderBox.size;
    final Rect boundaryRect =
        _boundaryMargin.inflateRect(Offset.zero & childSize);

    // If the boundaries are infinite, then no need to check if the translation
    // fits within them.
    if (boundaryRect.isInfinite) {
      return nextMatrix;
    }

    final Quad boundariesAabbQuad = _getAxisAlignedBoundingBox(boundaryRect);

    // If the given translation fits completely within the boundaries, allow it.
    final Offset offendingDistance =
        _exceedsBy(boundariesAabbQuad, nextViewport);
    if (offendingDistance == Offset.zero) {
      return nextMatrix;
    }

    // Desired translation goes out of bounds, so translate to the nearest
    // in-bounds point instead.
    final Offset nextTotalTranslation = _getMatrixTranslation(nextMatrix);
    final double currentScale = matrix.getMaxScaleOnAxis();
    final Offset correctedTotalTranslation = Offset(
      nextTotalTranslation.dx - offendingDistance.dx * currentScale,
      nextTotalTranslation.dy - offendingDistance.dy * currentScale,
    );
    final Matrix4 correctedMatrix = matrix.clone()
      ..setTranslation(Vector3(
        correctedTotalTranslation.dx,
        correctedTotalTranslation.dy,
        0.0,
      ));

    // Double check that the corrected translation fits.
    final Quad correctedViewport =
        _transformViewport(correctedMatrix, _viewport);
    final Offset offendingCorrectedDistance =
        _exceedsBy(boundariesAabbQuad, correctedViewport);
    if (offendingCorrectedDistance == Offset.zero) {
      return correctedMatrix;
    }

    // If the corrected translation doesn't fit in either direction, don't allow
    // any translation at all. This happens when the viewport is larger than the
    // entire boundary.
    if (offendingCorrectedDistance.dx != 0.0 &&
        offendingCorrectedDistance.dy != 0.0) {
      return matrix.clone();
    }

    // Otherwise, allow translation in only the direction that fits. This
    // happens when the viewport is larger than the boundary in one direction.
    final Offset unidirectionalCorrectedTotalTranslation = Offset(
      offendingCorrectedDistance.dx == 0.0 ? correctedTotalTranslation.dx : 0.0,
      offendingCorrectedDistance.dy == 0.0 ? correctedTotalTranslation.dy : 0.0,
    );
    return matrix.clone()
      ..setTranslation(Vector3(
        unidirectionalCorrectedTotalTranslation.dx,
        unidirectionalCorrectedTotalTranslation.dy,
        0.0,
      ));
  }

  // Return a new matrix representing the given matrix after applying the given
  // scale.
  Matrix4 _matrixScale(Matrix4 matrix, double scale) {
    if (scale == 1.0) {
      return matrix.clone();
    }
    assert(scale != 0.0);

    // Don't allow a scale that results in an overall scale beyond min/max
    // scale.
    final double currentScale = viewMatrix.getMaxScaleOnAxis();
    final double totalScale = currentScale * scale;
    final double clampedTotalScale = totalScale
        .clamp(
          _minScale,
          _maxScale,
        )
        .toDouble();
    final double clampedScale = clampedTotalScale / currentScale;
    final Matrix4 nextMatrix = matrix.clone()..scale(clampedScale);

    return nextMatrix;
  }

  // Returns true if the given _GestureType is enabled.
  bool _gestureIsSupported(_GestureType gestureType) {
    switch (gestureType) {
      case _GestureType.scale:
        return widget.scaleEnabled;

      case _GestureType.pan:
      default:
        return widget.panEnabled;
    }
  }

  double _pixels = 0;
  double _translationY = 0;

  // Handle scale start of a gesture.
  void _handleScaleStart(ScaleStartDetails details) {
    if (_animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
      _animation?.removeListener(_handleAnimate);
      _animation = null;
    }

    _gestureType = null;
    _panAxis = null;
    _scaleStart = viewMatrix.getMaxScaleOnAxis();
    _pixels = widget.scrollController.position.pixels;
    _translationY = 0;
    if (widget.scrollController.position.maxScrollExtent > 0) {
      final factor = _pixels / widget.scrollController.position.maxScrollExtent;
      final totalSize = widget.scrollController.position.viewportDimension +
          widget.scrollController.position.maxScrollExtent;
      final scaledSize = _scaleStart * totalSize;
      final scaledMaxScrollExtent =
          scaledSize - widget.scrollController.position.viewportDimension;
      _pixels = scaledMaxScrollExtent * factor;
      _pixels = (_pixels / scaledSize) *
          totalSize; //Converting the pixels to scale level 1
    } else {
      _pixels = 0.0;
    }
    _referenceFocalPoint = toScene(
      details.localFocalPoint,
    );
    _previousOffset =
        Offset(-_referenceFocalPoint.dx, -(widget.scrollController.offset));
  }

  void _setPosition(Offset translation) {
    final position = widget.scrollController.position;
    final maxScrollExtent =
        position.maxScrollExtent > 0 ? position.maxScrollExtent : 1;
    _translationY = _translationY + translation.dy;
    final totalSize = position.viewportDimension + maxScrollExtent;
    double factor = (_pixels - _translationY) / totalSize;
    final scaledSize = totalSize * viewMatrix.getMaxScaleOnAxis();
    final scaledMaxScrollExtent = scaledSize - position.viewportDimension;
    final factorAfterScaling = (scaledSize * factor) / scaledMaxScrollExtent;
    double newPixels = maxScrollExtent * factorAfterScaling;
    if (newPixels < 0) {
      newPixels = 0;
    }
    position.jumpTo(
        newPixels); //This calculation is to move the scroll head based on scaling
    factor = newPixels / maxScrollExtent;
    _origin = Offset(
        0,
        position.viewportDimension *
            factor); //This is to scale by having the scroll head position as origin.
    if (position.maxScrollExtent <= 0) {
      //maxScrollExtent less than zero this condition triggered
      _origin = Offset(0, 0);
      viewMatrix = _matrixTranslate(viewMatrix, Offset(0, translation.dy));
    }
  }

  /// Handle scale update for ongoing gesture.
  void _handleScaleUpdate({ScaleUpdateDetails details, bool doubleTap}) {
    Offset focalPointScene;
    //if the double details are not null doubleTap invoked ,otherwise pinch zoom invoked
    if (doubleTap != null) {
      Offset _offset;
      if (_scale <= 1.0) {
        _origin = Offset.zero;
        final Offset normalizedOffset =
            ((_tapPosition) - _previousOffset * _scale) / _scale;
        _scale = 2;
        //this offset represent the current focus offset after double tap zoom
        _offset = ((_tapPosition) - normalizedOffset * _scale) / _scale;
        viewMatrix = _matrixScale(
          viewMatrix,
          _scale,
        );

        // Translating in X axis and ignored Y axis. If the Y axis is translated
        // then, the viewport origin will be changed to current translation
        // offset which causes few parts of the document inaccessible.
        // Y axis translation will be handled by scroll controller
        // to maintain exact scale offset without cropping the document
        // in the following codes.
        viewMatrix = _matrixTranslate(viewMatrix, Offset(_offset.dx, 0));
        widget.scrollController.jumpTo(-(_offset.dy));
      } else {
        final Offset normalizedOffset =
            ((_tapPosition) - _previousOffset * _scale) / _scale;
        viewMatrix = _matrixScale(
          viewMatrix,
          1.0 / _scale,
        );
        _scale = 1;
        //this offset represent the current focus offset after double tap zoom
        _offset = ((_tapPosition) - normalizedOffset * _scale) / _scale;

        // Translating in X axis and ignored Y axis. If the Y axis is translated
        // then, the viewport origin will be changed to current translation
        // offset which causes few parts of the document inaccessible.
        // Y axis translation will be handled by scroll controller
        // to maintain exact scale offset without cropping the document
        // in the following codes.
        viewMatrix = _matrixTranslate(viewMatrix, Offset(_offset.dx, 0));
        widget.scrollController.jumpTo(-_offset.dy);
      }
      _setPosition(_offset - _previousOffset);
      if (_pdfController != null) {
        _pdfController.zoomLevel = _scale;
        _previousScale = _scale;
      }
    } else {
      _scale = viewMatrix.getMaxScaleOnAxis();
      focalPointScene = toScene(
        details.localFocalPoint,
      );
      _gestureType ??=
          _getGestureType(!widget.scaleEnabled ? 1.0 : details.scale);
      if (_gestureType == _GestureType.pan) {
        _panAxis ??= _getPanAxis(_referenceFocalPoint, focalPointScene);
      }

      if (!_gestureIsSupported(_gestureType)) {
        return;
      }
    }
    switch (_gestureType) {
      case _GestureType.scale:
        if (_scaleStart == null) {
          return;
        }

        _origin = Offset.zero;

        // details.scale gives us the amount to change the scale as of the
        // start of this gesture, so calculate the amount to scale as of the
        // previous call to _onScaleUpdate.
        final double desiredScale = _scaleStart * details.scale;
        final double scaleChange = desiredScale / _scale;
        viewMatrix = _matrixScale(
          viewMatrix,
          scaleChange,
        );

        // While scaling, translate such that the user's two fingers stay on
        // the same places in the scene. That means that the focal point of
        // the scale should be on the same place in the scene before and after
        // the scale.
        final Offset focalPointSceneScaled = toScene(
          details.localFocalPoint,
        );

        final translation = focalPointSceneScaled - _referenceFocalPoint;

        // Translating in X axis and ignored Y axis. If the Y axis is translated
        // then, the viewport origin will be changed to current translation
        // offset which causes few parts of the document inaccessible.
        // Y axis translation will be handled by scroll controller
        // to maintain exact scale offset without cropping the document
        // in the following codes.
        viewMatrix = _matrixTranslate(viewMatrix, Offset(translation.dx, 0.0));
        _setPosition(translation);
        // details.localFocalPoint should now be at the same location as the
        // original _referenceFocalPoint point. If it's not, that's because
        // the translate came in contact with a boundary. In that case, update
        // _referenceFocalPoint so subsequent updates happen in relation to
        // the new effective focal point.
        final Offset focalPointSceneCheck = toScene(
          details.localFocalPoint,
        );
        if (_round(_referenceFocalPoint) != _round(focalPointSceneCheck)) {
          _referenceFocalPoint = focalPointSceneCheck;
        }
        return;

      case _GestureType.pan:
        if (_referenceFocalPoint == null || details.scale != 1.0) {
          return;
        }
        // Translate so that the same point in the scene is underneath the
        // focal point before and after the movement. We have ignore dy since
        // the Y axis is translation is done by scroll controller.
        final Offset translationChange = focalPointScene - _referenceFocalPoint;
        viewMatrix = _matrixTranslate(
          viewMatrix,
          Offset(
              translationChange.dx,
              widget.scrollController.position.maxScrollExtent > 0
                  ? 0
                  : translationChange.dy),
        );
        _referenceFocalPoint = toScene(
          details.localFocalPoint,
        );
        return;
    }
  }

  // Handle scale end of a gesture of _GestureType.
  void _handleScaleEnd(ScaleEndDetails details) {
    if (_pdfController != null) {
      _pdfController.zoomLevel = _scale;
    }
    _previousScale = _scale;
    _scaleStart = null;
    _referenceFocalPoint = null;
    _animation?.removeListener(_handleAnimate);
    _animationController.reset();
    if (!_gestureIsSupported(_gestureType)) {
      _panAxis = null;
      return;
    }

    // If the scale ended with enough velocity, animate inertial movement.
    if (_gestureType != _GestureType.pan ||
        details.velocity.pixelsPerSecond.distance < kMinFlingVelocity) {
      _panAxis = null;
      return;
    }

    final Vector3 translationVector = viewMatrix.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    final FrictionSimulation frictionSimulationX = FrictionSimulation(
      _kDrag,
      translation.dx,
      details.velocity.pixelsPerSecond.dx,
    );
    final FrictionSimulation frictionSimulationY = FrictionSimulation(
      _kDrag,
      translation.dy,
      details.velocity.pixelsPerSecond.dy,
    );
    final double tFinal = _getFinalTime(
      details.velocity.pixelsPerSecond.distance,
      _kDrag,
    );
    _animation = Tween<Offset>(
      begin: translation,
      end: Offset(frictionSimulationX.finalX, frictionSimulationY.finalX),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));
    _animationController.duration =
        Duration(milliseconds: (tFinal * 1000).round());
    _animation.addListener(_handleAnimate);
    _animationController.forward();
  }

  // Handle inertia animation.
  void _handleAnimate() {
    if (!_animationController.isAnimating) {
      _panAxis = null;
      _animation?.removeListener(_handleAnimate);
      _animation = null;
      _animationController.reset();
      return;
    }
    // Translate such that the resulting translation is _animation.value.
    final Vector3 translationVector = viewMatrix.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    final Offset translationScene = toScene(
      translation,
    );
    final Offset animationScene = toScene(
      _animation.value,
    );
    final Offset translationChangeScene = animationScene - translationScene;
    viewMatrix =
        _matrixTranslate(viewMatrix, Offset(translationChangeScene.dx, 0.0));
  }

  /// This method use to get the tap positions
  void _handleTapDown(TapDownDetails details) {
    _tapPosition = (details.localPosition);
  }

  void _onZoomLevelChanged() {
    if (_pdfController != null &&
        _pdfController.zoomLevel != null &&
        _scale != _pdfController.zoomLevel) {
      double scaleChangeFactor = 1.0;
      //whenever user set scale greater than maximum scale percentage and less than minimum scale percentage
      // it will be reassigned within limit
      if (_pdfController.zoomLevel > _maxScale) {
        _pdfController.zoomLevel = _maxScale;
      } else if (_pdfController.zoomLevel < _minScale) {
        _pdfController.zoomLevel = _minScale;
      }
      if (_scale != null) {
        //previous scale value updated here before scale changed
        _previousScale = _scale;
      }
      _scale = _pdfController.zoomLevel;
      scaleChangeFactor = _scale;
      //Here zoom in and zoom out logic applied,
      // setScale value changed  based on maximum zoom percentage to minimum scale percentage
      // and minimum percentage to maximum percentage
      if (_scale != null && _previousScale > _scale) {
        scaleChangeFactor = _scale / _previousScale;
      }

      viewMatrix = _matrixScale(
        viewMatrix,
        scaleChangeFactor,
      );
      viewMatrix = _matrixTranslate(
          viewMatrix, Offset(_viewport.width, _viewport.height));
    }

    // This invoked whenever current and previous scale percentage changed
    if (widget.onZoomLevelChanged != null) {
      final double newZoomLevel = _scale;
      final double oldZoomLevel = _previousScale;
      if (newZoomLevel != oldZoomLevel) {
        widget.onZoomLevelChanged(PdfZoomDetails(newZoomLevel, oldZoomLevel));
      }
    }
  }

  /// Call the method according to property name.
  void _onControllerValueChange({String property}) {
    if (property == 'zoomLevel') {
      _onZoomLevelChanged();
    }
  }

  /// Jumps horizontally in view port.
  void jumpHorizontally(double value) {
    viewMatrix = _matrixTranslate(viewMatrix, Offset(value, 0));
  }

  /// resets PdfContainer view matrix
  void reset() {
    viewMatrix = Matrix4.identity();
  }

  @override
  void initState() {
    super.initState();
    _pdfController = widget.pdfController;
    _pdfController?.addListener(_onControllerValueChange);
    viewMatrix = Matrix4.identity();
    if (_pdfController.zoomLevel != null) {
      if (_pdfController.zoomLevel < _minScale ||
          _pdfController.zoomLevel > _maxScale) {
        _pdfController.zoomLevel = _minScale;
      } else {
        viewMatrix = _matrixScale(
          viewMatrix,
          _pdfController.zoomLevel,
        );
        _scale = _pdfController.zoomLevel;
        _previousScale = _scale;
      }
    }
    _animationController = AnimationController(
      vsync: this,
    );

    // Added a listener for the scrolling.
    widget.scrollController.addListener(_updateOrigin);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pdfController?.removeListener(_onControllerValueChange);
    widget.scrollController.removeListener(_updateOrigin);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Transform(
      origin: _origin,
      transform: viewMatrix,
      child: KeyedSubtree(
        key: _childKey,
        child: Center(
          child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                  children: List.generate(widget.pdfController.pageCount,
                      (index) => widget.itemBuilder(context, index)).toList())),
        ),
      ),
    );

    // A GestureDetector allows the detection of panning and zooming gestures on
    // the child.
    return Listener(
      key: _parentKey,
      child: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          // Necessary when panning off screen.
          gestures: {
            PdfScaleRecognizer:
                GestureRecognizerFactoryWithHandlers<PdfScaleRecognizer>(
              () => PdfScaleRecognizer(),
              (PdfScaleRecognizer instance) {
                instance.onStart = (details) => _handleScaleStart(details);
                instance.onUpdate =
                    (details) => _handleScaleUpdate(details: details);
                instance.onEnd = (details) => _handleScaleEnd(details);
              },
            ),
            DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                DoubleTapGestureRecognizer>(
              () => DoubleTapGestureRecognizer(),
              (DoubleTapGestureRecognizer instances) {
                //when user disable double tap zoom it does not allowed to perform double tap zoom operations
                if (widget.enableDoubleTapZooming) {
                  instances.onDoubleTap =
                      () => _handleScaleUpdate(doubleTap: true);
                } else {
                  instances.onDoubleTap = null;
                }
              },
            ),
            TapRecognizer: GestureRecognizerFactoryWithHandlers<TapRecognizer>(
              () => TapRecognizer(),
              (TapRecognizer instances) {
                instances.onTapDown = (int num, details) {
                  if (!FocusScope.of(context).hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  _handleTapDown(details);
                };
              },
            ),
          },
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: child,
          )),
    );
  }

  /// Return the scene point at the given viewport point.
  Offset toScene(Offset viewportPoint) {
    // On viewportPoint, perform the inverse transformation of the scene to get
    // where the point would be in the scene before the transformation.
    final Matrix4 inverseMatrix = Matrix4.inverted(viewMatrix);
    final Vector3 untransformed = inverseMatrix.transform3(Vector3(
      viewportPoint.dx,
      viewportPoint.dy,
      0,
    ));
    return Offset(untransformed.x, untransformed.y);
  }

  void _updateOrigin() {
    if (_isPositionHandlerAttached) {
      return;
    }

    _isPositionHandlerAttached = true;

    widget.scrollController.position.addListener(() {
      if (_scaleStart != null) {
        return;
      }
      // Setting an origin is equivalent to conjugating the transform matrix by a
      // translation. Initially, origin for transform wasn't considered due to
      // which the scaling caused to hide the region in the page specifically
      // in first and last pages of the PDF. Resolve this issue,
      // we have considered the origin by considering the current position
      // and ratio with total extent. Here we have considered Y axis
      // as we perform vertical scrolling in continuous page mode

      setState(() {
        final position = widget.scrollController.position;
        if (position.maxScrollExtent > 0) {
          final factor = position.pixels / position.maxScrollExtent;
          _origin = Offset(0, position.viewportDimension * factor);
        }
      });
    });
  }
}

/// Represents the scale gesture recognizer for PdfContainer.
class PdfScaleRecognizer extends ScaleGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    /// Since list view scroll interrupts scale gesture, overridden the reject gesture behavior. This piece of code is planned to be changed in future.
    acceptGesture(pointer);
  }
}

// A classification of relevant user gestures. Each contiguous user gesture is
// represented by exactly one _GestureType.
enum _GestureType {
  pan,
  scale,
}

// Given a velocity and drag, calculate the time at which motion will come to
// a stop, within the margin of effectivelyMotionless.
double _getFinalTime(double velocity, double drag) {
  const double effectivelyMotionless = 10.0;
  return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
}

// Decide which type of gesture this is by comparing the amount of scale.
_GestureType _getGestureType(double scale) {
  if ((scale - 1).abs() > 0.0) {
    return _GestureType.scale;
  } else {
    return _GestureType.pan;
  }
}

// Return the translation from the given Matrix4 as an Offset.
Offset _getMatrixTranslation(Matrix4 matrix) {
  final Vector3 nextTranslation = matrix.getTranslation();
  return Offset(nextTranslation.x, nextTranslation.y);
}

// Transform the four corners of the viewport by the inverse of the given
// matrix. This gives the viewport after the child has been transformed by the
// given matrix. The viewport transforms as the inverse of the child (i.e.
// moving the child left is equivalent to moving the viewport right).
Quad _transformViewport(Matrix4 matrix, Rect viewport) {
  final Matrix4 inverseMatrix = matrix.clone()..invert();
  return Quad.points(
    inverseMatrix.transform3(Vector3(
      viewport.topLeft.dx,
      viewport.topLeft.dy,
      0.0,
    )),
    inverseMatrix.transform3(Vector3(
      viewport.topRight.dx,
      viewport.topRight.dy,
      0.0,
    )),
    inverseMatrix.transform3(Vector3(
      viewport.bottomRight.dx,
      viewport.bottomRight.dy,
      0.0,
    )),
    inverseMatrix.transform3(Vector3(
      viewport.bottomLeft.dx,
      viewport.bottomLeft.dy,
      0.0,
    )),
  );
}

// Find the axis aligned bounding box for the rect.
Quad _getAxisAlignedBoundingBox(Rect rect) {
  final Matrix4 transformMatrix = Matrix4.identity()
    ..translate(rect.size.width / 2, rect.size.height / 2)
    ..translate(-rect.size.width / 2, -rect.size.height / 2);
  final Quad boundaries = Quad.points(
    transformMatrix.transform3(Vector3(rect.left, rect.top, 0.0)),
    transformMatrix.transform3(Vector3(rect.right, rect.top, 0.0)),
    transformMatrix.transform3(Vector3(rect.right, rect.bottom, 0.0)),
    transformMatrix.transform3(Vector3(rect.left, rect.bottom, 0.0)),
  );
  return PdfContainer.getAxisAlignedBoundingBox(boundaries);
}

// Return the amount that viewport lies outside of boundary. If the viewport
// is completely contained within the boundary (inclusively), then returns
// Offset.zero.
Offset _exceedsBy(Quad boundary, Quad viewport) {
  final List<Vector3> viewportPoints = <Vector3>[
    viewport.point0,
    viewport.point1,
    viewport.point2,
    viewport.point3,
  ];
  Offset largestExcess = Offset.zero;
  for (final Vector3 point in viewportPoints) {
    final Vector3 pointInside =
        PdfContainer.getNearestPointInside(point, boundary);
    final Offset excess = Offset(
      pointInside.x - point.x,
      pointInside.y - point.y,
    );
    if (excess.dx.abs() > largestExcess.dx.abs()) {
      largestExcess = Offset(excess.dx, largestExcess.dy);
    }
    if (excess.dy.abs() > largestExcess.dy.abs()) {
      largestExcess = Offset(largestExcess.dx, excess.dy);
    }
  }

  return _round(largestExcess);
}

// Round the output values. This works around a precision problem where
// values that should have been zero were given as within 10^-10 of zero.
Offset _round(Offset offset) {
  return Offset(
    double.parse(offset.dx.toStringAsFixed(9)),
    double.parse(offset.dy.toStringAsFixed(9)),
  );
}

// Align the given offset to the given axis by allowing movement only in the
// axis direction.
Offset _alignAxis(Offset offset, Axis axis) {
  switch (axis) {
    case Axis.horizontal:
      return Offset(offset.dx, 0.0);
    case Axis.vertical:
    default:
      return Offset(0.0, offset.dy);
  }
}

// Given two points, return the axis where the distance between the points is
// greatest. If they are equal, return null.
Axis _getPanAxis(Offset point1, Offset point2) {
  if (point1 == point2) {
    return null;
  }
  final double x = point2.dx - point1.dx;
  final double y = point2.dy - point1.dy;
  return x.abs() > y.abs() ? Axis.horizontal : Axis.vertical;
}

/// Tap gesture recognizer for PdfContainer.
class TapRecognizer extends MultiTapGestureRecognizer {
  @override
  void rejectGesture(int pointers) {
    /// Since double Tap interrupts Tap gesture, overridden the reject gesture behavior. This piece of code is planned to be changed in future.
    acceptGesture(pointers);
  }
}
