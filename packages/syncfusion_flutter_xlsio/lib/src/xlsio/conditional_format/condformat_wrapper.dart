import 'dart:ui';

import '../conditional_format/above_below_average/above_below_average.dart';
import '../conditional_format/above_below_average/above_below_average_impl.dart';
import '../conditional_format/above_below_average/above_below_average_wrapper.dart';
import '../conditional_format/color_scale/color_scale.dart';
import '../conditional_format/color_scale/color_scale_impl.dart';
import '../conditional_format/color_scale/color_scale_wrapper.dart';
import '../conditional_format/data_bar/data_bar.dart';
import '../conditional_format/data_bar/data_bar_impl.dart';
import '../conditional_format/data_bar/data_bar_wrapper.dart';
import '../conditional_format/icon_set/icon_set.dart';
import '../conditional_format/icon_set/icon_set_impl.dart';
import '../conditional_format/icon_set/icon_set_wrapper.dart';
import '../conditional_format/top_bottom/top_bottom.dart';
import '../conditional_format/top_bottom/top_bottom_impl.dart';
import '../conditional_format/top_bottom/top_bottom_wrapper.dart';
import '../general/enums.dart';
import '../range/range.dart';
import 'condformat_collection_wrapper.dart';
import 'conditionalformat.dart';
import 'conditionalformat_impl.dart';

/// Summary description for ConditionalFormatWrapper.
class ConditionalFormatWrapper implements ConditionalFormat {
  /// Creates new instance of the Conditional Format wrapper.
  ConditionalFormatWrapper(CondFormatCollectionWrapper formats, int iIndex) {
    _formats = formats;
    if (iIndex < 0 || iIndex >= formats.condFormats!.count) {
      throw Exception('iIndex');
    }
    _iIndex = iIndex;
  }

  /// Parent conditional formats wrapper.
  late CondFormatCollectionWrapper _formats;

  /// Condition index.
  late int _iIndex;

  /// Number of begin update calls that have no corresponding end update.
  int _iBeginCount = 0;

  /// Gets AboveBelowAverage conditional formatting rule. Read-only.
  AboveBelowAverageWrapper? _aboveBelowAverage;

  /// Gets TopBottom conditional formatting rule. Read-only.
  TopBottomWrapper? _topBottom;

  /// Wrapper over color scale object.
  ColorScaleWrapper? _colorScale;

  /// Wrapper over icon set object.
  IconSetWrapper? _iconSet;

  /// Wrapper over data bar object.
  DataBarWrapper? _dataBar;

  /// RangeImpl.
  Range? range;

  @override

  /// Gets or sets the type of the conditional format.
  ExcelCFType get formatType {
    return getCondition().formatType;
  }

  @override

  /// Gets or sets the type of the conditional format.
  set formatType(ExcelCFType value) {
    getCondition().formatType = value;
  }

  @override

  ///  Gets or sets one of the constants of see cref="CFTimePeriods" enumeration
  ///  which represents the type of the time period.
  CFTimePeriods get timePeriodType {
    return getCondition().timePeriodType;
  }

  @override

  ///  Gets or sets one of the constants of see cref="CFTimePeriods" enumeration
  ///  which represents the type of the time period.
  set timePeriodType(CFTimePeriods value) {
    getCondition().timePeriodType = value;
  }

  @override

  /// Gets or sets the comparison operator for the conditional format.
  ExcelComparisonOperator get operator {
    return getCondition().operator;
  }

  @override

  /// Gets or sets the comparison operator for the conditional format.
  set operator(ExcelComparisonOperator value) {
    getCondition().operator = value;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is bold.
  bool get isBold {
    return getCondition().isBold;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is bold.
  set isBold(bool value) {
    getCondition().isBold = value;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is Italic.
  bool get isItalic {
    return getCondition().isItalic;
  }

  @override

  /// Gets or sets a boolean value indicating whether the font is Italic.
  set isItalic(bool value) {
    getCondition().isItalic = value;
  }

  @override

  /// Gets or sets the font color from predefined colors.
  String get fontColor {
    return getCondition().fontColor;
  }

  @override

  /// Gets or sets the font color from predefined colors.
  set fontColor(String value) {
    getCondition().fontColor = value;
  }

  @override

  /// Gets or sets the underline type for the conditional format.
  bool get underline {
    return getCondition().underline;
  }

  @override

  /// Gets or sets the underline type for the conditional format.
  set underline(bool value) {
    getCondition().underline = value;
  }

  @override

  /// Gets or sets the left border color from predefined colors.
  String get leftBorderColor {
    return getCondition().leftBorderColor;
  }

  @override

  /// Gets or sets the left border color from predefined colors.
  set leftBorderColor(String value) {
    getCondition().leftBorderColor = value;
  }

  @override

  /// Gets or sets the right border color from predefined colors.
  String get rightBorderColor {
    return getCondition().rightBorderColor;
  }

  @override

  /// Gets or sets the right border color from predefined colors.
  set rightBorderColor(String value) {
    getCondition().rightBorderColor = value;
  }

  @override

  /// Gets or sets the top border color from predefined colors.
  String get topBorderColor {
    return getCondition().topBorderColor;
  }

  @override

  /// Gets or sets the top border color from predefined colors.
  set topBorderColor(String value) {
    getCondition().topBorderColor = value;
  }

  @override

  /// Gets or sets the bottom border color from predefined colors.
  String get bottomBorderColor {
    return getCondition().bottomBorderColor;
  }

  @override

  /// Gets or sets the bottom border color from predefined colors.
  set bottomBorderColor(String value) {
    getCondition().bottomBorderColor = value;
  }

  @override

  /// Gets or sets the left border Style from predefined Styles.
  LineStyle get leftBorderStyle {
    return getCondition().leftBorderStyle;
  }

  @override

  /// Gets or sets the left border Style from predefined Styles.
  set leftBorderStyle(LineStyle value) {
    getCondition().leftBorderStyle = value;
  }

  @override

  /// Gets or sets the right border Style from predefined Styles.
  LineStyle get rightBorderStyle {
    return getCondition().rightBorderStyle;
  }

  @override

  /// Gets or sets the right border Style from predefined Styles.
  set rightBorderStyle(LineStyle value) {
    getCondition().rightBorderStyle = value;
  }

  @override

  /// Gets or sets the top border Style from predefined Styles.
  LineStyle get topBorderStyle {
    return getCondition().topBorderStyle;
  }

  @override

  /// Gets or sets the top border Style from predefined Styles.
  set topBorderStyle(LineStyle value) {
    getCondition().topBorderStyle = value;
  }

  @override

  /// Gets or sets the bottom border Style from predefined Styles.
  LineStyle get bottomBorderStyle {
    return getCondition().bottomBorderStyle;
  }

  @override

  /// Gets or sets the bottom border Style from predefined Styles.
  set bottomBorderStyle(LineStyle value) {
    getCondition().bottomBorderStyle = value;
  }

  @override

  /// Gets or sets the value or expression associated with the conditional format.
  String get firstFormula {
    return getCondition().firstFormula;
  }

  @override

  /// Gets or sets the value or expression associated with the conditional format.
  set firstFormula(String value) {
    getCondition().firstFormula = value;
  }

  @override

  /// Gets or sets the value or expression associated with the second conditional format.
  String get secondFormula {
    return getCondition().secondFormula;
  }

  @override

  /// Gets or sets the value or expression associated with the second conditional format.
  set secondFormula(String value) {
    getCondition().secondFormula = value;
  }

  @override

  /// Gets or sets the background color from predefined colors.
  String get backColor {
    return getCondition().backColor;
  }

  @override

  /// Gets or sets the background color from predefined colors.
  set backColor(String value) {
    getCondition().backColor = value;
  }

  @override

  /// Gets or sets number format index of the conditional format rule.
  String? get numberFormat {
    return getCondition().numberFormat;
  }

  @override

  /// Gets or sets number format index of the conditional format rule.
  set numberFormat(String? value) {
    getCondition().numberFormat = value;
  }

  @override

  /// Gets or sets a boolean value that determines if additional formatting rules on the cell should be evaluated
  /// if the current rule evaluates to True.
  bool get stopIfTrue {
    return getCondition().stopIfTrue;
  }

  @override

  /// Gets or sets a boolean value that determines if additional formatting rules on the cell should be evaluated
  /// if the current rule evaluates to True.
  set stopIfTrue(bool value) {
    getCondition().stopIfTrue = value;
  }

  @override

  /// Gets or sets the text value used in SpecificText conditional formatting rule.
  /// The default value is null.
  String? get text {
    return getCondition().text;
  }

  @override

  /// Gets or sets the text value used in SpecificText conditional formatting rule.
  /// The default value is null.
  set text(String? value) {
    getCondition().text = value;
  }

  /// Gets unwrapped condition.
  ConditionalFormatImpl getCondition() {
    return _formats.condFormats!.conditionalFormat[_iIndex];
  }

  @override

  /// Gets TopBottom conditional formatting rule. Read-only.
  TopBottom? get topBottom {
    if (formatType == ExcelCFType.topBottom) {
      _topBottom ??=
          TopBottomWrapper(getCondition().topBottom! as TopBottomImpl, this);
    } else {
      _topBottom = null;
    }
    return _topBottom;
  }

  @override
  set topBottom(TopBottom? value) {
    _topBottom = value! as TopBottomWrapper;
  }

  @override

  /// Gets AboveBelowAverage conditional formatting rule. Read-only.
  AboveBelowAverage? get aboveBelowAverage {
    if (formatType == ExcelCFType.aboveBelowAverage) {
      _aboveBelowAverage ??= AboveBelowAverageWrapper(
          getCondition().aboveBelowAverage! as AboveBelowAverageImpl, this);
    } else {
      _aboveBelowAverage = null;
    }

    return _aboveBelowAverage;
  }

  @override
  set aboveBelowAverage(AboveBelowAverage? value) {
    _aboveBelowAverage = value! as AboveBelowAverageWrapper;
  }

  @override

  /// Gets color scale conditional formatting rule. Read-only.
  ColorScale? get colorScale {
    if (formatType == ExcelCFType.colorScale) {
      _colorScale ??=
          ColorScaleWrapper(getCondition().colorScale! as ColorScaleImpl, this);
    } else {
      _colorScale = null;
    }

    return _colorScale;
  }

  @override
  set colorScale(ColorScale? value) {
    _colorScale = value! as ColorScaleWrapper;
  }

  @override

  /// Gets color scale conditional formatting rule. Read-only.
  IconSet? get iconSet {
    if (formatType == ExcelCFType.iconSet) {
      _iconSet ??= IconSetWrapper(getCondition().iconSet! as IconSetImpl, this);
    } else {
      _iconSet = null;
    }

    return _iconSet;
  }

  @override
  set iconSet(IconSet? value) {
    _iconSet = value! as IconSetWrapper;
  }

  @override

  /// Gets color scale conditional formatting rule. Read-only.
  DataBar? get dataBar {
    if (formatType == ExcelCFType.dataBar) {
      _dataBar ??= DataBarWrapper(getCondition().dataBar! as DataBarImpl, this);
    } else {
      _dataBar = null;
    }

    return _dataBar;
  }

  @override
  set dataBar(DataBar? value) {
    _dataBar = value! as DataBarWrapper;
  }

  /// This method should be called before several updates to the object will take place.
  void beginUpdate() {
    if (_iBeginCount == 0) {
      _formats.beginUpdate();
    }

    _iBeginCount++;
  }

  /// This method should be called after several updates to the object took place.
  void endUpdate() {
    if (_iBeginCount > 0) {
      _iBeginCount--;
    }

    if (_iBeginCount == 0) {
      _formats.endUpdate();
    }
  }

  @override

  /// Gets the value or expression associated with the conditional format
  /// in R1C1 notation.
  String get firstFormulaR1C1 {
    return getCondition().firstFormulaR1C1;
  }

  @override

  /// sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  set firstFormulaR1C1(String value) {
    getCondition().range = range;
    getCondition().firstFormulaR1C1 = value;
  }

  @override

  /// Gets the value or expression associated with the conditional format
  /// in R1C1 notation.
  String get secondFormulaR1C1 {
    return getCondition().secondFormulaR1C1;
  }

  @override

  /// sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  set secondFormulaR1C1(String value) {
    getCondition().range = range;
    getCondition().secondFormulaR1C1 = value;
  }

  @override

  /// Gets or sets the font color from Rgb.
  Color get fontColorRgb {
    return getCondition().fontColorRgb;
  }

  @override

  /// Gets or sets the font color from Rgb.
  set fontColorRgb(Color value) {
    getCondition().fontColorRgb = value;
  }

  @override

  /// Gets or sets the background color from Rgb.
  Color get backColorRgb {
    return getCondition().backColorRgb;
  }

  @override

  /// Gets or sets the background color from Rgb.
  set backColorRgb(Color value) {
    getCondition().backColorRgb = value;
  }

  @override

  /// Gets or sets the left border color from Rgb.
  Color get leftBorderColorRgb {
    return getCondition().leftBorderColorRgb;
  }

  @override

  /// Gets or sets the left border color from Rgb.
  set leftBorderColorRgb(Color value) {
    getCondition().leftBorderColorRgb = value;
  }

  @override

  /// Gets or sets the right border color from Rgb.
  Color get rightBorderColorRgb {
    return getCondition().rightBorderColorRgb;
  }

  @override

  /// Gets or sets the right border color from Rgb.
  set rightBorderColorRgb(Color value) {
    getCondition().rightBorderColorRgb = value;
  }

  @override

  /// Gets or sets the top border color from Rgb.
  Color get topBorderColorRgb {
    return getCondition().topBorderColorRgb;
  }

  @override

  /// Gets or sets the top border color from Rgb.
  set topBorderColorRgb(Color value) {
    getCondition().topBorderColorRgb = value;
  }

  @override

  /// Gets or sets the bottom border color from Rgb.
  Color get bottomBorderColorRgb {
    return getCondition().bottomBorderColorRgb;
  }

  @override

  /// Gets or sets the bottom border color from Rgb.
  set bottomBorderColorRgb(Color value) {
    getCondition().bottomBorderColorRgb = value;
  }
}
