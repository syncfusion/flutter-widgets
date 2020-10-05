part of maps;

/// A Render object widget which renders all data labels.
class _MapDataLabel extends LeafRenderObjectWidget {
  const _MapDataLabel({
    this.mapDataSource,
    this.settings,
    this.effectiveTextStyle,
    this.themeData,
    this.defaultController,
    this.state,
  });

  final Map<String, _MapModel> mapDataSource;
  final MapDataLabelSettings settings;
  final TextStyle effectiveTextStyle;
  final SfMapsThemeData themeData;
  final _DefaultController defaultController;
  final _MapsShapeLayerState state;

  @override
  _RenderMapDataLabel createRenderObject(BuildContext context) {
    return _RenderMapDataLabel(
      mapDataSource: mapDataSource,
      settings: settings,
      effectiveTextStyle: effectiveTextStyle,
      themeData: themeData,
      defaultController: defaultController,
      mediaQueryData: MediaQuery.of(context),
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMapDataLabel renderObject) {
    renderObject
      ..mapDataSource = mapDataSource
      ..settings = settings
      ..effectiveTextStyle = effectiveTextStyle
      ..themeData = themeData
      ..defaultController = defaultController
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderMapDataLabel extends _ShapeLayerChildRenderBoxBase {
  _RenderMapDataLabel({
    Map<String, _MapModel> mapDataSource,
    MapDataLabelSettings settings,
    TextStyle effectiveTextStyle,
    SfMapsThemeData themeData,
    _DefaultController defaultController,
    MediaQueryData mediaQueryData,
    _MapsShapeLayerState state,
  })  : mapDataSource = mapDataSource,
        _settings = settings,
        _effectiveTextStyle = effectiveTextStyle,
        _themeData = themeData,
        defaultController = defaultController,
        _mediaQueryData = mediaQueryData,
        _state = state {
    _effectiveTextScaleFactor = _mediaQueryData.textScaleFactor;

    _textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..textScaleFactor = _effectiveTextScaleFactor;

    _opacityTween = Tween<double>(begin: 0.0, end: 1.0);
    _dataLabelAnimation = CurvedAnimation(
      parent: _state.dataLabelAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );
  }

  final _MapsShapeLayerState _state;
  double _effectiveTextScaleFactor;
  Animation<double> _dataLabelAnimation;
  Tween<double> _opacityTween;
  TextPainter _textPainter;
  _DefaultController defaultController;
  Map<String, _MapModel> mapDataSource;

  MapDataLabelSettings get settings => _settings;
  MapDataLabelSettings _settings;
  set settings(MapDataLabelSettings value) {
    if (_settings == value) {
      return;
    }
    _settings = value;
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
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    _effectiveTextScaleFactor = _mediaQueryData.textScaleFactor;
    _textPainter.textScaleFactor = _effectiveTextScaleFactor;
    markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = _getBoxSize(constraints);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _state.dataLabelAnimationController.addListener(markNeedsPaint);
    if (defaultController != null) {
      defaultController.addZoomingListener(_handleZooming);
      defaultController.addPanningListener(_handlePanning);
      defaultController.addResetListener(_handleReset);
    }
  }

  @override
  void detach() {
    _state.dataLabelAnimationController.removeListener(markNeedsPaint);
    if (defaultController != null) {
      defaultController.removeZoomingListener(_handleZooming);
      defaultController.removePanningListener(_handlePanning);
      defaultController.removeResetListener(_handleReset);
    }
    super.detach();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  @override
  void refresh() {
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (mapDataSource != null) {
      context.canvas
        ..save()
        ..clipRect(offset & size);
      defaultController.applyTransform(context, offset);

      String dataLabelText;
      final TextStyle textStyle = _effectiveTextStyle.copyWith(
          color: _getAnimatedColor(_effectiveTextStyle.color));
      final bool hasMapper = _state.widget.delegate.dataLabelMapper != null;
      final bool isCustomTextStyle =
          _settings.textStyle != null || _themeData.dataLabelTextStyle != null;
      mapDataSource.forEach((String key, _MapModel model) {
        dataLabelText = defaultController.isInInteractive
            ? model.visibleDataLabelText
            : hasMapper
                ? model.dataLabelText
                : model.primaryKey;
        if (dataLabelText == null) {
          return;
        }

        final TextStyle desiredTextStyle =
            _updateLuminanceColor(textStyle, isCustomTextStyle, model);
        _textPainter.text =
            TextSpan(style: desiredTextStyle, text: dataLabelText);
        _textPainter.layout();
        if (!defaultController.isInInteractive) {
          if (_settings.overflowMode == MapLabelOverflowMode.hide) {
            if (_textPainter.width > model.shapeWidth) {
              model.visibleDataLabelText = null;
              return;
            }
          } else if (_settings.overflowMode == MapLabelOverflowMode.trim) {
            _trimText(dataLabelText, model.shapeWidth, desiredTextStyle);
          }

          final TextSpan textSpan = _textPainter.text;
          model.visibleDataLabelText = textSpan.text;
        }
        context.canvas
          ..save()
          ..translate(model.shapePathCenter.dx, model.shapePathCenter.dy)
          ..scale(1 / defaultController.localScale);
        _textPainter.paint(context.canvas,
            Offset(-_textPainter.width / 2, -_textPainter.height / 2));
        context.canvas.restore();
      });
      context.canvas.restore();
    }
  }

  TextStyle _updateLuminanceColor(
      TextStyle style, bool isCustomTextStyle, _MapModel model) {
    if (!isCustomTextStyle) {
      final Brightness brightness =
          ThemeData.estimateBrightnessForColor(_getActualShapeColor(model));
      final Color color =
          brightness == Brightness.dark ? Colors.white : Colors.black;
      style = style.copyWith(color: _getAnimatedColor(color));
    }

    return style;
  }

  Color _getActualShapeColor(_MapModel model) {
    return model.shapeColor ??
        (_state.paletteLength > 0
            ? _state.widget.palette[model.actualIndex % _state.paletteLength]
            : _themeData.layerColor);
  }

  Color _getAnimatedColor(Color color) {
    return color.withOpacity(_opacityTween.evaluate(_dataLabelAnimation));
  }

  void _trimText(String dataLabelText, double shapeWidth, TextStyle textStyle) {
    final int actualTextLength = dataLabelText.length;
    String trimmedText = dataLabelText;
    int trimLength = 3; // 3 dots
    while (_textPainter.width > shapeWidth) {
      if (trimmedText.length <= 4) {
        _textPainter.text =
            TextSpan(style: textStyle, text: trimmedText[0] + '...');
        _textPainter.layout();
        break;
      } else {
        trimmedText = dataLabelText.replaceRange(
            actualTextLength - trimLength, actualTextLength, '...');
        _textPainter.text = TextSpan(style: textStyle, text: trimmedText);
        _textPainter.layout();
        trimLength++;
      }
    }
  }
}
