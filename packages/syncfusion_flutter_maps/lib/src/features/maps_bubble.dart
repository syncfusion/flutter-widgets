part of maps;

/// A Render object widget which draws bubble shape.
class _MapBubble extends LeafRenderObjectWidget {
  const _MapBubble({
    this.delegate,
    this.mapDataSource,
    this.bubbleSettings,
    this.legendSettings,
    this.themeData,
    this.defaultController,
    this.state,
  });

  final MapShapeLayerDelegate delegate;
  final Map<String, _MapModel> mapDataSource;
  final MapBubbleSettings bubbleSettings;
  final MapLegendSettings legendSettings;
  final SfMapsThemeData themeData;
  final _DefaultController defaultController;
  final _MapsShapeLayerState state;

  @override
  _RenderMapBubble createRenderObject(BuildContext context) {
    return _RenderMapBubble(
        delegate: delegate,
        mapDataSource: mapDataSource,
        bubbleSettings: bubbleSettings,
        legendSettings: legendSettings,
        themeData: themeData,
        defaultController: defaultController,
        state: state);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMapBubble renderObject) {
    renderObject
      ..delegate = delegate
      ..mapDataSource = mapDataSource
      ..bubbleSettings = bubbleSettings
      ..legendSettings = legendSettings
      ..defaultController = defaultController
      ..themeData = themeData;
  }
}

class _RenderMapBubble extends _ShapeLayerChildRenderBoxBase {
  _RenderMapBubble({
    MapShapeLayerDelegate delegate,
    Map<String, _MapModel> mapDataSource,
    MapBubbleSettings bubbleSettings,
    MapLegendSettings legendSettings,
    SfMapsThemeData themeData,
    _DefaultController defaultController,
    _MapsShapeLayerState state,
  })  : mapDataSource = mapDataSource,
        _delegate = delegate,
        _bubbleSettings = bubbleSettings,
        _legendSettings = legendSettings,
        _themeData = themeData,
        defaultController = defaultController,
        _state = state {
    _bubbleAnimation = CurvedAnimation(
      parent: _state.bubbleAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );
    _toggleBubbleAnimation = CurvedAnimation(
        parent: _state.toggleAnimationController, curve: Curves.easeInOut);

    _forwardToggledBubbleColorTween = ColorTween();
    _forwardToggledBubbleStrokeColorTween = ColorTween();
    _reverseToggledBubbleColorTween = ColorTween();
    _reverseToggledBubbleStrokeColorTween = ColorTween();

    _toggleBubbleAnimation = CurvedAnimation(
        parent: _state.toggleAnimationController, curve: Curves.easeInOut);

    _forwardBubbleHoverColorTween = ColorTween();
    _forwardBubbleHoverStrokeColorTween = ColorTween();
    _reverseBubbleHoverColorTween = ColorTween();
    _reverseBubbleHoverStrokeColorTween = ColorTween();

    _hoverBubbleAnimation = CurvedAnimation(
        parent: _state.hoverBubbleAnimationController, curve: Curves.easeInOut);

    if (_legendSettings.enableToggleInteraction) {
      _initializeToggledBubbleTweenColors();
    }

    if (_themeData.bubbleHoverColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeWidth > 0.0) {
      _initializeHoverBubbleTweenColors();
    }
  }

  final _MapsShapeLayerState _state;
  Map<String, _MapModel> mapDataSource;
  Animation<double> _bubbleAnimation;
  Animation<double> _toggleBubbleAnimation;
  Animation<double> _hoverBubbleAnimation;
  _MapModel _currentHoverItem;
  _MapModel _previousHoverItem;

  // Apply color animation for the toggled bubble. The
  // begin color will be bubble color and the
  // end color will be toggled color.
  ColorTween _forwardToggledBubbleColorTween;
  // Apply stroke color animation for the toggled bubble. The
  // begin color will be bubble stroke color and the
  // end color will be toggled bubble stroke color.
  ColorTween _forwardToggledBubbleStrokeColorTween;
  // Apply color animation for the bubble while un-toggling the toggled bubble.
  // The begin color will be toggled bubble color and the
  // end color will be bubble color.
  ColorTween _reverseToggledBubbleColorTween;
  // Apply stroke color animation for the bubble while un-toggling the toggled
  // bubble. The begin color will be toggled bubble stroke color and the
  // end color will be bubble stroke color.
  ColorTween _reverseToggledBubbleStrokeColorTween;
  // Apply color animation for the hover bubble. The
  // begin color will be bubble color and the
  // end color will be hover color.
  ColorTween _forwardBubbleHoverColorTween;
  // Apply stroke color animation for the hover bubble. The
  // begin color will be bubble stroke color and the
  // end color will be hover bubble stroke color.
  ColorTween _forwardBubbleHoverStrokeColorTween;
  // Apply color animation for the bubble while exist the hovered bubble.
  // The begin color will be hover bubble color and the
  // end color will be bubble color.
  ColorTween _reverseBubbleHoverColorTween;
  // Apply stroke color animation for the bubble while exist the hovered bubble.
  // bubble. The begin color will be hover bubble stroke color and the
  // end color will be bubble stroke color.
  ColorTween _reverseBubbleHoverStrokeColorTween;

  _DefaultController defaultController;

  MapShapeLayerDelegate get delegate => _delegate;
  MapShapeLayerDelegate _delegate;
  set delegate(MapShapeLayerDelegate value) {
    if (_delegate == value) {
      return;
    }
    _delegate = value;
    _previousHoverItem = null;
    markNeedsPaint();
  }

  MapBubbleSettings get bubbleSettings => _bubbleSettings;
  MapBubbleSettings _bubbleSettings;
  set bubbleSettings(MapBubbleSettings value) {
    if (_bubbleSettings == value) {
      return;
    }
    _bubbleSettings = value;
    _previousHoverItem = null;
    markNeedsPaint();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    if (_legendSettings.enableToggleInteraction) {
      _initializeToggledBubbleTweenColors();
    }

    if (_themeData.bubbleHoverColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeWidth > 0.0) {
      _initializeHoverBubbleTweenColors();
    }

    markNeedsPaint();
  }

  MapLegendSettings get legendSettings => _legendSettings;
  MapLegendSettings _legendSettings;
  set legendSettings(MapLegendSettings value) {
    // Update [MapsShapeLayer.legendSettings] value only when
    // [MapsShapeLayer.legend] property is set to bubble.
    if (_state.widget.legendSource != MapElement.bubble ||
        _legendSettings == value) {
      return;
    }
    _legendSettings = value;
    if (_legendSettings.enableToggleInteraction) {
      _initializeToggledBubbleTweenColors();
    }

    markNeedsPaint();
  }

  bool get hasDefaultStroke =>
      _bubbleSettings.strokeWidth > 0 &&
      _bubbleSettings.strokeColor != null &&
      _bubbleSettings.strokeColor != Colors.transparent;

  bool get hasHoverStroke =>
      _themeData.bubbleHoverStrokeWidth > 0 &&
      _themeData.bubbleHoverStrokeColor != Colors.transparent;

  bool get hasToggledStroke =>
      _legendSettings.toggledItemStrokeWidth > 0 &&
      _legendSettings.toggledItemStrokeColor != null &&
      _legendSettings.toggledItemStrokeColor != Colors.transparent;

  void _handleZooming(MapZoomDetails details) {
    if (_currentHoverItem != null) {
      onExit();
    }
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    if (_currentHoverItem != null) {
      onExit();
    }
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void refresh() {
    markNeedsPaint();
  }

  @override
  void onHover(Offset hoverPosition, {_MapModel model, _Layer layer}) {
    if (layer == _Layer.bubble && _currentHoverItem != model) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = model;
      _updateHoverItemTween();
    } else if ((_currentHoverItem != null && _currentHoverItem != model) ||
        (layer == _Layer.shape && _currentHoverItem == model)) {
      onExit();
    }
  }

  @override
  void onExit() {
    _previousHoverItem = _currentHoverItem;
    _currentHoverItem = null;
    _updateHoverItemTween();
  }

  void _updateHoverItemTween() {
    final double opacity = _bubbleAnimation.value * _bubbleSettings.opacity;
    final Color defaultColor = bubbleSettings.color.withOpacity(opacity);
    if (_currentHoverItem != null) {
      _forwardBubbleHoverColorTween.begin =
          _currentHoverItem.bubbleColor ?? defaultColor;
      _forwardBubbleHoverColorTween.end =
          _getHoverFillColor(opacity, defaultColor, _currentHoverItem);
    }

    if (_previousHoverItem != null) {
      _reverseBubbleHoverColorTween.begin =
          _getHoverFillColor(opacity, defaultColor, _previousHoverItem);
      _reverseBubbleHoverColorTween.end =
          _previousHoverItem.bubbleColor ?? defaultColor;
    }

    _state.hoverBubbleAnimationController.forward(from: 0.0);
  }

  Color _getHoverFillColor(
      double opacity, Color defaultColor, _MapModel model) {
    final Color bubbleColor = model.bubbleColor ?? defaultColor;
    final bool canAdjustHoverOpacity = (model.bubbleColor != null &&
            double.parse(model.bubbleColor.opacity.toStringAsFixed(2)) !=
                _hoverColorOpacity) ||
        _bubbleSettings.opacity != _hoverColorOpacity;
    return _themeData.bubbleHoverColor != null &&
            _themeData.bubbleHoverColor != Colors.transparent
        ? _themeData.bubbleHoverColor
        : bubbleColor.withOpacity(
            canAdjustHoverOpacity ? _hoverColorOpacity : _minHoverOpacity);
  }

  @override
  void performLayout() {
    size = _getBoxSize(constraints);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _bubbleAnimation.addListener(markNeedsPaint);
    _bubbleAnimation.addStatusListener(_handleAnimationStatusChange);
    _state.toggleAnimationController?.addListener(markNeedsPaint);
    _state.hoverBubbleAnimationController?.addListener(markNeedsPaint);
    if (defaultController != null) {
      defaultController.addToggleListener(_handleToggleChange);
      defaultController.addZoomingListener(_handleZooming);
      defaultController.addPanningListener(_handlePanning);
      defaultController.addResetListener(_handleReset);
    }
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _state.widget.showDataLabels) {
      _state.dataLabelAnimationController?.forward();
    }
  }

  @override
  void detach() {
    _bubbleAnimation.removeListener(markNeedsPaint);
    _bubbleAnimation.removeStatusListener(_handleAnimationStatusChange);
    _state.toggleAnimationController?.removeListener(markNeedsPaint);
    _state.hoverBubbleAnimationController?.removeListener(markNeedsPaint);
    if (defaultController != null) {
      defaultController.removeToggleListener(_handleToggleChange);
      defaultController.removeZoomingListener(_handleZooming);
      defaultController.removePanningListener(_handlePanning);
      defaultController.removeResetListener(_handleReset);
    }
    super.detach();
  }

  void _handleToggleChange() {
    if (_state.widget.legendSource == MapElement.bubble) {
      _updateToggledBubbleTweenColor();
      _state.toggleAnimationController.forward(from: 0);
    }
  }

  void _initializeToggledBubbleTweenColors() {
    final Color toggledBubbleColor =
        _themeData.toggledItemColor != Colors.transparent
            ? _themeData.toggledItemColor
                .withOpacity(_legendSettings.toggledItemOpacity)
            : null;

    _forwardToggledBubbleColorTween.end = toggledBubbleColor;
    _forwardToggledBubbleStrokeColorTween.begin = _themeData.bubbleStrokeColor;
    _forwardToggledBubbleStrokeColorTween.end =
        _themeData.toggledItemStrokeColor;

    _reverseToggledBubbleColorTween.begin = toggledBubbleColor;
    _reverseToggledBubbleStrokeColorTween.begin =
        _themeData.toggledItemStrokeColor;
    _reverseToggledBubbleStrokeColorTween.end = _themeData.bubbleStrokeColor;
  }

  void _initializeHoverBubbleTweenColors() {
    final Color hoverBubbleStrokeColor = _getHoverStrokeColor();
    _forwardBubbleHoverStrokeColorTween.begin = _bubbleSettings.strokeColor;
    _forwardBubbleHoverStrokeColorTween.end = hoverBubbleStrokeColor;
    _reverseBubbleHoverStrokeColorTween.begin = hoverBubbleStrokeColor;
    _reverseBubbleHoverStrokeColorTween.end = _bubbleSettings.strokeColor;
  }

  Color _getHoverStrokeColor() {
    final Color bubbleStrokeColor = _bubbleSettings.strokeColor;
    final bool canAdjustHoverOpacity =
        double.parse(bubbleStrokeColor.opacity.toStringAsFixed(2)) !=
            _hoverColorOpacity;
    return _themeData.bubbleHoverStrokeColor != null ??
            _themeData.bubbleHoverStrokeColor != Colors.transparent
        ? _themeData.bubbleHoverStrokeColor
        : bubbleStrokeColor.withOpacity(
            canAdjustHoverOpacity ? _hoverColorOpacity : _minHoverOpacity);
  }

  void _updateToggledBubbleTweenColor() {
    if (mapDataSource != null) {
      _MapModel model;
      if (_state.widget.delegate.bubbleColorMappers == null) {
        model = mapDataSource.values
            .elementAt(defaultController.currentToggledItemIndex);
      } else {
        for (final mapModel in mapDataSource.values) {
          if (mapModel.dataIndex != null &&
              mapModel.legendMapperIndex ==
                  defaultController.currentToggledItemIndex) {
            model = mapModel;
            break;
          }
        }
      }

      final Color bubbleColor = model.bubbleColor ??
          _themeData.bubbleColor.withOpacity(_bubbleSettings.opacity);
      _forwardToggledBubbleColorTween.begin = bubbleColor;
      _reverseToggledBubbleColorTween.end = bubbleColor;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (mapDataSource != null) {
      final Rect bounds =
          Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
      context.canvas
        ..save()
        ..clipRect(bounds);
      defaultController.applyTransform(context, offset);

      final double opacity = _bubbleAnimation.value * _bubbleSettings.opacity;
      final Color defaultColor = bubbleSettings.color.withOpacity(opacity);
      final bool hasToggledIndices =
          defaultController.toggledIndices.isNotEmpty;
      final Paint fillPaint = Paint()..isAntiAlias = true;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      mapDataSource.forEach((String key, _MapModel model) {
        if (model.bubbleSizeValue == null ||
            (_currentHoverItem != null &&
                _currentHoverItem.primaryKey == model.primaryKey)) {
          return;
        }

        final double bubbleRadius =
            _getDesiredValue(_bubbleAnimation.value * model.bubbleRadius);
        _updateFillColor(model, fillPaint, hasToggledIndices, defaultColor);
        if (fillPaint.color != null && fillPaint.color != Colors.transparent) {
          context.canvas
              .drawCircle(model.shapePathCenter, bubbleRadius, fillPaint);
        }

        _drawBubbleStroke(
            context, model, strokePaint, bubbleRadius, hasToggledIndices);
      });

      _drawHoveredBubble(context, opacity, defaultColor);
    }
  }

  double _getDesiredValue(double value) {
    return value /
        (defaultController.gesture == _Gesture.scale
            ? defaultController.localScale
            : 1);
  }

  void _drawBubbleStroke(PaintingContext context, _MapModel model,
      Paint strokePaint, double bubbleRadius, bool hasToggledIndices) {
    if (hasToggledStroke || hasDefaultStroke) {
      _updateStrokePaint(model, strokePaint, hasToggledIndices, bubbleRadius);
      strokePaint.strokeWidth /= defaultController.gesture == _Gesture.scale
          ? defaultController.localScale
          : 1;
      context.canvas.drawCircle(
          model.shapePathCenter,
          _getActualCircleRadius(bubbleRadius, strokePaint.strokeWidth),
          strokePaint);
    }
  }

  // Set color to the toggled and un-toggled bubbles based on
  // the [legendController.toggledIndices] collection.
  void _updateFillColor(_MapModel model, Paint fillPaint,
      bool hasToggledIndices, Color defaultColor) {
    fillPaint.style = PaintingStyle.fill;
    if (_state.widget.legendSource == MapElement.bubble) {
      if (defaultController.currentToggledItemIndex ==
          model.legendMapperIndex) {
        // Set tween color to the bubble based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledBubbleColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledBubbleColorTween] return.
        final Color bubbleColor = defaultController.wasToggled(model)
            ? _forwardToggledBubbleColorTween.evaluate(_toggleBubbleAnimation)
            : _reverseToggledBubbleColorTween.evaluate(_toggleBubbleAnimation);
        fillPaint.color = bubbleColor ?? Colors.transparent;
        return;
      } else if (hasToggledIndices && defaultController.wasToggled(model)) {
        // Set toggled color to the previously toggled bubbles.
        fillPaint.color =
            _forwardToggledBubbleColorTween.end ?? Colors.transparent;
        return;
      }
    }

    if (_previousHoverItem != null &&
        _previousHoverItem.primaryKey == model.primaryKey) {
      fillPaint.color = _themeData.bubbleHoverColor != Colors.transparent
          ? _reverseBubbleHoverColorTween.evaluate(_hoverBubbleAnimation)
          : (_previousHoverItem.bubbleColor ?? defaultColor);
      return;
    }
    fillPaint.color = model.bubbleColor ?? defaultColor;
  }

  // Set stroke paint to the toggled and un-toggled bubbles based on
  // the [legendController.toggledIndices] collection.
  void _updateStrokePaint(_MapModel model, Paint strokePaint,
      bool hasToggledIndices, double bubbleRadius) {
    strokePaint.style = PaintingStyle.stroke;
    if (_state.widget.legendSource == MapElement.bubble) {
      if (defaultController.currentToggledItemIndex ==
          model.legendMapperIndex) {
        // Set tween color to the bubble based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledBubbleStrokeColorTween] return.
        // If the legend item is un-toggled, then the
        // [_reverseToggledBubbleStrokeColorTween] return.
        strokePaint
          ..color = defaultController.wasToggled(model)
              ? _forwardToggledBubbleStrokeColorTween
                  .evaluate(_toggleBubbleAnimation)
              : _reverseToggledBubbleStrokeColorTween
                  .evaluate(_toggleBubbleAnimation)
          ..strokeWidth = defaultController.wasToggled(model)
              ? _legendSettings.toggledItemStrokeWidth
              : _bubbleSettings.strokeWidth;
        return;
      } else if (hasToggledIndices && defaultController.wasToggled(model)) {
        // Set toggled stroke color to the previously toggled bubbles.
        strokePaint
          ..color = _forwardToggledBubbleStrokeColorTween.end
          ..strokeWidth = _legendSettings.toggledItemStrokeWidth;
        return;
      }
    }

    if (_previousHoverItem != null &&
        _previousHoverItem.primaryKey == model.primaryKey) {
      if (_themeData.bubbleHoverStrokeWidth > 0.0 &&
          _themeData.bubbleHoverStrokeColor != Colors.transparent) {
        strokePaint
          ..style = PaintingStyle.stroke
          ..color = _reverseBubbleHoverStrokeColorTween
              .evaluate(_hoverBubbleAnimation)
          ..strokeWidth = _themeData.bubbleStrokeWidth;
        return;
      } else if (hasDefaultStroke) {
        strokePaint
          ..style = PaintingStyle.stroke
          ..color = _themeData.bubbleStrokeColor
          ..strokeWidth = _themeData.bubbleStrokeWidth;
        return;
      }
    }
    strokePaint
      ..color = _bubbleSettings.strokeColor
      ..strokeWidth = _bubbleSettings.strokeWidth > bubbleRadius
          ? bubbleRadius
          : _bubbleSettings.strokeWidth;
  }

  void _drawHoveredBubble(
      PaintingContext context, double opacity, Color defaultColor) {
    if (_currentHoverItem != null) {
      final double bubbleRadius =
          _getDesiredValue(_currentHoverItem.bubbleRadius);
      final Color defaultColor =
          bubbleSettings.color.withOpacity(_bubbleSettings.opacity);
      final Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _themeData.bubbleHoverColor != Colors.transparent
            ? _forwardBubbleHoverColorTween.evaluate(_hoverBubbleAnimation)
            : (_currentHoverItem.bubbleColor ?? defaultColor);
      if (paint.color != null && paint.color != Colors.transparent) {
        context.canvas
            .drawCircle(_currentHoverItem.shapePathCenter, bubbleRadius, paint);
      }

      _drawHoveredBubbleStroke(context, bubbleRadius);
    }
  }

  void _drawHoveredBubbleStroke(PaintingContext context, double bubbleRadius) {
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    if (_themeData.bubbleHoverStrokeWidth > 0.0 &&
        _themeData.bubbleHoverStrokeColor != Colors.transparent) {
      strokePaint
        ..color =
            _forwardBubbleHoverStrokeColorTween.evaluate(_hoverBubbleAnimation)
        ..strokeWidth = _getDesiredValue(themeData.bubbleHoverStrokeWidth);
    } else if (hasDefaultStroke) {
      strokePaint
        ..color = _themeData.bubbleStrokeColor
        ..strokeWidth = _getDesiredValue(_themeData.bubbleStrokeWidth);
    }

    if (strokePaint.strokeWidth > 0.0 &&
        strokePaint.color != Colors.transparent) {
      context.canvas.drawCircle(
          _currentHoverItem.shapePathCenter,
          strokePaint.strokeWidth > bubbleRadius
              ? bubbleRadius / 2
              : bubbleRadius - strokePaint.strokeWidth / 2,
          strokePaint);
    }
  }
}
