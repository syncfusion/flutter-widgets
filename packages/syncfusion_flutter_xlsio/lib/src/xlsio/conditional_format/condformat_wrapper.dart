part of xlsio;

/// Summary description for ConditionalFormatWrapper.
class _ConditionalFormatWrapper implements ConditionalFormat {
  /// Creates new instance of the Conditional Format wrapper.
  _ConditionalFormatWrapper(_CondFormatCollectionWrapper formats, int iIndex) {
    _formats = formats;
    if (iIndex < 0 || iIndex >= formats._condFormats!.count) {
      throw Exception('iIndex');
    }
    _iIndex = iIndex;
  }

  /// Parent conditional formats wrapper.
  late _CondFormatCollectionWrapper _formats;

  /// Condition index.
  late int _iIndex;

  /// Number of begin update calls that have no corresponding end update.
  int _iBeginCount = 0;

  /// Gets AboveBelowAverage conditional formatting rule. Read-only.
  _AboveBelowAverageWrapper? _aboveBelowAverage;

  /// Gets TopBottom conditional formatting rule. Read-only.
  _TopBottomWrapper? _topBottom;

  /// Wrapper over color scale object.
  _ColorScaleWrapper? _colorScale;

  /// Wrapper over icon set object.
  _IconSetWrapper? _iconSet;

  /// Wrapper over data bar object.
  _DataBarWrapper? _dataBar;

  /// RangeImpl.
  Range? _range;

  @override

  /// Gets or sets the type of the conditional format.
  ExcelCFType get formatType {
    return _getCondition().formatType;
  }

  @override

  /// Gets or sets the type of the conditional format.
  set formatType(ExcelCFType value) {
    _getCondition().formatType = value;
  }

  @override

  ///  Gets or sets one of the constants of <see cref="CFTimePeriods"/> enumeration
  ///  which represents the type of the time period.
  CFTimePeriods get timePeriodType {
    return _getCondition().timePeriodType;
  }

  @override

  ///  Gets or sets one of the constants of <see cref="CFTimePeriods"/> enumeration
  ///  which represents the type of the time period.
  set timePeriodType(CFTimePeriods value) {
    _getCondition().timePeriodType = value;
  }

  @override

  /// Gets or sets the comparison operator for the conditional format.
  ExcelComparisonOperator get operator {
    return _getCondition().operator;
  }

  @override

  /// Gets or sets the comparison operator for the conditional format.
  set operator(ExcelComparisonOperator value) {
    _getCondition().operator = value;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is bold.
  bool get isBold {
    return _getCondition().isBold;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is bold.
  set isBold(bool value) {
    _getCondition().isBold = value;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is Italic.
  bool get isItalic {
    return _getCondition().isItalic;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is Italic.
  set isItalic(bool value) {
    _getCondition().isItalic = value;
  }

  @override

  /// Gets or sets the font color from predefined colors.
  String get fontColor {
    return _getCondition().fontColor;
  }

  @override

  /// Gets or sets the font color from predefined colors.
  set fontColor(String value) {
    _getCondition().fontColor = value;
  }

  @override

  /// Gets or sets the underline type for the conditional format.
  bool get underline {
    return _getCondition().underline;
  }

  @override

  /// Gets or sets the underline type for the conditional format.
  set underline(bool value) {
    _getCondition().underline = value;
  }

  @override

  /// Gets or sets the left border color from predefined colors.
  String get leftBorderColor {
    return _getCondition().leftBorderColor;
  }

  @override

  /// Gets or sets the left border color from predefined colors.
  set leftBorderColor(String value) {
    _getCondition().leftBorderColor = value;
  }

  @override

  /// Gets or sets the right border color from predefined colors.
  String get rightBorderColor {
    return _getCondition().rightBorderColor;
  }

  @override

  /// Gets or sets the right border color from predefined colors.
  set rightBorderColor(String value) {
    _getCondition().rightBorderColor = value;
  }

  @override

  /// Gets or sets the top border color from predefined colors.
  String get topBorderColor {
    return _getCondition().topBorderColor;
  }

  @override

  /// Gets or sets the top border color from predefined colors.
  set topBorderColor(String value) {
    _getCondition().topBorderColor = value;
  }

  @override

  /// Gets or sets the bottom border color from predefined colors.
  String get bottomBorderColor {
    return _getCondition().bottomBorderColor;
  }

  @override

  /// Gets or sets the bottom border color from predefined colors.
  set bottomBorderColor(String value) {
    _getCondition().bottomBorderColor = value;
  }

  @override

  /// Gets or sets the left border Style from predefined Styles.
  LineStyle get leftBorderStyle {
    return _getCondition().leftBorderStyle;
  }

  @override

  /// Gets or sets the left border Style from predefined Styles.
  set leftBorderStyle(LineStyle value) {
    _getCondition().leftBorderStyle = value;
  }

  @override

  /// Gets or sets the right border Style from predefined Styles.
  LineStyle get rightBorderStyle {
    return _getCondition().rightBorderStyle;
  }

  @override

  /// Gets or sets the right border Style from predefined Styles.
  set rightBorderStyle(LineStyle value) {
    _getCondition().rightBorderStyle = value;
  }

  @override

  /// Gets or sets the top border Style from predefined Styles.
  LineStyle get topBorderStyle {
    return _getCondition().topBorderStyle;
  }

  @override

  /// Gets or sets the top border Style from predefined Styles.
  set topBorderStyle(LineStyle value) {
    _getCondition().topBorderStyle = value;
  }

  @override

  /// Gets or sets the bottom border Style from predefined Styles.
  LineStyle get bottomBorderStyle {
    return _getCondition().bottomBorderStyle;
  }

  @override

  /// Gets or sets the bottom border Style from predefined Styles.
  set bottomBorderStyle(LineStyle value) {
    _getCondition().bottomBorderStyle = value;
  }

  @override

  /// Gets or sets the value or expression associated with the conditional format.
  String get firstFormula {
    return _getCondition().firstFormula;
  }

  @override

  /// Gets or sets the value or expression associated with the conditional format.
  set firstFormula(String value) {
    _getCondition().firstFormula = value;
  }

  @override

  /// Gets or sets the value or expression associated with the second conditional format.
  String get secondFormula {
    return _getCondition().secondFormula;
  }

  @override

  /// Gets or sets the value or expression associated with the second conditional format.
  set secondFormula(String value) {
    _getCondition().secondFormula = value;
  }

  @override

  /// Gets or sets the background color from predefined colors.
  String get backColor {
    return _getCondition().backColor;
  }

  @override

  /// Gets or sets the background color from predefined colors.
  set backColor(String value) {
    _getCondition().backColor = value;
  }

  @override

  /// Gets or sets number format index of the conditional format rule.
  String? get numberFormat {
    return _getCondition().numberFormat;
  }

  @override

  /// Gets or sets number format index of the conditional format rule.
  set numberFormat(String? value) {
    _getCondition().numberFormat = value;
  }

  @override

  /// Gets or sets a boolean value that determines if additional formatting rules on the cell should be evaluated
  /// if the current rule evaluates to True.
  bool get stopIfTrue {
    return _getCondition().stopIfTrue;
  }

  @override

  /// Gets or sets a boolean value that determines if additional formatting rules on the cell should be evaluated
  /// if the current rule evaluates to True.
  set stopIfTrue(bool value) {
    _getCondition().stopIfTrue = value;
  }

  @override

  /// Gets or sets the text value used in <inheritdoc>SpecificText</inheritdoc> conditional formatting rule.
  /// The default value is null.
  String? get text {
    return _getCondition().text;
  }

  @override

  /// Gets or sets the text value used in <inheritdoc>SpecificText</inheritdoc> conditional formatting rule.
  /// The default value is null.
  set text(String? value) {
    _getCondition().text = value;
  }

  /// Gets unwrapped condition.
  _ConditionalFormatImpl _getCondition() {
    return _formats._condFormats!.conditionalFormat[_iIndex];
  }

  @override

  /// Gets TopBottom conditional formatting rule. Read-only.
  TopBottom? get topBottom {
    if (formatType == ExcelCFType.topBottom) {
      _topBottom ??=
          _TopBottomWrapper(_getCondition().topBottom! as _TopBottomImpl, this);
    } else {
      _topBottom = null;
    }
    return _topBottom;
  }

  @override
  set topBottom(TopBottom? value) {
    _topBottom = value! as _TopBottomWrapper;
  }

  @override

  /// Gets AboveBelowAverage conditional formatting rule. Read-only.
  AboveBelowAverage? get aboveBelowAverage {
    if (formatType == ExcelCFType.aboveBelowAverage) {
      _aboveBelowAverage ??= _AboveBelowAverageWrapper(
          _getCondition().aboveBelowAverage! as _AboveBelowAverageImpl, this);
    } else {
      _aboveBelowAverage = null;
    }

    return _aboveBelowAverage;
  }

  @override
  set aboveBelowAverage(AboveBelowAverage? value) {
    _aboveBelowAverage = value! as _AboveBelowAverageWrapper;
  }

  @override

  /// Gets color scale conditional formatting rule. Read-only.
  ColorScale? get colorScale {
    if (formatType == ExcelCFType.colorScale) {
      _colorScale ??= _ColorScaleWrapper(
          _getCondition().colorScale! as _ColorScaleImpl, this);
    } else {
      _colorScale = null;
    }

    return _colorScale;
  }

  @override
  set colorScale(ColorScale? value) {
    _colorScale = value! as _ColorScaleWrapper;
  }

  @override

  /// Gets color scale conditional formatting rule. Read-only.
  IconSet? get iconSet {
    if (formatType == ExcelCFType.iconSet) {
      _iconSet ??=
          _IconSetWrapper(_getCondition().iconSet! as _IconSetImpl, this);
    } else {
      _iconSet = null;
    }

    return _iconSet;
  }

  @override
  set iconSet(IconSet? value) {
    _iconSet = value! as _IconSetWrapper;
  }

  @override

  /// Gets color scale conditional formatting rule. Read-only.
  DataBar? get dataBar {
    if (formatType == ExcelCFType.dataBar) {
      _dataBar ??=
          _DataBarWrapper(_getCondition().dataBar! as _DataBarImpl, this);
    } else {
      _dataBar = null;
    }

    return _dataBar;
  }

  @override
  set dataBar(DataBar? value) {
    _dataBar = value! as _DataBarWrapper;
  }

  /// This method should be called before several updates to the object will take place.
  void _beginUpdate() {
    if (_iBeginCount == 0) {
      _formats._beginUpdate();
    }

    _iBeginCount++;
  }

  /// This method should be called after several updates to the object took place.
  void _endUpdate() {
    if (_iBeginCount > 0) {
      _iBeginCount--;
    }

    if (_iBeginCount == 0) {
      _formats._endUpdate();
    }
  }

  @override

  /// Gets the value or expression associated with the conditional format
  /// in R1C1 notation.
  String get firstFormulaR1C1 {
    return _getCondition().firstFormulaR1C1;
  }

  @override

  /// sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  set firstFormulaR1C1(String value) {
    _getCondition()._range = _range;
    _getCondition().firstFormulaR1C1 = value;
  }

  @override

  /// Gets the value or expression associated with the conditional format
  /// in R1C1 notation.
  String get secondFormulaR1C1 {
    return _getCondition().secondFormulaR1C1;
  }

  @override

  /// sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  set secondFormulaR1C1(String value) {
    _getCondition()._range = _range;
    _getCondition().secondFormulaR1C1 = value;
  }

  @override

  /// Gets or sets the font color from Rgb.
  Color get fontColorRgb {
    return _getCondition().fontColorRgb;
  }

  @override

  /// Gets or sets the font color from Rgb.
  set fontColorRgb(Color value) {
    _getCondition().fontColorRgb = value;
  }

  @override

  /// Gets or sets the background color from Rgb.
  Color get backColorRgb {
    return _getCondition().backColorRgb;
  }

  @override

  /// Gets or sets the background color from Rgb.
  set backColorRgb(Color value) {
    _getCondition().backColorRgb = value;
  }

  @override

  /// Gets or sets the left border color from Rgb.
  Color get leftBorderColorRgb {
    return _getCondition().leftBorderColorRgb;
  }

  @override

  /// Gets or sets the left border color from Rgb.
  set leftBorderColorRgb(Color value) {
    _getCondition().leftBorderColorRgb = value;
  }

  @override

  /// Gets or sets the right border color from Rgb.
  Color get rightBorderColorRgb {
    return _getCondition().rightBorderColorRgb;
  }

  @override

  /// Gets or sets the right border color from Rgb.
  set rightBorderColorRgb(Color value) {
    _getCondition().rightBorderColorRgb = value;
  }

  @override

  /// Gets or sets the top border color from Rgb.
  Color get topBorderColorRgb {
    return _getCondition().topBorderColorRgb;
  }

  @override

  /// Gets or sets the top border color from Rgb.
  set topBorderColorRgb(Color value) {
    _getCondition().topBorderColorRgb = value;
  }

  @override

  /// Gets or sets the bottom border color from Rgb.
  Color get bottomBorderColorRgb {
    return _getCondition().bottomBorderColorRgb;
  }

  @override

  /// Gets or sets the bottom border color from Rgb.
  set bottomBorderColorRgb(Color value) {
    _getCondition().bottomBorderColorRgb = value;
  }
}
