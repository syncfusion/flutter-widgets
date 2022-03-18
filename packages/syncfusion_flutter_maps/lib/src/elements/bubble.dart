import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../utils.dart';

// ignore_for_file: public_member_api_docs
class MapBubble extends LeafRenderObjectWidget {
  const MapBubble({
    Key? key,
    required this.source,
    required this.mapDataSource,
    required this.bubbleSettings,
    required this.legend,
    required this.showDataLabels,
    required this.themeData,
    required this.controller,
    required this.bubbleAnimationController,
    required this.dataLabelAnimationController,
    required this.toggleAnimationController,
    required this.hoverBubbleAnimationController,
  }) : super(key: key);

  final MapShapeSource source;
  final Map<String, MapModel> mapDataSource;
  final MapBubbleSettings bubbleSettings;
  final MapLegend? legend;
  final bool showDataLabels;
  final SfMapsThemeData themeData;
  final MapController? controller;
  final AnimationController bubbleAnimationController;
  final AnimationController dataLabelAnimationController;
  final AnimationController toggleAnimationController;
  final AnimationController hoverBubbleAnimationController;

  @override
  RenderMapBubble createRenderObject(BuildContext context) {
    return RenderMapBubble(
      source: source,
      mapDataSource: mapDataSource,
      bubbleSettings: bubbleSettings,
      legend: legend,
      showDataLabels: showDataLabels,
      themeData: themeData,
      controller: controller,
      bubbleAnimationController: bubbleAnimationController,
      dataLabelAnimationController: dataLabelAnimationController,
      toggleAnimationController: toggleAnimationController,
      hoverBubbleAnimationController: hoverBubbleAnimationController,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMapBubble renderObject) {
    renderObject
      ..source = source
      ..mapDataSource = mapDataSource
      ..bubbleSettings = bubbleSettings
      ..legend = legend
      ..showDataLabels = showDataLabels
      ..themeData = themeData
      ..bubbleAnimationController = bubbleAnimationController
      ..dataLabelAnimationController = dataLabelAnimationController
      ..toggleAnimationController = toggleAnimationController
      ..hoverBubbleAnimationController = hoverBubbleAnimationController;
  }
}

class RenderMapBubble extends ShapeLayerChildRenderBoxBase {
  RenderMapBubble({
    required MapShapeSource source,
    required this.mapDataSource,
    required MapBubbleSettings bubbleSettings,
    required MapLegend? legend,
    required this.showDataLabels,
    required SfMapsThemeData themeData,
    required this.controller,
    required this.bubbleAnimationController,
    required this.dataLabelAnimationController,
    required this.toggleAnimationController,
    required this.hoverBubbleAnimationController,
  })  : _source = source,
        _bubbleSettings = bubbleSettings,
        _legend = legend,
        _themeData = themeData {
    _bubbleAnimation = CurvedAnimation(
      parent: bubbleAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );
    _toggleBubbleAnimation = CurvedAnimation(
        parent: toggleAnimationController, curve: Curves.easeInOut);

    _forwardToggledBubbleColorTween = ColorTween();
    _forwardToggledBubbleStrokeColorTween = ColorTween();
    _reverseToggledBubbleColorTween = ColorTween();
    _reverseToggledBubbleStrokeColorTween = ColorTween();

    _toggleBubbleAnimation = CurvedAnimation(
        parent: toggleAnimationController, curve: Curves.easeInOut);

    _forwardBubbleHoverColorTween = ColorTween();
    _forwardBubbleHoverStrokeColorTween = ColorTween();
    _reverseBubbleHoverColorTween = ColorTween();
    _reverseBubbleHoverStrokeColorTween = ColorTween();

    _hoverBubbleAnimation = CurvedAnimation(
        parent: hoverBubbleAnimationController, curve: Curves.easeInOut);

    if (_legend != null && _legend!.enableToggleInteraction) {
      _initializeToggledBubbleTweenColors();
    }

    if (_themeData.bubbleHoverColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeWidth! > 0.0) {
      _initializeHoverBubbleTweenColors();
    }
  }

  late Animation<double> _bubbleAnimation;
  late Animation<double> _toggleBubbleAnimation;
  late Animation<double> _hoverBubbleAnimation;
  MapModel? _currentHoverItem;
  MapModel? _previousHoverItem;
  late ColorTween _forwardToggledBubbleColorTween;
  late ColorTween _forwardToggledBubbleStrokeColorTween;
  late ColorTween _reverseToggledBubbleColorTween;
  late ColorTween _reverseToggledBubbleStrokeColorTween;
  late ColorTween _forwardBubbleHoverColorTween;
  late ColorTween _forwardBubbleHoverStrokeColorTween;
  late ColorTween _reverseBubbleHoverColorTween;
  late ColorTween _reverseBubbleHoverStrokeColorTween;

  Map<String, MapModel> mapDataSource;
  bool showDataLabels;
  MapController? controller;
  AnimationController bubbleAnimationController;
  AnimationController dataLabelAnimationController;
  AnimationController toggleAnimationController;
  AnimationController hoverBubbleAnimationController;

  MapShapeSource get source => _source;
  MapShapeSource _source;
  set source(MapShapeSource value) {
    if (_source == value) {
      return;
    }
    _source = value;
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
    if (_legend != null && _legend!.enableToggleInteraction) {
      _initializeToggledBubbleTweenColors();
    }

    if (_themeData.bubbleHoverColor != Colors.transparent ||
        _themeData.bubbleHoverStrokeColor != Colors.transparent ||
        (_themeData.bubbleHoverStrokeWidth != null &&
            _themeData.bubbleHoverStrokeWidth! > 0.0)) {
      _initializeHoverBubbleTweenColors();
    }

    markNeedsPaint();
  }

  MapLegend? get legend => _legend;
  MapLegend? _legend;
  set legend(MapLegend? value) {
    // Update [MapsShapeLayer.legend] value only when
    // [MapsShapeLayer.legend] property is set to bubble.
    if (_legend != null && _legend!.source != MapElement.bubble ||
        _legend == value) {
      return;
    }
    _legend = value;
    if (_legend!.enableToggleInteraction) {
      _initializeToggledBubbleTweenColors();
    }

    markNeedsPaint();
  }

  bool get hasDefaultStroke =>
      _bubbleSettings.strokeWidth! > 0 &&
      _bubbleSettings.strokeColor != null &&
      _bubbleSettings.strokeColor != Colors.transparent;

  bool get hasHoverStroke =>
      _themeData.bubbleHoverStrokeWidth! > 0 &&
      _themeData.bubbleHoverStrokeColor != Colors.transparent;

  bool get hasToggledStroke =>
      _legend != null &&
      _legend!.toggledItemStrokeWidth > 0 &&
      _legend!.toggledItemStrokeColor != null &&
      _legend!.toggledItemStrokeColor != Colors.transparent;

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

  void _handleZoomPanChange() {
    if (_currentHoverItem != null) {
      onExit();
    }
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void onHover(MapModel? item, MapLayerElement? element) {
    if (element == MapLayerElement.bubble && _currentHoverItem != item) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = item;
      _updateHoverItemTween();
    } else if ((_currentHoverItem != null && _currentHoverItem != item) ||
        (element == MapLayerElement.shape && _currentHoverItem == item)) {
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
    final double opacity =
        _bubbleAnimation.value * _bubbleSettings.color!.opacity;
    final Color defaultColor = bubbleSettings.color!.withOpacity(opacity);
    if (_currentHoverItem != null) {
      _forwardBubbleHoverColorTween.begin =
          _currentHoverItem!.bubbleColor ?? defaultColor;
      _forwardBubbleHoverColorTween.end =
          _getHoverFillColor(opacity, defaultColor, _currentHoverItem!);
    }

    if (_previousHoverItem != null) {
      _reverseBubbleHoverColorTween.begin =
          _getHoverFillColor(opacity, defaultColor, _previousHoverItem!);
      _reverseBubbleHoverColorTween.end =
          _previousHoverItem!.bubbleColor ?? defaultColor;
    }

    hoverBubbleAnimationController.forward(from: 0.0);
  }

  Color _getHoverFillColor(double opacity, Color defaultColor, MapModel model) {
    final Color bubbleColor = model.bubbleColor ?? defaultColor;
    return _themeData.bubbleHoverColor != null &&
            _themeData.bubbleHoverColor != Colors.transparent
        ? _themeData.bubbleHoverColor!
        : getSaturatedColor(bubbleColor);
  }

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _bubbleAnimation
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handleAnimationStatusChange);
    toggleAnimationController.addListener(markNeedsPaint);
    hoverBubbleAnimationController.addListener(markNeedsPaint);
    if (controller != null) {
      controller!
        ..addZoomPanListener(_handleZoomPanChange)
        ..addToggleListener(_handleToggleChange)
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addRefreshListener(_handleRefresh)
        ..addResetListener(_handleReset);
    }
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && showDataLabels) {
      dataLabelAnimationController.forward();
    }
  }

  @override
  void detach() {
    _bubbleAnimation
      ..removeListener(markNeedsPaint)
      ..removeStatusListener(_handleAnimationStatusChange);
    toggleAnimationController.removeListener(markNeedsPaint);
    hoverBubbleAnimationController.removeListener(markNeedsPaint);
    if (controller != null) {
      controller!
        ..removeToggleListener(_handleToggleChange)
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeRefreshListener(_handleRefresh)
        ..removeResetListener(_handleReset);
    }

    super.detach();
  }

  void _handleToggleChange() {
    if (legend!.source == MapElement.bubble) {
      _updateToggledBubbleTweenColor();
      toggleAnimationController.forward(from: 0);
    }
  }

  void _initializeToggledBubbleTweenColors() {
    final Color? toggledBubbleColor = _themeData.toggledItemColor !=
            Colors.transparent
        ? _themeData.toggledItemColor!.withOpacity(_legend!.toggledItemOpacity)
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
    final Color bubbleStrokeColor = _bubbleSettings.strokeColor!;
    return (_themeData.bubbleHoverStrokeColor != null &&
            _themeData.bubbleHoverStrokeColor != Colors.transparent)
        ? _themeData.bubbleHoverStrokeColor!
        : getSaturatedColor(bubbleStrokeColor);
  }

  void _updateToggledBubbleTweenColor() {
    late MapModel model;
    if (source.bubbleColorMappers == null) {
      model =
          mapDataSource.values.elementAt(controller!.currentToggledItemIndex);
    } else {
      for (final MapModel mapModel in mapDataSource.values) {
        if (mapModel.dataIndex != null &&
            mapModel.legendMapperIndex == controller!.currentToggledItemIndex) {
          model = mapModel;
          break;
        }
      }
    }

    final Color bubbleColor = model.bubbleColor ?? _themeData.bubbleColor!;
    _forwardToggledBubbleColorTween.begin = bubbleColor;
    _reverseToggledBubbleColorTween.end = bubbleColor;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect bounds =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    context.canvas
      ..save()
      ..clipRect(bounds);
    controller!.applyTransform(context, offset);

    final double opacity =
        _bubbleAnimation.value * _bubbleSettings.color!.opacity;
    final Color defaultColor = bubbleSettings.color!.withOpacity(opacity);
    final bool hasToggledIndices = controller!.toggledIndices.isNotEmpty;
    final Paint fillPaint = Paint()..isAntiAlias = true;
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    mapDataSource.forEach((String key, MapModel model) {
      if (model.bubbleSizeValue == null ||
          (_currentHoverItem != null &&
              _currentHoverItem!.primaryKey == model.primaryKey)) {
        return;
      }

      final double bubbleRadius =
          _getDesiredValue(_bubbleAnimation.value * model.bubbleRadius!);
      _updateFillColor(model, fillPaint, hasToggledIndices, defaultColor);
      if (fillPaint.color != Colors.transparent) {
        context.canvas
            .drawCircle(model.shapePathCenter!, bubbleRadius, fillPaint);
      }

      _drawBubbleStroke(
          context, model, strokePaint, bubbleRadius, hasToggledIndices);
    });

    _drawHoveredBubble(context, opacity, defaultColor);
  }

  double _getDesiredValue(double value) {
    return value /
        (controller!.gesture == Gesture.scale ? controller!.localScale : 1);
  }

  void _drawBubbleStroke(PaintingContext context, MapModel model,
      Paint strokePaint, double bubbleRadius, bool hasToggledIndices) {
    if (hasToggledStroke || hasDefaultStroke) {
      _updateStrokePaint(model, strokePaint, hasToggledIndices, bubbleRadius);
      strokePaint.strokeWidth /=
          controller!.gesture == Gesture.scale ? controller!.localScale : 1;
      context.canvas.drawCircle(
          model.shapePathCenter!,
          _getDesiredRadius(bubbleRadius, strokePaint.strokeWidth),
          strokePaint);
    }
  }

  double _getDesiredRadius(double circleRadius, double strokeWidth) {
    return strokeWidth > circleRadius
        ? circleRadius / 2
        : circleRadius - strokeWidth / 2;
  }

  // Set color to the toggled and un-toggled bubbles based on
  // the [legendController.toggledIndices] collection.
  void _updateFillColor(MapModel model, Paint fillPaint, bool hasToggledIndices,
      Color defaultColor) {
    fillPaint.style = PaintingStyle.fill;
    if (_legend != null && _legend!.source == MapElement.bubble) {
      if (controller!.currentToggledItemIndex == model.legendMapperIndex) {
        // Set tween color to the bubble based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledBubbleColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledBubbleColorTween] return.
        final Color? bubbleColor = controller!.wasToggled(model)
            ? _forwardToggledBubbleColorTween.evaluate(_toggleBubbleAnimation)
            : _reverseToggledBubbleColorTween.evaluate(_toggleBubbleAnimation);
        fillPaint.color = bubbleColor ?? Colors.transparent;
        return;
      } else if (hasToggledIndices && controller!.wasToggled(model)) {
        // Set toggled color to the previously toggled bubbles.
        fillPaint.color =
            _forwardToggledBubbleColorTween.end ?? Colors.transparent;
        return;
      }
    }

    if (_previousHoverItem != null &&
        _previousHoverItem!.primaryKey == model.primaryKey) {
      fillPaint.color = _themeData.bubbleHoverColor != Colors.transparent
          ? _reverseBubbleHoverColorTween.evaluate(_hoverBubbleAnimation)!
          : (_previousHoverItem!.bubbleColor ?? defaultColor);
      return;
    }
    fillPaint.color = model.bubbleColor ?? defaultColor;
  }

  // Set stroke paint to the toggled and un-toggled bubbles based on
  // the [legendController.toggledIndices] collection.
  void _updateStrokePaint(MapModel model, Paint strokePaint,
      bool hasToggledIndices, double bubbleRadius) {
    strokePaint.style = PaintingStyle.stroke;
    if (_legend != null && _legend!.source == MapElement.bubble) {
      if (controller!.currentToggledItemIndex == model.legendMapperIndex) {
        // Set tween color to the bubble based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledBubbleStrokeColorTween] return.
        // If the legend item is un-toggled, then the
        // [_reverseToggledBubbleStrokeColorTween] return.
        strokePaint
          ..color = controller!.wasToggled(model)
              ? _forwardToggledBubbleStrokeColorTween
                  .evaluate(_toggleBubbleAnimation)!
              : _reverseToggledBubbleStrokeColorTween
                  .evaluate(_toggleBubbleAnimation)!
          ..strokeWidth = controller!.wasToggled(model)
              ? _legend!.toggledItemStrokeWidth
              : _bubbleSettings.strokeWidth!;
        return;
      } else if (hasToggledIndices && controller!.wasToggled(model)) {
        // Set toggled stroke color to the previously toggled bubbles.
        strokePaint
          ..color = _forwardToggledBubbleStrokeColorTween.end!
          ..strokeWidth = _legend!.toggledItemStrokeWidth;
        return;
      }
    }

    if (_previousHoverItem != null &&
        _previousHoverItem!.primaryKey == model.primaryKey) {
      if (_themeData.bubbleHoverStrokeWidth! > 0.0 &&
          _themeData.bubbleHoverStrokeColor != Colors.transparent) {
        strokePaint
          ..style = PaintingStyle.stroke
          ..color = _reverseBubbleHoverStrokeColorTween
              .evaluate(_hoverBubbleAnimation)!
          ..strokeWidth = _themeData.bubbleStrokeWidth;
        return;
      } else if (hasDefaultStroke) {
        strokePaint
          ..style = PaintingStyle.stroke
          ..color = _themeData.bubbleStrokeColor!
          ..strokeWidth = _themeData.bubbleStrokeWidth;
        return;
      }
    }
    strokePaint
      ..color = _bubbleSettings.strokeColor!
      ..strokeWidth = _bubbleSettings.strokeWidth! > bubbleRadius
          ? bubbleRadius
          : _bubbleSettings.strokeWidth!;
  }

  void _drawHoveredBubble(
      PaintingContext context, double opacity, Color defaultColor) {
    if (_currentHoverItem != null) {
      final double bubbleRadius =
          _getDesiredValue(_currentHoverItem!.bubbleRadius!);
      final Color defaultColor = bubbleSettings.color!;
      final Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _themeData.bubbleHoverColor != Colors.transparent
            ? _forwardBubbleHoverColorTween.evaluate(_hoverBubbleAnimation)!
            : (_currentHoverItem!.bubbleColor ?? defaultColor);
      if (paint.color != Colors.transparent) {
        context.canvas.drawCircle(
            _currentHoverItem!.shapePathCenter!, bubbleRadius, paint);
      }

      _drawHoveredBubbleStroke(context, bubbleRadius);
    }
  }

  void _drawHoveredBubbleStroke(PaintingContext context, double bubbleRadius) {
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    if (_themeData.bubbleHoverStrokeWidth! > 0.0 &&
        _themeData.bubbleHoverStrokeColor != Colors.transparent) {
      strokePaint
        ..color =
            _forwardBubbleHoverStrokeColorTween.evaluate(_hoverBubbleAnimation)!
        ..strokeWidth = _getDesiredValue(themeData.bubbleHoverStrokeWidth!);
    } else if (hasDefaultStroke) {
      strokePaint
        ..color = _themeData.bubbleStrokeColor!
        ..strokeWidth = _getDesiredValue(_themeData.bubbleStrokeWidth);
    }

    if (strokePaint.strokeWidth > 0.0 &&
        strokePaint.color != Colors.transparent) {
      context.canvas.drawCircle(
          _currentHoverItem!.shapePathCenter!,
          strokePaint.strokeWidth > bubbleRadius
              ? bubbleRadius / 2
              : bubbleRadius - strokePaint.strokeWidth / 2,
          strokePaint);
    }
  }
}
