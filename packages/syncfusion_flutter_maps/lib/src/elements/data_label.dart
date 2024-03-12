import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../utils.dart';

// ignore_for_file: public_member_api_docs
class MapDataLabel extends LeafRenderObjectWidget {
  const MapDataLabel({
    required this.source,
    required this.mapDataSource,
    required this.settings,
    required this.effectiveTextStyle,
    required this.themeData,
    required this.controller,
    required this.dataLabelAnimationController,
  });

  final MapShapeSource source;
  final Map<String, MapModel> mapDataSource;
  final MapDataLabelSettings settings;
  final TextStyle effectiveTextStyle;
  final SfMapsThemeData themeData;
  final MapController? controller;
  final AnimationController dataLabelAnimationController;

  @override
  // ignore: library_private_types_in_public_api
  _RenderMapDataLabel createRenderObject(BuildContext context) {
    return _RenderMapDataLabel(
      source: source,
      mapDataSource: mapDataSource,
      settings: settings,
      effectiveTextStyle: effectiveTextStyle,
      themeData: themeData,
      controller: controller,
      dataLabelAnimationController: dataLabelAnimationController,
      mediaQueryData: MediaQuery.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderMapDataLabel renderObject) {
    renderObject
      ..source = source
      ..mapDataSource = mapDataSource
      ..settings = settings
      ..effectiveTextStyle = effectiveTextStyle
      ..themeData = themeData
      ..dataLabelAnimationController = dataLabelAnimationController
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderMapDataLabel extends ShapeLayerChildRenderBoxBase {
  _RenderMapDataLabel({
    required this.source,
    required this.mapDataSource,
    required MapDataLabelSettings settings,
    required TextStyle effectiveTextStyle,
    required SfMapsThemeData themeData,
    required this.controller,
    required this.dataLabelAnimationController,
    required MediaQueryData mediaQueryData,
  })  : _settings = settings,
        _effectiveTextStyle = effectiveTextStyle,
        _themeData = themeData,
        _mediaQueryData = mediaQueryData {
    _effectiveTextScaleFactor = _mediaQueryData.textScaler;

    _textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..textScaler = _effectiveTextScaleFactor;

    _opacityTween = Tween<double>(begin: 0.0, end: 1.0);
    _dataLabelAnimation = CurvedAnimation(
      parent: dataLabelAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );
    _checkDataLabelColor();
  }

  late TextScaler _effectiveTextScaleFactor;
  late Animation<double> _dataLabelAnimation;
  late Tween<double> _opacityTween;
  late bool _isCustomTextColor;
  late TextPainter _textPainter;

  MapShapeSource source;
  Map<String, MapModel> mapDataSource;
  AnimationController dataLabelAnimationController;
  MapController? controller;

  MapDataLabelSettings get settings => _settings;
  MapDataLabelSettings _settings;
  set settings(MapDataLabelSettings value) {
    if (_settings == value) {
      return;
    }
    _settings = value;
    _checkDataLabelColor();
    markNeedsPaint();
  }

  TextStyle get effectiveTextStyle => _effectiveTextStyle;
  TextStyle _effectiveTextStyle;
  set effectiveTextStyle(TextStyle value) {
    if (_effectiveTextStyle == value) {
      return;
    }
    _effectiveTextStyle = value;
    markNeedsPaint();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    _checkDataLabelColor();
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    _effectiveTextScaleFactor = _mediaQueryData.textScaler;
    _textPainter.textScaler = _effectiveTextScaleFactor;
    markNeedsPaint();
  }

  void _checkDataLabelColor() {
    _isCustomTextColor = _settings.textStyle?.color != null ||
        _themeData.dataLabelTextStyle?.color != null;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    dataLabelAnimationController.addListener(markNeedsPaint);
    if (controller != null) {
      controller!
        ..addZoomPanListener(_handleZoomPanChange)
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addRefreshListener(_handleRefresh)
        ..addResetListener(_handleReset);
    }
  }

  @override
  void detach() {
    dataLabelAnimationController.removeListener(markNeedsPaint);
    if (controller != null) {
      controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeRefreshListener(_handleRefresh)
        ..removeResetListener(_handleReset);
    }

    super.detach();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleZoomPanChange() {
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas
      ..save()
      ..clipRect(offset & size);
    controller?.applyTransform(context, offset);

    String? dataLabelText;
    final TextStyle textStyle = _effectiveTextStyle.copyWith(
        color: _getAnimatedColor(_effectiveTextStyle.color));
    final bool hasMapper = source.dataLabelMapper != null;
    mapDataSource.forEach((String key, MapModel model) {
      dataLabelText = controller!.isInInteractive
          ? model.visibleDataLabelText
          : hasMapper
              ? model.dataLabelText
              : model.primaryKey;
      if (dataLabelText == null) {
        return;
      }

      final TextStyle desiredTextStyle =
          _updateLuminanceColor(textStyle, _isCustomTextColor, model);
      _textPainter.text =
          TextSpan(style: desiredTextStyle, text: dataLabelText);
      _textPainter.layout();
      if (!controller!.isInInteractive) {
        if (_settings.overflowMode == MapLabelOverflow.hide) {
          if (_textPainter.width > model.shapeWidth!) {
            model.visibleDataLabelText = null;
            return;
          }
        } else if (_settings.overflowMode == MapLabelOverflow.ellipsis) {
          final String trimmedText = getTrimText(
              dataLabelText!,
              desiredTextStyle,
              model.shapeWidth!,
              _textPainter,
              _textPainter.width);
          _textPainter.text =
              TextSpan(style: desiredTextStyle, text: trimmedText);
          _textPainter.layout();
        }

        // ignore: avoid_as
        final TextSpan textSpan = _textPainter.text! as TextSpan;
        model.visibleDataLabelText = textSpan.text;
      }
      context.canvas
        ..save()
        ..translate(model.shapePathCenter!.dx, model.shapePathCenter!.dy)
        ..scale(1 / controller!.localScale);
      _textPainter.paint(context.canvas,
          Offset(-_textPainter.width / 2, -_textPainter.height / 2));
      context.canvas.restore();
    });
    context.canvas.restore();
  }

  TextStyle _updateLuminanceColor(
      TextStyle style, bool isCustomTextStyle, MapModel model) {
    if (!isCustomTextStyle) {
      final Brightness brightness =
          ThemeData.estimateBrightnessForColor(_getActualShapeColor(model));
      final Color color =
          brightness == Brightness.dark ? Colors.white : Colors.black;
      style = style.copyWith(color: _getAnimatedColor(color));
    }

    return style;
  }

  Color _getActualShapeColor(MapModel model) {
    return model.shapeColor ?? _themeData.layerColor!;
  }

  Color? _getAnimatedColor(Color? color) {
    if (color == null) {
      return null;
    }
    return color.withOpacity(_opacityTween.evaluate(_dataLabelAnimation));
  }
}
