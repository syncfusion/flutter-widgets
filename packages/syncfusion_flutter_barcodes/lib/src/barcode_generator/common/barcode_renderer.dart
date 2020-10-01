part of barcodes;

/// Represents the render object widget
class _SfBarcodeGeneratorRenderObjectWidget extends LeafRenderObjectWidget {
  /// Creates the render object widget
  const _SfBarcodeGeneratorRenderObjectWidget(
      {Key key,
      this.value,
      this.symbology,
      this.foregroundColor,
      this.showText,
      this.textSpacing,
      this.textStyle,
      this.textSize,
      this.textAlign})
      : super(key: key);

  ///Defines the value of the barcode to be rendered.
  final String value;

  ///Define anyone of barcode symbology that will be used to
  ///convert input value into visual barcode representation
  final Symbology symbology;

  /// Define the color for barcode elements.
  final Color foregroundColor;

  /// Specifies whether to show the value along with the barcode.
  final bool showText;

  /// Specifies the spacing between the text and the barcode.
  final double textSpacing;

  ///Defines the text alignment for the text to be rendered in the barcode.
  final TextStyle textStyle;

  /// Add style to customize the text.
  final Size textSize;

  /// Specifies the spacing between the text and the barcode.
  final TextAlign textAlign;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBarcode(
        value: value,
        symbology: symbology,
        foregroundColor: foregroundColor,
        showText: showText,
        textSpacing: textSpacing,
        textStyle: textStyle,
        textSize: textSize,
        textAlign: textAlign);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderBarcode renderObject) {
    renderObject
      ..value = value
      ..symbology = symbology
      ..foregroundColor = foregroundColor
      ..showText = showText
      ..textSpacing = textSpacing
      ..textStyle = textStyle
      ..textSize = textSize
      ..textAlign = textAlign;
  }
}

/// Represents the RenderBarcode class
class _RenderBarcode extends RenderBox {
  /// Creates the RenderBarcode
  _RenderBarcode(
      {@required String value,
      Symbology symbology,
      Color foregroundColor,
      bool showText,
      double textSpacing,
      TextStyle textStyle,
      Size textSize,
      TextAlign textAlign})
      : _value = value,
        _symbology = symbology,
        _foregroundColor = foregroundColor,
        _showText = showText,
        _textSpacing = textSpacing,
        _textStyle = textStyle,
        _textSize = textSize,
        _textAlign = textAlign;

  /// Represents the barcode value
  String _value;

  /// Define anyone of barcode symbology that will be
  /// used to convert input value into visual barcode representation
  Symbology _symbology;

  /// Define the color for barcode elements.
  Color _foregroundColor;

  /// Specifies whether to show the value along with the barcode.
  bool _showText;

  ///Specifies the spacing between the text and the barcode.
  double _textSpacing;

  /// Defines the text alignment for the text to be rendered in the barcode.
  TextStyle _textStyle;

  /// Add style to customize the text.
  Size _textSize;

  /// Specifies the spacing between the text and the barcode.
  TextAlign _textAlign;

  /// Returns the value
  String get value => _value;

  /// Returns the symbology value
  Symbology get symbology => _symbology;

  /// Returns the foreground color
  Color get foregroundColor => _foregroundColor;

  /// Returns the show text value
  bool get showText => _showText;

  /// Returns the text spacing value
  double get textSpacing => _textSpacing;

  /// Returns the text style value
  TextStyle get textStyle => _textStyle;

  /// Returns the text size value
  Size get textSize => _textSize;

  /// Returns the text align value
  TextAlign get textAlign => _textAlign;

  /// Set the value
  set value(String value) {
    if (_value != value) {
      _value = value;
      markNeedsPaint();
    }
  }

  /// Set the symbology value
  set symbology(Symbology value) {
    if (_symbology != value) {
      _symbology = value;
      markNeedsPaint();
    }
  }

  /// Set the foreground color
  set foregroundColor(Color value) {
    if (_foregroundColor != value) {
      _foregroundColor = value;
      markNeedsPaint();
    }
  }

  /// To set the value to show text
  set showText(bool value) {
    if (_showText != value) {
      _showText = value;
      markNeedsPaint();
    }
  }

  /// To set the value of text spacing
  set textSpacing(double value) {
    if (_textSpacing != value) {
      _textSpacing = value;
      markNeedsPaint();
    }
  }

  /// To set the text style value
  set textStyle(TextStyle value) {
    if (_textStyle != value) {
      _textStyle = value;
      markNeedsPaint();
    }
  }

  /// Sets the text size value
  set textSize(Size value) {
    if (_textSize != value) {
      _textSize = value;
      markNeedsPaint();
    }
  }

  /// Sets the text align value
  set textAlign(TextAlign value) {
    if (_textAlign != value) {
      _textAlign = value;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    const double minHeight = 350;
    const double minWidth = 350;
    double height = constraints.maxHeight;
    double width = constraints.maxWidth;
    if (height == double.infinity) {
      height = minHeight;
    }
    if (width == double.infinity) {
      width = minWidth;
    }

    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    symbology._renderBarcode(
        context.canvas,
        Size(
            size.width,
            size.height -
                (showText
                    ? (_textSpacing +
                        (_textSize != null ? _textSize.height : 0))
                    : 0)),
        offset,
        value,
        foregroundColor,
        textStyle,
        textSpacing,
        textAlign,
        showText);
  }
}
