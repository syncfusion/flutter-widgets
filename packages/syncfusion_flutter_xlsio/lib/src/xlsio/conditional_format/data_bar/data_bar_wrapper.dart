part of xlsio;

/// Represents a wrapper over data bar conditional formatting rule. Applying
/// a data bar to a range helps you see the value of a cell relative to other cells.
class _DataBarWrapper implements DataBar {
  /// Initializes new instance of the wrapper.
  _DataBarWrapper(_DataBarImpl dataBar, _ConditionalFormatWrapper format) {
    _wrapped = dataBar;
    _format = format;
  }

  /// Wrapped data bar object.
  late _DataBarImpl _wrapped;

  /// Parent conditional format wrapper.
  late _ConditionalFormatWrapper _format;

  /// Returns a ConditionValue object which specifies how the shortest bar is evaluated
  /// for a data bar conditional format.

  @override
  ConditionValue get minPoint {
    {
      return _wrapped.minPoint;
    }
  }

  @override
  set minPoint(ConditionValue value) {
    _beginUpdate();
    _wrapped.minPoint = value;
    _endUpdate();
  }

  @override

  /// Returns a ConditionValue object which specifies how the longest bar is evaluated
  /// for a data bar conditional format.
  ConditionValue get maxPoint {
    {
      return _wrapped.maxPoint;
    }
  }

  @override
  set maxPoint(ConditionValue value) {
    _beginUpdate();
    _wrapped.maxPoint = value;
    _endUpdate();
  }

  @override

  /// Gets/sets the color of the bars in a data bar conditional format.
  String get barColor {
    {
      return _wrapped.barColor;
    }
  }

  @override
  set barColor(String value) {
    _beginUpdate();
    _wrapped.barColor = value;
    _endUpdate();
  }

  @override

  /// Returns or sets a value that specifies the length of the longest
  /// data bar as a percentage of cell width.
  int get percentMax {
    {
      return _wrapped.percentMax;
    }
  }

  @override
  set percentMax(int value) {
    _beginUpdate();
    _wrapped.percentMax = value;
    _endUpdate();
  }

  @override

  /// Returns or sets a value that specifies the length of the shortest
  /// data bar as a percentage of cell width.
  int get percentMin {
    {
      return _wrapped.percentMin;
    }
  }

  @override
  set percentMin(int value) {
    _beginUpdate();
    _wrapped.percentMin = value;
    _endUpdate();
  }

  @override

  /// Returns or sets a Boolean value that specifies if the value in the cell
  /// is displayed if the data bar conditional format is applied to the range.
  bool get showValue {
    {
      return _wrapped.showValue;
    }
  }

  @override
  set showValue(bool value) {
    _beginUpdate();
    _wrapped.showValue = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the axis color of the data bar.
  /// This element MUST exist if and only if axisPosition does not equal "none".
  String get barAxisColor {
    {
      return _wrapped.barAxisColor;
    }
  }

  @override
  set barAxisColor(String value) {
    _beginUpdate();
    _wrapped.barAxisColor = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the border color of the data bar.
  /// This element MUST exist if and only if border equals "true".
  String get borderColor {
    {
      return _wrapped.borderColor;
    }
  }

  @override
  set borderColor(String value) {
    _beginUpdate();
    _wrapped.borderColor = value;
    _endUpdate();
  }

  @override

  /// Gets whether the data bar has a border.
  bool get hasBorder {
    {
      return _wrapped.hasBorder;
    }
  }

  @override
  set hasBorder(bool value) {
    _wrapped.hasBorder = value;
  }

  @override

  /// Gets or sets whether the data bar has a gradient fill.
  bool get hasGradientFill {
    {
      return _wrapped.hasGradientFill;
    }
  }

  @override
  set hasGradientFill(bool value) {
    _wrapped.hasGradientFill = value;
  }

  @override

  /// Gets or sets the direction of the data bar.
  DataBarDirection get dataBarDirection {
    {
      return _wrapped.dataBarDirection;
    }
  }

  @override
  set dataBarDirection(DataBarDirection value) {
    _beginUpdate();
    _wrapped.dataBarDirection = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the negative border color of the data bar.
  /// This element MUST exist if and only if negativeBarborderColorSameAsPositive equals "false" and border equals "true".
  String get negativeBorderColor {
    {
      return _wrapped.negativeBorderColor;
    }
  }

  @override
  set negativeBorderColor(String value) {
    _beginUpdate();
    _wrapped.negativeBorderColor = value;
    _endUpdate();
  }

  @override

  /// Gest or sests the negative fill color of the data bar.
  /// This element MUST exist if and only if negativebarColorSameAsPositive equals "false".
  String get negativeFillColor {
    return _wrapped.negativeFillColor;
  }

  @override
  set negativeFillColor(String value) {
    _beginUpdate();
    _wrapped.negativeFillColor = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the axis position for the data bar.
  DataBarAxisPosition get dataBarAxisPosition {
    {
      return _wrapped.dataBarAxisPosition;
    }
  }

  @override
  set dataBarAxisPosition(DataBarAxisPosition value) {
    _beginUpdate();
    _wrapped.dataBarAxisPosition = value;
    _endUpdate();
  }

  /// This method should be called before several updates to the object will take place.
  void _beginUpdate() {
    _format._beginUpdate();
    _wrapped = _format._getCondition().dataBar! as _DataBarImpl;
  }

  /// This method should be called after several updates to the object took place.
  void _endUpdate() {
    _format._endUpdate();
  }

  @override

  /// Gets/sets the color of the bars in a data bar conditional format.
  Color get barColorRgb {
    return _wrapped.barColorRgb;
  }

  @override
  set barColorRgb(Color value) {
    _beginUpdate();
    _wrapped.barColorRgb = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the negative border color of the data bar.
  /// This element MUST exist if and only if negativeBarborderColorSameAsPositive equals "false" and border equals "true".
  Color get negativeBorderColorRgb {
    return _wrapped.negativeBorderColorRgb;
  }

  @override
  set negativeBorderColorRgb(Color value) {
    _beginUpdate();
    _wrapped.negativeBorderColorRgb = value;
    _endUpdate();
  }

  @override

  /// Gest or sests the negative fill color of the data bar.
  /// This element MUST exist if and only if negativebarColorSameAsPositive equals "false".
  Color get negativeFillColorRgb {
    return _wrapped.negativeFillColorRgb;
  }

  @override
  set negativeFillColorRgb(Color value) {
    _beginUpdate();
    _wrapped.negativeFillColorRgb = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the axis color of the data bar in Rgb.
  /// This element MUST exist if and only if axisPosition does not equal "none".
  Color get barAxisColorRgb {
    {
      return _wrapped.barAxisColorRgb;
    }
  }

  @override
  set barAxisColorRgb(Color value) {
    _beginUpdate();
    _wrapped.barAxisColorRgb = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the border color of the data bar in Rgb.
  /// This element MUST exist if and only if border equals "true".
  Color get borderColorRgb {
    {
      return _wrapped.borderColorRgb;
    }
  }

  @override
  set borderColorRgb(Color value) {
    _beginUpdate();
    _wrapped.borderColorRgb = value;
    _endUpdate();
  }
}
