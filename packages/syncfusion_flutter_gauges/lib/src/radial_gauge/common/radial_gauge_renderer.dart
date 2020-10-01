part of gauges;

/// Represents the container to render the axis and its element
///
class _AxisContainer extends StatelessWidget {
  const _AxisContainer(
      this._gauge, this._gaugeThemeData, this._renderingDetails);

  /// Hold the radial gauge animation details
  final _RenderingDetails _renderingDetails;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Specifies the radial gauge
  final SfRadialGauge _gauge;

  /// Method to update the pointer value
  void _updatePointerValue(BuildContext context, DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject();
    if (details != null && details.globalPosition != null) {
      final Offset tapPosition =
          renderBox.globalToLocal(details.globalPosition);
      for (num i = 0; i < _gauge.axes.length; i++) {
        final RadialAxisRenderer axisRenderer =
            _renderingDetails.axisRenderers[i];
        final List<_GaugePointerRenderer> _pointerRenderers =
            _renderingDetails.gaugePointerRenderers[i];
        if (_gauge.axes[i].pointers != null &&
            _gauge.axes[i].pointers.isNotEmpty) {
          for (num j = 0; j < _gauge.axes[i].pointers.length; j++) {
            final GaugePointer pointer = _gauge.axes[i].pointers[j];
            final _GaugePointerRenderer pointerRenderer = _pointerRenderers[j];
            if (pointer.enableDragging && pointerRenderer._isDragStarted) {
              final Rect rect = Rect.fromLTRB(
                  axisRenderer._axisRect.left + axisRenderer._axisCenter.dx,
                  axisRenderer._axisRect.top + axisRenderer._axisCenter.dy,
                  axisRenderer._axisRect.right + axisRenderer._axisCenter.dx,
                  axisRenderer._axisRect.bottom + axisRenderer._axisCenter.dy);
              if (pointer is RangePointer) {
                final double actualCenterX = pointerRenderer._pointerRect.left +
                    axisRenderer._axisCenter.dx +
                    axisRenderer._radius;
                final double actualCenterY = pointerRenderer._pointerRect.top +
                    axisRenderer._axisCenter.dy +
                    axisRenderer._radius;
                final double x = tapPosition.dx - actualCenterX;
                final double y = tapPosition.dy - actualCenterY;

                /// Checks whether the tapped position is available inside the
                /// radius of range pointer
                final bool isInside = (x * x) + (y * y) <=
                    (axisRenderer._radius * axisRenderer._radius);
                if (isInside) {
                  pointerRenderer._updateDragValue(
                      tapPosition.dx, tapPosition.dy, _renderingDetails);
                }
              }

              /// Checks whether the tapped position is available inside the
              /// rect of needle or marker pointer
              else if (rect.contains(tapPosition)) {
                pointerRenderer._updateDragValue(
                    tapPosition.dx, tapPosition.dy, _renderingDetails);
              }
            }
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

    return GestureDetector(
        // onPanStart: enablePointerDragging
        //     ? (DragStartDetails details) =>
        //         _checkPointerDragging(context, details)
        //     : null,
        // onPanUpdate: enablePointerDragging
        //     ? (DragUpdateDetails details) =>
        //         _updatePointerValue(context, details)
        //     : null,
        // onPanEnd: enablePointerDragging
        //     ? (DragEndDetails details) => _checkPointerIsDragged()
        //     : null,

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
            ? (TapUpDetails details) => _checkIsAxisTapped(context, details)
            : null,
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Stack(children: gaugeWidgets),
        ));
  }

  // Checks whether onAxisTapped callback is activated.
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
      if (currentAxis.pointers != null && currentAxis.pointers.isNotEmpty) {
        for (int j = 0; j < currentAxis.pointers.length; j++) {
          if (currentAxis.pointers[j].enableDragging) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Method to check whether the axis is tapped
  void _checkIsAxisTapped(BuildContext context, TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject();
    if (details != null && details.globalPosition != null) {
      if (_gauge.axes.isNotEmpty) {
        for (num i = 0; i < _gauge.axes.length; i++) {
          final RadialAxis axis = _gauge.axes[i];
          final RadialAxisRenderer axisRenderer =
              _renderingDetails.axisRenderers[i];
          final Offset offset = renderBox.globalToLocal(details.globalPosition);
          if (axis.onAxisTapped != null &&
              axisRenderer._axisPath.getBounds().contains(offset)) {
            axisRenderer._calculateAngleFromOffset(offset);
          }
        }
      }
    }
  }

  /// Method to check whether the axis pointer is dragging
  void _checkPointerDragging(BuildContext context, DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject();
    if (details != null && details.globalPosition != null) {
      final Offset tapPosition =
          renderBox.globalToLocal(details.globalPosition);
      for (num i = 0; i < _gauge.axes.length; i++) {
        final RadialAxisRenderer axisRenderer =
            _renderingDetails.axisRenderers[i];
        final List<_GaugePointerRenderer> pointerRenderers =
            _renderingDetails.gaugePointerRenderers[i];
        if (_gauge.axes[i].pointers != null &&
            _gauge.axes[i].pointers.isNotEmpty) {
          for (num j = 0; j < _gauge.axes[i].pointers.length; j++) {
            final GaugePointer pointer = _gauge.axes[i].pointers[j];
            final _GaugePointerRenderer pointerRenderer = pointerRenderers[j];
            if (pointer.enableDragging) {
              if (pointer is RangePointer) {
                final _RangePointerRenderer renderer = pointerRenderer;
                final Rect pathRect = Rect.fromLTRB(
                    renderer._arcPath.getBounds().left +
                        axisRenderer._axisCenter.dx -
                        5,
                    renderer._arcPath.getBounds().top +
                        axisRenderer._axisCenter.dy -
                        5,
                    renderer._arcPath.getBounds().right +
                        axisRenderer._axisCenter.dx +
                        5,
                    renderer._arcPath.getBounds().bottom +
                        axisRenderer._axisCenter.dy +
                        5);

                // Checks whether the tapped position is present inside
                // the range pointer path
                if (pathRect.contains(tapPosition)) {
                  renderer._isDragStarted = true;
                  renderer._createPointerValueChangeStartArgs();
                  break;
                } else {
                  renderer._isDragStarted = false;
                }
              } else {
                if (pointerRenderer._pointerRect.contains(tapPosition)) {
                  pointerRenderer._isDragStarted = true;
                  pointerRenderer._createPointerValueChangeStartArgs();
                  break;
                } else {
                  pointerRenderer._isDragStarted = false;
                }
              }
            }
          }
        }
      }
    }
  }

  /// Method to ensure whether the pointer was dragged
  void _checkPointerIsDragged() {
    if (_gauge.axes != null) {
      for (num i = 0; i < _gauge.axes.length; i++) {
        if (_gauge.axes[i].pointers != null &&
            _gauge.axes[i].pointers.isNotEmpty) {
          final List<_GaugePointerRenderer> pointerRenderers =
              _renderingDetails.gaugePointerRenderers[i];
          for (num j = 0; j < _gauge.axes[i].pointers.length; j++) {
            final GaugePointer pointer = _gauge.axes[i].pointers[j];
            final _GaugePointerRenderer pointerRenderer = pointerRenderers[j];
            if (pointer.enableDragging) {
              if (pointerRenderer._isDragStarted) {
                pointerRenderer._createPointerValueChangeEndArgs();

                if (pointer is NeedlePointer) {
                  final NeedlePointerRenderer renderer = pointerRenderer;
                  renderer._animationEndValue = renderer._getSweepAngle();
                } else if (pointer is MarkerPointer) {
                  final MarkerPointerRenderer renderer = pointerRenderer;
                  renderer._animationEndValue = renderer._getSweepAngle();
                } else {
                  final _RangePointerRenderer renderer = pointerRenderer;
                  renderer._animationEndValue = renderer._getSweepAngle();
                }
              }
              pointerRenderer._isDragStarted = false;
            }
          }
        }
      }
    }
  }

  /// Calculates the axis position
  void _calculateAxisElementPosition(
      BuildContext context, BoxConstraints constraints) {
    if (_gauge.axes != null && _gauge.axes.isNotEmpty) {
      for (int i = 0; i < _gauge.axes.length; i++) {
        final RadialAxisRenderer axisRenderer =
            _renderingDetails.axisRenderers[i];
        if (axisRenderer != null) {
          axisRenderer._calculateAxisRange(
              constraints, context, _gaugeThemeData, _renderingDetails);
        }
      }
    }
  }

  /// Methods to add the gauge elements
  void _addGaugeElements(BoxConstraints constraints, BuildContext context,
      List<Widget> gaugeWidgets) {
    if (_gauge.axes != null && _gauge.axes.isNotEmpty) {
      final _AnimationDurationDetails durationDetails =
          _AnimationDurationDetails();
      _calculateDurationForAnimation(durationDetails);
      for (int i = 0; i < _gauge.axes.length; i++) {
        final RadialAxis axis = _gauge.axes[i];
        final GaugeAxisRenderer axisRenderer =
            _renderingDetails.axisRenderers[i];

        _addAxis(
            axis, constraints, gaugeWidgets, durationDetails, axisRenderer);

        if (axis.ranges != null && axis.ranges.isNotEmpty) {
          final List<_GaugeRangeRenderer> rangeRenderers =
              _renderingDetails.gaugeRangeRenderers[i];
          _addRange(axis, constraints, gaugeWidgets, durationDetails,
              axisRenderer, rangeRenderers);
        }

        if (axis.pointers != null && axis.pointers.isNotEmpty) {
          final List<_GaugePointerRenderer> pointerRenderers =
              _renderingDetails.gaugePointerRenderers[i];
          for (num j = 0; j < axis.pointers.length; j++) {
            final _GaugePointerRenderer pointerRenderer = pointerRenderers[j];
            if (axis.pointers[j] is NeedlePointer) {
              final NeedlePointer needlePointer = axis.pointers[j];
              _addNeedlePointer(axis, constraints, needlePointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            } else if (axis.pointers[j] is MarkerPointer) {
              final MarkerPointer markerPointer = axis.pointers[j];
              _addMarkerPointer(axis, constraints, markerPointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            } else if (axis.pointers[j] is RangePointer) {
              final RangePointer rangePointer = axis.pointers[j];
              _addRangePointer(axis, constraints, rangePointer, gaugeWidgets,
                  durationDetails, axisRenderer, pointerRenderer);
            }
          }
        }

        if (axis.annotations != null && axis.annotations.isNotEmpty) {
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
      RadialAxisRenderer axisRenderer) {
    Animation<double> axisAnimation;
    Animation<double> axisElementAnimation;
    if (_renderingDetails.needsToAnimateAxes &&
        (durationDetails.hasAxisLine || durationDetails.hasAxisElements)) {
      _renderingDetails.animationController.duration =
          Duration(milliseconds: _gauge.animationDuration.toInt());
      // Includes animation duration for axis line
      if (durationDetails.hasAxisLine) {
        axisAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: _renderingDetails.animationController,
            curve: Interval(durationDetails.axisLineInterval[0],
                durationDetails.axisLineInterval[1],
                curve: Curves.easeIn)));
      }
      // Includes animation duration for axis ticks and labels
      if (durationDetails.hasAxisElements) {
        axisElementAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _renderingDetails.animationController,
                curve: Interval(durationDetails.axisElementsInterval[0],
                    durationDetails.axisElementsInterval[1],
                    curve: Curves.easeIn)));
      }
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: _AxisPainter(
                _gauge,
                axis,
                axisRenderer._needsRepaintAxis ?? true,
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
      _renderingDetails.animationController.forward(from: 0.0);
    }
  }

  /// Adds the range pointer
  void _addRangePointer(
      RadialAxis axis,
      BoxConstraints constraints,
      RangePointer rangePointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRenderer axisRenderer,
      _GaugePointerRenderer pointerRenderer) {
    final _RangePointerRenderer rangePointerRenderer = pointerRenderer;
    rangePointerRenderer._animationEndValue =
        rangePointerRenderer._getSweepAngle();
    Animation<double> pointerAnimation;
    final List<double> animationIntervals =
        _getPointerAnimationInterval(durationDetails);
    if (_renderingDetails.needsToAnimatePointers ||
        (rangePointer.enableAnimation &&
            rangePointer.animationDuration > 0 &&
            rangePointerRenderer._needsAnimate)) {
      _renderingDetails.animationController.duration = Duration(
          milliseconds:
              _getPointerAnimationDuration(rangePointer.animationDuration));
      final Curve pointerAnimationType =
          _getCurveAnimation(rangePointer.animationType);
      final double endValue = rangePointerRenderer._animationEndValue;
      pointerAnimation = Tween<double>(
              begin: rangePointerRenderer._animationStartValue ?? 0,
              end: endValue)
          .animate(CurvedAnimation(
              parent: _renderingDetails.animationController,
              curve: Interval(animationIntervals[0], animationIntervals[1],
                  curve: pointerAnimationType)));
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: _RangePointerPainter(
                _gauge,
                axis,
                rangePointer,
                rangePointerRenderer._needsRepaintPointer ?? true,
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
        rangePointerRenderer._getIsPointerAnimationEnabled()) {
      _renderingDetails.animationController.forward(from: 0.0);
    }
  }

  /// Adds the needle pointer
  void _addNeedlePointer(
      RadialAxis axis,
      BoxConstraints constraints,
      NeedlePointer needlePointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRenderer axisRenderer,
      _GaugePointerRenderer pointerRenderer) {
    final NeedlePointerRenderer needleRenderer = pointerRenderer;
    Animation<double> pointerAnimation;
    final List<double> intervals =
        _getPointerAnimationInterval(durationDetails);
    needleRenderer._animationEndValue = needleRenderer._getSweepAngle();
    if (_renderingDetails.needsToAnimatePointers ||
        (needlePointer.enableAnimation &&
            needlePointer.animationDuration > 0 &&
            needleRenderer._needsAnimate)) {
      _renderingDetails.animationController.duration = Duration(
          milliseconds:
              _getPointerAnimationDuration(needlePointer.animationDuration));

      final double startValue = axis.isInversed ? 1 : 0;
      final double endValue = axis.isInversed ? 0 : 1;
      double actualValue = needleRenderer._animationStartValue ?? startValue;
      actualValue = actualValue == endValue ? startValue : actualValue;
      pointerAnimation = Tween<double>(
              begin: actualValue, end: needleRenderer._animationEndValue)
          .animate(CurvedAnimation(
              parent: _renderingDetails.animationController,
              curve: Interval(intervals[0], intervals[1],
                  curve: _getCurveAnimation(needlePointer.animationType))));
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: _NeedlePointerPainter(
                _gauge,
                axis,
                needlePointer,
                needleRenderer._needsRepaintPointer ?? true,
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
        needleRenderer._getIsPointerAnimationEnabled()) {
      _renderingDetails.animationController.forward(from: 0.0);
    }
  }

  /// Adds the marker pointer
  void _addMarkerPointer(
      RadialAxis axis,
      BoxConstraints constraints,
      MarkerPointer markerPointer,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRenderer axisRenderer,
      _GaugePointerRenderer pointerRenderer) {
    final MarkerPointerRenderer markerRenderer = pointerRenderer;
    Animation<double> pointerAnimation;
    final List<double> pointerIntervals =
        _getPointerAnimationInterval(durationDetails);
    markerRenderer._animationEndValue = markerRenderer._getSweepAngle();
    if (_renderingDetails.needsToAnimatePointers ||
        (markerPointer.enableAnimation &&
            markerPointer.animationDuration > 0 &&
            markerRenderer._needsAnimate)) {
      _renderingDetails.animationController.duration = Duration(
          milliseconds:
              _getPointerAnimationDuration(markerPointer.animationDuration));

      final double startValue = axis.isInversed ? 1 : 0;
      pointerAnimation = Tween<double>(
              begin: markerRenderer._animationStartValue ?? startValue,
              end: markerRenderer._animationEndValue)
          .animate(CurvedAnimation(
              parent: _renderingDetails.animationController,
              curve: Interval(pointerIntervals[0], pointerIntervals[1],
                  curve: _getCurveAnimation(markerPointer.animationType))));
    }

    gaugeWidgets.add(Container(
      child: RepaintBoundary(
        child: CustomPaint(
            painter: _MarkerPointerPainter(
                _gauge,
                axis,
                markerPointer,
                markerRenderer._needsRepaintPointer ?? true,
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
        markerRenderer._getIsPointerAnimationEnabled()) {
      _renderingDetails.animationController.forward(from: 0.0);
    }
  }

  /// Adds the axis range
  void _addRange(
      RadialAxis axis,
      BoxConstraints constraints,
      List<Widget> gaugeWidgets,
      _AnimationDurationDetails durationDetails,
      RadialAxisRenderer axisRenderer,
      List<_GaugeRangeRenderer> rangeRenderers) {
    for (num k = 0; k < axis.ranges.length; k++) {
      final GaugeRange range = axis.ranges[k];
      final _GaugeRangeRenderer rangeRenderer = rangeRenderers[k];
      Animation<double> rangeAnimation;
      if (_renderingDetails.needsToAnimateRanges) {
        _renderingDetails.animationController.duration =
            Duration(milliseconds: _gauge.animationDuration.toInt());
        rangeAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _renderingDetails.animationController,
                curve: Interval(durationDetails.rangesInterval[0],
                    durationDetails.rangesInterval[1],
                    curve: Curves.easeIn)));
      }

      gaugeWidgets.add(Container(
        child: RepaintBoundary(
          child: CustomPaint(
              painter: _RangePainter(
                  _gauge,
                  axis,
                  range,
                  rangeRenderer._needsRepaintRange ?? true,
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
        _renderingDetails.animationController.forward(from: 0.0);
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
  List<double> _getPointerAnimationInterval(
      _AnimationDurationDetails durationDetails) {
    List<double> pointerIntervals = List<double>(2);
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
      RadialAxisRenderer axisRenderer) {
    for (num j = 0; j < axis.annotations.length; j++) {
      final GaugeAnnotation annotation = axis.annotations[j];
      gaugeWidgets.add(_AnnotationRenderer(
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
    for (num i = 0; i < _gauge.axes.length; i++) {
      _calculateAxisElements(_gauge.axes[i], durationDetails);
    }

    totalCount = _getElementsCount(totalCount, durationDetails);

    interval = 1 / totalCount;
    endValue = interval;
    if (durationDetails.hasAxisLine) {
      durationDetails.axisLineInterval = List<double>(2);
      durationDetails.axisLineInterval[0] = startValue;
      durationDetails.axisLineInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasAxisElements) {
      durationDetails.axisElementsInterval = List<double>(2);
      durationDetails.axisElementsInterval[0] = startValue;
      durationDetails.axisElementsInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasRanges) {
      durationDetails.rangesInterval = List<double>(2);
      durationDetails.rangesInterval[0] = startValue;
      durationDetails.rangesInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasPointers) {
      durationDetails.pointersInterval = List<double>(2);
      durationDetails.pointersInterval[0] = startValue;
      durationDetails.pointersInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (durationDetails.hasAnnotations) {
      durationDetails.annotationInterval = List<double>(2);
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
        axis.ranges.isNotEmpty &&
        !durationDetails.hasRanges) {
      durationDetails.hasRanges = true;
    }

    if (axis.pointers != null &&
        axis.pointers.isNotEmpty &&
        !durationDetails.hasPointers) {
      durationDetails.hasPointers = true;
    }

    if (axis.annotations != null &&
        axis.annotations.isNotEmpty &&
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
  List<double> axisLineInterval;

  /// Specifies the axis element interval for load time animation
  List<double> axisElementsInterval;

  /// Specifies the range interval for initial animation
  List<double> rangesInterval;

  /// Specifies the pointer interval for load time animation
  List<double> pointersInterval;

  /// Specifies the annotation interval for load time animation
  List<double> annotationInterval;

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
