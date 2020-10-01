part of maps;

class _RenderShapeLayer extends RenderStack implements MouseTrackerAnnotation {
  _RenderShapeLayer({
    Map<String, _MapModel> mapDataSource,
    MapShapeLayerDelegate mapDelegate,
    bool enableShapeTooltip,
    bool enableBubbleTooltip,
    bool enableSelection,
    MapLegendSettings legendSettings,
    MapBubbleSettings bubbleSettings,
    MapSelectionSettings selectionSettings,
    MapZoomPanBehavior zoomPanBehavior,
    SfMapsThemeData themeData,
    _DefaultController defaultController,
    BuildContext context,
    _MapsShapeLayerState state,
  })  : _mapDataSource = mapDataSource,
        _mapDelegate = mapDelegate,
        _enableShapeTooltip = enableShapeTooltip,
        _enableBubbleTooltip = enableBubbleTooltip,
        _enableSelection = enableSelection,
        _legendSettings = legendSettings,
        _bubbleSettings = bubbleSettings,
        _selectionSettings = selectionSettings,
        _zoomPanBehavior = zoomPanBehavior,
        _themeData = themeData,
        context = context,
        defaultController = defaultController,
        _state = state,
        super(textDirection: Directionality.of(state.context)) {
    _scaleGestureRecognizer = ScaleGestureRecognizer()
      ..onStart = _handleScaleStart
      ..onUpdate = _handleScaleUpdate
      ..onEnd = _handleScaleEnd;

    _state._defaultController
      ..onZoomLevelChange = _handleZoomLevelChange
      ..onPanChange = _handlePanTo;

    _selectionColorAnimation = CurvedAnimation(
        parent: _state.selectionAnimationController, curve: Curves.easeInOut);
    _forwardSelectionColorTween = ColorTween();
    _forwardSelectionStrokeColorTween = ColorTween();
    _reverseSelectionColorTween = ColorTween();
    _reverseSelectionStrokeColorTween = ColorTween();

    _forwardToggledShapeColorTween = ColorTween();
    _forwardToggledShapeStrokeColorTween = ColorTween();
    _reverseToggledShapeColorTween = ColorTween();
    _reverseToggledShapeStrokeColorTween = ColorTween();

    _hoverColorAnimation = CurvedAnimation(
        parent: _state.hoverShapeAnimationController, curve: Curves.easeInOut);
    _forwardHoverColorTween = ColorTween();
    _forwardHoverStrokeColorTween = ColorTween();
    _reverseHoverColorTween = ColorTween();
    _reverseHoverStrokeColorTween = ColorTween();

    _toggleShapeAnimation = CurvedAnimation(
        parent: _state.toggleAnimationController, curve: Curves.easeInOut);

    if (_enableSelection) {
      _initializeSelectionTweenColors();
      if (_state.widget.initialSelectedIndex != -1) {
        _currentSelectedItem = _mapDataSource.values.firstWhere(
            (_MapModel model) =>
                model.dataIndex == _state.widget.initialSelectedIndex);
        _updateCurrentSelectedItemTween();
      }
    }

    if (_legendSettings.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }

    if (hasShapeHoverColor) {
      _initializeHoverTweenColors();
    }

    _state.widget.controller?._parentBox = this;
  }

  final _MapsShapeLayerState _state;
  final int _minPanDistance = 5;
  Size _size;
  double _actualFactor = 1.0;
  Size _actualShapeSize;
  Offset _downGlobalPoint;
  Offset _downLocalPoint;
  int _pointerCount = 0;
  bool _singleTapConfirmed = false;
  _MapModel _prevSelectedItem;
  _MapModel _currentSelectedItem;
  _MapModel _currentHoverItem;
  _MapModel _previousHoverItem;
  ScaleGestureRecognizer _scaleGestureRecognizer;
  Animation<double> _selectionColorAnimation;
  Animation<double> _toggleShapeAnimation;
  Timer _zoomingDelayTimer;
  Rect _refShapeBounds;
  Rect _refVisibleBounds;
  MapZoomDetails _zoomDetails;
  MapPanDetails _panDetails;

  Animation<double> _hoverColorAnimation;
  // Apply color animation for the selected shape. The
  // begin color will be shape color and the
  // end color will be selection color.
  ColorTween _forwardSelectionColorTween;
  // Apply stroke color animation for the selected shape. The
  // begin color will be shape stroke color and the
  // end color will be selection stroke color.
  ColorTween _forwardSelectionStrokeColorTween;
  // Apply color animation for the previously selected shape. The
  // begin color will be selection color and the
  // end color will be shape color.
  ColorTween _reverseSelectionColorTween;
  // Apply stroke color animation for the previously selected shape. The
  // begin color will be selection stroke color and the
  // end color will be shape stroke color.
  ColorTween _reverseSelectionStrokeColorTween;
  // Apply color animation for the hover shape. The
  // begin color will be shape color and the
  // end color will be hover color.
  ColorTween _forwardHoverColorTween;
  // Apply stroke color animation for the hover shape. The
  // begin color will be shape stroke color and the
  // end color will be hover stroke color.
  ColorTween _forwardHoverStrokeColorTween;
  // Apply color animation for the previously hover shape. The
  // begin color will be hover color and the
  // end color will be shape color.
  ColorTween _reverseHoverColorTween;
  // Apply stroke color animation for the previously hover shape. The
  // begin color will be hover stroke color and the
  // end color will be shape stroke color.
  ColorTween _reverseHoverStrokeColorTween;
  // Apply color animation for the toggled shape. The
  // begin color will be shape color and the
  // end color will be toggled shape color.
  ColorTween _forwardToggledShapeColorTween;
  // Apply stroke color animation for the toggled shape. The
  // begin color will be shape stroke color and the
  // end color will be toggled shape stroke color.
  ColorTween _forwardToggledShapeStrokeColorTween;
  // Apply color animation for the shape while un-toggling the toggled shape.
  // The begin color will be toggled shape color and the
  // end color will be shape color.
  ColorTween _reverseToggledShapeColorTween;
  // Apply stroke color animation for the shape while un-toggling the toggled
  // shape. The begin color will be toggled shape stroke color and the
  // end color will be shape stroke color.
  ColorTween _reverseToggledShapeStrokeColorTween;

  BuildContext context;

  _DefaultController defaultController;

  bool get canZoom =>
      _zoomPanBehavior != null &&
      (_zoomPanBehavior.enablePinching || _zoomPanBehavior.enablePanning);

  bool get isInteractive =>
      canZoom ||
      _enableBubbleTooltip ||
      _enableShapeTooltip ||
      _enableSelection ||
      (kIsWeb && (hasBubbleHoverColor || hasShapeHoverColor));

  bool get hasBubbleHoverColor =>
      _themeData.bubbleHoverColor != Colors.transparent ||
      (_themeData.bubbleHoverStrokeColor != Colors.transparent &&
          _themeData.bubbleHoverStrokeWidth > 0);

  bool get hasShapeHoverColor =>
      _themeData.shapeHoverColor != Colors.transparent ||
      (_themeData.shapeHoverStrokeColor != Colors.transparent &&
          _themeData.shapeHoverStrokeWidth > 0);

  Map<String, _MapModel> get mapDataSource => _mapDataSource;
  Map<String, _MapModel> _mapDataSource;
  set mapDataSource(Map<String, _MapModel> value) {
    if (const MapEquality<String, _MapModel>().equals(_mapDataSource, value)) {
      return;
    }

    _mapDataSource = value;
    _refresh();
    markNeedsPaint();
  }

  MapShapeLayerDelegate get mapDelegate => _mapDelegate;
  MapShapeLayerDelegate _mapDelegate;
  set mapDelegate(MapShapeLayerDelegate value) {
    if (_mapDelegate == value) {
      return;
    }

    if (_mapDelegate != null &&
        value != null &&
        _mapDelegate.shapeFile != value.shapeFile) {
      _mapDelegate = value;
      return;
    }

    _mapDelegate = value;
    _currentSelectedItem = null;
    _prevSelectedItem = null;
    _previousHoverItem = null;
    _refresh();
    markNeedsPaint();
    _state.dataLabelAnimationController.value = 0.0;
    _state.bubbleAnimationController.value = 0.0;
    SchedulerBinding.instance.addPostFrameCallback(_initiateInitialAnimations);
  }

  MapBubbleSettings get bubbleSettings => _bubbleSettings;
  MapBubbleSettings _bubbleSettings;
  set bubbleSettings(MapBubbleSettings value) {
    if (_bubbleSettings == value) {
      return;
    }
    if (_bubbleSettings.minRadius != value.minRadius ||
        _bubbleSettings.maxRadius != value.maxRadius) {
      _bubbleSettings = value;
      _mapDataSource.forEach((String key, _MapModel mapModel) {
        _updateBubbleRadiusAndPath(mapModel);
      });
    } else {
      _bubbleSettings = value;
    }
    markNeedsPaint();
  }

  MapLegendSettings get legendSettings => _legendSettings;
  MapLegendSettings _legendSettings;
  set legendSettings(MapLegendSettings value) {
    // Update [MapsShapeLayer.legendSettings] value only when
    // [MapsShapeLayer.legend] property is set to shape.
    if (_state.widget.legendSource != MapElement.shape ||
        _legendSettings == value) {
      return;
    }
    _legendSettings = value;
    if (_legendSettings.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }
    markNeedsPaint();
  }

  MapSelectionSettings get selectionSettings => _selectionSettings;
  MapSelectionSettings _selectionSettings;
  set selectionSettings(MapSelectionSettings value) {
    if (_selectionSettings == value) {
      return;
    }
    _selectionSettings = value;
  }

  MapZoomPanBehavior get zoomPanBehavior => _zoomPanBehavior;
  MapZoomPanBehavior _zoomPanBehavior;
  set zoomPanBehavior(MapZoomPanBehavior value) {
    if (_zoomPanBehavior == value) {
      return;
    }
    _zoomPanBehavior = value;
  }

  bool get enableShapeTooltip => _enableShapeTooltip;
  bool _enableShapeTooltip;
  set enableShapeTooltip(bool value) {
    if (_enableShapeTooltip == value) {
      return;
    }
    _enableShapeTooltip = value;
  }

  bool get enableBubbleTooltip => _enableBubbleTooltip;
  bool _enableBubbleTooltip;
  set enableBubbleTooltip(bool value) {
    if (_enableBubbleTooltip == value) {
      return;
    }
    _enableBubbleTooltip = value;
  }

  bool get enableSelection => _enableSelection;
  bool _enableSelection;
  set enableSelection(bool value) {
    if (_enableSelection == value) {
      return;
    }
    _enableSelection = value;
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;

    if (_enableSelection) {
      _initializeSelectionTweenColors();
    }
    if (_legendSettings.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }

    if (hasShapeHoverColor) {
      _initializeHoverTweenColors();
    }

    markNeedsPaint();
  }

  @override
  MouseCursor get cursor => defaultController.gesture == _Gesture.pan
      ? SystemMouseCursors.grabbing
      : SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  @override
  PointerHoverEventListener get onHover => _handleHover;

  @override
  PointerExitEventListener get onExit => _handleExit;

  void _initializeSelectionTweenColors() {
    final Color selectionColor =
        _themeData.selectionColor.withOpacity(_selectionSettings.opacity);
    _forwardSelectionColorTween.end = selectionColor;
    _forwardSelectionStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardSelectionStrokeColorTween.end = _themeData.selectionStrokeColor;

    _reverseSelectionColorTween.begin = selectionColor;
    _reverseSelectionStrokeColorTween.begin = _themeData.selectionStrokeColor;
    _reverseSelectionStrokeColorTween.end = _themeData.layerStrokeColor;
    _updateCurrentSelectedItemTween();
  }

  void _updateCurrentSelectedItemTween() {
    if (_currentSelectedItem != null &&
        !defaultController.wasToggled(_currentSelectedItem)) {
      _forwardSelectionColorTween.begin =
          getActualShapeColor(_currentSelectedItem);
    }

    if (_prevSelectedItem != null) {
      _reverseSelectionColorTween.end = getActualShapeColor(_prevSelectedItem);
    }
  }

  void _initializeHoverTweenColors() {
    final Color hoverStrokeColor = _getHoverStrokeColor();
    _forwardHoverStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardHoverStrokeColorTween.end = hoverStrokeColor;
    _reverseHoverStrokeColorTween.begin = hoverStrokeColor;
    _reverseHoverStrokeColorTween.end = _themeData.layerStrokeColor;
  }

  Color _getHoverStrokeColor() {
    final bool canAdjustHoverOpacity =
        double.parse(_themeData.layerStrokeColor.opacity.toStringAsFixed(2)) !=
            _hoverColorOpacity;
    return _themeData.shapeHoverStrokeColor != null &&
            _themeData.shapeHoverStrokeColor != Colors.transparent
        ? _themeData.shapeHoverStrokeColor
        : _themeData.layerStrokeColor.withOpacity(
            canAdjustHoverOpacity ? _hoverColorOpacity : _minHoverOpacity);
  }

  void _refresh([MapLatLng latlng]) {
    if (hasSize && _mapDataSource != null && _mapDataSource.isNotEmpty) {
      _computeActualFactor();
      defaultController.shapeLayerSizeFactor = _actualFactor;
      if (_zoomPanBehavior != null) {
        defaultController.shapeLayerSizeFactor *= _zoomPanBehavior.zoomLevel;
      }

      defaultController.shapeLayerOffset =
          _getTranslationPoint(defaultController.shapeLayerSizeFactor);
      defaultController.shapeLayerOrigin = Offset.zero;
      _adjustTranslationTo(latlng);
      defaultController.updateVisibleBounds();
      _updateMapDataSourceForVisual();
      markNeedsPaint();
    }
  }

  void _adjustTranslationTo(MapLatLng latlng) {
    latlng ??= _zoomPanBehavior?.focalLatLng;
    if (latlng != null) {
      final Offset focalPoint = _pixelFromLatLng(
        latlng.latitude,
        latlng.longitude,
        size,
        defaultController.shapeLayerOffset,
        defaultController.shapeLayerSizeFactor,
      );
      final Offset center =
          _getShapeBounds(defaultController.shapeLayerSizeFactor).center;
      defaultController.shapeLayerOffset +=
          center + defaultController.shapeLayerOffset - focalPoint;
    }
  }

  void _computeActualFactor() {
    final Offset minPoint = _pixelFromLatLng(
        _state.shapeFileData.bounds.minLatitude,
        _state.shapeFileData.bounds.minLongitude,
        _size);
    final Offset maxPoint = _pixelFromLatLng(
        _state.shapeFileData.bounds.maxLatitude,
        _state.shapeFileData.bounds.maxLongitude,
        _size);
    _actualShapeSize = Size(
        (maxPoint.dx - minPoint.dx).abs(), (maxPoint.dy - minPoint.dy).abs());
    _actualFactor = min(_size.height / _actualShapeSize.height,
        _size.width / _actualShapeSize.width);
  }

  Offset _getTranslationPoint(double factor, [Rect bounds]) {
    assert(factor != null);
    bounds ??= _getShapeBounds(factor);
    // 0.0 is default translation value.
    final double dx = _interpolateValue(
        0.0, _size.width - _actualShapeSize.width, -bounds.left);
    final double dy = _interpolateValue(
        0.0, _size.height - _actualShapeSize.height, -bounds.top);
    final Offset shift = Offset(_size.width - _actualShapeSize.width * factor,
        _size.height - _actualShapeSize.height * factor);
    return Offset(dx + shift.dx / 2, dy + shift.dy / 2);
  }

  Rect _getShapeBounds(double factor, [Offset translation = Offset.zero]) {
    final Offset minPoint = _pixelFromLatLng(
        _state.shapeFileData.bounds.minLatitude,
        _state.shapeFileData.bounds.minLongitude,
        _size,
        translation,
        factor);
    final Offset maxPoint = _pixelFromLatLng(
        _state.shapeFileData.bounds.maxLatitude,
        _state.shapeFileData.bounds.maxLongitude,
        _size,
        translation,
        factor);
    return Rect.fromPoints(minPoint, maxPoint);
  }

  void _updateMapDataSourceForVisual() {
    if (_mapDataSource != null) {
      Offset point;
      Path shapePath;
      dynamic coordinate;
      List<Offset> pixelPoints;
      List<dynamic> rawPoints;
      int rawPointsLength, pointsLength;
      _mapDataSource.forEach((String key, _MapModel mapModel) {
        double signedArea = 0.0, centerX = 0.0, centerY = 0.0;
        rawPointsLength = mapModel.rawPoints.length;
        mapModel.pixelPoints = List<List<Offset>>(rawPointsLength);
        shapePath = Path();
        for (int j = 0; j < rawPointsLength; j++) {
          rawPoints = mapModel.rawPoints[j];
          pointsLength = rawPoints.length;
          pixelPoints = mapModel.pixelPoints[j] = List<Offset>(pointsLength);
          for (int k = 0; k < pointsLength; k++) {
            coordinate = rawPoints[k];
            point = pixelPoints[k] = _pixelFromLatLng(
                coordinate[1],
                coordinate[0],
                _size,
                defaultController.shapeLayerOffset,
                defaultController.shapeLayerSizeFactor);
            if (k == 0) {
              shapePath.moveTo(point.dx, point.dy);
            } else {
              shapePath.lineTo(point.dx, point.dy);
              final int l = k - 1;
              if ((_state.widget.showDataLabels || _state.widget.showBubbles) &&
                  l + 1 < pixelPoints.length) {
                // Used mathematical formula to find
                // the center of polygon points.
                final double x0 = pixelPoints[l].dx, y0 = pixelPoints[l].dy;
                final double x1 = pixelPoints[l + 1].dx,
                    y1 = pixelPoints[l + 1].dy;
                signedArea += (x0 * y1) - (y0 * x1);
                centerX += (x0 + x1) * (x0 * y1 - x1 * y0);
                centerY += (y0 + y1) * (x0 * y1 - x1 * y0);
              }
            }
          }
          shapePath.close();
        }

        mapModel.shapePath = shapePath;
        _findPathCenterAndWidth(signedArea, centerX, centerY, mapModel);
        _updateBubbleRadiusAndPath(mapModel);
      });
    }
  }

  void _findPathCenterAndWidth(
      double signedArea, double centerX, double centerY, _MapModel mapModel) {
    if (_state.widget.showDataLabels || _state.widget.showBubbles) {
      // Used mathematical formula to find the center of polygon points.
      signedArea /= 2;
      centerX = centerX / (6 * signedArea);
      centerY = centerY / (6 * signedArea);
      mapModel.shapePathCenter = Offset(centerX, centerY);
      double minX, maxX;
      double distance,
          minDistance = double.infinity,
          maxDistance = double.negativeInfinity;

      final List<double> minDistances = <double>[double.infinity];
      final List<double> maxDistances = <double>[double.negativeInfinity];
      for (final List<Offset> points in mapModel.pixelPoints) {
        for (final Offset point in points) {
          distance = (centerY - point.dy).abs();
          if (point.dx < centerX) {
            // Collected all points which is less 10 pixels distance from
            // 'center y' to position the labels more smartly.
            if (minX != null && distance < 10) {
              minDistances.add(point.dx);
            }
            if (distance < minDistance) {
              minX = point.dx;
              minDistance = distance;
            }
          } else if (point.dx > centerX) {
            if (maxX != null && distance < 10) {
              maxDistances.add(point.dx);
            }

            if (distance > maxDistance) {
              maxX = point.dx;
              maxDistance = distance;
            }
          }
        }
      }

      mapModel.shapeWidth = max(maxX, maxDistances.reduce(max)) -
          min(minX, minDistances.reduce(min));
    }
  }

  void _updateBubbleRadiusAndPath(_MapModel mapModel) {
    final double bubbleSizeValue = mapModel.bubbleSizeValue;
    if (bubbleSizeValue != null) {
      if (bubbleSizeValue == _state.minBubbleValue) {
        mapModel.bubbleRadius = _bubbleSettings.minRadius;
      } else if (bubbleSizeValue == _state.maxBubbleValue) {
        mapModel.bubbleRadius = _bubbleSettings.maxRadius;
      } else {
        final double percentage = ((bubbleSizeValue - _state.minBubbleValue) /
                (_state.maxBubbleValue - _state.minBubbleValue)) *
            100;
        mapModel.bubbleRadius = bubbleSettings.minRadius +
            (bubbleSettings.maxRadius - bubbleSettings.minRadius) *
                (percentage / 100);
      }
    }

    if ((_enableBubbleTooltip || hasBubbleHoverColor) &&
        mapModel.bubbleRadius != null) {
      mapModel.bubblePath = Path()
        ..addOval(
          Rect.fromCircle(
            center: mapModel.shapePathCenter,
            radius: mapModel.bubbleRadius,
          ),
        );
    }
  }

  // Invoking animation for data label and bubble.
  void _initiateInitialAnimations(Duration timeStamp) {
    if (_state.mounted) {
      if (_state.widget.showBubbles) {
        _state.bubbleAnimationController.forward(from: 0);
      } else if (_state.widget.showDataLabels) {
        _state.dataLabelAnimationController.forward(from: 0);
      }
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (canZoom) {
      if (defaultController.gesture == _Gesture.scale) {
        _zoomEnd();
      }

      defaultController.isInInteractive = true;
      defaultController.gesture = null;
      _downGlobalPoint = details.focalPoint;
      _downLocalPoint = details.localFocalPoint;
      _refVisibleBounds = defaultController
          .getVisibleBounds(defaultController.shapeLayerOffset);
      _refShapeBounds = _getShapeBounds(defaultController.shapeLayerSizeFactor,
          defaultController.shapeLayerOffset);
      final MapLatLngBounds newVisibleBounds =
          defaultController.getVisibleLatLngBounds(
              _refVisibleBounds.topRight, _refVisibleBounds.bottomLeft);
      _zoomDetails = MapZoomDetails(
        newVisibleBounds: newVisibleBounds,
      );
      _panDetails = MapPanDetails(
        newVisibleBounds: newVisibleBounds,
      );
    }
  }

  // Scale and pan are handled in scale gesture.
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    defaultController.isInInteractive = true;
    defaultController.gesture ??=
        _getGestureType(details.scale, details.localFocalPoint);
    if (!canZoom || defaultController.gesture == null) {
      return;
    }

    switch (defaultController.gesture) {
      case _Gesture.scale:
        _singleTapConfirmed = false;
        if (_zoomPanBehavior.enablePinching &&
            defaultController.shapeLayerSizeFactor * details.scale >=
                _actualFactor) {
          _invokeOnZooming(details.scale, _downLocalPoint, _downGlobalPoint);
        }
        return;
      case _Gesture.pan:
        _singleTapConfirmed = false;
        if (_zoomPanBehavior.enablePanning) {
          final Offset delta =
              _getValidPanDelta(details.localFocalPoint - _downLocalPoint);
          final Rect visibleBounds = defaultController
              .getVisibleBounds(defaultController.shapeLayerOffset + delta);
          _panDetails = MapPanDetails(
            globalFocalPoint: details.focalPoint,
            localFocalPoint: details.localFocalPoint,
            zoomLevel: _zoomPanBehavior.zoomLevel,
            delta: delta,
            previousVisibleBounds: _panDetails != null
                ? _panDetails.newVisibleBounds
                : defaultController.visibleLatLngBounds,
            newVisibleBounds: defaultController.getVisibleLatLngBounds(
                visibleBounds.topRight,
                visibleBounds.bottomLeft,
                defaultController.shapeLayerOffset + delta),
          );
          if (_state.widget.onWillPan == null ||
              _state.widget.onWillPan(_panDetails)) {
            _zoomPanBehavior?.onPanning(_panDetails);
          }
        }
        return;
    }
  }

  void _invokeOnZooming(double scale,
      [Offset localFocalPoint, Offset globalFocalPoint]) {
    final double newZoomLevel = _getZoomLevel(scale);
    final double newShapeLayerSizeFactor = _getScale(newZoomLevel);
    final Offset newShapeLayerOffset =
        defaultController.getZoomingTranslation(origin: localFocalPoint);
    final Rect newVisibleBounds = defaultController.getVisibleBounds(
        newShapeLayerOffset, newShapeLayerSizeFactor);
    _zoomDetails = MapZoomDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: _zoomPanBehavior.zoomLevel,
      newZoomLevel: newZoomLevel,
      previousVisibleBounds: _zoomDetails != null
          ? _zoomDetails.newVisibleBounds
          : defaultController.visibleLatLngBounds,
      newVisibleBounds: defaultController.getVisibleLatLngBounds(
        newVisibleBounds.topRight,
        newVisibleBounds.bottomLeft,
        newShapeLayerOffset,
        newShapeLayerSizeFactor,
      ),
    );
    if (_state.widget.onWillZoom == null ||
        _state.widget.onWillZoom(_zoomDetails)) {
      _zoomPanBehavior?.onZooming(_zoomDetails);
    }
  }

  Offset _getValidPanDelta(Offset delta) {
    final Rect currentShapeBounds = _getShapeBounds(
        defaultController.shapeLayerSizeFactor,
        defaultController.shapeLayerOffset + delta);
    double dx = 0.0, dy = 0.0;
    if (_refVisibleBounds.width < _refShapeBounds.width) {
      dx = delta.dx;
      if (currentShapeBounds.left > _refVisibleBounds.left) {
        dx = _refVisibleBounds.left - _refShapeBounds.left;
      }

      if (currentShapeBounds.right < _refVisibleBounds.right) {
        dx = _refVisibleBounds.right - _refShapeBounds.right;
      }
    }

    if (_refVisibleBounds.height < _refShapeBounds.height) {
      dy = delta.dy;
      if (currentShapeBounds.top > _refVisibleBounds.top) {
        dy = _refVisibleBounds.top - _refShapeBounds.top;
      }

      if (currentShapeBounds.bottom < _refVisibleBounds.bottom) {
        dy = _refVisibleBounds.bottom - _refShapeBounds.bottom;
      }
    }

    return Offset(dx, dy);
  }

  _Gesture _getGestureType(double scale, Offset point) {
    if (scale == 1) {
      if (_downLocalPoint != null) {
        final Offset distance = point - _downLocalPoint;
        return distance.dx.abs() > _minPanDistance ||
                distance.dy.abs() > _minPanDistance
            ? _Gesture.pan
            : null;
      }
    }

    return _Gesture.scale;
  }

  Offset _getAdjTranslation(double zoomLevel) {
    double dx = 0.0, dy = 0.0;
    final Rect currentBounds = defaultController.currentBounds;
    if (currentBounds.left > paintBounds.left) {
      dx = paintBounds.left - currentBounds.left;
    }

    if (currentBounds.right < paintBounds.right) {
      dx = paintBounds.right - currentBounds.right;
    }

    if (currentBounds.top > paintBounds.top) {
      dy = paintBounds.top - currentBounds.top;
    }

    if (currentBounds.bottom < paintBounds.bottom) {
      dy = paintBounds.bottom - currentBounds.bottom;
    }

    return Offset(dx, dy);
  }

  void _validateEdges(double zoomLevel, [Offset origin]) {
    final Offset leftTop = defaultController.getZoomingTranslation(
        origin: origin,
        scale: _getScale(zoomLevel),
        previousOrigin: defaultController.shapeLayerOrigin);
    defaultController.currentBounds = Rect.fromLTWH(leftTop.dx, leftTop.dy,
        _size.width * zoomLevel, _size.height * zoomLevel);
    defaultController.adjustment = _getAdjTranslation(zoomLevel);
  }

  void _handleZooming(MapZoomDetails details) {
    if (defaultController.isInInteractive && details.localFocalPoint != null) {
      // Updating map while pinching and scrolling.
      defaultController.localScale = _getScale(details.newZoomLevel);
      defaultController.pinchCenter = details.localFocalPoint;
      defaultController.updateVisibleBounds(
          defaultController.getZoomingTranslation() +
              defaultController.adjustment,
          defaultController.shapeLayerSizeFactor *
              defaultController.localScale);
      _validateEdges(details.newZoomLevel);
    } else {
      // Updating map via toolbar.
      _downLocalPoint = null;
      _downGlobalPoint = null;
      _validateEdges(
          details.newZoomLevel, Offset(_size.width / 2, _size.height / 2));
      defaultController.shapeLayerOrigin =
          defaultController.getZoomingTranslation(
                  origin: Offset(_size.width / 2, _size.height / 2),
                  scale: _getScale(details.newZoomLevel),
                  previousOrigin: defaultController.shapeLayerOrigin) +
              defaultController.adjustment;
      defaultController.shapeLayerSizeFactor =
          _actualFactor * details.newZoomLevel;
      defaultController.shapeLayerOffset =
          _getTranslationPoint(defaultController.shapeLayerSizeFactor) +
              defaultController.adjustment;
      if (details.newZoomLevel != 1) {
        _adjustTranslationTo(defaultController.visibleFocalLatLng);
      }
      defaultController.updateVisibleBounds();
      _updateMapDataSourceForVisual();
    }
    _zoomPanBehavior.zoomLevel = details.newZoomLevel;
  }

  void _handlePanning(MapPanDetails details) {
    if (_currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
    }
    defaultController.panDistance = details.delta;
    defaultController.updateVisibleBounds(
        defaultController.shapeLayerOffset + details.delta);
    markNeedsPaint();
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (defaultController.gesture == null) {
      return;
    }

    switch (defaultController.gesture) {
      case _Gesture.scale:
        _zoomEnd();
        break;
      case _Gesture.pan:
        _panEnd();
        break;
    }

    defaultController.gesture = null;
  }

  void _zoomEnd() {
    defaultController.isInInteractive = false;
    _zoomingDelayTimer?.cancel();
    _zoomingDelayTimer = null;
    _zoomDetails = null;
    _panDetails = null;
    if (_zoomPanBehavior != null && _zoomPanBehavior.enablePinching) {
      defaultController.shapeLayerOffset =
          defaultController.getZoomingTranslation() +
              defaultController.adjustment;
      defaultController.shapeLayerOrigin =
          defaultController.getZoomingTranslation(
                  previousOrigin: defaultController.shapeLayerOrigin) +
              defaultController.adjustment;
      defaultController.shapeLayerSizeFactor *= defaultController.localScale;
      _updateMapDataSourceForVisual();
      _invalidateChildren();
      markNeedsPaint();
    }

    _downLocalPoint = null;
    _downGlobalPoint = null;
    defaultController.gesture = null;
    defaultController.adjustment = Offset.zero;
    defaultController.localScale = 1.0;
  }

  void _panEnd() {
    defaultController.isInInteractive = false;
    _zoomDetails = null;
    _panDetails = null;
    if (_zoomPanBehavior.enablePanning) {
      defaultController.shapeLayerOffset += defaultController.panDistance;
      defaultController.shapeLayerOrigin += defaultController.panDistance;
      _updateMapDataSourceForVisual();
      _invalidateChildren();
      markNeedsPaint();
    }

    _downLocalPoint = null;
    _downGlobalPoint = null;
    defaultController.gesture = null;
    defaultController.panDistance = Offset.zero;
  }

  void _invalidateChildren() {
    RenderBox child = firstChild;
    while (child != null) {
      if (child is _ShapeLayerChildRenderBoxBase) {
        child.refresh();
      }

      final StackParentData childParentData = child.parentData;
      child = childParentData.nextSibling;
    }
  }

  /// Handling zooming using mouse wheel scrolling.
  void _handleScrollEvent(PointerScrollEvent event) {
    if (_zoomPanBehavior != null && _zoomPanBehavior.enablePinching) {
      defaultController.isInInteractive = true;
      defaultController.gesture ??= _Gesture.scale;
      if (defaultController.gesture != _Gesture.scale) {
        return;
      }

      if (_currentHoverItem != null) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = null;
      }
      _downGlobalPoint ??= event.position;
      _downLocalPoint ??= event.localPosition;
      double scale = defaultController.localScale - (event.scrollDelta.dy / 60);
      if (defaultController.shapeLayerSizeFactor * scale < _actualFactor) {
        scale = _actualFactor / defaultController.shapeLayerSizeFactor;
      }

      _invokeOnZooming(scale, _downLocalPoint, _downGlobalPoint);
      // When the user didn't scrolled or scaled for certain time period,
      // we will refresh the map to the corresponding zoom level.
      _zoomingDelayTimer?.cancel();
      _zoomingDelayTimer = Timer(const Duration(milliseconds: 250), () {
        _zoomEnd();
      });
    }
  }

  void _handleZoomLevelChange(double zoomLevel, {MapLatLng latlng}) {
    if (defaultController.isInInteractive) {
      markNeedsPaint();
    } else {
      if (latlng != null) {
        defaultController.visibleFocalLatLng = latlng;
      }
      _invokeOnZooming(_getScale(zoomLevel));
    }
  }

  void _handlePanTo(MapLatLng latlng) {
    defaultController.visibleFocalLatLng = latlng;
    _refresh(latlng);
    if (defaultController.gesture == null) {
      _invalidateChildren();
    }
  }

  void _handleReset() {
    defaultController.shapeLayerSizeFactor = _actualFactor;
    defaultController.shapeLayerOffset =
        _getTranslationPoint(defaultController.shapeLayerSizeFactor);
    _updateMapDataSourceForVisual();
    markNeedsPaint();
  }

  void _handleExit(PointerExitEvent event) {
    if (_state.widget.showBubbles && hasBubbleHoverColor) {
      RenderBox child = lastChild;
      while (child != null) {
        final StackParentData childParentData = child.parentData;
        if (child is _RenderMapBubble) {
          child.onExit();
        }

        child = childParentData.previousSibling;
      }
    }

    if (hasShapeHoverColor && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      markNeedsPaint();
    }
  }

  double _getZoomLevel(double scale) {
    return _interpolateValue(
      defaultController.shapeLayerSizeFactor * scale / _actualFactor,
      _zoomPanBehavior.minZoomLevel,
      _zoomPanBehavior.maxZoomLevel,
    );
  }

  double _getScale(double zoomLevel) {
    return _actualFactor * zoomLevel / defaultController.shapeLayerSizeFactor;
  }

  void _handleTapUp(Offset localPosition) {
    _handleTapUpAndHover(localPosition);
    if (_currentSelectedItem != null) {
      _currentHoverItem = null;
    }
  }

  void _handleHover(PointerHoverEvent event) {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPosition = renderBox.globalToLocal(event.position);
    _handleTapUpAndHover(localPosition, isHover: true);
  }

  void _handleTapUpAndHover(Offset position, {bool isHover = false}) {
    if (_mapDataSource == null || _mapDataSource.isEmpty) {
      return;
    }

    double bubbleRadius;
    _MapModel model;
    _Layer layer;
    for (final _MapModel mapModel in _mapDataSource.values) {
      final bool wasToggled = defaultController.wasToggled(mapModel);
      if (_isBubbleContains(position, mapModel)) {
        layer = _Layer.bubble;
        if (!wasToggled &&
            (bubbleRadius == null || mapModel.bubbleRadius < bubbleRadius)) {
          bubbleRadius = mapModel.bubbleRadius;
          model = mapModel;
        }
      } else if (_isShapeContains(position, mapModel, layer) &&
          !(wasToggled && _state.widget.legendSource == MapElement.shape)) {
        model = mapModel;
        layer = _Layer.shape;
        if (!(_enableBubbleTooltip || hasBubbleHoverColor)) {
          break;
        }
      }
    }

    if (isHover) {
      _prevSelectedItem = null;
      _performChildHover(position, model, layer);
    } else {
      _setCurrentSelectedItem(model);
      _performChildTap(model, position, layer);
    }
  }

  bool _isBubbleContains(Offset position, _MapModel mapModel) {
    return (_enableBubbleTooltip || hasBubbleHoverColor) &&
        mapModel.bubblePath != null &&
        mapModel.bubblePath.contains(position);
  }

  bool _isShapeContains(
      Offset position, _MapModel mapModel, _Layer interactPath) {
    return (_enableSelection || _enableShapeTooltip || hasShapeHoverColor) &&
        interactPath != _Layer.bubble &&
        mapModel.shapePath.contains(position);
  }

  void _setCurrentSelectedItem(_MapModel mapModel) {
    if (_enableSelection && mapModel != null && mapModel.dataIndex != null) {
      // Update the previously selected shape details to the
      // [_prevSelectedItem] field, before updating the current selected
      // shape details into the [_currentSelectedItem] field.
      _prevSelectedItem = _currentSelectedItem;
      if (_state.widget.controller != null) {
        _state.widget.controller.selectedIndex =
            _state.widget.controller.selectedIndex == mapModel.dataIndex
                ? -1
                : mapModel.dataIndex;
      } else {
        _currentSelectedItem = mapModel;
        _updateSelectedItemModel();
      }

      _updateCurrentSelectedItemTween();
      _state.selectionAnimationController.forward(from: 0);
    }
  }

  void _updateSelectedItemModel() {
    _currentSelectedItem.isSelected = !_currentSelectedItem.isSelected;
    if (_prevSelectedItem != null &&
        _currentSelectedItem.dataIndex != _prevSelectedItem.dataIndex) {
      _prevSelectedItem.isSelected = false;
    }

    if (_prevSelectedItem != null &&
        _currentSelectedItem.dataIndex == _prevSelectedItem.dataIndex) {
      _currentSelectedItem = null;
    }
    SchedulerBinding.instance.addPostFrameCallback(_handleSelectionChanged);
    markNeedsPaint();
  }

  void _handleSelectionChanged(Duration time) {
    if (_state.widget.onSelectionChanged != null) {
      _state.widget.onSelectionChanged(
          _currentSelectedItem != null ? _currentSelectedItem.dataIndex : -1);
    }
  }

  void _performChildTap(_MapModel model, Offset position, _Layer interactPath) {
    if ((_enableShapeTooltip || _enableBubbleTooltip) && model != null) {
      RenderBox child = firstChild;
      while (child != null) {
        final StackParentData childParentData = child.parentData;
        if (child is _RenderMapTooltip) {
          child.onTap(position, model: model, layer: interactPath);
          break;
        }
        child = childParentData.nextSibling;
      }
    }
  }

  void _performChildHover(Offset position, _MapModel model, _Layer layer) {
    RenderBox child = firstChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      if (child is _RenderMapTooltip) {
        child.onHover(position, model: model, layer: layer);
      } else if (hasBubbleHoverColor) {
        if (child is _RenderMapBubble) {
          child.onHover(position, model: model, layer: layer);
        }
      }
      child = childParentData.nextSibling;
    }

    if (hasShapeHoverColor &&
        (_currentSelectedItem == null || _currentSelectedItem != model)) {
      if (layer == _Layer.shape && _currentHoverItem != model) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = model;
        _updateHoverItemTween();
      } else if ((_currentHoverItem != null && _currentHoverItem != model) ||
          (layer == _Layer.bubble && _currentHoverItem == model)) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = null;
        _updateHoverItemTween();
      }
    }
  }

  void _updateHoverItemTween() {
    if (_currentHoverItem != null) {
      _forwardHoverColorTween.begin = getActualShapeColor(_currentHoverItem);
      _forwardHoverColorTween.end = _getHoverFillColor(_currentHoverItem);
    }

    if (_previousHoverItem != null) {
      _reverseHoverColorTween.begin = _getHoverFillColor(_previousHoverItem);
      _reverseHoverColorTween.end = getActualShapeColor(_previousHoverItem);
    }

    _state.hoverShapeAnimationController.forward(from: 0);
  }

  Color _getHoverFillColor(_MapModel model) {
    final bool canAdjustHoverOpacity =
        double.parse(getActualShapeColor(model).opacity.toStringAsFixed(2)) !=
            _hoverColorOpacity;
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor
        : getActualShapeColor(model).withOpacity(
            canAdjustHoverOpacity ? _hoverColorOpacity : _minHoverOpacity);
  }

  void _handleShapeLayerControllerState() {
    if (_enableSelection) {
      final int selectedIndex = _state.widget.controller.selectedIndex;
      assert(selectedIndex < _mapDelegate.dataCount);
      _prevSelectedItem = _currentSelectedItem;
      _updateCurrentSelectedItemTween();
      _state.selectionAnimationController.forward(from: 0);
      if (selectedIndex == -1) {
        if (_prevSelectedItem != null) {
          _prevSelectedItem.isSelected = false;
        }

        if (_currentSelectedItem != null) {
          _currentSelectedItem = null;
        }

        SchedulerBinding.instance.addPostFrameCallback(_handleSelectionChanged);
        markNeedsPaint();
        return;
      }
      _currentSelectedItem = _mapDataSource.values.firstWhere(
          (_MapModel element) => element.dataIndex == selectedIndex);
      _updateSelectedItemModel();
    }
  }

  void _initializeToggledShapeTweenColors() {
    final Color toggledShapeColor =
        _themeData.toggledItemColor != Colors.transparent
            ? _themeData.toggledItemColor
                .withOpacity(_legendSettings.toggledItemOpacity)
            : null;

    _forwardToggledShapeColorTween.end = toggledShapeColor;
    _forwardToggledShapeStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardToggledShapeStrokeColorTween.end =
        _themeData.toggledItemStrokeColor != Colors.transparent
            ? _themeData.toggledItemStrokeColor
            : null;

    _reverseToggledShapeColorTween.begin = toggledShapeColor;
    _reverseToggledShapeStrokeColorTween.begin =
        _themeData.toggledItemStrokeColor != Colors.transparent
            ? _themeData.toggledItemStrokeColor
            : null;
    _reverseToggledShapeStrokeColorTween.end = _themeData.layerStrokeColor;
  }

  void _handleToggleChange() {
    _previousHoverItem = null;
    if (_state.widget.legendSource == MapElement.shape) {
      _MapModel model;
      if (_state.widget.delegate.shapeColorMappers == null) {
        model = mapDataSource.values
            .elementAt(defaultController.currentToggledItemIndex);
      } else {
        for (final mapModel in _mapDataSource.values) {
          if (mapModel.dataIndex != null &&
              mapModel.legendMapperIndex ==
                  defaultController.currentToggledItemIndex) {
            model = mapModel;
            break;
          }
        }
      }

      final Color shapeColor = (_enableSelection &&
              _currentSelectedItem != null &&
              _currentSelectedItem.actualIndex == model.actualIndex)
          ? _themeData.selectionColor.withOpacity(_selectionSettings.opacity)
          : getActualShapeColor(model);
      _forwardToggledShapeColorTween.begin = shapeColor;
      _reverseToggledShapeColorTween.end = shapeColor;
      _state.toggleAnimationController.forward(from: 0);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _state.widget.controller?.addListener(_handleShapeLayerControllerState);
    _state.selectionAnimationController?.addListener(markNeedsPaint);
    _state.toggleAnimationController?.addListener(markNeedsPaint);
    _state.hoverShapeAnimationController?.addListener(markNeedsPaint);
    if (defaultController != null) {
      defaultController.addToggleListener(_handleToggleChange);
      defaultController.addZoomingListener(_handleZooming);
      defaultController.addPanningListener(_handlePanning);
      defaultController.addResetListener(_handleReset);
    }
    SchedulerBinding.instance.addPostFrameCallback(_initiateInitialAnimations);
  }

  @override
  void detach() {
    _state.dataLabelAnimationController.value = 0.0;
    _state.bubbleAnimationController.value = 0.0;
    _state.widget.controller?.removeListener(_handleShapeLayerControllerState);
    _state.selectionAnimationController?.removeListener(markNeedsPaint);
    _state.toggleAnimationController?.removeListener(markNeedsPaint);
    _state.hoverShapeAnimationController?.removeListener(markNeedsPaint);
    if (defaultController != null) {
      defaultController.removeToggleListener(_handleToggleChange);
      defaultController.removeZoomingListener(_handleZooming);
      defaultController.removePanningListener(_handlePanning);
      defaultController.removeResetListener(_handleReset);
    }
    _zoomingDelayTimer?.cancel();
    super.detach();
  }

  @override
  bool hitTestSelf(Offset position) => isInteractive;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    _zoomPanBehavior?.handleEvent(event, entry);
    if (isInteractive && event.down && event is PointerDownEvent) {
      _pointerCount++;
      _scaleGestureRecognizer.addPointer(event);
      _singleTapConfirmed = _pointerCount == 1;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      if (_singleTapConfirmed) {
        _handleTapUp(event.localPosition);
        _downLocalPoint = null;
        _downGlobalPoint = null;
      }

      _pointerCount = 0;
    } else if (event is PointerScrollEvent) {
      _handleScrollEvent(event);
    }
  }

  @override
  void performLayout() {
    _size = _getBoxSize(constraints);
    defaultController.shapeLayerBoxSize = _size;
    if (!hasSize || size != _size) {
      size = _size;
      _refresh(defaultController.visibleFocalLatLng);
    }

    final BoxConstraints looseConstraints = BoxConstraints.loose(_size);
    RenderBox child = firstChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      child.layout(looseConstraints, parentUsesSize: true);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_mapDataSource != null && _mapDataSource.isNotEmpty) {
      context.canvas
        ..save()
        ..clipRect(offset & _size);
      defaultController.applyTransform(context, offset);
      final bool hasToggledIndices =
          defaultController.toggledIndices.isNotEmpty;
      final Paint fillPaint = Paint()..isAntiAlias = true;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      final bool hasPrevSelectedItem = _prevSelectedItem != null &&
          !defaultController.wasToggled(_prevSelectedItem);

      _mapDataSource.forEach((String key, _MapModel model) {
        if (_currentHoverItem != null &&
            _currentHoverItem.primaryKey == model.primaryKey) {
          return;
        }

        if (hasPrevSelectedItem && _prevSelectedItem.primaryKey == key) {
          fillPaint.color =
              _reverseSelectionColorTween.evaluate(_selectionColorAnimation);
          strokePaint
            ..color = _reverseSelectionStrokeColorTween
                .evaluate(_selectionColorAnimation)
            ..strokeWidth = _themeData.selectionStrokeWidth;
        } else if (_previousHoverItem != null &&
            _previousHoverItem.primaryKey == key &&
            !defaultController.wasToggled(_previousHoverItem) &&
            _previousHoverItem != _currentHoverItem) {
          fillPaint.color = _themeData.shapeHoverColor != Colors.transparent
              ? _reverseHoverColorTween.evaluate(_hoverColorAnimation)
              : getActualShapeColor(model);

          if (_themeData.shapeHoverStrokeWidth > 0.0 &&
              _themeData.shapeHoverStrokeColor != Colors.transparent) {
            strokePaint
              ..color =
                  _reverseHoverStrokeColorTween.evaluate(_hoverColorAnimation)
              ..strokeWidth = _themeData.layerStrokeWidth;
          } else {
            strokePaint
              ..color = _themeData.layerStrokeColor
              ..strokeWidth = _themeData.layerStrokeWidth;
          }
        } else {
          _updateFillColor(model, fillPaint, hasToggledIndices);
          _updateStrokePaint(model, strokePaint, hasToggledIndices);
        }

        context.canvas.drawPath(model.shapePath, fillPaint);
        if (strokePaint.strokeWidth > 0.0 &&
            strokePaint.color != Colors.transparent) {
          strokePaint.strokeWidth =
              _getIntrinsicStrokeWidth(strokePaint.strokeWidth);
          context.canvas.drawPath(model.shapePath, strokePaint);
        }
      });

      _drawHoverShape(context, fillPaint, strokePaint);
      _drawSelectedShape(context, fillPaint, strokePaint);
      context.canvas.restore();
      super.paint(context, offset);
    }
  }

  // Returns the color to the shape based on the [shapeColorMappers],
  // [palette], and [layerColor] properties.
  Color getActualShapeColor(_MapModel model) {
    return model.shapeColor ??
        (_state.paletteLength > 0
            ? _state.widget.palette[model.actualIndex % _state.paletteLength]
            : _themeData.layerColor);
  }

  double _getIntrinsicStrokeWidth(double strokeWidth) {
    return strokeWidth /= defaultController.gesture == _Gesture.scale
        ? defaultController.localScale
        : 1;
  }

  // Set the color to the toggled and un-toggled shapes based on
  // the [legendController.toggledIndices] collection.
  void _updateFillColor(
      _MapModel model, Paint fillPaint, bool hasToggledIndices) {
    fillPaint.style = PaintingStyle.fill;
    if (_state.widget.legendSource == MapElement.shape) {
      if (defaultController.currentToggledItemIndex ==
          model.legendMapperIndex) {
        final Color shapeColor = defaultController.wasToggled(model)
            ? _forwardToggledShapeColorTween.evaluate(_toggleShapeAnimation)
            : _reverseToggledShapeColorTween.evaluate(_toggleShapeAnimation);
        // Set tween color to the shape based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledShapeColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledShapeColorTween] return.
        fillPaint.color = shapeColor ?? Colors.transparent;
        return;
      } else if (hasToggledIndices && defaultController.wasToggled(model)) {
        // Set toggled color to the previously toggled shapes.
        fillPaint.color =
            _forwardToggledShapeColorTween.end ?? Colors.transparent;
        return;
      }
    }

    fillPaint.color = getActualShapeColor(model);
  }

  // Set the stroke paint to the toggled and un-toggled shapes based on
  // the [legendController.toggledIndices] collection.
  void _updateStrokePaint(
      _MapModel model, Paint strokePaint, bool hasToggledIndices) {
    if (_state.widget.legendSource == MapElement.shape) {
      if (defaultController.currentToggledItemIndex ==
          model.legendMapperIndex) {
        final Color shapeStrokeColor = defaultController.wasToggled(model)
            ? _forwardToggledShapeStrokeColorTween
                .evaluate(_toggleShapeAnimation)
            : _reverseToggledShapeStrokeColorTween
                .evaluate(_toggleShapeAnimation);
        // Set tween color to the shape stroke based on the currently
        // tapped legend item. If the legend item is toggled, then the
        // [_forwardToggledShapeStrokeColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledShapeStrokeColorTween] return.
        strokePaint
          ..color = shapeStrokeColor ?? Colors.transparent
          ..strokeWidth = defaultController.wasToggled(model)
              ? _legendSettings.toggledItemStrokeWidth
              : _themeData.layerStrokeWidth;
        return;
      } else if (hasToggledIndices && defaultController.wasToggled(model)) {
        // Set toggled stroke color to the previously toggled shapes.
        strokePaint
          ..color =
              _forwardToggledShapeStrokeColorTween.end ?? Colors.transparent
          ..strokeWidth = _legendSettings.toggledItemStrokeWidth;
        return;
      }
    }

    strokePaint
      ..color = _themeData.layerStrokeColor
      ..strokeWidth = _themeData.layerStrokeWidth;
  }

  void _drawSelectedShape(
      PaintingContext context, Paint fillPaint, Paint strokePaint) {
    if (_currentSelectedItem != null &&
        !defaultController.wasToggled(_currentSelectedItem)) {
      fillPaint.color =
          _forwardSelectionColorTween.evaluate(_selectionColorAnimation);
      context.canvas.drawPath(_currentSelectedItem.shapePath, fillPaint);
      if (_themeData.selectionStrokeWidth > 0.0) {
        strokePaint
          ..color = _forwardSelectionStrokeColorTween
              .evaluate(_selectionColorAnimation)
          ..strokeWidth =
              _getIntrinsicStrokeWidth(_themeData.selectionStrokeWidth);
        context.canvas.drawPath(_currentSelectedItem.shapePath, strokePaint);
      }
    }
  }

  void _drawHoverShape(
      PaintingContext context, Paint fillPaint, Paint strokePaint) {
    if (_currentHoverItem != null) {
      fillPaint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColorTween.evaluate(_hoverColorAnimation)
          : getActualShapeColor(_currentHoverItem);
      context.canvas.drawPath(_currentHoverItem.shapePath, fillPaint);
      if (_themeData.shapeHoverStrokeWidth > 0.0 &&
          _themeData.shapeHoverStrokeColor != Colors.transparent) {
        strokePaint
          ..color = _forwardHoverStrokeColorTween.evaluate(_hoverColorAnimation)
          ..strokeWidth =
              _getIntrinsicStrokeWidth(_themeData.shapeHoverStrokeWidth);
      } else {
        strokePaint
          ..color = _themeData.layerStrokeColor
          ..strokeWidth = _getIntrinsicStrokeWidth(_themeData.layerStrokeWidth);
      }

      if (strokePaint.strokeWidth > 0.0 &&
          strokePaint.color != Colors.transparent) {
        context.canvas.drawPath(_currentHoverItem.shapePath, strokePaint);
      }
    }
  }
}
