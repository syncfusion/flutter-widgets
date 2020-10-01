part of maps;

/// Visual explanation of the data represented in the map.
///
/// Each item should contains a shape as well as a label.
class _MapLegend extends StatefulWidget {
  const _MapLegend({
    this.dataSource,
    this.source,
    this.palette,
    this.settings,
    this.themeData,
    this.defaultController,
    this.toggleAnimationController,
  });

  final dynamic dataSource;
  final MapElement source;
  final List<Color> palette;
  final MapLegendSettings settings;
  final SfMapsThemeData themeData;
  final _DefaultController defaultController;
  final AnimationController toggleAnimationController;

  @override
  _MapLegendState createState() => _MapLegendState();
}

class _MapLegendState extends State<_MapLegend> {
  @override
  void didUpdateWidget(_MapLegend oldWidget) {
    if (oldWidget.source != widget.source) {
      widget.defaultController.currentToggledItemIndex = -1;
      widget.defaultController.toggledIndices.clear();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (widget.settings.overflowMode) {
      case MapLegendOverflowMode.scroll:
        return SingleChildScrollView(
          scrollDirection: widget.settings.position == MapLegendPosition.top ||
                  widget.settings.position == MapLegendPosition.bottom
              ? Axis.horizontal
              : Axis.vertical,
          child: actualChild,
        );
      case MapLegendOverflowMode.wrap:
        return actualChild;
    }
  }

  Widget get actualChild {
    return Padding(
      padding: widget.settings.padding,
      // Mapped the legend settings properties values to the Wrap widget.
      child: Wrap(
        direction: widget.settings.direction ??
                widget.settings.position == MapLegendPosition.top ||
                    widget.settings.position == MapLegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical,
        spacing: widget.settings.itemsSpacing,
        children: _getLegendItems(),
        runSpacing: 6,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.start,
      ),
    );
  }

  /// Returns the list of legend items based on the data source.
  List<Widget> _getLegendItems() {
    final List<Widget> legendItems = <Widget>[];
    final bool isLegendForBubbles = widget.source == MapElement.bubble;
    final int paletteLength =
        widget.palette != null ? widget.palette.length : 0;
    if (widget.dataSource != null && widget.dataSource.isNotEmpty) {
      // Here source be either shape color mappers or bubble color mappers.
      if (widget.dataSource is List) {
        final int length = widget.dataSource.length;
        for (int i = 0; i < length; i++) {
          final MapColorMapper item = widget.dataSource[i];
          assert(item != null);
          final String text =
              item.text ?? item.value ?? '${item.from} - ${item.to}';
          assert(text != null);
          legendItems.add(_getLegendItem(
            text,
            item.color,
            i,
            paletteLength,
            isLegendForBubbles,
          ));
        }
      } else {
        // Here source is map data source.
        widget.dataSource.forEach((String key, _MapModel mapModel) {
          assert(mapModel.primaryKey != null);
          legendItems.add(_getLegendItem(
            mapModel.primaryKey,
            isLegendForBubbles ? mapModel.bubbleColor : mapModel.shapeColor,
            mapModel.legendMapperIndex,
            paletteLength,
            isLegendForBubbles,
          ));
        });
      }
    }

    return legendItems;
  }

  /// Returns the legend icon and label.
  Widget _getLegendItem(String text, Color color, int index, int paletteLength,
      bool isLegendForBubbles) {
    assert(text != null);
    return _MapLegendItem(
      index: index,
      text: text,
      iconShapeColor: color ??
          (isLegendForBubbles
              ? widget.themeData.bubbleColor
              : (paletteLength > 0
                  ? widget.palette[index % paletteLength]
                  : widget.themeData.layerColor)),
      source: widget.source,
      legendSettings: widget.settings,
      themeData: widget.themeData,
      defaultController: widget.defaultController,
      toggleAnimationController: widget.toggleAnimationController,
    );
  }
}

class _MapLegendItem extends LeafRenderObjectWidget {
  const _MapLegendItem({
    this.index,
    this.text,
    this.iconShapeColor,
    this.source,
    this.legendSettings,
    this.themeData,
    this.defaultController,
    this.toggleAnimationController,
  });

  final int index;
  final String text;
  final Color iconShapeColor;
  final MapElement source;
  final MapLegendSettings legendSettings;
  final SfMapsThemeData themeData;
  final _DefaultController defaultController;
  final AnimationController toggleAnimationController;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLegendItem(
      index: index,
      text: text,
      iconShapeColor: iconShapeColor,
      source: source,
      legendSettings: legendSettings,
      themeData: themeData,
      defaultController: defaultController,
      toggleAnimationController: toggleAnimationController,
      mediaQueryData: MediaQuery.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderLegendItem renderObject) {
    renderObject
      ..text = text
      ..iconShapeColor = iconShapeColor
      ..source = source
      ..legendSettings = legendSettings
      ..themeData = themeData
      ..defaultController = defaultController
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderLegendItem extends RenderBox implements MouseTrackerAnnotation {
  _RenderLegendItem({
    int index,
    String text,
    Color iconShapeColor,
    MapElement source,
    MapLegendSettings legendSettings,
    SfMapsThemeData themeData,
    _DefaultController defaultController,
    AnimationController toggleAnimationController,
    MediaQueryData mediaQueryData,
  })  : _index = index,
        _text = text,
        _iconShapeColor = iconShapeColor,
        _source = source,
        _legendSettings = legendSettings,
        _themeData = themeData,
        defaultController = defaultController,
        _toggleAnimationController = toggleAnimationController,
        _mediaQueryData = mediaQueryData {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    _updateTextPainter();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
    _showLegendIcon =
        _legendSettings.iconSize != null && _legendSettings.showIcon;
    _toggleColorAnimation = CurvedAnimation(
        parent: _toggleAnimationController, curve: Curves.easeInOut);
    _iconColorTween = ColorTween();
    _textOpacityTween = Tween();
    _updateToggledIconColor();
  }

  final int _spacing = 3;

  final int _index;

  final double _toggledTextOpacity = 0.5;

  final double _untoggledTextOpacity = 1.0;

  final _MapIconShape _iconShape = const _MapIconShape();

  final AnimationController _toggleAnimationController;

  _DefaultController defaultController;

  bool _wasToggled = false;

  bool _showLegendIcon;

  TextPainter _textPainter;

  TapGestureRecognizer _tapGestureRecognizer;

  Animation<double> _toggleColorAnimation;

  Tween _textOpacityTween;

  ColorTween _iconColorTween;

  Color _toggledIconColor;

  String get text => _text;
  String _text;
  set text(String value) {
    if (_text == value) {
      return;
    }
    _text = value;
    _updateTextPainter();
    markNeedsLayout();
  }

  Color get iconShapeColor => _iconShapeColor;
  Color _iconShapeColor;
  set iconShapeColor(Color value) {
    if (_iconShapeColor == value) {
      return;
    }
    _iconShapeColor = value;
    markNeedsPaint();
  }

  MapElement get source => _source;
  MapElement _source;
  set source(MapElement value) {
    if (_source == value) {
      return;
    }
    _source = value;
    _wasToggled = false;
    markNeedsPaint();
  }

  MapLegendSettings get legendSettings => _legendSettings;
  MapLegendSettings _legendSettings;
  set legendSettings(MapLegendSettings value) {
    if (_legendSettings == value) {
      return;
    }
    _legendSettings = value;
    _updateTextPainter();
    _showLegendIcon =
        _legendSettings.iconSize != null && _legendSettings.showIcon;
    markNeedsLayout();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    _updateToggledIconColor();
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    _updateTextPainter();
    markNeedsLayout();
  }

  @override
  MouseCursor get cursor => _legendSettings.enableToggleInteraction
      ? SystemMouseCursors.click
      : SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  @override
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => null;

  void _handleTapUp(TapUpDetails details) {
    _wasToggled = !defaultController.toggledIndices.contains(_index);
    if (_wasToggled) {
      defaultController.toggledIndices.add(_index);
      _iconColorTween.begin = _iconShapeColor;
      _iconColorTween.end = _toggledIconColor;
      _textOpacityTween.begin = _untoggledTextOpacity;
      _textOpacityTween.end = _toggledTextOpacity;
    } else {
      defaultController.toggledIndices.remove(_index);
      _iconColorTween.begin = _toggledIconColor;
      _iconColorTween.end = _iconShapeColor;
      _textOpacityTween.begin = _toggledTextOpacity;
      _textOpacityTween.end = _untoggledTextOpacity;
    }
    defaultController.currentToggledItemIndex = _index;
    _toggleAnimationController.forward(from: 0);
  }

  void _updateTextPainter() {
    _textPainter.textScaleFactor = _mediaQueryData.textScaleFactor;
    _textPainter.text = TextSpan(text: _text, style: legendSettings.textStyle);
    _textPainter.layout();
  }

  void _updateToggledIconColor() {
    _toggledIconColor = _themeData.toggledItemColor != Colors.transparent
        ? _themeData.toggledItemColor
            .withOpacity(_legendSettings.toggledItemOpacity)
        : (_themeData.brightness != Brightness.dark
            ? Color.fromRGBO(230, 230, 230, 1.0)
            : Color.fromRGBO(66, 66, 66, 1.0));
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) => _legendSettings.enableToggleInteraction;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (_legendSettings.enableToggleInteraction &&
        event.down &&
        event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _toggleAnimationController?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _toggleAnimationController?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final double width =
        (_showLegendIcon ? _legendSettings.iconSize.width : 0) +
            _spacing +
            _textPainter.width;
    final double height = max(
            _showLegendIcon ? _legendSettings.iconSize.height : 0,
            _textPainter.height) +
        _spacing;
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double toggledLegendItemOpacity;
    Color iconColor;
    Offset actualOffset;
    if (_wasToggled || defaultController.currentToggledItemIndex == _index) {
      if (defaultController.currentToggledItemIndex == _index) {
        iconColor = _iconColorTween.evaluate(_toggleColorAnimation);
        toggledLegendItemOpacity =
            _textOpacityTween.evaluate(_toggleColorAnimation);
      } else {
        iconColor = _toggledIconColor;
        toggledLegendItemOpacity = _toggledTextOpacity;
      }
    } else {
      iconColor = _iconShapeColor;
      toggledLegendItemOpacity = _untoggledTextOpacity;
    }
    if (_showLegendIcon) {
      final Size halfIconSize =
          _iconShape.getPreferredSize(_legendSettings.iconSize, _themeData) / 2;
      actualOffset =
          offset + Offset(0, (size.height - (halfIconSize.height * 2)) / 2);
      _iconShape.paint(context, actualOffset,
          parentBox: this,
          iconSize: _legendSettings.iconSize,
          color: iconColor ?? Colors.transparent,
          iconType: _legendSettings.iconType);
    }

    _textPainter.text = TextSpan(
        style: _legendSettings.textStyle.copyWith(
            color: _legendSettings.textStyle.color
                .withOpacity(toggledLegendItemOpacity)),
        text: _text);
    _textPainter.layout();
    actualOffset = offset +
        Offset(
            (_showLegendIcon ? _legendSettings.iconSize.width : 0.0) + _spacing,
            (size.height - _textPainter.height) / 2);
    _textPainter.paint(context.canvas, actualOffset);
  }
}
